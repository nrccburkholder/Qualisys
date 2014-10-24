using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;
using Nrc.CatalystExporter.DataAccess;
using Nrc.CatalystExporter.DataContracts;
using Nrc.CatalystExporter.ExportClient.Helpers;
using Nrc.CatalystExporter.ExportClient.Models;
using Nrc.CatalystExporter.Logging;
using System.Text;
using System.Configuration;
using System.IO;
using System.Messaging;
using System.Text.RegularExpressions;

namespace Nrc.CatalystExporter.ExportClient.Controllers
{
    public class HomeController : Controller
    {
        #region Accessors
        private ExportLogAccess _logAccess = new ExportLogAccess();
        private FileDefinitionAccess _fileAccess = new FileDefinitionAccess();
        private ColumnDefinitionAccess _columnAccess = new ColumnDefinitionAccess();
        private ScheduledExportAccess _scheduleAccess = new ScheduledExportAccess();
        private ChangeLogAccess _changeLogAccess = new ChangeLogAccess();
        private UserSettingsAccess _userSettingsAccess = new UserSettingsAccess();
        private CatalystDatamartAccess _catalystAccess = new CatalystDatamartAccess();
        #endregion

        public ActionResult AccessDenied()
        {
            return View();
        }

        #region Index
        public ActionResult Index()
        {
            var model = new IndexModel();

            if (TempData["FileLocations"] != null)
                model.FileLocations = new List<string>(TempData["FileLocations"] as string[]);

            if (TempData["ScheduledSavedCount"] != null)
                model.ScheduledSavedCount = TempData["ScheduledSavedCount"] as int?;

            return View(model);
        }

        public JsonResult FindLogs(ICollection<int> survIds, int page = 1, int rows = 20)
        {
            if (survIds == null)
                survIds = new List<int>();

            var logs = _logAccess.FindManyBySurveyIds(survIds.ToArray(), new UserContext(User.Identity.Name));
            var catalystData = _catalystAccess.FindManyBySurveyIds_ClientStudySurvey(survIds.ToArray(), new UserContext(User.Identity.Name));

            int rowsCount = logs.Count();

            var history = new
            {
                total = (rowsCount % rows) == 0 ? rowsCount / rows : rowsCount / rows + 1,
                page = page,
                records = rowsCount,
                rows = (
                    from log in logs
                    from cat in catalystData
                    where log.FileDefinitions.Select(fd => fd.SurveyId).Contains(cat.SurveyID)
                    select new
                    {
                        i = log.Id,
                        cell = new string[] { 
                            log.Id.ToString(),
                            cat.ClientName, 
                            cat.StudyName,
                            cat.SurveyName + (log.FileDefinitions.Count > 1 ? " *" : string.Empty),                             
                            log.Name, 
                            log.CreationDate.ToString("M/d/yyyy h:mm:ss tt"), 
                            log.FileCreationCompleteTime.HasValue ? log.FileCreationCompleteTime.Value.ToString("M/d/yyyy h:mm:ss tt") : "", 
                            log.StartDate.ToString("M/d/yyyy"), 
                            log.EndDate.ToString("M/d/yyyy"), 
                            ((ExportDateType)log.FileDefinitions.FirstOrDefault().ExportDateType).ToString().Replace("_", " ")
                            }
                    }).OrderBy(x => x.cell[3]).ThenByDescending(x => Convert.ToDateTime(x.cell[5])).Skip((page - 1) * rows).Take(rows).ToArray()
            };

            return Json(history);
        }

        [OutputCache(Duration = 600, VaryByParam = "*")]
        public JsonResult FindNav(string search, string id)
        {
            List<JsonNavNode> nodes = new List<JsonNavNode>();
            if (id == "0") //search or initial client load (search for "")
            {
                bool isNumericSearch = false;
                long numericSearch;
                List<ClientStudySurvey> v_css = new List<ClientStudySurvey>();

                if (long.TryParse(search, out numericSearch))
                {//Search by Id
                    isNumericSearch = true;
                    var searchResult = _catalystAccess.SearchClientId_ClientStudySurvey(numericSearch, new UserContext(User.Identity.Name));

                    if (searchResult != null)
                        v_css.Add(searchResult);
                }
                else
                {//Search by name
                    v_css = _catalystAccess.SearchClientName_ClientStudySurvey(search, new UserContext(User.Identity.Name)).ToList();
                }

                foreach (var c in v_css.OrderBy(v => v.ClientName).GroupBy(v => v.ClientID))
                {
                    //load clients
                    nodes.Add(new JsonNavNode()
                    {
                        data = c.First().ClientName + " (" + c.First().Client_ID + ")",
                        attr = new { id = "cl" + c.First().ClientID },
                        state = "closed"
                    });
                }

                if (isNumericSearch)
                {
                    //look for studies with that id
                    ClientStudySurvey studyNode = _catalystAccess.FindStudyById(numericSearch, new UserContext(User.Identity.Name));
                    if (studyNode != null)
                    {
                        ClientStudySurvey clientNode = _catalystAccess.SearchClientId_ClientStudySurvey(long.Parse(studyNode.Client_ID), new UserContext(User.Identity.Name));

                        nodes.Add(BuildSearchResultNode(clientNode, studyNode, null));
                    }

                    //look for survey with that id
                    ClientStudySurvey surveyNode = _catalystAccess.FindSurveyById(numericSearch, new UserContext(User.Identity.Name));
                    if (surveyNode != null)
                    {
                        ClientStudySurvey clientNode = _catalystAccess.SearchClientId_ClientStudySurvey(long.Parse(surveyNode.Client_ID), new UserContext(User.Identity.Name));
                        studyNode = _catalystAccess.FindStudyById(long.Parse(clientNode.Study_ID), new UserContext(User.Identity.Name));

                        nodes.Add(BuildSearchResultNode(clientNode, studyNode, surveyNode));
                    }

                }

            }
            else if (id.StartsWith("cl"))
            {
                //Find studies for this client
                int cid = 0;
                int.TryParse(id.Substring(2), out cid);
                var v_css = _catalystAccess.FindStudiesByClientId(cid, new UserContext(User.Identity.Name));

                foreach (var c in v_css.OrderBy(v => v.StudyName).GroupBy(v => v.StudyID))
                {
                    nodes.Add(new JsonNavNode()
                    {
                        data = c.First().StudyName + " (" + c.First().Study_ID + ")",
                        attr = new { id = "st" + c.First().StudyID },
                        state = "closed"
                    });
                }
            }
            else if (id.StartsWith("st"))
            {
                //Find surveys for this study
                int stid = 0;
                int.TryParse(id.Substring(2), out stid);
                var v_css = _catalystAccess.FindSurveysByStudyId(stid, new UserContext(User.Identity.Name));

                foreach (var c in v_css.OrderBy(v => v.SurveyName).GroupBy(v => v.SurveyID))
                {
                    nodes.Add(new JsonNavNode()
                    {
                        data = c.First().SurveyName + " (" + c.First().Survey_ID + ")",
                        attr = new { id = "s" + c.First().SurveyID }
                    });
                }
            }
            return Json(nodes.ToArray(), JsonRequestBehavior.AllowGet);
        }

        private JsonNavNode BuildSearchResultNode(ClientStudySurvey client, ClientStudySurvey study, ClientStudySurvey survey)
        {
            List<JsonNavNode> surveyNode = new List<JsonNavNode>();
            if (survey != null)
            {
                surveyNode.Add(new JsonNavNode()
                {
                    data = survey.SurveyName + " (" + survey.Survey_ID + ")",
                    attr = new { id = "s" + survey.SurveyID }
                });
            }

            List<JsonNavNode> studyNode = new List<JsonNavNode>();
            if (study != null)
            {
                studyNode.Add(new JsonNavNode()
                {
                    data = study.StudyName + " (" + study.Study_ID + ")",
                    attr = new { id = "st" + study.StudyID },
                    state = surveyNode.Count > 0 ? "open" : "closed",
                    children = surveyNode
                });
            }

            JsonNavNode clientNode = null;

            if (client != null)
            {
                clientNode = new JsonNavNode()
                    {
                        data = client.ClientName + " (" + client.Client_ID + ")",
                        attr = new { id = "cl" + client.ClientID },
                        state = studyNode.Count > 0 ? "open" : "closed",
                        children = studyNode
                    };
            }

            return clientNode;
        }


        [OutputCache(Duration = 600, VaryByParam = "logId")]
        public JsonResult FindFields(long logId)
        {
            Dictionary<int, string[]> fields = new Dictionary<int, string[]>();

            long fileDefId = _logAccess.Find(logId, new UserContext(User.Identity.Name)).FileDefinitions.FirstOrDefault().Id;

            var columnDefs = _columnAccess.FindManyByFileDefinitionId(fileDefId, new UserContext(User.Identity.Name)).OrderBy(c => c.ColumnOrder);
            int id = 0;
            foreach (var colDef in columnDefs)
            {
                fields.Add(id, new string[] {
                       colDef.ColumnOrder.ToString(), 
                        colDef.FieldName
                    });
                id++;
            }
            if (columnDefs.Count() == 0)
            {
                fields.Add(id, new string[] {
                       "There were no fields chosen for this export.", ""
                    });
            }

            var jsonData = new
            {
                rows = (from f in fields
                        select new
                        {
                            i = f.Key,
                            cell = f.Value
                        }).ToArray()
            };
            return Json(jsonData, JsonRequestBehavior.AllowGet);
        }
        #endregion

        #region Creation
        public ActionResult CreateNew(string survIds, bool scheduled)
        {
            var split = survIds.Split(',');
            int[] ids = new int[split.Length];
            for (int i = 0; i < split.Length; i++)
            {
                var good = int.TryParse(split[i], out ids[i]);
                if (!good)
                    return RedirectToAction("Index");
            }

            var defs = new List<NewDefinition>();
            var surveys = _catalystAccess.FindManyBySurveyIds_ClientStudySurvey(ids, new UserContext(User.Identity.Name));

            NewDefinition def = new NewDefinition();
            def.SetSurveys(surveys.Where(s => s.StudyID > 0).ToArray());
            def.Columns = new List<ColumnDefinition>();

            IOrderedEnumerable<string> questionFields;
            IOrderedEnumerable<string> commentFields;
            IOrderedEnumerable<string> demographicFields;
            FindFieldLists(surveys.Select(s => s.StudyID).Distinct().ToArray(), def.Columns, out questionFields, out commentFields, out demographicFields);
            def.QuestionFields = questionFields;
            def.CommentFields = commentFields;
            def.DemographicFields = demographicFields;

            defs.Add(def);

            var model = new CreateNewModel()
            {
                Definitions = defs,
                IsScheduled = scheduled,
                Intervals = EnumHelper.GetSelectList<IntervalType>(),
                FileTypes = EnumHelper.GetSelectList<FileType>(),
                DateTypes = EnumHelper.GetSelectList<ExportDateType>(),
                FileStructureTypes = EnumHelper.GetSelectList<FileStructureType>(),
                Schedule = new ScheduledExport()
                {
                    RunInterval = (int)IntervalType.Months,
                    RunIntervalCount = 1,
                    DataInterval = (int)IntervalType.Months,
                    DataIntervalCount = 1,
                    NextRunDate = DateTime.Today.AddDays(1),
                    DataStartDate = new DateTime(DateTime.Now.Year, 1, 1)
                }
            };
            return View(model);
        }

        [HttpPost]
        public ActionResult CreateNew(CreateNewModel model)
        {
            if (ModelState.IsValid)
            {
                var user = new UserContext(User.Identity.Name);
                List<string> fileLocations = new List<string>();
                var toSave = new List<ScheduledExport>();

                foreach (var def in model.Definitions)
                {
                    var catalystData = _catalystAccess.FindManyBySurveyIds_ClientStudySurvey(def.SurveyIds.ToArray(), user);
                    ExportLog newLog = new ExportLog();
                    ScheduledExport scheduled = new ScheduledExport();
                    string loc = string.Empty;

                    foreach (var surv in catalystData)
                    {
                        var fileDef = new FileDefinition()
                        {
                            Name = model.FileName,
                            FileType = (int)model.TypeOfFile,
                            Delimiter = model.Delimiter,
                            ClientId = surv.ClientID,
                            StudyId = surv.StudyID,
                            SurveyId = surv.SurveyID,
                            ExportDateType = (int)model.DateType,
                            FileStructureType = (int)model.FileStructure
                        };

                        //duplicate cols so they save as new objects instead of existing ones
                        if (def.Columns != null)
                        {
                            fileDef.Columns = new List<ColumnDefinition>();
                            foreach (ColumnDefinition c in def.Columns)
                            {
                                ColumnDefinition newCol = new ColumnDefinition()
                                {
                                    ColumnOrder = c.ColumnOrder,
                                    DisplayName = c.DisplayName,
                                    FieldName = c.FieldName,
                                };

                                if (c.Replacements != null)
                                {
                                    newCol.Replacements = new List<ColumnTextReplacement>();
                                    foreach (ColumnTextReplacement r in c.Replacements)
                                    {
                                        newCol.Replacements.Add(new ColumnTextReplacement()
                                        {
                                            NewText = r.NewText,
                                            OldText = r.OldText,
                                        });
                                    }
                                }

                                fileDef.Columns.Add(newCol);
                            }
                        }

                        if (!model.IsScheduled)
                        {
                            loc = GetFileLocation(surv, model.FileName, (FileType)model.TypeOfFile, model.IsCombined);

                            if (!model.IsCombined) newLog = new ExportLog();

                            newLog.CreatedBy = user.UserName;
                            newLog.CreationDate = DateTime.Now;
                            newLog.StartDate = model.StartDate.Value;
                            newLog.EndDate = model.EndDate.Value;
                            newLog.Name = model.FileName;
                            newLog.Location = loc;

                            if (newLog.FileDefinitions == null) newLog.FileDefinitions = new List<FileDefinition>();

                            newLog.FileDefinitions.Add(fileDef);

                            if (!model.IsCombined)
                            {
                                _logAccess.Save(newLog, user);
                                AddToQueue(newLog.Id);
                                Logger.Log(string.Format("New Export Log Queued \r\n{0}", newLog.ExportLogToString()), System.Diagnostics.TraceEventType.Information, user);
                                fileLocations.Add(loc);
                            }
                        }
                        else
                        {
                            if (!model.IsCombined) scheduled = new ScheduledExport();

                            scheduled.RunInterval = model.Schedule.RunInterval;
                            scheduled.RunIntervalCount = model.Schedule.RunIntervalCount;
                            scheduled.DataInterval = model.Schedule.DataInterval;
                            scheduled.DataIntervalCount = model.Schedule.DataIntervalCount;
                            scheduled.NextRunDate = model.Schedule.NextRunDate;
                            scheduled.DataStartDate = model.Schedule.DataStartDate;
                            scheduled.IsRolling = model.Schedule.IsRolling;
                            scheduled.IsActive = true;

                            if (scheduled.FileDefinitions == null) scheduled.FileDefinitions = new List<FileDefinition>();

                            scheduled.FileDefinitions.Add(fileDef);

                            if (!model.IsCombined) toSave.Add(scheduled);
                        }
                    }

                    if (model.IsCombined && !model.IsScheduled)
                    {
                        _logAccess.Save(newLog, user);
                        AddToQueue(newLog.Id);
                        Logger.Log(string.Format("New Export Log Queued \r\n{0}", newLog.ExportLogToString()), System.Diagnostics.TraceEventType.Information, user);
                        fileLocations.Add(loc);
                    }

                    if (model.IsCombined && model.IsScheduled)
                    {
                        toSave.Add(scheduled);
                    }
                }

                if (!model.IsScheduled)
                {
                    TempData["FileLocations"] = fileLocations.ToArray();
                    return RedirectToAction("Index");
                }
                else
                {                 
                    _scheduleAccess.SaveMany(toSave.ToArray(), user);

                    foreach (ScheduledExport export in toSave)
                    {
                        Logger.Log(string.Format("New Scheduled Export Created \r\n{0}", export.ScheduledExportToString()), System.Diagnostics.TraceEventType.Information, user);
                    }

                    TempData["ScheduledSavedCount"] = toSave.Count;
                    return RedirectToAction("Index");
                }
            }

            foreach (var def in model.Definitions)
            {
                var surveys = _catalystAccess.FindManyBySurveyIds_ClientStudySurvey(def.SurveyIds.ToArray(), new UserContext(User.Identity.Name));
                def.SetSurveys(surveys.ToArray());

                IOrderedEnumerable<string> questionFields;
                IOrderedEnumerable<string> commentFields;
                IOrderedEnumerable<string> demographicFields;
                FindFieldLists(surveys.Select(s => s.StudyID).Distinct().ToArray(), def.Columns, out questionFields, out commentFields, out demographicFields);
                def.QuestionFields = questionFields;
                def.CommentFields = commentFields;
                def.DemographicFields = demographicFields;
            }
            model.Intervals = EnumHelper.GetSelectList<IntervalType>();
            model.FileTypes = EnumHelper.GetSelectList<FileType>();
            model.DateTypes = EnumHelper.GetSelectList<ExportDateType>();
            model.FileStructureTypes = EnumHelper.GetSelectList<FileStructureType>();
            return View(model);
        }
        public ActionResult CreateFromExisting(string fileName, string startDate, string endDate, string logIds)
        {
            DateTime sDate, eDate;
            var sGood = DateTime.TryParse(startDate, out sDate);
            var eGood = DateTime.TryParse(endDate, out eDate);
            if (!(sGood && eGood))
                return RedirectToAction("Index");

            var split = logIds.Split(',');
            long[] ids = new long[split.Length];
            for (int i = 0; i < split.Length; i++)
            {
                var good = long.TryParse(split[i], out ids[i]);
                if (!good)
                    return RedirectToAction("Index");
            }

            var user = new UserContext(User.Identity.Name);
            var existingLogs = _logAccess.FindMany_IncludeColumns(ids, user);
            var files = new List<string>();

            foreach (var old in existingLogs)
            {
                var surv = _catalystAccess.FindBySurveyId_ClientStudySurvey(old.FileDefinitions.FirstOrDefault().SurveyId, user);
                var loc = GetFileLocation(surv, fileName, (FileType)old.FileDefinitions.FirstOrDefault().FileType, old.FileDefinitions.Count > 1);

                var newLog = new ExportLog()
                {
                    CreatedBy = user.UserName,
                    CreationDate = DateTime.Now,
                    Name = fileName,
                    StartDate = sDate,
                    EndDate = eDate,
                    Location = loc,
                    FileDefinitions = old.FileDefinitions
                };

                foreach (FileDefinition fdef in newLog.FileDefinitions)
                {
                    fdef.ExportLogs.Add(newLog);
                }

                _logAccess.Save(newLog, user);

                AddToQueue(newLog.Id);
                Logger.Log(string.Format("New Export Log Queued \r\n{0}", newLog.ExportLogToString()), System.Diagnostics.TraceEventType.Information, user);

                files.Add(loc);
            }

            TempData["FileLocations"] = files.ToArray();
            return RedirectToAction("Index");
        }

        private string GetFileLocation(ClientStudySurvey survey, string fileName, FileType type, bool multipleStudies)
        {
            string regexSearch = new string(Path.GetInvalidFileNameChars()) + new string(Path.GetInvalidPathChars());
            System.Text.RegularExpressions.Regex r = new System.Text.RegularExpressions.Regex(string.Format("[{0}]", System.Text.RegularExpressions.Regex.Escape(regexSearch)));

            StringBuilder sb = new StringBuilder();

            var usersetting = _userSettingsAccess.Find(User.Identity.Name, new UserContext(User.Identity.Name));
            if (usersetting != null && !string.IsNullOrWhiteSpace(usersetting.NetworkLocation))
                sb.Append(usersetting.NetworkLocation);
            else
                sb.Append(ConfigurationManager.AppSettings[User.Identity.Name]
                     ?? ConfigurationManager.AppSettings["DefaultLocation"]);//User folder

            if (!sb.ToString().EndsWith("\\"))
                sb.Append("\\");

            sb.Append(r.Replace(survey.ClientName, ""));//Client folder
            sb.Append("\\");
            if (!multipleStudies)
            {
                sb.Append(r.Replace(survey.StudyName, ""));//Study Folder
                sb.Append("\\");
            }
            sb.Append(r.Replace(fileName, ""));
            sb.Append("-");
            if (!multipleStudies)
            {
                sb.Append(r.Replace(survey.SurveyName, ""));
                sb.Append("-");
            }
            sb.Append(DateTime.Now.ToString("yyyyMMddhhmmss"));
            sb.Append(".");
            if (type != FileType.Other_Delimiter)
                sb.Append(type.ToString().ToLower());
            else
                sb.Append("txt");

            return sb.Replace(' ', '_').ToString();

        }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2208:InstantiateArgumentExceptionsCorrectly")]
        private void AddToQueue(long exportLogId)
        {
            try
            {
                string queueName = System.Configuration.ConfigurationManager.AppSettings["Queue"];

                if (string.IsNullOrEmpty(queueName))
                    throw new ArgumentNullException("Queue");

                if (MessageQueue.Exists(queueName))
                {
                    using (MessageQueue queue = new MessageQueue(queueName))
                    {
                        queue.Formatter = new System.Messaging.XmlMessageFormatter(new Type[1] { typeof(long) });
                        using (Message m = new Message(exportLogId))
                        {
                            queue.Send(m);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                Logger.Log(ex, new UserContext(User.Identity.Name));
            }
        }
        #endregion

        #region Edit Scheduled
        public ActionResult ScheduledDefinitions()
        {
            var message = TempData["Message"] ?? "";
            return View(message);
        }

        public JsonResult FindScheduled(int page = 1, int rows = 20)
        {
            var schedules = _scheduleAccess.FindAllActive(new UserContext(User.Identity.Name));
            var catalystData = _catalystAccess.FindManyBySurveyIds_ClientStudySurvey(schedules.Select(s => s.FileDefinitions.FirstOrDefault().SurveyId).ToArray(), new UserContext(User.Identity.Name));

            int rowsCount = schedules.Count();

            var table = new
            {
                total = (rowsCount % rows) == 0 ? rowsCount / rows : rowsCount / rows + 1,
                page = page,
                records = rowsCount,
                rows = (from sched in schedules
                        from cat in catalystData
                        where sched.FileDefinitions.Select(fd => fd.SurveyId).Contains(cat.SurveyID)
                        select new
                        {
                            i = sched.Id,
                            cell = new string[] { 
                                "",
                                sched.Id.ToString(),
                                cat.ClientName + " (" + cat.Client_ID + ")", 
                                cat.StudyName + " (" + cat.Study_ID + ")",
                                cat.SurveyName + " (" + cat.Survey_ID + ")", 
                                sched.FileDefinitions.FirstOrDefault().Name, 
                                sched.NextRunDate.ToString("M/d/yyyy"),
                                sched.RunIntervalCount + " " + ((IntervalType)sched.RunInterval).ToString().TrimEnd(( sched.RunIntervalCount <= 1 ? 's' : new char() ) ), 
                                sched.DataIntervalCount + " " + ((IntervalType)sched.DataInterval).ToString().TrimEnd(( sched.DataIntervalCount <= 1 ? 's': new char() ) ), 
                                sched.DataStartDate.ToString("M/d/yyyy"),
                                sched.IsRolling.ToString(),
                                sched.CreatedBy,
                                sched.CreationDate.ToString("M/d/yyyy")                                
                            }
                        }).OrderBy(x => x.cell[1]).ThenByDescending(x => x.cell[2]).ThenByDescending(x => x.cell[3]).Skip((page - 1) * rows).Take(rows).ToArray()
            };

            return Json(table);
        }

        public JsonResult DisableScheduled(long id)
        {
            var user = new UserContext(User.Identity.Name);
            var sched = _scheduleAccess.Find(id, user);
            sched.IsActive = false;
            _scheduleAccess.Save(sched, user);
            var log = new ChangeLog()
            {
                ScheduledExportId = id,
                Description = "Disabled"
            };
            _changeLogAccess.Save(log, user);
            return Json(true, JsonRequestBehavior.AllowGet);
        }

        public ActionResult EditScheduled(long id)
        {
            var user = new UserContext(User.Identity.Name);
            var schedule = _scheduleAccess.Find_IncludeColumns(id, user);

            IOrderedEnumerable<string> questionFields;
            IOrderedEnumerable<string> commentFields;
            IOrderedEnumerable<string> demographicFields;
            FindFieldLists(schedule.FileDefinitions.Select(s => s.StudyId).Distinct().ToArray(), schedule.FileDefinitions.FirstOrDefault().Columns, out questionFields, out commentFields, out demographicFields);

            var model = new EditScheduleModel()
            {
                Schedule = schedule,
                Survey = _catalystAccess.FindBySurveyId_ClientStudySurvey(schedule.FileDefinitions.FirstOrDefault().SurveyId, user),
                QuestionFields = questionFields,
                CommentFields = commentFields,
                DemographicFields = demographicFields,
                Intervals = EnumHelper.GetSelectList<IntervalType>(),
                FileTypes = EnumHelper.GetSelectList<FileType>(),
                DateTypes = EnumHelper.GetSelectList<ExportDateType>(),
                FileStructureTypes = EnumHelper.GetSelectList<FileStructureType>()
            };
            return View(model);
        }

        [HttpPost]
        public ActionResult EditScheduled(EditScheduleModel model)
        {
            var user = new UserContext(User.Identity.Name);
            var scheduled = _scheduleAccess.Find_IncludeColumns(model.Schedule.Id, user);
            if (ModelState.IsValid)
            {
                //var oldFileDef = scheduled.FileDefinition;

                List<FileDefinition> fileDefinition = new List<FileDefinition>();

                foreach (FileDefinition fdef in scheduled.FileDefinitions)
                {
                    fileDefinition.Add(new FileDefinition()
                    {
                        Name = model.Schedule.FileDefinitions.FirstOrDefault().Name,
                        FileType = (int)model.Schedule.FileDefinitions.FirstOrDefault().FileType,
                        Delimiter = model.Schedule.FileDefinitions.FirstOrDefault().Delimiter,
                        ClientId = fdef.ClientId,
                        StudyId = fdef.StudyId,
                        SurveyId = fdef.SurveyId,
                        ExportDateType = (int)model.Schedule.FileDefinitions.FirstOrDefault().ExportDateType,
                        FileStructureType = (int)model.Schedule.FileDefinitions.FirstOrDefault().FileStructureType,
                        Columns = model.Schedule.FileDefinitions.FirstOrDefault().Columns
                    });
                }

                _scheduleAccess.RemoveFileDefinitions(scheduled);

                scheduled.FileDefinitions.AddRange(fileDefinition);

                scheduled.RunInterval = model.Schedule.RunInterval;
                scheduled.RunIntervalCount = model.Schedule.RunIntervalCount;
                scheduled.DataInterval = model.Schedule.DataInterval;
                scheduled.DataIntervalCount = model.Schedule.DataIntervalCount;
                scheduled.NextRunDate = model.Schedule.NextRunDate;
                scheduled.IsActive = true;
                scheduled.DataStartDate = model.Schedule.DataStartDate;
                scheduled.IsRolling = model.Schedule.IsRolling;

                _scheduleAccess.Save(scheduled, user);

                Logger.Log(string.Format("Scheduled Export Edited \r\n{0}", scheduled.ScheduledExportToString()), System.Diagnostics.TraceEventType.Information, user);

                TempData["Message"] = "Definition successfully saved.";
                return RedirectToAction("ScheduledDefinitions");
            }

            IOrderedEnumerable<string> questionFields;
            IOrderedEnumerable<string> commentFields;
            IOrderedEnumerable<string> demographicFields;
            FindFieldLists(scheduled.FileDefinitions.Select(f => f.StudyId).Distinct().ToArray(), scheduled.FileDefinitions.FirstOrDefault().Columns, out questionFields, out commentFields, out demographicFields);

            model.DemographicFields = demographicFields;
            model.QuestionFields = questionFields;
            model.CommentFields = commentFields;
            model.Intervals = EnumHelper.GetSelectList<IntervalType>();
            model.FileTypes = EnumHelper.GetSelectList<FileType>();
            model.DateTypes = EnumHelper.GetSelectList<ExportDateType>();
            model.FileStructureTypes = EnumHelper.GetSelectList<FileStructureType>();
            return View(model);
        }
        #endregion

        private void FindFieldLists(int[] studyIds, IEnumerable<ColumnDefinition> columns, out IOrderedEnumerable<string> questionFields, out IOrderedEnumerable<string> commentFields, out IOrderedEnumerable<string> demographicFields)
        {
            questionFields = ExportResult.QuestionDataPropertyNames().Except(columns.Select(f => f.FieldName)).OrderBy(f => f);
            commentFields = ExportResult.CommentDataPropertyNames().Except(columns.Select(f => f.FieldName)).OrderBy(f => f);

            demographicFields = typeof(ExportResult).GetProperties().Select(f => f.Name).Except(questionFields).Except(commentFields).OrderBy(f => f);
            demographicFields = demographicFields.Concat(_catalystAccess.FindManyByStudyId_SampPopBgColAttr(studyIds, new UserContext(User.Identity.Name)).Distinct().Select(s => s.ColumnName)).OrderBy(f => f);
            demographicFields = demographicFields.Except(columns.Select(f => f.FieldName)).OrderBy(f => f);
        }

        #region UserSettings
        public ActionResult Settings()
        {
            var username = User.Identity.Name;
            var model = _userSettingsAccess.Find(username, new UserContext(username));
            if (model == null)
            {
                model = new UserSetting()
                {
                    Username = username,
                    NetworkLocation = ConfigurationManager.AppSettings[User.Identity.Name] ?? ConfigurationManager.AppSettings["DefaultLocation"]
                };
            }

            return View(model);
        }

        [HttpPost]
        public ActionResult Settings(UserSetting model)
        {
            if (ModelState.IsValid)
            {
                _userSettingsAccess.Save(model, new UserContext(User.Identity.Name));
                return RedirectToAction("Index");
            }
            return View(model);
        }

        //[OutputCache(Duration = 3600, VaryByParam = "directory")]
        public JsonResult FindSubdirectories(string directory)
        {
            List<JsonNavNode> subdirs = new List<JsonNavNode>();
            var dir = new DirectoryInfo(directory.Replace("%20", " ") + "\\");
            if (dir != null)
            {
                foreach (var d in dir.GetDirectories())
                {
                    try
                    {
                        d.GetDirectories();
                        subdirs.Add(new JsonNavNode() { data = d.Name, attr = new { id = d.FullName }, state = "closed" });
                    }
                    catch (UnauthorizedAccessException) { }
                    catch (IOException) { }
                }
            }

            return Json(subdirs.ToArray(), JsonRequestBehavior.AllowGet);
        }

        #endregion
    }

    public class JsonNavNode
    {
        public string data { get; set; }
        public IEnumerable<JsonNavNode> children { get; set; }
        public object attr { get; set; }
        public string state { get; set; }
    }
}
