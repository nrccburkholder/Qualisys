using System;
using System.Data.SqlClient;
using System.Diagnostics;
using System.Linq;
using Nrc.CatalystExporter.DataContracts;
using Nrc.CatalystExporter.Logging;

namespace Nrc.CatalystExporter.DataAccess
{
    public class CatalystDatamartAccess
    {
        public ClientStudySurvey[] SearchClientName_ClientStudySurvey(string search, UserContext userContext)
        {
            Logger.Log("SearchClientName_ClientStudySurvey", TraceEventType.Verbose, userContext);
            using (var db = new CatalystDatamartContext())
            {
                var query = db.v_ClientStudySurvey.Where(c => c.ClientIsActive);
                if (!string.IsNullOrWhiteSpace(search))
                    query = query.Where(c => c.ClientName.ToLower().Contains(search.ToLower()));
                return query.ToArray();
            }
        }

        public ClientStudySurvey SearchClientId_ClientStudySurvey(long id, UserContext userContext)
        {
            string idAsString = id.ToString();

            Logger.Log("SearchClientId_ClientStudySurvey", TraceEventType.Verbose, userContext);
            using (var db = new CatalystDatamartContext())
            {
                var query = db.v_ClientStudySurvey.Where(c => c.ClientIsActive);
                query = query.Where(c => c.Client_ID.Equals(idAsString));
                return query.FirstOrDefault();
            }
        }

        public ClientStudySurvey FindBySurveyId_ClientStudySurvey(int id, UserContext userContext)
        {
            if (id <= 0) throw new ArgumentException("Invalid id", "id");

            Logger.Log(string.Format("ClientStudySurvey Find: {0}", id), TraceEventType.Verbose, userContext);
            using (var db = new CatalystDatamartContext())
            {
                return db.v_ClientStudySurvey.Where(c => c.SurveyID == id).FirstOrDefault(); ;
            }
        }

        public ClientStudySurvey[] FindManyBySurveyIds_ClientStudySurvey(int[] ids, UserContext userContext)
        {
            Logger.Log("ClientStudySurvey FindManyBySurveyIds", TraceEventType.Verbose, userContext);
            using (var db = new CatalystDatamartContext())
            {
                return db.v_ClientStudySurvey.Where(c => ids.Contains(c.SurveyID) && c.ClientIsActive).ToArray();
            }
        }

        public SamplePopulationBackgroundColumnAttribute[] FindManyByStudyId_SampPopBgColAttr(int[] studyIds, UserContext userContext)
        {
            Logger.Log("SamplePopulationBackgroundColumnAttribute FindManyByStudyId", TraceEventType.Verbose, userContext);
            using (var db = new CatalystDatamartContext())
            {
                db.SetCommandTimeout(600);
                return db.SamplePopulationBackgroundColumnAttribute.Where(c => studyIds.Contains(c.StudyID)).ToArray();
            }
        }

        public SamplePopulationBackgroundField[] FindManyBySampPopIds_SampPopBgField(int[] samplePopulationIds, string[] fields, UserContext userContext)
        {
            Logger.Log("SamplePopulationBackgroundField FindManyByStudyId", TraceEventType.Verbose, userContext);
            using (var db = new CatalystDatamartContext())
            {
                db.SetCommandTimeout(600);
                return db.SamplePopulationBackgroundField.Where(c => samplePopulationIds.Contains(c.SamplePopulationID) && fields.Contains(c.ColumnName)).ToArray();
            }
        }

        public ExportResult[] FindMany_ExportResult(int surveyId, int studyId, DateTime startDate, DateTime endDate, ExportDateType dateType, UserContext userContext)
        {
            Logger.Log("ExportResult Stored procedure", TraceEventType.Verbose, userContext);
            using (var db = new CatalystDatamartContext())
            {
                db.SetCommandTimeout(600);
                return db.Database.SqlQuery<ExportResult>("GetExportData @SurveyId, @StudyId, @StartDate, @EndDate, @DateType",
                    new SqlParameter("SurveyId", surveyId),
                    new SqlParameter("StudyId", studyId),
                    new SqlParameter("StartDate", startDate),
                    new SqlParameter("EndDate", endDate),
                    new SqlParameter("DateType", (int)dateType)).ToArray();
            }
        }

        public ClientStudySurvey[] FindStudiesByClientId(int cid, UserContext userContext)
        {
            Logger.Log("ClientStudySurvey FindStudiesByClientId", TraceEventType.Verbose, userContext);
            using (var db = new CatalystDatamartContext())
            {
                var query = db.v_ClientStudySurvey.Where(c => c.ClientIsActive);
                if (cid > 0)
                {
                    query = query.Where(c => c.ClientID == cid);
                    return query.ToArray();
                }
                else
                    return new ClientStudySurvey[0];
            }
        }

        public ClientStudySurvey FindStudyById(long id, UserContext userContext)
        {
            string idAsString = id.ToString();

            Logger.Log("ClientStudySurvey FindStudyById", TraceEventType.Verbose, userContext);
            using (var db = new CatalystDatamartContext())
            {
                var query = db.v_ClientStudySurvey.Where(c => c.ClientIsActive);

                query = query.Where(c => c.Study_ID == idAsString);
                return query.FirstOrDefault();
            }
        }

        public ClientStudySurvey FindSurveyById(long id, UserContext userContext)
        {
            string idAsString = id.ToString();

            Logger.Log("ClientStudySurvey FindStudyById", TraceEventType.Verbose, userContext);
            using (var db = new CatalystDatamartContext())
            {
                var query = db.v_ClientStudySurvey.Where(c => c.ClientIsActive);

                query = query.Where(c => c.Survey_ID == idAsString);
                return query.FirstOrDefault();
            }
        }

        public ClientStudySurvey[] FindSurveysByStudyId(int stid, UserContext userContext)
        {
            Logger.Log("ClientStudySurvey FindSurveysByStudyId", TraceEventType.Verbose, userContext);
            using (var db = new CatalystDatamartContext())
            {
                var query = db.v_ClientStudySurvey.Where(c => c.ClientIsActive);
                if (stid > 0)
                {
                    query = query.Where(c => c.StudyID == stid);
                    return query.ToArray();
                }
                else
                    return new ClientStudySurvey[0];
            }
        }
    }
}
