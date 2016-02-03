using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Data.SqlClient;
using QMS;
using SurveyPointDAL;

namespace SurveyPointClasses
{
    /// <summary>
    /// Summary description for clsSurveyInterview.
    /// </summary>
    public class clsSurveyInterview
    {
        private bool bAutoCloseConn = false;

        public clsSurveyInterview(int iScriptID, int iUserID)
        {
            _Conn = DataAccess.DBConnections.GetSQLConnection(clsConnection.MAIN_DB);

            _Interview = new clsInterview(_Conn);
            _Interview.UserID = iUserID;
            _Interview.ScriptID = iScriptID;

            //fill with script data
            _Interview.Script.FillMain(iScriptID);
            _Interview.FillScriptScreens();
            _Interview.FillScriptScreenCategories();
            _Interview.FillScriptTriggers();

        }

        public clsSurveyInterview(int iScriptID, int iUserID, SqlConnection conn)
        {
            _Conn = conn;
            _Interview = new clsInterview(_Conn);
            _Interview.UserID = iUserID;
            _Interview.ScriptID = iScriptID;

            //fill with script data
            _Interview.Script.FillMain(iScriptID);
            _Interview.FillScriptScreens();
            _Interview.FillScriptScreenCategories();
            _Interview.FillScriptTriggers();

        }

        ~clsSurveyInterview()
        {

            _Interview = null;
            if (bAutoCloseConn && _Conn != null && _Conn.State.ToString() == "Open") _Conn.Close();
        }

        private SqlConnection _Conn;
        private SqlTransaction _Transaction = null;
        private clsInterview _Interview;

        public void Score(int iRespondentID)
        {

            //clear previous data
            _Interview.Responses.ClearMainTable();
            _Interview.Respondent.ClearMainTable();

            //get respondent data
            _Interview.RespondentID = iRespondentID;
            _Interview.Respondent.FillMain(iRespondentID);
            _Interview.FillResponses();

            //calculate score
            _Interview.StartInterview();
            _Interview.UpdateScreenStatus(0);
            _Interview.Score(false);
            _Interview.EndInterview();

        }

        public qmsInputMode InputMode
        {
            get
            {
                return _Interview.InputMode;
            }
            set
            {
                _Interview.InputMode = value;
            }
        }

        public SqlTransaction DBTransaction
        {
            get { return _Transaction; }
            set
            {
                _Transaction = value;
                _Interview.DBTransaction = value;
            }
        }

        public SqlConnection DBConnections
        {
            get { return _Conn; }
            set
            {
                if (_Conn != null)
                {
                    _Conn.Close();
                    _Conn.Dispose();
                }
                _Conn = value;
            }
        }
    }
}

