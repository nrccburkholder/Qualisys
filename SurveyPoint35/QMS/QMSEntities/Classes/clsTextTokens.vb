Imports System.Text.RegularExpressions
Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports DMI
Imports System.Data.Common
'use this class to replace text tokens within script text
Public Class clsTextTokens
    Inherits DMI.clsProtoDataObject

    Dim _RespondentID As Integer
    Dim _UserID As Integer
    Dim _RespondentDataRow As DataRow
    Dim _RespondentDataReader As SqlClient.SqlDataReader
    Dim _SurveyQuestions As DataTable
    Dim _Responses As DataTable
    Dim _ScreenAnswerCategories As DataTable
    Dim _PropertiesTable As DataTable
    Dim _Users As DataTable
    Dim _OtherTextTokens As Hashtable
    Dim _Username As String = ""

    'constructor
    Public Sub New(ByVal Connection As SqlClient.SqlConnection, ByVal RespondentID As Integer, ByVal UserID As Integer)
        MyBase.New(Connection)
        _RespondentID = RespondentID
        _UserID = UserID

    End Sub

    Public Sub New(ByVal Connection As SqlClient.SqlConnection)
        MyBase.New(Connection)

    End Sub

    Public Sub New()
        MyBase.New(Nothing)

    End Sub

    Public Function ReplaceTextTokens(ByVal sScreenText As String) As String
        Dim re As System.Text.RegularExpressions.Regex

        'replace classic tokens
        sScreenText = re.Replace(sScreenText, "%([\w\s]+)%", New System.Text.RegularExpressions.MatchEvaluator(AddressOf EvalClassicToken))
        'replace token functions
        sScreenText = re.Replace(sScreenText, "(\w+)\(([^\)]*)\)", New System.Text.RegularExpressions.MatchEvaluator(AddressOf EvalTokenFunc))

        Return sScreenText

    End Function

    'evaluates token functions of pattern "func_name(func_arg)"
    Private Function EvalTokenFunc(ByVal m As Match) As String
        Dim sFuncName As String = m.Groups(1).ToString.ToUpper
        Dim sArgValue As String = m.Groups(2).ToString.ToUpper

        Select Case sFuncName
            Case "RESPONDENT"
                Return Respondent(sArgValue)

            Case "PROPERTY"
                Return RespondentProperty(sArgValue)

            Case "ANSWERTEXT"
                Return AnswerText(sArgValue)

            Case "RESPONSETEXT"
                Return ResponseText(sArgValue)

            Case "USERNAME"
                Return UserName

            Case "OTHER"
                Return Other(sArgValue)

            Case "QUERY"
                Return Query(sArgValue)

            Case Else
                Return String.Format("{0}({1})", sFuncName, sArgValue)

        End Select

    End Function

    Private Function EvalClassicToken(ByVal m As System.Text.RegularExpressions.Match) As String
        Dim sToken As String = m.Groups(1).ToString.ToUpper.Trim

        Select Case sToken
            Case "CLIENT NAME"
                Return Respondent("CLIENTNAME")

            Case "SURVEY NAME"
                Return Respondent("SURVEYNAME")

            Case "SURVEY INSTANCE NAME"
                Return Respondent("SurveyInstanceName")

            Case "RESPONDENT NAME"
                Return Respondent("FULLNAME")

            Case "RESPONDENT CITY"
                Return Respondent("CITY")

            Case "RESPONDENT STATE"
                Return Respondent("STATE")

            Case "RESPONDENT PRONOUN"
                Return Respondent("PRONOUN_SUBJECT")

            Case "RESPONDENT POSSESIVE"
                Return Respondent("PRONOUN_POSSESIVE")

            Case "INTERVIEWER NAME"
                Return UserName

        End Select

    End Function

    'set respondent id for database lookups
    Public Property RespondentID() As Integer
        Get
            Return _RespondentID

        End Get
        Set(ByVal Value As Integer)
            _RespondentID = Value

        End Set
    End Property

    'set user id for database lookups
    Public Property UserID() As Integer
        Get
            Return _UserID
        End Get
        Set(ByVal Value As Integer)
            _UserID = Value
        End Set
    End Property

    'set respondent datarow
    Public Property RespondentDataRow() As DataRow
        Get
            Return _RespondentDataRow

        End Get
        Set(ByVal Value As DataRow)
            _RespondentDataRow = Value
            _RespondentDataReader = Nothing

        End Set
    End Property

    'set respondent datareader
    Public Property RespondentDataReader() As SqlClient.SqlDataReader
        Get
            Return _RespondentDataReader

        End Get
        Set(ByVal Value As SqlClient.SqlDataReader)
            _RespondentDataReader = Value
            _RespondentDataRow = Nothing

        End Set
    End Property

    Public Property PropertyDataTable() As DataTable
        Get
            Return _PropertiesTable
        End Get
        Set(ByVal Value As DataTable)
            _PropertiesTable = Value

        End Set

    End Property

    Public Property OtherTextTokens() As Hashtable
        Get
            Return _OtherTextTokens

        End Get
        Set(ByVal Value As Hashtable)
            _OtherTextTokens = Value

        End Set
    End Property

    Public Sub SetCachedResponses(ByVal Responses As DataTable, ByVal ScreenCategories As DataTable, ByVal SurveyQuestions As DataTable)
        _SurveyQuestions = SurveyQuestions
        _Responses = Responses
        _ScreenAnswerCategories = ScreenCategories

    End Sub

    'get respondent value
    Public ReadOnly Property Respondent(ByVal Item As String) As String
        Get
            If Me.IsPronoun(Item) Then
                Return RespondentPronoun(Item)

            ElseIf Item.ToUpper = "FULLNAME" Then
                Return String.Format("{0} {1}", Respondent("FIRSTNAME"), Respondent("LASTNAME"))

            Else
                'pull base data item

                If RespondentDataCached() Then
                    'pull from respondent table
                    Return RespondentTokenCached(Item)

                ElseIf DatabaseConnected() Then
                    'pull item from database
                    Return RespondentTokenDB(Item)

                End If

            End If

            'unable to pull item
            Return String.Format("[{0}]", Item)

        End Get

    End Property

    'get respondent property value
    Public ReadOnly Property RespondentProperty(ByVal item As String) As String
        Get
            If PropertyDataCached() Then
                Return PropertyTokenCached(item)

            ElseIf DatabaseConnected() Then
                Return PropertyTokenDB(item)

            End If

            Return String.Format("[{0}]", item)

        End Get
    End Property

    Public ReadOnly Property AnswerText(ByVal QuestionName As String) As String
        Get
            If ResponsesCached() Then
                Return AnswerTextTokenCached(QuestionName)

            ElseIf DatabaseConnected() Then
                Return AnswerTextTokenDB(QuestionName)

            End If

            Return String.Format("[{0}]", QuestionName)

        End Get
    End Property

    Public ReadOnly Property ResponseText(ByVal QuestionName As String) As String
        Get
            If ResponsesCached() Then
                Return ResponseTextTokenCached(QuestionName)

            ElseIf DatabaseConnected() Then
                Return ResponseTextTokenDB(QuestionName)

            End If

            Return String.Format("[{0}]", QuestionName)

        End Get
    End Property

    Public ReadOnly Property Query(ByVal sqlCommandText As String) As String
        Get
            If DatabaseConnected() Then
                Dim result As Object
                sqlCommandText = Text.RegularExpressions.Regex.Replace(sqlCommandText, "/\[([^(?:\]/)]*)\]/", "($1)")
                result = SqlHelper.ExecuteScalar(Me._Connection, CommandType.Text, String.Format(sqlCommandText, RespondentID))

                If Not IsNothing(result) AndAlso Not IsDBNull(result) Then
                    Return result.ToString

                End If

                Return ""

            End If
        End Get
    End Property

    Public Property UserName() As String
        Get
            If UsernameCached() Then
                Return _Username
            Else
                Return UserNameTextTokenDB()

            End If
        End Get
        Set(ByVal Value As String)
            _Username = Value

        End Set
    End Property

    Public ReadOnly Property Other(ByVal TokenName As String) As String
        Get
            If Not IsNothing(_OtherTextTokens) Then
                If _OtherTextTokens.ContainsKey(TokenName) Then
                    Return _OtherTextTokens.Item(TokenName).ToString

                End If
            End If

            Return String.Format("[{0}]", TokenName)

        End Get
    End Property
#Region "Pronoun Functions"
    Public Function IsPronoun(ByVal sColName As String) As Boolean
        Select Case sColName
            Case "PRONOUN_SUBJECT"
                Return True

            Case "PRONOUN_OBJECT"
                Return True

            Case "PRONOUN_POSSESIVE"
                Return True

            Case "PRONOUN_POSSESIVE2"
                Return True

            Case "PRONOUN_REFLEXIVE"
                Return True

            Case "TITLE"
                Return True

        End Select

        Return False

    End Function

    Public Function RespondentPronoun(ByVal sPronounType As String) As String
        Dim sSQL As String
        Dim oResult As Object

        If _RespondentID > 0 Then
            oResult = Me.Respondent("GENDER")
        Else
            oResult = "F"
        End If

        If Not IsDBNull(oResult) Then
            Select Case sPronounType
                Case "PRONOUN_SUBJECT"
                    Return IIf(oResult.ToString.ToUpper = "M", "he", "she").ToString

                Case "PRONOUN_OBJECT"
                    Return IIf(oResult.ToString.ToUpper = "M", "him", "her").ToString

                Case "PRONOUN_POSSESIVE"
                    Return IIf(oResult.ToString.ToUpper = "M", "his", "her").ToString

                Case "PRONOUN_POSSESIVE2"
                    Return IIf(oResult.ToString.ToUpper = "M", "his", "hers").ToString

                Case "PRONOUN_REFLEXIVE"
                    Return IIf(oResult.ToString.ToUpper = "M", "himself", "herself").ToString

                Case "TITLE"
                    Return IIf(oResult.ToString.ToUpper = "M", "Mr.", "Ms.").ToString

            End Select
        End If

        Return String.Format("[{0}]", sPronounType)

    End Function
#End Region

#Region "Database Functions"

    Public Function DatabaseConnected() As Boolean
        If Not IsNothing(_Connection) Then
            Return True

        End If

        Return False

    End Function
    'replace token for value in respondent table
    Public Function RespondentTokenDB(ByVal sColName As String) As String
        Dim sSQL As String
        Dim oResult As Object

        If _RespondentID > 0 Then
            sSQL = String.Format("SELECT {0} FROM vw_Respondents WHERE RespondentID = {1}", sColName, _RespondentID)
            Try
                oResult = SqlHelper.ExecuteScalar(_Connection, CommandType.Text, sSQL)
            Catch
                oResult = String.Format("[{0} INVALID COLUMN NAME]", sColName)
            End Try

        Else
            oResult = String.Format("TEST {0}", sColName)

        End If

        'check property table
        If IsDBNull(oResult) Or IsNothing(oResult) Then
            Return PropertyTokenDB(sColName)

        End If

        Return oResult.ToString

    End Function

    'replace token for value in respondent properties table
    Public Function PropertyTokenDB(ByVal sPropName As String) As String
        Dim sSQL As String

        sSQL = String.Format("SELECT PropertyValue FROM RespondentProperties WHERE PropertyName = {0} AND RespondentID = {1}", _
            DMI.DataHandler.QuoteString(sPropName), _RespondentID)
        Return DMI.clsUtil.DeNull(SqlHelper.ExecuteScalar(_Connection, CommandType.Text, sSQL), "NO PROPERTY")

    End Function

    'replace token with answer category text for a survey response
    Public Function AnswerTextTokenDB(ByVal sQuestionName As String) As String
        Dim sSQL As String

        sSQL = String.Format("SELECT dbo.GetResponseAnswerText({1},{0})", _
            DMI.DataHandler.QuoteString(sQuestionName), _RespondentID)
        Return DMI.clsUtil.DeNull(SqlHelper.ExecuteScalar(_Connection, CommandType.Text, sSQL), "NO RESPONSE")

    End Function

    'replace token with open answer text for a survey response
    Public Function ResponseTextTokenDB(ByVal sQuestionName As String) As String
        Dim sSQL As String

        sSQL = String.Format("SELECT dbo.GetResponseText({1},{0})", _
            DMI.DataHandler.QuoteString(sQuestionName), _RespondentID)
        Return DMI.clsUtil.DeNull(SqlHelper.ExecuteScalar(_Connection, CommandType.Text, sSQL), "NO RESPONSE")

    End Function

    'get interview name
    Private Function UserNameTextTokenDB() As String
        If _UserID > 0 Then
            Dim sSQL As String

            sSQL = String.Format("SELECT CASE ISNULL(FirstName, '') WHEN '' THEN LastName ELSE FirstName END FROM Users WHERE UserID = {0}", _UserID)
            _Username = SqlHelper.ExecuteScalar(_Connection, CommandType.Text, sSQL)
            Return _Username

        End If

        Return "[your name here]"

    End Function

#End Region

#Region "Datarow/Datatable/Datareader Functions"
#Region "Respondent functions"
    Public Function RespondentDataCached() As Boolean
        If Not IsNothing(_RespondentDataRow) Then
            Return True

        ElseIf Not IsNothing(_RespondentDataReader) Then
            Return True

        End If

        Return False

    End Function

    Public Function RespondentTokenCached(ByVal Item As String) As String
        If Not IsNothing(_RespondentDataRow) Then
            Return RespondentTokenDataRow(Item)

        ElseIf Not IsNothing(_RespondentDataReader) Then
            Return RespondentTokenDataReader(Item)

        End If

        Return String.Format("[{0}]", Item)

    End Function

    Private Function RespondentTokenDataRow(ByVal Item As String) As String
        If _RespondentDataRow.Table.Columns.Contains(Item) Then
            If Not IsDBNull(_RespondentDataRow.Item(Item)) Then
                Return _RespondentDataRow.Item(Item).ToString

            End If
        End If

        Return String.Format("[{0}]", Item)

    End Function

    Private Function RespondentTokenDataReader(ByVal Item As String) As String
        If Not IsDBNull(_RespondentDataReader.Item(Item)) Then
            Return _RespondentDataReader.Item(Item).ToString

        End If

    End Function

#End Region

#Region "Property Functions"
    Public Function PropertyDataCached() As Boolean
        If Not IsNothing(_PropertiesTable) Then
            Return True

        End If

        Return False

    End Function

    Public Function PropertyTokenCached(ByVal Item As String) As String
        If PropertyDataCached() Then
            Dim dr() As DataRow
            dr = Me._PropertiesTable.Select(String.Format("PropertyName LIKE {0}", DMI.DataHandler.QuoteString(Item)))
            If dr.Length > 0 Then
                If Not IsDBNull(dr(0).Item("PropertyValue")) Then
                    Return dr(0).Item("PropertyValue").ToString

                End If
            End If

        End If

        Return "NULL"

    End Function


#End Region

#Region "Response Functions"
    'indicate whether response tables as available
    Public Function ResponsesCached() As Boolean
        If Not IsNothing(Me._SurveyQuestions) Then
            If Not IsNothing(Me._Responses) Then
                If Not IsNothing(Me._ScreenAnswerCategories) Then
                    Return True

                End If
            End If
        End If

        Return True

    End Function

    'return answer text based on responses for given question name
    Private Function AnswerTextTokenCached(ByVal QuestionName As String) As String
        If ResponsesCached() Then
            Return GetResponseCategoryCached(QuestionName, "AnswerText")

        End If

        Return String.Format("[{0}]", QuestionName)

    End Function

    'return response text (open answers) based on responses for given question name
    Private Function ResponseTextTokenCached(ByVal QuestionName As String) As String
        Dim drItem As DataRow
        Dim drs() As DataRow
        Dim TextValue As New Text.StringBuilder

        drs = GetResponsesCached(QuestionName)

        For Each drItem In drs
            If Not IsDBNull(drItem.Item("ResponseText")) Then
                If drItem.Item("ResponseText").ToString.Length > 0 Then
                    If TextValue.Length > 0 Then TextValue.Append(", ")
                    TextValue.Append(drItem.Item("ResponseText").ToString)

                End If
            End If
        Next

        drItem = Nothing
        drs = Nothing
        Return TextValue.ToString

    End Function

    'return the survey question id, given the question name
    Private Function GetSurveyQuestionIDCached(ByVal QuestionName As String) As Integer
        Dim dr() As DataRow
        dr = _SurveyQuestions.Select(String.Format("ShortDesc LIKE {0}", DMI.DataHandler.QuoteString(QuestionName)))
        If dr.Length > 0 Then
            Return CInt(dr(0).Item("SurveyQuestionID"))

        End If

        Return 0

    End Function

    'return response datarows based on survey question id
    Private Function GetResponsesCached(ByVal SurveyQuestionID As Integer) As DataRow()
        Dim dr() As DataRow
        dr = _Responses.Select(String.Format("SurveyQuestionID = {0}", SurveyQuestionID))
        Return dr

    End Function

    'return response datarows based on question name
    Private Function GetResponsesCached(ByVal QuestionName As String) As DataRow()
        Dim SurveyQuestionID As Integer = GetSurveyQuestionIDCached(QuestionName)
        Return GetResponsesCached(SurveyQuestionID)

    End Function

    'return text field values for response category
    Private Function GetResponseCategoryCached(ByVal QuestionName As String, ByVal CategoryField As String) As String
        Dim drItem As DataRow
        Dim drs() As DataRow
        Dim Category As DataRow
        Dim TextValue As New Text.StringBuilder

        drs = GetResponsesCached(QuestionName)

        For Each drItem In drs
            Category = GetCategoryCached(CInt(drItem.Item("AnswerCategoryID")))
            If Not IsNothing(Category) Then
                If TextValue.Length > 0 Then TextValue.Append(", ")
                TextValue.Append(Category.Item(CategoryField))

            End If
        Next

        drItem = Nothing
        drs = Nothing
        Return TextValue.ToString

    End Function

    'return screen category datarow
    Private Function GetCategoryCached(ByVal AnswerCategoryID As Integer) As DataRow
        Dim drs() As DataRow

        drs = _ScreenAnswerCategories.Select(String.Format("AnswerCategoryID = {0}", AnswerCategoryID))
        If drs.Length > 0 Then
            Return drs(0)

        End If

        Return Nothing

    End Function

#End Region

#Region "Username functions"
    Public Function UsernameCached() As Boolean
        If _Username.Length > 0 Then Return True
        Return False

    End Function

#End Region
#End Region

End Class
