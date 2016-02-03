Option Explicit On
Option Strict On

Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports DMI
Imports System.Data.Common

Public Class clsInterviewLite
    Protected _Connection As SqlClient.SqlConnection
    Protected _Script As clsScripts
    Protected _ScriptScreen As clsScriptScreens
    Protected _ScriptScreenCategories As clsScriptScreenCategories
    Protected _Responses As clsResponses
    Protected _RespondentID As Integer
    Protected _ScriptID As Integer
    Protected _ScriptScreenID As Integer
    Protected _ScriptScreenIndex As Integer
    Protected _UserID As Integer
    Protected _InputMode As qmsInputMode = qmsInputMode.READ_ONLY
    Protected _InterviewMode As qmsInterviewMode = qmsInterviewMode.InputResponse
    Protected _JumpToScriptID As Integer
    Protected _ds As dsInterviewLite
    Protected _ErrorMsg As String = ""
    Protected _VerifyResponse As String
    Protected _KeyCount As Integer = 0

    Public Const SCRIPT_ID_KEY As String = "scr"
    Public Const RESPONDENT_ID_KEY As String = "rid"
    Public Const INPUTMODE_ID_KEY As String = "input"
    Public Const SCREEN_INDEX_KEY As String = "index"
    Public Const RESPONSE_FIELD_NAME As String = "response"
    Public Const CORRECTION_FIELD_NAME As String = "correction"

    Public Sub New(ByVal connection As SqlClient.SqlConnection)
        _Connection = connection
        _ds = New dsInterviewLite

    End Sub

    Protected Sub LoadData(ByVal respondentID As Integer, ByVal scriptID As Integer, ByVal screenIndex As Integer)
        Me._RespondentID = respondentID
        Me._ScriptID = scriptID
        Me._ScriptScreenIndex = screenIndex
        'SetScriptScreenIndex(screenIndex)

        FillScriptScreens()
        FillScriptScreenCategories()
        FillResponses()

    End Sub

    Public ReadOnly Property InputMode() As qmsInputMode
        Get
            Return _InputMode
        End Get
    End Property

    Public ReadOnly Property InterviewMode() As qmsInterviewMode
        Get
            Return _InterviewMode
        End Get
    End Property

    Public ReadOnly Property JumpToScriptID() As Integer
        Get
            Return _JumpToScriptID
        End Get
    End Property

    Public ReadOnly Property RespondentID() As Integer
        Get
            Return _RespondentID
        End Get
    End Property

    Public ReadOnly Property ScriptID() As Integer
        Get
            Return _ScriptID
        End Get
    End Property

    Public ReadOnly Property ScriptScreenID() As Integer
        Get
            Return _ScriptScreenID
        End Get
    End Property

    Public ReadOnly Property ScriptScreenIndex() As Integer
        Get
            Return _ScriptScreenIndex
        End Get
    End Property

    Public ReadOnly Property UserID() As Integer
        Get
            Return _UserID
        End Get
    End Property

    Private Property ErrorMsg() As String
        Get
            Return _ErrorMsg
        End Get
        Set(ByVal Value As String)
            _ErrorMsg = Value
        End Set
    End Property

    Public ReadOnly Property KeyCount() As Integer
        Get
            Return _KeyCount
        End Get
    End Property

    Protected ReadOnly Property Script() As clsScripts
        Get
            If IsNothing(_Script) Then
                _Script = New clsScripts(_Connection)
                _Script.MainDataTable = _ds.Scripts

            End If

            Return _Script

        End Get
    End Property

    Protected ReadOnly Property ScriptScreen() As clsScriptScreens
        Get
            If IsNothing(_ScriptScreen) Then
                _ScriptScreen = New clsScriptScreens(_Connection)
                _ScriptScreen.MainDataTable = _ds.ScriptScreens

            End If

            Return _ScriptScreen

        End Get
    End Property

    Protected ReadOnly Property ScriptScreenCategories() As clsScriptScreenCategories
        Get
            If IsNothing(_ScriptScreenCategories) Then
                _ScriptScreenCategories = New clsScriptScreenCategories(_Connection)
                _ScriptScreenCategories.MainDataTable = _ds.ScriptScreenCategories

            End If

            Return _ScriptScreenCategories

        End Get
    End Property

    Protected ReadOnly Property Responses() As clsResponses
        Get
            If IsNothing(_Responses) Then
                _Responses = New clsResponses(_Connection)
                _Responses.MainDataTable = _ds.Responses

            End If

            Return _Responses

        End Get
    End Property

    Private Sub FillScriptScreens()
        If ScriptID > 0 Then
            Dim ss As clsScriptScreens = ScriptScreen
            Dim dr As DataRow = ss.NewSearchRow

            dr.Item("ScriptID") = Me.ScriptID
            dr.Item("ItemOrder") = Me.ScriptScreenIndex
            ss.FillMain(dr)
            dr = Nothing
            Me._ScriptScreenID = Me.GetScreenInfo.ScriptScreenID

        End If

    End Sub

    Private Sub FillScriptScreenCategories()
        If ScriptScreenID > 0 Then
            Dim ssc As clsScriptScreenCategories = ScriptScreenCategories
            Dim dr As DataRow = ssc.NewSearchRow

            dr.Item("ScriptScreenID") = ScriptScreenID
            ssc.FillMain(dr)
            dr = Nothing

        End If

    End Sub

    Private Sub FillResponses()
        If RespondentID > 0 AndAlso ScriptScreenID > 0 Then
            Dim r As clsResponses = Responses
            Dim screen As dsInterviewLite.ScriptScreensRow = Me.GetScreenInfo()

            r.ClearMainTable()

            If Not screen.IsSurveyQuestionIDNull Then
                Dim dr As DataRow = r.NewSearchRow

                dr.Item("RespondentID") = RespondentID
                dr.Item("SurveyQuestionID") = screen.SurveyQuestionID
                r.FillMain(dr)
                dr = Nothing

            End If

        End If

    End Sub

    Public Sub StartInterview(ByVal inputModeID As Integer, ByVal userID As Integer, ByVal respondentID As Integer, ByVal scriptID As Integer)
        Me._InputMode = CType(inputModeID, qmsInputMode)
        Me._UserID = userID
        Me._ScriptID = scriptID
        Me._RespondentID = respondentID
        If Me.InputMode = qmsInputMode.TEST Then respondentID = SetupTestMode(scriptID)
        LogStart(inputModeID, userID, respondentID, scriptID)
        'run pre-script trigger
        If _InputMode <> qmsInputMode.READ_ONLY Then
            RunStartScriptTrigger()
        End If
        'run pre-screen trigger
        Dim screenIndex As Integer = InitScreenIndex()
        Me.LoadData(respondentID, scriptID, screenIndex)

    End Sub

    Public Sub ExitInterview(ByVal inputModeID As Integer, ByVal userID As Integer, ByVal respondentID As Integer, ByVal scriptID As Integer, Optional ByVal scoreSurvey As Boolean = True)
        Me._InputMode = CType(inputModeID, qmsInputMode)
        Me._UserID = userID
        Me._ScriptID = scriptID
        Me._RespondentID = respondentID
        Me._KeyCount = 1
        If _InputMode <> qmsInputMode.READ_ONLY Then
            clsQMSTools.CleanRespondentResponses(Me._Connection, respondentID)
            If scoreSurvey Then Me.Score()
            EndInterview(scoreSurvey)
        End If

    End Sub

    Protected Sub EndInterview(ByVal bRunEndTrigger As Boolean)
        If _InputMode <> qmsInputMode.READ_ONLY Then
            If bRunEndTrigger Then
                RunEndScriptTrigger()
            End If
            LogEnd(Me.InputMode, Me.UserID, Me.RespondentID, Me.ScriptID)
            If Me.InputMode = qmsInputMode.TEST Then Me.CleanUpTestMode()

        End If

    End Sub

    Public Sub RunStartScriptTrigger()
        Dim st As New clsScriptTriggers(Me._Connection)
        st.RunScriptTrigger(UserID, RespondentID, PrePostTrigger.PRE, ScriptID)

    End Sub

    Public Sub RunEndScriptTrigger()
        Dim st As New clsScriptTriggers(Me._Connection)
        st.RunScriptTrigger(Me.UserID, Me.RespondentID, PrePostTrigger.POST, Me.ScriptID)

    End Sub

    Protected Sub EndInterview()
        EndInterview(True)
    End Sub

    Protected Sub LogStart(ByVal inputModeID As Integer, ByVal userID As Integer, ByVal respondentID As Integer, ByVal scriptID As Integer)
        If CType(inputModeID, qmsInputMode) <> qmsInputMode.READ_ONLY Then
            Dim im As QMS.IInputMode

            im = QMS.clsInputMode.Create(CType(inputModeID, qmsInputMode))
            If im.StartEventID <> QMS.qmsEvents.NONE Then clsRespondents.InsertEvent(_Connection, CInt(im.StartEventID), userID, respondentID, scriptID.ToString)
            im = Nothing

        End If

    End Sub

    Protected Sub LogEnd(ByVal inputModeID As Integer, ByVal userID As Integer, ByVal respondentID As Integer, ByVal scriptID As Integer)
        If CType(inputModeID, qmsInputMode) <> qmsInputMode.READ_ONLY Then
            Dim im As QMS.IInputMode

            im = QMS.clsInputMode.Create(CType(inputModeID, qmsInputMode))
            If im.EndEventID <> QMS.qmsEvents.NONE Then clsRespondents.InsertEvent(_Connection, CInt(im.EndEventID), userID, respondentID, scriptID.ToString)
            im = Nothing

        End If

    End Sub
    'TP 20090911 This method is used to save the current question when the user exits the script screen.
    Public Sub RecordAnswer(ByVal r As Web.HttpRequest, ByVal interviewModeID As Integer, ByVal inputModeID As Integer, ByVal userID As Integer, ByVal respondentID As Integer, ByVal scriptID As Integer, ByVal screenIndex As Integer)
        Me._InterviewMode = CType(interviewModeID, qmsInterviewMode)
        Me._InputMode = CType(inputModeID, qmsInputMode)
        Me._UserID = userID
        Me.LoadData(respondentID, scriptID, screenIndex)
        If ReadWebResponse(r) Then
            Dim iScreenIndex As Integer
            If _InputMode <> qmsInputMode.READ_ONLY Then Me.Responses.Save()
        End If
    End Sub
    Public Function NextScreen(ByVal r As Web.HttpRequest, ByVal interviewModeID As Integer, ByVal inputModeID As Integer, ByVal userID As Integer, ByVal respondentID As Integer, ByVal scriptID As Integer, ByVal screenIndex As Integer) As Integer
        Me._InterviewMode = CType(interviewModeID, qmsInterviewMode)
        Me._InputMode = CType(inputModeID, qmsInputMode)
        Me._UserID = userID
        Me.LoadData(respondentID, scriptID, screenIndex)

        If ReadWebResponse(r) Then
            Dim iScreenIndex As Integer
            If _InputMode <> qmsInputMode.READ_ONLY Then Me.Responses.Save()
            iScreenIndex = NextScreenIndex(Me.ScriptScreenIndex)
            If iScreenIndex > ScriptScreenCount() Then
                'gone past the end of the survey, score and exit
                'TP 20090911 only score if not data entry
                If _InputMode <> qmsInputMode.DATAENTRY Then
                    Me.Score()
                End If
                iScreenIndex = -999
            End If
            If iScreenIndex <= 0 Then
                'exit survey
                'TP 20090911
                If _InputMode <> qmsInputMode.DATAENTRY Then
                    Me.EndInterview(True)
                Else
                    Me.EndInterview(False)
                End If
                'Me.SetScriptScreenIndex(iScreenIndex)
                Me._ScriptScreenIndex = iScreenIndex
                Return iScreenIndex
            ElseIf Not (Me.JumpToScriptID > 0) Then
                'go to next screen
                LoadData(Me.RespondentID, Me.ScriptID, iScreenIndex)
            End If

        End If

        Return Me.ScriptScreenIndex

    End Function

    Protected Function NextScreenIndex(ByVal currentScreenIndex As Integer) As Integer

        If _InputMode = qmsInputMode.READ_ONLY Then Return currentScreenIndex + 1

        Dim jump As ScriptJumpHandler
        Dim result As ScriptAction = jump.GetJumpAction(Me._Connection, Me.RespondentID, Me.ScriptID, currentScreenIndex, Me.UserID, True, CBool(Me.GetScriptInfo.FollowSkips = 1))
        If result.ExitScript Then
            Return -99
        ElseIf result.GoToScriptID <> DMI.DataHandler.NULLRECORDID Then
            Me._JumpToScriptID = result.GoToScriptID
            Return result.GoToScreenIndex
        Else
            Return result.GoToScreenIndex
        End If
        'Return GetTriggerJump(currentScreenIndex, True)

    End Function

    Protected Function InitScreenIndex() As Integer

        If _InputMode = qmsInputMode.READ_ONLY Then Return 1

        Dim jump As ScriptJumpHandler
        Dim result As ScriptAction
        'this if is a hack to fix a bug where "non-follow skip" scripts start on the 2nd screen
        If (Me.GetScriptInfo.FollowSkips = 1) Then
            result = jump.GetJumpAction(Me._Connection, Me.RespondentID, Me.ScriptID, 1, Me.UserID, False, True)
        Else
            result = jump.GetJumpAction(Me._Connection, Me.RespondentID, Me.ScriptID, 0, Me.UserID, False, False)
        End If

        If result.ExitScript Then
            Return -99
        ElseIf result.GoToScriptID <> DMI.DataHandler.NULLRECORDID Then
            Me._JumpToScriptID = result.GoToScriptID
            Return result.GoToScreenIndex
        Else
            Return result.GoToScreenIndex
        End If
        'Return GetTriggerJump(currentScreenIndex, True)

    End Function

    Public Function PreviousScreen(ByVal r As Web.HttpRequest, ByVal interviewModeID As Integer, ByVal inputModeID As Integer, ByVal userID As Integer, ByVal respondentID As Integer, ByVal scriptID As Integer, ByVal screenIndex As Integer) As Integer
        Me._InterviewMode = CType(interviewModeID, qmsInterviewMode)
        Me._InputMode = CType(inputModeID, qmsInputMode)
        Me._UserID = userID
        Me.LoadData(respondentID, scriptID, screenIndex)

        If ReadWebResponse(r) Then
            Dim iScreenIndex As Integer
            Me.Responses.Save()
            iScreenIndex = Me.ScriptScreenIndex - 1

            If iScreenIndex > 0 Then
                LoadData(Me.RespondentID, Me.ScriptID, iScreenIndex)
            Else
                Return iScreenIndex
            End If

        End If

        Return Me.ScriptScreenIndex

    End Function

    Public Sub GoToScreen(ByVal inputModeID As Integer, ByVal userID As Integer, ByVal respondentID As Integer, ByVal scriptID As Integer, ByVal screenIndex As Integer)
        Me._InputMode = CType(inputModeID, qmsInputMode)
        Me._UserID = userID
        Me.LoadData(respondentID, scriptID, screenIndex)

    End Sub

    Public Sub GoToScreen(ByVal r As Web.HttpRequest, ByVal inputModeID As Integer, ByVal userID As Integer, ByVal respondentID As Integer, ByVal scriptID As Integer, ByVal currentScreenIndex As Integer, ByVal goToScreenIndex As Integer)
        Me._InputMode = CType(inputModeID, qmsInputMode)
        Me._UserID = userID
        Me.LoadData(respondentID, scriptID, currentScreenIndex)

        If ReadWebResponse(r) Then
            Dim iScreenIndex As Integer
            Me.Responses.Save()
            iScreenIndex = NextScreenIndex(Me.ScriptScreenIndex)
            If goToScreenIndex > 0 AndAlso goToScreenIndex <= Me.ScriptScreenCount Then
                LoadData(Me.RespondentID, Me.ScriptID, goToScreenIndex)
            Else
                Me._ErrorMsg = String.Format("Invalid screen index value. Screen index must be between 1 and {0}", Me.ScriptScreenCount)
            End If

        End If


    End Sub

    Protected Function ReadWebResponse(ByVal r As Web.HttpRequest) As Boolean
        If _InputMode <> qmsInputMode.READ_ONLY Then
            Dim screen As dsInterviewLite.ScriptScreensRow = Me.GetScreenInfo
            _KeyCount = 1
            If Not screen.IsSurveyQuestionIDNull Then
                If VerifyResponse(r, screen) Then
                    'update responses
                    If Me.InterviewMode = qmsInterviewMode.InputResponse AndAlso Not _InputMode = qmsInputMode.VERIFY Then
                        Return WriteResponse(r, screen, True)
                    ElseIf Me.InterviewMode = qmsInterviewMode.InputCorrection Then
                        Return WriteCorrection(r, screen)
                    End If

                Else
                    Return False

                End If

            End If

        End If

        Return True

    End Function

    Private Function VerifyResponse(ByRef r As Web.HttpRequest, ByVal screen As dsInterviewLite.ScriptScreensRow) As Boolean
        If Me.InterviewMode = qmsInterviewMode.InputCorrection Then
            Return Me.CheckCorrection(r, screen)

        ElseIf Me.InputMode = qmsInputMode.VERIFY Then
            If Not Me.CheckVerification(r, screen) Then
                Me.SaveVerificationResponse(r, screen)
                Me._InterviewMode = qmsInterviewMode.InputCorrection
                Me.ErrorMsg &= "Your entry does not match previous data entry. Please make a correction:"
                Return False
            End If

        End If

        Return True

    End Function

    Private Function CheckCorrection(ByRef r As Web.HttpRequest, ByVal screen As dsInterviewLite.ScriptScreensRow) As Boolean
        'read correction
        If IsNumeric(r.Item(CORRECTION_FIELD_NAME)) Then
            _KeyCount += 1
            Select Case CType(r.Item(CORRECTION_FIELD_NAME), qmsCorrection)
                Case qmsCorrection.SELECT_OLD
                    'log correction and exit
                    clsRespondents.InsertEvent(Me._Connection, CInt(qmsEvents.VERIFY_CORRECT_OLD), Me.UserID, Me.RespondentID, screen.ScriptScreenID.ToString)
                    Return True

                Case qmsCorrection.SELECT_NEW
                    'log correction, continue to save responses
                    clsRespondents.InsertEvent(Me._Connection, CInt(qmsEvents.VERIFY_CORRECT_NEW), Me.UserID, Me.RespondentID, screen.ScriptScreenID.ToString)
                    Return True

                Case Else
                    'exit, re-display screen
                    Me._InterviewMode = qmsInterviewMode.InputResponse
                    Return False

            End Select

        Else

            _KeyCount = 0
            Me.ErrorMsg &= "You must make a correction.<br>Your entry does not match previous data entry. Please make a correction:"
            Me.SaveVerificationResponse(r, screen)
            Return False

        End If

    End Function

    Private Function CheckVerification(ByRef r As Web.HttpRequest, ByVal screen As dsInterviewLite.ScriptScreensRow) As Boolean
        Dim drCategory As dsInterviewLite.ScriptScreenCategoriesRow
        Dim iAnswerValue As Integer
        Dim Category As clsCategoryType
        Dim QuestionType As qmsQuestionTypes = CType(screen.QuestionTypeID, qmsQuestionTypes)
        Dim result As Boolean = True

        'loop thru each answer category
        For Each drCategory In _ds.ScriptScreenCategories.Rows
            iAnswerValue = CInt(drCategory.Item("AnswerValue"))

            'get verification responses
            Category = clsCategoryTypeFactory.Create(CType(drCategory.AnswerCategoryTypeID, qmsAnswerCategoryTypes), QuestionType)
            Category.ReadResponse(r, CType(drCategory, DataRow))

            'add key count
            If Category.Selected Then _KeyCount += (1 + Category.AnswerText.Length)

            'does verification match existing response
            If Not Me.MatchResponse(drCategory.AnswerCategoryID, Category.Selected, Category.AnswerText) Then
                result = False
            End If

            Category = Nothing

        Next

        'verification matches data entry
        Return result

    End Function

    Protected Function MatchResponse(ByVal answerCategoryID As Integer, ByVal selected As Boolean, ByVal openAnswerText As String) As Boolean
        Dim dr As DataRow = CType(Responses.SelectRow(String.Format("AnswerCategoryID = {0}", answerCategoryID)), dsInterviewLite.ResponsesRow)

        If selected AndAlso Not IsNothing(dr) Then
            'selected and also in response
            If openAnswerText.ToUpper = dr.Item("ResponseText").ToString.ToUpper Then
                'open answer text matches too
                Return True
            End If
        ElseIf Not selected AndAlso IsNothing(dr) Then
            'not selected and not in response
            Return True
        End If

        Return False

    End Function

    Protected Function WriteCorrection(ByRef r As Web.HttpRequest, ByVal screen As dsInterviewLite.ScriptScreensRow) As Boolean
        Me._InterviewMode = qmsInterviewMode.InputResponse

        If CType(r.Item(CORRECTION_FIELD_NAME), qmsCorrection) = qmsCorrection.SELECT_NEW Then
            Dim iCurrentKeyCount As Integer = Me._KeyCount
            Dim bResult As Boolean = WriteResponse(r, screen)
            ' do not count keystrokes for write responses, this is a correction
            Me._KeyCount = iCurrentKeyCount
            Return bResult

        End If

        Return True

    End Function

    Private Function WriteResponse(ByRef r As Web.HttpRequest, ByVal screen As dsInterviewLite.ScriptScreensRow, Optional ByVal countKeys As Boolean = False) As Boolean
        Dim drCategory As dsInterviewLite.ScriptScreenCategoriesRow
        Dim Category As clsCategoryType
        Dim QuestionType As qmsQuestionTypes = CType(screen.QuestionTypeID, qmsQuestionTypes)
        Dim bCategoryValid As Boolean = True
        Dim errorMsg As New Text.StringBuilder

        For Each drCategory In _ds.ScriptScreenCategories.Rows
            'check for response to category
            Category = clsCategoryTypeFactory.Create(CType(drCategory.AnswerCategoryTypeID, qmsAnswerCategoryTypes), QuestionType)
            If Not Category.ReadResponse(r, CType(drCategory, DataRow)) Then
                'invalid response found
                bCategoryValid = False
                errorMsg.Append(Category.ErrorMsg)
            Else
                ''add up key count if not writting a correction
                'If Category.Selected AndAlso countKeys Then
                '    _KeyCount += (1 + Category.AnswerText.Length)
                'End If
                WriteResponseRow(drCategory.AnswerCategoryID, Category.Selected, Category.AnswerText)
            End If

            Category = Nothing

        Next

        If errorMsg.Length > 0 Then Me.ErrorMsg &= errorMsg.ToString

        Return bCategoryValid

    End Function

    Protected Sub WriteResponseRow(ByVal answerCategoryID As Integer, ByVal selected As Boolean, ByVal responseText As String)
        Dim dr As DataRow = Responses.SelectRow(String.Format("AnswerCategoryID = {0}", answerCategoryID))

        If selected AndAlso Not IsNothing(dr) Then
            'category selected and already exists, check if text is different
            If dr.Item("ResponseText").ToString() <> responseText Then
                'update
                dr.Item("ResponseText") = responseText
                _KeyCount += (responseText.Length)
            End If
        ElseIf selected AndAlso IsNothing(dr) Then
            'insert: category selected and does not already exist
            NewResponse(answerCategoryID, responseText)
            _KeyCount += (1 + responseText.Length)
        ElseIf Not selected AndAlso Not IsNothing(dr) Then
            'delete: was not selected and already exists
            dr.Delete()
        End If

    End Sub

    Private Sub NewResponse(ByVal answerCategoryID As Integer, ByVal responseText As String)
        Dim drResponse As dsInterviewLite.ResponsesRow

        drResponse = CType(Responses.NewMainRow, dsInterviewLite.ResponsesRow)
        drResponse.RespondentID = Me.RespondentID
        drResponse.SurveyQuestionID = 0   'this will be updated when saved to db
        drResponse.AnswerCategoryID = answerCategoryID
        drResponse.ResponseText = responseText
        drResponse.UserID = Me.UserID

        Responses.AddMainRow(drResponse)

    End Sub

    Public Function ScreenText() As String
        Dim tt As New clsTextTokens(Me._Connection, Me.RespondentID, Me.UserID)
        Dim screen As dsInterviewLite.ScriptScreensRow = Me.GetScreenInfo()
        tt.RespondentDataRow = Me.GetRespondentInfo

        If ErrorMsg.Length > 0 Then
            'display text with error message
            Return String.Format("<p class=""error"">{0}</p>{1}", ErrorMsg, tt.ReplaceTextTokens(screen.Text).Replace("\n", "<br>"))
        Else
            'no error, just display text
            'TP Change _Text to Text
            Return tt.ReplaceTextTokens(screen.Text).Replace("\n", "<br>")
        End If

    End Function

    Public Function CategoryText() As String
        Dim screen As dsInterviewLite.ScriptScreensRow = Me.GetScreenInfo()

        If Not screen.IsSurveyQuestionIDNull Then
            If Me.InterviewMode = qmsInterviewMode.InputResponse Then
                Return AnswerCategories(screen)
            Else
                Return CorrectionCategories(screen)
            End If
        End If

        Return ""

    End Function

    Protected Function AnswerCategories(ByVal screen As dsInterviewLite.ScriptScreensRow) As String
        Dim categoryText As New Text.StringBuilder
        Dim drCategory As dsInterviewLite.ScriptScreenCategoriesRow
        Dim Category As clsCategoryType
        Dim QuestionType As qmsQuestionTypes = CType(screen.QuestionTypeID, qmsQuestionTypes)
        Dim dv As DataView = _ds.ScriptScreenCategories.DefaultView
        Dim drv As DataRowView
        dv.Sort = "AnswerValue"

        For Each drv In dv
            drCategory = CType(drv.Row, dsInterviewLite.ScriptScreenCategoriesRow)
            If drCategory.Show = 1 Then
                Category = clsCategoryTypeFactory.Create(CType(drCategory.AnswerCategoryTypeID, qmsAnswerCategoryTypes), QuestionType)
                If Me.InputMode = qmsInputMode.VERIFY Then Category.DisplayResponses = False
                categoryText.AppendFormat("{0}<br>", Category.ToHTML(drCategory))
                Category = Nothing

            End If
        Next

        Return categoryText.ToString

    End Function

    Protected Function CorrectionCategories(ByVal screen As dsInterviewLite.ScriptScreensRow) As String
        Dim sbCategory As New Text.StringBuilder
        Dim sbDataEntryResponses As New Text.StringBuilder
        Dim drCategory As dsInterviewLite.ScriptScreenCategoriesRow
        Dim drResponse As dsInterviewLite.ResponsesRow
        Dim Category As clsCategoryType
        Dim QuestionType As qmsQuestionTypes = CType(screen.QuestionTypeID, qmsQuestionTypes)
        Dim answerValue As Integer

        'get data entry responses
        For Each drResponse In _ds.Responses.Rows
            answerValue = GetAnswerValue(drResponse.AnswerCategoryID)
            If sbDataEntryResponses.Length > 0 Then sbDataEntryResponses.Append(", ")
            sbDataEntryResponses.Append(answerValue)
            If drResponse.ResponseText.Length > 0 Then sbDataEntryResponses.AppendFormat(":{0}", drResponse.ResponseText)

        Next

        sbCategory.AppendFormat("<input type=""radio"" name=""{1}"" id=""C{2}"" value=""{0}"">{2}:", CInt(qmsCorrection.SELECT_OLD), CORRECTION_FIELD_NAME, clsInterview.TranslateCorrectionToInputLetter(qmsCorrection.SELECT_OLD))
        sbCategory.AppendFormat("&nbsp;<strong>Choose old answer</strong>:&nbsp;{0}<br>", sbDataEntryResponses.ToString)
        sbCategory.AppendFormat("<input type=""radio"" name=""{1}"" id=""C{2}"" value=""{0}"">{2}:", CInt(qmsCorrection.SELECT_NEW), CORRECTION_FIELD_NAME, clsInterview.TranslateCorrectionToInputLetter(qmsCorrection.SELECT_NEW))
        sbCategory.AppendFormat("&nbsp;<strong>Choose new answer</strong>:&nbsp;{0}<br>", Me._VerifyResponse)
        sbCategory.AppendFormat("<input type=""radio"" name=""{1}"" id=""C{2}"" value=""{0}"">{2}:", CInt(qmsCorrection.RESELECT), CORRECTION_FIELD_NAME, clsInterview.TranslateCorrectionToInputLetter(qmsCorrection.RESELECT))
        sbCategory.Append("&nbsp;<strong>Choose neither answer, re-select...</strong>")

        Return sbCategory.ToString

    End Function

    Private Function GetAnswerValue(ByVal answerCategoryID As Integer) As Integer
        Dim dr As DataRow

        dr = Me.ScriptScreenCategories.SelectRow(String.Format("AnswerCategoryID = {0}", answerCategoryID))

        If Not IsNothing(dr) Then
            Return CInt(dr.Item("AnswerValue"))
        Else
            Return DMI.DataHandler.NULLRECORDID
        End If

    End Function

    Protected Sub SaveVerificationResponse(ByRef r As Web.HttpRequest, ByVal screen As dsInterviewLite.ScriptScreensRow)
        Dim sbCategory As New Text.StringBuilder
        Dim sbVerifyResponses As New Text.StringBuilder
        Dim drCategory As dsInterviewLite.ScriptScreenCategoriesRow
        Dim Category As clsCategoryType
        Dim QuestionType As qmsQuestionTypes = CType(screen.QuestionTypeID, qmsQuestionTypes)
        Dim dv As DataView = _ds.ScriptScreenCategories.DefaultView
        Dim drv As DataRowView
        dv.Sort = "AnswerValue"

        sbCategory.AppendFormat("<input type=""hidden"" name=""{1}"" value=""{0}"">", r.Item(RESPONSE_FIELD_NAME), RESPONSE_FIELD_NAME)

        For Each drv In dv
            drCategory = CType(drv.Row, dsInterviewLite.ScriptScreenCategoriesRow)
            'get verification responses
            Category = clsCategoryTypeFactory.Create(CType(drCategory.AnswerCategoryTypeID, qmsAnswerCategoryTypes), QuestionType)
            If Category.ReadResponse(r, CType(drCategory, DataRow)) Then
                If Category.Selected Then
                    If sbVerifyResponses.Length > 0 Then sbVerifyResponses.Append(", ")
                    sbVerifyResponses.Append(drCategory.AnswerValue)
                    If Category.AnswerText.Length > 0 Then
                        sbVerifyResponses.AppendFormat(":{0}", Category.AnswerText)
                        sbCategory.AppendFormat("<input type=""hidden"" name=""OA{0}"" id=""OA{0}"" value=""{1}"">", drCategory.AnswerValue, Category.AnswerText)
                    End If

                End If
            End If
            Category = Nothing

        Next

        sbCategory.Append(sbVerifyResponses.ToString)

        Me._VerifyResponse = sbCategory.ToString

    End Sub

    Public Function GetRespondentInfo() As dsInterviewLite.RespondentsRow
        If _ds.Respondents.Rows.Count <> 1 Then
            Dim obj As New clsRespondents(Me._Connection)
            obj.MainDataTable = _ds.Respondents
            obj.FillMain(Me.RespondentID)
        End If
        Return CType(_ds.Respondents.Rows(0), dsInterviewLite.RespondentsRow)

    End Function

    Public Function GetScriptInfo() As dsInterviewLite.ScriptsRow
        If _ds.Scripts.Rows.Count <> 1 Then
            Dim obj As New clsScripts(Me._Connection)
            obj.MainDataTable = _ds.Scripts
            obj.FillMain(Me.ScriptID)

        End If
        Return CType(_ds.Scripts.Rows(0), dsInterviewLite.ScriptsRow)

    End Function

    Public Function GetScreenInfo() As dsInterviewLite.ScriptScreensRow
        If ScriptScreen.MainDataTable.Rows.Count = 1 Then
            Return CType(ScriptScreen.MainDataTable.Rows(0), dsInterviewLite.ScriptScreensRow)
        End If
    End Function

    Public Function GetRespondentDescText() As String
        Dim dr As dsInterviewLite.RespondentsRow = Me.GetRespondentInfo
        Dim desc As New System.Text.StringBuilder

        'Set respondent info
        desc.AppendFormat("RID {0}", dr.RespondentID)
        If Not dr.IsFirstNameNull Then
            desc.AppendFormat(", {0} {1}", dr.FirstName, dr.LastName)
        Else
            desc.AppendFormat(", {0}", dr.LastName)
        End If
        If Not dr.IsCityNull Then desc.AppendFormat(", {0}", dr.City)
        If Not dr.IsStateNull Then desc.AppendFormat(", {0}", dr.State)
        If Not dr.IsTelephoneDayNull Then desc.AppendFormat(", {0}", DMI.clsUtil.FormatTelephone(dr.TelephoneDay))
        If Not dr.IsTelephoneEveningNull Then desc.AppendFormat(", {0}", DMI.clsUtil.FormatTelephone(dr.TelephoneEvening))

        Return desc.ToString

    End Function

    Public Function ScriptScreenCount() As Integer
        Return Me.ScriptScreen.ScreenCount(Me._Connection, Me.ScriptID)
    End Function

    Protected Function GetScreenID(ByVal ScreenIndex As Integer) As Integer
        Return clsScriptScreens.GetScriptScreenID(Me._Connection, Me.ScriptID, ScreenIndex)
    End Function

    Protected Function GetScreenIndex(ByVal screenID As Integer) As Integer
        Return clsScriptScreens.GetScriptScreenIndex(Me._Connection, Me.ScriptID, screenID)
    End Function

    Protected Sub SetScriptScreenIndex(ByVal Value As Integer)
        _ScriptScreenIndex = Value
        If Value <= 0 Then
            _ScriptScreenID = DMI.DataHandler.NULLRECORDID
        Else
            _ScriptScreenID = clsScriptScreens.GetScriptScreenID(Me._Connection, ScriptID, Value)
        End If

    End Sub

    Protected Sub Score(Optional ByVal updateScore As Boolean = False)
        If Me.InputMode <> qmsInputMode.TEST AndAlso _
            InputMode <> qmsInputMode.READ_ONLY AndAlso _
            Me.GetScriptInfo.CalcCompleteness = 1 Then

            Dim status As New InterviewStatus(Me._Connection, Me.RespondentID, Me.ScriptID, Me.UserID)
            Me.LogScore(CInt(status.Score), updateScore)
            status = Nothing
        End If

    End Sub

    Private Sub LogScore(ByVal completenessScore As Integer, Optional ByVal updateScore As Boolean = False)
        Dim cc As QMS.qmsEvents = qmsEvents.NONE
        Dim r As QMS.clsRespondents

        If CInt(Me.GetScriptInfo.CompletenessLevel) <= completenessScore Then
            'Survey complete
            If InputMode = qmsInputMode.VIEW Then
                updateScore = True
                cc = GetCompleteCode(clsInputMode.LastInputMode(Me._Connection, RespondentID))
            Else
                cc = GetCompleteCode(InputMode)
            End If

        Else
            'Survey incomplete
            If InputMode = qmsInputMode.VIEW Then
                updateScore = True
                cc = GetIncompleteCode(clsInputMode.LastInputMode(Me._Connection, RespondentID))
            Else
                cc = GetIncompleteCode(InputMode)
            End If

        End If

        If cc <> qmsEvents.NONE Then
            If Not updateScore Then
                r.ClearCompleteness(Me._Connection, RespondentID)
                r.InsertEvent(Me._Connection, CInt(cc), UserID, RespondentID, completenessScore.ToString("0.0"))
            Else
                UpdateRespondentScore(Me._Connection, RespondentID, completenessScore, CInt(cc))
            End If

        End If

    End Sub

    Private Sub UpdateRespondentScore(ByVal connection As SqlClient.SqlConnection, ByVal respondentID As Integer, ByVal score As Integer, ByVal eventID As Integer)
        Dim sql As New Text.StringBuilder

        sql.AppendFormat("UPDATE EventLog SET EventParameters = '{0}', ", score.ToString("0.0"))
        sql.AppendFormat("EventID = {0} ", eventID)
        sql.AppendFormat("WHERE RespondentID = {0} AND EventID IN (3000, 3001, 3002, 3010, 3011, 3012, 3020, 3021, 3022, 3030, 3031, 3032, 3033, 3035)", respondentID)
        'TP Change
        SqlHelper.Db(connection.ConnectionString).ExecuteNonQuery(CommandType.Text, sql.ToString())
        'SqlHelper.ExecuteNonQuery(connection, CommandType.Text, sql.ToString)

    End Sub

    Protected Function GetCompleteCode(ByVal inputMode As qmsInputMode) As qmsEvents
        'Survey complete
        If inputMode = qmsInputMode.DATAENTRY Then
            If Not clsUsers.VerifyDataEntry(_Connection, _UserID) Then
                inputMode = qmsInputMode.VERIFY
            End If
        End If
        Return clsInputMode.Create(inputMode).CompleteCodeID

    End Function

    Protected Function GetIncompleteCode(ByVal inputMode As qmsInputMode) As qmsEvents
        'Survey incomplete
        If inputMode = qmsInputMode.DATAENTRY Then
            If Not clsUsers.VerifyDataEntry(_Connection, _UserID) Then
                inputMode = qmsInputMode.VERIFY
            End If
        End If
        Return clsInputMode.Create(inputMode).IncompleteCodeID

    End Function

    Protected Function SetupTestMode(ByVal scriptID As Integer) As Integer
        'TP Change
        Dim cmd As DbCommand = SqlHelper.Db(Me._Connection.ConnectionString).GetStoredProcCommand("setup_TestMode", scriptID)
        Return CInt(SqlHelper.Db(Me._Connection.ConnectionString).ExecuteScalar(cmd))
        'Return CInt(SqlHelper.ExecuteScalar(Me._Connection, CommandType.StoredProcedure, "setup_TestMode", _
        '   New SqlClient.SqlParameter("@ScriptID", scriptID)))

    End Function

    Protected Sub CleanUpTestMode()
        'TP Change
        Dim cmd As DbCommand = SqlHelper.Db(Me._Connection.ConnectionString).GetStoredProcCommand("cleanup_TestMode", Me.RespondentID)
        SqlHelper.Db(Me._Connection.ConnectionString).ExecuteScalar(cmd)
        'SqlHelper.ExecuteScalar(Me._Connection, CommandType.StoredProcedure, "cleanup_TestMode", _
        '   New SqlClient.SqlParameter("@RespondentID", Me.RespondentID))

    End Sub

    Public Sub RecordKeyStrokeCount(ByVal keyCount As Integer)
        clsRespondents.InsertEvent(_Connection, CInt(qmsEvents.KEYSTROKE_STATISTIC), _UserID, _RespondentID, keyCount.ToString)
    End Sub

End Class

Public Class InterviewStatus
    Protected _ds As dsInterviewLite
    Public Sub New(ByVal connection As SqlClient.SqlConnection, ByVal respondentID As Integer, ByVal scriptID As Integer, ByVal userID As Integer)
        Dim ss As New clsScriptScreens(connection)

        _ds = New dsInterviewLite
        FillScriptScreens(connection, scriptID)
        UpdateStatus(connection, respondentID, scriptID, userID)

    End Sub

    Public Sub New(ByVal connection As SqlClient.SqlConnection, ByVal respondentID As Integer, ByVal scriptID As Integer)
        Dim ss As New clsScriptScreens(connection)

        _ds = New dsInterviewLite
        FillScriptScreens(connection, scriptID)
        SetAnswered(connection, respondentID, scriptID)

    End Sub

    Protected Sub FillScriptScreens(ByVal connection As SqlClient.SqlConnection, ByVal scriptID As Integer)
        If scriptID > 0 Then
            Dim ss As New clsScriptScreens(connection)
            Dim dr As DataRow = ss.NewSearchRow

            ss.MainDataTable = _ds.ScriptScreens
            dr.Item("ScriptID") = scriptID
            ss.FillMain(dr)
            dr = Nothing

        End If

    End Sub

    Protected Sub UpdateStatus(ByVal connection As SqlClient.SqlConnection, ByVal respondentID As Integer, ByVal scriptID As Integer, ByVal userID As Integer)
        Dim dv As DataView = _ds.ScriptScreens.DefaultView
        dv.Sort = "ItemOrder"
        Dim furthestJumpIndex As Integer = 1

        For Each drv As DataRowView In dv
            Dim ssr As dsInterviewLite.ScriptScreensRow = CType(drv.Row, dsInterviewLite.ScriptScreensRow)
            If Not ssr.IsSurveyQuestionIDNull Then
                If AppropriatelyAnswered(connection, respondentID, ssr.SurveyQuestionID) Then
                    ssr.Status = qmsScreenStatus.ANSWERED
                ElseIf furthestJumpIndex > ssr.ItemOrder Then
                    ssr.Status = qmsScreenStatus.SKIPPED_LEGAL
                Else
                    ssr.Status = qmsScreenStatus.NO_ANSWER
                End If
                Dim nextJump As Integer = NextScreenIndex(connection, respondentID, scriptID, ssr.ItemOrder, userID)
                If nextJump > furthestJumpIndex Then furthestJumpIndex = nextJump
                ssr.JumpIndex = furthestJumpIndex
            Else
                ssr.Status = qmsScreenStatus.SKIPPED_LEGAL
            End If
        Next

    End Sub

    Protected Sub SetAnswered(ByVal connection As SqlClient.SqlConnection, ByVal respondentID As Integer, ByVal scriptID As Integer)
        Dim dv As DataView = _ds.ScriptScreens.DefaultView
        dv.Sort = "ItemOrder"
        Dim furthestJumpIndex As Integer = 1

        For Each drv As DataRowView In dv
            Dim ssr As dsInterviewLite.ScriptScreensRow = CType(drv.Row, dsInterviewLite.ScriptScreensRow)
            If Not ssr.IsSurveyQuestionIDNull Then
                If AnsweredQuestion(connection, respondentID, ssr.SurveyQuestionID) Then
                    ssr.Status = qmsScreenStatus.ANSWERED
                Else
                    ssr.Status = qmsScreenStatus.NO_ANSWER
                End If
            Else
                ssr.Status = qmsScreenStatus.NO_ANSWER
            End If
        Next

    End Sub

    Protected Function AnsweredQuestion(ByVal conn As SqlClient.SqlConnection, ByVal respondentID As Integer, ByVal surveyQuestionID As Integer) As Boolean
        Dim sql As String = String.Format("SELECT COUNT(r.ResponseID) AS ResponseCount FROM SurveyQuestions sq INNER JOIN Responses r ON sq.SurveyQuestionID = r.SurveyQuestionID WHERE (sq.SurveyQuestionID = {0}) AND (r.RespondentID = {1})", surveyQuestionID, respondentID)
        'TP Change
        Dim result As Integer = CInt(SqlHelper.Db(conn.ConnectionString).ExecuteScalar(CommandType.TableDirect, sql))
        'Dim result As Integer = CInt(SqlHelper.ExecuteScalar(conn, CommandType.Text, sql))
        Return result > 0

    End Function

    Protected Sub FillInStatus()
        Dim dv As DataView = _ds.ScriptScreens.DefaultView
        For Each drv As DataRowView In dv
            Dim ssr As dsInterviewLite.ScriptScreensRow = CType(drv.Row, dsInterviewLite.ScriptScreensRow)
            ssr.Status = qmsScreenStatus.NO_ANSWER
        Next
    End Sub

    Public Function Score() As Double
        Dim numerator As Integer = 0
        Dim denominator As Integer = 0
        Dim dv As DataView = _ds.ScriptScreens.DefaultView
        dv.Sort = "ItemOrder"
        Dim furthestJumpIndex As Integer = 1

        For Each drv As DataRowView In dv
            Dim ssr As dsInterviewLite.ScriptScreensRow = CType(drv.Row, dsInterviewLite.ScriptScreensRow)
            If Not ssr.IsSurveyQuestionIDNull Then
                If ssr.CalculationTypeID = qmsCalculationTypes.REQUIRED_SCREEN Then
                    If ssr.Status = qmsScreenStatus.ANSWERED Then
                        'count towards completeness
                        numerator += 1
                        denominator += 1
                    Else
                        'survey is incomplete, a required question was not answered
                        numerator = 0
                        denominator = 1
                        Exit For
                    End If
                ElseIf ssr.CalculationTypeID = qmsCalculationTypes.OPTIONAL_SCREEN Then
                    If ssr.Status = qmsScreenStatus.ANSWERED OrElse ssr.Status = qmsScreenStatus.SKIPPED_LEGAL Then
                        'count towards completeness
                        numerator += 1
                        denominator += 1
                    ElseIf ssr.Status = qmsScreenStatus.NO_ANSWER Then
                        'count against completeness
                        denominator += 1
                    End If
                End If
            End If
        Next

        If denominator = 0 Then denominator = 1
        Return (numerator / denominator) * 100.0

    End Function

    Public Function ScriptStatusHTML(ByVal respondentID As Integer, ByVal inputMode As Integer, ByVal scriptID As Integer, ByVal screenIndex As Integer, Optional ByVal maxColumns As Integer = 20) As String
        Dim drvScreen As DataRowView
        Dim dvScreens As DataView = _ds.ScriptScreens.DefaultView
        Dim sbTable As New Text.StringBuilder

        dvScreens.Sort = "ItemOrder"
        For Each drvScreen In dvScreens

            If CInt(drvScreen.Item("ItemOrder")) Mod maxColumns = 1 Then
                'close previous row
                If sbTable.Length > 0 Then sbTable.Append("</tr>")
                'start new row
                sbTable.Append("<tr>")

            End If

            'add cell
            sbTable.AppendFormat("<td title=""{0}"" ", drvScreen.Item("Title"))
            'apply cell format
            If CInt(drvScreen.Item("ItemOrder")) = screenIndex Then
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
             clsInterviewLite.RESPONDENT_ID_KEY, respondentID, _
             clsInterviewLite.SCRIPT_ID_KEY, scriptID, _
             clsInterviewLite.INPUTMODE_ID_KEY, inputMode, _
             clsInterviewLite.SCREEN_INDEX_KEY, drvScreen.Item("ItemOrder"))

        Next

        'add last filler cells
        If CInt(drvScreen.Item("ItemOrder")) Mod maxColumns > 0 Then
            sbTable.AppendFormat("<td colspan=""{0}"">&nbsp;</td>", _
             maxColumns - (CInt(drvScreen.Item("ItemOrder")) Mod maxColumns))

        End If
        'close last row
        sbTable.Append("</tr>")

        'wrap table tags
        sbTable.Insert(0, "<table cellspacing=""0"" cellpadding=""0"" border=""1"" bordercolor=""#000000"" bordercolordark=""#000000"" bordercolorlight=""#000000"" style=""border-width:1px;width:100%;"">")
        sbTable.Append("</table>")

        Return sbTable.ToString

    End Function

    Public Function GetScriptScreens() As dsInterviewLite.ScriptScreensDataTable
        Return _ds.ScriptScreens
    End Function

    Public Shared Function AppropriatelyAnswered(ByVal connection As SqlClient.SqlConnection, ByVal respondentID As Integer, ByVal surveyQuestionID As Integer) As Boolean
        Dim sql As String = String.Format("SELECT dbo.AppropriatelyAnswered({0},{1})", respondentID, surveyQuestionID)
        Dim result As Object
        result = SqlHelper.Db(connection.ConnectionString).ExecuteScalar(CommandType.Text, sql)
        'result = SqlHelper.ExecuteScalar(connection, CommandType.Text, sql)
        If Not IsNothing(result) AndAlso Not IsDBNull(result) Then
            If CInt(result) > 0 Then Return True
        End If

        Return False

    End Function

    Protected Function NextScreenIndex(ByVal connection As SqlClient.SqlConnection, ByVal respondentID As Integer, ByVal scriptID As Integer, ByVal currentScreenIndex As Integer, ByVal userID As Integer) As Integer
        Dim jump As ScriptJumpHandler
        Dim result As ScriptAction = jump.GetJumpAction(connection, respondentID, scriptID, currentScreenIndex, userID, True, True)
        If result.ExitScript Then
            Return clsScriptScreens.ScreenCount(connection, scriptID)
        ElseIf result.GoToScriptID <> DMI.DataHandler.NULLRECORDID Then
            Return clsScriptScreens.ScreenCount(connection, scriptID)
        Else
            Return result.GoToScreenIndex
        End If

    End Function

End Class

Public Class ScriptAction
    Public Sub New(Optional ByVal screenIndex As Integer = DMI.DataHandler.NULLRECORDID)
        GoToScreenIndex = screenIndex
    End Sub
    Public Sub New(ByVal scriptExit As Boolean)
        ExitScript = scriptExit
    End Sub
    Public ExitScript As Boolean = False
    Public GoToScreenIndex As Integer = DMI.DataHandler.NULLRECORDID
    Public GoToScriptID As Integer = DMI.DataHandler.NULLRECORDID
    Public Sub Compare(ByVal cmd As ScriptAction)
        If cmd.ExitScript Then Me.ExitScript = True
        If cmd.GoToScriptID > DMI.DataHandler.NULLRECORDID Then Me.GoToScriptID = cmd.GoToScriptID
        If cmd.GoToScreenIndex > Me.GoToScreenIndex Then Me.GoToScreenIndex = cmd.GoToScreenIndex
    End Sub
End Class

Public Class ScriptJumpHandler
    Public Shared Function GetJumpAction(ByVal connection As SqlClient.SqlConnection, ByVal respondentID As Integer, ByVal scriptID As Integer, ByVal currentScreenIndex As Integer, ByVal userID As Integer, ByVal PostScreen As Boolean, ByVal followSkips As Boolean) As ScriptAction
        Dim cmd As ScriptAction
        Dim result As String

        If followSkips Then
            Dim currentScriptScreenID As Integer = clsScriptScreens.GetScriptScreenID(connection, scriptID, currentScreenIndex)
            'gone past end of script, return current screen index
            If currentScriptScreenID = DMI.DataHandler.NULLRECORDID Then Return New ScriptAction(currentScreenIndex)

            'check for triggers 
            If PostScreen Then
                'post-screen trigger
                Dim st As New clsScriptTriggers(connection)
                result = st.RunScriptTrigger(userID, respondentID, PrePostTrigger.POST, scriptID, currentScriptScreenID)
                'check simple jump since we are leaving a starting screen
                cmd = GetSimpleJumpAction(connection, respondentID, scriptID, currentScreenIndex, followSkips)
                'screenIndex = currentScreenIndex + 1
            Else
                'pre-screen trigger
                Dim st As New clsScriptTriggers(connection)
                result = st.RunScriptTrigger(userID, respondentID, PrePostTrigger.PRE, scriptID, currentScriptScreenID)
                cmd = New ScriptAction(currentScreenIndex)
            End If

            If Not cmd.ExitScript Then
                'check results for jump
                If (result.Length > 0) Then
                    'follow skips, get new screen index from jump cmd
                    Dim cmdJumpIndex As New ScriptAction
                    cmd.Compare(JumpCommandAction(connection, scriptID, currentScreenIndex, result))
                End If
                If Not cmd.ExitScript AndAlso cmd.GoToScriptID = DMI.DataHandler.NULLRECORDID Then
                    'check pre-screen trigger for jump
                    If (cmd.GoToScreenIndex > currentScreenIndex) Then cmd = GetJumpAction(connection, respondentID, scriptID, cmd.GoToScreenIndex, userID, False, followSkips)

                End If

            End If

        Else
            'do not follow skip, just go to next screen
            cmd = New ScriptAction(currentScreenIndex + 1)
        End If

        Return cmd

    End Function

    Public Shared Function GetSimpleJumpAction(ByVal connection As SqlClient.SqlConnection, ByVal respondentID As Integer, ByVal scriptID As Integer, ByVal currentScreenIndex As Integer, ByVal followSkips As Boolean) As ScriptAction
        Dim result As Integer = 0
        Dim cmd As New ScriptAction

        If followSkips Then
            'TP Change
            Dim scmd As DbCommand = SqlHelper.Db(connection.ConnectionString).GetStoredProcCommand("get_SimpleScreenJumpIndex")
            scmd.Parameters.Add(New SqlClient.SqlParameter("@RespondentID", respondentID))
            scmd.Parameters.Add(New SqlClient.SqlParameter("@ScriptID", scriptID))
            scmd.Parameters.Add(New SqlClient.SqlParameter("@ScreenIndex", currentScreenIndex))
            result = CInt(SqlHelper.Db(connection.ConnectionString).ExecuteScalar(scmd))
            'result = CInt(SqlHelper.ExecuteScalar(connection, CommandType.StoredProcedure, "get_SimpleScreenJumpIndex", _
            '   New SqlClient.SqlParameter("@RespondentID", respondentID), _
            '  New SqlClient.SqlParameter("@ScriptID", scriptID), _
            ' New SqlClient.SqlParameter("@ScreenIndex", currentScreenIndex)))
        End If

        If result < 0 Then
            cmd.ExitScript = True
        ElseIf result = 0 OrElse result <= currentScreenIndex Then
            cmd.GoToScreenIndex = currentScreenIndex + 1
        Else
            cmd.GoToScreenIndex = result
        End If

        Return cmd

    End Function

    Protected Shared Function JumpCommandAction(ByVal connection As SqlClient.SqlConnection, ByVal scriptID As Integer, ByVal screenIndex As Integer, ByVal sCommand As String) As ScriptAction
        Dim pattern As String = "([\w]+)\(([\w]+)\)"
        Dim match As Text.RegularExpressions.Match = Text.RegularExpressions.Regex.Match(sCommand, pattern)
        Dim keyword As String
        Dim param As String
        Dim cmd As New ScriptAction

        If match.Success Then
            keyword = match.Groups(1).ToString
            param = match.Groups(2).ToString
        Else
            keyword = sCommand
        End If

        Select Case keyword.Trim.ToUpper
            Case "EXIT"
                cmd.ExitScript = True

            Case "END"
                cmd.GoToScreenIndex = clsScriptScreens.ScreenCount(connection, scriptID) + 1

            Case "NEXT"
                cmd.GoToScreenIndex = screenIndex + 1

            Case "SCREENINDEX"
                cmd.GoToScreenIndex = CInt(param)

            Case "SCREENID"
                cmd.GoToScreenIndex = clsScriptScreens.GetScriptScreenIndex(connection, scriptID, CInt(param))

            Case "SCRIPT"
                cmd.GoToScriptID = CInt(param)

            Case Else
                cmd.GoToScreenIndex = screenIndex

        End Select

        Return cmd

    End Function

End Class