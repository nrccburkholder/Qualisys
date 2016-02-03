using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;
using SurveyPointDAL;
using DataAccess;

namespace SurveyPointClasses
{
    /// <summary>
    /// Summary description for clsWebTools.
    /// </summary>
    public class clsWebTools
    {
        public static void fillSurveyDDL(ListControl listCtrl)
        {
            fillSurveyDDL(listCtrl, "Select Survey");
        }

        public static void fillSurveyDDL(ListControl listCtrl, string selectText)
        {
            dsSurveyPoint.SurveysDataTable dt = clsSurvey.getActiveSurveys();
            listCtrl.DataSource = dt;
            listCtrl.DataTextField = "Name";
            listCtrl.DataValueField = "SurveyID";
            listCtrl.DataBind();
            listCtrl.Items.Insert(0, new ListItem(selectText, ""));
        }

        public static void fillClientDDLBySurvey(ListControl listCtrl, int iSurveyID)
        {
            fillClientDDLBySurvey(listCtrl, iSurveyID, "Select Client");
        }

        public static void fillClientDDLBySurvey(ListControl listCtrl, int iSurveyID, string selectText)
        {
            dsSurveyPoint.ClientsDataTable dt = clsClient.getClientsBySurvey(iSurveyID);
            listCtrl.DataSource = dt;
            listCtrl.DataTextField = "Name";
            listCtrl.DataValueField = "ClientID";
            listCtrl.DataBind();
            listCtrl.Items.Insert(0, new ListItem(selectText, ""));
        }

        public static void fillClientDDL(ListControl listCtrl)
        {
            fillClientDDL(listCtrl, "Select Client");
        }

        public static void fillClientDDL(ListControl listCtrl, string selectText)
        {
            dsSurveyPoint.ClientsDataTable dt = clsClient.getClients();
            listCtrl.DataSource = dt;
            listCtrl.DataTextField = "Name";
            listCtrl.DataValueField = "ClientID";
            listCtrl.DataBind();
            listCtrl.Items.Insert(0, new ListItem(selectText, ""));
        }

        public static void fillScriptDDLBySurvey(ListControl listCtrl, int iSurveyID)
        {
            fillScriptDDLBySurvey(listCtrl, iSurveyID, "Select Script");
        }

        public static void fillScriptDDLBySurvey(ListControl listCtrl, int iSurveyID, string selectText)
        {
            dsSurveyPoint.ScriptsDataTable dt = clsScript.getScriptsBySurvey(iSurveyID);
            listCtrl.DataSource = dt;
            listCtrl.DataTextField = "Name";
            listCtrl.DataValueField = "ScriptID";
            listCtrl.DataBind();
            listCtrl.Items.Insert(0, new ListItem(selectText, ""));
        }

        public static void fillFileDefImportUpdatesDDLBySurvey(ListControl listCtrl, int iSurveyID)
        {
            fillFileDefImportUpdatesDDLBySurvey(listCtrl, iSurveyID, "Select File Definition");
        }

        public static void fillFileDefImportUpdatesDDLBySurvey(ListControl listCtrl, int iSurveyID, string selectText)
        {
            dsSurveyPoint.FileDefsDataTable dt = clsFileDefs.getImportUpdatesBySurvey(iSurveyID);
            listCtrl.DataSource = dt;
            listCtrl.DataTextField = "FileDefName";
            listCtrl.DataValueField = "FileDefID";
            listCtrl.DataBind();
            listCtrl.Items.Insert(0, new ListItem(selectText, ""));
            listCtrl.Items.Add(new ListItem("GENERATE FILEDEF", "GENERATE"));
        }

        public static void fillSurveyInstanceDDL(ListControl listCtrl)
        {
            DBFilter filter = new DBFilter();
            filter.AddSelectNumericFilter("Active", "1");
            dsSurveyPoint.SurveyInstancesDataTable dt = clsSurveyInstance.getSurveyInstances(filter);
            DataView dv = dt.DefaultView;
            dv.Sort = "SurveyName, ClientName, SurveyInstanceName";
            foreach (DataRowView drv in dv)
            {
                dsSurveyPoint.SurveyInstancesRow si = (dsSurveyPoint.SurveyInstancesRow)drv.Row;
                ListItem siItem = new ListItem(String.Format("{0} - {1} - {2}",
                    si.SurveyName, si.ClientName, si.SurveyInstanceName),
                    si.SurveyInstanceID.ToString());
                listCtrl.Items.Add(siItem);
            }

            listCtrl.Items.Insert(0, new ListItem("", ""));

        }

        public static void fillTriggerDDL(ListControl listCtrl, string selectText)
        {
            dsSurveyPoint.TriggersDataTable triggers = clsTriggers.GetTriggers(-1, -1, -1, null, true, false);
            listCtrl.DataSource = triggers;
            listCtrl.DataTextField = "TriggerName";
            listCtrl.DataValueField = "TriggerID";
            listCtrl.DataBind();
            if (selectText != null) listCtrl.Items.Insert(0, new ListItem(selectText, ""));
        }

        public static void fillTriggerDDL(ListControl listCtrl, string selectText, int TriggerID, int SurveyID, int TriggerTypeID, int InvocationPointID)
        {
            bool bIncNonSurveyTriggers = (SurveyID == 0);
            string connStr = DBConnections.GetConnectionString(clsConnection.MAIN_DB);
            SqlConnection conn = new SqlConnection(connStr);
            conn.Open();
            clsTriggers helper = new clsTriggers();
            helper.DBConnection = conn;
            try
            {
                dsSurveyPoint.TriggersDataTable triggers = clsTriggers.GetTriggers(SurveyID, TriggerTypeID, InvocationPointID, null, false, bIncNonSurveyTriggers);
                helper.removeRecursiveTriggers(TriggerID, triggers);
                listCtrl.DataSource = triggers;
                listCtrl.DataTextField = "TriggerName";
                listCtrl.DataValueField = "TriggerID";
                listCtrl.DataBind();
                if (selectText != null) listCtrl.Items.Insert(0, new ListItem(selectText, ""));
            }
            finally
            {
                if (conn != null)
                {
                    if (conn.State == ConnectionState.Open) conn.Close();
                    conn.Dispose();
                }
            }

        }

        public static void fillTriggerDDL(ListControl listCtrl, string selectText, int SurveyID, int TriggerTypeID, int InvocationPointID)
        {            
            bool bIncNonSurveyTriggers = (SurveyID == 0);
            string connStr = DBConnections.GetConnectionString(clsConnection.MAIN_DB);
            SqlConnection conn = new SqlConnection(connStr);
            conn.Open();
            clsTriggers helper = new clsTriggers();
            helper.DBConnection = conn;
            try
            {
                dsSurveyPoint.TriggersDataTable triggers = clsTriggers.GetTriggers(SurveyID, TriggerTypeID, InvocationPointID, null, false, bIncNonSurveyTriggers);
                listCtrl.DataSource = triggers;
                listCtrl.DataTextField = "TriggerName";
                listCtrl.DataValueField = "TriggerID";
                listCtrl.DataBind();
                if (selectText != null) listCtrl.Items.Insert(0, new ListItem(selectText, ""));
            }
            finally
            {
                if (conn != null)
                {
                    if (conn.State == ConnectionState.Open) conn.Close();
                    conn.Dispose();
                }
            }

        }

        public static void fillTriggerTypeDDL(ListControl listCtrl, string selectText)
        {
            dsSurveyPoint.TriggerTypesDataTable types = clsTriggers.GetTriggerTypes();
            listCtrl.DataSource = types;
            listCtrl.DataTextField = "TriggerTypeName";
            listCtrl.DataValueField = "TriggerTypeID";
            listCtrl.DataBind();
            if (selectText != null) listCtrl.Items.Insert(0, new ListItem(selectText, ""));
        }

        public static void fillInvocationPointDDL(ListControl listCtrl, string selectText)
        {
            dsSurveyPoint.InvocationPointsDataTable points = clsTriggers.GetInvocationPoints();
            listCtrl.DataSource = points;
            listCtrl.DataTextField = "InvocationPointName";
            listCtrl.DataValueField = "InvocationPointID";
            listCtrl.DataBind();
            if (selectText != null) listCtrl.Items.Insert(0, new ListItem(selectText, ""));

        }

        public static void fillCriteriaTypeDDL(ListControl listCtrl, string selectText)
        {
            dsSurveyPoint.CriteriaTypesDataTable dt = clsCriteria.GetCriteriaTypes();
            listCtrl.DataSource = dt;
            listCtrl.DataTextField = "Name";
            listCtrl.DataValueField = "CriteriaTypeID";
            listCtrl.DataBind();
            if (selectText != null) listCtrl.Items.Insert(0, new ListItem(selectText, ""));
        }
    }
}
