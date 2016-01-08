using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

using Generated = HHCAHPSImporter.ImportProcessor.DAL.Generated;
using HHCAHPSImporter.Web.UI.Models;
using NRC.Common.Configuration;

namespace HHCAHPSImporter.Web.UI.Controllers
{
    [HandleError()]
    public class ClientsController : ControllerBase
    {
        //
        // GET: /Clients/

        #region Clients
        public ActionResult Index()
        {
            return View(TransformRepository.GetRepository().GetClients());
        }

        public ActionResult Details(int clientId, int studyId, int surveyId)
        {
            return View(TransformRepository.GetRepository().GetClientDetailInfo(clientId,studyId,surveyId));
        }

        public ActionResult Edit(int clientId, int studyId, int surveyId)
        {
            return View(TransformRepository.GetRepository().GetClientEditInfo(clientId, studyId, surveyId));
        }

        [HttpPost]
        public ActionResult Edit(int clientId, int studyId, int surveyId, int currentTransformId, int selectedTransformId)
        {
            try
            {
                var db = TransformRepository.GetRepository();

                if (selectedTransformId.Equals(-1))
                {
                    db.DisassociateClientFromTransform(
                        clientId,
                        studyId,
                        surveyId,
                        currentTransformId);
                }
                else
                {
                    if (currentTransformId != -1 && currentTransformId != selectedTransformId)
                    {
                        db.DisassociateClientFromTransform(
                            clientId,
                            studyId,
                            surveyId,
                            currentTransformId);
                    }

                    if (selectedTransformId != -1)
                    {
                        db.AssociateClientWithTransform(
                                clientId,
                                studyId,
                                surveyId,
                                selectedTransformId);
                    }
                }

                return RedirectToAction("Index");
            }
            catch (Exception ex)
            {
                return this.Edit(clientId, studyId, surveyId);
            }
        }
        #endregion

        #region Client Transform Mappings
        public ActionResult TransformMappings(int clientId, int studyId, int surveyId, int transformId, int transformTargetId)
        {
            var v = TransformRepository.GetRepository().GetClientTransformMappingsInfo(clientId, studyId, surveyId, transformId, transformTargetId);

            return View(v);
        }

        public ActionResult TransformMappingDetails(int clientId, int studyId, int surveyId, int transformId, int transformTargetId, int transformMappingId)
        {
            var v = TransformRepository.GetRepository().GetClientTransformMappingsInfo(clientId, studyId, surveyId, transformId, transformTargetId);

            v.TransformMappings = v.TransformMappings.Where(t => t.TransformMappingId.Equals(transformMappingId)).ToList();

            return View(v);
        }

        public ActionResult EditTransformMapping(int clientId, int studyId, int surveyId, int transformId, int transformTargetId, int transformMappingId)
        {
            return TransformMappingDetails(clientId, studyId, surveyId, transformId, transformTargetId, transformMappingId);
        }

        [HttpPost]
        public ActionResult EditTransformMapping(int clientId, int studyId, int surveyId, int transformId, int transformTargetId, int transformMappingId, Models.ClientDetailInfo clientDetailInfo)
        {
            try
            {
                var db = TransformRepository.GetRepository();

                var v = db.GetTransformClientMapping(clientId, studyId, surveyId, transformId, transformTargetId, transformMappingId);

                if (string.IsNullOrEmpty(clientDetailInfo.TransformMappings[0].ClientSourceFieldName) &&
                    string.IsNullOrEmpty(clientDetailInfo.TransformMappings[0].ClientTransformCode))
                {
                    if (v != null)
                    {
                        db.DeleteTransformClientMapping(v);
                    }
                }
                else
                {
                    if (v != null)
                    {

                        v.SourceFieldName = clientDetailInfo.TransformMappings[0].ClientSourceFieldName;
                        v.Transform = clientDetailInfo.TransformMappings[0].ClientTransformCode;
                        db.UpdateTranformClientMapping(v);
                    }
                    else
                    {
                        var newClientTransformMapping = new Generated.TransformClientMapping
                            {
                                Client_id = clientId,
                                Study_id = studyId,
                                Survey_id = surveyId,
                                TransformMappingId = transformMappingId,
                                SourceFieldName = clientDetailInfo.TransformMappings[0].ClientSourceFieldName,
                                Transform = clientDetailInfo.TransformMappings[0].ClientTransformCode
                            };
                        db.CreateTranformClientMapping(newClientTransformMapping);
                    }
                }

                return RedirectToAction("TransformMappings", new { clientId = clientId, studyId = studyId, surveyId = surveyId, transformId = transformId, transformTargetId = transformTargetId });
            }
            catch (Exception ex)
            {
                return View(clientDetailInfo);
            }
        }

        public ActionResult DeleteTransformMapping(int clientId, int studyId, int surveyId, int transformId, int transformTargetId, int transformMappingId)
        {
            return TransformMappingDetails(clientId, studyId, surveyId, transformId, transformTargetId, transformMappingId);
        }

        [HttpPost]
        public ActionResult DeleteTransformMapping(int clientId, int studyId, int surveyId, int transformId, int transformTargetId, int transformMappingId, FormCollection collection)
        {
            try
            {
                var db = TransformRepository.GetRepository();

                var v = db.GetTransformClientMapping(clientId, studyId, surveyId, transformId, transformTargetId, transformMappingId);

                db.DeleteTransformClientMapping(v);

                return RedirectToAction("TransformMappings", new { clientId = clientId, studyId = studyId, surveyId = surveyId, transformId = transformId, transformTargetId = transformTargetId });
            }
            catch
            {
                return View();
            }
        }
        
        #endregion

        #region Data Files
        public ActionResult DataFiles(int clientId)
        {
            Settings settings = ConfigManager.Load<Settings>();

            Generated.QP_DataLoad qpDataLoad = new Generated.QP_DataLoad(settings.QP_DataLoadConnectionString);

            // UploadedFileLogView
            var uploadfiles = qpDataLoad.UploadedFileLogView
                .Where(t => t.DataFile_id.HasValue &&
                            t.DateUploadFileStateChange >= DateTime.Now.AddDays(-7).Date &&
                            t.Client_ID.Equals(clientId) )
                .OrderByDescending(t => t.DataFile_id)
                .Take(25);

            ViewData["clientName"] = qpDataLoad.ClientDetail.Where(t => t.Client_id.Equals(clientId)).First().ClientName;
            ViewData["clientId"] = clientId;

            return View(uploadfiles);
        }

        [HttpPost]
        public ActionResult DataFiles(int clientId, string startDate, string endDate, string take, bool abandonedFilesOnly)
        {
            DateTime _startDate = DateTime.Now.AddDays(-7);
            if (!DateTime.TryParse(startDate, out _startDate))
            {
                _startDate = DateTime.Now.AddDays(-7);
            }

            DateTime _endDate = DateTime.Now.AddDays(-7);
            if (!DateTime.TryParse(endDate, out _endDate))
            {
                _endDate = DateTime.Now.AddDays(-7);
            }

            int _take = 25;
            if (!int.TryParse(take, out _take))
            {
                _take = 25;
            }

            Settings settings = ConfigManager.Load<Settings>();

            Generated.QP_DataLoad qpDataLoad = new Generated.QP_DataLoad(settings.QP_DataLoadConnectionString);

            List<Generated.UploadedFileLogView> uploadfiles = null;
            if (abandonedFilesOnly)
            {
                // UploadedFileLogView
                uploadfiles = qpDataLoad.UploadedFileLogView
                    .Where(t => t.Client_ID.Equals(clientId) &&
                                t.DataFile_id.HasValue &&
                                t.DateUploadFileStateChange >= _startDate &&
                                t.DateUploadFileStateChange < _endDate.AddDays(1) &&
                                t.DataFileState_id.Equals(HHCAHPSImporter.ImportProcessor.DAL.DataFileState.Abandoned))
                    .OrderByDescending(t => t.DataFile_id)
                    .Take(_take)
                    .ToList();
            }
            else
            {
                // UploadedFileLogView
                uploadfiles = qpDataLoad.UploadedFileLogView
                    .Where(t => t.Client_ID.Equals(clientId) &&
                                t.DataFile_id.HasValue &&
                                t.DateUploadFileStateChange >= _startDate &&
                                t.DateUploadFileStateChange < _endDate.AddDays(1))
                    .OrderByDescending(t => t.DataFile_id)
                    .Take(_take)
                    .ToList();
            }

            ViewData["clientName"] = qpDataLoad.ClientDetail.Where(t => t.Client_id.Equals(clientId)).First().ClientName;
            ViewData["clientId"] = clientId;
            ViewData["startDate"] = _startDate.ToString("MM/dd/yyyy");
            ViewData["endDate"] = _endDate.ToString("MM/dd/yyyy");
            ViewData["take"] = _take;
            ViewData["abandonedFilesOnly"] = abandonedFilesOnly;

            return View(uploadfiles);
        }
        #endregion
    }
}
