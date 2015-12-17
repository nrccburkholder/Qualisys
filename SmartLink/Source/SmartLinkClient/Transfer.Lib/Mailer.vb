Imports System.IO
Imports System.Net.Mail

Imports NRC.SmartLink.Common

Public Class Mailer

#Region "Private Variable"

    ''' <summary>
    ''' Set by reading NRC_SLT._AppName property
    ''' </summary>
    Private _AppName As String = My.Application.Info.Title   'FileVersionInfo.GetVersionInfo(System.Reflection.Assembly.GetExecutingAssembly.Location).Comments

    ''' <summary>
    ''' Module level variable used to contain the location of the mail server
    ''' </summary>
    Private _SrvrLoc As String
    ''' <summary>
    ''' Module level variable used to contain the email destination
    ''' </summary>
    Private _SendTo As String
    ''' <summary>
    ''' Module level variable used to contain the source of the email
    ''' </summary>
    Private _SentFrom As String
    ''' <summary>
    ''' Module level variable used to contain the subject line
    ''' </summary>
    Private _Subject As String
    ''' <summary>
    ''' Module level variable used to contain the location of the HTML template
    ''' </summary>
    Private _HTMLTemplateLoc As String
    ''' <summary>
    ''' Module level variable used to contain the HTML place holder text
    ''' </summary>
    ''' <remarks>This text, inside the HTML template, is replaced with the message body text before the email is sent.</remarks>
    Private _msgPlaceHolder As String = "REPLACE WITH ERROR LOG TEXT"
    ''' <summary>
    ''' Module level variable used to contain the location of the mail server.
    ''' </summary>
    ''' <remarks>This could be in the form of an IP address or DNS name</remarks>
    Private _MailServerLoc As String
    ''' <summary>
    ''' Module level variable used to contain the value of the flag the designates if the email message type is HTML
    ''' </summary>
    Private _IsBodyHTML As Boolean
    ''' <summary>
    ''' Module level variable used to contain the text of the message
    ''' </summary>
    Private _MailMessage As MailMessage
    ''' <summary>
    ''' Module level variable used to contain an instance of the system mail server object
    ''' </summary>
    Private _MailServer As New SmtpClient

    ''' <summary>
    ''' Module level variable that contains the list of mail recipients for carbon copy
    ''' </summary>
    Private _strCC As String = String.Empty
    ''' <summary>
    ''' Module level variable that contains the list of mail recipients for blind carbon copy
    ''' </summary>
    Private _strBCC As String = String.Empty
    ''' <summary>
    ''' Module level variable used to contain the text of the mail message
    ''' </summary>
    Private _MessageBody As String = String.Empty
    ''' <summary>
    ''' Module level variable used to contain the priority setting for the email
    ''' </summary>
    Private _objPriority As MailPriority = MailPriority.Normal
    ''' <summary>
    ''' Module level variable used to contain the collection of attachments to be sent with the email.
    ''' </summary>
    Private _objAttachment As Attachment = Nothing
    ''' <summary>
    ''' Module level variable used to contain mail attachment objects
    ''' </summary>
    Private _colAttachments As New ArrayList
    ''' <summary>
    ''' Module level variable used to contain list of carbon copy email addresses
    ''' </summary>
    Private _colCCNames As New List(Of String)()
    ''' <summary>
    ''' Module level variable used to contain list of blind carbon copy email addresses
    ''' </summary>
    Private _colBCCNames As New List(Of String)()

#End Region

#Region "Public Properties"

    ''' <summary>
    ''' Property used to indicate to the mail object the desired level of importance assigned to the email.
    ''' </summary>
    Public Property MsgPriority() As MailPriority
        Get
            Return _objPriority
        End Get
        Set(ByVal value As MailPriority)
            _objPriority = value
        End Set
    End Property

    ''' <summary>
    ''' Email addresses which should receive blind carbon copies
    ''' </summary>
    Public Property BCC() As String
        Get
            Return _strBCC
        End Get
        Set(ByVal value As String)
            _strBCC = value
        End Set
    End Property

    ''' <summary>
    ''' Email addresses which should recieve carbon copies
    ''' </summary>
    Public Property CC() As String
        Get
            Return _strCC
        End Get
        Set(ByVal value As String)
            _strCC = value
        End Set
    End Property

    ''' <summary>
    ''' Property used to set or get the text of the message
    ''' </summary>
    Public Property MessageBody() As String
        Get
            Return _MessageBody
        End Get
        Set(ByVal value As String)
            _MessageBody = value
        End Set
    End Property

    ''' <summary>
    ''' Flag used to indicate if the message is in HTML format
    ''' </summary>
    Public Property IsBodyHTML() As Boolean
        Get
            Return _IsBodyHTML
        End Get
        Set(ByVal value As Boolean)
            _IsBodyHTML = value
            If Not _MailMessage Is Nothing Then
                _MailMessage.IsBodyHtml = value
            End If
        End Set
    End Property

    ''' <summary>
    ''' Location of file that has an HTML template
    ''' </summary>
    ''' <remarks>The text in this file is merged with message body to complete the email body text sent.</remarks>
    Public Property HTMLTemplateLoc() As String
        Get
            Return _HTMLTemplateLoc
        End Get
        Set(ByVal value As String)
            _HTMLTemplateLoc = value
        End Set
    End Property

    ''' <summary>
    ''' The text from this property will make up the text of the subject line for the email.
    ''' </summary>
    Public Property Subject() As String
        Get
            Return _Subject
        End Get
        Set(ByVal value As String)
            _Subject = value
        End Set
    End Property

    ''' <summary>
    ''' Identifies the sender of the email.
    ''' </summary>
    Public Property SentFrom() As String
        Get
            Return _SentFrom
        End Get
        Set(ByVal value As String)
            _SentFrom = value
        End Set
    End Property

    ''' <summary>
    ''' List of all recipients to this email
    ''' </summary>
    Public Property SendTo() As String
        Get
            Return _SendTo
        End Get
        Set(ByVal value As String)
            _SendTo = value
        End Set
    End Property

    ''' <summary>
    ''' Location of the email server
    ''' </summary>
    ''' <remarks>set by Watcher:GetParameters</remarks>
    Public Property SrvrLoc() As String
        Get
            Return _SrvrLoc
        End Get
        Set(ByVal value As String)
            _SrvrLoc = value
        End Set
    End Property

#End Region

#Region "Public Methods"


    Public Sub New()

        ' Clear any pre-existing CC, BCC or Attachments
        _colAttachments.Clear()
        _colCCNames.Clear()
        _colBCCNames.Clear()

    End Sub

    Public Sub New(ByVal MailServerLoc As String)

        ' Clear any pre-existing CC, BCC or Attachments
        _colAttachments.Clear()
        _colCCNames.Clear()
        _colBCCNames.Clear()

        _MailServerLoc = MailServerLoc

    End Sub


    ''' <summary>
    ''' Method for attaching files to email messages
    ''' </summary>
    ''' <param name="FileLoc">the location of the file to be attached</param>
    Public Function AttachFile(ByVal FileLoc As String) As Boolean

        Dim strProcName As String = "AttachFile"
        Dim att As Attachment = Nothing

        Try
            If File.Exists(FileLoc) Then
                att = New Attachment(FileLoc)
                _colAttachments.Add(att)
                Return True
            End If

        Catch ex As Exception
            Log.WriteError("An error has occurred in NRC_Mail::AttachFile." &
                                 "See the Application EventLog & errors log for more details. " &
                                 "Contact your system administrator or NRC for assistance.", ex)
            Return False
        End Try

    End Function

    ''' <summary>
    ''' Overloded Method to send an email.
    ''' </summary>
    ''' <param name="Message">Body text of the email message</param>
    ''' <returns>Includes the message parameter.</returns>
    Public Function SendEmail(Optional ByVal message As String = Nothing, Optional ByVal exception As Exception = Nothing) As Boolean

        Dim strProcName As String = "SendEmail.1"
        Try
            If message IsNot Nothing Then
                _MessageBody = message

                If exception IsNot Nothing Then
                    _MessageBody += vbCrLf & vbCrLf & "Exception.Message: " & exception.Message _
                        & vbCrLf & vbCrLf & "Exception.Source: " & exception.Source _
                        & vbCrLf & vbCrLf & "Exception.StackTrace: " & exception.StackTrace
                End If
                _MessageBody += vbCrLf & vbCrLf & "See the errors log for more details. " &
                    vbCrLf & "Contact your system administrator or NRC for assistance."

                ' Else assumes message body has already been set via the public property
            End If

            Send()
            Return True

        Catch ex As Exception
            Log.WriteError("An error has occurred in NRC_Mail::SendEMail(Message)" &
                                "See the Application EventLog & errors log for more details. " &
                                "Contact your system administrator or NRC for assistance.", ex)
            Return False
        End Try

    End Function

    ''' <summary>
    ''' Method for removing attachments from the mail object
    ''' </summary>
    Public Sub ClearAttachments()
        _colAttachments.Clear()
    End Sub

#End Region

#Region "Private Methods"

    ''' <summary>
    ''' Once all components of the message are set
    ''' </summary>
    ''' <remarks>
    ''' 1.) Call CreateNewMsg()
    ''' 2.) Check to see if message has an HTML template and merge message body with template as needed
    ''' 3.) Create the Email message structure
    ''' 4.) Identify the mail server and invoke the send method
    ''' </remarks>
    Private Function Send() As Boolean

        Dim strProcName As String = "Send"
        Dim sb As New Text.StringBuilder

        If Not CreateNewMsg() Then
            Return False
        End If

        ' Combine message text with HTML if it is available
        If File.Exists(_HTMLTemplateLoc) Then
            Dim FileReader As New Microsoft.VisualBasic.FileIO.TextFieldParser(_HTMLTemplateLoc)
            Dim strHTML As String = FileReader.ReadToEnd

            With sb
                .Append(strHTML)
                .Replace(_msgPlaceHolder, MessageBody)
            End With

            MessageBody = sb.ToString
            Me.IsBodyHTML = True
            _MailMessage.Body = MessageBody

        End If

        ' Create the Email message structure
        With _MailMessage
            For Each itmCC As String In _colCCNames
                .CC.Add(itmCC)
            Next
            For Each itmBCC As String In _colBCCNames
                .CC.Add(itmBCC)
            Next
            For Each itmAttachment As Attachment In _colAttachments
                .Attachments.Add(itmAttachment)
            Next
            .Priority = _objPriority
        End With

        ' SmtpClient is used to send the e-mail
        ' UseDefaultCredentials tells the mail client to use the 
        ' Windows credentials of the account (i.e. user account) 
        ' being used to run the application
        _MailServer.UseDefaultCredentials = True

        ' Send delivers the message to the mail server
        With _MailServer
            .Host = _SrvrLoc
            .Send(_MailMessage)
        End With

        _MailMessage = Nothing
        Return True

    End Function

    ''' <summary>
    ''' Method for initializing the objects required to send an email.
    ''' </summary>
    Private Function CreateNewMsg() As Boolean

        Dim strProcName As String = "CreateNewMsg"

        Try
            If MailComponentsVerified() Then
                _MailMessage = New MailMessage(_SentFrom, _SendTo, _Subject, _MessageBody)
                _MailMessage.IsBodyHtml = _IsBodyHTML
                Return True
            End If

        Catch ex As Exception
            Log.WriteError("An error has occurred and the NRC SmartLink Transfer service has stopped. " &
                                "See the Windows Application Event log and the NRC SLT error log for more details. " &
                                "Contact your system administrator or NRC for assistance.", ex)
            Return False
        End Try

    End Function

    ''' <summary>
    ''' Method for verifying that the required information is available
    ''' </summary>
    Private Function MailComponentsVerified() As Boolean

        Dim strProcName As String = "MailComponentsVerified"
        ' Verify that all required parameters have been set and Throw Exception if needed
        Try
            If _SrvrLoc = String.Empty Then
                Throw New ArgumentException("The Email Server Location parameter is not set.")
            ElseIf _SentFrom = String.Empty Then
                Throw New ArgumentException("The Email From parameter is not set.")
            ElseIf _SendTo = String.Empty Then
                Throw New ArgumentException("The Send To parameter is not set.")
            ElseIf _Subject = String.Empty Then
                Throw New ArgumentException("The Subject Line parameter is not set.")
            ElseIf _MessageBody = String.Empty Then
                Throw New ArgumentException("The Message Body parameter is not set.")
            End If

            Return True

        Catch ex As ArgumentException
            Log.WriteError("NRCEmail::VerifyMailComponents - " & ex.Message, ex)
            Return False
        End Try

    End Function
#End Region

    Protected Overrides Sub Finalize()
        MyBase.Finalize()
    End Sub
End Class
