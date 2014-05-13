Imports Nrc.NRCAuthLib
Imports System.Net.Mail
Imports System.Collections.Generic
Imports System.IO
Imports System.Text

Public Class MassEmailSection

    Private mNavigator As OrgUnitNavigator
    Private mImagePaths As Dictionary(Of String, Boolean) 'indicates if the image has already been saved to the repository
    Private mMailServer As SmtpClient
    Private mDefaultFromAddress As String
    Private mDefaultTemplatePath As String
    Private mImageFileRepository As String
    Private ReadOnly Property IsHTML() As Boolean
        Get
            Return rbHTML.Checked
        End Get
    End Property
    Private ReadOnly Property FromEmail() As String
        Get
            If rbFromCurrentUser.Checked Then
                Return CurrentUser.Member.EmailAddress
            Else
                Return DefaultFromAddress
            End If
        End Get
    End Property
    Private ReadOnly Property DefaultFromAddress() As String
        Get
            If mDefaultFromAddress = String.Empty Then
                mDefaultFromAddress = Config.MassEmailDefaultFromAddress
            End If
            Return mDefaultFromAddress
        End Get
    End Property
    Private ReadOnly Property DefaultTemplatePath() As String
        Get
            If mDefaultTemplatePath = String.Empty Then
                mDefaultTemplatePath = Config.MassEmailDefaultTemplatePath
            End If
            Return mDefaultTemplatePath
        End Get
    End Property
    Private ReadOnly Property ImageFileRepository() As String
        Get
            If mImageFileRepository = String.Empty Then
                mImageFileRepository = Config.MassEmailImageRepository
            End If
            Return mImageFileRepository
        End Get
    End Property

#Region "Event Handlers"
    Private Sub MassEmailSection_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        mMailServer = New SmtpClient(Config.SmtpServer)
        mImagePaths = New Dictionary(Of String, Boolean)
        InitUI()

        AddHandler mNavigator.SelectedOrgUnitChanged, AddressOf OrgUnitChanged
        AddHandler grdGroup.SelectionChanged, AddressOf GroupChanged
        AddHandler HTMLBody.OnImageImbed, AddressOf ImbedImage
    End Sub
    Private Sub btnSendTest_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnSendTest.Click
        mMailServer.Send(CreateEmailMessage(CurrentUser.Member))
        MessageBox.Show("E-mail sent to " + CurrentUser.Member.EmailAddress, "E-mail sent", MessageBoxButtons.OK)
    End Sub
    Private Sub btnSend_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnSend.Click
        If ConfirmSend() Then
            SendToSelectedMembers()
        End If
    End Sub
    Private Sub btnLoadTemplate_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnLoadTemplate.Click
        LoadTemplate()
    End Sub
    Private Sub btnSaveTemplate_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnSaveTemplate.Click
        SaveTemplate()
    End Sub
    Private Sub OrgUnitChanged(ByVal sender As Object, ByVal args As OrgUnitNavigator.SelectedOrgUnitChangedEventArgs)
        LoadGrids(args.OrgUnit)
    End Sub
    Private Sub GroupChanged(ByVal sender As Object, ByVal args As EventArgs)
        If grdGroup.SelectedGroups.Count < 2 Then
            GrdMember.ClearSelection()
        End If
        If grdGroup.SelectedGroups.Count > 0 Then
            SelectMembersForGroups(grdGroup.SelectedGroups)
        End If
    End Sub
    Private Sub BodyFormatChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles rbPlainText.CheckedChanged, rbHTML.CheckedChanged
        HTMLBody.Visible = IsHTML
        txtBody.Visible = Not IsHTML
        gbTemplate.Enabled = IsHTML
    End Sub
    Private Sub imgHelp_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles imgHelp.Click
        MessageBox.Show(String.Format("E-mail can be composed in either HTML or plain text.  HTML e-mail can have pictures and links, as well as be saved as a template.{0}{0}Both types of e-mail will substitute the tag ""[username]"" for the recipient's username.", Environment.NewLine), _
            "Mass E-Mail Help", _
            MessageBoxButtons.OK, _
            MessageBoxIcon.Question)
    End Sub
    Private Sub ImbedImage(ByVal ImagePath As String)
        ImbedImage(ImagePath, False)
    End Sub
    Private Sub ImbedImage(ByVal ImagePath As String, ByVal FromRepository As Boolean)
        If Not mImagePaths.ContainsKey(ImagePath) Then
            mImagePaths.Add(ImagePath, FromRepository)
        End If
    End Sub
#End Region

#Region "Base Overrides"
    Public Overrides Sub ActivateSection()
        MyBase.ActivateSection()
        mNavigator.ShowGroupSelector = False
        'this getting of units is because the group and member lists from the navigator
        'don't refresh if they have already been loaded
        'so if a new user or group is added, it won't show up unless we refresh those lists
        LoadGrids(OrgUnit.GetOrgUnit(mNavigator.SelectedOrgUnit.OrgUnitId))
        ToolTip1.SetToolTip(btnSendTest, "Send example e-mail to " & CurrentUser.Member.EmailAddress)
        ToolTip1.SetToolTip(btnSend, "Send to selected clients")
    End Sub

    Public Overrides Sub RegisterNavControl(ByVal navCtrl As Navigator)
        MyBase.RegisterNavControl(navCtrl)
        Me.mNavigator = TryCast(navCtrl, OrgUnitNavigator)
        If Me.mNavigator Is Nothing Then
            Throw New Exception("The MassEmailSection control expects a Navigation control of type OrgUnitNavigator.")
        End If
    End Sub
#End Region

    Private Sub InitUI()
        rbFromDefault.Text = DefaultFromAddress
        rbFromCurrentUser.Text = CurrentUser.Member.EmailAddress
        rbFromCurrentUser.Left = rbFromDefault.Right + 5
        gbFrom.Width = rbFromDefault.Width + rbFromCurrentUser.Width + 20

        If Not (IO.Directory.Exists(DefaultTemplatePath) AndAlso IO.Directory.Exists(ImageFileRepository)) Then
            MessageBox.Show("The template repository does not exist.  To save or load templates, please contact support.", "Repository inaccessable!", MessageBoxButtons.OK, MessageBoxIcon.Exclamation)
            gbTemplate.Enabled = False
        End If

    End Sub
    Private Sub LoadGrids(ByVal unit As OrgUnit)
        grdGroup.Populate(unit.Groups)
        GrdMember.Populate(unit.Members)
        grdGroup.ClearSelection()
        GrdMember.ClearSelection()
    End Sub
    Private Sub SelectMembersForGroups(ByVal grps As GroupCollection)
        For Each g As Group In grps
            For Each m As Member In MemberCollection.GetGroupMembers(g.GroupId)
                GrdMember.SelectMember(m)
            Next
        Next
    End Sub

    Private Function ConfirmSend() As Boolean
        Dim confirm As New MassEmailConfirmation(GrdMember.SelectedMembers.Count())
        confirm.StartPosition = FormStartPosition.CenterScreen
        If confirm.ShowDialog() = DialogResult.OK Then
            SendToSelectedMembers()
        End If
    End Function
    Private Sub SendToSelectedMembers()
        'TODO: log sending
        For Each m As Member In GrdMember.SelectedMembers
            mMailServer.Send(CreateEmailMessage(m))
        Next
        For Each ccm As Member In Config.MassEmailCCMembers
            mMailServer.Send(CreateEmailMessage(ccm))
        Next
    End Sub
    Private Function CreateEmailMessage(ByVal Recipient As Member) As MailMessage
        Dim message As New MailMessage(FromEmail, Recipient.EmailAddress)
        message.IsBodyHtml = IsHTML
        message.Subject = txtSubject.Text
        If IsHTML Then
            Dim HTML As String = ConvertImagePathsToTags(HTMLBody.BodyHtml)
            HTML = HTML.Replace("[username]", Recipient.UserName) 'this should be replaced with a more robust tag system
            message.AlternateViews.Add(GetAlternateViewWithImages(HTML))
        Else
            message.Body = txtBody.Text.Replace("[username]", Recipient.UserName) 'this should be replaced with a more robust tag system
        End If
        Return message
    End Function
    Private Function ConvertImagePathsToTags(ByVal HTML As String) As String
        If HTML Is Nothing Then
            Return String.Empty
        End If

        Dim result As String = HTML
        Dim ResourcesToRemove As New List(Of String) 'No sense in imbeding images we are not using
        Dim path As String
        Dim i As Integer = 0
        Dim Used As Boolean = False
        For Each ImagePath As String In mImagePaths.Keys
            path = ImagePath
            If result.Contains(ConvertToURI(path)) Then 'the HTML control converts all UNC paths to URIs, so when we need to swap them out, we need to look for the URI.
                result = result.Replace(ConvertToURI(path), "cid:image" + i.ToString())
                Used = True
            End If
            If result.Contains(path) Then
                result = result.Replace(path, "cid:image" + i.ToString())
                Used = True
            End If
            If Not Used Then
                ResourcesToRemove.Add(path)
            End If
            i = i + 1
            Used = False
        Next
        For Each s As String In ResourcesToRemove
            mImagePaths.Remove(s)
        Next
        Return result
    End Function
    Private Function GetAlternateViewWithImages(ByVal HTML As String) As AlternateView
        Dim HTMLAltView As AlternateView = AlternateView.CreateAlternateViewFromString(HTML, New System.Net.Mime.ContentType("text/html"))
        Dim i As Integer = 0
        For Each imgPath As String In mImagePaths.Keys
            Dim R As New LinkedResource(imgPath)
            R.ContentId = "image" + i.ToString()
            HTMLAltView.LinkedResources.Add(R)
            i = i + 1
        Next
        Return HTMLAltView
    End Function
    Private Sub LoadTemplate()
        Dim LoadPath As String = GetLoadTemplatePath()
        If LoadPath = String.Empty Then
            Exit Sub
        End If

        Dim TemplateText As String = File.ReadAllText(LoadPath)
        mImagePaths.Clear()

        txtSubject.Text = parseTag(TemplateText, "EmailSubject")
        Dim EmailBody As String = parseTag(TemplateText, "EmailBody")

        If TemplateText.Contains("<Images>") Then
            Dim i As Int32 = 0
            Dim ImagePath As String = parseTag(TemplateText, "Image" + i.ToString())
            While Not ImagePath = String.Empty
                ImagePath = ImageFileRepository + ImagePath
                ImbedImage(ImagePath, True)
                EmailBody = EmailBody.Replace("img" + i.ToString(), ImagePath)
                i = i + 1
                ImagePath = parseTag(TemplateText, "Image" + i.ToString())
            End While
        End If
        HTMLBody.BodyHtml = EmailBody
    End Sub
    Private Sub SaveTemplate() 'this storage belongs in the database.  Original plan was to imbed images in the template files, thus having an "all inclusive" package.  
        Dim SavePath As String = GetSaveTemplatePath()
        If SavePath = String.Empty Then
            Exit Sub
        End If
        Dim TemplateText As New StringBuilder()
        Dim BodyText As String
        If IsHTML Then
            BodyText = HTMLBody.BodyHtml
            If mImagePaths.Count > 0 Then
                TemplateText.Append("<Images>")
                Dim imgtag As String
                Dim RepositoryFileName As String
                Dim i As Int32 = 0
                For Each img As String In mImagePaths.Keys
                    imgtag = "<Image" + i.ToString() + ">"
                    TemplateText.Append(imgtag)
                    If Not mImagePaths(img) Then
                        RepositoryFileName = Path.GetRandomFileName()
                        File.Copy(img, ImageFileRepository + RepositoryFileName)
                    Else
                        RepositoryFileName = img
                    End If
                    BodyText = BodyText.Replace(img, "img" + i.ToString())
                    TemplateText.Append(RepositoryFileName)
                    TemplateText.Append(imgtag.Replace("<", "</"))
                    i = i + 1
                Next
                TemplateText.Append("</Images>")
            End If
        Else
            BodyText = HTMLBody.BodyText
        End If

        TemplateText.Append("<EmailSubject>")
        TemplateText.Append(txtSubject.Text)
        TemplateText.Append("</EmailSubject>")
        TemplateText.Append("<EmailBody>")
        TemplateText.Append(BodyText)
        TemplateText.Append("</EmailBody>")
        File.WriteAllText(SavePath, TemplateText.ToString())
    End Sub
    Public Function ConvertToURI(ByVal UNCPath As String) As String
        Dim UriPath As Uri = New Uri(UNCPath)
        Return UriPath.ToString().Replace(" ", "%20")
    End Function
    Private Function parseTag(ByVal Source As String, ByVal Tag As String) As String
        Dim TagIndex As Int32 = Source.IndexOf("<" + Tag + ">") + Tag.Length + 2
        Dim TagEndIndex As Int32 = Source.IndexOf("</" + Tag + ">")
        If TagIndex >= 0 AndAlso TagEndIndex > TagIndex Then
            Return Source.Substring(TagIndex, TagEndIndex - TagIndex)
        Else
            Return String.Empty
        End If
    End Function
    Private Function GetSaveTemplatePath() As String
        Dim dlg As New SaveFileDialog()
        dlg.AddExtension = True
        dlg.Filter = "Mass E-Mail Template .met|*.met"
        dlg.DefaultExt = "Mass E-Mail Template .met|*.met"
        dlg.Title = "Save Template"
        dlg.InitialDirectory = DefaultTemplatePath
        dlg.ShowDialog()
        If (Not dlg.FileName Is Nothing) Then
            Return dlg.FileName
        Else
            Return String.Empty
        End If
    End Function
    Private Function GetLoadTemplatePath() As String
        Dim dlg As New OpenFileDialog()
        dlg.Filter = "Mass E-Mail Template; *.met|*.met"
        dlg.DefaultExt = "Mass E-Mail Template; *.met|*.met"
        dlg.Title = "Choose an e-mail template"
        dlg.InitialDirectory = DefaultTemplatePath
        If dlg.ShowDialog() = DialogResult.OK Then
            If (Not dlg.FileName Is Nothing) AndAlso (File.Exists(dlg.FileName)) Then
                Return dlg.FileName
            Else
                Return String.Empty
            End If
        Else
            Return String.Empty
        End If
    End Function
End Class
