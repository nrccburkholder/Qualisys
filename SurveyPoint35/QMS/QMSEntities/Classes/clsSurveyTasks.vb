Imports DMI
Imports System.Data.Common
Public Class clsSurveyTasks
    Inherits DMI.clsDBEntity2

    Private _iUserID As Integer

#Region "dbEntity2 Overrides"
    Public Sub New(ByRef conn As SqlClient.SqlConnection)
        MyBase.New(conn)

    End Sub

    Public Sub New(ByRef conn As String)
        MyBase.New(conn)

    End Sub

    Protected Overrides Sub _FillLookups(ByRef drCriteria As System.Data.DataRow)
        'no lookups

    End Sub

    Protected Overrides Function BuildSelectSQL(ByVal drCriteria As DataRow) As String
        Dim dr As dsSurveyTasks.SearchRow
        Dim sbSQL As New System.Text.StringBuilder()

        dr = CType(drCriteria, dsSurveyTasks.SearchRow)

        'Primary key criteria
        If Not dr.IsSurveyInstanceProtocolStepIDNull Then sbSQL.AppendFormat("SurveyInstanceProtocolStepID = {0} AND ", dr.SurveyInstanceProtocolStepID)
        If Not dr.IsRowIDNull Then sbSQL.AppendFormat("RowID = {0} AND ", dr.RowID)
        'protocol step id criteria
        If Not dr.IsProtocolStepIDNull Then sbSQL.AppendFormat("ProtocolStepID = {0} AND ", dr.ProtocolStepID)
        'protocol step type criteria
        If Not dr.IsProtocolStepTypeIDNull Then
            sbSQL.AppendFormat("ProtocolStepTypeID = {0} AND ", dr.ProtocolStepTypeID)
        Else
            sbSQL.Append("(ProtocolStepTypeID NOT IN (2,3,4)) AND ")
        End If
        'survey criteria
        If Not dr.IsSurveyIDNull Then sbSQL.AppendFormat("SurveyID = {0} AND ", dr.SurveyID)
        'client criteria
        If Not dr.IsClientIDNull Then sbSQL.AppendFormat("ClientID = {0} AND ", dr.ClientID)
        'survey instance criteria
        If Not dr.IsSurveyInstanceIDNull Then sbSQL.AppendFormat("SurveyInstanceID = {0} AND ", dr.SurveyInstanceID)
        'active critiera
        If Not dr.IsActiveNull Then sbSQL.AppendFormat("Active = {0} AND ", dr.Active)
        'cleared criteria
        If Not dr.IsClearedNull Then sbSQL.AppendFormat("Cleared = {0} AND ", dr.Cleared)
        'date range criteria
        If Not dr.IsStartDateRangeNull Then sbSQL.AppendFormat("ProtocolStepDate >= '{0}' AND ", dr.StartDateRange)
        If Not dr.IsEndDateRangeNull Then sbSQL.AppendFormat("ProtocolStepDate <= '{0}' AND ", dr.EndDateRange)

        'Clean up criteria
        If sbSQL.Length > 0 Then
            DMI.clsUtil.Chop(sbSQL, 4)
            sbSQL.Insert(0, "WHERE ")

        End If

        'Add select statement
        sbSQL.Insert(0, "SELECT * FROM vw_SurveyTasks ")

        Return sbSQL.ToString

    End Function

    Protected Overrides Function DeleteCommand() As System.Data.SqlClient.SqlCommand
        Dim oCmd As SqlClient.SqlCommand

        oCmd = New SqlClient.SqlCommand("clear_SurveyTasks", Me._oConn)
        oCmd.CommandType = CommandType.StoredProcedure
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@SurveyInstanceID", SqlDbType.Int, 4, "SurveyInstanceID"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@ProtocolStepID", SqlDbType.Int, 4, "ProtocolStepID"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@UserID", _iUserID))

        Return oCmd

    End Function

    Protected Overrides Sub InitSettings()
        'init class variables
        _ds = New dsSurveyTasks()
        _dtMainTable = _ds.Tables("SurveyTasks")
        _sDeleteFilter = "RowID = {0}"

    End Sub

    Protected Overrides Function InsertCommand() As System.Data.SqlClient.SqlCommand

    End Function

    Protected Overrides Sub SetIdentityFilter(ByVal iEntityID As Integer, ByRef drCriteria As System.Data.DataRow)
        drCriteria.Item("ProtocolStepID") = iEntityID

    End Sub

    Protected Overrides Function UpdateCommand() As System.Data.SqlClient.SqlCommand

    End Function

    Protected Overrides Sub SetNewRowDefaults(ByRef dr As System.Data.DataRow)

    End Sub

#End Region

    Public Property UserID() As Integer
        Get
            Return _iUserID

        End Get
        Set(ByVal Value As Integer)
            _iUserID = Value

        End Set
    End Property

End Class
