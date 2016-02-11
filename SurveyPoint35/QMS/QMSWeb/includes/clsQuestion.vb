Public Enum tblQuestions
    QuestionID = 0
    QuestionFolderID = 1
    Text = 2
    ShortDesc = 3
    QuestionTypeID = 4
    ItemOrder = 5
    QuestionTypeName = 6
    QuestionFolderName = 7
End Enum

Public Enum qmsQuestionType
    SingleSelect = 1
    MultipleSelect = 2
    OpenAnswer = 3
    Numeric = 4
    Datetime = 5

End Enum

<Obsolete("Use QMS.clsQuestions")> _
Public Class clsQuestion
    Inherits clsDBEntity

    Protected _iQuestionFolderID As Integer = 0

    Sub New(Optional ByVal sConn As String = "", Optional ByVal iEntityID As Integer = 0)
        MyBase.New(sConn, iEntityID)

    End Sub

    Default Public Overloads Property Details(ByVal qField As tblQuestions) As Object
        Get
            Return MyBase.Details(qField.ToString)

        End Get

        Set(ByVal Value As Object)
            If qField = tblQuestions.QuestionID Then
                Me._iEntityID = Value

            ElseIf qField = tblQuestions.QuestionFolderID Then
                Me._iQuestionFolderID = Value

            End If

            MyBase.Details(qField.ToString) = Value

        End Set

    End Property

    Public Overrides Property DataSet() As System.Data.DataSet
        Get
            Return Me._dsEntity

        End Get

        Set(ByVal Value As DataSet)
            Me._dsEntity = Value

            If Me._dsEntity.Tables.IndexOf(Me._sTableName) > -1 Then
                If Me._dsEntity.Tables(Me._sTableName).Rows.Count > 0 Then
                    Me._iEntityID = Me.Details(tblQuestions.QuestionID)
                    If Not IsDBNull(Me.Details(tblQuestions.QuestionFolderID)) Then
                        Me._iQuestionFolderID = Me.Details(tblQuestions.QuestionFolderID)

                    End If
                End If
            End If
        End Set

    End Property

    'Function to provide all class parameters, like _sTableName
    Protected Overrides Sub InitClass()
        'Define table
        Me._sTableName = "Questions"

        'INSERT SQL for table
        Me._sInsertSQL = "INSERT INTO Questions(QuestionFolderID, Text, ShortDesc, QuestionTypeID, ItemOrder) "
        Me._sInsertSQL &= "(SELECT {1}, {2}, {3}, {4}, ISNULL(MAX(q.ItemOrder), 0) + 1 "
        Me._sInsertSQL &= "FROM Questions q RIGHT OUTER JOIN QuestionFolders qf "
        Me._sInsertSQL &= "ON q.QuestionFolderID = qf.QuestionFolderID "
        Me._sInsertSQL &= "GROUP BY qf.QuestionFolderID "
        Me._sInsertSQL &= "HAVING (qf.QuestionFolderID = {1})) "

        'UPDATE SQL for table
        Me._sUpdateSQL = "UPDATE Questions SET Text = {2}, ShortDesc = {3}, QuestionTypeID = {4} "
        Me._sUpdateSQL &= "WHERE QuestionID = {0} "

        'DELETE SQL for table
        Me._sDeleteSQL = "DELETE FROM AnswerCategories WHERE QuestionID = {0}; "
        Me._sDeleteSQL &= "DELETE FROM Questions WHERE QuestionID = {0} "

        'SELECT SQL for table
        Me._sSelectSQL = "SELECT q.QuestionID, q.QuestionFolderID, q.Text, q.ShortDesc, q.QuestionTypeID, q.ItemOrder, qt.Name AS QuestionTypeName, qf.Name AS QuestionFolderName "
        Me._sSelectSQL &= "FROM Questions q INNER JOIN QuestionTypes qt "
        Me._sSelectSQL &= "ON q.QuestionTypeID = qt.QuestionTypeID "
        Me._sSelectSQL &= "INNER JOIN QuestionFolders qf ON q.QuestionFolderID = qf.QuestionFolderID "

    End Sub

    'Builds insert SQL from dataset
    Protected Overrides Function GetInsertSQL() As String

        Return String.Format(Me._sInsertSQL, Details(tblQuestions.QuestionID), _
                            Details(tblQuestions.QuestionFolderID), _
                            DMI.DataHandler.QuoteString(Details(tblQuestions.Text)), _
                            DMI.DataHandler.QuoteString(Details(tblQuestions.ShortDesc)), _
                            Details(tblQuestions.QuestionTypeID))

    End Function

    'Builds update SQL from dataset
    Protected Overrides Function GetUpdateSQL() As String

        Return String.Format(Me._sUpdateSQL, Details(tblQuestions.QuestionID), _
                            Details(tblQuestions.QuestionFolderID), _
                            DMI.DataHandler.QuoteString(Details(tblQuestions.Text)), _
                            DMI.DataHandler.QuoteString(Details(tblQuestions.ShortDesc)), _
                            Details(tblQuestions.QuestionTypeID))

    End Function

    Public Function SetOpenAnswerCategory() As Boolean
        Dim ac As clsAnswerCategory

        If Me.Details(tblQuestions.QuestionTypeID) = qmsQuestionType.OpenAnswer Then
            If Me.AnswerCategoryCount > 0 Then
                Return False

            End If

            ac = New clsAnswerCategory(Me.ConnectionString)
            ac.Details(tblAnswerCategories.AnswerCategoryID) = 0
            ac.Details(tblAnswerCategories.QuestionID) = Me.Details(tblQuestions.QuestionID)
            ac.Details(tblAnswerCategories.AnswerCategoryTypeID) = qmsAnswerCategoryTypes.OPEN_ANSWER
            ac.Details(tblAnswerCategories.AnswerValue) = 1
            ac.Details(tblAnswerCategories.AnswerText) = "Open Answer"
            ac.Submit()

            Return True

        End If

        Return False

    End Function

    'Builds select SQL from dataset for search
    Protected Overrides Function GetSearchSQL() As String
        Dim sWHERESQL As String = ""
        Dim bIdentity As Boolean = False

        If Me._iEntityID > 0 Then
            sWHERESQL &= String.Format("QuestionID = {0} AND ", Me._iEntityID)
            bIdentity = True

        End If

        If Not bIdentity Then

            If Not IsDBNull(Details(tblQuestions.QuestionFolderID)) Then
                sWHERESQL &= String.Format("q.QuestionFolderID = {0} AND ", Details(tblQuestions.QuestionFolderID))

            End If

            If Details(tblQuestions.Text).ToString.Length > 0 Then
                sWHERESQL &= String.Format("Text LIKE {0} AND ", DMI.DataHandler.QuoteString(Details(tblQuestions.Text)))

            End If

            If Details(tblQuestions.ShortDesc).ToString.Length > 0 Then
                sWHERESQL &= String.Format("ShortDesc LIKE {0} AND ", DMI.DataHandler.QuoteString(Details(tblQuestions.ShortDesc)))

            End If

            If Not IsDBNull(Details(tblQuestions.QuestionTypeID)) Then
                sWHERESQL &= String.Format("q.QuestionTypeID = {0} AND ", Details(tblQuestions.QuestionTypeID))

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

        Return String.Format(Me._sDeleteSQL, Details(tblQuestions.QuestionID))

    End Function

    'Determine if delete is allowed
    Protected Overrides Function VerifyDelete() As String
        Dim sSQL As String
        Dim ds As DataSet

        sSQL = "SELECT COUNT(SurveyQuestionID) AS SurveyQuestionCount "
        sSQL &= String.Format("FROM SurveyQuestions sq WHERE QuestionID = {0}", Me._iEntityID)

        If CInt(DMI.SqlHelper.ExecuteScalar(Me.ConnectionString, CommandType.Text, sSQL)) > 0 Then
            Return String.Format("Question id {0} cannot be deleted. Question is being used by a survey.\n", Me._iEntityID)

        Else
            Return ""

        End If

    End Function

    'Called by Create method to fill datarow with default values for new record
    Protected Overrides Sub SetRecordDefaults(ByRef dr As DataRow)

        dr.Item("QuestionID") = 0
        dr.Item("QuestionFolderID") = Me._iQuestionFolderID
        dr.Item("Text") = ""
        dr.Item("ShortDesc") = ""
        dr.Item("QuestionTypeID") = 1
        dr.Item("ItemOrder") = 0

    End Sub

    Public Function GetQuestionTypesList() As DataTable
        Dim sSQL As String
        Dim ds As DataSet

        sSQL = "SELECT QuestionTypeID, Name FROM QuestionTypes ORDER BY Name "

        If DMI.DataHandler.GetDS(Me.ConnectionString, ds, sSQL, "QuestionTypes") Then

            Return ds.Tables("QuestionTypes")

        End If

    End Function

    Protected Overrides Function Create() As DataSet
        Dim ds As DataSet
        Dim sSQL As String

        If Not IsDBNull(Details(tblQuestions.QuestionFolderID)) Then
            If Details(tblQuestions.QuestionFolderID) > 0 Then
                sSQL = "SELECT 0 AS QuestionID, QuestionFolderID, '' AS Text, '' AS ShortDesc, 1 AS QuestionTypeID, 0 AS ItemOrder, '' AS QuestionTypeName, Name AS QuestionFolderName "
                sSQL &= "FROM QuestionFolders WHERE QuestionFolderID = {0} "
                sSQL = String.Format(sSQL, Details(tblQuestions.QuestionFolderID))

                If Not Me._dsEntity Is Nothing Then
                    Me._dsEntity.Clear()
                End If

                If DMI.DataHandler.GetDS(Me.ConnectionString, Me._dsEntity, sSQL, Me._sTableName) Then
                    Me._iEntityID = -1

                    Return Me._dsEntity

                End If

            End If

        End If

        Return MyBase.Create()

    End Function

    Public Function GetAnswerCategories() As DataTable
        Dim ac As New clsAnswerCategory(ConnectionString)
        Dim dt As DataTable

        If Me._dsEntity.Tables.IndexOf("AnswerCategories") > -1 Then
            Me._dsEntity.Tables.Remove("AnswerCategories")

        End If

        ac.Details(tblAnswerCategories.QuestionID) = Me._iEntityID
        dt = ac.GetDetails().Tables("AnswerCategories").Copy

        Me._dsEntity.Tables.Add(dt)

        Return dt

    End Function

    Public ReadOnly Property AnswerCategoryCount() As Integer
        Get
            If Me._dsEntity.Tables.IndexOf("AnswerCategories") = -1 Then
                GetAnswerCategories()

            End If

            Return Me._dsEntity.Tables("AnswerCategories").Rows.Count

        End Get

    End Property

    Public Sub AddAnswerCategory()
        Dim dr As DataRow

        dr = Me._dsEntity.Tables("AnswerCategories").NewRow

        dr.Item("AnswerCategoryID") = 0
        dr.Item("QuestionID") = Me._iEntityID
        dr.Item("AnswerValue") = -1
        dr.Item("AnswerText") = ""
        dr.Item("AnswerCategoryTypeID") = 1

        Me._dsEntity.Tables("AnswerCategories").Rows.Add(dr)

    End Sub

    Public Function IsValid() As Boolean
        Dim sSQL As String = ""
        Dim iCountInvalidCategories As Integer

        If Details(tblQuestions.QuestionID) > 0 Then

            sSQL = "SELECT COUNT(AnswerCategoryID) FROM AnswerCategories WHERE QuestionID = {0} AND AnswerCategoryTypeID NOT IN (SELECT AnswerCategoryTypeID FROM QuestionAnswerCategoryTypes WHERE QuestionTypeID = {1})"
            sSQL = String.Format(sSQL, Details(tblQuestions.QuestionID), Details(tblQuestions.QuestionTypeID))

            iCountInvalidCategories = CInt(DMI.SqlHelper.ExecuteScalar(Me.ConnectionString, CommandType.Text, sSQL))

            If iCountInvalidCategories > 0 Then
                Select Case CInt(Details(tblQuestions.QuestionTypeID))
                    Case qmsQuestionType.SingleSelect, qmsQuestionType.MultipleSelect
                        Me._sErrorMsg = "Unable to change question type. Question type doesn't not allow open answer categories. Please remove open answer categories before updating."

                    Case Else 'Open answer
                        Me._sErrorMsg = "Unable to change question type. Question type doesn't not allow select categories. Please remove select categories before updating."

                End Select

                Return False

            End If

        End If

        Return True

    End Function

    Function CopyTo(ByVal iQuestionID As Integer, ByVal iToQuestionFolderID As Integer) As Integer
        Dim sSQL As String
        Dim iNewQuestionID As Integer

        'copy question record
        sSQL = "INSERT INTO Questions (QuestionFolderID, Text, ShortDesc, QuestionTypeID, ItemOrder) "
        sSQL &= "SELECT {1}, Text, ShortDesc, QuestionTypeID, (SELECT COUNT(QuestionID) + 1 FROM Questions WHERE QuestionFolderID = {1}) AS ItemOrder "
        sSQL &= "FROM Questions WHERE QuestionID = {0};  SELECT ISNULL(@@IDENTITY,0) "
        sSQL = String.Format(sSQL, iQuestionID, iToQuestionFolderID)
        iNewQuestionID = CInt(DMI.SqlHelper.ExecuteScalar(Me.ConnectionString, CommandType.Text, sSQL))

        'copy answer category records
        sSQL = "INSERT INTO AnswerCategories (QuestionID, AnswerValue, AnswerText, AnswerCategoryTypeID) "
        sSQL &= "SELECT {1}, AnswerValue, AnswerText, AnswerCategoryTypeID FROM AnswerCategories WHERE QuestionID = {0}"
        sSQL = String.Format(sSQL, iQuestionID, iNewQuestionID)
        DMI.SqlHelper.ExecuteNonQuery(Me.ConnectionString, CommandType.Text, sSQL)

        Return iNewQuestionID

    End Function

End Class
