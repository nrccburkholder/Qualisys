Option Explicit On
Option Strict On

Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports DMI
Imports System.Data.Common

Public Enum qmsInterviewMode As Integer
    NotInitialized = -1
    InputResponse = 0
    InputCorrection = 2

End Enum

Public Enum qmsCorrection As Integer
    SELECT_OLD = 1
    SELECT_NEW = 2
    RESELECT = 3

End Enum

Public Enum qmsScreenStatus As Integer
    ANSWERED = 1
    NO_ANSWER = 2
    SKIPPED_LEGAL = 3
    SKIPPED_ILLEGAL = 4
    MULTIMARKED = 5
    MISSING = 6

End Enum

Public Enum qmsCalculationTypes As Integer
    REQUIRED_SCREEN = 1
    EXCLUDED_SCREEN = 2
    OPTIONAL_SCREEN = 3

End Enum

Public Class clsInterview
    Inherits DMI.clsDSEntity

#Region "Variables"
    Private _oRespondent As clsRespondents
    Private _oResponses As clsResponses
    Private _oEventLog As clsEventLog
    Private _oScript As clsScripts
    Private _oScriptScreens As clsScriptScreens
    Private _oScriptScreenCategories As clsScriptScreenCategories
    Private _oScriptTriggers As clsScriptTriggers
    Private _iRespondentID As Integer
    Private _iScriptID As Integer
    Private _iUserID As Integer
    Private _iScreenIndex As Integer = 0
    Private _drScriptScreen As dsInterview.ScriptScreensRow
    Private _drScriptScreenCategories As DataRow()
    Private _Correction As qmsInterviewMode = qmsInterviewMode.InputResponse
    Private _iInputModeID As qmsInputMode = qmsInputMode.VIEW
    Private _HttpRequest As Web.HttpRequest
    Private _JumpToScriptID As Integer = -1
    Private _Transaction As SqlClient.SqlTransaction

    Public Const SCRIPT_ID_KEY As String = "scr"
    Public Const RESPONDENT_ID_KEY As String = "rid"
    Public Const INPUTMODE_ID_KEY As String = "input"
    Public Const SCREEN_INDEX_KEY As String = "index"
    Public Const RESPONSE_FIELD_NAME As String = "response"
    Public Const CORRECTION_FIELD_NAME As String = "correction"

#End Region

    Public Sub Save()
        'If Me.InputMode = qmsInputMode.TEST Then
        '    'do not save responses to database in test mode
        '    Responses.MainDataTable.AcceptChanges()
        'Else
        '    'save responses to database and update screen status
        '    Responses.Save()
        'End If
        Responses.Save()
        UpdateScreenStatus(CInt(CurrentScreen.Item("ItemOrder")))

    End Sub

#Region "DSEntity Overrides"
    Public Sub New(ByVal oConn As SqlClient.SqlConnection)
        MyBase.New(oConn)

    End Sub

    Protected Overrides Sub CleanUpEntityObjects()
        If Not IsNothing(_oRespondent) Then _oRespondent.Close()
        If Not IsNothing(_oResponses) Then _oResponses.Close()
        If Not IsNothing(_oScript) Then _oScript.Close()
        If Not IsNothing(_oScriptScreens) Then _oScriptScreens.Close()
        If Not IsNothing(_oScriptScreenCategories) Then _oScriptScreenCategories.Close()
        If Not IsNothing(_oScriptTriggers) Then _oScriptTriggers.Close()
        _oRespondent = Nothing
        _oResponses = Nothing
        _oScript = Nothing
        _oScriptScreens = Nothing
        _oScriptScreenCategories = Nothing
        _oScriptTriggers = Nothing

    End Sub

    Protected Overrides Sub FillChildTables(ByVal drCriteria As System.Data.DataRow)
        FillScriptScreens()
        FillScriptScreenCategories()
        FillScriptTriggers()
        FillResponses()
        UpdateScreenStatus()

    End Sub

    Protected Overrides Sub FillLookupTables(ByVal drCriteria As System.Data.DataRow)
        'no lookups

    End Sub

    Protected Overrides Sub FillMainTable(ByVal drCriteria As System.Data.DataRow)
        If ScriptID > 0 Then
            Script.FillMain(ScriptID)
            If InputMode = qmsInputMode.TEST Then
                'in test mode, use fake survey instance and respondent
                SetupTest()
            Else
                Respondent.FillMain(RespondentID)
            End If

        End If

    End Sub

    Protected Overrides Sub SetTypedDataSet()
        _ds = New dsInterview

    End Sub

#End Region

#Region "Objects"
    Public ReadOnly Property Respondent() As clsRespondents
        Get
            If IsNothing(_oRespondent) Then
                _oRespondent = New clsRespondents(_oConn)
                _oRespondent.UserID = Me.UserID
                _oRespondent.MainDataTable = _ds.Tables("Respondents")

            End If

            Return _oRespondent

        End Get
    End Property

    Public ReadOnly Property Responses() As clsResponses
        Get
            If IsNothing(_oResponses) Then
                _oResponses = New clsResponses(_oConn)
                _oResponses.MainDataTable = _ds.Tables("Responses")

            End If

            Return _oResponses

        End Get
    End Property

    Public ReadOnly Property EventLog() As clsEventLog
        Get
            If IsNothing(_oEventLog) Then
                _oEventLog = New clsEventLog(_oConn)
                _oEventLog.MainDataTable = _ds.Tables("EventLog")

            End If

            Return _oEventLog

        End Get
    End Property

    Public ReadOnly Property Script() As clsScripts
        Get
            If IsNothing(_oScript) Then
                _oScript = New clsScripts(_oConn)
                _oScript.MainDataTable = _ds.Tables("Scripts")

            End If

            Return _oScript

        End Get
    End Property

    Public ReadOnly Property ScriptScreens() As clsScriptScreens
        Get
            If IsNothing(_oScriptScreens) Then
                _oScriptScreens = New clsScriptScreens(_oConn)
                _oScriptScreens.MainDataTable = _ds.Tables("ScriptScreens")

            End If

            Return _oScriptScreens

        End Get
    End Property

    Public ReadOnly Property ScriptScreenCategories() As clsScriptScreenCategories
        Get
            If IsNothing(_oScriptScreenCategories) Then
                _oScriptScreenCategories = New clsScriptScreenCategories(_oConn)
                _oScriptScreenCategories.MainDataTable = _ds.Tables("ScriptScreenCategories")

            End If

            Return _oScriptScreenCategories

        End Get
    End Property

    Public ReadOnly Property ScriptTriggers() As clsScriptTriggers
        Get
            If IsNothing(_oScriptTriggers) Then
                _oScriptTriggers = New clsScriptTriggers(_oConn)
                _oScriptTriggers.UserID = Me.UserID
                _oScriptTriggers.MainDataTable = _ds.Tables("ScriptedTriggers")

            End If

            Return _oScriptTriggers

        End Get
    End Property

#End Region

#Region "Fill Functions"
    Public Sub FillResponses()
        If RespondentID > 0 Then
            Dim r As clsResponses = Responses
            Dim dr As DataRow = r.NewSearchRow

            dr.Item("RespondentID") = RespondentID
            dr.Item("ScriptID") = ScriptID
            r.FillMain(dr)
            dr = Nothing

        End If

    End Sub

    Public Sub FillScriptScreens()
        If ScriptID > 0 Then
            Dim ss As clsScriptScreens = ScriptScreens
            Dim dr As DataRow = ss.NewSearchRow

            dr.Item("ScriptID") = ScriptID
            ss.FillMain(dr)
            dr = Nothing

        End If

    End Sub

    Public Sub FillScriptScreenCategories()
        If ScriptID > 0 Then
            Dim ssc As clsScriptScreenCategories = ScriptScreenCategories
            Dim dr As DataRow = ssc.NewSearchRow

            dr.Item("ScriptID") = ScriptID
            ssc.FillMain(dr)
            ssc.MainDataTable.DefaultView.Sort = "ScriptScreenID, AnswerValue"
            dr = Nothing

        End If

    End Sub

    Public Sub FillScriptTriggers()
        If ScriptID > 0 Then
            Dim st As clsScriptTriggers = ScriptTriggers
            Dim dr As DataRow = st.NewSearchRow

            dr.Item("ScriptID") = ScriptID
            st.FillMain(dr)
            dr = Nothing

        End If

    End Sub

#Region "Setup Test Mode"
    Private Sub SetupTest()
        Dim iSurveyID As Integer = CInt(Script.MainDataTable.Rows(0).Item("SurveyID"))
        Dim iClientID As Integer = SetupTestClient()
        Dim iSurveyInstanceID As Integer = SetupTestSurveyInstance(iSurveyID, iClientID)
        Dim iRespondentID As Integer = SetupTestRespondent(iSurveyInstanceID)

        Me.RespondentID = iRespondentID

    End Sub

    Private Function SetupTestClient() As Integer
        Dim C As New QMS.clsClients(_oConn)
        Dim dr As DataRow
        Dim iClientID As Integer
        Const TESTMODECLIENTNAME As String = "Test Mode Client"

        'determine if test client already exists
        dr = C.NewSearchRow
        dr.Item("Name") = TESTMODECLIENTNAME
        dr.Item("Active") = 0
        C.FillMain(dr)
        If C.MainDataTable.Rows.Count > 0 Then
            'get client id of existing test mode client
            iClientID = CInt(C.MainDataTable.Rows(0).Item("ClientID"))

        Else
            'add test mode client to database
            dr = C.NewMainRow
            dr.Item("Name") = TESTMODECLIENTNAME
            dr.Item("Address1") = ""
            dr.Item("Address2") = ""
            dr.Item("City") = ""
            dr.Item("State") = ""
            dr.Item("PostalCode") = ""
            dr.Item("Telephone") = ""
            dr.Item("Fax") = ""
            dr.Item("Active") = 0
            C.AddMainRow(dr)
            C.Save()

            'get survey instance id
            iClientID = CInt(dr.Item("ClientID"))

        End If

        'clean up
        dr = Nothing
        C.Close()
        C = Nothing

        Return iClientID

    End Function

    Private Function SetupTestSurveyInstance(ByVal SurveyID As Integer, ByVal ClientID As Integer) As Integer
        Dim SI As New QMS.clsSurveyInstances(_oConn)
        Dim dr As DataRow
        Dim iSurveyInstanceID As Integer

        'Create test survey instance
        dr = SI.NewMainRow
        dr.Item("SurveyID") = SurveyID
        dr.Item("ClientID") = ClientID
        dr.Item("ProtocolID") = CInt(SqlHelper.ExecuteScalar(_oConn, CommandType.Text, "SELECT TOP 1 ProtocolID FROM Protocols"))
        dr.Item("Name") = "Test Instance"
        dr.Item("Active") = 0
        dr.Item("GroupByHousehold") = 0
        SI.AddMainRow(dr)
        SI.Save()

        'get survey instance id
        iSurveyInstanceID = CInt(dr.Item("SurveyInstanceID"))

        'clean up
        dr = Nothing
        SI.Close()
        SI = Nothing

        Return iSurveyInstanceID

    End Function

    Private Function SetupTestRespondent(ByVal SurveyInstanceID As Integer) As Integer
        Dim dr As DataRow
        Dim iRespondentID As Integer

        'create test respondent
        dr = Respondent.NewMainRow
        dr.Item("SurveyInstanceID") = SurveyInstanceID
        dr.Item("LastName") = "Doe"
        dr.Item("FirstName") = "Jane"
        dr.Item("City") = "Springfield"
        dr.Item("State") = "IL"
        dr.Item("TelephoneDay") = "5555555555"
        dr.Item("TelephoneEvening") = "5555555555"
        dr.Item("Gender") = "F"
        dr.Item("SurveyID") = 0
        dr.Item("ClientID") = 0
        dr.Item("SurveyName") = ""
        dr.Item("ClientName") = "DUFF"
        dr.Item("SurveyInstanceName") = String.Format("{0:MMM yyyy}", Now())
        dr.Item("CallsMade") = 0
        Respondent.AddMainRow(dr)
        Respondent.Save()

        'get respondent id
        Return CInt(dr.Item("RespondentID"))

    End Function

    Public Sub CleanUpTestMode()
        Dim SI As New clsSurveyInstances(_oConn)
        Dim dr As DataRow

        'get survey instance
        dr = SI.NewSearchRow
        dr.Item("SurveyInstanceID") = CInt(Respondent.MainDataTable.Rows(0).Item("SurveyInstanceID"))
        SI.FillMain(dr)

        'delete responses
        For Each dr In Responses.MainDataTable.Rows
            dr.Delete()
        Next
        Responses.Save()

        'delete test respondent
        Respondent.MainDataTable.Rows(0).Delete()
        Respondent.Save()

        'delete survey instance
        SI.MainDataTable.Rows(0).Delete()
        SI.Save()

        'clean up
        dr = Nothing
        SI.Close()
        SI = Nothing

    End Sub

#End Region

#End Region

#Region "Properties"
    Public Property RespondentID() As Integer
        Get
            Return _iRespondentID

        End Get
        Set(ByVal Value As Integer)
            _iRespondentID = Value

        End Set
    End Property

    Public Property UserID() As Integer
        Get
            Return _iUserID

        End Get
        Set(ByVal Value As Integer)
            _iUserID = Value

        End Set
    End Property

    Public Property ScriptID() As Integer
        Get
            Return _iScriptID

        End Get
        Set(ByVal Value As Integer)
            _iScriptID = Value

        End Set
    End Property

    Public ReadOnly Property JumpToScriptID() As Integer
        Get
            Return _JumpToScriptID
        End Get
    End Property

    Public Property InputMode() As qmsInputMode
        Get
            Return _iInputModeID
        End Get
        Set(ByVal Value As qmsInputMode)
            _iInputModeID = Value

        End Set
    End Property

    Public Property InterviewMode() As qmsInterviewMode
        Get
            Return _Correction

        End Get
        Set(ByVal Value As qmsInterviewMode)
            _Correction = Value

        End Set
    End Property

    Public Property DBTransaction() As SqlClient.SqlTransaction
        Get
            Return _Transaction
        End Get
        Set(ByVal Value As SqlClient.SqlTransaction)
            _Transaction = Value
            Respondent.DBTransaction = Value
            Responses.DBTransaction = Value
            EventLog.DBTransaction = Value
            Script.DBTransaction = Value
            ScriptScreens.DBTransaction = Value
            ScriptScreenCategories.DBTransaction = Value
            ScriptTriggers.DBTransaction = Value
        End Set
    End Property

    Public Property DBConnections() As SqlClient.SqlConnection
        Get
            Return _oConn
        End Get
        Set(ByVal Value As SqlClient.SqlConnection)
            _oConn = Value
            Respondent.DBConnection = Value
            Responses.DBConnection = Value
            EventLog.DBConnection = Value

        End Set
    End Property
#End Region

#Region "Write HTML Responses"
    Public Function ScreenText() As String
        Dim tt As New clsTextTokens(Me._oConn, Me._iRespondentID, Me._iUserID)
        tt.RespondentDataRow = Me.Respondent.MainDataTable.Rows(0)

        If ErrorMsg.Length > 0 Then
            'display text with error message
            'TP Change _Text to Text
            Return String.Format("<p class=""error"">{0}</p>{1}", ErrorMsg, tt.ReplaceTextTokens(_drScriptScreen.Text).Replace("\n", "<br>"))

        Else
            'no error, just display text
            Return tt.ReplaceTextTokens(_drScriptScreen.Text).Replace("\n", "<br>")

        End If

    End Function

    Public Function CategoryHTML() As String
        If Not IsDBNull(_drScriptScreen.Item("SurveyQuestionID")) Then
            If _Correction = qmsInterviewMode.InputResponse Then
                Return AnswerCategories()

            Else
                Return CorrectionCategories()

            End If

        End If

        Return ""

    End Function

    Private Function AnswerCategories() As String
        Dim sbCategory As New Text.StringBuilder
        Dim drCategory As DataRow
        Dim Category As clsCategoryType
        Dim QuestionType As qmsQuestionTypes = CType(_drScriptScreen.Item("QuestionTypeID"), qmsQuestionTypes)
        Dim AnswerValueComparer As IComparer = New clsScriptScreenCategories.SortByAnswerValue

        'sort categories by answer value
        Array.Sort(_drScriptScreenCategories, AnswerValueComparer)
        AnswerValueComparer = Nothing

        For Each drCategory In _drScriptScreenCategories
            Category = clsCategoryTypeFactory.Create(CType(drCategory.Item("AnswerCategoryTypeID"), qmsAnswerCategoryTypes), QuestionType)
            If _iInputModeID = qmsInputMode.VERIFY Then Category.DisplayResponses = False
            sbCategory.AppendFormat("{0}<br>", Category.ToHTML(drCategory))
            Category = Nothing
        Next

        Return sbCategory.ToString

    End Function

    Private Function CorrectionCategories() As String
        Dim sbCategory As New Text.StringBuilder
        Dim sbDataEntryResponses As New Text.StringBuilder
        Dim sbVerifyResponses As New Text.StringBuilder
        Dim drCategory As DataRow
        Dim arPreviousResponses() As String
        Dim drResponses() As DataRow
        Dim iAnswerValue As Integer
        Dim Category As clsCategoryType
        Dim QuestionType As qmsQuestionTypes = CType(_drScriptScreen.Item("QuestionTypeID"), qmsQuestionTypes)

        'save verification response
        sbCategory.AppendFormat("<input type=""hidden"" name=""{1}"" value=""{0}"">", _HttpRequest.Item(RESPONSE_FIELD_NAME), RESPONSE_FIELD_NAME)
        arPreviousResponses = Split(_HttpRequest.Item(RESPONSE_FIELD_NAME), ",")

        For Each drCategory In _drScriptScreenCategories
            'get data entry responses
            drResponses = GetResponses(drCategory)
            iAnswerValue = CInt(drCategory.Item("AnswerValue"))
            If drResponses.Length > 0 Then
                If sbDataEntryResponses.Length > 0 Then sbDataEntryResponses.Append(", ")
                sbDataEntryResponses.Append(iAnswerValue)
                If drResponses(0).Item("ResponseText").ToString.Length > 0 Then
                    sbDataEntryResponses.AppendFormat(":{0}", drResponses(0).Item("ResponseText"))

                End If

            End If
            'get verification responses
            Category = clsCategoryTypeFactory.Create(CType(drCategory.Item("AnswerCategoryTypeID"), qmsAnswerCategoryTypes), QuestionType)
            If Category.ReadResponse(_HttpRequest, drCategory) Then
                If Category.Selected Then
                    If sbVerifyResponses.Length > 0 Then sbVerifyResponses.Append(", ")
                    sbVerifyResponses.Append(iAnswerValue)
                    If Category.AnswerText.Length > 0 Then
                        sbVerifyResponses.AppendFormat(":{0}", Category.AnswerText)
                        sbCategory.AppendFormat("<input type=""hidden"" name=""OA{0}"" id=""OA{0}"" value=""{1}"">", iAnswerValue, Category.AnswerText)

                    End If

                End If
            End If
            Category = Nothing

        Next

        sbCategory.AppendFormat("<input type=""radio"" name=""{1}"" id=""C{2}"" value=""{0}"">{2}:", CInt(qmsCorrection.SELECT_OLD), CORRECTION_FIELD_NAME, TranslateCorrectionToInputLetter(qmsCorrection.SELECT_OLD))
        sbCategory.AppendFormat("&nbsp;<strong>Choose old answer</strong>:&nbsp;{0}<br>", sbDataEntryResponses.ToString)
        sbCategory.AppendFormat("<input type=""radio"" name=""{1}"" id=""C{2}"" value=""{0}"">{2}:", CInt(qmsCorrection.SELECT_NEW), CORRECTION_FIELD_NAME, TranslateCorrectionToInputLetter(qmsCorrection.SELECT_NEW))
        sbCategory.AppendFormat("&nbsp;<strong>Choose new answer</strong>:&nbsp;{0}<br>", sbVerifyResponses.ToString)
        sbCategory.AppendFormat("<input type=""radio"" name=""{1}"" id=""C{2}"" value=""{0}"">{2}:", CInt(qmsCorrection.RESELECT), CORRECTION_FIELD_NAME, TranslateCorrectionToInputLetter(qmsCorrection.RESELECT))
        sbCategory.Append("&nbsp;<strong>Choose neither answer, re-select...</strong>")

        Return sbCategory.ToString

    End Function

    Public Shared Function TranslateCorrectionToInputLetter(ByVal correction As qmsCorrection) As String
        Select Case correction
            Case qmsCorrection.SELECT_OLD
                Return "A"
            Case qmsCorrection.SELECT_NEW
                Return "B"
            Case qmsCorrection.RESELECT
                Return "C"
        End Select
    End Function

    Public Shared Function TranslateInputLetterToCorrection(ByVal inputLetter As String) As qmsCorrection
        Select Case inputLetter
            Case "A"
                Return qmsCorrection.SELECT_OLD
            Case "B"
                Return qmsCorrection.SELECT_NEW
            Case "C"
                Return qmsCorrection.RESELECT
        End Select
    End Function

    Public Shared Function IsCorrectionInputLetter(ByVal inputLetter As String) As Boolean
        Select Case inputLetter.ToUpper
            Case "A", "B", "C"
                Return True
            Case Else
                Return False
        End Select

    End Function

#End Region

#Region "Read HTML Responses"
    Public Function ReadWebResponse(ByVal r As Web.HttpRequest) As Boolean
        _HttpRequest = r

        If Not IsDBNull(_drScriptScreen.Item("SurveyQuestionID")) Then
            If VerifyResponse(r) Then
                'update responses
                If Me._Correction = qmsInterviewMode.InputResponse Then
                    Return WriteResponse(r)
                Else
                    Return WriteCorrection(r)
                End If

            Else
                Return False

            End If

        End If

        Return True

    End Function

    Private Function VerifyResponse(ByRef r As Web.HttpRequest) As Boolean
        If Me._Correction = qmsInterviewMode.InputCorrection Then
            'read correction
            If IsNumeric(r.Item(CORRECTION_FIELD_NAME)) Then
                Select Case CType(r.Item(CORRECTION_FIELD_NAME), qmsCorrection)
                    Case qmsCorrection.SELECT_OLD
                        'log correction and exit
                        Respondent.InsertEvent(qmsEvents.VERIFY_CORRECT_OLD, _iUserID, _drScriptScreen.ScriptScreenID.ToString)
                        Return True

                    Case qmsCorrection.SELECT_NEW
                        'log correction, continue to save responses
                        Respondent.InsertEvent(qmsEvents.VERIFY_CORRECT_NEW, _iUserID, _drScriptScreen.ScriptScreenID.ToString)
                        Return True

                    Case Else
                        'exit, re-display screen
                        Me._Correction = qmsInterviewMode.InputResponse
                        Return False

                End Select


            Else
                ErrorMsg = "You must make a correction.<br>Your entry does not match previous data entry. Please make a correction:"
                Return False

            End If

        ElseIf _iInputModeID = qmsInputMode.VERIFY Then
            'verify data entry
            If Not CheckVerification(r) Then
                _Correction = qmsInterviewMode.InputCorrection
                ErrorMsg = "Your entry does not match previous data entry. Please make a correction:"
                Return False

            End If

        End If

        Return True

    End Function

    Private Function CheckVerification(ByRef r As Web.HttpRequest) As Boolean
        Dim drCategory As DataRow
        Dim drResponses() As DataRow
        Dim arResponses() As String
        Dim iAnswerValue As Integer
        Dim Category As clsCategoryType
        Dim QuestionType As qmsQuestionTypes = CType(_drScriptScreen.Item("QuestionTypeID"), qmsQuestionTypes)

        arResponses = Split(r.Item(RESPONSE_FIELD_NAME), ",")

        For Each drCategory In _drScriptScreenCategories
            iAnswerValue = CInt(drCategory.Item("AnswerValue"))

            'get verification responses
            Category = clsCategoryTypeFactory.Create(CType(drCategory.Item("AnswerCategoryTypeID"), qmsAnswerCategoryTypes), QuestionType)
            Category.ReadResponse(r, drCategory)

            'get responses
            drResponses = GetResponses(drCategory)

            'compare responses
            If drResponses.Length > 0 Then
                'data entry has response, does verification?
                If Category.Selected Then
                    'do response text match?
                    If DMI.clsUtil.DeNull(drResponses(0).Item("ResponseText")).ToString.ToUpper <> _
                      Category.AnswerText.ToString.ToUpper Then
                        'answer text does not match
                        Return False

                    End If
                Else
                    'no verification response
                    Return False

                End If

            Else
                'data entry does not have response, does verification
                If Category.Selected Then
                    Return False

                End If
            End If
            Category = Nothing

        Next

        'verification matches data entry
        Return True

    End Function

    Private Function WriteResponse(ByRef r As Web.HttpRequest) As Boolean
        Dim drCategory As DataRow
        Dim Category As clsCategoryType
        Dim QuestionType As qmsQuestionTypes = CType(_drScriptScreen.Item("QuestionTypeID"), qmsQuestionTypes)
        Dim drResponses() As DataRow
        Dim bCategoryValid As Boolean = True

        For Each drCategory In _drScriptScreenCategories
            'check for response to category
            Category = clsCategoryTypeFactory.Create(CType(drCategory.Item("AnswerCategoryTypeID"), qmsAnswerCategoryTypes), QuestionType)
            If Not Category.ReadResponse(r, drCategory) Then
                'invalid response found
                bCategoryValid = False
                Me.ErrorMsg &= Category.ErrorMsg
            End If
            'get responses
            drResponses = GetResponses(drCategory)
            If Category.Selected Then
                'answer category selected
                If drResponses.Length > 0 Then
                    'response already exists, update
                    If drResponses(0).Item("ResponseText").ToString <> Category.AnswerText Then
                        drResponses(0).Item("ResponseText") = Category.AnswerText
                        drResponses(0).Item("UserID") = Me.UserID

                    End If
                Else
                    'new response, insert
                    NewResponse(drCategory, Category.AnswerText)

                End If
            Else
                'answer category was not selected
                If drResponses.Length > 0 Then
                    'response already exists, delete
                    drResponses(0).Delete()
                End If

            End If
            Category = Nothing

        Next

        Return bCategoryValid

    End Function

    Private Function WriteCorrection(ByRef r As Web.HttpRequest) As Boolean
        Me._Correction = qmsInterviewMode.InputResponse

        If CType(r.Item(CORRECTION_FIELD_NAME), qmsCorrection) = qmsCorrection.SELECT_NEW Then
            Return WriteResponse(r)

        End If

        Return True

    End Function

    Private Sub NewResponse(ByVal drCategory As DataRow, ByVal ResponseText As String)
        Dim drResponse As dsInterview.ResponsesRow

        drResponse = CType(Responses.NewMainRow, dsInterview.ResponsesRow)
        drResponse.RespondentID = RespondentID
        drResponse.SurveyQuestionID = 0   'this will be updated when saved to db
        drResponse.AnswerCategoryID = CInt(drCategory.Item("AnswerCategoryID"))
        drResponse.ResponseText = DMI.clsUtil.DeNull(ResponseText).ToString
        drResponse.UserID = Me.UserID

        Responses.AddMainRow(drResponse)

    End Sub

    Private Function GetResponses(ByVal drCategory As DataRow) As DataRow()
        Return Responses.MainDataTable.Select(String.Format("AnswerCategoryID = {0}", drCategory.Item("AnswerCategoryID")))

    End Function
#End Region

#Region "Navigate Script"
    Public Function NextScreen() As Integer
        Dim i As Integer = 0

        If ScreenIndex >= ScriptScreens.MainDataTable.Rows.Count Then
            'reached end of script
            ScreenIndex = 0

        ElseIf CInt(Script.MainDataTable.Rows(0).Item("FollowSkips")) = 1 Then   'And Me._iInputModeID <> qmsInputMode.VERIFY Then
            'check for jump
            i = CInt(CurrentScreen.Item("JumpIndex"))

            If i > ScriptScreens.MainDataTable.Rows.Count Then
                'jump passed end of script
                ScreenIndex = 0

            ElseIf i <= 0 Then
                'exit code, exit survey
                ScreenIndex = 0

            Else
                'jump to screen
                ScreenIndex = i

            End If

        Else
            'go to next screen
            ScreenIndex += 1

        End If

        Return ScreenIndex

    End Function

    Public Function PreviousScreen() As Integer
        ScreenIndex -= 1
        Return ScreenIndex

    End Function

    Public Property ScriptScreenID() As Integer
        Get
            Return ScriptScreens.LookupScreenID(_iScreenIndex)

        End Get
        Set(ByVal Value As Integer)
            ScreenIndex = ScriptScreens.LookupScreenIndex(Value)

        End Set
    End Property

    Public Property ScreenIndex() As Integer
        Get
            Return _iScreenIndex

        End Get
        Set(ByVal Value As Integer)
            _iScreenIndex = Value
            _drScriptScreen = CType(ScriptScreens.FindScreenRowByIndex(_iScreenIndex), dsInterview.ScriptScreensRow)
            If IsNothing(_drScriptScreen) Then
                _iScreenIndex = -1
                _drScriptScreenCategories = Nothing

            Else
                _drScriptScreenCategories = _drScriptScreen.GetChildRows("ScriptScreensScriptScreenCategories")

            End If


        End Set
    End Property

    Public Function CurrentScreen() As DataRow
        If IsNothing(_drScriptScreen) Then ScreenIndex = _iScreenIndex
        Return _drScriptScreen

    End Function

    Private Function CheckTriggerJump(ByVal ScreenIndex As Integer, ByVal PostScreen As Boolean) As Integer
        Dim iScreenIndex As Integer = ScreenIndex
        Dim iScriptScreenID As Integer = ScriptScreens.LookupScreenID(ScreenIndex)
        Dim sResult As String

        'check for triggers 
        If PostScreen Then
            sResult = ScriptTriggers.TriggerPostScreen(iScriptScreenID, Me.RespondentID)

        Else
            sResult = ScriptTriggers.TriggerPreScreen(iScriptScreenID, Me.RespondentID)

        End If
        'If Me.ScreenIndex = ScreenIndex Then
        'check results for jump
        If sResult.Length > 0 Then iScreenIndex = ScreenIndexJumpCommand(iScreenIndex, sResult)
        If iScreenIndex > ScreenIndex Then iScreenIndex = CheckTriggerJump(iScreenIndex, False)

        Return iScreenIndex

    End Function

    Private Function NextJump(ByVal ScreenIndex As Integer, ByVal PostScreen As Boolean) As Integer
        Dim dr As DataRow = ScriptScreens.FindScreenRowByIndex(ScreenIndex)
        Dim iScriptScreenID As Integer = CInt(dr.Item("ScriptScreenID"))
        Dim iScreenIndex As Integer
        Dim iScreenIndex2 As Integer
        Dim bExit As Boolean = False

        'check trigger jump (pre or post screen)
        iScreenIndex = CheckTriggerJump(ScreenIndex, PostScreen)
        If iScreenIndex < 0 Then bExit = True

        'set defaults
        If PostScreen Then
            '*** leaving screen ***
            'go to next screen?
            If iScreenIndex < ScreenIndex + 1 Then iScreenIndex = ScreenIndex + 1
            'run simple response jump"
            iScreenIndex2 = ScreenJumpToIndex(dr)
            'check simple response jump or exit
            If iScreenIndex2 < 0 Then bExit = True
            If iScreenIndex < iScreenIndex2 Then iScreenIndex = iScreenIndex2
        Else
            '*** entering screen ***
            'if no pre-screen trigger jump, stay on entering screen
            If iScreenIndex < ScreenIndex Then iScreenIndex = ScreenIndex

        End If
        If bExit Then iScreenIndex = -999
        dr = Nothing

        'check for pre-screen trigger jump on next screen, if jumped forward and not pass end of script
        If iScreenIndex > ScreenIndex And iScreenIndex <= ScriptScreens.MainDataTable.Rows.Count Then iScreenIndex = NextJump(iScreenIndex, False)

        Return iScreenIndex

    End Function

    Private Function ScreenIndexJumpCommand(ByVal ScreenIndex As Integer, ByVal sCommand As String) As Integer
        Dim rx As Text.RegularExpressions.Regex
        Dim sResult As String

        Select Case sCommand.Trim.ToUpper
            Case "EXIT"
                Return -999

            Case "END"
                Return ScriptScreens.MainDataTable.Rows.Count + 1

            Case "NEXT"
                Return ScreenIndex + 1

            Case Else
                sResult = rx.Replace(sCommand, "([\w]+)\(([\w]+)\)", New System.Text.RegularExpressions.MatchEvaluator(AddressOf JumpCommand))
                'do not let the script change occur unless we are on the currrent screen
                If Me.ScreenIndex <> ScreenIndex Then Me._JumpToScriptID = -1
                If IsNumeric(sResult) Then Return CInt(sResult)

        End Select

        Return ScreenIndex

    End Function

    Private Function JumpCommand(ByVal m As System.Text.RegularExpressions.Match) As String
        Dim sCmdName As String = m.Groups(1).ToString.ToUpper.Trim
        Dim sCmdParam As String = m.Groups(2).ToString

        If IsNumeric(sCmdParam) Then
            Select Case sCmdName
                Case "SCREENINDEX"
                    Return sCmdParam

                Case "SCREENID"
                    Return ScriptScreens.LookupScreenID(CInt(sCmdParam)).ToString

                Case "SCRIPT"
                    If IsNumeric(sCmdParam) Then
                        _JumpToScriptID = CInt(sCmdParam)
                        Return "0"

                    End If

            End Select
        End If

        Return "0"

    End Function

#End Region

#Region "Start and End script methods"
    Private Sub LogStart()
        Dim im As QMS.IInputMode

        im = QMS.clsInputMode.Create(InputMode)
        If im.StartEventID <> QMS.qmsEvents.NONE Then
            If IsNothing(DBTransaction) Then
                Respondent.InsertEvent(_oConn, CInt(im.StartEventID), UserID, RespondentID, ScriptID.ToString)
            Else
                Respondent.InsertEvent(DBTransaction, CInt(im.StartEventID), UserID, RespondentID, ScriptID.ToString)
            End If
        End If
        im = Nothing

    End Sub

    Private Sub LogEnd()
        Dim im As QMS.IInputMode

        im = QMS.clsInputMode.Create(InputMode)
        If im.EndEventID <> QMS.qmsEvents.NONE Then
            If IsNothing(DBTransaction) Then
                Respondent.InsertEvent(_oConn, CInt(im.EndEventID), UserID, RespondentID, ScriptID.ToString)
            Else
                Respondent.InsertEvent(DBTransaction, CInt(im.EndEventID), UserID, RespondentID, ScriptID.ToString)
            End If

        End If
        im = Nothing

    End Sub

    Public Sub StartInterview()
        LogStart()
        ScriptTriggers.TriggerPreScript(RespondentID)

    End Sub

    Public Sub EndInterview()
        LogEnd()
        ScriptTriggers.TriggerPostScript(RespondentID)

    End Sub

#End Region

#Region "Script Status"
    Public Function ScriptStatusHTML() As String
        Dim drvScreen As DataRowView
        Dim dvScreens As DataView = ScriptScreens.MainDataTable.DefaultView
        Dim sbTable As New Text.StringBuilder
        Const MAX_COLS As Integer = 20

        dvScreens.Sort = "ItemOrder"
        For Each drvScreen In dvScreens

            If CInt(drvScreen.Item("ItemOrder")) Mod MAX_COLS = 1 Then
                'close previous row
                If sbTable.Length > 0 Then sbTable.Append("</tr>")
                'start new row
                sbTable.Append("<tr>")

            End If

            'add cell
            sbTable.AppendFormat("<td title=""{0}"" ", drvScreen.Item("Title"))
            'apply cell format
            If CInt(drvScreen.Item("ItemOrder")) = ScreenIndex Then
                'current cell
                sbTable.Append("class=""pagecell4"">")
            Else
                Select Case CType(drvScreen.Item("Status"), qmsScreenStatus)
                    Case qmsScreenStatus.ANSWERED
                        sbTable.Append("class=""pagecell2"">")
                    Case qmsScreenStatus.NO_ANSWER, qmsScreenStatus.SKIPPED_ILLEGAL
                        sbTable.Append("class=""pagecell1"">")
                    Case qmsScreenStatus.SKIPPED_LEGAL
                        sbTable.Append("class=""pagecell3"">")
                    Case Else
                        sbTable.Append("class=""pagecell5"">")
                End Select

            End If
            'add cell link
            sbTable.AppendFormat("<a href=""?{0}={1}&{2}={3}&{4}={5}&{6}={7}"">{7}</a></td>", _
             RESPONDENT_ID_KEY, RespondentID, SCRIPT_ID_KEY, ScriptID, INPUTMODE_ID_KEY, CInt(InputMode), _
             SCREEN_INDEX_KEY, drvScreen.Item("ItemOrder"))

        Next

        'add last filler cells
        If CInt(drvScreen.Item("ItemOrder")) Mod MAX_COLS > 0 Then
            sbTable.AppendFormat("<td colspan=""{0}"">&nbsp;</td>", _
             MAX_COLS - (CInt(drvScreen.Item("ItemOrder")) Mod MAX_COLS))

        End If
        'close last row
        sbTable.Append("</tr>")

        'wrap table tags
        sbTable.Insert(0, "<table cellspacing=""1"" cellpadding=""0"" border=""0"" style=""border-width:0px;width:100%;"">")
        sbTable.Append("</table>")

        Return sbTable.ToString

    End Function

    Public Sub UpdateScreenStatus(Optional ByVal UpdateFromIndex As Integer = 0)
        Dim drvScreen As DataRowView
        Dim dvScreens As DataView = ScriptScreens.MainDataTable.DefaultView
        Dim iJumpToIndex As Integer
        Dim iGoToIndex As Integer = 0
        Dim iScreenIndex As Integer

        dvScreens.Sort = "ItemOrder"

        'loop thru each screen
        For Each drvScreen In dvScreens
            iScreenIndex = CInt(drvScreen("ItemOrder"))

            'update status of screen?
            If iScreenIndex >= UpdateFromIndex Then
                'check pre-screen trigger jump
                If iScreenIndex >= iGoToIndex Then iJumpToIndex = NextJump(iScreenIndex, False)

                'Is screen associated with a survey question
                If Not IsDBNull(drvScreen.Item("SurveyQuestionID")) Then
                    '*** question screens
                    If HasResponse(drvScreen.Row) AndAlso Not IsMultimarked(drvScreen.Row) AndAlso Not IsMissing(drvScreen.Row) Then
                        'screen has been answered...
                        drvScreen.Item("Status") = CInt(qmsScreenStatus.ANSWERED)

                    Else
                        'screen has not been answered...
                        If CInt(drvScreen.Item("CalculationTypeID")) = CInt(qmsCalculationTypes.REQUIRED_SCREEN) Then
                            'and screen is required. So not appropriately skipped
                            drvScreen.Item("Status") = CInt(qmsScreenStatus.SKIPPED_ILLEGAL)

                        ElseIf CInt(drvScreen.Item("ItemOrder")) < iGoToIndex Or CInt(drvScreen.Item("ItemOrder")) < iJumpToIndex Then
                            'but appropriately skipped
                            drvScreen.Item("Status") = CInt(qmsScreenStatus.SKIPPED_LEGAL)

                        ElseIf IsMultimarked(drvScreen.Row) Then
                            'screen answered inappropriately with multiple marks...
                            drvScreen.Item("Status") = CInt(qmsScreenStatus.MULTIMARKED)

                        ElseIf IsMissing(drvScreen.Row) Then
                            'screen marked as missing...
                            drvScreen.Item("Status") = CInt(qmsScreenStatus.MISSING)

                        Else
                            'no answer
                            drvScreen.Item("Status") = CInt(qmsScreenStatus.NO_ANSWER)

                        End If

                    End If
                Else
                    '*** non-question screen, always legally skipped
                    drvScreen.Item("Status") = CInt(qmsScreenStatus.SKIPPED_LEGAL)

                End If

            End If

            'check for next screen
            iJumpToIndex = NextJump(iScreenIndex, True)
            'check if jump value overrides current jump
            If iJumpToIndex > iGoToIndex Then iGoToIndex = iJumpToIndex
            'save jump index for screen
            drvScreen.Item("JumpIndex") = iJumpToIndex

        Next

    End Sub

    Private Function ScreenJumpToIndex(ByVal drScreen As DataRow) As Integer
        Dim drCategories() As DataRow
        Dim drResponses() As DataRow
        Dim drCategory As DataRow
        Dim iScriptScreenID As Integer
        Dim iScreenIndex As Integer = 0

        drCategories = drScreen.GetChildRows("ScriptScreensScriptScreenCategories")

        For Each drCategory In drCategories
            If CType(drCategory.Item("AnswerCategoryTypeID"), qmsAnswerCategoryTypes) <> qmsAnswerCategoryTypes.MultiMark Then
                drResponses = GetResponses(drCategory)
                If drResponses.Length > 0 Then
                    If Not IsDBNull(drCategory.Item("JumpToScriptScreenID")) Then
                        iScriptScreenID = CInt(drCategory.Item("JumpToScriptScreenID"))
                    Else
                        iScriptScreenID = 0
                    End If
                    If iScriptScreenID > 0 Then
                        'jump to screen
                        iScreenIndex = ScriptScreens.LookupScreenIndex(iScriptScreenID)
                    ElseIf iScriptScreenID = -999 Then
                        'go to end of survey
                        iScreenIndex = ScriptScreens.MainDataTable.Rows.Count + 1
                    ElseIf iScriptScreenID < 0 Then
                        'exit survey
                        iScreenIndex = iScriptScreenID
                    End If
                End If

            End If
        Next

        Return iScreenIndex

    End Function

    Private Function HasResponse(ByVal drScreen As DataRow) As Boolean
        Dim drCategories() As DataRow
        Dim drResponses() As DataRow
        Dim drCategory As DataRow
        Dim dtResponses As DataTable = _ds.Tables("Responses")

        drCategories = drScreen.GetChildRows("ScriptScreensScriptScreenCategories")

        For Each drCategory In drCategories
            If CType(drCategory.Item("AnswerCategoryTypeID"), qmsAnswerCategoryTypes) <> qmsAnswerCategoryTypes.MultiMark Then
                'drResponses = drCategory.GetChildRows("ScriptScreenCategoriesResponses")
                drResponses = GetResponses(drCategory)
                If drResponses.Length > 0 Then Return True

            End If
        Next

        Return False

    End Function

    Private Function IsMultimarked(ByVal drScreen As DataRow) As Boolean
        Dim drCategories() As DataRow
        Dim drResponses() As DataRow
        Dim drCategory As DataRow

        drCategories = drScreen.GetChildRows("ScriptScreensScriptScreenCategories")

        For Each drCategory In drCategories
            If CType(drCategory.Item("AnswerCategoryTypeID"), qmsAnswerCategoryTypes) = qmsAnswerCategoryTypes.MultiMark Then
                drResponses = GetResponses(drCategory)
                If drResponses.Length > 0 Then Return True

            End If
        Next

        Return False

    End Function

    Private Function IsMissing(ByVal drScreen As DataRow) As Boolean
        Dim drCategories() As DataRow
        Dim drResponses() As DataRow
        Dim drCategory As DataRow

        drCategories = drScreen.GetChildRows("ScriptScreensScriptScreenCategories")

        For Each drCategory In drCategories
            If CType(drCategory.Item("AnswerCategoryTypeID"), qmsAnswerCategoryTypes) = qmsAnswerCategoryTypes.Missing Then
                drResponses = GetResponses(drCategory)
                If drResponses.Length > 0 Then Return True

            End If
        Next

        Return False

    End Function

#End Region

#Region "Completeness Calculations"
    Public Sub Score(Optional ByVal updateScore As Boolean = False)
        If CInt(Script.MainDataTable.Rows(0).Item("CalcCompleteness")) = 1 Then
            Dim drvScreen As DataRowView
            Dim dvScreens As DataView = ScriptScreens.MainDataTable.DefaultView
            Dim iNumerator As Integer = 0
            Dim iDenominator As Integer = 0
            Dim dblScore As Double = 0.0

            dvScreens.Sort = "ItemOrder"

            For Each drvScreen In dvScreens
                If Not IsDBNull(drvScreen.Item("SurveyQuestionID")) Then
                    Select Case CType(drvScreen.Item("CalculationTypeID"), qmsCalculationTypes)
                        Case qmsCalculationTypes.REQUIRED_SCREEN
                            Select Case CType(drvScreen.Item("Status"), qmsScreenStatus)
                                Case qmsScreenStatus.MULTIMARKED, qmsScreenStatus.NO_ANSWER, qmsScreenStatus.SKIPPED_ILLEGAL, qmsScreenStatus.SKIPPED_LEGAL, qmsScreenStatus.MISSING
                                    'all requires must be answered, otherwise survey is incomplete
                                    'set completeness score to zero and exit calculation
                                    iNumerator = 0
                                    iDenominator = 1
                                    Exit For

                                Case qmsScreenStatus.ANSWERED
                                    'count answer for required screen
                                    iNumerator += 1
                                    iDenominator += 1
                            End Select

                        Case qmsCalculationTypes.OPTIONAL_SCREEN
                            Select Case CType(drvScreen.Item("Status"), qmsScreenStatus)
                                Case qmsScreenStatus.ANSWERED, qmsScreenStatus.SKIPPED_LEGAL
                                    'count answer for optional screen
                                    iNumerator += 1
                                    iDenominator += 1

                                Case qmsScreenStatus.MULTIMARKED, qmsScreenStatus.NO_ANSWER, qmsScreenStatus.SKIPPED_ILLEGAL, qmsScreenStatus.MISSING
                                    'count against completeness
                                    iDenominator += 1

                            End Select

                        Case qmsCalculationTypes.EXCLUDED_SCREEN
                            'Do nothing, excluded from scoring

                    End Select

                End If

            Next

            If iDenominator = 0 Then iDenominator = 1
            dblScore = (iNumerator / iDenominator) * 100
            LogScore(CInt(dblScore), updateScore)

        End If

    End Sub

    Private Sub LogScore(ByVal CompletenessScore As Integer, Optional ByVal updateScore As Boolean = False)
        Dim cc As QMS.qmsEvents = qmsEvents.NONE
        Dim r As QMS.clsRespondents
        Dim iCompleteLevel As Integer

        iCompleteLevel = CInt(Script.MainDataTable.Rows(0).Item("CompletenessLevel"))

        If iCompleteLevel <= CompletenessScore Then
            'Survey complete
            If InputMode = qmsInputMode.VIEW Then
                updateScore = True
                cc = GetCompleteCode(clsInputMode.LastInputMode(Me._oConn, RespondentID))
            Else
                cc = GetCompleteCode(InputMode)
            End If

        Else
            'Survey incomplete
            If InputMode = qmsInputMode.VIEW Then
                updateScore = True
                cc = GetIncompleteCode(clsInputMode.LastInputMode(Me._oConn, RespondentID))
            Else
                cc = GetIncompleteCode(InputMode)
            End If

        End If

        If cc <> qmsEvents.NONE Then
            If Not updateScore Then
                If IsNothing(DBTransaction) Then
                    r.ClearCompleteness(Me._oConn, RespondentID)
                    r.InsertEvent(Me._oConn, CInt(cc), UserID, RespondentID, CompletenessScore.ToString("0.0"))
                Else
                    r.ClearCompleteness(DBTransaction, RespondentID)
                    r.InsertEvent(DBTransaction, CInt(cc), UserID, RespondentID, CompletenessScore.ToString("0.0"))
                End If
            Else
                If IsNothing(DBTransaction) Then
                    UpdateRespondentScore(Me._oConn, RespondentID, CompletenessScore, CInt(cc))
                Else
                    UpdateRespondentScore(DBTransaction, RespondentID, CompletenessScore, CInt(cc))
                End If

            End If

        End If

    End Sub

    Private Sub UpdateRespondentScore(ByVal connection As SqlClient.SqlConnection, ByVal respondentID As Integer, ByVal score As Integer, ByVal eventID As Integer)
        Dim sql As New Text.StringBuilder

        sql.AppendFormat("UPDATE EventLog SET EventParameters = '{0}', ", score.ToString("0.0"))
        sql.AppendFormat("EventID = {0} ", eventID)
        sql.AppendFormat("WHERE RespondentID = {0} AND EventID IN (3000, 3001, 3002, 3010, 3011, 3012, 3020, 3021, 3022, 3030, 3031, 3032, 3033, 3035)", respondentID)

        SqlHelper.ExecuteNonQuery(connection, CommandType.Text, sql.ToString)

    End Sub

    Private Sub UpdateRespondentScore(ByVal trans As SqlClient.SqlTransaction, ByVal respondentID As Integer, ByVal score As Integer, ByVal eventID As Integer)
        Dim sql As New Text.StringBuilder

        sql.AppendFormat("UPDATE EventLog SET EventParameters = '{0}', ", score.ToString("0.0"))
        sql.AppendFormat("EventID = {0} ", eventID)
        sql.AppendFormat("WHERE RespondentID = {0} AND EventID IN (3000, 3001, 3002, 3010, 3011, 3012, 3020, 3021, 3022, 3030, 3031, 3032, 3033, 3035)", respondentID)

        SqlHelper.ExecuteNonQuery(trans, CommandType.Text, sql.ToString)

    End Sub

    Public Shared Function GetCompleteCode(ByVal inputMode As qmsInputMode) As qmsEvents
        'Survey complete
        Return clsInputMode.Create(inputMode).CompleteCodeID

    End Function

    Public Shared Function GetIncompleteCode(ByVal inputMode As qmsInputMode) As qmsEvents
        'Survey incomplete
        Return clsInputMode.Create(inputMode).IncompleteCodeID

    End Function

#End Region

End Class

#Region "Category Type Classes"
Public MustInherit Class clsCategoryType
    Protected _iQuestionTypeID As qmsQuestionTypes
    Protected _bDisplayResponses As Boolean = True
    Protected _iInputMode As qmsInputMode = qmsInputMode.VIEW
    Protected _bSelected As Boolean = False
    Protected _sAnswerText As String
    Protected _sErrMsg As String

    Public MustOverride ReadOnly Property AnswerCategoryTypeID() As qmsAnswerCategoryTypes
    Public MustOverride Function ToHTML(ByVal dr As DataRow) As String
    Public MustOverride Function ReadResponse(ByRef r As Web.HttpRequest, ByRef dr As DataRow) As Boolean

    Public Property QuestionTypeID() As qmsQuestionTypes
        Get
            Return _iQuestionTypeID

        End Get
        Set(ByVal Value As qmsQuestionTypes)
            _iQuestionTypeID = Value

        End Set
    End Property

    Public Property InputModeID() As qmsInputMode
        Get
            Return _iInputMode

        End Get
        Set(ByVal Value As qmsInputMode)
            _iInputMode = Value

        End Set
    End Property

    Public Property DisplayResponses() As Boolean
        Get
            Return _bDisplayResponses

        End Get
        Set(ByVal Value As Boolean)
            _bDisplayResponses = Value

        End Set
    End Property

    Public Property Selected() As Boolean
        Get
            Return _bSelected

        End Get
        Set(ByVal Value As Boolean)
            _bSelected = Value

        End Set
    End Property

    Public Property AnswerText() As String
        Get
            Return DMI.clsUtil.DeNull(_sAnswerText).ToString

        End Get
        Set(ByVal Value As String)
            _sAnswerText = Value

        End Set
    End Property

    Public Property ErrorMsg() As String
        Get
            Return _sErrMsg

        End Get
        Set(ByVal Value As String)
            _sErrMsg = Value

        End Set
    End Property

    Protected Function ContainsResponsesTable(ByRef dr As DataRow) As Boolean
        Return dr.Table.DataSet.Tables.Contains("Responses")

    End Function

    Protected Function ResponsesTable(ByRef dr As DataRow) As DataTable
        Return dr.Table.DataSet.Tables("Responses")

    End Function

    Protected Function AnswerValueSelected(ByVal r As System.Web.HttpRequest, ByVal answerValue As String) As Boolean
        Dim response() As String = Split(r.Item(clsInterview.RESPONSE_FIELD_NAME), ",")
        Return (Array.IndexOf(response, answerValue) >= 0)

    End Function

    Protected Function GetAnswerText(ByVal r As System.Web.HttpRequest, ByVal answerValue As String) As String
        Return DMI.clsUtil.DeNull(r.Item(String.Format("OA{0}", answerValue))).ToString()

    End Function

End Class

Public Class clsCategoryTypeFactory
    Public Shared Function Create(ByVal AnswerCategoryType As qmsAnswerCategoryTypes, ByVal QuestionType As qmsQuestionTypes) As clsCategoryType
        Select Case AnswerCategoryType
            Case qmsAnswerCategoryTypes.SelectItem, qmsAnswerCategoryTypes.MultiMark, qmsAnswerCategoryTypes.Missing
                Return New clsCategorySelect(QuestionType)

            Case qmsAnswerCategoryTypes.SelectOpenAnswer
                Return New clsCategoryOpenAnswer(QuestionType)

            Case qmsAnswerCategoryTypes.OpenAnswer
                Return New clsCategoryOpenAnswer(QuestionType)

            Case qmsAnswerCategoryTypes.Year
                Return New clsCategoryYear(QuestionType)

            Case qmsAnswerCategoryTypes.TwoDigits
                Return New clsCategoryTwoDigits(QuestionType)

            Case qmsAnswerCategoryTypes.Numeric
                Return New clsCategoryNumeric(QuestionType)

            Case Else
                Return New clsCategorySelect(QuestionType)

        End Select

    End Function

End Class

#Region "Category Type Classes"
Public Class clsCategorySelect
    Inherits clsCategoryType

    Public Sub New(ByVal QuestionType As qmsQuestionTypes)
        Me.QuestionTypeID = QuestionType

    End Sub

    Public Overrides ReadOnly Property AnswerCategoryTypeID() As qmsAnswerCategoryTypes
        Get
            Return qmsAnswerCategoryTypes.SelectItem

        End Get
    End Property

    Public Overrides Function ToHTML(ByVal dr As DataRow) As String
        Dim sbControl As New Text.StringBuilder
        Dim drResponse() As DataRow = {}

        'get responses
        If _bDisplayResponses AndAlso ContainsResponsesTable(dr) Then drResponse = Me.ResponsesTable(dr).Select(String.Format("AnswerCategoryID = {0}", dr.Item("AnswerCategoryID")))

        Select Case QuestionTypeID
            Case qmsQuestionTypes.SingleSelect
                'radio button for single select question
                sbControl.AppendFormat("<input type=""radio"" name=""{0}"" ", clsInterview.RESPONSE_FIELD_NAME)
                sbControl.AppendFormat("id=""C{0}"" value=""{0}"" ", dr.Item("AnswerValue"))
                sbControl.Append("onClick=""checkRadio(this)"" ")
                'show response
                If drResponse.Length > 0 Then sbControl.Append("checked ")
                sbControl.Append(">")

            Case qmsQuestionTypes.MultipleSelect
                'checkbox for multiple select question
                sbControl.AppendFormat("<input type=""checkbox"" name=""{0}"" ", clsInterview.RESPONSE_FIELD_NAME)
                sbControl.AppendFormat("id=""C{0}"" value=""{0}"" ", dr.Item("AnswerValue"))
                'show response
                If drResponse.Length > 0 Then sbControl.Append("checked ")
                sbControl.Append(">")

            Case Else
                Return ""

        End Select

        'add control label
        sbControl.AppendFormat("&nbsp;{0}:&nbsp;<strong>{1}</strong>", dr.Item("AnswerValue"), dr.Item("Text"))
        Return sbControl.ToString

    End Function

    Public Overrides Function ReadResponse(ByRef r As System.Web.HttpRequest, ByRef dr As DataRow) As Boolean
        Selected = Me.AnswerValueSelected(r, dr.Item("AnswerValue").ToString)
        Return True

    End Function

End Class

Public Class clsCategoryOpenAnswer
    Inherits clsCategoryType

    Public Sub New(ByVal QuestionType As qmsQuestionTypes)
        Me.QuestionTypeID = QuestionType

    End Sub

    Public Overrides ReadOnly Property AnswerCategoryTypeID() As qmsAnswerCategoryTypes
        Get
            Return qmsAnswerCategoryTypes.OpenAnswer

        End Get
    End Property

    Public Overrides Function ToHTML(ByVal dr As DataRow) As String
        Dim sbControl As New Text.StringBuilder
        Dim drResponse() As DataRow = {}

        'get responses
        If _bDisplayResponses AndAlso ContainsResponsesTable(dr) Then drResponse = Me.ResponsesTable(dr).Select(String.Format("AnswerCategoryID = {0}", dr.Item("AnswerCategoryID")))

        Select Case QuestionTypeID
            Case qmsQuestionTypes.SingleSelect
                'radio button for single select question
                sbControl.AppendFormat("<input type=""radio"" name=""{0}"" ", clsInterview.RESPONSE_FIELD_NAME)
                sbControl.AppendFormat("id=""C{0}"" value=""{0}"" ", dr.Item("AnswerValue"))
                sbControl.Append("onClick=""checkRadio(this)"" ")
                'show response
                If drResponse.Length > 0 Then sbControl.Append("checked ")
                'add control label
                sbControl.AppendFormat(">&nbsp;{0}:&nbsp;<strong>{1}</strong>&nbsp;", dr.Item("AnswerValue"), dr.Item("Text"))

            Case qmsQuestionTypes.MultipleSelect
                'checkbox for multiple select question
                sbControl.AppendFormat("<input type=""checkbox"" name=""{0}"" ", clsInterview.RESPONSE_FIELD_NAME)
                sbControl.AppendFormat("id=""C{0}"" value=""{0}"" ", dr.Item("AnswerValue"))
                'show response if not in verify mode
                If drResponse.Length > 0 Then sbControl.Append("checked ")
                'add control label
                sbControl.AppendFormat(">&nbsp;{0}:&nbsp;<strong>{1}</strong>&nbsp;", dr.Item("AnswerValue"), dr.Item("Text"))

            Case qmsQuestionTypes.OpenAnswer
                'add hidden response field 
                sbControl.AppendFormat("<small>{0} {1}:</small><br>", dr.Item("AnswerValue"), dr.Item("Text"))
                'sbControl.AppendFormat("<input type=""hidden"" name=""{0}"" ", clsInterview.RESPONSE_FIELD_NAME)
                'sbControl.AppendFormat("id=""C{0}"" value=""{0}"">", dr.Item("AnswerValue"))

        End Select

        'add open answer textbox
        sbControl.AppendFormat("<input type=""text"" name=""OA{0}"" id=""OA{0}"" ", dr.Item("AnswerValue"))
        'show response text if not in verify mode
        If drResponse.Length > 0 Then sbControl.AppendFormat("value=""{0}"" ", drResponse(0).Item("ResponseText"))
        sbControl.Append("onFocus=""focusTextBox()"" onBlur=""focusTextBox()"">")

        Return sbControl.ToString

    End Function

    Public Overrides Function ReadResponse(ByRef r As System.Web.HttpRequest, ByRef dr As DataRow) As Boolean
        Select Case QuestionTypeID
            Case qmsQuestionTypes.OpenAnswer
                AnswerText = Me.GetAnswerText(r, dr.Item("AnswerValue").ToString)
                If AnswerText.Length > 0 Then
                    Selected = True
                    Return ValidateAnswerText(AnswerText)
                End If

                'not selected
                Selected = False
                AnswerText = ""
                Return True

            Case Else
                Selected = Me.AnswerValueSelected(r, dr.Item("AnswerValue").ToString)
                If Selected Then
                    AnswerText = Me.GetAnswerText(r, dr.Item("AnswerValue").ToString)
                    Return ValidateAnswerText(AnswerText)
                End If

                'not selected
                AnswerText = ""
                Return True


        End Select

    End Function

    Protected Overridable Function ValidateAnswerText(ByVal answerText As String) As Boolean
        Return True

    End Function
End Class

Public Class clsCategoryYear
    Inherits clsCategoryOpenAnswer

    Public Sub New(ByVal QuestionType As qmsQuestionTypes)
        MyBase.New(QuestionType)

    End Sub

    Public Overrides ReadOnly Property AnswerCategoryTypeID() As qmsAnswerCategoryTypes
        Get
            Return qmsAnswerCategoryTypes.Year

        End Get
    End Property

    Protected Overrides Function ValidateAnswerText(ByVal answerText As String) As Boolean
        Dim rx As Text.RegularExpressions.Regex

        If answerText.Length = 0 Then
            'can be blank
            Return True

        ElseIf rx.IsMatch(answerText, "^\d{4}$") Then
            'fits year format
            Return True

        Else
            Me.ErrorMsg = String.Format("""{0}"" is not a valid year. Value must be a four-digit year (YYYY).", answerText)
            Return False

        End If

    End Function
End Class

Public Class clsCategoryTwoDigits
    Inherits clsCategoryOpenAnswer

    Public Sub New(ByVal QuestionType As qmsQuestionTypes)
        MyBase.New(QuestionType)

    End Sub

    Public Overrides ReadOnly Property AnswerCategoryTypeID() As qmsAnswerCategoryTypes
        Get
            Return qmsAnswerCategoryTypes.TwoDigits

        End Get
    End Property

    Protected Overrides Function ValidateAnswerText(ByVal answerText As String) As Boolean
        Dim rx As Text.RegularExpressions.Regex

        If rx.IsMatch(answerText, "^\d{0,2}$") Then
            Return True

        Else
            Me.ErrorMsg = String.Format("""{0}"" is not a valid open answer. Open answer must be a no more than two-digits.", answerText)
            Return False

        End If

    End Function

End Class

Public Class clsCategoryNumeric
    Inherits clsCategoryOpenAnswer

    Public Sub New(ByVal QuestionType As qmsQuestionTypes)
        MyBase.New(QuestionType)

    End Sub

    Public Overrides ReadOnly Property AnswerCategoryTypeID() As qmsAnswerCategoryTypes
        Get
            Return qmsAnswerCategoryTypes.Numeric

        End Get
    End Property

    Protected Overrides Function ValidateAnswerText(ByVal answerText As String) As Boolean
        Dim rx As Text.RegularExpressions.Regex

        If rx.IsMatch(answerText, "^\d+$") Then
            Return True

        Else
            Me.ErrorMsg = String.Format("""{0}"" is not a valid open answer. Open answer must be numeric.", answerText)
            Return False

        End If

    End Function
End Class

#End Region

#End Region
