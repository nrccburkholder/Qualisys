Public Enum tblRespondentCallList
    RespondentID = 0
    SurveyID = 1
    ClientID = 2
    SurveyInstanceID = 3
    SurveyName = 4
    ClientName = 5
    SurveyInstanceName = 6
    FirstName = 7
    LastName = 8
    City = 9
    State = 10
    StateTime = 11
    TimeDifference = 12
    BatchID = 13
    NextContact = 14
    CallsMade = 15
    Batched = 16
    EarliestTime = 17
    LatestTime = 18
    EventCode = 19

End Enum

<Obsolete("use QMS.clsCallList", True)> _
Public Class clsRespondentCallList

    Sub New(ByVal sConnStr As String, Optional ByVal iEntityID As Integer = 0)
        ConnectionString = sConnStr
        _iEntityID = iEntityID
        Me.InitClass()

    End Sub

    Public ConnectionString As String = ""

    Public _iEntityID As Integer = 0

    Private _dsEntity As DataSet

    Private _sTableName As String

    Private _sSelectSQL As String

    Private _sErrorMsg As String = ""

    Private _iSurveyInstanceID As Integer = 0

    Private _iSurveyID As Integer = 0

    Private _iClientID As Integer = 0

    Private _iTimeDifference As Integer = -99

    Private _sHasBatchID As String = ""

    Private _iCallsMade As Integer = 0

    Private _sState As String = ""

    Private _sEarliestTime As String

    Private _sLatestTime As String

    Private _iEventCode As qmsEventCodes = qmsEventCodes.NONE

    Default Public Overloads Property Details(ByVal eField As tblRespondentCallList) As Object
        Get
            If eField = tblRespondentCallList.EventCode Then Return _iEventCode

            Return Me._dsEntity.Tables(Me._sTableName).Rows(0).Item(eField.ToString)

        End Get

        Set(ByVal Value As Object)
            If eField = tblRespondentCallList.RespondentID Then
                Me._iEntityID = Value

            ElseIf eField = tblRespondentCallList.SurveyInstanceID Then
                Me._iSurveyInstanceID = Value

            ElseIf eField = tblRespondentCallList.SurveyID Then
                Me._iSurveyID = Value

            ElseIf eField = tblRespondentCallList.ClientID Then
                Me._iClientID = Value

            ElseIf eField = tblRespondentCallList.TimeDifference Then
                Me._iTimeDifference = Value

            ElseIf eField = tblRespondentCallList.Batched Then
                Me._sHasBatchID = Value

            ElseIf eField = tblRespondentCallList.State Then
                Me._sState = Value

            ElseIf eField = tblRespondentCallList.EarliestTime Then
                Me._sEarliestTime = Value

            ElseIf eField = tblRespondentCallList.LatestTime Then
                Me._sLatestTime = Value

            ElseIf eField = tblRespondentCallList.EventCode Then
                Me._iEventCode = Value

            ElseIf eField = tblRespondentCallList.CallsMade Then
                Me._iCallsMade = Value

            End If

        End Set

    End Property

    Public Property DataSet() As System.Data.DataSet
        Get
            Return Me._dsEntity

        End Get

        Set(ByVal Value As DataSet)
            Me._dsEntity = Value

            If Me._dsEntity.Tables.IndexOf(Me._sTableName) > -1 Then
                If Me._dsEntity.Tables(Me._sTableName).Rows.Count > 0 Then
                    Me._iEntityID = IIf(Me.Details(tblRespondentCallList.RespondentID) Is DBNull.Value, 0, Me.Details(tblRespondentCallList.RespondentID))

                End If
            End If
        End Set

    End Property

    Public ReadOnly Property NamedDataSet(ByVal sName As String) As DataSet
        Get

            If sName.Length > 0 Then Me._dsEntity.DataSetName = sName

            Return Me._dsEntity

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


    Public ReadOnly Property ErrorMsgs() As String
        Get
            Return Me._sErrorMsg
        End Get

    End Property

    Protected Sub InitClass()

        'Define table
        Me._sTableName = "RespondentCallList"

        'SELECT SQL
        Me._sSelectSQL = "SELECT * FROM v_RespondentCallList "

    End Sub

    Public Sub Clear()
        Me._iEntityID = 0
        Me._iClientID = 0
        Me._iSurveyID = 0
        Me._iSurveyInstanceID = 0
        Me._iTimeDifference = -99
        Me._sHasBatchID = ""
        Me._sState = ""
        Me._iCallsMade = 0
        Me._sEarliestTime = "9:00 AM"
        Me._sLatestTime = "9:00 PM"
        Me._iEventCode = qmsEventCodes.NONE

    End Sub

    Public Function GetDetails() As DataSet
        Dim sSQL As String

        sSQL = Me.GetSearchSQL()

        If Not IsNothing(Me._dsEntity) Then
            If Me._dsEntity.Tables.IndexOf(Me._sTableName) > -1 Then
                Me._dsEntity.Tables.Remove(Me._sTableName)

            End If

        End If

        If DMI.DataHandler.GetDS(Me.ConnectionString, Me._dsEntity, sSQL, Me._sTableName) Then
            Return Me._dsEntity

        End If

    End Function

    Protected Function GetSearchSQL() As String
        Dim sWHERESQL As New System.Text.StringBuilder()
        Dim sEventLogSQL As New System.Text.StringBuilder()

        'Identity criteria
        If Me._iEntityID > 0 Then
            sWHERESQL.AppendFormat("RespondenID = {0} AND ", Me._iEntityID)

        Else
            'filter by survey instance
            If Me._iSurveyInstanceID > 0 Then sWHERESQL.AppendFormat("SurveyInstanceID = {0} AND ", Me._iSurveyInstanceID)

            'filter by survey
            If Me._iSurveyID > 0 Then sWHERESQL.AppendFormat("SurveyID = {0} AND ", Me._iSurveyID)

            'filter by client
            If Me._iClientID > 0 Then sWHERESQL.AppendFormat("ClientID = {0} AND ", Me._iClientID)

            'filter by time zone
            If Me._iTimeDifference > -99 Then sWHERESQL.AppendFormat("TimeDifference = {0} AND ", Me._iTimeDifference)

            'filter by state
            If Me._sState.Length > 0 Then sWHERESQL.AppendFormat("State = {0} AND ", DMI.DataHandler.QuoteString(Me._sState))

            'filter by batch
            If Me._sHasBatchID.ToUpper = "Y" Then
                sWHERESQL.Append("BatchID IS NOT NULL AND ")

            ElseIf Me._sHasBatchID.ToUpper = "N" Then
                sWHERESQL.Append("BatchID IS NULL AND ")

            End If

            'filter by time range
            If Me._sEarliestTime.Length > 0 And Me._sLatestTime.Length > 0 Then
                sWHERESQL.AppendFormat("(CAST(CONVERT(CHAR(8), StateTime, 108) AS datetime) BETWEEN {0} AND {1}) AND ", _
                            DMI.DataHandler.QuoteString(Me._sEarliestTime), DMI.DataHandler.QuoteString(Me._sLatestTime))

            ElseIf Me._sEarliestTime.Length > 0 Then
                sWHERESQL.AppendFormat("(CAST(CONVERT(CHAR(8), StateTime, 108) AS datetime) >= {0}) AND ", _
                            DMI.DataHandler.QuoteString(Me._sEarliestTime))

            ElseIf Me._sLatestTime.Length > 0 Then
                sWHERESQL.AppendFormat("(CAST(CONVERT(CHAR(8), StateTime, 108) AS datetime) <= {0}) AND ", _
                            DMI.DataHandler.QuoteString(Me._sLatestTime))

            End If

            'filter by incompletes codes
            If Me._iEventCode > 0 Then sWHERESQL.AppendFormat("RespondentID IN (SELECT RespondentID FROM EventLog WHERE EventID = {0}) AND ", CInt(Me._iEventCode))
            If Me._iEventCode < 0 Then
                Select Case Me._iEventCode
                    Case qmsEventCodes.MAILING_SURVEY_1ST
                        sWHERESQL.AppendFormat("RespondentID NOT IN (SELECT RespondentID FROM EventLog WHERE EventID = {0}) AND ", CInt(qmsEventCodes.BATCH_RESPONDENT))
                        sWHERESQL.AppendFormat("RespondentID IN (SELECT RespondentID FROM EventLog WHERE (EventID = {0}) GROUP BY RespondentID HAVING (COUNT(EventLogID) = 1)) AND ", CInt(qmsEventCodes.MAILING_SURVEY))

                    Case qmsEventCodes.MAILING_SURVEY_2ND
                        sWHERESQL.AppendFormat("RespondentID NOT IN (SELECT RespondentID FROM EventLog WHERE EventID = {0}) AND ", CInt(qmsEventCodes.BATCH_RESPONDENT))
                        sWHERESQL.AppendFormat("RespondentID IN (SELECT RespondentID FROM EventLog WHERE (EventID = {0}) GROUP BY RespondentID HAVING (COUNT(EventLogID) = 2)) AND ", CInt(qmsEventCodes.MAILING_SURVEY))

                    Case Else
                        sWHERESQL.AppendFormat("RespondentID NOT IN (SELECT RespondentID FROM EventLog WHERE EventID = {0}) AND ", CInt(Me._iEventCode) * -1)

                End Select

            End If

            sWHERESQL.AppendFormat("CallsMade = {0} AND ", Me._iCallsMade)

        End If

        If sWHERESQL.ToString <> "" Then
            sWHERESQL.Insert(0, "WHERE ")
            sWHERESQL.Remove(sWHERESQL.Length - 4, 4)

        End If

        sWHERESQL.Insert(0, Me._sSelectSQL)

        Return sWHERESQL.ToString

    End Function

    Public Function GetRespondent(ByVal iUserID As Integer, Optional ByVal iInputMode As qmsInputMode = qmsInputMode.CATI) As Integer
        Dim sSQL As String
        Dim dr As DataRow
        Dim iRespondentID As Integer = -1
        Dim iLogEventID As qmsEventCodes = qmsEventCodes.RESPONDENT_SELECTED_CATICALL

        If iInputMode = qmsInputMode.RCALL Then
            iLogEventID = qmsEventCodes.RESPONDENT_SELECTED_REMINDERCALL

        End If

        If Not IsNothing(Me._dsEntity) Then
            If Me._dsEntity.Tables.IndexOf("RespondentCallList") > -1 Then

                For Each dr In Me._dsEntity.Tables("RespondentCallList").Rows
                    sSQL = String.Format("EXEC spGetRespondentFromCallList {0}, {1}, {2}", _
                                dr.Item("RespondentID"), iUserID, CInt(iLogEventID))
                    iRespondentID = CInt(DMI.SqlHelper.ExecuteScalar(Me.ConnectionString, CommandType.Text, sSQL))

                    If iRespondentID > 0 Then
                        Return iRespondentID

                    End If

                Next

            End If
        End If

        Me._sErrorMsg = "No Respondents Available"
        Return -1

    End Function

End Class
