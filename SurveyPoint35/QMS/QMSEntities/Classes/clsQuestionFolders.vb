Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports DMI
Imports System.Data.Common
Public Class clsQuestionFolders
    Inherits DMI.clsDBEntity2

#Region "dbEntity2 Overrides"

    Public Sub New(ByRef conn As SqlClient.SqlConnection)
        MyBase.New(conn)

    End Sub

    Public Sub New(ByRef conn As String)
        MyBase.New(conn)

    End Sub

    Protected Overrides Sub _FillLookups(ByRef drCriteria As System.Data.DataRow)
        FillQuestions(drCriteria)
        clsQuestions.FillQuestionType(Me._oConn, _ds.Tables("QuestionTypes"))

    End Sub

    Protected Overrides Function BuildSelectSQL(ByVal drCriteria As DataRow) As String
        Dim dr As dsQuestionFolders.SearchRow
        Dim sbSQL As New System.Text.StringBuilder

        dr = CType(drCriteria, dsQuestionFolders.SearchRow)

        'Primary key criteria
        If Not dr.IsQuestionFolderIDNull Then sbSQL.AppendFormat("QuestionFolderID = {0} AND ", dr.QuestionFolderID)
        'keyword criteria
        If Not dr.IsKeywordNull Then sbSQL.AppendFormat("Name + Description LIKE {0} AND ", DMI.DataHandler.QuoteString(dr.Keyword))
        'Folder criteria
        If Not dr.IsActiveNull Then sbSQL.AppendFormat("Active = {0} AND ", dr.Active)

        'Clean up criteria
        If sbSQL.Length > 0 Then
            DMI.clsUtil.Chop(sbSQL, 4)
            sbSQL.Insert(0, "WHERE ")

        End If

        'Add select statement
        sbSQL.Insert(0, "SELECT * FROM QuestionFolders ")

        Return sbSQL.ToString

    End Function

    Protected Overrides Function DeleteCommand() As System.Data.SqlClient.SqlCommand
        Dim oCmd As SqlClient.SqlCommand

        oCmd = New SqlClient.SqlCommand("delete_QuestionFolders", Me._oConn)
        oCmd.CommandType = CommandType.StoredProcedure
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@QuestionFolderID", SqlDbType.Int, 4, "QuestionFolderID"))

        Return oCmd

    End Function

    Protected Overrides Sub InitSettings()
        'init class variables
        _ds = New dsQuestionFolders
        _dtMainTable = _ds.Tables("QuestionFolders")
        _sDeleteFilter = "QuestionFolderID = {0}"

    End Sub

    Protected Overrides Function InsertCommand() As System.Data.SqlClient.SqlCommand
        Dim oCmd As SqlClient.SqlCommand

        oCmd = New SqlClient.SqlCommand("insert_QuestionFolders", Me._oConn)
        oCmd.CommandType = CommandType.StoredProcedure
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@QuestionFolderID", SqlDbType.Int, 4, "QuestionFolderID"))
        oCmd.Parameters("@QuestionFolderID").Direction = ParameterDirection.Output
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@Name", SqlDbType.VarChar, 100, "Name"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@Description", SqlDbType.VarChar, 1000, "Description"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@Active", SqlDbType.TinyInt, 1, "Active"))

        Return oCmd

    End Function

    Protected Overrides Sub SetIdentityFilter(ByVal iEntityID As Integer, ByRef drCriteria As System.Data.DataRow)
        drCriteria.Item("QuestionFolderID") = iEntityID

    End Sub

    Protected Overrides Function UpdateCommand() As System.Data.SqlClient.SqlCommand
        Dim oCmd As SqlClient.SqlCommand

        oCmd = New SqlClient.SqlCommand("update_QuestionFolders", Me._oConn)
        oCmd.CommandType = CommandType.StoredProcedure
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@QuestionFolderID", SqlDbType.Int, 4, "QuestionFolderID"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@Name", SqlDbType.VarChar, 100, "Name"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@Description", SqlDbType.VarChar, 1000, "Description"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@Active", SqlDbType.TinyInt, 1, "Active"))

        Return oCmd

    End Function

    Protected Overrides Sub SetNewRowDefaults(ByRef dr As System.Data.DataRow)
        dr.Item("Name") = ""
        dr.Item("Description") = ""
        dr.Item("Active") = 1

    End Sub

    Protected Overrides Function VerifyDelete(ByRef dr As System.Data.DataRow) As Boolean
        Dim sbSQL As New Text.StringBuilder
        Dim iCount As Integer

        sbSQL.AppendFormat("SELECT COUNT(QuestionID) FROM Questions WHERE QuestionFolderID = {0}", dr.Item("QuestionFolderID", DataRowVersion.Original))

        iCount = CInt(SqlHelper.ExecuteScalar(Me._oConn, CommandType.Text, sbSQL.ToString))
        sbSQL = Nothing

        If iCount > 0 Then
            Me._sErrorMsg &= String.Format("Cannot delete Question Folder ID {0} {1}. Question folder has questions.\n", dr.Item("QuestionFolderID", DataRowVersion.Original), dr.Item("Name", DataRowVersion.Original))
            Return False

        End If

        Return True

    End Function

    Protected Overrides Function VerifyInsert(ByVal dr As System.Data.DataRow) As Boolean
        Return ValidateFolderName(CInt(dr.Item("QuestionFolderID")), dr.Item("Name").ToString)

    End Function

    Protected Overrides Function VerifyUpdate(ByVal dr As System.Data.DataRow) As Boolean
        Return ValidateFolderName(CInt(dr.Item("QuestionFolderID")), dr.Item("Name").ToString)

    End Function

#End Region

    Public Function ValidateFolderName(ByVal iQuestionFolderID As Integer, ByVal sFolderName As String) As Boolean
        Dim sSQL As String

        sSQL = String.Format("SELECT COUNT(QuestionFolderID) FROM QuestionFolders WHERE Name LIKE {0} AND QuestionFolderID <> {1}", DMI.DataHandler.QuoteString(sFolderName), iQuestionFolderID)

        If CInt(SqlHelper.ExecuteScalar(_oConn, CommandType.Text, sSQL)) > 0 Then
            'username already in use
            Me._sErrorMsg &= String.Format("Folder name {0} already in use by another folder. Please change folder name.", sFolderName)
            Return False

        End If

        Return True

    End Function

#Region "Datareader functions"

    Public Function GetQuestionFolderList() As SqlClient.SqlDataReader
        Return GetQuestionFolderList(Me._oConn)

    End Function

    Public Shared Function GetQuestionFolderList(ByVal oConn As SqlClient.SqlConnection) As SqlClient.SqlDataReader
        Dim sSQL As String

        sSQL = "SELECT QuestionFolderID, Name FROM QuestionFolders WHERE Active = 1 ORDER BY Name"

        Return SqlHelper.ExecuteReader(oConn, CommandType.Text, sSQL)

    End Function

#End Region

#Region "Question lookup functions"

    Public Sub FillQuestions(ByVal drCriteria As DataRow)
        Dim dr1 As dsQuestionFolders.SearchRow
        Dim dr2 As dsQuestions.SearchRow
        Dim oQ As New clsQuestions(Me._oConn)

        dr1 = CType(drCriteria, dsQuestionFolders.SearchRow)
        dr2 = CType(oQ.NewSearchRow, dsQuestions.SearchRow)

        If Not dr1.IsQuestionFolderIDNull Then dr2.QuestionFolderID = dr1.QuestionFolderID

        oQ.MainDataTable = Me.QuestionsTable
        oQ.FillMain(dr2)

        oQ.Close()
        oQ = Nothing
        dr1 = Nothing
        dr2 = Nothing

    End Sub

    Public ReadOnly Property QuestionsTable() As DataTable
        Get
            Return _ds.Tables("Questions")

        End Get
    End Property

#End Region

End Class
