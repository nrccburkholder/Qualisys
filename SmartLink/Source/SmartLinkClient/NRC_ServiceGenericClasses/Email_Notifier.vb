Imports System.Net.Mail

Namespace Miscellaneous
    Public Class Email_Notifier

        'set current default smtp server
        Private _strSMTP As String = "smtp1"
        Private _strOperatorEmail As String = "support@nationalresearch.com"

        'get the computer name, the application name, and the process username
        Private _strAppName As String = My.Application.Info.Title
        Private _strAppVersion As String = My.Application.Info.Version.ToString()
        Private _strFromWho As String = System.Security.Principal.WindowsIdentity.GetCurrent().Name
        Private _strMachineName As String = My.Computer.Name
        Private _strTextAddresses As String = String.Empty
        Private _strEmailAddresses As String = String.Empty
        Private _MailServer As New SmtpClient


        'internal flag to specify if the current message is an error message
        Private _blnIsError As Boolean = False

        ''' <summary>
        ''' The smtp server.  Defaults to 'smtp1'.
        ''' </summary>
        Public Property SMTP() As String
            Get
                Return Me._strSMTP
            End Get
            Set(ByVal value As String)
                Me._strSMTP = value
            End Set
        End Property

        ''' <summary>
        ''' The 'From' email address.  Defaults to 'support@nationalresearch.com'.
        ''' </summary>
        Public Property OperatorEmail() As String
            Get
                Return Me._strOperatorEmail
            End Get
            Set(ByVal value As String)
                If Me.IsValidAdressList(value) = False Then
                    Throw New Exception("An invalid email address was supplied for 'OperatorEmail'")
                End If
                Me._strOperatorEmail = value
            End Set
        End Property

        ''' <summary>
        ''' The default list of email addresses to use for text message alerts.  A semicolon, comma, or colon can be used as a delimiter.
        ''' </summary>
        Public Property TextAddresses() As String

            Get
                Return Me._strTextAddresses
            End Get

            Set(ByVal value As String)
                If Me.IsValidAdressList(value) = False Then
                    Throw New Exception("An invalid email address was supplied for 'TextAddresses'")
                End If
                Me._strTextAddresses = value
            End Set

        End Property

        ''' <summary>
        ''' The default list of email addresses.  A semicolon, comma, or colon can be used as a delimiter.
        ''' </summary>
        Public Property EmailAddresses() As String

            Get
                Return Me._strEmailAddresses
            End Get

            Set(ByVal value As String)
                If Me.IsValidAdressList(value) = False Then
                    Throw New Exception("An invalid email address was supplied for 'EmailAddresses'")
                End If
                Me._strEmailAddresses = value
            End Set

        End Property

        Public Sub New(ByVal OperatorEmail As String)
            If Me.IsValidAdressList(OperatorEmail) = False Then
                Throw New Exception("An invalid email address was supplied for 'OperatorEmail'")
            End If
            Me._strOperatorEmail = OperatorEmail
        End Sub

        ''' <summary>
        ''' Send an email notification.
        ''' </summary>
        ''' <remarks>The subject includes application name and machine name.  The body includes the message along with where the application is running and under what user name.</remarks>
        ''' <param name="strAddressList">An email address or a list of email addresses.  A semicolon, comma, or colon can be used as a delimiter.</param>
        ''' <param name="Message">The message to be sent.</param>
        Public Sub SendMessage(ByVal Message As String, Optional ByVal strAddressList As String = Nothing)

            Dim MailMessage As New MailMessage
            Dim strAddresses() As String

            Try
                If strAddressList Is Nothing Then
                    strAddressList = Me._strEmailAddresses
                Else
                    Me.IsValidAdressList(strAddressList)
                End If

                'accepted delimiters are  ':'  ','  ';' 
                strAddressList = strAddressList.Replace(":", ";")
                strAddressList = strAddressList.Replace(",", ";")
                strAddressList = strAddressList.Replace(" ", "")
                strAddressList = strAddressList.Trim(";"c)

                strAddresses = Split(strAddressList, ";")
                For Each person As String In strAddresses
                    MailMessage.To.Add(person)
                Next

                If Me._blnIsError = True Then
                    MailMessage.Subject = Me._strAppName & " Error Notification - " & Me._strMachineName
                Else
                    MailMessage.Subject = Me._strAppName & " Notification - " & Me._strMachineName
                End If

                Message &= vbCrLf & vbCrLf & "Service: " & Me._strAppName _
                        & vbCrLf & "Version: " & Me._strAppVersion _
                        & vbCrLf & "Service Run By: " & Me._strFromWho _
                        & vbCrLf & "Service Run On: " & Me._strMachineName

                MailMessage.Body = Message
                MailMessage.From = New MailAddress(Me._strOperatorEmail)
                MailMessage.Priority = Net.Mail.MailPriority.High
                Me._MailServer.Host = Me._strSMTP
                Me._MailServer.ServicePoint.MaxIdleTime = 1000
				'Me._MailServer.Send(MailMessage)
                MailMessage.Dispose()

                'System.Net.ServicePointManager.MaxServicePointIdleTime = -1

            Catch ex As Exception
                Throw New System.Exception("An error occurred while trying to send an email.", ex)
            Finally
                'make sure this gets reset always
                Me._blnIsError = False
            End Try

        End Sub

        ''' <summary>
        ''' Send an email formatted for cell phone text messaging.
        ''' </summary>
        ''' <remarks>The text includes the application name, machine name, and the message.</remarks>
        ''' <param name="AddressList">An email address or a list of email addresses.  A semicolon, comma, or colon can be used as a delimiter.</param>
        ''' <param name="Message">The message to be sent.</param>
        Public Sub SendText(ByVal Message As String, Optional ByVal AddressList As String = Nothing)

            Me.SendText(Message, True, AddressList)

        End Sub

        Private Sub SendText(ByVal strMessage As String, ByVal blnFirstOccurence As Boolean, Optional ByVal strAddressList As String = Nothing)

            Dim MailMessage As New MailMessage
            Dim strAddresses() As String
            Dim intI As Integer
            Dim strWhiteSpace As String = Chr(13) & Chr(9) & " "
            Dim strCurrentMessage As String

            Try
                If strAddressList Is Nothing Then
                    strAddressList = Me._strTextAddresses
                Else
                    Me.IsValidAdressList(strAddressList)
                End If

                'accepted delimiters are  ':'  ','  ';' 
                strAddressList = strAddressList.Replace(":", ";")
                strAddressList = strAddressList.Replace(",", ";")
                strAddressList = strAddressList.Replace(" ", "")
                strAddressList = strAddressList.Trim(";"c)

                'seperate email addresses
                strAddresses = Split(strAddressList, ";")
                For Each person As String In strAddresses
                    MailMessage.To.Add(person)
                Next

                'add a psuedo subject line.  not using real subject because it adds unesseary 'subject: ' text.
                If blnFirstOccurence Then
                    If Me._blnIsError = True Then
                        strMessage = "Error! " & Me._strAppName & " - " & Me._strMachineName & ". " & strMessage
                    Else
                        strMessage = Me._strAppName & " - " & Me._strMachineName & ". " & strMessage
                    End If
                End If

                'remove extra line breaks
                strMessage.Replace(vbCrLf, " "c)

                'text messages can only contain 160 characters total
                'this gets the first 160 seperating where there is whitespace to avoid splitting a word
                If strMessage.Length > 160 Then
                    intI = 160
                    Do
                        intI -= 1
                    Loop While Not strWhiteSpace.Contains(strMessage.ToCharArray()(intI))
                    strCurrentMessage = strMessage.Substring(0, intI)
                    strMessage = strMessage.Substring(intI)
                Else
                    strCurrentMessage = strMessage
                    strMessage = Nothing
                End If

                'send email
                MailMessage.Body = strCurrentMessage
                MailMessage.From = New MailAddress(Me._strOperatorEmail)
                MailMessage.Priority = Net.Mail.MailPriority.High
                Me._MailServer.Host = Me._strSMTP
                Me._MailServer.ServicePoint.MaxIdleTime = 1000
                Me._MailServer.Send(MailMessage)
                MailMessage.Dispose()

                'recursively call this sub when we still have leftover text
                If strMessage IsNot Nothing Then
                    Me.SendText(strMessage, False)
                End If

            Catch ex As Exception
                Throw New System.Exception("An error occurred while trying to send an email.", ex)
            Finally
                'make sure this gets reset always
                Me._blnIsError = False
            End Try

        End Sub


        ''' <summary>
        ''' Send an error notification via email.
        ''' </summary>
        ''' <remarks>The subject indicates that an error occurred and includes application name and machine name.  The body includes the message along with where the application is running and under what user name.  It also includes instructions to check the event log and trace log for the running application.</remarks>
        ''' <param name="AddressList">An email address or a list of email addresses.  A semicolon, comma, or colon can be used as a delimiter.</param>
        ''' <param name="Message">The message to be sent.</param>
        Public Sub SendErrorMessage(ByVal Message As String, Optional ByVal AddressList As String = Nothing)

            Me._blnIsError = True

            Message &= vbCrLf & vbCrLf & "See the Windows Application Event log and the " & Me._strAppName & " trace log for more details. " & _
                       vbCrLf & "Contact your system administrator or NRC for assistance." & vbCrLf & vbCrLf

            If AddressList IsNot Nothing Then
                SendMessage(Message, AddressList)
            Else
                SendMessage(Message, Me._strEmailAddresses)
            End If

        End Sub

        ''' <summary>
        ''' Send an error notification via email.
        ''' </summary>
        ''' <remarks>The subject indicates that an error occurred and includes application name and machine name.  The body includes the message, the exception message, the exception source, and  the exception stack trace.  It also includes where the application is running and under what user name as well as instructions to check the event log and trace log for the running application.</remarks>
        ''' <param name="AddressList">An email address or a list of email addresses.  A semicolon, comma, or colon can be used as a delimiter.</param>
        ''' <param name="Message">The message to be sent.</param>
        ''' <param name="ex">The exception that occurred.</param>
        Public Sub SendErrorMessage(ByVal Message As String, ByVal ex As System.Exception, Optional ByVal AddressList As String = Nothing)

            Me._blnIsError = True

            Message &= vbCrLf & vbCrLf & "Exception.Message: " & ex.Message _
                     & vbCrLf & vbCrLf & "Exception.Source: " & ex.Source _
                     & vbCrLf & vbCrLf & "Exception.StackTrace: " & ex.StackTrace

            'write out any data related to the exception
            If ex.Data.Count > 0 Then
                Message &= vbCrLf & vbCrLf & "Exception.Data: "
                For Each de As DictionaryEntry In ex.Data
                    Message &= vbCrLf & "     " & de.Key().ToString() & " ... " & de.Value().ToString()
                Next
            End If

            If AddressList IsNot Nothing Then
                SendMessage(Message, AddressList)
            Else
                SendMessage(Message, Me._strEmailAddresses)
            End If

        End Sub

        ''' <summary>
        ''' Sends an shortened error message via email.
        ''' </summary>
        ''' <remarks>The text includes the application name, machine name, and the message.</remarks>
        ''' <param name="AddressList">An email address or a list of email addresses.  A semicolon, comma, or colon can be used as a delimiter.</param>
        ''' <param name="Message">The message to be sent.</param>
        Public Sub SendTextAlert(ByVal Message As String, Optional ByVal AddressList As String = Nothing)

            Me._blnIsError = True

            If AddressList IsNot Nothing Then
                SendText(Message, AddressList)
            Else
                SendText(Message, Me._strTextAddresses)
            End If

        End Sub

        ''' <summary>
        ''' Sends an shortened error message via email.
        ''' </summary>
        ''' <remarks>The text includes the application name and machine name, the message, and the exception message.</remarks>
        ''' <param name="AddressList">An email address or a list of email addresses.  A semicolon, comma, or colon can be used as a delimiter.</param>
        ''' <param name="Message">The message to be sent.</param>
        ''' <param name="ex">The exception that occurred.</param>
        Public Sub SendTextAlert(ByVal Message As String, ByVal ex As System.Exception, Optional ByVal AddressList As String = Nothing)

            Me._blnIsError = True

            Message &= "  Exception.Message: " & ex.Message

            If AddressList IsNot Nothing Then
                SendText(Message, AddressList)
            Else
                SendText(Message, Me._strTextAddresses)
            End If

        End Sub

        Public Function IsValidAdressList(ByVal strAddressList As String) As Boolean

            Dim strAddresses() As String

            'accepted delimiters are  ':'  ','  ';' 
            strAddressList = strAddressList.Replace(":", ";")
            strAddressList = strAddressList.Replace(",", ";")
            strAddressList = strAddressList.Replace(" ", "")
            strAddressList = strAddressList.Trim(";"c)

            'seperate email addresses
            strAddresses = Split(strAddressList, ";")
            For Each person As String In strAddresses
                If Not person Like "?*@?*.???" Then
                    Return False
                End If
            Next

            Return True
        End Function

        Public Sub New()
            If Not Security.ValidateKey Then
                Throw New System.Exception("Not valid Security Key, Please provide a valid Security Key using the security class")
            End If
        End Sub

        'clones the current object.  
        Public Function Clone() As NRC.Miscellaneous.Email_Notifier

            Dim retVal As New NRC.Miscellaneous.Email_Notifier()

            retVal.EmailAddresses = Me.EmailAddresses
            retVal.SMTP = Me.SMTP
            retVal.TextAddresses = Me.TextAddresses
            retVal.OperatorEmail = Me.OperatorEmail

            Return retVal

        End Function

    End Class
End Namespace