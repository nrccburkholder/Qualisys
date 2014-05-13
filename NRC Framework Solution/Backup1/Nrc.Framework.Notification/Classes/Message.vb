Imports ActiveUp.Net
Imports System.Collections.ObjectModel

Partial Public Class Message

#Region "Private Members"

    Private mMessageType As MessageTypes
    Private mTemplateID As Integer
    Private mTemplateName As String
    Private mTemplateString As String
    Private mTemplateFields As List(Of String)
    Private mTemplateTables As Dictionary(Of String, List(Of String))

    Private mSmtpServer As String = String.Empty

    Private mFrom As New Address
    Private mTo As New AddressCollection
    Private mCc As New AddressCollection
    Private mBcc As New AddressCollection
    Private mSubject As String = String.Empty
    Private mBodyText As String = String.Empty
    Private mBodyHtml As String = String.Empty
    Private mAttachments As New AttachmentCollection

    Private mReplacementFields As New Dictionary(Of String, String)
    Private mReplacementTables As New Dictionary(Of String, DataTable)

    Private mValidationErrors As New List(Of String)

#End Region


#Region "Public Properties"

    ''' <summary>Represents the from address in a email</summary>
    ''' <value>An address object</value>
    ''' <CreatedBy>Jeff Fleming</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property From() As Address
        Get
            Return mFrom
        End Get
        Set(ByVal value As Address)
            mFrom = value
        End Set
    End Property

    ''' <summary>Represents the to collection of emails in a email to line</summary>
    ''' <value>An AddressCollection object</value>
    ''' <CreatedBy>Jeff Fleming</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public ReadOnly Property [To]() As AddressCollection
        Get
            Return mTo
        End Get
    End Property

    ''' <summary>Represents the cc collection of emails for an email cc line.</summary>
    ''' <value>An AddressCollection object</value>
    ''' <CreatedBy>Jeff Fleming</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public ReadOnly Property Cc() As AddressCollection
        Get
            Return mCc
        End Get
    End Property

    ''' <summary>Represents the bcc collection of bcc email addresses.</summary>
    ''' <value>An AddressCollection object</value>
    ''' <CreatedBy>Jeff Fleming</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public ReadOnly Property Bcc() As AddressCollection
        Get
            Return mBcc
        End Get
    End Property

    ''' <summary>Represents the subject line of an email.</summary>
    ''' <value>the subject line as a string.</value>
    ''' <CreatedBy>Jeff Fleming</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property Subject() As String
        Get
            Return mSubject
        End Get
        Set(ByVal value As String)
            If mMessageType = MessageTypes.Template Then
                Throw New InvalidPropertyValueException("The Subject Property is not available if a Template is defined")
            End If
            mSubject = value
        End Set
    End Property

    ''' <summary>Represents the body text of a non HTML based message.</summary>
    ''' <value>String representing the body text of a non html based message.</value>
    ''' <CreatedBy>Jeff Fleming</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property BodyText() As String
        Get
            Return mBodyText
        End Get
        Set(ByVal value As String)
            If mMessageType = MessageTypes.Template Then
                Throw New InvalidPropertyValueException("The BodyText Property is not available if a Template is defined")
            End If
            mBodyText = value
        End Set
    End Property

    ''' <summary>Represents the body html of an html message.</summary>
    ''' <value>A string that represents the body html of an html message.</value>
    ''' <CreatedBy>Jeff Fleming</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property BodyHtml() As String
        Get
            Return mBodyHtml
        End Get
        Set(ByVal value As String)
            If mMessageType = MessageTypes.Template Then
                Throw New InvalidPropertyValueException("The BodyHtml Property is not available if a Template is defined")
            End If
            mBodyHtml = value
        End Set
    End Property

    ''' <summary>A collection of attachment objects which contain path to the files wanting to be attached to an email.</summary>
    ''' <value>AttachmentCollection</value>
    ''' <CreatedBy>Jeff Fleming</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public ReadOnly Property Attachments() As AttachmentCollection
        Get
            Return mAttachments
        End Get
    End Property

    ''' <summary>This list represents values that will be replaced of of an email body.  The user will fill this list which will then merge against merge fields in contained within the body html or text.</summary>
    ''' <value>Dictionary(Of String, String)</value>
    ''' <CreatedBy>Jeff Fleming</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public ReadOnly Property ReplacementValues() As Dictionary(Of String, String)
        Get
            Return mReplacementFields
        End Get
    End Property

    ''' <summary>This list represents key - table name - value data table used as merge field replacements of tables within the body or text of an email.</summary>
    ''' <value>Dictionary(Of String, DataTable)</value>
    ''' <CreatedBy>Jeff Fleming</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public ReadOnly Property ReplacementTables() As Dictionary(Of String, DataTable)
        Get
            Return mReplacementTables
        End Get
    End Property

    ''' <summary>A string list of validation errors such as not putting anything in the from clause or having invalid merge fields.</summary>
    ''' <value>List(Of String)</value>
    ''' <CreatedBy>Jeff Fleming</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public ReadOnly Property ValidationErrors() As List(Of String)
        Get
            Return mValidationErrors
        End Get
    End Property

#End Region


#Region "Constructors"

    ''' <summary>This constructor will create a message object for a stand alone notification (no template).</summary>
    ''' <param name="smtpServer">Specifies the SMTP server to be used to send the message</param>
    ''' <CreatedBy>Jeff Fleming</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Sub New(ByVal smtpServer As String)

        'Validate the SMTP server
        If String.IsNullOrEmpty(smtpServer) Then
            Throw New System.ArgumentException("The smtpServer must be specified for messages of MessageType.Normal", smtpServer)
        End If

        'Store the parameters
        mMessageType = MessageTypes.Normal
        mSmtpServer = smtpServer
        mTemplateName = String.Empty

    End Sub

    ''' <summary>This constructor will create a message object that for a templated notification.</summary>
    ''' <param name="templateName">Specifies the name of the template to be used to create the message</param>
    ''' <param name="smtpServer">Specifies the SMTP server to be used to send the message</param>
    ''' <CreatedBy>Jeff Fleming</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Sub New(ByVal templateName As String, ByVal smtpServer As String)

        'Validate the Template Name
        If String.IsNullOrEmpty(templateName) Then
            Throw New System.ArgumentException("The templateName must be specified for messages of MessageType.Template", templateName)
        End If

        'Store the parameters
        mMessageType = MessageTypes.Template
        mTemplateName = templateName

        mTemplateFields = New List(Of String)
        mTemplateTables = New Dictionary(Of String, List(Of String))

        'Get the template information from the database
        LoadTemplateData()

        'If the smtpServer was supplied then that is the one we will use
        If Not String.IsNullOrEmpty(smtpServer) Then
            mSmtpServer = smtpServer
        End If

        'Validate the SMTP server
        If String.IsNullOrEmpty(mSmtpServer) Then
            Throw New System.ArgumentException(String.Format("The SMTP server was not defined with Template Name '{0}' and was not passed as a parameter", mTemplateName), mTemplateName)
        End If

    End Sub

#End Region


#Region "Public Methods"

    ''' <summary>Initiates the validation of fields within the message object.</summary>
    ''' <returns>True if message is valid, else false.</returns>
    ''' <CreatedBy>Jeff Fleming</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Function Validate() As Boolean

        'Clear the Broken Rules collection
        mValidationErrors.Clear()

        'Validate the email addresses
        ValidateAddresses()

        'Validate the email attachments
        ValidateAttachments()

        'Validate the subject
        ValidateSubject()

        'Validate the email body
        ValidateBody()

        'Determine the return value
        Return (mValidationErrors.Count = 0)

    End Function

    ''' <summary>Performs the merge of a templated message</summary>
    ''' <returns>true if merge is successful else false.</returns>
    ''' <CreatedBy>Jeff Fleming</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Function MergeTemplate() As Boolean

        'If this is not a templated message then exit
        If mMessageType <> MessageTypes.Template Then Return True

        'Validate the message
        If Not Validate() Then Return False

        Try
            'Build the message
            BuildMessage()

            Return True

        Catch ex As Exception
            Throw New MessageSendException("Message.Merge Failed", ex)
            Return False

        End Try

    End Function

    ''' <summary>If a valid message will send the email(s)</summary>
    ''' <returns>true if sent else false.</returns>
    ''' <CreatedBy>Jeff Fleming</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Function Send() As Boolean

        'Validate the message
        If Not Validate() Then Return False

        Try
            'Build the message
            Dim auMessage As Mail.Message = BuildMessage()

            'Send the message
            auMessage.Send(mSmtpServer)

            Return True

        Catch ex As Exception
            Throw New MessageSendException("Message.Send Failed", ex)
            Return False

        End Try

    End Function

    ''' <summary>Returns a html printable summary of an email message represented in the message object.</summary>
    ''' <param name="messagePreview"></param>
    ''' <returns>true if no exceptions, else false.</returns>
    ''' <CreatedBy>Jeff Fleming</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Function Summary(ByRef messagePreview As String) As Boolean

        'Validate the message
        If Not Validate() Then Return False

        Try
            'Build the message
            Dim auMessage As Mail.Message = BuildMessage()

            'Send the message
            messagePreview = auMessage.Summary

            Return True

        Catch ex As Exception
            messagePreview = String.Format("Message.Summary Failed{0}{0}{1}{0}{0}{2}", vbCrLf, ex.Message, ex.StackTrace)
            Return False

        End Try

    End Function

#End Region


#Region "Private Methods"

    ''' <summary>Creates an active up mail object that can be sent.</summary>
    ''' <returns>an active Up Message object.</returns>
    ''' <CreatedBy>Jeff Fleming</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Function BuildMessage() As Mail.Message

        'Get a message object
        Dim auMessage As Mail.Message = Nothing

        'Create the message body based on mMessageType
        Select Case mMessageType
            Case MessageTypes.Normal
                'Create the new message object
                auMessage = New Mail.Message

                'Set the message subject
                auMessage.Subject = mSubject

                'Set the text body of the message
                auMessage.BodyText.Text = mBodyText

                'Set the html body of the message
                auMessage.BodyHtml.Text = mBodyHtml

            Case MessageTypes.Template
                'Create the Templater object
                Dim auTemplater As New Mail.Templater

                'Load the template from the string obtained from the database
                auTemplater.LoadTemplateFromString(mTemplateString)

                'Create the Merger object using this template
                Dim auMerger As New Mail.Merger(auTemplater)

                'Merge any required tables
                For Each repTab As String In mReplacementTables.Keys
                    auMerger.MergeListTemplate(repTab, mReplacementTables(repTab))
                Next

                'Merge the remainder of the message
                auMessage = auMerger.MergeMessage(mReplacementFields)

                'Merge the subject line
                auMessage.Subject = auMerger.MergeText(mSubject, mReplacementFields, False)

                'Set the local variables to the merged values
                mSubject = auMessage.Subject
                mBodyText = auMessage.BodyText.Text
                mBodyHtml = auMessage.BodyHtml.Text

        End Select

        'Set the message properties
        With auMessage
            'Assign the sender
            .From = mFrom.AuAddress

            'Assign the To
            For Each addr As Address In mTo
                .To.Add(addr.AuAddress)
            Next

            'Assign the Cc
            For Each addr As Address In mCc
                .Cc.Add(addr.AuAddress)
            Next

            'Assign the Bcc
            For Each addr As Address In mBcc
                .Bcc.Add(addr.AuAddress)
            Next

            'Add any required attachments
            For Each attach As Attachment In mAttachments
                .Attachments.Add(attach.FilePath, True)
            Next
        End With

        Return auMessage

    End Function

    ''' <summary>Checks the to, from, bcc, cc address to make sure they contain valid email addresses.</summary>
    ''' <CreatedBy>Jeff Fleming</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub ValidateAddresses()

        'Validate the From property
        If mFrom Is Nothing OrElse String.IsNullOrEmpty(mFrom.Email) Then
            mValidationErrors.Add("The From address must be provided")
        ElseIf Not Mail.Validator.ValidateSyntax(mFrom.AuAddress) Then
            mValidationErrors.Add("The From address is invalid")
        End If

        'Validate the To property
        If mTo.Count = 0 Then
            mValidationErrors.Add("You must provide at least one To address")
        Else
            For Each addr As Address In mTo
                If Not Mail.Validator.ValidateSyntax(addr.AuAddress) Then
                    mValidationErrors.Add(String.Format("The TO address ({0}) is invalid", addr.Merged))
                End If
            Next
        End If

        'Validate the Cc property
        If mCc.Count > 0 Then
            For Each addr As Address In mCc
                If Not Mail.Validator.ValidateSyntax(addr.AuAddress) Then
                    mValidationErrors.Add(String.Format("The CC address ({0}) is invalid", addr.Merged))
                End If
            Next
        End If

        'Validate the Bcc property
        If mBcc.Count > 0 Then
            For Each addr As Address In mBcc
                If Not Mail.Validator.ValidateSyntax(addr.AuAddress) Then
                    mValidationErrors.Add(String.Format("The BCC address ({0}) is invalid", addr.Merged))
                End If
            Next
        End If

    End Sub

    ''' <summary>Validates that any file needed to be attatched actually exist.</summary>
    ''' <CreatedBy>Jeff Fleming</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub ValidateAttachments()

        'Validate the Attachments property
        If mAttachments.Count > 0 Then
            For Each att As Attachment In mAttachments
                If String.IsNullOrEmpty(att.FilePath) Then
                    mValidationErrors.Add("The Attachment.FilePath must be provided")
                Else
                    Dim file As New System.IO.FileInfo(att.FilePath)
                    If Not file.Exists Then
                        mValidationErrors.Add(String.Format("The Attachment.FilePath '{0}' does not exist", att.FilePath))
                    End If
                End If
            Next
        End If

    End Sub

    ''' <summary>Validates that a subject line was entered.</summary>
    ''' <CreatedBy>Jeff Fleming</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub ValidateSubject()

        'Validate the message subject
        If String.IsNullOrEmpty(mSubject) Then
            mValidationErrors.Add("The message Subject must be provided")
        End If

    End Sub

    ''' <summary>Validates that a body was entered and that any mergefields required were put in by the user of the message object.</summary>
    ''' <CreatedBy>Jeff Fleming</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub ValidateBody()

        Select Case mMessageType
            Case MessageTypes.Normal
                'Validate the Body
                If String.IsNullOrEmpty(mBodyText.Trim) AndAlso String.IsNullOrEmpty(mBodyHtml.Trim) Then
                    mValidationErrors.Add("You must provide either a BodyText, BodyHtml, or both")
                End If

            Case MessageTypes.Template
                'Validate that the user has not provided any ReplacementFields not in our list
                For Each repFld As String In mReplacementFields.Keys
                    If Not mTemplateFields.Contains(repFld) Then
                        'Add this ReplacementField to the broken rules collection
                        mValidationErrors.Add(String.Format("ReplacementField '{0}' is not a valid TemplateField", repFld))
                    End If
                Next

                'Validate that the user has not provided any ReplacementTables not in our list
                For Each repTab As String In mReplacementTables.Keys
                    If Not mTemplateTables.ContainsKey(repTab) Then
                        'Add this ReplacementTable to the broken rules collection
                        mValidationErrors.Add(String.Format("ReplacementTable name '{0}' is not a valid TemplateTable", repTab))
                    End If

                    'Validate that the user has not provided any ReplacementTable columns for columns not in our list
                    For Each col As DataColumn In mReplacementTables(repTab).Columns
                        If Not mTemplateTables(repTab).Contains(col.ColumnName) Then
                            'Add this ReplacementTable column name to the broken rules collection
                            mValidationErrors.Add(String.Format("Column name '{0}' is not a valid column for TemplateTable name '{1}'", col.ColumnName, repTab))
                        End If
                    Next
                Next

        End Select

    End Sub

#End Region

End Class
