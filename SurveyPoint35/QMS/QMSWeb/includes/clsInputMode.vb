<Obsolete("use QMS.clsInputMode")> _
Public Enum qmsInputMode
    VIEW = 0
    DATAENTRY = 1
    VERIFY = 2
    CATI = 3
    RCALL = 4
    BATCH = 5
    TEST = 999

End Enum

<Obsolete("use QMS.clsInputMode")> _
Public Class clsInputMode

    Public Shared Function InputModeName(ByVal eInputMode As qmsInputMode) As String

        Select Case eInputMode
            Case qmsInputMode.DATAENTRY
                Return "Data Entry"

            Case qmsInputMode.VERIFY
                Return "Verification"

            Case qmsInputMode.CATI
                Return "CATI"

            Case qmsInputMode.RCALL
                Return "Reminder Call"

            Case qmsInputMode.VIEW
                Return "Viewing"

            Case qmsInputMode.TEST
                Return "Testing"

        End Select

    End Function

    Public Shared Function AllowAccess(ByVal arlPrivledges As ArrayList, ByVal eInputMode As qmsInputMode) As Boolean

        Select Case eInputMode
            Case qmsInputMode.CATI, qmsInputMode.RCALL
                Return QMS.clsQMSSecurity.CheckPrivledge(arlPrivledges, QMS.qmsSecurity.CATI)

            Case qmsInputMode.DATAENTRY
                Return QMS.clsQMSSecurity.CheckPrivledge(arlPrivledges, QMS.qmsSecurity.DATA_ENTRY)

            Case qmsInputMode.VERIFY
                Return QMS.clsQMSSecurity.CheckPrivledge(arlPrivledges, QMS.qmsSecurity.VERIFICATION)

            Case Else
                Return True

        End Select

    End Function

    Public Shared Function GetProtocolStepTypeID(ByVal iInputMode As qmsInputMode) As Integer

        Select Case iInputMode
            Case qmsInputMode.CATI
                Return CInt(qmsProtocolStepType.CATI)

            Case qmsInputMode.RCALL
                Return CInt(qmsProtocolStepType.REMINDER)

            Case qmsInputMode.DATAENTRY
                Return CInt(qmsProtocolStepType.DATAENTRY)

            Case qmsInputMode.VERIFY
                Return CInt(qmsProtocolStepType.VERIFICATION)

            Case qmsInputMode.BATCH
                Return CInt(qmsProtocolStepType.BATCHING)

            Case Else
                Return 0

        End Select

    End Function


End Class
