<Obsolete("Use QMS.clsAnswerCategories")> _
Public Enum tblAnswerCategories
    AnswerCategoryID = 0
    QuestionID = 1
    AnswerValue = 2
    AnswerText = 3
    AnswerCategoryTypeID = 4
    AnswerCategoryTypeName = 5

End Enum

<Obsolete("Use QMS.clsAnswerCategories")> _
Public Enum qmsAnswerCategoryTypes
    SELECT_ITEM = 1
    SELECT_OPEN_ANSWER = 2
    OPEN_ANSWER = 3
    MULTIMARK_SELECT = 4

End Enum

<Obsolete("Use QMS.clsAnswerCategories")> _
Public Class clsAnswerCategory
    Inherits clsDBEntity

    Sub New(Optional ByVal sConn As String = "", Optional ByVal iEntityID As Integer = 0)
        MyBase.New(sConn, iEntityID)

    End Sub



    Protected _iQuestionID As Integer

    Default Public Overloads Property Details(ByVal eField As tblAnswerCategories) As Object
        Get
            Return MyBase.Details(eField.ToString)

        End Get

        Set(ByVal Value As Object)
            If eField = tblAnswerCategories.AnswerCategoryID Then
                Me._iEntityID = Value

            ElseIf eField = tblAnswerCategories.QuestionID Then
                Me._iQuestionID = Value

            End If

            MyBase.Details(eField.ToString) = Value

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
                    Me._iEntityID = Me.Details(tblAnswerCategories.AnswerCategoryID)
                    Me._iQuestionID = Me.Details(tblAnswerCategories.QuestionID)

                End If
            End If
        End Set

    End Property

    'Function to provide all class parameters, like _sTableName
    Protected Overrides Sub InitClass()

        'Define table
        Me._sTableName = "AnswerCategories"

        'INSERT SQL for Users table
        Me._sInsertSQL = "INSERT INTO AnswerCategories(QuestionID, AnswerValue, AnswerText, AnswerCategoryTypeID) "
        Me._sInsertSQL &= "VALUES({1}, {2}, {3}, {4}) "

        'UPDATE SQL for Users table
        Me._sUpdateSQL = "UPDATE AnswerCategories SET QuestionID = {1}, AnswerValue = {2}, AnswerText = {3}, AnswerCategoryTypeID = {4} "
        Me._sUpdateSQL &= "WHERE AnswerCategoryID = {0}"

        'DELETE SQL for Users table
        Me._sDeleteSQL = "DELETE FROM AnswerCategories WHERE AnswerCategoryID = {0} "

        'SELECT SQL for Users table
        Me._sSelectSQL = "SELECT ac.AnswerCategoryID, ac.QuestionID, ac.AnswerValue, ac.AnswerText, ac.AnswerCategoryTypeID, "
        Me._sSelectSQL &= "act.Name AS AnswerCategoryTypeName "
        Me._sSelectSQL &= "FROM AnswerCategories ac INNER JOIN "
        Me._sSelectSQL &= "AnswerCategoryTypes act ON ac.AnswerCategoryTypeID = act.AnswerCategoryTypeID "

    End Sub

    'Builds insert SQL from dataset
    Protected Overrides Function GetInsertSQL() As String

        Return String.Format(Me._sInsertSQL, Details(tblAnswerCategories.AnswerCategoryID), _
                            Details(tblAnswerCategories.QuestionID), _
                            Details(tblAnswerCategories.AnswerValue), _
                            DMI.DataHandler.QuoteString(Details(tblAnswerCategories.AnswerText)), _
                            Details(tblAnswerCategories.AnswerCategoryTypeID))

    End Function

    'Builds update SQL from dataset
    Protected Overrides Function GetUpdateSQL() As String

        Return String.Format(Me._sUpdateSQL, Details(tblAnswerCategories.AnswerCategoryID), _
                            Details(tblAnswerCategories.QuestionID), _
                            Details(tblAnswerCategories.AnswerValue), _
                            DMI.DataHandler.QuoteString(Details(tblAnswerCategories.AnswerText)), _
                            Details(tblAnswerCategories.AnswerCategoryTypeID))

    End Function

    'Builds select SQL from dataset for search
    Protected Overrides Function GetSearchSQL() As String
        Dim sWHERESQL As String = ""
        Dim bIdentity As Boolean = False

        If Me._iEntityID > 0 Then
            sWHERESQL = String.Format("AnswerCategoryID = {0} AND ", Me._iEntityID)
            bIdentity = True

        End If

        If Not bIdentity Then

            If Not IsDBNull(Details(tblAnswerCategories.QuestionID)) Then
                sWHERESQL &= String.Format("QuestionID = {0} AND ", Details(tblAnswerCategories.QuestionID))

            End If

            If Not IsDBNull(Details(tblAnswerCategories.AnswerValue)) Then
                sWHERESQL &= String.Format("AnswerValue = {0} AND ", Details(tblAnswerCategories.AnswerValue))

            End If

            If Details(tblAnswerCategories.AnswerText).ToString.Length > 0 Then
                sWHERESQL &= String.Format("AnswerText LIKE {0} AND ", DMI.DataHandler.QuoteString(Details(tblAnswerCategories.AnswerText)))

            End If

            If Not IsDBNull(Details(tblAnswerCategories.AnswerCategoryTypeID)) Then
                sWHERESQL &= String.Format("AnswerCategoryTypeID = {0} AND ", Details(tblAnswerCategories.AnswerCategoryTypeID))

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

        Return String.Format(Me._sDeleteSQL, Details(tblAnswerCategories.AnswerCategoryID))

    End Function

    'Determine if delete is allowed
    Protected Overrides Function VerifyDelete() As String
        Dim sSQL As String
        Dim ds As DataSet

        sSQL = "SELECT COUNT(r.ResponseID) AS ResponseCount, COUNT(ssc.ScriptScreenCategoryID) AS ScriptScreenCategoryCount "
        sSQL &= "FROM AnswerCategories ac LEFT OUTER JOIN "
        sSQL &= "Responses r ON ac.AnswerCategoryID = r.AnswerCategoryID LEFT OUTER JOIN "
        sSQL &= "ScriptScreenCategories ssc ON ac.AnswerCategoryID = ssc.AnswerCategoryID "
        sSQL &= String.Format("WHERE ac.AnswerCategoryID = {0} ", Me._iEntityID)

        If DMI.DataHandler.GetDS(Me.ConnectionString, ds, sSQL) Then

            If ds.Tables(0).Rows(0).Item("ResponseCount") > 0 Then
                Return String.Format("Answer category id {0} cannot be deleted. Answer category has responses.\n", Me._iEntityID)

            ElseIf ds.Tables(0).Rows(0).Item("ScriptScreenCategoryCount") > 0 Then
                Return String.Format("Answer category id {0} cannot be deleted. Answer category used by script screens.\n", Me._iEntityID)

            End If

        Else

            Return "Problems querying database.\n"

        End If

        Return ""

    End Function

    'Called by Create method to fill datarow with default values for new record
    Protected Overrides Sub SetRecordDefaults(ByRef dr As DataRow)

        dr.Item("AnswerCategoryID") = 0
        dr.Item("QuestionID") = Me._iQuestionID
        dr.Item("AnswerValue") = -1
        dr.Item("AnswerText") = ""
        dr.Item("AnswerCategoryTypeID") = 1

    End Sub

    Public Function GetAnswerCategoryTypes(ByVal iQuestionTypeID As Integer) As DataTable
        Dim sSQL As String
        Dim ds As DataSet

        Const iSingle = 1
        Const iMultiple = 2
        Const iOpenAnswer = 3

        If Me._dsEntity.Tables.IndexOf("AnswerCategoryTypes") > -1 Then
            Me._dsEntity.Tables.Remove("AnswerCategoryTypes")

        End If

        sSQL = "SELECT AnswerCategoryTypeID, AnswerCategoryTypeName FROM v_QuestionAnswerCategoryTypes "
        sSQL &= String.Format("WHERE QuestionTypeID = {0} ", iQuestionTypeID)

        If DMI.DataHandler.GetDS(Me.ConnectionString, Me._dsEntity, sSQL, "AnswerCategoryTypes") Then
            Return Me._dsEntity.Tables("AnswerCategoryTypes")

        End If

    End Function

    Protected Overrides Function VerifyInsert() As String
        Dim sSQL As String

        sSQL = "SELECT COUNT(AnswerCategoryID) FROM AnswerCategories WHERE AnswerCategoryID <> {0} AND QuestionID = {1} AND AnswerValue = {2} "
        sSQL = String.Format(sSQL, Details(tblAnswerCategories.AnswerCategoryID), _
                    Details(tblAnswerCategories.QuestionID), _
                    Details(tblAnswerCategories.AnswerValue))

        If CInt(DMI.SqlHelper.ExecuteScalar(Me.ConnectionString, CommandType.Text, sSQL)) > 0 Then
            Return "Value already exists. Please change the answer value. "

        End If

        Return ""

    End Function

End Class
