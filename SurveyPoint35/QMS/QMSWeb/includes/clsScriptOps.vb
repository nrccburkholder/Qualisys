<Obsolete("moved to QMS")> _
Public Enum qmsQuestionType
    SingleSelect = 1
    MultipleSelect = 2
    OpenAnswer = 3
    Numeric = 4
    Datetime = 5

End Enum

<Obsolete("moved to QMS")> _
Public Enum qmsCorrection
    SELECT_OLD = 1
    SELECT_NEW = 2
    RESELECT = 3

End Enum

<Obsolete("moved to QMS")> _
Public Enum qmsResponseStatus
    SELECTED = 1
    NOT_SELECTED = 0
    UPDATE_TO_SELECTED = -1
    SELECTION_CHANGED = -2
    UPDATE_TO_NOT_SELECTED = -3

End Enum

<Obsolete("moved to QMS")> _
Public Enum qmsScreenCalculationTypes
    REQUIRED_SCREEN = 1
    EXCLUDED_SCREEN = 2
    OPTIONAL_SCREEN = 3

End Enum

<Obsolete("moved to QMS")> _
Public Enum qmsScreenStatus
    ANSWERED = 1
    NO_ANSWER = 2
    SKIPPED = 3
    MULTIMARKED = 4

End Enum

<Obsolete("use QMS.clsInterview")> _
Public Class clsScriptOps

    Private _dsScript As DataSet

    Private _iScriptID As Integer = 0

    Private _iRespondentID As Integer = 0

    Private _sConnection As String = ""

    Private _iErrCode As ErrorCodes = ErrorCodes.NO_ERRORS

    Private _sErrMsg As String = ""

    Private _iUserID As Integer = 0

    Private _iInputMode As QMS.qmsInputMode = QMS.qmsInputMode.VIEW

    Private _drCurrentScriptScreen As DataRow

    Private _dvCurrentScriptCategories As DataView

    Public Enum ErrorCodes
        NO_ERRORS = 0
        END_OF_SCRIPT = 1
        BEGINNING_OF_SCRIPT = 2
        INVALID_ID = 3
        INVALID_INDEX = 4

    End Enum

    Sub New(ByVal sConn As String, Optional ByVal iScriptID As Integer = 0, Optional ByVal iRespondentID As Integer = 0)
        Me._sConnection = sConn

        If iScriptID > 0 Then
            LoadDataSet(iScriptID, iRespondentID)

        End If

    End Sub

    Public Property RespondentID() As Integer
        Get
            Return Me._iRespondentID

        End Get
        Set(ByVal Value As Integer)
            Me._iRespondentID = Value
            LoadDataSet(Me._iScriptID, Me._iRespondentID)

        End Set
    End Property

    Public Property ScriptID() As Integer
        Get
            Return Me._iScriptID

        End Get
        Set(ByVal Value As Integer)
            Me._iScriptID = Value
            LoadDataSet(Me._iScriptID, Me._iRespondentID)

        End Set
    End Property

    Public ReadOnly Property SurveyInstanceID() As Integer
        Get
            Return Me._dsScript.Tables("RespondentInfo").Rows(0).Item("SurveyInstanceID")

        End Get
    End Property

    Public Property ScriptScreenID() As Integer
        Get
            Return Me._drCurrentScriptScreen.Item("ScriptScreenID")

        End Get
        Set(ByVal Value As Integer)
            Me.GetScreenByID(Value)

        End Set
    End Property

    Public Property ScriptScreenIndex() As Integer
        Get
            Return Me._drCurrentScriptScreen.Item("ItemOrder")

        End Get
        Set(ByVal Value As Integer)
            Me.GetScreenByIndex(Value)

        End Set
    End Property

    Public Property DataSet() As DataSet
        Get
            Return Me._dsScript

        End Get
        Set(ByVal Value As DataSet)
            Me._dsScript = Value

            Me._iScriptID = Value.Tables("ScriptInfo").Rows(0).Item("ScriptID")
            Me._iRespondentID = Value.Tables("RespondentInfo").Rows(0).Item("RespondentID")

        End Set

    End Property

    Public ReadOnly Property NamedDataSet(ByVal sName As String) As DataSet
        Get

            If sName.Length > 0 Then Me._dsScript.DataSetName = sName

            Return Me._dsScript

        End Get

    End Property


    Public Function VerifyNamedDataSet(ByVal ds As DataSet, ByVal sName As String) As Boolean

        If ds.DataSetName.ToUpper = sName.ToUpper Then
            'signed dataset matches signature
            Me.DataSet = ds
            Return True

        End If

        Return False

    End Function

    Public ReadOnly Property ErrorCode() As ErrorCodes
        Get
            Return Me._iErrCode

        End Get
    End Property

    Public ReadOnly Property ErrorMsg() As String
        Get
            Return Me._sErrMsg

        End Get
    End Property

    Public ReadOnly Property RespondentDataRow() As DataRow
        Get
            Return Me._dsScript.Tables("RespondentInfo").Rows(0)

        End Get
    End Property

    Public ReadOnly Property ScriptDataRow() As DataRow
        Get
            Return Me._dsScript.Tables("ScriptInfo").Rows(0)

        End Get
    End Property

    Public ReadOnly Property ScriptScreenDataTable() As DataTable
        Get
            Return Me._dsScript.Tables("ScriptScreens")

        End Get
    End Property

    Public ReadOnly Property CurrentScreenDataRow() As DataRow
        Get
            Return Me._drCurrentScriptScreen

        End Get
    End Property

    Public ReadOnly Property CurrentCategoriesDataView() As DataView
        Get
            Return Me._dvCurrentScriptCategories

        End Get
    End Property

    Public ReadOnly Property ScreenCount() As Integer
        Get
            Return Me._dsScript.Tables("ScriptScreens").Rows.Count

        End Get
    End Property

    Public ReadOnly Property FollowSkips() As Boolean
        Get
            If Me._dsScript.Tables("ScriptInfo").Rows(0).Item("FollowSkips") = 1 Then
                Return True

            Else
                Return False

            End If
        End Get
    End Property

    Public ReadOnly Property ScreenText() As String
        Get
            Return Me.ReplaceScreenTextTokens(Me.CurrentScreenDataRow.Item("Text"))

        End Get
    End Property

    Public Property UserID() As Integer
        Get
            Return Me._iUserID

        End Get
        Set(ByVal Value As Integer)
            Me._iUserID = Value

        End Set
    End Property

    Public Property InputMode() As QMS.qmsInputMode
        Get
            Return Me._iInputMode

        End Get
        Set(ByVal Value As QMS.qmsInputMode)
            Me._iInputMode = Value

        End Set
    End Property

    Public Function NextScreen() As Boolean
        Dim iIndex As Integer

        'check for skips?
        If Me.FollowSkips Then
            'Is screen associated with a survey question
            If Not IsDBNull(Me.CurrentScreenDataRow.Item("SurveyQuestionID")) Then
                'does survey questions have answer categories
                If Not IsDBNull(Me.CurrentScreenDataRow.Item("JumpToScriptScreenID")) Then
                    'Is there a skip
                    If Me.CurrentScreenDataRow.Item("JumpToScriptScreenID") > 0 Then
                        'perform jump
                        Me.ScriptScreenID = Me.CurrentScreenDataRow.Item("JumpToScriptScreenID")
                        Return True

                    ElseIf Me.CurrentScreenDataRow.Item("JumpToScriptScreenID") < 0 Then
                        'end survey jump
                        Return False

                    End If

                End If

            End If

        End If

        'increment by one screen
        iIndex = Me.ScriptScreenIndex + 1

        If iIndex <= Me.ScreenCount Then
            Me.ScriptScreenIndex = iIndex
            Return True

        Else
            Me._iErrCode = ErrorCodes.END_OF_SCRIPT
            Me._sErrMsg = "End of script"
            Return False

        End If

    End Function

    Public Function PrevScreen() As Boolean
        Dim iIndex As Integer

        iIndex = Me.ScriptScreenIndex - 1

        If iIndex > 0 Then
            Me.ScriptScreenIndex = iIndex
            Return True

        Else
            Me._iErrCode = ErrorCodes.BEGINNING_OF_SCRIPT
            Me._sErrMsg = "Beginning of script"
            Return False

        End If

    End Function

    Public Function LoadDataSet(ByVal iScriptID As Integer, ByVal iRespondentID As Integer) As DataSet
        Dim sSQL As String
        Dim dr As DataRelation
        Dim colParent As DataColumn
        Dim colChild As DataColumn

        Me._iScriptID = iScriptID
        Me._iRespondentID = iRespondentID

        'Get respondent information
        sSQL = "SELECT RespondentID, SurveyInstanceID, FormattedName, City, State, TelephoneDay, TelephoneEvening, Gender, SurveyID, ClientID, SurveyName, ClientName, SurveyInstanceName "
        sSQL &= String.Format("FROM v_Respondents WHERE (RespondentID = {0})", Me._iRespondentID)
        DMI.DataHandler.GetDS(Me._sConnection, Me._dsScript, sSQL, "RespondentInfo")
        'Create dummary test respondent
        If Me._iRespondentID = 0 Then AddTestRespondent(Me._dsScript.Tables("RespondentInfo"))

        'Get script information
        sSQL = "SELECT scr.ScriptID, scr.SurveyID, scr.Name AS ScriptName, scr.CompletenessLevel, scr.FollowSkips, s.Name AS SurveyName "
        sSQL &= "FROM Scripts scr INNER JOIN Surveys s ON scr.SurveyID = s.SurveyID "
        sSQL &= String.Format("WHERE (scr.ScriptID = {0})", Me._iScriptID)
        DMI.DataHandler.GetDS(Me._sConnection, Me._dsScript, sSQL, "ScriptInfo")

        'Check initialized respondent and script data
        If VerifyRespondentScript() Then
            'Get script screens
            sSQL = String.Format("SELECT * FROM ScriptScreens WHERE (ScriptID = {0}) ORDER BY ItemOrder", Me._iScriptID)
            DMI.DataHandler.GetDS(Me._sConnection, Me._dsScript, sSQL, "ScriptScreens")

            'Get script screen categories
            sSQL = String.Format("EXEC spGetRespondentScriptCategories {0}, {1} ", Me._iRespondentID, Me._iScriptID)
            DMI.DataHandler.GetDS(Me._sConnection, Me._dsScript, sSQL, "RespondentScriptCategories")

            'Screen to Category data relation
            colParent = Me._dsScript.Tables("ScriptScreens").Columns("ScriptScreenID")
            colChild = Me._dsScript.Tables("RespondentScriptCategories").Columns("ScriptScreenID")
            dr = New DataRelation("Screen2Categories", colParent, colChild)
            Me._dsScript.Relations.Add(dr)

            'Add new columns to Categories table
            With Me._dsScript.Tables("RespondentScriptCategories")
                .Columns.Add("JumpToFlag", GetType(Integer), "JumpToScriptScreenID * IIF(ResponseStatus < 1, 0, 1)")
                .Columns.Add("MultiMark", GetType(Integer), "ResponseStatus * IIF(AnswerCategoryTypeID = 4, 1, 0)")
                .Columns("ResponseStatus").ReadOnly = False
                .Columns("ResponseText").ReadOnly = False

            End With

            'Add new columns to Script Screen table
            With Me._dsScript.Tables("ScriptScreens")
                .Columns.Add("JumpToScriptScreenID", GetType(Integer), "IIF(MIN(Child(Screen2Categories).JumpToFlag)<0,MIN(Child(Screen2Categories).JumpToFlag),MAX(Child(Screen2Categories).JumpToFlag))")
                .Columns.Add("Responded", GetType(Integer), "MAX(Child(Screen2Categories).ResponseStatus)")
                .Columns.Add("MultiMark", GetType(Integer), "MAX(Child(Screen2Categories).MultiMark)")
                .Columns.Add("ScreenStatus", GetType(Integer))
                .Columns("ScreenStatus").ReadOnly = False
                .Columns("ScreenStatus").AllowDBNull = True

            End With

            'Add new columns to Respondent Info table
            With Me._dsScript.Tables("RespondentInfo")
                .Columns.Add("Pronoun", GetType(String), "IIF(Gender = 'M', 'HE', 'SHE')")
                .Columns.Add("Possesive", GetType(String), "IIF(Gender = 'M', 'HIS', 'HERS')")

            End With

        End If

        Return Me._dsScript

    End Function

    Public Function VerifyDataSet(ByVal ds As DataSet) As Boolean

        If ds.Tables.IndexOf("RespondentInfo") > -1 Then
            If ds.Tables.IndexOf("ScriptInfo") > -1 Then
                If ds.Tables.IndexOf("RespondentScriptCategories") > -1 Then
                    If ds.Tables.IndexOf("ScriptScreens") > -1 Then
                        Me.DataSet = ds
                        Return True

                    End If
                End If
            End If
        End If

        Return False

    End Function

    Public Function UpdateScriptStatus() As DataTable
        Dim dr As DataRow
        Dim iJumpToIndex As Integer = 0
        Dim iScriptScreenID As Integer

        For Each dr In Me.ScriptScreenDataTable.Rows
            'Is screen associated with a survey question
            If Not IsDBNull(dr.Item("SurveyQuestionID")) Then
                'Does survey question have categories
                If Not IsDBNull(dr.Item("JumpToScriptScreenID")) Then
                    iScriptScreenID = CInt(dr.Item("JumpToScriptScreenID"))

                    If Me.GetScreenIndex(iScriptScreenID) > iJumpToIndex Then
                        'skipped screen, get new screen index
                        iJumpToIndex = Me.GetScreenIndex(iScriptScreenID)

                    ElseIf iScriptScreenID = -999 Then
                        'jump to end of script
                        iJumpToIndex = Me.ScriptScreenDataTable.Rows.Count + 1

                    End If

                    'set status code
                    If dr.Item("Responded") > 0 And dr.Item("MultiMark") = 0 Then
                        'screen answered
                        dr.Item("ScreenStatus") = qmsScreenStatus.ANSWERED

                    ElseIf dr.Item("ItemOrder") < iJumpToIndex Then
                        'Valid Screen Skip
                        dr.Item("ScreenStatus") = qmsScreenStatus.SKIPPED

                    ElseIf dr.Item("MultiMark") = 1 Then
                        'screen answered
                        dr.Item("ScreenStatus") = qmsScreenStatus.MULTIMARKED

                    Else
                        'Not answered
                        dr.Item("ScreenStatus") = qmsScreenStatus.NO_ANSWER

                    End If

                Else
                    'Survey question does not have categories, set to no answer
                    dr.Item("ScreenStatus") = qmsScreenStatus.NO_ANSWER

                End If

            Else
                'treat all non-survey question screens as answered
                dr.Item("ScreenStatus") = qmsScreenStatus.ANSWERED

            End If

        Next

        Me.ScriptScreenDataTable.AcceptChanges()

        Return Me.ScriptScreenDataTable

    End Function

    Private Function VerifyRespondentScript() As Boolean

        With Me._dsScript
            'Valid script id
            If Not .Tables("ScriptInfo").Rows.Count > 0 Then
                Me._sErrMsg = String.Format("Script id {0} does not exist.", Me._iScriptID)
                Return False

            End If

            If Me._iRespondentID > 0 Then
                'Valid respondent id
                If Not .Tables("RespondentInfo").Rows.Count > 0 Then
                    Me._sErrMsg = String.Format("Respondent id {0} does not exist.", Me._iRespondentID)
                    Return False

                End If

                'Valid script for respondent
                If .Tables("RespondentInfo").Rows(0).Item("SurveyID") <> .Tables("ScriptInfo").Rows(0).Item("SurveyID") Then
                    Me._sErrMsg = String.Format("Script id {0} does not belong to respondent's survey.", Me._iScriptID)
                    Return False

                End If

            End If

        End With

        'Everything is alright
        Return True

    End Function

    Private Sub GetScreenByIndex(Optional ByVal iScreenIndex As Integer = 1)
        Dim iScriptScreenID As Integer

        'Index must be zero or positive
        If iScreenIndex > 0 Then
            'Index must be less than screen count
            If iScreenIndex <= Me._dsScript.Tables("ScriptScreens").Rows.Count Then
                'set script screen data row
                Me._drCurrentScriptScreen = Me._dsScript.Tables("ScriptScreens").Rows(iScreenIndex - 1)
                iScriptScreenID = Me._drCurrentScriptScreen.Item("ScriptScreenID")

                'set script categories data view
                Me._dvCurrentScriptCategories = Me._dsScript.Tables("RespondentScriptCategories").DefaultView
                Me._dvCurrentScriptCategories.RowFilter = String.Format("ScriptScreenID = {0}", iScriptScreenID)
                Me._dvCurrentScriptCategories.Sort = "AnswerValue"


            Else
                Me._sErrMsg = "Screen index exceeds screen count."
                Me._iErrCode = ErrorCodes.END_OF_SCRIPT

            End If

        Else
            Me._sErrMsg = "Screen index cannot be less than 1."
            Me._iErrCode = ErrorCodes.INVALID_INDEX

        End If

    End Sub

    Private Sub GetScreenByID(ByVal iScriptScreenID As Integer)
        Dim iScreenIndex As Integer
        Dim dv As DataView

        'dv = Me._dsScript.Tables("ScriptScreens").DefaultView
        'dv.Sort = "ScriptScreenID"
        'iScreenIndex = dv.Find(iScriptScreenID)

        iScreenIndex = Me.GetScreenIndex(iScriptScreenID) - 1

        If iScreenIndex >= 0 Then
            'set script screen data row
            Me._drCurrentScriptScreen = Me.ScriptScreenDataTable.Rows(iScreenIndex)

            'set script categories data view
            Me._dvCurrentScriptCategories = Me._dsScript.Tables("RespondentScriptCategories").DefaultView
            Me._dvCurrentScriptCategories.RowFilter = String.Format("ScriptScreenID = {0}", iScriptScreenID)
            Me._dvCurrentScriptCategories.Sort = "AnswerValue"

        Else
            Me._sErrMsg = String.Format("Script screen id {0} not found.", iScriptScreenID)
            Me._iErrCode = ErrorCodes.INVALID_ID

        End If

    End Sub

    Public Function GetAnswerCategoryType(ByVal iValue As Integer) As qmsAnswerCategoryTypes
        Dim drs As DataRow()
        Dim iScriptScreenID As Integer = _drCurrentScriptScreen.Item("ScriptScreenID")

        drs = Me._dsScript.Tables("RespondentScriptCategories").Select(String.Format("ScriptScreenID = {0} AND AnswerValue ={1}", iScriptScreenID, iValue))

        If drs.Length > 0 Then
            Return drs(0).Item("AnswerCategoryTypeID")

        Else
            Return Nothing

        End If

    End Function

    Public Sub SubmitResponse(ByVal sValues() As String, ByVal htText As Hashtable)
        Dim drv As DataRowView
        Dim iValue As Integer

        For Each drv In Me._dvCurrentScriptCategories
            iValue = drv.Item("AnswerValue")

            If Array.IndexOf(sValues, CType(iValue, String)) >= 0 Then
                'Category selected
                If drv.Item("ResponseStatus") = qmsResponseStatus.NOT_SELECTED Then
                    'select if not already selected
                    drv.Item("ResponseStatus") = qmsResponseStatus.UPDATE_TO_SELECTED

                ElseIf drv.Item("ResponseStatus") = qmsResponseStatus.UPDATE_TO_NOT_SELECTED Then
                    'was unselected, now restore selection
                    drv.Item("ResponseStatus") = qmsResponseStatus.SELECTED

                End If

                'Check text answers
                If drv.Item("AnswerCategoryTypeID") = qmsAnswerCategoryTypes.OPEN_ANSWER And _
                    htText(drv.Item("AnswerValue")) = "" Then
                    'Remove all Open Answer Responses with no text
                    If drv.Item("ResponseStatus") = qmsResponseStatus.UPDATE_TO_SELECTED Then
                        drv.Item("ResponseStatus") = qmsResponseStatus.NOT_SELECTED

                    ElseIf drv.Item("ResponseStatus") = qmsResponseStatus.SELECTED Then
                        drv.Item("ResponseStatus") = qmsResponseStatus.UPDATE_TO_NOT_SELECTED

                    End If

                ElseIf drv.Item("AnswerCategoryTypeID") = qmsAnswerCategoryTypes.SELECT_OPEN_ANSWER Or _
                    drv.Item("AnswerCategoryTypeID") = qmsAnswerCategoryTypes.OPEN_ANSWER Then

                    If htText(drv.Item("AnswerValue")) <> DMI.clsUtil.DeNull(drv.Item("ResponseText")) Then
                        'If answer text has changed, perform update...
                        drv.Item("ResponseText") = htText(drv.Item("AnswerValue"))
                        If drv.Item("ResponseStatus") = qmsResponseStatus.SELECTED Then
                            'flag to update already selected category
                            drv.Item("ResponseStatus") = qmsResponseStatus.SELECTION_CHANGED

                        End If
                    End If
                End If

            Else
                'Category was not selected
                If drv.Item("ResponseStatus") = qmsResponseStatus.UPDATE_TO_NOT_SELECTED _
                    Or drv.Item("ResponseStatus") = qmsResponseStatus.NOT_SELECTED Then
                    'Already unselected, do nothing

                Else
                    'All other status, update to not selected
                    drv.Item("ResponseStatus") = qmsResponseStatus.UPDATE_TO_NOT_SELECTED

                End If


            End If
        Next

    End Sub

    'Translates Script Screen ID to Index
    Public Function GetScreenIndex(ByVal iScriptScreenID As Integer) As Integer
        Dim dv As DataView
        Dim drv As DataRowView

        dv = Me.ScriptScreenDataTable.DefaultView
        dv.RowFilter = String.Format("ScriptScreenID = {0}", iScriptScreenID)
        For Each drv In dv
            Return drv.Item("ItemOrder")

        Next

        Return 0

    End Function

    'Updates rows in CurrentCategoriesDataView
    Public Function UpdateResponse() As DataSet
        Dim dv As DataView
        Dim drv As DataRowView
        Dim sSQL As String = ""

        dv = Me._dsScript.Tables("RespondentScriptCategories").DefaultView
        dv.RowFilter = "ResponseStatus < 0"

        For Each drv In dv
            Select Case drv.Item("ResponseStatus")
                Case qmsResponseStatus.SELECTION_CHANGED
                    sSQL &= String.Format("UPDATE Responses SET ResponseText = {3} WHERE RespondentID = {0} AND SurveyQuestionID = {1} AND AnswerCategoryID = {2}; ", _
                            Me._iRespondentID, _
                            drv.Item("SurveyQuestionID"), _
                            drv.Item("AnswerCategoryID"), _
                            DMI.DataHandler.QuoteString(IIf(IsDBNull(drv.Item("ResponseText")), "", drv.Item("ResponseText"))))

                Case qmsResponseStatus.UPDATE_TO_SELECTED
                    sSQL &= String.Format("INSERT INTO Responses(RespondentID, SurveyQuestionID, AnswerCategoryID, ResponseText) VALUES({0},{1},{2},{3}); ", _
                            Me._iRespondentID, _
                            drv.Item("SurveyQuestionID"), _
                            drv.Item("AnswerCategoryID"), _
                            DMI.DataHandler.QuoteString(IIf(IsDBNull(drv.Item("ResponseText")), "", drv.Item("ResponseText"))))

                Case qmsResponseStatus.UPDATE_TO_NOT_SELECTED
                    sSQL &= String.Format("DELETE FROM Responses WHERE RespondentID = {0} AND SurveyQuestionID = {1} AND AnswerCategoryID = {2}; ", _
                            Me._iRespondentID, _
                            drv.Item("SurveyQuestionID"), _
                            drv.Item("AnswerCategoryID"))

            End Select

        Next

        If sSQL.Length > 0 Then
            DMI.SqlHelper.ExecuteNonQuery(Me._sConnection, CommandType.Text, sSQL)

        End If

        Return ResetResponseStatus()

    End Function

    Public Function ResetResponseStatus() As DataSet
        Dim dv As DataView
        Dim drv As DataRowView

        dv = Me._dsScript.Tables("RespondentScriptCategories").DefaultView
        dv.RowFilter = String.Format("ScriptScreenID = {0}", Me.ScriptScreenID)

        For Each drv In dv
            Select Case drv.Item("ResponseStatus")
                Case qmsResponseStatus.SELECTION_CHANGED, qmsResponseStatus.UPDATE_TO_SELECTED
                    drv.Item("ResponseStatus") = qmsResponseStatus.SELECTED

                Case qmsResponseStatus.UPDATE_TO_NOT_SELECTED
                    drv.Item("ResponseStatus") = qmsResponseStatus.NOT_SELECTED

            End Select

        Next

        Me._dsScript.Tables("RespondentScriptCategories").AcceptChanges()

        Return Me._dsScript

    End Function

    Public Sub ScoreScript()
        Dim dr As DataRow
        Dim dt As DataTable
        Dim iNumerator As Integer = 0
        Dim iDenominator As Integer = 0
        Dim dblScore As Double = 0.0
        Dim r As clsRespondents
        Dim cc As QMS.qmsEvents

        dt = Me.UpdateScriptStatus

        For Each dr In dt.Rows

            If Not IsDBNull(dr.Item("SurveyQuestionID")) Then

                Select Case dr.Item("CalculationTypeID")
                    Case qmsScreenCalculationTypes.REQUIRED_SCREEN
                        If dr.Item("ScreenStatus") = qmsScreenStatus.ANSWERED Then
                            iNumerator += 1
                            iDenominator += 1

                        ElseIf dr.Item("ScreenStatus") = qmsScreenStatus.NO_ANSWER Or _
                            dr.Item("ScreenStatus") = qmsScreenStatus.MULTIMARKED Then

                            iDenominator += 1

                        End If

                    Case qmsScreenCalculationTypes.OPTIONAL_SCREEN
                        If dr.Item("ScreenStatus") = qmsScreenStatus.ANSWERED Then
                            iNumerator += 1
                            iDenominator += 1

                        ElseIf dr.Item("ScreenStatus") = qmsScreenStatus.NO_ANSWER Or _
                            dr.Item("ScreenStatus") = qmsScreenStatus.MULTIMARKED Then
                            'Do nothing, optional question

                        End If

                    Case qmsScreenCalculationTypes.EXCLUDED_SCREEN
                        'Do nothing, excluded from scoring

                End Select

            End If

        Next

        If iDenominator = 0 Then iDenominator = 1

        dblScore = (iNumerator / iDenominator) * 100

        r = New clsRespondents(Me._sConnection, Me.RespondentID)
        If Me.ScriptDataRow.Item("CompletenessLevel") <= dblScore Then
            'Survey complete
            Select Case Me._iInputMode
                Case QMS.qmsInputMode.DATAENTRY
                    cc = QMS.qmsEvents.DE_COMPLETE_SURVEY

                Case QMS.qmsInputMode.VERIFY
                    cc = QMS.qmsEvents.VERIFY_COMPLETE_SURVEY

                Case QMS.qmsInputMode.CATI
                    cc = QMS.qmsEvents.CATI_COMPLETE_SURVEY

                Case QMS.qmsInputMode.RCALL
                    cc = QMS.qmsEvents.REMINDER_COMPLETE_SURVEY

                Case Else
                    'do not validate for other input modes
                    Exit Sub

            End Select

        Else
            'Survey incomplete
            Select Case Me._iInputMode
                Case QMS.qmsInputMode.DATAENTRY
                    cc = QMS.qmsEvents.DE_INCOMPLETE_SURVEY

                Case QMS.qmsInputMode.VERIFY
                    cc = QMS.qmsEvents.VERIFY_INCOMPLETE_SURVEY

                Case QMS.qmsInputMode.CATI
                    cc = QMS.qmsEvents.CATI_INCOMPLETE_SURVEY

                Case QMS.qmsInputMode.RCALL
                    cc = QMS.qmsEvents.REMINDER_INCOMPLETE_SURVEY

                Case Else
                    'do not validate for other input modes
                    Exit Sub

            End Select

        End If

        r.ClearCompleteness()
        r.InsertEvent(cc, Me._iUserID, dblScore.ToString("0.0"))

    End Sub

    Private Sub AddTestRespondent(ByRef dtRespondent As DataTable)
        Dim dr As DataRow

        dr = dtRespondent.NewRow()

        dr.Item("RespondentID") = 0
        dr.Item("SurveyInstanceID") = 0
        dr.Item("FormattedName") = "Test Respondent"
        dr.Item("City") = "San Francisco"
        dr.Item("State") = "CA"
        dr.Item("TelephoneDay") = "5555555555"
        dr.Item("TelephoneEvening") = "5555555555"
        dr.Item("Gender") = "F"
        dr.Item("SurveyID") = 0
        dr.Item("ClientID") = 0
        dr.Item("SurveyName") = ""
        dr.Item("ClientName") = "DMI"
        dr.Item("SurveyInstanceName") = String.Format("{0:MMM yyyy}", Now())

        dtRespondent.Rows.Add(dr)

    End Sub

    Public Sub RenderHTMLCategoryControls(ByRef ph As PlaceHolder)
        Dim drv As DataRowView
        Dim wft As DMI.WebFormTools
        Dim hc As HtmlControl

        For Each drv In Me._dvCurrentScriptCategories

            If drv.Item("ShowCategory") = 1 Then

                Select Case drv.Item("AnswerCategoryTypeID")
                    Case qmsAnswerCategoryTypes.SELECT_ITEM, qmsAnswerCategoryTypes.MULTIMARK_SELECT
                        If drv.Item("QuestionTypeID") = qmsQuestionType.SingleSelect Then
                            'single select radio button
                            hc = wft.GetRadioButton("Response", _
                                                    drv.Item("AnswerValue"), _
                                                    IIf(drv.Item("ResponseStatus") > 0 And Me._iInputMode <> QMS.qmsInputMode.VERIFY, 1, 0), _
                                                    String.Format("C{0}", drv.Item("AnswerValue")))
                            hc.Attributes.Add("onClick", "checkRadio(this)")
                            ph.Controls.Add(hc)
                        Else
                            'multi select checkbox
                            ph.Controls.Add(wft.GetCheckBoxHTML("Response", _
                                                drv.Item("AnswerValue"), _
                                                IIf(drv.Item("ResponseStatus") > 0 And Me._iInputMode <> QMS.qmsInputMode.VERIFY, 1, 0), _
                                                String.Format("C{0}", drv.Item("AnswerValue"))))

                        End If

                        ph.Controls.Add(wft.GetLiteral(String.Format("&nbsp;{0}:&nbsp;<strong>{1}</strong><br>", drv.Item("AnswerValue"), drv.Item("AnswerText"))))

                    Case qmsAnswerCategoryTypes.SELECT_OPEN_ANSWER
                        If drv.Item("QuestionTypeID") = qmsQuestionType.SingleSelect Then
                            'single select radio button
                            hc = wft.GetRadioButton("Response", _
                                                    drv.Item("AnswerValue"), _
                                                    IIf(drv.Item("ResponseStatus") > 0 And Me._iInputMode <> QMS.qmsInputMode.VERIFY, 1, 0), _
                                                    String.Format("C{0}", drv.Item("AnswerValue")))
                            hc.Attributes.Add("onClick", "checkRadio(this)")
                            ph.Controls.Add(hc)

                        Else
                            'multi select checkbox
                            ph.Controls.Add(wft.GetCheckBoxHTML("Response", _
                                                drv.Item("AnswerValue"), _
                                                IIf(drv.Item("ResponseStatus") > 0 And Me._iInputMode <> QMS.qmsInputMode.VERIFY, 1, 0), _
                                                String.Format("C{0}", drv.Item("AnswerValue"))))

                        End If

                        ph.Controls.Add(wft.GetLiteral(String.Format("&nbsp;{0}:&nbsp;<strong>{1}</strong>:&nbsp;", drv.Item("AnswerValue"), drv.Item("AnswerText"))))
                        hc = wft.GetTextBox(String.Format("OA{0}", _
                                            drv.Item("AnswerValue")), _
                                            IIf(Me._iInputMode <> QMS.qmsInputMode.VERIFY, DMI.clsUtil.DeNull(drv.Item("ResponseText")), ""))
                        hc.Attributes.Add("onFocus", "focusTextBox()")
                        hc.Attributes.Add("onBlur", "focusTextBox()")
                        ph.Controls.Add(hc)
                        ph.Controls.Add(wft.GetLiteral("<br>"))

                    Case qmsAnswerCategoryTypes.OPEN_ANSWER
                        ph.Controls.Add(wft.GetHiddenField("Response", drv.Item("AnswerValue")))
                        ph.Controls.Add(wft.GetLiteral(String.Format("<small>{0} {1}:</small><br>", drv.Item("AnswerValue"), drv.Item("AnswerText"))))
                        hc = wft.GetTextBox(String.Format("OA{0}", _
                                            drv.Item("AnswerValue")), _
                                            IIf(Me._iInputMode <> QMS.qmsInputMode.VERIFY, DMI.clsUtil.DeNull(drv.Item("ResponseText")), ""))
                        hc.Attributes.Add("onFocus", "focusTextBox()")
                        hc.Attributes.Add("onBlur", "focusTextBox()")
                        ph.Controls.Add(hc)
                        ph.Controls.Add(wft.GetLiteral("<br>"))

                End Select

            End If

        Next

    End Sub

    Private Function ReplaceScreenTextTokens(ByVal sScreenText As String) As String
        Dim re As System.Text.RegularExpressions.Regex
        Dim f As New QMS.clsScriptTextTokens(Me._sConnection, Me._iRespondentID)

        'replace classic tokens
        sScreenText = re.Replace(sScreenText, "%([\w\s]+)%", New System.Text.RegularExpressions.MatchEvaluator(AddressOf Me.ClassicToken))
        'replace token functions
        sScreenText = re.Replace(sScreenText, "([\w]+)\(([\w]+)\)", New System.Text.RegularExpressions.MatchEvaluator(AddressOf f.EvalTokenFunc))

        Return sScreenText

    End Function

    Private Function ClassicToken(ByVal m As System.Text.RegularExpressions.Match) As String
        Dim sToken As String = m.Groups(1).ToString.ToUpper.Trim

        Select Case sToken
            Case "CLIENT NAME"
                Return Me.RespondentDataRow.Item("ClientName").ToString

            Case "SURVEY NAME"
                Return Me.ScriptDataRow.Item("SurveyName").ToString

            Case "SURVEY INSTANCE NAME"
                Return Me.RespondentDataRow.Item("SurveyInstanceName").ToString

            Case "RESPONDENT NAME"
                Return Me.RespondentDataRow.Item("FormattedName").ToString

            Case "RESPONDENT CITY"
                Return Me.RespondentDataRow.Item("City").ToString

            Case "RESPONDENT STATE"
                Return Me.RespondentDataRow.Item("State").ToString

            Case "RESPONDENT PRONOUN"
                If Me.RespondentDataRow.Item("Gender").ToString.ToUpper = "M" Then
                    Return "HE"
                Else
                    Return "SHE"
                End If
                'Return Me.RespondentDataRow.Item("Pronoun").ToString

            Case "RESPONDENT POSSESIVE"
                If Me.RespondentDataRow.Item("Gender").ToString.ToUpper = "M" Then
                    Return "HIS"
                Else
                    Return "HERS"
                End If
                'Return Me.RespondentDataRow.Item("Possesive").ToString

            Case "INTERVIEWER NAME"
                Return GetInterviewerName()

        End Select

    End Function

    Private Function GetInterviewerName()
        Dim u As QMS.clsUsers

        u = New QMS.clsUsers(Me._sConnection, Me._iUserID)
        Return u.MainDataTable.Rows(0).Item("FirstName").ToString

    End Function

End Class
