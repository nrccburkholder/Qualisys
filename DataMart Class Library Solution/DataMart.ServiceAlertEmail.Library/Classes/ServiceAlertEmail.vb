Imports NRC.Framework.BusinessLogic
Imports Nrc.Framework.BusinessLogic.Configuration
Imports Nrc.Framework.Notification

<Serializable()> _
Public Class ServiceAlertEmail
	Inherits BusinessBase(Of ServiceAlertEmail)
	Implements IServiceAlertEmail

#Region " Private Fields "

    Private mInstanceGuid As Guid = Guid.NewGuid
    Private mClientUserId As Integer
    Private mEmailList As String = String.Empty
    Private mAccountDirector As String = String.Empty
    Private mEmailFormat As ServiceAlertEmailFormats
    Private mLithoList As String = String.Empty
    Private mLoginName As String = String.Empty

#End Region

#Region " Public Properties "

    Public Property ClientUserId() As Integer Implements IServiceAlertEmail.ClientUserId
        Get
            Return mClientUserId
        End Get
        Private Set(ByVal value As Integer)
            If Not value = mClientUserId Then
                mClientUserId = value
                PropertyHasChanged("ClientUserId")
            End If
        End Set
    End Property

    Public Property EmailList() As String
        Get
            Return mEmailList
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mEmailList Then
                mEmailList = value
                PropertyHasChanged("EmailList")
            End If
        End Set
    End Property

    Public Property AccountDirector() As String
        Get
            Return mAccountDirector
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mAccountDirector Then
                mAccountDirector = value
                PropertyHasChanged("AD")
            End If
        End Set
    End Property

    Public Property EmailFormat() As ServiceAlertEmailFormats
        Get
            Return mEmailFormat
        End Get
        Set(ByVal value As ServiceAlertEmailFormats)
            If Not value = mEmailFormat Then
                mEmailFormat = value
                PropertyHasChanged("EmailFormat")
            End If
        End Set
    End Property

    Public Property LithoList() As String
        Get
            Return mLithoList
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mLithoList Then
                mLithoList = value
                PropertyHasChanged("LithoList")
            End If
        End Set
    End Property

    Public Property LoginName() As String
        Get
            Return mLoginName
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mLoginName Then
                mLoginName = value
                PropertyHasChanged("LoginName")
            End If
        End Set
    End Property

#End Region

#Region " Private ReadOnly Properties "

    Private ReadOnly Property LithoCodeCount() As Integer
        Get
            Dim lithoCodes() As String = mLithoList.Split(","c)
            Return lithoCodes.GetUpperBound(0) + 1
        End Get
    End Property

    Private ReadOnly Property LithoCodeCountWords() As String
        Get
            If LithoCodeCount = 1 Then
                Return " has "
            Else
                Return "s have "
            End If
        End Get
    End Property

    Private ReadOnly Property LithoCodeList() As String
        Get
            Dim lithos As String = String.Empty
            Dim lithoCodes() As String = mLithoList.Split(","c)

            For Each lithoCode As String In lithoCodes
                lithos &= String.Format("Survey Code: {0}{1}", lithoCode, vbCrLf)
            Next

            Return lithos
        End Get
    End Property

#End Region

#Region " Constructors "

    Private Sub New()

        CreateNew()

    End Sub

#End Region

#Region " Factory Methods "

    Public Shared Function NewServiceAlertEmail() As ServiceAlertEmail

        Return New ServiceAlertEmail

    End Function

    Public Shared Function GetAll() As ServiceAlertEmailCollection

        Return ServiceAlertEmailProvider.Instance.SelectAllServiceAlertEmails()

    End Function

#End Region

#Region " Basic Overrides "

    Protected Overrides Function GetIdValue() As Object

        If IsNew Then
            Return mInstanceGuid
        Else
            Return mClientUserId
        End If

    End Function

#End Region

#Region " Validation "

    Protected Overrides Sub AddBusinessRules()

        'Add validation rules here...

    End Sub

#End Region

#Region " Data Access "

    Protected Overrides Sub CreateNew()

        'Set default values here

        'Optionally finish by validating default values
        ValidationRules.CheckRules()

    End Sub

#End Region

#Region " Public Methods "

    Public Shared Function SendEmail(ByVal serviceAlert As ServiceAlertEmail, ByVal useTo As Boolean, ByVal useCC As Boolean) As Boolean

        Dim toList As New List(Of String)
        Dim ccList As New List(Of String)
        Dim bccList As New List(Of String)
        Dim recipientNoteText As String = String.Empty
        Dim recipientNoteHtml As String = String.Empty
        Dim environmentName As String = String.Empty
        Dim subjectExtra As String = String.Empty
        Dim bodyText As String = String.Empty

        Try
            'Determine who the recipients are going to be
            If useTo Then
                toList.AddRange(serviceAlert.EmailList.Split(";"c))
            End If
            If useCC Then
                ccList.Add(String.Format("{0}@NationalResearch.com", serviceAlert.AccountDirector))
            End If
            bccList.Add("JFleming@NationalResearch.com")

            'Shift the recipients up as needed
            If toList.Count = 0 Then
                If ccList.Count > 0 Then
                    toList = ccList
                Else
                    toList = bccList
                End If
                subjectExtra = " - No Client Contact Specified"
            End If

            'Determine recipients bases on the environment
            If AppConfig.EnvironmentType <> EnvironmentTypes.Production Then
                'We are not in production
                'Add the real recipients to the note
                recipientNoteText = String.Format("{0}{0}Production To:{0}", vbCrLf)
                For Each email As String In toList
                    recipientNoteText &= email & vbCrLf
                Next
                recipientNoteText &= String.Format("{0}Production CC:{0}", vbCrLf)
                For Each email As String In ccList
                    recipientNoteText &= email & vbCrLf
                Next
                recipientNoteText &= String.Format("{0}Production BCC:{0}", vbCrLf)
                For Each email As String In bccList
                    recipientNoteText &= email & vbCrLf
                Next
                recipientNoteHtml = recipientNoteText.Replace(vbCrLf, "<BR>")

                'Clear the lists
                toList.Clear()
                ccList.Clear()
                bccList.Clear()

                'Populate the toList with the Testing group only
                toList.Add("Testing@NRCPicker.com")

                'Set teh environment string
                environmentName = String.Format("({0})", AppConfig.EnvironmentName)
            End If

            'Create the message object
            Dim msg As Message
            If serviceAlert.EmailFormat = ServiceAlertEmailFormats.QuantityOnly Then
                msg = New Message("SAEmailQtyOnly", AppConfig.SMTPServer)
            Else
                msg = New Message("SAEmailQtyAndLithos", AppConfig.SMTPServer)
            End If

            'Set the message properties
            With msg
                'To recipient
                For Each email As String In toList
                    .To.Add(email)
                Next

                'Cc recipient
                For Each email As String In ccList
                    .Cc.Add(email)
                Next

                'Bcc recipient
                For Each email As String In bccList
                    .Bcc.Add(email)
                Next

                'Add the replacement values
                With .ReplacementValues
                    .Add("Environment", environmentName)
                    .Add("SubjectExtra", subjectExtra)
                    .Add("LithoCodeCount", serviceAlert.LithoCodeCount.ToString)
                    .Add("LithoCodeCountWords", serviceAlert.LithoCodeCountWords)
                    .Add("LoginName", serviceAlert.LoginName)
                    .Add("RecipientNoteText", recipientNoteText)
                    If serviceAlert.EmailFormat <> ServiceAlertEmailFormats.QuantityOnly Then
                        .Add("LithoCodeList", serviceAlert.LithoCodeList)
                    End If
                End With
            End With

            'Merge the template
            msg.MergeTemplate()

            'Get the body text
            bodyText = msg.BodyText

            'Send the message
            msg.Send()

            'Add the log entry
            Dim log As ServiceAlertEmailsAttempted = ServiceAlertEmailsAttempted.NewServiceAlertEmailsAttempted
            With log
                .ClientUserId = serviceAlert.ClientUserId
                .DateSent = Now
                .EMailFormat = serviceAlert.EmailFormat
                .LithoList = serviceAlert.LithoList
                .ToList = serviceAlert.EmailList
            End With
            log.Save()

            'Return success
            Return True

        Catch ex As Exception
            'Return this exception
            If String.IsNullOrEmpty(bodyText) Then
                bodyText = "Email not formed yet"
            End If
            bodyText = String.Format("Exception encountered while attempting to send Service Alert Email!{0}{0}{1}{0}{0}Source: {2}{0}{0}Stack Trace:{0}{3}{0}{0}Service Alert Email:{0}{4}", vbCrLf, ex.Message, ex.Source, ex.StackTrace, bodyText)

            'Add the log entry
            Dim log As ServiceAlertEmailsAttempted = ServiceAlertEmailsAttempted.NewServiceAlertEmailsAttempted
            With log
                .ClientUserId = serviceAlert.ClientUserId
                .DateSent = Nothing
                .EMailFormat = serviceAlert.EmailFormat
                .LithoList = serviceAlert.LithoList
                .ToList = serviceAlert.EmailList
                .Exception = bodyText
            End With
            log.Save()

            'Return failure
            Return False

        End Try

    End Function

#End Region

#Region " Private Methods "

#End Region

End Class


