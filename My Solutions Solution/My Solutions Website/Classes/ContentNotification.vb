Imports Nrc.DataMart.MySolutions.Library
Imports NRC.NRCAuthLib

Imports System.IO
Imports System.Net.Mail

Imports System.Xml
Imports System.Xml.Xsl

Imports Log = NRC.NRCAuthLib.SecurityLog

'' Controls whether to use DowloadDocument.aspx (True) or ResourceSearch.aspx (False)
#Const DOWNLOAD_DOCUMENT = False

Public NotInheritable Class ContentNotification

    Private Const BufferLength As Integer = 1024 * 4

    Private Delegate Sub DoWork()

    Private ReadOnly mResource As MemberResource
    Private ReadOnly mDownloadDocument As Uri
    Private ReadOnly mBanner As Uri
    Private ReadOnly mHomePage As Uri
    Private ReadOnly mHost As Uri
    Private ReadOnly mTemplates As String

    Private Sub New(ByVal resource As MemberResource)
        mResource = resource
        mTemplates = HttpContext.Current.Server.MapPath("~/eToolKit/Admin")
#If DOWNLOAD_DOCUMENT Then
        mDownloadDocument = VirtualToAbsolute("~/Shared/DownloadDocument.aspx")
#Else
        mDownloadDocument = VirtualToAbsolute("~/eToolKit/ResourceSearch.aspx")
#End If
        mBanner = VirtualToAbsolute("~/img/email_header.png")
        mHomePage = VirtualToAbsolute("~/eToolkit/Default.aspx")
        mHost = VirtualToAbsolute("/")
    End Sub

    Private Function VirtualToAbsolute(ByVal virtualPath As String) As Uri
        Dim builder As New UriBuilder(HttpContext.Current.Request.Url)
        builder.Path = VirtualPathUtility.ToAbsolute(virtualPath)
        Return builder.Uri
    End Function

    Public Shared Sub Notify(ByVal resource As MemberResource)
        Dim notification As New ContentNotification(resource)
        Dim work As DoWork = AddressOf notification.SendContentNotification
        work.BeginInvoke(AddressOf SendContentNotificationCompleted, work)
    End Sub

    Private Shared Sub SendContentNotificationCompleted(ByVal ar As IAsyncResult)
        Dim work As DoWork = CType(ar.AsyncState, DoWork)
        Try
            work.EndInvoke(ar)
        Catch ex As Exception
            PublishException(ex)
        End Try
    End Sub

    Private Shared Sub PublishException(ByVal ex As Exception, Optional ByVal handled As Boolean = False, Optional ByVal warning As String = "")
        Dim additionalInfo As New System.Collections.Specialized.NameValueCollection
        additionalInfo.Add("Time Stamp", DateTime.Now.ToString())
        additionalInfo.Add("Server Name", Environment.MachineName)
        additionalInfo.Add("Page Name", "Content Notification")

        additionalInfo.Add("Handled", handled.ToString)

        If warning.Length > 0 Then additionalInfo.Add("Warning", warning)

        ExceptionManager.Publish(ex, additionalInfo)

        Log.LogWebException("", "", "eToolKit", "", "Content Notification", handled, ex.Message, ex.GetType().ToString(), ex.StackTrace)
    End Sub

    Private Sub SendContentNotification()
        Dim plainTextBody As String = FormatText("PlainTextNotification.xslt")

        Using plainTextMessage As New MailMessage
            InitializePlainText(plainTextMessage, plainTextBody)
            SendContentNotification(plainTextMessage, EmailNotifyMethod.PlainTextEmail)
        End Using

        Using htmlMessage As New MailMessage
            Dim htmlBody As String = HtmlEntityRef.HtmlEncodeEntity(FormatText("HtmlNotification.xslt"))
            InitializeHtml(htmlMessage, htmlBody, plainTextBody)
            SendContentNotification(htmlMessage, EmailNotifyMethod.HtmlEmail)
        End Using

    End Sub

    Private Sub SendContentNotification(ByVal email As MailMessage, ByVal notifyMethod As EmailNotifyMethod)
        Dim memberIds() As Integer = MemberContentNotifyMethod.GetContentNotifyMemberIds(notifyMethod)
        Dim members As MemberCollection = MemberCollection.GetMembersByIds(memberIds)
        For Each member As Member In members
            Dim address As New MailAddress(member.EmailAddress, member.DisplayLabel)
            email.Bcc.Add(address)
        Next
        Dim smtp As New SmtpClient(Config.SmtpServer)
        smtp.Send(email)
    End Sub

    Private Function FormatText(ByVal template As String) As String
        Using input As XmlReader = ResourceToXml()
            Dim output As New StringBuilder(BufferLength)
            Using results As New StringWriter(output)
                Dim xslt As New XslCompiledTransform()
                Dim templatePath As String = Path.Combine(mTemplates, template)
                xslt.Load(templatePath)
                Dim arguments As New XsltArgumentList()
                arguments.AddParam("DownloadDocument", "", mDownloadDocument.ToString())
#If DOWNLOAD_DOCUMENT Then
                arguments.AddParam("DownloadDocument", "", "&amp;type=mr")
#End If
                arguments.AddParam("Banner", "", mBanner.ToString())
                arguments.AddParam("HomePage", "", mHomePage.ToString())
                arguments.AddParam("Host", "", mHost.ToString())
                xslt.Transform(input, arguments, results)
            End Using
            Return output.ToString()
        End Using
    End Function

    Private Sub InitializeEmail(ByVal email As MailMessage)
        email.From = New MailAddress(Config.ResourcesEmail)
        email.To.Add(New MailAddress(Config.ResourcesEmail, "Program Users"))
        email.Subject = "New eToolKit Resource Available"
    End Sub

    Private Sub InitializeHtml(ByVal email As MailMessage, ByVal htmlBody As String, ByVal plainTextBody As String)
        InitializeEmail(email)
        Dim htmlView As AlternateView = AlternateView.CreateAlternateViewFromString(htmlBody, Nothing, "text/html")
        htmlView.BaseUri = mHost
        email.AlternateViews.Add(htmlView)
        Dim plainView As AlternateView = AlternateView.CreateAlternateViewFromString(plainTextBody, Nothing, "text/plain")
        plainView.BaseUri = mHost
        email.AlternateViews.Add(plainView)
    End Sub

    Private Sub InitializePlainText(ByVal email As MailMessage, ByVal body As String)
        InitializeEmail(email)
        email.Body = body
    End Sub

    Private Function ResourceToXml() As XmlReader
        Dim services As ServiceTypeCollection = ServiceType.GetAll()

        Dim output As New StringBuilder(BufferLength)
        Using writer As XmlWriter = XmlWriter.Create(output)

            writer.WriteStartDocument()
            writer.WriteStartElement("MemberResource")
            writer.WriteAttributeString("Id", mResource.Id.ToString())

            writer.WriteElementString("Title", mResource.Title)
            writer.WriteElementString("Author", mResource.Author)
            writer.WriteElementString("FilePath", mResource.FilePath)
            writer.WriteElementString("OriginalPath", mResource.OriginalPath)

            writer.WriteStartElement("AbstractHtml")
            Dim abstractHtml As String = HtmlEntityRef.HtmlDecodeEntity(mResource.AbstractHtml)
            writer.WriteRaw(abstractHtml)
            writer.WriteEndElement() ' AbstractHtml

            writer.WriteStartElement("AbstractPlainText")
            Dim abstractPlainText As String = HttpUtility.HtmlDecode(mResource.AbstractPlainText)
            writer.WriteString(abstractPlainText)
            writer.WriteEndElement() ' AbstractPlainText

            writer.WriteElementString("DateCreated", mResource.DateCreated.ToString())
            writer.WriteElementString("DateModified", mResource.DateModified.ToString())

            writer.WriteStartElement("ResourceType")
            writer.WriteAttributeString("Id", mResource.ResourceTypeId.ToString())
            Dim resourceType As ResourceType = resourceType.GetByKey(mResource.ResourceTypeId)
            writer.WriteElementString("Description", resourceType.Description)
            writer.WriteEndElement() ' ResourceType

            Dim categories As New StringCollection() ' An ordered HashSet really!

            For Each question As MemberResourceQuestion In mResource.Questions
                writer.WriteStartElement("Question")
                writer.WriteAttributeString("Id", question.Id.ToString())
                Dim service As ServiceType = services.FindServiceType(question.ServiceTypeId)

                writer.WriteStartElement("ServiceType")
                writer.WriteAttributeString("Id", question.ServiceTypeId.ToString())
                writer.WriteElementString("Description", service.Name)
                writer.WriteEndElement() ' ServiceType
                SaveCategory(categories, service.Name)

                writer.WriteStartElement("View")
                writer.WriteAttributeString("Id", question.ViewId.ToString())
                writer.WriteElementString("Description", service.FindView(question.ViewId).Name)
                writer.WriteEndElement() ' View

                writer.WriteStartElement("Theme")
                writer.WriteAttributeString("Id", question.ThemeId.ToString())
                writer.WriteElementString("Description", service.FindTheme(question.ThemeId).Name)
                writer.WriteEndElement() ' Theme
                SaveCategory(categories, service.FindTheme(question.ThemeId).Name)

                writer.WriteStartElement("QuestionContent")
                writer.WriteAttributeString("Id", question.QuestionId.ToString())
                writer.WriteElementString("Description", QuestionContent.GetByQuestionId(question.QuestionId).QuestionText)
                writer.WriteEndElement() ' QuestionContent

                writer.WriteEndElement() ' Question
            Next

            For Each tag As MemberResourceOtherType In mResource.OtherTypes
                writer.WriteStartElement("OtherType")
                writer.WriteAttributeString("Id", tag.OtherTypeId.ToString())
                writer.WriteElementString("Description", tag.Description)
                writer.WriteEndElement() ' Tag
                SaveCategory(categories, tag.Description)
            Next

            For Each value As String In categories
                writer.WriteStartElement("Category")
                writer.WriteElementString("Description", value)
                writer.WriteEndElement() ' Tag

            Next
            writer.WriteEndElement() ' MemberResource
            writer.WriteEndDocument()
        End Using
        Return XmlReader.Create(New StringReader(output.ToString()))
    End Function

    Private Sub SaveCategory(ByVal hashSet As StringCollection, ByVal value As String)
        If Not hashSet.Contains(value) Then
            hashSet.Add(value)
        End If
    End Sub

End Class
