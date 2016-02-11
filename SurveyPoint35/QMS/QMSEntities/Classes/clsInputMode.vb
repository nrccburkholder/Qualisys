Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports DMI
Imports System.Data.Common

Public Enum qmsInputMode As Integer
    NOTINITIALIZED = -1
    VIEW = 0
    DATAENTRY = 1
    VERIFY = 2
    CATI = 3
    RCALL = 4
    BATCH = 5
    WEB = 6
    REMOTE = 7
    INCOMING = 8
    READ_ONLY = 9
    TEST = 999

End Enum

#Region "Input Mode Interfaces"
Public Interface IInputMode
    ReadOnly Property InputMode() As qmsInputMode
    ReadOnly Property InputModeName() As String
    ReadOnly Property ProtocolStepTypeID() As Integer
    ReadOnly Property EventTypeIDList() As String
    ReadOnly Property SelectEventID() As qmsEvents
    ReadOnly Property StartEventID() As qmsEvents
    ReadOnly Property EndEventID() As qmsEvents
    ReadOnly Property ScriptTypeIDList() As String
    ReadOnly Property CompleteCodeID() As qmsEvents
    ReadOnly Property IncompleteCodeID() As qmsEvents
    Function AllowUser(ByRef arlPrivledges As ArrayList) As Boolean
    Function AllowRespondent(ByVal oConn As SqlClient.SqlConnection, ByVal iRespondentID As Integer) As Boolean
    ReadOnly Property ErrorMsg() As String

End Interface

'data entry
Public Class clsInputModeDataEntry
    Implements IInputMode

    Private _sErrorMsg As String

    Public ReadOnly Property ErrorMsg() As String Implements QMS.IInputMode.ErrorMsg
        Get
            Return _sErrorMsg

        End Get
    End Property

    Public Function AllowRespondent(ByVal oConn As System.Data.SqlClient.SqlConnection, ByVal iRespondentID As Integer) As Boolean Implements QMS.IInputMode.AllowRespondent
        Dim iProtocolID As Integer = clsRespondents.ProtocolID(oConn, iRespondentID)

        'in active survey instance?
        If clsRespondents.InActiveSurveyInstance(oConn, iRespondentID) Then
            'has data entry step?
            If clsProtocols.ContainsProtocolStepType(oConn, iProtocolID, Me.ProtocolStepTypeID) Then
                'is respondent final?
                If Not clsRespondents.IsBatchFinal(oConn, iRespondentID) Then
                    'has batching step?
                    If clsProtocols.ContainsProtocolStepType(oConn, iProtocolID, qmsProtocolStepTypes.BATCHING) Then
                        'check if respondent has been batched
                        If clsRespondents.HasBeenInputed(oConn, iRespondentID, qmsInputMode.BATCH) Then
                            Return True

                        End If
                        _sErrorMsg = String.Format("Respondent {0} must be batched first.\n", iRespondentID)
                        Return False

                    Else
                        Return True

                    End If

                Else
                    _sErrorMsg = String.Format("Respondent {0} is final.\n", iRespondentID)
                    Return False

                End If
            Else
                _sErrorMsg = String.Format("Respondent {0} does not have {1} step.\n", iRespondentID, Me.InputModeName)
                Return False

            End If
        Else
            _sErrorMsg = String.Format("Respondent {0} in inactive survey instance.\n", iRespondentID, Me.InputModeName)
            Return False

        End If

    End Function

    Public Function AllowUser(ByRef arlPrivledges As System.Collections.ArrayList) As Boolean Implements QMS.IInputMode.AllowUser
        Return clsQMSSecurity.CheckPrivledge(arlPrivledges, qmsSecurity.DATA_ENTRY)

    End Function

    Public ReadOnly Property EventTypeIDList() As String Implements QMS.IInputMode.EventTypeIDList
        Get
            Return "4"

        End Get
    End Property

    Public ReadOnly Property InputModeName() As String Implements QMS.IInputMode.InputModeName
        Get
            Return "Data Entry"

        End Get
    End Property

    Public ReadOnly Property ProtocolStepTypeID() As Integer Implements QMS.IInputMode.ProtocolStepTypeID
        Get
            Return qmsProtocolStepTypes.DATAENTRY

        End Get
    End Property

    Public ReadOnly Property SelectEventID() As QMS.qmsEvents Implements QMS.IInputMode.SelectEventID
        Get
            Return qmsEvents.RESPONDENT_SELECTED_DATAENTRY

        End Get
    End Property

    Public ReadOnly Property StartEventID() As QMS.qmsEvents Implements QMS.IInputMode.StartEventID
        Get
            Return qmsEvents.DE_START

        End Get
    End Property

    Public ReadOnly Property EndEventID() As QMS.qmsEvents Implements QMS.IInputMode.EndEventID
        Get
            Return qmsEvents.DE_END

        End Get
    End Property

    Public ReadOnly Property InputMode() As QMS.qmsInputMode Implements QMS.IInputMode.InputMode
        Get
            Return qmsInputMode.DATAENTRY

        End Get
    End Property

    Public ReadOnly Property ScriptTypeIDList() As String Implements IInputMode.ScriptTypeIDList
        Get
            Return "1"

        End Get
    End Property

    Public ReadOnly Property CompleteCodeID() As qmsEvents Implements IInputMode.CompleteCodeID
        Get
            Return qmsEvents.DE_COMPLETE_SURVEY
        End Get
    End Property

    Public ReadOnly Property IncompleteCodeID() As qmsEvents Implements IInputMode.IncompleteCodeID
        Get
            Return qmsEvents.DE_INCOMPLETE_SURVEY
        End Get
    End Property

End Class

'verification
Public Class clsInputModeVerification
    Implements IInputMode

    Private _sErrorMsg As String

    Public ReadOnly Property ScriptTypeIDList() As String Implements IInputMode.ScriptTypeIDList
        Get
            Return "1"

        End Get
    End Property

    Public ReadOnly Property CompleteCodeID() As qmsEvents Implements IInputMode.CompleteCodeID
        Get
            Return qmsEvents.VERIFY_COMPLETE_SURVEY
        End Get
    End Property

    Public ReadOnly Property IncompleteCodeID() As qmsEvents Implements IInputMode.IncompleteCodeID
        Get
            Return qmsEvents.VERIFY_INCOMPLETE_SURVEY
        End Get
    End Property

    Public ReadOnly Property ErrorMsg() As String Implements QMS.IInputMode.ErrorMsg
        Get
            Return _sErrorMsg

        End Get
    End Property

    Public Function AllowRespondent(ByVal oConn As System.Data.SqlClient.SqlConnection, ByVal iRespondentID As Integer) As Boolean Implements QMS.IInputMode.AllowRespondent
        Dim iProtocolID As Integer = clsRespondents.ProtocolID(oConn, iRespondentID)

        'in active survey instance?
        If clsRespondents.InActiveSurveyInstance(oConn, iRespondentID) Then
            'has verification step?
            If clsProtocols.ContainsProtocolStepType(oConn, iProtocolID, Me.ProtocolStepTypeID) Then
                If Not clsRespondents.IsBatchFinal(oConn, iRespondentID) Then
                    'has data entry step?
                    If clsProtocols.ContainsProtocolStepType(oConn, iProtocolID, qmsProtocolStepTypes.DATAENTRY) Then
                        'check if respondent has been data entered
                        If clsRespondents.HasBeenInputed(oConn, iRespondentID, qmsInputMode.DATAENTRY) Then
                            Return True

                        End If
                        _sErrorMsg = String.Format("Respondent {0} must be data entered first.\n", iRespondentID)
                        Return False

                    Else
                        Return True

                    End If
                Else
                    _sErrorMsg = String.Format("Respondent {0} is final.\n", iRespondentID)
                    Return False

                End If
            Else
                _sErrorMsg = String.Format("Respondent {0} does not have {1} step.\n", iRespondentID, Me.InputModeName)
                Return False

            End If

        Else
            _sErrorMsg = String.Format("Respondent {0} in inactive survey instance.\n", iRespondentID)
            Return False

        End If

    End Function

    Public Function AllowUser(ByRef arlPrivledges As System.Collections.ArrayList) As Boolean Implements QMS.IInputMode.AllowUser
        Return clsQMSSecurity.CheckPrivledge(arlPrivledges, qmsSecurity.VERIFICATION)

    End Function

    Public ReadOnly Property EventTypeIDList() As String Implements QMS.IInputMode.EventTypeIDList
        Get
            Return "4"

        End Get
    End Property

    Public ReadOnly Property InputMode() As QMS.qmsInputMode Implements QMS.IInputMode.InputMode
        Get
            Return qmsInputMode.VERIFY

        End Get
    End Property

    Public ReadOnly Property InputModeName() As String Implements QMS.IInputMode.InputModeName
        Get
            Return "Verification"

        End Get
    End Property

    Public ReadOnly Property ProtocolStepTypeID() As Integer Implements QMS.IInputMode.ProtocolStepTypeID
        Get
            Return qmsProtocolStepTypes.VERIFICATION

        End Get
    End Property

    Public ReadOnly Property SelectEventID() As QMS.qmsEvents Implements QMS.IInputMode.SelectEventID
        Get
            Return qmsEvents.RESPONDENT_SELECTED_VERIFICATION

        End Get
    End Property

    Public ReadOnly Property StartEventID() As QMS.qmsEvents Implements QMS.IInputMode.StartEventID
        Get
            Return qmsEvents.VERIFY_START

        End Get
    End Property

    Public ReadOnly Property EndEventID() As QMS.qmsEvents Implements QMS.IInputMode.EndEventID
        Get
            Return qmsEvents.VERIFY_END

        End Get
    End Property


End Class

Public Class clsInputModeCATI
    Implements IInputMode

    Private _sErrorMsg As String

    Public ReadOnly Property ScriptTypeIDList() As String Implements IInputMode.ScriptTypeIDList
        Get
            Return "2"

        End Get
    End Property

    Public ReadOnly Property CompleteCodeID() As qmsEvents Implements IInputMode.CompleteCodeID
        Get
            Return qmsEvents.CATI_COMPLETE_SURVEY
        End Get
    End Property

    Public ReadOnly Property IncompleteCodeID() As qmsEvents Implements IInputMode.IncompleteCodeID
        Get
            Return qmsEvents.CATI_INCOMPLETE_SURVEY
        End Get
    End Property

    Public ReadOnly Property ErrorMsg() As String Implements QMS.IInputMode.ErrorMsg
        Get
            Return _sErrorMsg

        End Get
    End Property

    Public Function AllowRespondent(ByVal oConn As System.Data.SqlClient.SqlConnection, ByVal iRespondentID As Integer) As Boolean Implements QMS.IInputMode.AllowRespondent
        'in active survey instance?
        If clsRespondents.InActiveSurveyInstance(oConn, iRespondentID) Then
            Dim iProtocolID As Integer = clsRespondents.ProtocolID(oConn, iRespondentID)
            If clsProtocols.ContainsProtocolStepType(oConn, iProtocolID, Me.ProtocolStepTypeID) Then
                If Not clsRespondents.IsFinal(oConn, iRespondentID) Then
                    Return True
                End If
                _sErrorMsg = String.Format("Respondent {0} is final.\n", iRespondentID)
                Return False

            End If
            _sErrorMsg = String.Format("Respondent {0} does not have {1} step.\n", iRespondentID, Me.InputModeName)
            Return False

        Else
            _sErrorMsg = String.Format("Respondent {0} in inactive survey instance.\n", iRespondentID)
            Return False

        End If

    End Function

    Public Function AllowUser(ByRef arlPrivledges As System.Collections.ArrayList) As Boolean Implements QMS.IInputMode.AllowUser
        Return clsQMSSecurity.CheckPrivledge(arlPrivledges, qmsSecurity.CATI)

    End Function

    Public ReadOnly Property EventTypeIDList() As String Implements QMS.IInputMode.EventTypeIDList
        Get
            Return "5"

        End Get
    End Property

    Public ReadOnly Property InputMode() As QMS.qmsInputMode Implements QMS.IInputMode.InputMode
        Get
            Return qmsInputMode.CATI

        End Get
    End Property

    Public ReadOnly Property InputModeName() As String Implements QMS.IInputMode.InputModeName
        Get
            Return "CATI"

        End Get
    End Property

    Public ReadOnly Property ProtocolStepTypeID() As Integer Implements QMS.IInputMode.ProtocolStepTypeID
        Get
            Return qmsProtocolStepTypes.CATI

        End Get
    End Property

    Public ReadOnly Property SelectEventID() As QMS.qmsEvents Implements QMS.IInputMode.SelectEventID
        Get
            Return qmsEvents.RESPONDENT_SELECTED_CATICALL

        End Get
    End Property

    Public ReadOnly Property StartEventID() As QMS.qmsEvents Implements QMS.IInputMode.StartEventID
        Get
            Return qmsEvents.CATI_START

        End Get
    End Property

    Public ReadOnly Property EndEventID() As QMS.qmsEvents Implements QMS.IInputMode.EndEventID
        Get
            Return qmsEvents.CATI_END

        End Get
    End Property

End Class

Public Class clsInputModeReminderCall
    Implements IInputMode

    Private _sErrorMsg As String

    Public ReadOnly Property ScriptTypeIDList() As String Implements IInputMode.ScriptTypeIDList
        Get
            Return "3"

        End Get
    End Property

    Public ReadOnly Property CompleteCodeID() As qmsEvents Implements IInputMode.CompleteCodeID
        Get
            Return qmsEvents.REMINDER_COMPLETE_SURVEY
        End Get
    End Property

    Public ReadOnly Property IncompleteCodeID() As qmsEvents Implements IInputMode.IncompleteCodeID
        Get
            Return qmsEvents.REMINDER_INCOMPLETE_SURVEY
        End Get
    End Property

    Public ReadOnly Property ErrorMsg() As String Implements QMS.IInputMode.ErrorMsg
        Get
            Return _sErrorMsg

        End Get
    End Property

    Public Function AllowRespondent(ByVal oConn As System.Data.SqlClient.SqlConnection, ByVal iRespondentID As Integer) As Boolean Implements QMS.IInputMode.AllowRespondent
        'in active survey instance?
        If clsRespondents.InActiveSurveyInstance(oConn, iRespondentID) Then
            Dim iProtocolID As Integer = clsRespondents.ProtocolID(oConn, iRespondentID)
            If clsProtocols.ContainsProtocolStepType(oConn, iProtocolID, Me.ProtocolStepTypeID) Then
                If Not clsRespondents.IsFinal(oConn, iRespondentID) Then
                    Return True
                End If
                _sErrorMsg = String.Format("Respondent {0} is final.\n", iRespondentID)
                Return False

            End If
            _sErrorMsg = String.Format("Respondent {0} does not have {1} step.\n", iRespondentID, Me.InputModeName)
            Return False

        Else
            _sErrorMsg = String.Format("Respondent {0} in inactive survey instance.\n", iRespondentID)
            Return False

        End If

    End Function

    Public Function AllowUser(ByRef arlPrivledges As System.Collections.ArrayList) As Boolean Implements QMS.IInputMode.AllowUser
        Return clsQMSSecurity.CheckPrivledge(arlPrivledges, qmsSecurity.CATI)

    End Function

    Public ReadOnly Property EventTypeIDList() As String Implements QMS.IInputMode.EventTypeIDList
        Get
            Return "5"

        End Get
    End Property

    Public ReadOnly Property InputMode() As QMS.qmsInputMode Implements QMS.IInputMode.InputMode
        Get
            Return qmsInputMode.RCALL

        End Get
    End Property

    Public ReadOnly Property InputModeName() As String Implements QMS.IInputMode.InputModeName
        Get
            Return "Reminder Call"

        End Get
    End Property

    Public ReadOnly Property ProtocolStepTypeID() As Integer Implements QMS.IInputMode.ProtocolStepTypeID
        Get
            Return qmsProtocolStepTypes.REMINDER

        End Get
    End Property

    Public ReadOnly Property SelectEventID() As QMS.qmsEvents Implements QMS.IInputMode.SelectEventID
        Get
            Return qmsEvents.RESPONDENT_SELECTED_REMINDERCALL

        End Get
    End Property

    Public ReadOnly Property StartEventID() As QMS.qmsEvents Implements QMS.IInputMode.StartEventID
        Get
            Return qmsEvents.REMINDER_START

        End Get
    End Property

    Public ReadOnly Property EndEventID() As QMS.qmsEvents Implements QMS.IInputMode.EndEventID
        Get
            Return qmsEvents.REMINDER_END

        End Get
    End Property

End Class

Public Class clsInputModeView
    Implements IInputMode

    Private _sErrorMsg As String

    Public ReadOnly Property ScriptTypeIDList() As String Implements IInputMode.ScriptTypeIDList
        Get
            Return "1,2,3"

        End Get
    End Property

    Public ReadOnly Property CompleteCodeID() As qmsEvents Implements IInputMode.CompleteCodeID
        Get
            Return qmsEvents.NONE
        End Get
    End Property

    Public ReadOnly Property IncompleteCodeID() As qmsEvents Implements IInputMode.IncompleteCodeID
        Get
            Return qmsEvents.NONE
        End Get
    End Property

    Public ReadOnly Property ErrorMsg() As String Implements QMS.IInputMode.ErrorMsg
        Get
            Return _sErrorMsg

        End Get
    End Property

    Public Function AllowRespondent(ByVal oConn As System.Data.SqlClient.SqlConnection, ByVal iRespondentID As Integer) As Boolean Implements QMS.IInputMode.AllowRespondent
        Return True

    End Function

    Public Function AllowUser(ByRef arlPrivledges As System.Collections.ArrayList) As Boolean Implements QMS.IInputMode.AllowUser
        Return True

    End Function

    Public ReadOnly Property EventTypeIDList() As String Implements QMS.IInputMode.EventTypeIDList
        Get
            Return "4,5"

        End Get
    End Property

    Public ReadOnly Property InputMode() As QMS.qmsInputMode Implements QMS.IInputMode.InputMode
        Get
            Return qmsInputMode.VIEW

        End Get
    End Property

    Public Overridable ReadOnly Property InputModeName() As String Implements QMS.IInputMode.InputModeName
        Get
            Return "Viewing"

        End Get
    End Property

    Public ReadOnly Property ProtocolStepTypeID() As Integer Implements QMS.IInputMode.ProtocolStepTypeID
        Get
            Return 0

        End Get
    End Property

    Public ReadOnly Property SelectEventID() As QMS.qmsEvents Implements QMS.IInputMode.SelectEventID
        Get
            Return qmsEvents.RESPONDENT_SELECTED_VIEWING

        End Get
    End Property

    Public ReadOnly Property StartEventID() As QMS.qmsEvents Implements QMS.IInputMode.StartEventID
        Get
            Return Nothing

        End Get
    End Property

    Public ReadOnly Property EndEventID() As QMS.qmsEvents Implements QMS.IInputMode.EndEventID
        Get
            Return Nothing

        End Get
    End Property

End Class

Public Class clsInputModeReadOnly
    Inherits clsInputModeView

    Public Overrides ReadOnly Property InputModeName() As String
        Get
            Return "Read-Only"

        End Get
    End Property

End Class

Public Class clsInputModeIncomingCall
    Implements IInputMode

    Private _sErrorMsg As String

    Public ReadOnly Property ScriptTypeIDList() As String Implements IInputMode.ScriptTypeIDList
        Get
            Return "2,3"

        End Get
    End Property

    Public ReadOnly Property CompleteCodeID() As qmsEvents Implements IInputMode.CompleteCodeID
        Get
            Return qmsEvents.INCOMING_COMPLETE_SURVEY
        End Get
    End Property

    Public ReadOnly Property IncompleteCodeID() As qmsEvents Implements IInputMode.IncompleteCodeID
        Get
            Return qmsEvents.INCOMING_INCOMPLETE_SURVEY
        End Get
    End Property

    Public ReadOnly Property ErrorMsg() As String Implements QMS.IInputMode.ErrorMsg
        Get
            Return _sErrorMsg

        End Get
    End Property

    Public Function AllowRespondent(ByVal oConn As System.Data.SqlClient.SqlConnection, ByVal iRespondentID As Integer) As Boolean Implements QMS.IInputMode.AllowRespondent
        Return True

    End Function

    Public Function AllowUser(ByRef arlPrivledges As System.Collections.ArrayList) As Boolean Implements QMS.IInputMode.AllowUser
        Return True

    End Function

    Public ReadOnly Property EventTypeIDList() As String Implements QMS.IInputMode.EventTypeIDList
        Get
            Return "4"

        End Get
    End Property

    Public ReadOnly Property InputMode() As QMS.qmsInputMode Implements QMS.IInputMode.InputMode
        Get
            Return qmsInputMode.INCOMING

        End Get
    End Property

    Public ReadOnly Property InputModeName() As String Implements QMS.IInputMode.InputModeName
        Get
            Return "Incoming Call"

        End Get
    End Property

    Public ReadOnly Property ProtocolStepTypeID() As Integer Implements QMS.IInputMode.ProtocolStepTypeID
        Get
            Return qmsProtocolStepTypes.INCOMING

        End Get
    End Property

    Public ReadOnly Property SelectEventID() As QMS.qmsEvents Implements QMS.IInputMode.SelectEventID
        Get
            Return qmsEvents.RESPONDENT_SELECTED_INCOMING

        End Get
    End Property

    Public ReadOnly Property StartEventID() As QMS.qmsEvents Implements QMS.IInputMode.StartEventID
        Get
            Return qmsEvents.INCOMING_START

        End Get
    End Property

    Public ReadOnly Property EndEventID() As QMS.qmsEvents Implements QMS.IInputMode.EndEventID
        Get
            Return qmsEvents.INCOMING_END

        End Get
    End Property

End Class

Public Class clsInputModeWeb
    Implements IInputMode

    Private _sErrorMsg As String

    Public ReadOnly Property ScriptTypeIDList() As String Implements IInputMode.ScriptTypeIDList
        Get
            Return "1"

        End Get
    End Property

    Public ReadOnly Property CompleteCodeID() As qmsEvents Implements IInputMode.CompleteCodeID
        Get
            Return qmsEvents.NONE
        End Get
    End Property

    Public ReadOnly Property IncompleteCodeID() As qmsEvents Implements IInputMode.IncompleteCodeID
        Get
            Return qmsEvents.NONE
        End Get
    End Property

    Public ReadOnly Property ErrorMsg() As String Implements QMS.IInputMode.ErrorMsg
        Get
            Return _sErrorMsg

        End Get
    End Property

    Public Function AllowRespondent(ByVal oConn As System.Data.SqlClient.SqlConnection, ByVal iRespondentID As Integer) As Boolean Implements QMS.IInputMode.AllowRespondent
        Return True

    End Function

    Public Function AllowUser(ByRef arlPrivledges As System.Collections.ArrayList) As Boolean Implements QMS.IInputMode.AllowUser
        Return True

    End Function

    Public ReadOnly Property EventTypeIDList() As String Implements QMS.IInputMode.EventTypeIDList
        Get
            Return "0"

        End Get
    End Property

    Public ReadOnly Property InputMode() As QMS.qmsInputMode Implements QMS.IInputMode.InputMode
        Get
            Return qmsInputMode.WEB

        End Get
    End Property

    Public ReadOnly Property InputModeName() As String Implements QMS.IInputMode.InputModeName
        Get
            Return "Web"

        End Get
    End Property

    Public ReadOnly Property ProtocolStepTypeID() As Integer Implements QMS.IInputMode.ProtocolStepTypeID
        Get
            Return 0

        End Get
    End Property

    Public ReadOnly Property SelectEventID() As QMS.qmsEvents Implements QMS.IInputMode.SelectEventID
        Get
            Return qmsEvents.RESPONDENT_SELECTED_WEB

        End Get
    End Property

    Public ReadOnly Property StartEventID() As QMS.qmsEvents Implements QMS.IInputMode.StartEventID
        Get
            Return qmsEvents.WEB_START

        End Get
    End Property

    Public ReadOnly Property EndEventID() As QMS.qmsEvents Implements QMS.IInputMode.EndEventID
        Get
            Return qmsEvents.WEB_END

        End Get
    End Property

End Class

Public Class clsInputModeRemote
    Implements IInputMode

    Private _sErrorMsg As String

    Public ReadOnly Property ScriptTypeIDList() As String Implements IInputMode.ScriptTypeIDList
        Get
            Return "1"

        End Get
    End Property

    Public ReadOnly Property CompleteCodeID() As qmsEvents Implements IInputMode.CompleteCodeID
        Get
            Return qmsEvents.NONE
        End Get
    End Property

    Public ReadOnly Property IncompleteCodeID() As qmsEvents Implements IInputMode.IncompleteCodeID
        Get
            Return qmsEvents.NONE
        End Get
    End Property

    Public ReadOnly Property ErrorMsg() As String Implements QMS.IInputMode.ErrorMsg
        Get
            Return _sErrorMsg

        End Get
    End Property

    Public Function AllowRespondent(ByVal oConn As System.Data.SqlClient.SqlConnection, ByVal iRespondentID As Integer) As Boolean Implements QMS.IInputMode.AllowRespondent
        Return True

    End Function

    Public Function AllowUser(ByRef arlPrivledges As System.Collections.ArrayList) As Boolean Implements QMS.IInputMode.AllowUser
        Return True

    End Function

    Public ReadOnly Property EventTypeIDList() As String Implements QMS.IInputMode.EventTypeIDList
        Get
            Return "4, 5"

        End Get
    End Property

    Public ReadOnly Property InputMode() As QMS.qmsInputMode Implements QMS.IInputMode.InputMode
        Get
            Return qmsInputMode.REMOTE

        End Get
    End Property

    Public ReadOnly Property InputModeName() As String Implements QMS.IInputMode.InputModeName
        Get
            Return "Remote"

        End Get
    End Property

    Public ReadOnly Property ProtocolStepTypeID() As Integer Implements QMS.IInputMode.ProtocolStepTypeID
        Get
            Return 0

        End Get
    End Property

    Public ReadOnly Property SelectEventID() As QMS.qmsEvents Implements QMS.IInputMode.SelectEventID
        Get
            Return qmsEvents.RESPONDENT_SELECTED_REMOTE

        End Get
    End Property

    Public ReadOnly Property StartEventID() As QMS.qmsEvents Implements QMS.IInputMode.StartEventID
        Get
            Return qmsEvents.REMOTE_START

        End Get
    End Property

    Public ReadOnly Property EndEventID() As QMS.qmsEvents Implements QMS.IInputMode.EndEventID
        Get
            Return qmsEvents.REMOTE_END

        End Get
    End Property

End Class

Public Class clsInputModeTest
    Implements IInputMode

    Private _sErrorMsg As String

    Public ReadOnly Property ScriptTypeIDList() As String Implements IInputMode.ScriptTypeIDList
        Get
            Return "1,2,3"

        End Get
    End Property

    Public ReadOnly Property CompleteCodeID() As qmsEvents Implements IInputMode.CompleteCodeID
        Get
            Return qmsEvents.NONE
        End Get
    End Property

    Public ReadOnly Property IncompleteCodeID() As qmsEvents Implements IInputMode.IncompleteCodeID
        Get
            Return qmsEvents.NONE
        End Get
    End Property

    Public ReadOnly Property ErrorMsg() As String Implements QMS.IInputMode.ErrorMsg
        Get
            Return _sErrorMsg

        End Get
    End Property

    Public Function AllowRespondent(ByVal oConn As System.Data.SqlClient.SqlConnection, ByVal iRespondentID As Integer) As Boolean Implements QMS.IInputMode.AllowRespondent
        Return True

    End Function

    Public Function AllowUser(ByRef arlPrivledges As System.Collections.ArrayList) As Boolean Implements QMS.IInputMode.AllowUser
        Return True

    End Function

    Public ReadOnly Property EventTypeIDList() As String Implements QMS.IInputMode.EventTypeIDList
        Get
            Return "4,5"

        End Get
    End Property

    Public ReadOnly Property InputMode() As QMS.qmsInputMode Implements QMS.IInputMode.InputMode
        Get
            Return qmsInputMode.TEST

        End Get
    End Property

    Public ReadOnly Property InputModeName() As String Implements QMS.IInputMode.InputModeName
        Get
            Return "Testing"

        End Get
    End Property

    Public ReadOnly Property ProtocolStepTypeID() As Integer Implements QMS.IInputMode.ProtocolStepTypeID
        Get
            Return 0

        End Get
    End Property

    Public ReadOnly Property SelectEventID() As QMS.qmsEvents Implements QMS.IInputMode.SelectEventID
        Get
            Return qmsEvents.RESPONDENT_SELECTED_VIEWING

        End Get
    End Property

    Public ReadOnly Property StartEventID() As QMS.qmsEvents Implements QMS.IInputMode.StartEventID
        Get
            Return Nothing

        End Get
    End Property

    Public ReadOnly Property EndEventID() As QMS.qmsEvents Implements QMS.IInputMode.EndEventID
        Get
            Return Nothing

        End Get
    End Property

End Class

Public Class clsInputModeBatch
    Implements IInputMode

    Private _sErrorMsg As String

    Public ReadOnly Property ScriptTypeIDList() As String Implements IInputMode.ScriptTypeIDList
        Get
            Return "1,2,3"

        End Get
    End Property

    Public ReadOnly Property CompleteCodeID() As qmsEvents Implements IInputMode.CompleteCodeID
        Get
            Return qmsEvents.NONE
        End Get
    End Property

    Public ReadOnly Property IncompleteCodeID() As qmsEvents Implements IInputMode.IncompleteCodeID
        Get
            Return qmsEvents.NONE
        End Get
    End Property

    Public ReadOnly Property ErrorMsg() As String Implements QMS.IInputMode.ErrorMsg
        Get
            Return _sErrorMsg

        End Get
    End Property

    Public Function AllowRespondent(ByVal oConn As System.Data.SqlClient.SqlConnection, ByVal iRespondentID As Integer) As Boolean Implements QMS.IInputMode.AllowRespondent
        'in active survey instance?
        If clsRespondents.InActiveSurveyInstance(oConn, iRespondentID) Then
            Dim iProtocolID As Integer = clsRespondents.ProtocolID(oConn, iRespondentID)
            If clsProtocols.ContainsProtocolStepType(oConn, iProtocolID, Me.ProtocolStepTypeID) Then
                If Not clsRespondents.IsFinal(oConn, iRespondentID) Then
                    Return True
                End If
                _sErrorMsg = String.Format("Respondent {0} is final.\n", iRespondentID)
                Return False

            End If
            _sErrorMsg = String.Format("Respondent {0} does not have {1} step.\n", iRespondentID, Me.InputModeName)
            Return False

        Else
            _sErrorMsg = String.Format("Respondent {0} in inactive survey instance.\n", iRespondentID)
            Return False

        End If

    End Function

    Public Function AllowUser(ByRef arlPrivledges As System.Collections.ArrayList) As Boolean Implements QMS.IInputMode.AllowUser
        Return True

    End Function

    Public ReadOnly Property EventTypeIDList() As String Implements QMS.IInputMode.EventTypeIDList
        Get
            Return "4,5"

        End Get
    End Property

    Public ReadOnly Property InputMode() As QMS.qmsInputMode Implements QMS.IInputMode.InputMode
        Get
            Return qmsInputMode.BATCH

        End Get
    End Property

    Public ReadOnly Property InputModeName() As String Implements QMS.IInputMode.InputModeName
        Get
            Return "Batching"

        End Get
    End Property

    Public ReadOnly Property ProtocolStepTypeID() As Integer Implements QMS.IInputMode.ProtocolStepTypeID
        Get
            Return qmsProtocolStepTypes.BATCHING

        End Get
    End Property

    Public ReadOnly Property SelectEventID() As QMS.qmsEvents Implements QMS.IInputMode.SelectEventID
        Get
            Return qmsEvents.BATCH_RESPONDENT

        End Get
    End Property

    Public ReadOnly Property StartEventID() As QMS.qmsEvents Implements QMS.IInputMode.StartEventID
        Get
            Return qmsEvents.BATCH_RESPONDENT

        End Get
    End Property

    Public ReadOnly Property EndEventID() As QMS.qmsEvents Implements QMS.IInputMode.EndEventID
        Get
            Return Nothing

        End Get
    End Property

End Class

#End Region

Public Class clsInputMode
    Public Shared Function Create(ByVal InputMode As qmsInputMode) As IInputMode
        Select Case InputMode
            Case qmsInputMode.BATCH
                Return New clsInputModeBatch

            Case qmsInputMode.CATI
                Return New clsInputModeCATI

            Case qmsInputMode.DATAENTRY
                Return New clsInputModeDataEntry

            Case qmsInputMode.RCALL
                Return New clsInputModeReminderCall

            Case qmsInputMode.TEST
                Return New clsInputModeTest

            Case qmsInputMode.VERIFY
                Return New clsInputModeVerification

            Case qmsInputMode.WEB
                Return New clsInputModeWeb

            Case qmsInputMode.REMOTE
                Return New clsInputModeRemote

            Case qmsInputMode.INCOMING
                Return New clsInputModeIncomingCall

            Case qmsInputMode.READ_ONLY
                Return New clsInputModeReadOnly

            Case Else
                Return New clsInputModeView

        End Select

    End Function

    Public Shared Function CheckScriptType(ByVal inputMode As qmsInputMode, ByVal scriptTypeID As Integer) As Boolean
        Dim im As IInputMode = clsInputMode.Create(inputMode)
        Dim scriptTypes() As String = im.ScriptTypeIDList.Split(",")

        If Array.IndexOf(scriptTypes, scriptTypeID.ToString) >= 0 Then
            Return True
        Else
            Return False
        End If

    End Function

    Public Shared Function LastInputMode(ByVal Connection As SqlClient.SqlConnection, ByVal RespondentID As Integer) As QMS.qmsInputMode
        Dim sqlLastInput As New Text.StringBuilder
        Dim oResult As Object

        sqlLastInput.Append("SELECT EventID FROM EventLog WHERE ")
        sqlLastInput.AppendFormat("RespondentID = {0} AND EventID >= 3000 AND EventID < 3040", RespondentID)
        'TP Change
        oResult = SqlHelper.Db(Connection.ConnectionString).ExecuteScalar(CommandType.Text, sqlLastInput.ToString())
        'oResult = SqlHelper.ExecuteScalar(Connection, CommandType.Text, sqlLastInput.ToString)

        If IsDBNull(oResult) Or IsNothing(oResult) Then
            Return qmsInputMode.VIEW

        Else
            Select Case CType(oResult, QMS.qmsEvents)
                Case qmsEvents.DE_COMPLETE_SURVEY, qmsEvents.DE_INCOMPLETE_SURVEY, qmsEvents.DE_PARTIAL_COMPLETE_SURVEY
                    Return QMS.qmsInputMode.DATAENTRY

                Case qmsEvents.VERIFY_COMPLETE_SURVEY, qmsEvents.VERIFY_INCOMPLETE_SURVEY, qmsEvents.VERIFY_PARTIAL_COMPLETE_SURVEY
                    Return QMS.qmsInputMode.VERIFY

                Case qmsEvents.CATI_COMPLETE_SURVEY, qmsEvents.CATI_INCOMPLETE_SURVEY, qmsEvents.CATI_PARTIAL_COMPLETE_SURVEY
                    Return QMS.qmsInputMode.CATI

                Case qmsEvents.REMINDER_COMPLETE_SURVEY, qmsEvents.REMINDER_INCOMPLETE_SURVEY, qmsEvents.REMINDER_PARTIAL_COMPLETE_SURVEY
                    Return QMS.qmsInputMode.RCALL

                Case qmsEvents.INCOMING_COMPLETE_SURVEY, qmsEvents.INCOMING_INCOMPLETE_SURVEY, qmsEvents.INCOMING_PARTIAL_COMPLETE_SURVEY
                    Return qmsInputMode.INCOMING

                Case qmsEvents.WEB_COMPLETE_SURVEY, qmsEvents.WEB_INCOMPLETE_SURVEY
                    Return qmsInputMode.WEB

                Case Else
                    Return qmsInputMode.VIEW

            End Select
        End If
    End Function

End Class
