Public Class TriggerDemo
    Inherits System.Web.UI.Page
    Protected WithEvents ddlTriggerID As System.Web.UI.WebControls.DropDownList
    Protected WithEvents tbRespondentID As System.Web.UI.WebControls.TextBox
    Protected WithEvents tbScriptScreenID As System.Web.UI.WebControls.TextBox
    Protected WithEvents CompareValidator1 As System.Web.UI.WebControls.CompareValidator
    Protected WithEvents cbRunCriteria As System.Web.UI.WebControls.CheckBox
    Protected WithEvents btnExecute As System.Web.UI.WebControls.Button
    Protected WithEvents dgResults As System.Web.UI.WebControls.DataGrid
    Protected WithEvents CompareValidator2 As System.Web.UI.WebControls.CompareValidator

#Region " Web Form Designer Generated Code "

    'This call is required by the Web Form Designer.
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()

    End Sub

    Private Sub Page_Init(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Init
        'CODEGEN: This method call is required by the Web Form Designer
        'Do not modify it using the code editor.
        InitializeComponent()
    End Sub

#End Region

    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load

        If Not Page.IsPostBack Then
            FillTriggerDDL()

        End If

    End Sub

    Sub FillTriggerDDL()
        Dim sSQL As String = "SELECT TriggerID, TriggerName FROM Triggers"
        Dim dr As SqlClient.SqlDataReader

        dr = DMI.SqlHelper.ExecuteReader(DMI.DataHandler.sConnection, CommandType.Text, sSQL)
        ddlTriggerID.DataSource = dr
        ddlTriggerID.DataValueField = "TriggerID"
        ddlTriggerID.DataTextField = "TriggerName"
        ddlTriggerID.DataBind()

        dr.Close()
        dr = Nothing

    End Sub


    Private Sub btnExecute_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnExecute.Click
        Dim iTriggerID As Integer = 0
        Dim iRespondentID As Integer = 0
        Dim iScriptScreenID As Integer = 0
        Dim bRunCriteria As Boolean = False

        'Get form settings
        iTriggerID = CInt(ddlTriggerID.SelectedItem.Value)
        If IsNumeric(tbRespondentID.Text) Then iRespondentID = CInt(tbRespondentID.Text)
        If IsNumeric(tbScriptScreenID.Text) Then iScriptScreenID = CInt(tbScriptScreenID.Text)
        If cbRunCriteria.Checked Then bRunCriteria = True

        RunTrigger(iTriggerID, iRespondentID, iScriptScreenID, bRunCriteria)

    End Sub

    Sub RunTrigger(ByVal iTriggerID As Integer, ByVal iRespondentID As Integer, ByVal iScriptScreenID As Integer, Optional ByVal bRunCriteria As Boolean = True)
        Dim iCriteriaID As Integer = 0
        Dim bRunTrigger As Boolean = True
        Dim drTrigger As SqlClient.SqlDataReader
        Dim drTriggerType As SqlClient.SqlDataReader
        Dim sbSQL As New StringBuilder()
        Dim ds As DataSet
        Dim rwTrigger As DataRow

        'get trigger parameters
        drTrigger = GetTriggerDataReader(iTriggerID)

        If drTrigger.Read Then
            'run criteria
            If Not IsDBNull(drTrigger.Item("CriteriaID")) Then
                If bRunCriteria Then bRunTrigger = CheckCriteria(CInt(drTrigger.Item("CriteriaID")), iRespondentID)

            End If

            'execute trigger
            If bRunTrigger Then
                'get trigger type code
                drTriggerType = GetTriggerTypeDataReader(CInt(drTrigger.Item("TriggerTypeID")))
                drTriggerType.Read()

                'build sql code
                sbSQL.AppendFormat(drTriggerType.Item("IntroCode"), iRespondentID, iScriptScreenID)
                sbSQL.AppendFormat(drTrigger.Item("TheCode"), iRespondentID, iScriptScreenID)
                sbSQL.AppendFormat(drTriggerType.Item("ExitCode"), iRespondentID, iScriptScreenID)

                'clean up data readers
                drTriggerType.Close()
                drTrigger.Close()
                drTriggerType = Nothing
                drTrigger = Nothing

                'execute generated code
                Try
                    ds = DMI.SqlHelper.ExecuteDataset(DMI.DataHandler.sConnection, CommandType.Text, sbSQL.ToString)

                    'log trigger success
                    DMI.SqlHelper.ExecuteNonQuery(DMI.DataHandler.sConnection, CommandType.StoredProcedure, _
                        "spLogTrigger", _
                        New SqlClient.SqlParameter("@triggerID", iTriggerID), _
                        New SqlClient.SqlParameter("@value1", iRespondentID), _
                        New SqlClient.SqlParameter("@value2", iScriptScreenID), _
                        New SqlClient.SqlParameter("@value3", DBNull.Value), _
                        New SqlClient.SqlParameter("@value4", DBNull.Value), _
                        New SqlClient.SqlParameter("@successFlag", 1), _
                        New SqlClient.SqlParameter("@parameterText", ""))

                Catch
                    'log trigger failure
                    DMI.SqlHelper.ExecuteNonQuery(DMI.DataHandler.sConnection, CommandType.StoredProcedure, _
                        "spLogTrigger", _
                        New SqlClient.SqlParameter("@triggerID", iTriggerID), _
                        New SqlClient.SqlParameter("@value1", iRespondentID), _
                        New SqlClient.SqlParameter("@value2", iScriptScreenID), _
                        New SqlClient.SqlParameter("@value3", DBNull.Value), _
                        New SqlClient.SqlParameter("@value4", DBNull.Value), _
                        New SqlClient.SqlParameter("@successFlag", 0), _
                        New SqlClient.SqlParameter("@parameterText", ""))

                    Exit Sub

                End Try

                'check if there are other triggers to run, then execute self
                drTrigger = GetTriggerIDDataTable(iTriggerID, iRespondentID, iScriptScreenID, -7777, -7777)

                Do Until Not drTrigger.Read
                    RunTrigger(CInt(drTrigger.Item("TriggerID")), iRespondentID, iScriptScreenID, bRunCriteria)

                Loop

                drTrigger.Close()
                drTrigger = Nothing

            End If

        End If

    End Sub

    Function GetTriggerDataReader(ByVal iTriggerID As Integer) As SqlClient.SqlDataReader
        Dim sSQL As String

        sSQL = String.Format("SELECT * FROM Triggers WHERE TriggerID = {0}", iTriggerID)
        Return DMI.SqlHelper.ExecuteReader(DMI.DataHandler.sConnection, CommandType.Text, sSQL)

    End Function

    Function GetTriggerTypeDataReader(ByVal iTriggerTypeID As Integer) As SqlClient.SqlDataReader
        Dim sSQL As String

        sSQL = String.Format("SELECT * FROM TriggerTypes WHERE TriggerTypeID = {0}", iTriggerTypeID)
        Return DMI.SqlHelper.ExecuteReader(DMI.DataHandler.sConnection, CommandType.Text, sSQL)

    End Function

    Function CheckCriteria(ByVal iCriteriaID As Integer, ByVal iRespondentID As Integer) As Boolean
        Dim sSQL As String = String.Format("SELECT DoesRespondentMatchCriteria({0},{1})", iCriteriaID, iRespondentID)

        If CInt(DMI.SqlHelper.ExecuteScalar(DMI.DataHandler.sConnection, CommandType.Text, sSQL)) = 1 Then
            Return True

        End If

        Return False

    End Function

    Function GetTriggerIDDataTable(ByVal iTriggerID As Integer, ByVal iValue1 As Integer, ByVal iValue2 As Integer, ByVal iValue3 As Integer, ByVal iValue4 As Integer) As SqlClient.SqlDataReader

        Return DMI.SqlHelper.ExecuteReader(DMI.DataHandler.sConnection, CommandType.StoredProcedure, _
            "spGetListOfDependantTriggersToRun", _
            New SqlClient.SqlParameter("@triggerid", iTriggerID), _
            New SqlClient.SqlParameter("@value1", iValue1), _
            New SqlClient.SqlParameter("@value2", iValue2), _
            New SqlClient.SqlParameter("@value3", iValue3), _
            New SqlClient.SqlParameter("@value4", iValue4))


    End Function

    Sub SetupDataGrid(ByRef ds As DataSet)
        dgResults.DataSource = ds
        dgResults.DataBind()

    End Sub

End Class
