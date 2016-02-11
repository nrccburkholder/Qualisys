Option Explicit On

Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports DMI
Imports System.Data.Common
Public Class clsSurveys
    Inherits DMI.clsDBEntity2

    Private m_iUserID As Integer = 0

#Region "dbEntity2 Overrides"
    Public Sub New(ByRef conn As SqlClient.SqlConnection)
        MyBase.New(conn)

    End Sub

    Public Sub New(ByRef conn As String)
        MyBase.New(conn)

    End Sub

    Protected Overrides Sub _FillLookups(ByRef drCriteria As System.Data.DataRow)
        Me.FillUsers()
        Me.FillSurveyQuestions(drCriteria)
        Me.FillQuestions(drCriteria)

    End Sub

    Protected Overrides Function BuildSelectSQL(ByVal drCriteria As DataRow) As String
        Dim dr As dsSurveys.SearchRow
        Dim sbSQL As New System.Text.StringBuilder()

        dr = CType(drCriteria, dsSurveys.SearchRow)

        'Primary key criteria
        If Not dr.IsSurveyIDNull Then sbSQL.AppendFormat("SurveyID = {0} AND ", dr.SurveyID)
        'keyword criteria
        If Not dr.IsKeywordNull Then sbSQL.AppendFormat("Name + Description LIKE {0} AND ", DMI.DataHandler.QuoteString(dr.Keyword))
        'survey author
        If Not dr.IsCreatedByUserIDNull Then sbSQL.AppendFormat("CreatedByUserID = {0} AND ", dr.CreatedByUserID)
        'active criteria
        If Not dr.IsActiveNull Then sbSQL.AppendFormat("Active = {0} AND ", dr.Active)

        'Clean up criteria
        If sbSQL.Length > 0 Then
            DMI.clsUtil.Chop(sbSQL, 4)
            sbSQL.Insert(0, "WHERE ")

        End If

        'Add select statement
        sbSQL.Insert(0, "SELECT * FROM Surveys ")

        Return sbSQL.ToString

    End Function

    Protected Overrides Function DeleteCommand() As System.Data.SqlClient.SqlCommand
        Dim oCmd As SqlClient.SqlCommand

        oCmd = New SqlClient.SqlCommand("delete_Surveys", Me._oConn)
        oCmd.CommandType = CommandType.StoredProcedure
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@SurveyID", SqlDbType.Int, 4, "SurveyID"))

        Return oCmd

    End Function

    Protected Overrides Sub InitSettings()
        'init class variables
        _ds = New dsSurveys()
        _dtMainTable = _ds.Tables("Surveys")
        _sDeleteFilter = "SurveyID = {0}"

    End Sub

    Protected Overrides Function InsertCommand() As System.Data.SqlClient.SqlCommand
        Dim oCmd As SqlClient.SqlCommand

        oCmd = New SqlClient.SqlCommand("insert_Surveys", Me._oConn)
        oCmd.CommandType = CommandType.StoredProcedure
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@SurveyID", SqlDbType.Int, 4, "SurveyID"))
        oCmd.Parameters("@SurveyID").Direction = ParameterDirection.Output
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@Name", SqlDbType.VarChar, 100, "Name"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@Description", SqlDbType.VarChar, 1000, "Description"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@CreatedByUserID", SqlDbType.Int, 4, "CreatedByUserID"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@Active", SqlDbType.TinyInt, 1, "Active"))

        Return oCmd

    End Function

    Protected Overrides Sub SetIdentityFilter(ByVal iEntityID As Integer, ByRef drCriteria As System.Data.DataRow)
        drCriteria.Item("SurveyID") = iEntityID

    End Sub

    Protected Overrides Function UpdateCommand() As System.Data.SqlClient.SqlCommand
        Dim oCmd As SqlClient.SqlCommand

        oCmd = New SqlClient.SqlCommand("update_Surveys", Me._oConn)
        oCmd.CommandType = CommandType.StoredProcedure
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@SurveyID", SqlDbType.Int, 4, "SurveyID"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@Name", SqlDbType.VarChar, 100, "Name"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@Description", SqlDbType.VarChar, 1000, "Description"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@Active", SqlDbType.TinyInt, 1, "Active"))

        Return oCmd

    End Function

    Protected Overrides Sub SetNewRowDefaults(ByRef dr As System.Data.DataRow)
        dr.Item("Name") = ""
        dr.Item("Description") = ""
        dr.Item("CreatedByUserID") = m_iUserID
        dr.Item("CreatedOnDate") = Now()
        dr.Item("Active") = 1

    End Sub

    Protected Overrides Function VerifyDelete(ByRef dr As System.Data.DataRow) As Boolean
        Dim sbSQL As New Text.StringBuilder()
        Dim iCount As Integer

        sbSQL.AppendFormat("SELECT COUNT(SurveyQuestionID) FROM SurveyQuestions WHERE SurveyID = {0}", dr.Item("SurveyID", DataRowVersion.Original))

        iCount = CInt(SqlHelper.ExecuteScalar(Me._oConn, CommandType.Text, sbSQL.ToString))
        sbSQL = Nothing

        If iCount > 0 Then
            Me._sErrorMsg &= String.Format("Cannot delete survey ID {0}. Survey has survey questions.\n", dr.Item("SurveyID", DataRowVersion.Original))
            Return False

        End If

        Return True

    End Function

#End Region

    Public Property AuthorUserID() As Integer
        Get
            Return m_iUserID

        End Get
        Set(ByVal Value As Integer)
            m_iUserID = Value

        End Set
    End Property

    Public Shared Function CopySurvey(ByVal iSurveyID As Integer, ByVal iUserID As Integer, ByRef oConn As SqlClient.SqlConnection) As Integer
        Return CInt(SqlHelper.ExecuteScalar(oConn, CommandType.StoredProcedure, "copy_Survey", _
            New SqlClient.SqlParameter("@SurveyID", iSurveyID), _
            New SqlClient.SqlParameter("@UserID", iUserID)))

    End Function

#Region "Survey Question Lookup"

    Public Sub FillSurveyQuestions(ByVal drCriteria As DataRow)
        Dim dr1 As dsSurveys.SearchRow
        Dim dr2 As dsSurveyQuestions.SearchRow
        Dim oSQ As New clsSurveyQuestions(Me._oConn)

        dr1 = CType(drCriteria, dsSurveys.SearchRow)
        dr2 = CType(oSQ.NewSearchRow, dsSurveyQuestions.SearchRow)

        If Not dr1.IsSurveyIDNull Then dr2.SurveyID = dr1.SurveyID

        oSQ.MainDataTable = Me.SurveyQuestionsTable
        oSQ.FillMain(dr2)

        oSQ.Close()
        oSQ = Nothing
        dr1 = Nothing
        dr2 = Nothing

    End Sub

    Public Sub FillSurveyQuestions(ByVal iSurveyID As Integer)
        Dim dr As DataRow

        dr = Me.NewSearchRow
        dr.Item("SurveyID") = iSurveyID
        Me.FillSurveyQuestions(dr)

        dr = Nothing

    End Sub

    Public Function SurveyQuestionsTable() As DataTable
        Return Me._ds.Tables("SurveyQuestions")

    End Function

#End Region

#Region "Question Lookup"

    Public Sub FillQuestions(ByVal drCriteria As DataRow)
        Dim dr1 As dsSurveys.SearchRow
        Dim dr2 As dsQuestions.SearchRow
        Dim oQ As New clsQuestions(Me._oConn)

        dr1 = CType(drCriteria, dsSurveys.SearchRow)
        dr2 = CType(oQ.NewSearchRow, dsQuestions.SearchRow)

        If Not dr1.IsSurveyIDNull Then dr2.SurveyID = dr1.SurveyID

        oQ.MainDataTable = Me.QuestionsTable
        oQ.FillMain(dr2)

        oQ.Close()
        oQ = Nothing
        dr1 = Nothing
        dr2 = Nothing

    End Sub

    Public Sub FillQuestions(ByVal iSurveyID As Integer)
        Dim dr As DataRow

        dr = Me.NewSearchRow
        dr.Item("SurveyID") = iSurveyID
        Me.FillSurveyQuestions(dr)

        dr = Nothing

    End Sub

    Public Function QuestionsTable() As DataTable
        Return Me._ds.Tables("Questions")

    End Function

#End Region

#Region "User Lookup"
    Public Sub FillUsers()
        Dim dr As dsUsers.SearchRow
        Dim oU As New clsUsers(Me._oConn)

        dr = CType(oU.NewSearchRow, dsUsers.SearchRow)

        oU.MainDataTable = Me.UsersTable
        oU.FillMain(dr)

        oU.Close()
        oU = Nothing
        dr = Nothing

    End Sub

    Public Function UsersTable()
        Return Me._ds.Tables("Users")

    End Function

#End Region

    Public Shared Function GetSurveyList(ByVal oConn As SqlClient.SqlConnection) As SqlClient.SqlDataReader
        Return SqlHelper.ExecuteReader(oConn, CommandType.Text, _
            "SELECT SurveyID, Name FROM Surveys WHERE Active = 1 ORDER BY Name")

    End Function

End Class
