Imports PS.Framework.BusinessLogic
Imports System.IO
Imports System.Text.RegularExpressions
Imports System.Net.Mail

Public Interface IEmail
    Property EmailID() As Integer
End Interface

Public Class Email
    Inherits BusinessBase(Of Email)
    Implements IEmail
#Region " Field Definitions "
    Private mInstanceGuid As Guid = Guid.NewGuid
    Private mEmailID As Integer = 0
    Private mToEmailAddresses As New List(Of String)
    Private mCCEmailAddresses As New List(Of String)
    Private mBCCEmailAddresses As New List(Of String)
    Private mFromEmailAddress As String = String.Empty
    Private mSubject As String = String.Empty
    Private mBody As String = String.Empty
    Private mStatusMsg As String = String.Empty
    Private mEmailStatus As EmailStatus = EmailStatus.NotSent
    Private mEmailType As EmailType = EmailType.Text
    Private mAttachments As New List(Of String)
    Private mTransferAttachments As New List(Of String)
    Private mInsertDate As DateTime
    Private mUpdateDate As DateTime
    Private mInsertUser As String = String.Empty
    Private mUpdateUser As String = String.Empty
    Private mObjectValidations As New Validation.ObjectValidations
    Private mContinueWithAttachmentError As Boolean = False
    Private mApplicationName As String = Config.ApplicationName
    Private Const CLASSNAME As String = "Email"
#End Region
#Region " Properties "
    Public Property EmailID() As Integer Implements IEmail.EmailID
        Get
            Return Me.mEmailID
        End Get
        Protected Set(ByVal value As Integer)
            Me.mEmailID = value
        End Set
    End Property
    Public Property ToEmailAddresses() As List(Of String)
        Get
            Return Me.mToEmailAddresses
        End Get
        Set(ByVal value As List(Of String))
            Me.mToEmailAddresses = value
        End Set
    End Property
    Public Property CCEmailAddresses() As List(Of String)
        Get
            Return Me.mCCEmailAddresses
        End Get
        Set(ByVal value As List(Of String))
            Me.mCCEmailAddresses = value
        End Set
    End Property
    Public Property BCCEmailAddresses() As List(Of String)
        Get
            Return Me.mBCCEmailAddresses
        End Get
        Set(ByVal value As List(Of String))
            Me.mBCCEmailAddresses = value
        End Set
    End Property
    Public Property FromEmailAddress() As String
        Get
            Return Me.mFromEmailAddress
        End Get
        Set(ByVal value As String)
            If Not (Me.mFromEmailAddress = value) Then
                Me.mFromEmailAddress = value
                PropertyHasChanged("FromEmailAddress")
            End If
        End Set
    End Property
    Public Property Subject() As String
        Get
            Return Me.mSubject
        End Get
        Set(ByVal value As String)
            If Not (Me.mSubject = value) Then
                Me.mSubject = value
                PropertyHasChanged("Subject")
            End If
        End Set
    End Property
    Public Property Body() As String
        Get
            Return Me.mBody
        End Get
        Set(ByVal value As String)
            If Not (Me.mBody = value) Then
                Me.mBody = value
                PropertyHasChanged("Body")
            End If
        End Set
    End Property
    Public Property EmailStatus() As EmailStatus
        Get
            Return Me.mEmailStatus
        End Get
        Set(ByVal value As EmailStatus)
            If Not (Me.mEmailStatus = value) Then
                Me.mEmailStatus = value
                PropertyHasChanged("EmailStatus")
            End If
        End Set
    End Property
    Public Property EmailType() As EmailType
        Get
            Return Me.mEmailType
        End Get
        Set(ByVal value As EmailType)
            If Not (Me.mEmailType = value) Then
                Me.mEmailType = value
                PropertyHasChanged("EmailType")
            End If
        End Set
    End Property
    Public Property Attachements() As List(Of String)
        Get
            Return Me.mAttachments
        End Get
        Set(ByVal value As List(Of String))
            Me.mAttachments = value
        End Set
    End Property
    Public Property InsertDate() As DateTime
        Get
            Return Me.mInsertDate
        End Get
        Set(ByVal value As DateTime)
            If Not (Me.mInsertDate = value) Then
                Me.mInsertDate = value
                PropertyHasChanged("InsertDate")
            End If
        End Set
    End Property
    Public Property UpdateDate() As DateTime
        Get
            Return Me.mUpdateDate
        End Get
        Set(ByVal value As DateTime)
            If Not (Me.mUpdateDate = value) Then
                Me.mUpdateDate = value
                PropertyHasChanged("UpdateDate")
            End If
        End Set
    End Property
    Public Property InsertUser() As String
        Get
            Return Me.mInsertUser
        End Get
        Set(ByVal value As String)
            If Not (Me.mInsertUser = value) Then
                Me.mInsertUser = value
                PropertyHasChanged("InsertUser")
            End If
        End Set
    End Property
    Public Property UpdateUser() As String
        Get
            Return Me.mUpdateUser
        End Get
        Set(ByVal value As String)
            If Not (Me.mUpdateUser = value) Then
                Me.mUpdateUser = value
                PropertyHasChanged("UpdateUser")
            End If
        End Set
    End Property
    Public Property ContinueWithAttachmentError() As Boolean
        Get
            Return Me.mContinueWithAttachmentError
        End Get
        Set(ByVal value As Boolean)
            Me.mContinueWithAttachmentError = value
        End Set
    End Property
    Public Property StatusMsg() As String
        Get
            Return Me.mStatusMsg
        End Get
        Set(ByVal value As String)
            If Not Me.mStatusMsg = value Then
                Me.mStatusMsg = value
                PropertyHasChanged("StatusMsg")
            End If
        End Set
    End Property
    Public ReadOnly Property ObjectValidations() As Validation.ObjectValidations
        Get
            Return Me.mObjectValidations
        End Get
    End Property
    Private ReadOnly Property ToEmailString() As String
        Get
            Dim retVal As String = String.Empty
            For Each item As String In Me.mToEmailAddresses
                retVal += item & ";DELIMIT;"
            Next
            If retVal.Length > 0 Then retVal = retVal.Substring(0, (retVal.Length - 9))
            Return retVal
        End Get
    End Property
    Private ReadOnly Property CCEmailString() As String
        Get
            Dim retVal As String = String.Empty
            For Each item As String In Me.mCCEmailAddresses
                retVal += item & ";DELIMIT;"
            Next
            If retVal.Length > 0 Then retVal = retVal.Substring(0, (retVal.Length - 9))
            Return retVal
        End Get
    End Property
    Private ReadOnly Property BCCEmailString() As String
        Get
            Dim retVal As String = String.Empty
            For Each item As String In Me.mBCCEmailAddresses
                retVal += item & ";DELIMIT;"
            Next
            If retVal.Length > 0 Then retVal = retVal.Substring(0, (retVal.Length - 9))
            Return retVal
        End Get
    End Property
    Private ReadOnly Property AttachmentString() As String
        Get
            Dim retVal As String = String.Empty
            For Each item As String In Me.mTransferAttachments
                retVal += item & ";DELIMIT;"
            Next
            If retVal.Length > 0 Then retVal = retVal.Substring(0, (retVal.Length - 9))
            Return retVal
        End Get
    End Property
#End Region
#Region " Constructors "
    Public Sub New()
        Me.CreateNew()
    End Sub
    Public Sub New(ByVal user As String, ByVal continueWithAttachmentError As Boolean)
        If Me.IsNew Then
            Me.mInsertUser = user
        Else
            Me.mUpdateUser = user
        End If
        Me.mContinueWithAttachmentError = continueWithAttachmentError
    End Sub
#End Region
#Region " Factory Calls "
    Public Shared Function NewEmail() As Email
        Return New Email
    End Function
    Public Shared Function NewEmail(ByVal user As String, ByVal continueWithAttachmentError As Boolean) As Email
        Return New Email(user, continueWithAttachmentError)
    End Function
    Public Shared Function GetTop50EmailsToSend() As Emails
        Return EmailProvider.Instance.GetTop50EmailsToSend()
    End Function
    Public Shared Function PingEmailDB() As Boolean
        Try
            Return EmailProvider.Instance.PingSurveyAdminDB()
        Catch ex As Exception
            Return False
        End Try
    End Function
#End Region
#Region " Data Access "
    Protected Overrides Sub Delete()
        Throw New NotImplementedException()
        'RespondentImportFileLogProvider.Instance.DeleteRespondentImportFileLog(Me)
    End Sub
    Protected Overrides Sub Insert()
        Throw New NotImplementedException()
        'RespondentImportFileLogProvider.Instance.InsertRespondentImportFileLog(Me)
    End Sub
    Protected Overrides Sub Update()
        Throw New NotImplementedException()
        'RespondentImportFileLogProvider.Instance.UpdateRespondentImportFileLog(Me)
    End Sub
    Public Function ValidateAndSendToQueue() As Validation.ObjectValidations
        If Me.mEmailID = 0 Then
            Me.Validate()
            If Not Me.mObjectValidations.ErrorsExist Then
                LoadAttachments()
                If Not Me.mObjectValidations.ErrorsExist Then
                    Try
                        Me.EmailID = EmailProvider.Instance.InsertEmail(Me.ToEmailString, CCEmailString, BCCEmailString, _
                                                           FromEmailAddress, Subject, Body, Me.mEmailType, AttachmentString, _
                                                           Me.mApplicationName, Me.mInsertUser, Me.mContinueWithAttachmentError)
                    Catch ex As Exception
                        Me.mObjectValidations.Add(New Validation.ObjectValidation(Validation.MessageTypes.Error, "Notification", CLASSNAME, _
                                            "ValidateAndSend", ex.StackTrace, ex.Message))
                    End Try
                End If
            End If
        Else
            Me.mObjectValidations.Add(New Validation.ObjectValidation(Validation.MessageTypes.Error, "Notification", CLASSNAME, _
                                            "ValidateAndSend", "", "Email has already been queued."))
        End If
        Return Me.mObjectValidations
    End Function
#End Region
#Region " Execution Methods "
    Public Function Validate() As Validation.ObjectValidations
        If Me.mSubject.Length = 0 OrElse Me.mSubject.Length > 500 Then
            Me.mObjectValidations.Add(New Validation.ObjectValidation(Validation.MessageTypes.Error, "Notification", CLASSNAME, _
                                "Validate", "", "Subject is empty or greater than 500 characters."))
        End If
        If Me.mBody.Length = 0 OrElse Me.mBody.Length > 8000 Then
            Me.mObjectValidations.Add(New Validation.ObjectValidation(Validation.MessageTypes.Error, "Notification", CLASSNAME, _
                                "Validate", "", "Body is empty or greater than 8000 characters."))
        End If
        If Me.mInsertUser.Length = 0 AndAlso Me.mUpdateUser.Length = 0 Then
            Me.mObjectValidations.Add(New Validation.ObjectValidation(Validation.MessageTypes.Error, "Notification", CLASSNAME, _
                                "Validate", "", "You must submit the current user."))
        End If        
        If Me.mFromEmailAddress.Length = 0 OrElse Me.mFromEmailAddress.Length > 500 OrElse Not EmailAddressCheck(Me.mFromEmailAddress) Then
            Me.mObjectValidations.Add(New Validation.ObjectValidation(Validation.MessageTypes.Error, "Notification", CLASSNAME, _
                                "Validate", "", "You have and invalid from address."))
        End If
        ValidateEmailCollections()
        ValidateAttachments()
        Return Me.mObjectValidations
    End Function
    Public Sub AddTo(ByVal item As String)
        Me.mToEmailAddresses.Add(item)
    End Sub
    Public Sub AddBCC(ByVal item As String)
        Me.mBCCEmailAddresses.Add(item)
    End Sub
    Public Sub AddCC(ByVal item As String)
        Me.mCCEmailAddresses.Add(item)
    End Sub
    Public Sub AddAttachment(ByVal filePath As String)
        Me.mAttachments.Add(filePath)
    End Sub
    Private Sub LoadAttachments()
        Try
            If Me.mAttachments.Count > 0 Then
                Dim strGuid As String = Guid.NewGuid().ToString
                Dim lanPath As String = Config.EmailLANPath
                Directory.CreateDirectory(lanPath & strGuid)
                For Each item As String In Me.mAttachments
                    If item.Length > 0 AndAlso File.Exists(item) Then
                        Dim fi As New FileInfo(item)
                        File.Copy(item, lanPath & strGuid & "\" & fi.Name)
                        mTransferAttachments.Add(lanPath & strGuid & "\" & fi.Name)
                        If Not File.Exists(lanPath & strGuid & "\" & fi.Name) Then
                            Throw New System.Exception("File did not successfully transfer.")
                        End If
                    End If
                Next
            End If
        Catch ex As Exception
            If Not Me.mContinueWithAttachmentError Then
                Me.mObjectValidations.Add(New Validation.ObjectValidation(Validation.MessageTypes.Error, "Notification", CLASSNAME, _
                                "LoadAttachments", ex.StackTrace, ex.Message))
            End If
        End Try
    End Sub
    Private Sub ValidateEmailCollections()
        'Validate To Emails
        If Me.mToEmailAddresses.Count = 0 OrElse Me.ToEmailString().Length > 8000 Then
            Me.mObjectValidations.Add(New Validation.ObjectValidation(Validation.MessageTypes.Error, "Notification", CLASSNAME, _
                                "ValidateEmailCollections", "", "You have and empty or too many To Addresses."))
        Else
            For Each item As String In Me.mToEmailAddresses
                If item.Length = 0 Then
                    Me.mObjectValidations.Add(New Validation.ObjectValidation(Validation.MessageTypes.Error, "Notification", CLASSNAME, _
                                "ValidateEmailCollections", "", "You have an empty To Addresses."))
                Else
                    If Not EmailAddressCheck(item) Then
                        Me.mObjectValidations.Add(New Validation.ObjectValidation(Validation.MessageTypes.Error, "Notification", CLASSNAME, _
                                "ValidateEmailCollections", "", "You have an invalid To Addresses."))
                    End If
                End If
            Next
        End If
        For Each item As String In Me.mBCCEmailAddresses
            If item.Length = 0 Then
                Me.mObjectValidations.Add(New Validation.ObjectValidation(Validation.MessageTypes.Error, "Notification", CLASSNAME, _
                            "ValidateEmailCollections", "", "You have an empty BCC Addresses."))
            Else
                If Not EmailAddressCheck(item) Then
                    Me.mObjectValidations.Add(New Validation.ObjectValidation(Validation.MessageTypes.Error, "Notification", CLASSNAME, _
                            "ValidateEmailCollections", "", "You have an invalid BCC Addresses."))
                End If
            End If
        Next
        If Me.BCCEmailString.Length > 8000 Then
            Me.mObjectValidations.Add(New Validation.ObjectValidation(Validation.MessageTypes.Error, "Notification", CLASSNAME, _
                                "ValidateEmailCollections", "", "You have too many BCC Addresses."))
        End If
        For Each item As String In Me.mCCEmailAddresses
            If item.Length = 0 Then
                Me.mObjectValidations.Add(New Validation.ObjectValidation(Validation.MessageTypes.Error, "Notification", CLASSNAME, _
                            "ValidateEmailCollections", "", "You have an empty CC Addresses."))
            Else
                If Not EmailAddressCheck(item) Then
                    Me.mObjectValidations.Add(New Validation.ObjectValidation(Validation.MessageTypes.Error, "Notification", CLASSNAME, _
                            "ValidateEmailCollections", "", "You have an invalid CC Addresses."))
                End If
            End If
        Next
        If Me.CCEmailString.Length > 8000 Then
            Me.mObjectValidations.Add(New Validation.ObjectValidation(Validation.MessageTypes.Error, "Notification", CLASSNAME, _
                                "ValidateEmailCollections", "", "You have too many CC Addresses."))
        End If
    End Sub
    Private Function EmailAddressCheck(ByVal emailAddress As String) As Boolean

        Dim pattern As String = "^[a-zA-Z][\w\.-]*[a-zA-Z0-9]@[a-zA-Z0-9][\w\.-]*[a-zA-Z0-9]\.[a-zA-Z][a-zA-Z\.]*[a-zA-Z]$"
        Dim emailAddressMatch As Match = Regex.Match(emailAddress, pattern)
        If emailAddressMatch.Success Then
            EmailAddressCheck = True
        Else
            EmailAddressCheck = False
        End If

    End Function
    Private Sub ValidateAttachments()
        Dim mType As Validation.MessageTypes
        If Me.mContinueWithAttachmentError Then
            mType = Validation.MessageTypes.Warning
        Else
            mType = Validation.MessageTypes.Error
        End If
        For i As Integer = 0 To Me.mAttachments.Count - 1            
            If Me.mAttachments(i).Length = 0 Then
                Me.mObjectValidations.Add(New Validation.ObjectValidation(mType, "Notification", CLASSNAME, _
                                "ValidateAttachments", "", "You have an empty attachment."))
            ElseIf Not File.Exists(Me.mAttachments(i)) Then
                Me.mObjectValidations.Add(New Validation.ObjectValidation(mType, "Notification", CLASSNAME, _
                                "ValidateAttachments", "", Me.mAttachments(i) & " does not exist."))
            End If
        Next
        If AttachmentString.Length > 8000 Then
            Me.mObjectValidations.Add(New Validation.ObjectValidation(mType, "Notification", CLASSNAME, _
                                "ValidateAttachments", "", "Attachment length is too long."))
        End If
    End Sub
    Public Function SendEmail() As Boolean
        Dim retVal As Boolean = False
        Me.Validate()
        If Not Me.mObjectValidations.ErrorsExist Then
            Dim client As New SmtpClient(Config.SmtpServer)
            Dim message As New MailMessage
            message.From = New MailAddress(Me.mFromEmailAddress)
            For Each item As String In Me.mToEmailAddresses
                message.To.Add(New MailAddress(item))
            Next
            For Each item As String In Me.mCCEmailAddresses
                message.CC.Add(New MailAddress(item))
            Next
            For Each item As String In Me.mBCCEmailAddresses
                message.Bcc.Add(New MailAddress(item))
            Next
            message.Subject = Me.mSubject
            message.Body = Me.mBody
            If Me.mEmailType = Library.EmailType.HTML Then
                message.IsBodyHtml = True
            Else
                message.IsBodyHtml = False
            End If
            For Each item As String In Me.mAttachments
                If Me.mContinueWithAttachmentError Then
                    If IsvalidFile(item) Then
                        message.Attachments.Add(New Attachment(item))
                    End If
                Else
                    message.Attachments.Add(New Attachment(item))
                End If                
            Next
            client.Send(message)
            EmailProvider.Instance.RecordSent(Me.mEmailID)
        End If
        Return retVal
    End Function
#End Region
#Region " Helper Methods "
    Private Function IsvalidFile(ByVal str As String) As Boolean
        Dim retVal As Boolean = False
        If str.Length > 0 AndAlso File.Exists(str) Then
            Return True
        End If
        Return retVal
    End Function
#End Region
End Class
Public Class Emails
    Inherits BusinessListBase(Of Email)

End Class
Public MustInherit Class EmailProvider
#Region " Singleton Implementation "
    Private Shared mInstance As EmailProvider
    Private Const mProviderName As String = "EmailProvider"
    ''' <summary>Retrieves the instance of the Data provider class that will implement the abstract methods.</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared ReadOnly Property Instance() As EmailProvider
        Get
            If mInstance Is Nothing Then
                mInstance = DataProviderFactory.CreateInstance(Of EmailProvider)(mProviderName)
            End If

            Return mInstance
        End Get
    End Property
#End Region
#Region "Constructors "
    Protected Sub New()
    End Sub
#End Region
#Region " Abstract Methods "
    Public MustOverride Function GetTop50EmailsToSend() As Emails
    Public MustOverride Function InsertEmail(ByVal ToAddresses As String, ByVal ccAddresses As String, ByVal bccAddresses As String, ByVal fromAddress As String, _
                                             ByVal subject As String, ByVal body As String, ByVal emailType As EmailType, ByVal attachments As String, _
                                             ByVal applicationName As String, ByVal insertUser As String, ByVal continueWAttachmentError As Boolean) As Integer
    Public MustOverride Function PingSurveyAdminDB() As Boolean
    Public MustOverride Sub RecordSent(ByVal emailID As Integer)
#End Region
End Class
