using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Data.SqlClient;
using Microsoft.Practices.EnterpriseLibrary.Data;
using DataAccess;
using System.Collections;
using System.Data.Common;
//TP using log4net;
using Logging;

namespace SurveyPointDAL
{
    /// <summary>
    /// Summary description for clsTriggers.
    /// </summary>
    public class clsTriggers
    {
        private SqlTransaction _transaction = null;
        private SqlConnection _connection = null;
        private bool bAutoCloseConn = false;
        private string _connectionString = DBConnections.GetConnectionString(clsConnection.MAIN_DB);
        private int _respondentID = -1;
        private int _scriptScreenID = -1;
        private int _userID = -1;
        public const string TABLE_NAME = "Triggers";
               
        private ILog _log = null;

        /// <summary>
        /// Trigger constructor
        /// </summary>
        public clsTriggers()
        {

        }

        /// <summary>
        /// Trigger constructor
        /// </summary>
        /// <param name="iRespondentID"></param>
        /// <param name="iUserID"></param>
        public clsTriggers(int iRespondentID, int iUserID)
        {
            _respondentID = iRespondentID;
            _userID = iUserID;
        }

        /// <summary>
        /// Trigger constructor
        /// </summary>
        /// <param name="iRespondentID"></param>
        /// <param name="iUserID"></param>
        /// <param name="iScriptScreenID"></param>
        public clsTriggers(int iRespondentID, int iUserID, int iScriptScreenID)
        {
            _respondentID = iRespondentID;
            _userID = iUserID;
            _scriptScreenID = iScriptScreenID;
        }

        /// <summary>
        /// Trigger deconstructor
        /// </summary>
        ~clsTriggers()
        {
            if (bAutoCloseConn && _connection != null && _connection.State == ConnectionState.Open)
            {
                _connection.Close();
                _connection.Dispose();
            }
        }

        /// <summary>
        /// Set or get the respondent id
        /// </summary>
        public int RespondentID
        {
            get { return _respondentID; }
            set { _respondentID = value; }
        }

        /// <summary>
        /// Set or get the script screen id
        /// </summary>
        public int ScriptScreenID
        {
            get { return _scriptScreenID; }
            set { _scriptScreenID = value; }
        }

        /// <summary>
        /// Set or get the user id
        /// </summary>
        public int UserID
        {
            get { return _userID; }
            set { _userID = value; }
        }

        /// <summary>
        /// Set or get database transaction
        /// </summary>
        public SqlTransaction DBTransaction
        {
            get { return _transaction; }
            set { _transaction = value; }
        }

        /// <summary>
        /// Set or get the database connection
        /// </summary>
        public SqlConnection DBConnection
        {
            get
            {
                if (_connection == null)
                {
                    _connection = new SqlConnection(_connectionString);
                    _connection.Open();
                    bAutoCloseConn = true;
                }
                return _connection;
            }
            set { _connection = value; }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="invocPt"></param>
        /// <returns></returns>
        public string RunTriggers(InvocationPoint invocPt)
        {
            dsSurveyPoint.TriggersDataTable triggers = GetTriggers(invocPt);
            StringBuilder sbResult = new StringBuilder();

            foreach (dsSurveyPoint.TriggersRow trigger in triggers)
            {
                sbResult.Append(RunTrigger(trigger));
            }

            return sbResult.ToString();
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="invocPt"></param>
        /// <returns></returns>
        public dsSurveyPoint.TriggersDataTable GetTriggers(InvocationPoint invocPt)
        {
            string sql = String.Format("SELECT * FROM vw_Triggers WHERE (InvocationPointID = {0})", Convert.ToInt32(invocPt));
            dsSurveyPoint ds = new dsSurveyPoint();

            // access database
            string conn = DBConnections.GetConnectionString(clsConnection.MAIN_DB);            
            //TP Change
            SqlHelper.Db(conn).LoadDataSet(CommandType.Text, sql, ds, new string[] { TABLE_NAME });
            //SqlHelper.FillDataset(conn, CommandType.Text, sql, ds, new string[] { TABLE_NAME });

            return ds.Triggers;
        }

        public static dsSurveyPoint.TriggersDataTable GetTriggers(int SurveyID, int TriggerTypeID, int InvocationPointID, string TriggerName, bool bRootTriggersOnly, bool bIncNonSurveyTriggers)
        {
            DBFilter filter = new DBFilter();
            if (SurveyID > 0 && !bIncNonSurveyTriggers)
                filter.AddSelectNumericFilter("SurveyID", SurveyID.ToString());
            else if (SurveyID > 0 && bIncNonSurveyTriggers)
                filter.AddCustomFilter(String.Format("(SurveyID = {0} OR SurveyID IS NULL)", SurveyID));
            else if (SurveyID == 0 && bIncNonSurveyTriggers)
                filter.AddCustomFilter("(SurveyID IS NULL)");
            if (TriggerTypeID > 0) filter.AddSelectNumericFilter("TriggerTypeID", TriggerTypeID.ToString());
            if (InvocationPointID > 0) filter.AddSelectNumericFilter("InvocationPointID", InvocationPointID.ToString());
            if (TriggerName != null) filter.AddSelectStringFilter("TriggerName", TriggerName + "%", true);
            if (bRootTriggersOnly) filter.AddCustomFilter("NOT EXISTS (SELECT 1 FROM TriggerDependencies td WHERE td.TriggerID = vw_Triggers.TriggerID)");

            string sql = String.Format("SELECT * FROM vw_Triggers {0}", filter.GenerateWhereClause());
            string conn = DBConnections.GetConnectionString(clsConnection.MAIN_DB);
            dsSurveyPoint ds = new dsSurveyPoint();

            // access database
            //TP Change
            SqlHelper.Db(conn).LoadDataSet(CommandType.Text, sql, ds, new string[] { TABLE_NAME });
            //SqlHelper.FillDataset(conn, CommandType.Text, sql, ds, new string[] { TABLE_NAME });

            return ds.Triggers;

        }

        /// <summary>
        /// Runs a trigger by first checking that the criteria is met, then executing the trigger code
        /// and any child triggers
        /// </summary>
        /// <param name="triggerID">id of the trigger to run</param>
        /// <returns>results of the trigger run</returns>
        public string RunTrigger(int triggerID)
        {
            dsSurveyPoint.TriggersRow trigger = null;
            trigger = GetTriggerRow(triggerID);
            return RunTrigger(trigger);
        }

        /// <summary>
        /// Runs a trigger by first checking that the criteria is met, then executing the trigger code
        /// and any child triggers
        /// </summary>
        /// <param name="trigger">trigger row</param>
        /// <returns>results of the trigger run</returns>
        public string RunTrigger(dsSurveyPoint.TriggersRow trigger)
        {
            string result = null;

            if (trigger != null && !trigger.IsCriteriaIDNull() && CheckCriteria(trigger.CriteriaID))
                result = ExecuteTrigger(trigger);
            else if (trigger != null && trigger.IsCriteriaIDNull())
                result = ExecuteTrigger(trigger);
            else
                result = "";

            return result;
        }

        /// <summary>
        /// Returns the typed data row of a trigger
        /// </summary>
        /// <param name="triggerID">id of the trigger to return</param>
        /// <returns>trigger row</returns>
        public dsSurveyPoint.TriggersRow GetTriggerRow(int triggerID)
        {
            // setup query
            dsSurveyPoint ds = new dsSurveyPoint();
            string sql = "SELECT * FROM vw_Triggers WHERE TriggerID = " + triggerID.ToString();

            // access database
            if (DBTransaction == null)
                //TP Change
                SqlHelper.Db(_connection.ConnectionString).LoadDataSet(CommandType.Text, sql, ds, new string[] { TABLE_NAME });
                //SqlHelper.FillDataset(_connection, CommandType.Text, sql, ds, new string[] { TABLE_NAME },
                  //  new SqlParameter[] { new SqlParameter("@TriggerID", triggerID) });
            else
                //TP Change
                SqlHelper.Db(_connection.ConnectionString).LoadDataSet(DBTransaction, sql, ds, new string[] { TABLE_NAME }, new SqlParameter[] { new SqlParameter("@TriggerID", triggerID) });
                //SqlHelper.FillDataset(DBTransaction, CommandType.Text, sql, ds, new string[] { TABLE_NAME },
                  //  new SqlParameter[] { new SqlParameter("@TriggerID", triggerID) });

            // return results
            if (ds.Triggers.Rows.Count > 0)
                return ds.Triggers.Rows[0] as dsSurveyPoint.TriggersRow;
            else
                return null;
        }

        /// <summary>
        /// Checks if respondent matches the criteria
        /// </summary>
        /// <param name="criteriaID">id of criteria to check</param>
        /// <returns>true, if respondent matches criteria</returns>
        public bool CheckCriteria(int criteriaID)
        {
            string sql = String.Format("SELECT dbo.DoesRespondentMatchCriteria({0},{1})", criteriaID, _respondentID);
            object result = null;

            if (DBTransaction == null)
                result = SqlHelper.Db(_connection.ConnectionString).ExecuteScalar(CommandType.Text, sql);
                //result = SqlHelper.ExecuteScalar(_connection, CommandType.Text, sql);
            else
                result = SqlHelper.Db(_connection.ConnectionString).ExecuteScalar(DBTransaction, CommandType.Text, sql);
                //result = SqlHelper.ExecuteScalar(DBTransaction, CommandType.Text, sql);

            return (result != null && result != DBNull.Value && Convert.ToInt32(result) == 1);
        }

        /// <summary>
        /// Executes the code in a trigger
        /// </summary>
        /// <param name="trigger">trigger to run</param>
        /// <returns>results of the code execution</returns>
        public string ExecuteTrigger(dsSurveyPoint.TriggersRow trigger)
        {
            StringBuilder sbTriggerCode = new StringBuilder();
            StringBuilder sbResult = new StringBuilder();
            dsSurveyPoint.TriggerTypesRow triggertype = GetTriggerTypeRow(trigger.TriggerTypeID);

            if (!triggertype.IsIntroCodeNull()) sbTriggerCode.AppendFormat(triggertype.IntroCode, RespondentID, ScriptScreenID, UserID);
            if (!trigger.IsTheCodeNull()) sbTriggerCode.AppendFormat(trigger.TheCode, RespondentID, ScriptScreenID, UserID);
            if (!triggertype.IsExitCodeNull()) sbTriggerCode.AppendFormat(triggertype.ExitCode, RespondentID, ScriptScreenID, UserID);

            try
            {
                sbResult.Append(RunTriggerCode(sbTriggerCode.ToString()));
                LogTrigger(trigger.TriggerID, true);
            }
            catch (Exception ex)
            {
                LogTrigger(trigger.TriggerID, false);
                throw ex;
            }

            sbResult.Append(RunChildTriggers(trigger.TriggerID));

            return sbResult.ToString();
        }

        /// <summary>
        /// Returns a trigger type row
        /// </summary>
        /// <param name="triggerTypeId">id of the trigger type to return</param>
        /// <returns>trigger type row</returns>
        public dsSurveyPoint.TriggerTypesRow GetTriggerTypeRow(int triggerTypeId)
        {
            // setup query
            dsSurveyPoint ds = new dsSurveyPoint();
            string sql = "SELECT * FROM TriggerTypes WHERE TriggerTypeID = @TriggerTypeID";

            // access database
            if (DBTransaction == null)
            {
                //TP Change
                DbCommand cmd = SqlHelper.Db(_connection.ConnectionString).GetSqlStringCommand(sql);
                cmd.Parameters.Add(new SqlParameter("@TriggerTypeID", triggerTypeId));
                SqlHelper.Db(_connection.ConnectionString).LoadDataSet(cmd, ds,
                    new string[] { "TriggerTypes" });                    
                //SqlHelper.FillDataset(_connection, CommandType.Text, sql, ds, new string[] { "TriggerTypes" },
                  //  new SqlParameter[] { new SqlParameter("@TriggerTypeID", triggerTypeId) });
            }
            else
            {
                //TP Change
                DbCommand cmd = SqlHelper.Db(_connection.ConnectionString).GetSqlStringCommand(sql);
                cmd.Parameters.Add(new SqlParameter("@TriggerTypeID", triggerTypeId));
                cmd.Transaction = DBTransaction;                 
                SqlHelper.Db(_connection.ConnectionString).LoadDataSet(cmd, ds,
                    new string[] { "TriggerTypes" });                    
                //SqlHelper.FillDataset(DBTransaction, CommandType.Text, sql, ds, new string[] { "TriggerTypes" },
                  //  new SqlParameter[] { new SqlParameter("@TriggerTypeID", triggerTypeId) });
            }

            // return results
            if (ds.TriggerTypes.Rows.Count > 0)
                return ds.TriggerTypes.Rows[0] as dsSurveyPoint.TriggerTypesRow;
            else
                return null;

        }

        /// <summary>
        /// Executes the trigger code against the database
        /// </summary>
        /// <param name="triggerCode">trigger code</param>
        /// <returns>results of the code execution</returns>
        public string RunTriggerCode(string triggerCode)
        {
            string returnVal = "";
            object result = null;

            if (triggerCode.Length > 0)
            {
                if (triggerCode.StartsWith("%"))
                    returnVal = triggerCode.Substring(1);
                else if (DBTransaction != null)
                {
                    //TP Change
                    result = SqlHelper.Db(DBConnection.ConnectionString).ExecuteScalar(DBTransaction, CommandType.Text, triggerCode);
                    //result = SqlHelper.ExecuteScalar(DBTransaction, CommandType.Text, triggerCode);
                    if (result != null && result != DBNull.Value) returnVal = result.ToString();
                }
                else
                {
                    result = SqlHelper.Db(DBConnection.ConnectionString).ExecuteScalar(CommandType.Text, triggerCode);
                    //result = SqlHelper.ExecuteScalar(DBConnection, CommandType.Text, triggerCode).ToString();
                    if (result != null && result != DBNull.Value) returnVal = result.ToString();
                }

            }

            if (returnVal.Length > 0) returnVal += " ";

            return returnVal;

        }

        /// <summary>
        /// logs success or failure of trigger for dependent triggers
        /// </summary>
        /// <param name="triggerID">trigger id</param>
        /// <param name="bSuccess">true, if success</param>
        public void LogTrigger(int triggerID, bool bSuccess)
        {
            Object scriptScreenIDParam;
            if (ScriptScreenID > -1)
                scriptScreenIDParam = ScriptScreenID;
            else
                scriptScreenIDParam = DBNull.Value;

            if (DBTransaction != null)
            {
                //TP Change                
                SqlHelper.Db(DBConnection.ConnectionString).ExecuteNonQuery(DBTransaction, "spLogTrigger",
                    new SqlParameter("@triggerID", triggerID),
                    new SqlParameter("@value1", RespondentID),
                    new SqlParameter("@value2", scriptScreenIDParam),
                    new SqlParameter("@value3", DBNull.Value),
                    new SqlParameter("@value4", DBNull.Value),
                    new SqlParameter("@successFlag", bSuccess ? 1 : 0),
                    new SqlParameter("@parameterText", ""));
                //SqlHelper.ExecuteNonQuery(DBTransaction, CommandType.StoredProcedure, "spLogTrigger",
                //    new SqlParameter("@triggerID", triggerID),
                //    new SqlParameter("@value1", RespondentID),
                //    new SqlParameter("@value2", scriptScreenIDParam),
                //    new SqlParameter("@value3", DBNull.Value),
                //    new SqlParameter("@value4", DBNull.Value),
                //    new SqlParameter("@successFlag", bSuccess ? 1 : 0),
                //    new SqlParameter("@parameterText", ""));
            }
            else
            {
                //TP Change
                SqlHelper.Db(DBConnection.ConnectionString).ExecuteNonQuery("spLogTrigger",
                    new SqlParameter("@triggerID", triggerID),
                    new SqlParameter("@value1", RespondentID),
                    new SqlParameter("@value2", scriptScreenIDParam),
                    new SqlParameter("@value3", DBNull.Value),
                    new SqlParameter("@value4", DBNull.Value),
                    new SqlParameter("@successFlag", bSuccess ? 1 : 0),
                    new SqlParameter("@parameterText", ""));
                //SqlHelper.ExecuteNonQuery(DBConnection, CommandType.StoredProcedure, "spLogTrigger",
                //    new SqlParameter("@triggerID", triggerID),
                //    new SqlParameter("@value1", RespondentID),
                //    new SqlParameter("@value2", scriptScreenIDParam),
                //    new SqlParameter("@value3", DBNull.Value),
                //    new SqlParameter("@value4", DBNull.Value),
                //    new SqlParameter("@successFlag", bSuccess ? 1 : 0),
                //    new SqlParameter("@parameterText", ""));
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="triggerID"></param>
        /// <returns></returns>
        public string RunChildTriggers(int triggerID)
        {
            StringBuilder sbResult = new StringBuilder();
            ArrayList children = GetChildTriggerList(triggerID);
            foreach (int childID in children)
            {
                sbResult.Append(RunTrigger(childID));
            }
            return sbResult.ToString();
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="triggerID"></param>
        /// <returns></returns>
        public ArrayList GetChildTriggerList(int triggerID)
        {
            ArrayList list = new ArrayList();
            SqlDataReader triggers = null;

            try
            {
                if (DBTransaction == null)
                {
                    //TP Change
                    triggers = (SqlDataReader)(SqlHelper.Db(DBConnection.ConnectionString).ExecuteReader("spGetListOfDependantTriggersToRun",
                        new SqlParameter("@triggerid", triggerID),
                        new SqlParameter("@value1", RespondentID),
                        new SqlParameter("@value2", ScriptScreenID > 0 ? ScriptScreenID : -7777),
                        new SqlParameter("@value3", -7777),
                        new SqlParameter("@value4", -7777)));
                    //triggers = SqlHelper.ExecuteReader(DBConnection, CommandType.StoredProcedure,
                    //    "spGetListOfDependantTriggersToRun",
                    //    new SqlParameter("@triggerid", triggerID),
                    //    new SqlParameter("@value1", RespondentID),
                    //    new SqlParameter("@value2", ScriptScreenID > 0 ? ScriptScreenID : -7777),
                    //    new SqlParameter("@value3", -7777),
                    //    new SqlParameter("@value4", -7777));
                }
                else
                {
                    //TP Change
                    triggers = (SqlDataReader)(SqlHelper.Db(DBConnection.ConnectionString).ExecuteReader(DBTransaction,
                        "spGetListOfDependantTriggersToRun",
                        new SqlParameter("@triggerid", triggerID),
                        new SqlParameter("@value1", RespondentID),
                        new SqlParameter("@value2", ScriptScreenID > 0 ? ScriptScreenID : -7777),
                        new SqlParameter("@value3", -7777),
                        new SqlParameter("@value4", -7777)));
                    //triggers = SqlHelper.ExecuteReader(DBTransaction, CommandType.StoredProcedure,
                    //    "spGetListOfDependantTriggersToRun",
                    //    new SqlParameter("@triggerid", triggerID),
                    //    new SqlParameter("@value1", RespondentID),
                    //    new SqlParameter("@value2", ScriptScreenID > 0 ? ScriptScreenID : -7777),
                    //    new SqlParameter("@value3", -7777),
                    //    new SqlParameter("@value4", -7777));
                }
                while (triggers.Read())
                {
                    list.Add(Convert.ToInt32(triggers["TriggerID"]));
                }
            }
            finally
            {
                if (triggers != null) triggers.Close();
            }

            return list;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="triggerID"></param>
        /// <returns></returns>
        public dsSurveyPoint.TriggersDataTable GetChildTriggers(int triggerID)
        {
            dsSurveyPoint ds = new dsSurveyPoint();
            string sql = String.Format("select t.* from vw_triggers t,triggerdependencies td where td.dependsontriggerid= {0} and td.triggerid = t.triggerid", triggerID);
            //TP Change
            SqlHelper.Db(DBConnection.ConnectionString).LoadDataSet(CommandType.Text, sql, ds, new string[] { TABLE_NAME });
            //SqlHelper.FillDataset(DBConnection, CommandType.Text, sql, ds, new string[] { TABLE_NAME });
            return ds.Triggers;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="triggerID"></param>
        /// <returns></returns>
        public dsSurveyPoint.TriggersDataTable GetParentTriggers(int triggerID)
        {
            dsSurveyPoint ds = new dsSurveyPoint();
            string sql = String.Format("select t.* from vw_triggers t,triggerdependencies td where td.triggerid= {0} and td.dependsontriggerid = t.triggerid", triggerID);
            //TP Change
            SqlHelper.Db(DBConnection.ConnectionString).LoadDataSet(CommandType.Text, sql, ds, new string[] { TABLE_NAME });
            //SqlHelper.FillDataset(DBConnection, CommandType.Text, sql, ds, new string[] { TABLE_NAME });
            return ds.Triggers;
        }

        public bool HasTriggerErrors()
        {
            string sql = String.Format("SELECT COUNT(*) FROM EventLog WHERE EventID = 2999 AND RespondentID = {0}", RespondentID);
            int result = 0;
            if (DBTransaction == null)
            {
                //TP Change
                result = Convert.ToInt32(SqlHelper.Db(DBConnection.ConnectionString).ExecuteScalar(CommandType.Text, sql));
                //result = Convert.ToInt32(SqlHelper.ExecuteScalar(DBConnection, CommandType.Text, sql));
            }
            else
            {
                //TP Change
                result = Convert.ToInt32(SqlHelper.Db(DBConnection.ConnectionString).ExecuteScalar(DBTransaction, CommandType.Text, sql));
                //result = Convert.ToInt32(SqlHelper.ExecuteScalar(DBTransaction, CommandType.Text, sql));
            }
            return (result > 0);
        }

        public string TriggerErrorMsg()
        {
            System.Data.SqlClient.SqlDataReader dr = null;
            StringBuilder sbResult = new StringBuilder();
            try
            {
                string sql = String.Format("SELECT EventParameters FROM EventLog WHERE EventID = 2999 AND RespondentID = {0}", RespondentID);

                if (DBTransaction == null)
                {
                    //TP Change
                    dr = (SqlDataReader)(SqlHelper.Db(DBConnection.ConnectionString).ExecuteReader(CommandType.Text, sql));
                    //dr = SqlHelper.ExecuteReader(DBConnection, CommandType.Text, sql);
                }
                else
                {
                    //TP Change
                    dr = (SqlDataReader)(SqlHelper.Db(DBConnection.ConnectionString).ExecuteReader(DBTransaction, CommandType.Text, sql));
                    //dr = SqlHelper.ExecuteReader(DBTransaction, CommandType.Text, sql);
                }
                while (dr.Read())
                {
                    sbResult.AppendFormat("{0}\n", dr[0]);
                }

            }
            finally
            {
                if (dr != null) dr.Close();
            }

            return sbResult.ToString();
        }

        public void removeRecursiveTriggers(int TriggerID, dsSurveyPoint.TriggersDataTable triggers)
        {
            dsSurveyPoint.TriggersRow trigger = triggers.FindByTriggerID(TriggerID);
            if (trigger != null)
            {
                trigger.Delete();
                trigger.AcceptChanges();
            }
            removeParentTriggers(TriggerID, triggers);
            removeChildTriggers(TriggerID, triggers);
        }

        public void removeParentTriggers(int TriggerID, dsSurveyPoint.TriggersDataTable triggers)
        {
            dsSurveyPoint.TriggersDataTable parents = GetParentTriggers(TriggerID);
            foreach (dsSurveyPoint.TriggersRow parent in parents)
            {
                removeParentTriggers(parent.TriggerID, triggers);
                dsSurveyPoint.TriggersRow trigger = triggers.FindByTriggerID(parent.TriggerID);
                if (trigger != null)
                {
                    trigger.Delete();
                    trigger.AcceptChanges();
                }
            }
        }

        public void removeChildTriggers(int TriggerID, dsSurveyPoint.TriggersDataTable triggers)
        {
            dsSurveyPoint.TriggersDataTable children = GetChildTriggers(TriggerID);
            foreach (dsSurveyPoint.TriggersRow child in children)
            {
                removeChildTriggers(child.TriggerID, triggers);
                dsSurveyPoint.TriggersRow trigger = triggers.FindByTriggerID(child.TriggerID);
                if (trigger != null)
                {
                    trigger.Delete();
                    trigger.AcceptChanges();
                }
            }
        }

        public void LogTriggerError()
        {
            // get import file name
            string sql = String.Format("SELECT PropertyValue FROM RespondentProperties WHERE (PropertyName = 'IMPORT_FILE_NAME') AND (RespondentID = {0})", RespondentID);
            //TP Change
            Object result = SqlHelper.Db(DBConnection.ConnectionString).ExecuteScalar(CommandType.Text, sql);
            //Object result = SqlHelper.ExecuteScalar(DBConnection, CommandType.Text, sql);
            string strImportFile = result != DBNull.Value ? result.ToString() : "NO IMPORT FILE NAME";

            // get import file line number
            sql = String.Format("SELECT PropertyValue FROM RespondentProperties WHERE (PropertyName = 'IMPORT_FILE_LINE_NUMBER') AND (RespondentID = {0})", RespondentID);
            //TP Change
            result =  SqlHelper.Db(DBConnection.ConnectionString).ExecuteScalar(CommandType.Text, sql);
            //result = SqlHelper.ExecuteScalar(DBConnection, CommandType.Text, sql);
            string strImportFileLine = result != DBNull.Value ? result.ToString() : "NO IMPORT FILE LINE NUMBER";

            // get error parameters
            sql = String.Format("SELECT EventParameters FROM EventLog WHERE (EventID = 2999) AND (RespondentID = {0})", RespondentID);
            //TP Change
            result = SqlHelper.Db(DBConnection.ConnectionString).ExecuteScalar(CommandType.Text, sql);
            //result = SqlHelper.ExecuteScalar(DBConnection, CommandType.Text, sql);
            string strErrorParams = result != DBNull.Value ? result.ToString() : "NO TRIGGER ERRORS";
            //TP Change
            Log.WarnFormat(String.Format("Problem with {0} at line {1}: {2}", strImportFile, strImportFileLine, strErrorParams));
            //Log.WarnFormat("Problem with {0} at line {1}: {2}", strImportFile, strImportFileLine, strErrorParams);
        }
        //TP Change
        public ILog Log
        {
            get
            {
                if (_log == null) _log = Logging.LogManager.GetLogger("SurveyPointDAL.clsTriggers");
                return _log;
            }
        }

        //public ILog Log
        //{
        //    get
        //    {
        //        if (_log == null) _log = log4net.LogManager.GetLogger("SurveyPointDAL.clsTriggers");
        //        return _log;
        //    }
        //}

        public static dsSurveyPoint.InvocationPointsDataTable GetInvocationPoints()
        {
            string conn = DBConnections.GetConnectionString(clsConnection.MAIN_DB);
            string sql = "SELECT * FROM InvocationPoints ORDER BY InvocationPointName";
            dsSurveyPoint ds = new dsSurveyPoint();

            // access database
            //TP Change
            SqlHelper.Db(conn).LoadDataSet(CommandType.Text, sql, ds, new string[] { "InvocationPoints" });
            //SqlHelper.FillDataset(conn, CommandType.Text, sql, ds, new string[] { "InvocationPoints" });

            return ds.InvocationPoints;

        }

        public static dsSurveyPoint.TriggerTypesDataTable GetTriggerTypes()
        {
            string conn = DBConnections.GetConnectionString(clsConnection.MAIN_DB);
            string sql = "SELECT * FROM TriggerTypes ORDER BY TriggerTypeName";
            dsSurveyPoint ds = new dsSurveyPoint();

            // access database
            //TP Change
            SqlHelper.Db(conn).LoadDataSet(CommandType.Text, sql, ds, new string[] { "TriggerTypes" });
            //SqlHelper.FillDataset(conn, CommandType.Text, sql, ds, new string[] { "TriggerTypes" });

            return ds.TriggerTypes;

        }

        public static void DeleteTrigger(int TriggerID)
        {
            string conn = DBConnections.GetConnectionString(clsConnection.MAIN_DB);
            SqlParameter[] param = new SqlParameter[1];
            param[0] = new SqlParameter("@TriggerID", TriggerID);
            string sql = "delete_Triggers";
            //TP Change
            SqlHelper.Db(conn).ExecuteNonQuery(sql, param);
            //SqlHelper.ExecuteNonQuery(conn, CommandType.StoredProcedure, sql, param);
        }

        public int InsertTrigger(dsSurveyPoint.TriggersRow trigger)
        {
            SqlParameter[] param = new SqlParameter[9];
            param[0] = new SqlParameter("@TriggerID", SqlDbType.Int);
            param[0].Direction = ParameterDirection.Output;
            param[1] = new SqlParameter("@TriggerTypeID", trigger.TriggerTypeID);
            param[2] = new SqlParameter("@SurveyID", SqlDbType.Int);
            if (!trigger.IsSurveyIDNull()) param[2].Value = trigger.SurveyID; else param[2].Value = DBNull.Value;
            param[3] = new SqlParameter("@TriggerName", SqlDbType.VarChar, 100);
            if (!trigger.IsTriggerNameNull()) param[3].Value = trigger.TriggerName; else param[3].Value = DBNull.Value;
            param[4] = new SqlParameter("@CriteriaID", SqlDbType.Int);
            if (!trigger.IsCriteriaIDNull()) param[4].Value = trigger.CriteriaID; else param[4].Value = DBNull.Value;
            param[5] = new SqlParameter("@TheCode", SqlDbType.VarChar, 8000);
            if (!trigger.IsTheCodeNull()) param[5].Value = trigger.TheCode; else param[5].Value = DBNull.Value;
            param[6] = new SqlParameter("@PerodicyDate", SqlDbType.DateTime);
            if (!trigger.IsPerodicyDateNull()) param[6].Value = trigger.PerodicyDate; else param[6].Value = DBNull.Value;
            param[7] = new SqlParameter("@PerodicyNextDate", SqlDbType.DateTime);
            if (!trigger.IsPerodicyNextDateNull()) param[7].Value = trigger.PerodicyNextDate; else param[7].Value = DBNull.Value;
            param[8] = new SqlParameter("@InvocationPointID", SqlDbType.Int);
            if (!trigger.IsInvocationPointIDNull()) param[8].Value = trigger.InvocationPointID; else param[8].Value = DBNull.Value;
            //TP Change
            SqlHelper.Db(DBConnection.ConnectionString).ExecuteNonQuery("insert_Triggers", param);
            //SqlHelper.ExecuteNonQuery(DBConnection, CommandType.StoredProcedure, "insert_Triggers", param);

            return Convert.ToInt32(param[0].Value);
        }

        public void UpdateTrigger(dsSurveyPoint.TriggersRow trigger)
        {
            SqlParameter[] param = new SqlParameter[9];
            param[0] = new SqlParameter("@TriggerID", trigger.TriggerID);
            param[1] = new SqlParameter("@TriggerTypeID", trigger.TriggerTypeID);
            param[2] = new SqlParameter("@SurveyID", SqlDbType.Int);
            if (!trigger.IsSurveyIDNull()) param[2].Value = trigger.SurveyID; else param[2].Value = DBNull.Value;
            param[3] = new SqlParameter("@TriggerName", SqlDbType.VarChar, 100);
            if (!trigger.IsTriggerNameNull()) param[3].Value = trigger.TriggerName; else param[3].Value = DBNull.Value;
            param[4] = new SqlParameter("@CriteriaID", SqlDbType.Int);
            if (!trigger.IsCriteriaIDNull()) param[4].Value = trigger.CriteriaID; else param[4].Value = DBNull.Value;
            param[5] = new SqlParameter("@TheCode", SqlDbType.VarChar, 8000);
            if (!trigger.IsTheCodeNull()) param[5].Value = trigger.TheCode; else param[5].Value = DBNull.Value;
            param[6] = new SqlParameter("@PerodicyDate", SqlDbType.DateTime);
            if (!trigger.IsPerodicyDateNull()) param[6].Value = trigger.PerodicyDate; else param[6].Value = DBNull.Value;
            param[7] = new SqlParameter("@PerodicyNextDate", SqlDbType.DateTime);
            if (!trigger.IsPerodicyNextDateNull()) param[7].Value = trigger.PerodicyNextDate; else param[7].Value = DBNull.Value;
            param[8] = new SqlParameter("@InvocationPointID", SqlDbType.Int);
            if (!trigger.IsInvocationPointIDNull()) param[8].Value = trigger.InvocationPointID; else param[8].Value = DBNull.Value;
            //TP Change
            SqlHelper.Db(DBConnection.ConnectionString).ExecuteNonQuery("update_Triggers", param);
            //SqlHelper.ExecuteNonQuery(DBConnection, CommandType.StoredProcedure, "update_Triggers", param);
        }

        public void MakeTriggerDependent(int iTriggerID, int iDependentOnID)
        {
            string sql = "INSERT INTO TriggerDependencies (TriggerID, DependsOnTriggerID) VALUES (@TriggerID, @DependsOnTriggerID)";
            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@TriggerID", iTriggerID);
            param[1] = new SqlParameter("@DependsOnTriggerID", iDependentOnID);
            //TP Change
            DbCommand cmd = SqlHelper.Db(DBConnection.ConnectionString).GetSqlStringCommand(sql);
            cmd.Parameters.AddRange(param);
            SqlHelper.Db(DBConnection.ConnectionString).ExecuteNonQuery(cmd);
            //SqlHelper.ExecuteNonQuery(DBConnection, CommandType.Text, sql, param);

        }

        public bool IsTriggerNameUnique(int iTriggerId, int iSurveyId, string sTriggerName)
        {
            DBFilter filter = new DBFilter();
            filter.AddSelectStringFilter("TriggerName", sTriggerName);
            if (iTriggerId > 0) filter.AddCustomFilter(String.Format("(TriggerID <> {0})", iTriggerId));
            if (iSurveyId > 0)
                filter.AddSelectNumericFilter("SurveyID", iSurveyId.ToString());
            else
                filter.AddCustomFilter("(SurveyID IS NULL)");
            string sql = String.Format("SELECT COUNT(TriggerID) FROM vw_Triggers {0}", filter.GenerateWhereClause());
            //TP Change
            int result = Convert.ToInt32(SqlHelper.Db(DBConnection.ConnectionString).ExecuteScalar(CommandType.Text, sql));
            //int result = Convert.ToInt32(SqlHelper.ExecuteScalar(DBConnection, CommandType.Text, sql));
            return result == 0;
        }

        public void Close()
        {
            if (_connection != null && _connection.State == ConnectionState.Open)
            {
                _connection.Close();
                _connection.Dispose();
            }
            _connection = null;
        }
    }

    public enum InvocationPoint
    {
        AFTER_IMPORT = 1,
        AFTER_IMPORT_UPDATE = 2,
        AFTER_IMPORT_UPDATE_SCORING = 3
    }
}
