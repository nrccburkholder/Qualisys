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
    /// Summary description for clsRespondentDetails.
    /// </summary>
    public class clsRespondentDetails
    {
        private dsRespondentDetails _ds = new dsRespondentDetails();

        public clsRespondentDetails(int iRespondentId)
        {
            FillDataSet(iRespondentId);
        }

        private void FillDataSet(int iRespondentID)
        {
            //get respondent
            clsRespondent.FillTable(_ds, iRespondentID);
            dsRespondentDetails.RespondentsRow r = this.Respondent;
            if (r == null)
                throw new ApplicationException(String.Format("Respondent id {0} does not exist.", iRespondentID));
            else
            {
                //get respondent's survey instance data
                clsSurveyInstance.FillTable(_ds, r.SurveyInstanceID);
                dsRespondentDetails.SurveyInstancesRow si = this.SurveyInstance;
                if (si == null)
                    throw new ApplicationException(String.Format("Survey instance id {0} does not exist.", r.SurveyInstanceID));
                else
                {
                    //get respondent's client data
                    clsClient.FillTable(_ds, si.ClientID);
                    // get respondent's survey data
                    clsSurvey.FillTable(_ds, si.SurveyID);
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

        public dsRespondentDetails.RespondentsRow Respondent
        {
            get
            {
                if (_ds.Respondents.Rows.Count > 0)
                    return (dsRespondentDetails.RespondentsRow)_ds.Respondents.Rows[0];
                else
                    return null;
            }
        }

        public dsRespondentDetails.SurveyInstancesRow SurveyInstance
        {
            get
            {
                if (_ds.SurveyInstances.Rows.Count > 0)
                    return (dsRespondentDetails.SurveyInstancesRow)_ds.SurveyInstances.Rows[0];
                else
                    return null;
            }
        }

        public dsRespondentDetails.ClientsRow Client
        {
            get
            {
                if (_ds.Clients.Rows.Count > 0)
                    return (dsRespondentDetails.ClientsRow)_ds.Clients.Rows[0];
                else
                    return null;
            }
        }

        public dsRespondentDetails.SurveysRow Survey
        {
            get
            {
                if (_ds.Surveys.Rows.Count > 0)
                    return (dsRespondentDetails.SurveysRow)_ds.Surveys.Rows[0];
                else
                    return null;
            }
        }


        public dsRespondentDetails RespondentDetails
        {
            get { return _ds; }
        }
    }
}
