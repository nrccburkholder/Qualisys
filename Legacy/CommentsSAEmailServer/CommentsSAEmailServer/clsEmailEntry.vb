Imports Microsoft.VisualBasic
Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Data
Imports System.Data.SqlClient
Imports System.Runtime.CompilerServices
Imports System.Runtime.InteropServices
Imports System.Web.Mail

Namespace CommentsSAEmailServer
    Public Class clsEmailEntry
        ' Methods
        Private Sub AddEmailLogEntry(ByVal Optional intEmailCount As Integer = -1)
            Try 
                modMain.WriteLogEntry(String.Format("Attempting to log Email #{0} (sp_WA_AddEmailLogEntry) for LithoCodes {1}", intEmailCount, Me.mstrLithoCodeList))
                Dim connection As New SqlConnection(modMain.GetSQLConnectString("Comments"))
                connection.Open
                Dim command As New SqlCommand("sp_WA_AddEmailLogEntry")
                Dim command2 As SqlCommand = command
                command2.CommandType = CommandType.StoredProcedure
                command2.Connection = connection
                command2.Parameters.Add("@ClientUserID", SqlDbType.Int).Value = Me.mintClientUserID
                command2.Parameters.Add("@strLithoList", SqlDbType.VarChar, &H1B58).Value = Me.mstrLithoCodeList
                command2.Parameters.Add("@strToList", SqlDbType.VarChar, 500).Value = Me.mstrTo
                command2.Parameters.Add("@intEmailFormat", SqlDbType.Int).Value = Me.mobjEmailFormat.FormatID
                command2 = Nothing
                command.ExecuteNonQuery
                modMain.WriteLogEntry(String.Format("Email #{0} Logged (sp_WA_AddEmailLogEntry) for LithoCodes {1}", intEmailCount, Me.mstrLithoCodeList))
                connection.Close
            Catch exception1 As Exception
                ProjectData.SetProjectError(exception1)
                modMain.WriteLogEntry(String.Format("Email Logging Failed for Email #{0} (sp_WA_AddEmailLogEntry)", intEmailCount))
                ProjectData.ClearProjectError
            End Try
        End Sub

        Public Function GetSampleEmail(ByVal Optional bolTo As Boolean = True, ByVal Optional bolCC As Boolean = True) As String
            Dim vLeft As String = ""
            If Me.mbolPrivSAEMail Then
                Me.SetEmailAddresses(bolTo, bolCC)
                vLeft = (((("To:     " & Me.mstrTo & ChrW(13) & ChrW(10) & "CC:     " & Me.mstrCC) & ChrW(13) & ChrW(10) & "From:   " & Me.mstrFrom) & ChrW(13) & ChrW(10) & ChrW(13) & ChrW(10)) & "Subject: Service Alert/Contact" & Me.mstrExtra & ChrW(13) & ChrW(10) & ChrW(13) & ChrW(10))
                Select Case Me.mobjEmailFormat.FormatID
                    Case 1
                        Return StringType.FromObject(ObjectType.StrCatObj(vLeft, ObjectType.StrCatObj(ObjectType.StrCatObj(ObjectType.StrCatObj(ObjectType.StrCatObj(ObjectType.StrCatObj(("This email has been sent as notification that " & StringType.FromInteger(Me.LithoCodeCount) & " Service" & ChrW(13) & ChrW(10) & "Alert/Contact Comment"), Interaction.IIf((Me.LithoCodeCount = 1), " has ", "s have ")), "been posted to your NRC+Picker" & ChrW(13) & ChrW(10) & "eComments web site for "), Me.mstrLoginName), "." & ChrW(13) & ChrW(10) & ChrW(13) & ChrW(10) & "Click here to link to NRCPicker:" & ChrW(13) & ChrW(10) & "    http://nrcpicker.com" & ChrW(13) & ChrW(10) & ChrW(13) & ChrW(10) & ChrW(13) & ChrW(10) & "National Research Corporation" & ChrW(13) & ChrW(10) & "1245 Q Street" & ChrW(13) & ChrW(10) & "Lincoln, NE 68508" & ChrW(13) & ChrW(10) & ChrW(13) & ChrW(10) & "Phone: (402) 475-2525" & ChrW(13) & ChrW(10) & "Fax:   (402) 475-9061" & ChrW(13) & ChrW(10)), Me.ConfidentialityNotice)))
                    Case 2
                        Dim strArray As String() = Me.mstrLithoCodeList.Split(New Char() { ","c })
                        Dim str3 As String = StringType.FromObject(ObjectType.StrCatObj(ObjectType.StrCatObj(ObjectType.StrCatObj(ObjectType.StrCatObj(("This email has been sent as notification that " & StringType.FromInteger(Me.LithoCodeCount) & " Service" & ChrW(13) & ChrW(10) & "Alert/Contact Comment"), Interaction.IIf((Me.LithoCodeCount = 1), " has ", "s have ")), "been posted to your NRC+Picker" & ChrW(13) & ChrW(10) & "eComments web site for "), Me.mstrLoginName), "." & ChrW(13) & ChrW(10) & ChrW(13) & ChrW(10)))
                        Dim upperBound As Integer = strArray.GetUpperBound(0)
                        Dim i As Integer = 0
                        Do While (i <= upperBound)
                            str3 = (str3 & "Survey Code: " & strArray(i) & ChrW(13) & ChrW(10))
                            i += 1
                        Loop
                        str3 = (str3 & ChrW(13) & ChrW(10) & "Click here to link to NRCPicker:" & ChrW(13) & ChrW(10) & "    http://nrcpicker.com" & ChrW(13) & ChrW(10) & ChrW(13) & ChrW(10) & ChrW(13) & ChrW(10) & "National Research Corporation" & ChrW(13) & ChrW(10) & "1245 Q Street" & ChrW(13) & ChrW(10) & "Lincoln, NE 68508" & ChrW(13) & ChrW(10) & ChrW(13) & ChrW(10) & "Phone: (402) 475-2525" & ChrW(13) & ChrW(10) & "Fax:   (402) 475-9061" & ChrW(13) & ChrW(10) & Me.ConfidentialityNotice)
                        Return (vLeft & str3)
                End Select
            End If
            Return vLeft
        End Function

        Private Sub PopPrivileges()
            Try 
                modMain.WriteLogEntry(String.Format("Attempting to populate privileges for ClientUser {0}", Me.mintClientUserID))
                Dim connection As New SqlConnection(modMain.GetSQLConnectString("WebAccounts"))
                connection.Open
                Dim command As New SqlCommand("sp_Comment_GetEmailInfo")
                Dim command2 As SqlCommand = command
                command2.CommandType = CommandType.StoredProcedure
                command2.Connection = connection
                command2.Parameters.Add("@intClientUserID", SqlDbType.Int).Value = Me.mintClientUserID
                command2.Parameters.Add("@strLoginName", SqlDbType.VarChar, 100).Direction = ParameterDirection.Output
                command2.Parameters.Add("@bitSAEmail", SqlDbType.Bit).Direction = ParameterDirection.Output
                command2 = Nothing
                command.ExecuteNonQuery
                Me.mstrLoginName = StringType.FromObject(Interaction.IIf(Information.IsDBNull(RuntimeHelpers.GetObjectValue(command.Parameters.Item("@strLoginName").Value)), "", RuntimeHelpers.GetObjectValue(command.Parameters.Item("@strLoginName").Value))).Trim
                Me.mbolPrivSAEMail = BooleanType.FromObject(Interaction.IIf(Information.IsDBNull(RuntimeHelpers.GetObjectValue(command.Parameters.Item("@bitSAEmail").Value)), False, RuntimeHelpers.GetObjectValue(command.Parameters.Item("@bitSAEmail").Value)))
                connection.Close
                modMain.WriteLogEntry(String.Format("Privileges successfully populated for ClientUser {0}", Me.mintClientUserID))
            Catch exception1 As Exception
                ProjectData.SetProjectError(exception1)
                Dim exception As Exception = exception1
                Me.mstrLoginName = ""
                Me.mbolPrivSAEMail = False
                modMain.WriteLogEntry(String.Format("Error encountered populating privileges for ClientUser {0}. Error: {1} Stack Trace: {2}", Me.mintClientUserID, exception.Message, exception.StackTrace))
                ProjectData.ClearProjectError
            End Try
        End Sub

        Public Sub SendEmail(ByVal Optional bolTo As Boolean = True, ByVal Optional bolCC As Boolean = True, ByVal Optional intEmailCount As Integer = -1)
            Dim message As New MailMessage
            If Me.mbolPrivSAEMail Then
                Try 
                    Dim strArray As String()
                    Dim num As Integer
                    Dim str As String
                    Dim upperBound As Integer
                    modMain.WriteLogEntry(String.Format("Preparing Email #{0} for LithoCodes {1}", intEmailCount, Me.mstrLithoCodeList))
                    Me.SetEmailAddresses(bolTo, bolCC)
                    Dim message2 As MailMessage = message
                    message2.To = Me.mstrTo
                    message2.Cc = Me.mstrCC
                    message2.From = Me.mstrFrom
                    message2.Priority = MailPriority.High
                    message2.Subject = ("Service Alert/Contact" & Me.mstrExtra)
                    message2.BodyFormat = MailFormat.Text
                    Select Case Me.mobjEmailFormat.FormatID
                        Case 1
                            message2.Body = StringType.FromObject(ObjectType.StrCatObj(ObjectType.StrCatObj(ObjectType.StrCatObj(ObjectType.StrCatObj(ObjectType.StrCatObj(("This email has been sent as notification that " & StringType.FromInteger(Me.LithoCodeCount) & " Service" & ChrW(13) & ChrW(10) & "Alert/Contact Comment"), Interaction.IIf((Me.LithoCodeCount = 1), " has ", "s have ")), "been posted to your NRC+Picker" & ChrW(13) & ChrW(10) & "eComments web site for "), Me.mstrLoginName), "." & ChrW(13) & ChrW(10) & ChrW(13) & ChrW(10) & "Click here to link to NRCPicker:" & ChrW(13) & ChrW(10) & "    http://nrcpicker.com" & ChrW(13) & ChrW(10) & ChrW(13) & ChrW(10) & ChrW(13) & ChrW(10) & "National Research Corporation" & ChrW(13) & ChrW(10) & "1245 Q Street" & ChrW(13) & ChrW(10) & "Lincoln, NE 68508" & ChrW(13) & ChrW(10) & ChrW(13) & ChrW(10) & "Phone: (402) 475-2525" & ChrW(13) & ChrW(10) & "Fax:   (402) 475-9061" & ChrW(13) & ChrW(10)), Me.ConfidentialityNotice))
                            goto Label_01FA
                        Case 2
                            strArray = Me.mstrLithoCodeList.Split(New Char() { ","c })
                            str = StringType.FromObject(ObjectType.StrCatObj(ObjectType.StrCatObj(ObjectType.StrCatObj(ObjectType.StrCatObj(("This email has been sent as notification that " & StringType.FromInteger(Me.LithoCodeCount) & " Service" & ChrW(13) & ChrW(10) & "Alert/Contact Comment"), Interaction.IIf((Me.LithoCodeCount = 1), " has ", "s have ")), "been posted to your NRC+Picker" & ChrW(13) & ChrW(10) & "eComments web site for "), Me.mstrLoginName), "." & ChrW(13) & ChrW(10) & ChrW(13) & ChrW(10)))
                            upperBound = strArray.GetUpperBound(0)
                            num = 0
                            goto Label_01DA
                        Case Else
                            goto Label_01FA
                    End Select
                Label_01C1:
                    str = (str & "Survey Code: " & strArray(num) & ChrW(13) & ChrW(10))
                    num += 1
                Label_01DA:
                    If (num <= upperBound) Then
                        goto Label_01C1
                    End If
                    str = (str & ChrW(13) & ChrW(10) & "Click here to link to NRCPicker:" & ChrW(13) & ChrW(10) & "    http://nrcpicker.com" & ChrW(13) & ChrW(10) & ChrW(13) & ChrW(10) & ChrW(13) & ChrW(10) & "National Research Corporation" & ChrW(13) & ChrW(10) & "1245 Q Street" & ChrW(13) & ChrW(10) & "Lincoln, NE 68508" & ChrW(13) & ChrW(10) & ChrW(13) & ChrW(10) & "Phone: (402) 475-2525" & ChrW(13) & ChrW(10) & "Fax:   (402) 475-9061" & ChrW(13) & ChrW(10) & Me.ConfidentialityNotice)
                    message2.Body = str
                Label_01FA:
                    message2 = Nothing
                    modMain.WriteLogEntry(String.Format("Attempting to send Email #{0} for LithoCodes {1}", intEmailCount, Me.mstrLithoCodeList))
                    SmtpMail.SmtpServer = "smtp2.NationalResearch.com"
                    SmtpMail.Send(message)
                    modMain.WriteLogEntry(String.Format("Send successful for Email #{0} for LithoCodes {1}", intEmailCount, Me.mstrLithoCodeList))
                    Me.AddEmailLogEntry(intEmailCount)
                Catch exception1 As Exception
                    ProjectData.SetProjectError(exception1)
                    Dim exception As Exception = exception1
                    modMain.WriteLogEntry(String.Format("Error encountered sending Email #{0}. Error: {1} Stack Trace: {2}", intEmailCount, exception.Message, exception.StackTrace))
                    ProjectData.ClearProjectError
                End Try
            Else
                modMain.WriteLogEntry(String.Format("Skipping Email #{0} as ClientUser privileges do not allow sending", intEmailCount))
            End If
        End Sub

        Private Sub SetEmailAddresses(ByVal bolTo As Boolean, ByVal bolCC As Boolean)
            Me.mstrTo = StringType.FromObject(Interaction.IIf(bolTo, Me.mstrEmailList, ""))
            Me.mstrCC = ""
            Me.mstrFrom = "CommentsAdmin@NationalResearch.com"
            Me.mstrExtra = ""
            If (Me.mstrTo.Trim.Length = 0) Then
                If (Me.mstrCC.Trim.Length > 0) Then
                    Me.mstrTo = Me.mstrCC
                End If
                Me.mstrExtra = " - No Client Contact Specified"
            End If
        End Sub


        ' Properties
        Public Property AcctDirector As String
            Get
                Return Me.mstrAcctDirector
            End Get
            Set(ByVal Value As String)
                Me.mstrAcctDirector = Value
            End Set
        End Property

        Public Property ClientUserID As Integer
            Get
                Return Me.mintClientUserID
            End Get
            Set(ByVal Value As Integer)
                Me.mintClientUserID = Value
                Me.PopPrivileges
            End Set
        End Property

        Private ReadOnly Property ConfidentialityNotice As String
            Get
                Return ChrW(13) & ChrW(10) & ChrW(13) & ChrW(10) & "CONFIDENTIALITY NOTICE:" & ChrW(13) & ChrW(10) & ChrW(13) & ChrW(10) & "This email may contain confidential health information that is legally" & ChrW(13) & ChrW(10) & "privileged. This information is intended for the use of the named" & ChrW(13) & ChrW(10) & "recipient(s). The authorized recipient of this information is prohibited" & ChrW(13) & ChrW(10) & "from disclosing this information to any party unless required to do so" & ChrW(13) & ChrW(10) & "by law or regulation and is required to destroy the information after" & ChrW(13) & ChrW(10) & "its stated need hasbeen fulfilled. If you are not the intended recipient," & ChrW(13) & ChrW(10) & "you are hereby notified that any disclosure, copying, distribution, or" & ChrW(13) & ChrW(10) & "action taken in reliance on the contents of this email is strictly" & ChrW(13) & ChrW(10) & "prohibited. If you receive this e-mail message in error, please notify" & ChrW(13) & ChrW(10) & "the sender immediately to arrange disposition of the information." & ChrW(13) & ChrW(10)
            End Get
        End Property

        Public Property DateSent As DateTime
            Get
                Return Me.mdatDateSent
            End Get
            Set(ByVal Value As DateTime)
                Me.mdatDateSent = Value
            End Set
        End Property

        Public ReadOnly Property EmailFormat As clsEmailFormat
            Get
                Return Me.mobjEmailFormat
            End Get
        End Property

        Public Property EmailList As String
            Get
                Return Me.mstrEmailList
            End Get
            Set(ByVal Value As String)
                Me.mstrEmailList = Value
            End Set
        End Property

        Public ReadOnly Property LithoCodeCount As Integer
            Get
                Return (Me.mstrLithoCodeList.Split(New Char() { ","c }).GetUpperBound(0) + 1)
            End Get
        End Property

        Public Property LithoCodeList As String
            Get
                Return Me.mstrLithoCodeList
            End Get
            Set(ByVal Value As String)
                Me.mstrLithoCodeList = Value
            End Set
        End Property

        Public ReadOnly Property LoginName As String
            Get
                Return Me.mstrLoginName
            End Get
        End Property

        Public ReadOnly Property PrivSAEMail As Boolean
            Get
                Return Me.mbolPrivSAEMail
            End Get
        End Property


        ' Fields
        Private mbolPrivSAEMail As Boolean = False
        Private mdatDateSent As DateTime
        Private mintClientUserID As Integer = 0
        Private mobjEmailFormat As clsEmailFormat = New clsEmailFormat
        Private mstrAcctDirector As String = ""
        Private mstrBCC As String = ""
        Private mstrCC As String = ""
        Private mstrEmailList As String = ""
        Private mstrExtra As String = ""
        Private mstrFrom As String = ""
        Private mstrLithoCodeList As String = ""
        Private mstrLoginName As String = ""
        Private mstrTo As String = ""
    End Class
End Namespace

