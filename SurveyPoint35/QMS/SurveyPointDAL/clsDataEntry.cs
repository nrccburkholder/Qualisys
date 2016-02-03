using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Data.SqlClient;
using DataAccess;

namespace SurveyPointDAL
{
    /// <summary>
    /// Summary description for clsDataEntry.
    /// </summary>
    public class clsDataEntry
    {
        private dsDataEntry _ds = new dsDataEntry();

        public clsDataEntry(int iRespondentID, int iScriptID)
        {
            FillDataSet(iRespondentID, iScriptID);
        }

        private void FillDataSet(int iRespondentID, int iScriptID)
        {
            //get respondent
            clsRespondent.FillTable(_ds, iRespondentID);
            dsDataEntry.RespondentsRow r = this.Respondent;
            if (r == null)
                throw new ApplicationException(String.Format("Respondent id {0} does not exist.", iRespondentID));
            else
            {
                //get respondent's survey instance data
                clsSurveyInstance.FillTable(_ds, r.SurveyInstanceID);
                dsDataEntry.SurveyInstancesRow si = this.SurveyInstance;
                if (si == null)
                    throw new ApplicationException(String.Format("Survey instance id {0} does not exist.", r.SurveyInstanceID));
                else
                {
                    //get respondent's client data
                    clsClient.FillTable(_ds, si.ClientID);
                    // get respondent's survey data
                    clsSurvey.FillTable(_ds, si.SurveyID);
                }

                //get respondent's properties
                clsRespondentProperty.FillTable(_ds, iRespondentID);
                //get respondent's responses
                clsResponse.FillTable(_ds, iRespondentID);
                //get respondent's event log
                clsEventLog.FillTable(_ds, iRespondentID);

                //get script
                clsScript.FillTable(_ds, iScriptID);
                dsDataEntry.ScriptsRow scr = this.Script;
                if (scr == null)
                    throw new ApplicationException(String.Format("Script id {0} does not exist.", iScriptID));
                else
                {
                    //get script screens
                    clsScriptScreen.FillTable(_ds, iScriptID);
                    //get script screen categories
                    clsScriptScreenCategory.FillTable(_ds, iScriptID);
                }
            }
        }

        public void CommitDataSet()
        {
            SqlConnection conn = new SqlConnection(DBConnections.GetConnectionString(clsConnection.MAIN_DB));
            try
            {
                conn.Open();
                clsRespondent.CommitTable(conn, _ds);
                clsRespondentProperty.CommitTable(conn, _ds);
                clsResponse.CommitTable(conn, _ds);
                clsEventLog.CommitTable(conn, _ds);
            }
            finally
            {
                if (conn.State != ConnectionState.Closed) conn.Close();
                conn.Dispose();
            }
        }

        public dsDataEntry.RespondentsRow Respondent
        {
            get
            {
                if (_ds.Respondents.Rows.Count > 0)
                    return (dsDataEntry.RespondentsRow)_ds.Respondents.Rows[0];
                else
                    return null;
            }
        }

        public dsDataEntry.SurveyInstancesRow SurveyInstance
        {
            get
            {
                if (_ds.SurveyInstances.Rows.Count > 0)
                    return (dsDataEntry.SurveyInstancesRow)_ds.SurveyInstances.Rows[0];
                else
                    return null;
            }
        }

        public dsDataEntry.ClientsRow Client
        {
            get
            {
                if (_ds.Clients.Rows.Count > 0)
                    return (dsDataEntry.ClientsRow)_ds.Clients.Rows[0];
                else
                    return null;
            }
        }

        public dsDataEntry.SurveysRow Survey
        {
            get
            {
                if (_ds.Surveys.Rows.Count > 0)
                    return (dsDataEntry.SurveysRow)_ds.Surveys.Rows[0];
                else
                    return null;
            }
        }

        public dsDataEntry.ScriptsRow Script
        {
            get
            {
                if (_ds.Scripts.Rows.Count > 0)
                    return (dsDataEntry.ScriptsRow)_ds.Scripts.Rows[0];
                else
                    return null;
            }
        }

        public dsDataEntry DataEntry
        {
            get { return _ds; }
        }
    }
}
