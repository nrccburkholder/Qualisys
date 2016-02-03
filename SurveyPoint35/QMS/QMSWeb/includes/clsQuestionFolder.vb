Public Enum tblQuestionFolders
    QuestionFolderID = 0
    Name = 1
    Description = 2
    Active = 3
    QuestionCount = 4
End Enum

<Obsolete("Use QMS.clsQuestionFolders")> _
Public Class clsQuestionFolder
    Inherits clsDBEntity

    Sub New(Optional ByVal sConn As String = "", Optional ByVal iEntityID As Integer = 0)
        MyBase.New(sConn, iEntityID)

    End Sub

    Default Public Overloads Property Details(ByVal qbField As tblQuestionFolders) As Object
        Get
            Return MyBase.Details(qbField.ToString)

        End Get

        Set(ByVal Value As Object)
            If qbField = tblQuestionFolders.QuestionFolderID Then
                Me._iEntityID = Value

            End If

            MyBase.Details(qbField.ToString) = Value

        End Set

    End Property

    'Function to provide all class parameters, like _sTableName
    Protected Overrides Sub InitClass()
        'Define table
        Me._sTableName = "QuestionFolders"

        'INSERT SQL for Users table
        Me._sInsertSQL = "INSERT INTO QuestionFolders(Name, Description, Active) VALUES({1},{2},{3}) "

        'UPDATE SQL for Users table
        Me._sUpdateSQL = "UPDATE QuestionFolders SET Name = {1}, Description = {2}, Active = {3} "
        Me._sUpdateSQL &= "WHERE QuestionFolderID = {0} "

        'DELETE SQL for Users table
        Me._sDeleteSQL = "DELETE FROM QuestionFolders WHERE QuestionFolderID = {0} "

        'SELECT SQL for Users table
        Me._sSelectSQL = "SELECT QuestionFolderID, Name, Description, Active, QuestionCount "
        Me._sSelectSQL &= "FROM (SELECT qf.QuestionFolderID, qf.Name, qf.Description, qf.Active, COUNT(q.QuestionID) AS QuestionCount "
        Me._sSelectSQL &= "FROM QuestionFolders qf LEFT OUTER JOIN Questions q ON qf.QuestionFolderID = q.QuestionFolderID "
        Me._sSelectSQL &= "GROUP BY qf.QuestionFolderID, qf.Name, qf.Description, qf.Active) x "

    End Sub

    'Builds insert SQL from dataset
    Protected Overrides Function GetInsertSQL() As String

        Return String.Format(Me._sInsertSQL, Details(tblQuestionFolders.QuestionFolderID), _
                            DMI.DataHandler.QuoteString(Details(tblQuestionFolders.Name)), _
                            DMI.DataHandler.QuoteString(Details(tblQuestionFolders.Description)), _
                            Math.Abs(Details(tblQuestionFolders.Active)))

    End Function

    'Builds update SQL from dataset
    Protected Overrides Function GetUpdateSQL() As String

        Return String.Format(Me._sUpdateSQL, Details(tblQuestionFolders.QuestionFolderID), _
                            DMI.DataHandler.QuoteString(Details(tblQuestionFolders.Name)), _
                            DMI.DataHandler.QuoteString(Details(tblQuestionFolders.Description)), _
                            Math.Abs(Details(tblQuestionFolders.Active)))

    End Function

    'Builds select SQL from dataset for search
    Protected Overrides Function GetSearchSQL() As String
        Dim sWHERESQL As String = ""
        Dim bIdentity As Boolean = False

        If Me._iEntityID > 0 Then
            sWHERESQL = String.Format("QuestionFolderID = {0} AND ", Me._iEntityID)
            bIdentity = True

        End If

        If Not bIdentity Then

            If Details(tblQuestionFolders.Name).ToString.Length > 0 Then
                sWHERESQL &= String.Format("Name LIKE {0} AND ", DMI.DataHandler.QuoteString(Details(tblQuestionFolders.Name)))

            End If

            If Details(tblQuestionFolders.Description).ToString.Length > 0 Then
                sWHERESQL &= String.Format("Description LIKE {0} AND ", DMI.DataHandler.QuoteString(Details(tblQuestionFolders.Description)))

            End If

            If Details(tblQuestionFolders.Active).ToString.Length > 0 Then
                sWHERESQL &= String.Format("Active = {0} AND ", Details(tblQuestionFolders.Active))

            End If

        End If

        If sWHERESQL <> "" Then
            sWHERESQL = "WHERE " & sWHERESQL
            sWHERESQL = Left(sWHERESQL, Len(sWHERESQL) - 4)

        End If

        Return Me._sSelectSQL & sWHERESQL

    End Function

    'Builds delete SQL from dataset
    Protected Overrides Function GetDeleteSQL() As String

        Return String.Format(Me._sDeleteSQL, Details(tblQuestionFolders.QuestionFolderID))

    End Function

    'Determine if delete is allowed
    Protected Overrides Function VerifyDelete() As String
        Dim sSQL As String

        sSQL = String.Format("SELECT COUNT(QuestionID) FROM Questions WHERE QuestionFolderID = {0}", Me._iEntityID)

        If CInt(DMI.SqlHelper.ExecuteScalar(Me.ConnectionString, CommandType.Text, sSQL)) > 0 Then
            Return String.Format("Question folder id {0} cannot be deleted. There are still questions in folder.\n", Me._iEntityID)

        End If

        Return ""

    End Function

    'Called by Create method to fill datarow with default values for new record
    Protected Overrides Sub SetRecordDefaults(ByRef dr As DataRow)

        dr.Item("QuestionFolderID") = 0
        dr.Item("Name") = ""
        dr.Item("Description") = ""
        dr.Item("Active") = 1

    End Sub

    Public Function CopyQuestionFolder(ByVal iQuestionFolderID As Integer) As Integer
        Dim sSQL As String
        Dim iNewQuestionFolderID As Integer

        sSQL = "INSERT INTO QuestionFolders(Name, Description, Active) "
        sSQL &= "(SELECT 'Copy of ' + Name, Description, 1 FROM QuestionFolders WHERE QuestionFolderID = {0}; " & vbCrLf
        sSQL &= "SELECT @@INDENTITY"

        iNewQuestionFolderID = CInt(DMI.SqlHelper.ExecuteScalar(Me.ConnectionString, CommandType.Text, sSQL))

        Return iNewQuestionFolderID

    End Function

    Public Function GetQuestions() As DataTable
        Dim q As New clsQuestion(Me.ConnectionString)
        Dim dt As DataTable

        If Me._dsEntity.Tables.IndexOf("Questions") > -1 Then
            Me._dsEntity.Tables.Remove("Questions")

        End If

        q.Details(tblQuestions.QuestionFolderID) = Me._iEntityID
        dt = q.GetDetails().Tables("Questions").Copy

        Me._dsEntity.Tables.Add(dt)

        Return dt

    End Function

    Public Sub ResortQuestions()
        Dim sSQL As String
        Dim dv As DataView
        Dim drv As DataRowView
        Dim iItemOrder As Integer

        dv = Me._dsEntity.Tables("Questions").DefaultView
        dv.Sort = "ItemOrder"
        iItemOrder = 1
        sSQL = ""

        For Each drv In dv.Table.DefaultView
            sSQL &= String.Format("UPDATE Questions SET ItemOrder = {1} WHERE QuestionID = {0}; " & vbCrLf, _
                                    drv.Item("QuestionID"), iItemOrder)
            drv.Item("ItemOrder") = iItemOrder

            iItemOrder += 1

        Next

        If sSQL.Length > 0 Then
            DMI.SqlHelper.ExecuteNonQuery(Me.ConnectionString, CommandType.Text, sSQL)

        End If

    End Sub

    Public Sub ResortQuestions(ByVal ht As Hashtable)
        Dim dr As DataRow
        Dim iQuestionID As Integer

        For Each dr In Me._dsEntity.Tables("Questions").Rows
            iQuestionID = dr.Item("QuestionID")
            dr.Item("ItemOrder") = ht.Item(iQuestionID)

        Next

        Me.ResortQuestions()

    End Sub

    Public ReadOnly Property QuestionCount() As Integer
        Get

            If Me._dsEntity.Tables.IndexOf("Questions") = -1 Then
                Me.GetQuestions()
            End If

            Return Me._dsEntity.Tables("Questions").Rows.Count

        End Get

    End Property

End Class
