Imports Nrc.DataMart.MySolutions.Library
Imports Nrc.NRCAuthLib
Imports System.IO

Partial Public Class eToolKit_Admin_ResourceManager
    Inherits ToolKitPage

    Protected Overrides ReadOnly Property LogPageRequest() As Boolean
        Get
            Return False
        End Get
    End Property

    Private _user As Member

    Private Enum Mode
        EditMode = 0
        AddMode = 1
        NewResourceType = 2
        NewOtherType = 3
    End Enum

    ''' <summary>
    ''' Enumerates valid values representing available tabs.
    ''' </summary>
    ''' <remarks>
    '''   <para>
    '''   Rick Christenham (09/06/2007): NRC eToolkit Enhancement II
    '''   </para> 
    ''' </remarks>
    Private Enum TabIndex
        Resource = 0
        MapQuestions = 1
        MapClients = 2
    End Enum

    ''' <summary>
    ''' Flag indicating whether or not to show the OrgUnit TreeView based on the user's permissions.
    ''' </summary>
    ''' <returns>Boolean</returns>
    ''' <remarks>
    '''   <para>
    '''   Rick Christenham (09/06/2007): NRC eToolkit Enhancement II: 
    '''                                  Adapted from NRCAuthLib.
    '''   </para>
    ''' </remarks>
    Private ReadOnly Property ShowOrgUnitTree() As Boolean
        Get
            If (_user.MemberType = Member.MemberTypeEnum.NRC_Admin OrElse _user.MemberType = Member.MemberTypeEnum.Administrator OrElse _user.MemberType = Member.MemberTypeEnum.Super_User) AndAlso _user.OrgUnit.HasChildren Then
                Return True
            Else
                Return False
            End If
        End Get
    End Property

    Private Property ResourceMode() As Mode
        Get
            If ViewState("ResourceMode") Is Nothing Then
                ViewState("ResourceMode") = Mode.AddMode
            End If
            Return CType(ViewState("ResourceMode"), Mode)
        End Get
        Set(ByVal Value As Mode)
            ViewState("ResourceMode") = Value
        End Set
    End Property

    Private ReadOnly Property ResourceKey() As Integer
        Get
            If Context.Items("ResourceKey") Is Nothing Then Return 0
            Return CInt(Context.Items("ResourceKey"))
        End Get
    End Property

    Private Property ResourceMemberKey() As Integer
        Get
            If ViewState("ResourceMemberKey") Is Nothing Then Return 0
            Return CInt(ViewState("ResourceMemberKey"))
        End Get
        Set(ByVal value As Integer)
            ViewState("ResourceMemberKey") = value
        End Set
    End Property

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        '   Rick Christenham (09/07/2007):  NRC eToolkit Enhancement II:
        '                                   Set the user object.
        If _user Is Nothing Then
            _user = Member.GetMember(Page.User.Identity.Name)
        End If

        If Not Page.IsPostBack Then
            If ResourceKey = 0 Then
                ResourceMode = Mode.AddMode
                PopulateForm()
            Else
                ResourceMode = Mode.EditMode
                ResourceMemberKey = ResourceKey
                PopulateContent()
            End If
            Me.FileUploadRequired.Enabled = (Me.ResourceMode = Mode.AddMode)
            Me.TitleCustomValidator.Enabled = (Me.ResourceMode = Mode.AddMode)
            '   Rick Christenham (09/06/2007):  NRC eToolkit Enhancement II:
            '                                   Show the initial tab.
            If Me.MultiViewContent.ActiveViewIndex = -1 Then
                FormatTabButtons(TabIndex.Resource)
            End If
        End If
    End Sub

    Protected Sub PopulateContent()
        Dim resource As MemberResource = MemberResource.GetMemberResource(ResourceMemberKey)
        Dim i, j As Integer
        Dim vpath As String
        'Dim themePath As String
        Dim theNode As TreeNode

        PopulateForm()

        If Not resource Is Nothing Then
            Me.Teaser.Text = resource.AbstractHtml
            Dim plaintext As String = resource.AbstractPlainText
            Me.TitleTextBox.Text = resource.Title
            Me.AuthorTextBox.Text = resource.Author

            Me.DatePostedTextBox.Text = resource.DateCreated.ToString()
            Me.DateUpdatedTextBox.Text = resource.DateModified.ToString()

            Me.TypeRadioButtonList.SelectedValue = resource.ResourceTypeId.ToString()

            Me.ViewCurrentFile.NavigateUrl = ResourceManager.GetMemberResourcePath(Me, resource.Id)

            Dim tags As MemberResourceOtherTypeCollection = resource.OtherTypes()
            Dim questions As MemberResourceQuestionCollection = resource.Questions()

            If tags.Count > 0 Then
                For i = 0 To tags.Count - 1
                    For j = 0 To Me.OtherCheckBoxList.Items.Count - 1
                        If Me.OtherCheckBoxList.Items(j).Value = tags.Item(i).OtherTypeId.ToString() Then
                            Me.OtherCheckBoxList.Items(j).Selected = True
                        End If
                    Next
                Next
            End If

            If questions.Count > 0 Then
                For i = 0 To questions.Count - 1
                    vpath = "0/" + questions.Item(i).ServiceTypeId.ToString() + "/" + questions.Item(i).ViewId.ToString() + "/" + questions.Item(i).ThemeId.ToString() + "/" + questions.Item(i).QuestionId.ToString()
                    theNode = TagsTreeView.FindNode(vpath)
                    theNode.Checked = True
                    Dim parent As TreeNode = theNode.Parent
                    Do Until parent Is Nothing
                        parent.Expand()
                        parent = parent.Parent
                    Loop
                Next
            End If

            '   Rick Christenham (09/11/2007):  NRC eToolkit Enhancement II:
            '                                   Update map client group checkboxes
            UpdateClientGroupCheckboxes(resource)

            '   Rick Christenham (09/11/2007):  NRC eToolkit Enhancement II:
            '                                   Commented out following code since replacing
            '                                   parent checkboxes with different methodology.
            ''If all questions for the theme have been checked, uncheck the questions and check the theme
            'Dim saveThemePath As String = ""
            'Dim allChecked As Boolean
            'If questions.Count > 0 Then
            '    For i = 0 To questions.Count - 1
            '        themePath = "0/" + questions.Item(i).ServiceTypeId.ToString() + "/" + questions.Item(i).ViewId.ToString() + "/" + questions.Item(i).ThemeId.ToString()
            '        If themePath <> saveThemePath Then
            '            saveThemePath = themePath
            '            allChecked = True
            '            theNode = TagsTreeView.FindNode(themePath)
            '            For j = 0 To theNode.ChildNodes.Count - 1
            '                If Not theNode.ChildNodes.Item(j).Checked Then
            '                    allChecked = False
            '                End If
            '            Next
            '            If allChecked Then
            '                'For j = 0 To theNode.ChildNodes.Count - 1
            '                '    theNode.ChildNodes.Item(j).Checked = False
            '                'Next
            '                theNode.Checked = True
            '            End If
            '        End If
            '    Next
            'End If
            If Not String.IsNullOrEmpty(resource.OriginalPath) Then
                Dim original As FileInfo = New FileInfo(resource.OriginalPath)
                lblOriginalFile.ToolTip = resource.OriginalPath
                lblOriginalFile.Text += original.Name
                Dim current As FileInfo = New FileInfo(resource.FilePath)
                lblCurrentFile.ToolTip = resource.FilePath
                lblCurrentFile.Text += current.Name
            End If
        End If
    End Sub

    Protected Sub PopulateForm()
        Me.InitModelTree()
        Me.InitResourceType()
        Me.InitResourceOtherType()
        If ShowOrgUnitTree Then
            BuildOrgUnitTree()
        End If
        NewTypeTextBox.Enabled = False
        NewTypeTextBox.Visible = False
        lblNewTypeTextBox.Enabled = False
        lblNewTypeTextBox.Visible = False
        ASCheckBox.Enabled = False
        ASCheckBox.Visible = False
        TypeButton.Enabled = False
        TypeButton.Visible = False
        CancelNewResourceBtn.Enabled = False
        CancelNewResourceBtn.Visible = False
        NewOtherTextBox.Enabled = False
        NewOtherTextBox.Visible = False
        lblNewOtherTextBox.Visible = False
        lblNewOtherTextBox.Enabled = False
        OtherButton.Enabled = False
        OtherButton.Visible = False
        CancelOtherButton.Enabled = False
        CancelOtherButton.Visible = False
        TypeNameFVal.Enabled = False
        OtherFVal.Enabled = False
    End Sub

    Protected Sub InitModelTree()
        Dim shortQuestion As String

        Dim serviceTypes As ServiceTypeCollection = ServiceType.GetAll
        Me.TagsTreeView.Nodes.Clear()

        Dim root As New TreeNode("Improvement Model", "0")

        Me.TagsTreeView.Nodes.Add(root)

        '   Rick Christenham (09/06/2007):  NRC eToolkit Enhancement II:
        '                                   1) Modified select action to select and expand the node.
        '                                   2) Enabled select action only on those nodes with children.
        '                                   3) Added folder icons to represent OrgUnits.
        root.ImageUrl = "~/img/MemberList.gif"
        root.SelectAction = TreeNodeSelectAction.Select
        For Each st As ServiceType In serviceTypes
            Dim serviceNode As New TreeNode(st.Name, st.Id.ToString)
            serviceNode.ImageUrl = "~/img/MemberList.gif"
            serviceNode.SelectAction = CType(IIf(st.Views.Count = 0, TreeNodeSelectAction.None, TreeNodeSelectAction.Select), TreeNodeSelectAction)
            root.ChildNodes.Add(serviceNode)
            For Each v As View In st.Views
                Dim viewNode As New TreeNode(v.Name, v.Id.ToString)
                viewNode.ImageUrl = "~/img/MemberList.gif"
                viewNode.SelectAction = CType(IIf(v.Themes.Count = 0, TreeNodeSelectAction.None, TreeNodeSelectAction.Select), TreeNodeSelectAction)
                serviceNode.ChildNodes.Add(viewNode)
                For Each t As Theme In v.Themes
                    Dim themeNode As New TreeNode(t.Name, t.Id.ToString)
                    Dim themeQuestionCollection As ThemeQuestionCollection = ThemeQuestion.GetByThemeId(t.Id)
                    themeNode.ImageUrl = "~/img/MemberList.gif"
                    themeNode.SelectAction = CType(IIf(themeQuestionCollection.Count = 0, TreeNodeSelectAction.None, TreeNodeSelectAction.Select), TreeNodeSelectAction)
                    viewNode.ChildNodes.Add(themeNode)
                    For Each q As ThemeQuestion In themeQuestionCollection
                        shortQuestion = EllipsisText(q.QuestionText, 90)
                        Dim questionNode As New TreeNode(shortQuestion, q.QuestionId.ToString())
                        questionNode.SelectAction = TreeNodeSelectAction.None
                        questionNode.ShowCheckBox = True
                        themeNode.ChildNodes.Add(questionNode)
                        questionNode.ToolTip = q.QuestionText
                    Next
                Next
            Next
        Next
        root.Expand()

    End Sub

    ''' <summary>
    ''' Builds the OrgUnit TreeView based on the current user's permissions.
    ''' </summary>
    ''' <remarks>
    '''   <para>
    '''   Rick Christenham (09/06/2007): NRC eToolkit Enhancement II:
    '''                                  Adapted from NRCAuthLib.
    '''   </para> 
    ''' </remarks>
    Private Sub BuildOrgUnitTree()
        Me.TreeViewOrgUnits.Nodes.Clear()

        Dim ou As OrgUnit = _user.OrgUnit
        Dim root As New TreeNode(ou.Name, ou.OrgUnitId.ToString())
        root.ImageUrl = "~/img/MemberList.gif"

        If ou.HasChildren OrElse ou.Groups.Count > 0 Then
            root.SelectAction = TreeNodeSelectAction.Select
            PopulateTree(root, ou)
        Else
            root.SelectAction = TreeNodeSelectAction.None
        End If

        root.ExpandAll()
        Me.TreeViewOrgUnits.Nodes.Add(root)
    End Sub

    ''' <summary>
    ''' Recursive method used to populate a node and its children.
    ''' </summary>
    ''' <param name="root">Starting <see cref="System.Web.UI.WebControls.TreeNode">node</see></param>
    ''' <param name="orgUnit"><see cref="NRCAuthLib.OrgUnit">OrgUnit </see> object</param>
    ''' <remarks>
    '''   <para>
    '''   Rick Christenham (09/06/2007): NRC eToolkit Enhancement II:
    '''                                  Adapted from NRCAuthLib.
    '''   </para>
    ''' </remarks>
    Private Sub PopulateTree(ByVal root As TreeNode, ByVal orgUnit As OrgUnit)
        For Each group As Group In orgUnit.Groups
            Dim node As TreeNode = New TreeNode()
            If Not group.Description Is Nothing AndAlso Not group.Description = "" Then
                node.Text = String.Format("{0} - {1}", group.Name, group.Description)
            Else
                node.Text = group.Name
            End If
            node.Value = group.GroupId.ToString()
            node.SelectAction = TreeNodeSelectAction.None
            node.ShowCheckBox = True
            node.Checked = True

            root.ChildNodes.Add(node)
        Next

        For Each ou As OrgUnit In orgUnit.OrgUnits
            Dim node As TreeNode = New TreeNode(ou.Name, ou.OrgUnitId.ToString)
            node.ImageUrl = "~/img/MemberList.gif"

            If ou.HasChildren OrElse ou.Groups.Count > 0 Then
                node.SelectAction = TreeNodeSelectAction.Select
                PopulateTree(node, ou)
            Else
                node.SelectAction = TreeNodeSelectAction.None
            End If

            root.ChildNodes.Add(node)
        Next
    End Sub

    Private Function EllipsisText(ByVal text As String, ByVal length As Integer) As String
        If text.Length > length Then
            Return text.Substring(0, length) + "..."
        Else
            Return text
        End If
    End Function

    Protected Sub InitResourceType()
        Me.TypeRadioButtonList.DataSource = ResourceType.GetAll
        Me.TypeRadioButtonList.DataBind()
    End Sub

    Protected Sub InitResourceOtherType()
        Me.OtherCheckBoxList.DataSource = ResourceOtherType.GetAll
        Me.OtherCheckBoxList.DataBind()
    End Sub

    Protected Sub btnSave_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnSave.Click
        If Not IsValid Then Return

        Dim question As MemberResourceQuestion
        Dim questionExists As MemberResourceQuestion = Nothing
        Dim mrQuestions As MemberResourceQuestionCollection
        Dim tag As MemberResourceOtherType
        Dim tagexists As MemberResourceOtherType = Nothing
        Dim tags As MemberResourceOtherTypeCollection
        Dim serviceTypeId As Integer
        Dim viewId As Integer
        Dim themeId As Integer
        Dim questionId As Integer
        Dim questions As Integer
        Dim i As Integer
        Dim vpath As String
        Dim themePath As String
        Dim theNode As TreeNode
        Dim themeNode As TreeNode

        Dim resource As MemberResource
        Dim type As ResourceType = ResourceType.GetByKey(CInt(Me.TypeRadioButtonList.SelectedValue))


        If ResourceMode = Mode.AddMode Then
            resource = MemberResource.NewMemberResource()
        Else
            resource = MemberResource.GetMemberResource(ResourceMemberKey)
        End If

        If (FileUpload.HasFile) Then
            Dim fileName As String
            If String.IsNullOrEmpty(resource.FilePath) Then
                fileName = Guid.NewGuid().ToString()
            Else
                fileName = resource.FilePath
            End If
            Dim previousName As String = fileName
            fileName = Path.ChangeExtension(fileName, Path.GetExtension(FileUpload.FileName))
            Dim filePath As String = Path.Combine(Config.MemberResourcePath, fileName)
            Dim previousPath As String = Path.Combine(Config.MemberResourcePath, previousName)
            resource.OriginalPath = FileUpload.PostedFile.FileName ' Want the full path!
            resource.FilePath = fileName
            FileUpload.SaveAs(filePath)
            If Not String.Equals(previousName, fileName) AndAlso File.Exists(previousPath) Then
                File.Delete(previousPath)
            End If
        End If

        resource.Title = TitleTextBox.Text
        resource.Author = AuthorTextBox.Text
        resource.AbstractHtml = Me.Teaser.Xhtml
        resource.AbstractPlainText = Me.Teaser.HtmlStrippedText
        resource.ResourceTypeId = type.Id

        mrQuestions = resource.Questions()
        tags = resource.OtherTypes()

        ''Go through OtherCheckBoxList and add new Member Resource Other Types
        For i = 0 To Me.OtherCheckBoxList.Items.Count - 1
            If Me.OtherCheckBoxList.Items(i).Selected Then
                If ResourceMode = Mode.EditMode Then
                    tagexists = tags.Find(CInt(Me.OtherCheckBoxList.Items(i).Value))
                End If
                If tagexists Is Nothing Then
                    tag = MemberResourceOtherType.NewMemberResourceOtherType(CInt(Me.OtherCheckBoxList.Items(i).Value))
                    resource.OtherTypes.Add(tag)
                End If
            End If
        Next

        ''Go through Member Resource Other Types and remove those unchecked
        If ResourceMode = Mode.EditMode Then
            For i = 0 To Me.OtherCheckBoxList.Items.Count - 1
                If Me.OtherCheckBoxList.Items(i).Selected = False Then
                    tagexists = tags.Find(CInt(Me.OtherCheckBoxList.Items(i).Value))
                    If Not tagexists Is Nothing Then
                        resource.OtherTypes.Remove(tagexists)
                    End If
                End If
            Next
        End If

        ''Go through the Question TreeNode and add new Member Resouce Questions that have been checked
        For Each node As TreeNode In Me.TagsTreeView.CheckedNodes
            If node.Checked Then
                If node.ChildNodes.Count > 0 Then
                    questions = node.ChildNodes.Count
                    For i = 0 To (questions - 1)
                        If Not node.ChildNodes.Item(i).Checked Then
                            If node.ChildNodes.Item(i).ToolTip.Length > 0 Then
                                questionId = CInt(node.ChildNodes.Item(i).Value)
                                themeId = CInt(node.ChildNodes.Item(i).Parent.Value)
                                viewId = CInt(node.ChildNodes.Item(i).Parent.Parent.Value)
                                serviceTypeId = CInt(node.ChildNodes.Item(i).Parent.Parent.Parent.Value)
                                If ResourceMode = Mode.EditMode Then
                                    questionExists = mrQuestions.Find(serviceTypeId, viewId, themeId, questionId)
                                End If
                                If questionExists Is Nothing Then
                                    question = MemberResourceQuestion.NewMemberResourceQuestion(serviceTypeId, viewId, themeId, questionId)
                                    resource.Questions.Add(question)
                                End If
                            End If
                        End If
                    Next
                Else
                    If node.ToolTip.Length > 0 Then
                        questionId = CInt(node.Value)
                        themeId = CInt(node.Parent.Value)
                        viewId = CInt(node.Parent.Parent.Value)
                        serviceTypeId = CInt(node.Parent.Parent.Parent.Value)
                        If ResourceMode = Mode.EditMode Then
                            questionExists = mrQuestions.Find(serviceTypeId, viewId, themeId, questionId)
                        End If
                        If questionExists Is Nothing Then
                            question = MemberResourceQuestion.NewMemberResourceQuestion(serviceTypeId, viewId, themeId, questionId)
                            resource.Questions.Add(question)
                        End If
                    End If
                End If
            End If
        Next

        ''Go through the Member Resource Questions and remove those that have been unchecked
        If ResourceMode = Mode.EditMode Then
            For i = (mrQuestions.Count - 1) To 0 Step -1
                themePath = "0/" + mrQuestions.Item(i).ServiceTypeId.ToString() + "/" + mrQuestions.Item(i).ViewId.ToString() + "/" + mrQuestions.Item(i).ThemeId.ToString()
                themeNode = TagsTreeView.FindNode(themePath)
                vpath = "0/" + mrQuestions.Item(i).ServiceTypeId.ToString() + "/" + mrQuestions.Item(i).ViewId.ToString() + "/" + mrQuestions.Item(i).ThemeId.ToString() + "/" + mrQuestions.Item(i).QuestionId.ToString()
                theNode = TagsTreeView.FindNode(vpath)
                If Not theNode.Checked And Not themeNode.Checked Then
                    question = mrQuestions.Item(i)
                    resource.Questions.Remove(question)
                End If
            Next
        End If

        '   Go through Member Resource Groups and add new Member Resource Groups that have 
        '   been checked, and remove those that have been unchecked:
        For Each root As TreeNode In Me.TreeViewOrgUnits.Nodes
            UpdateGroupRecords(root, resource)
        Next

        resource.Save()
        ResourceMemberKey = resource.Id

        If Not String.IsNullOrEmpty(resource.OriginalPath) Then
            Dim original As FileInfo = New FileInfo(resource.OriginalPath)
            lblOriginalFile.ToolTip = resource.OriginalPath
            lblOriginalFile.Text = original.Name
            Dim current As FileInfo = New FileInfo(resource.FilePath)
            lblCurrentFile.ToolTip = resource.FilePath
            lblCurrentFile.Text = current.Name
            Me.ViewCurrentFile.NavigateUrl = ResourceManager.GetMemberResourcePath(Me, resource.Id)
        End If

        ResourceMode = Mode.EditMode

        If EmailNotify.Checked Then
            ContentNotification.Notify(resource)
        End If

    End Sub

    Private Sub Page_PreRender(ByVal sender As Object, ByVal e As System.EventArgs) Handles MyBase.PreRender
        btnDelete.Visible = (ResourceMode = Mode.EditMode)
    End Sub

    Protected Sub btnDelete_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnDelete.Click
        Dim resource As MemberResource
        If ResourceMode = Mode.EditMode Then
            resource = MemberResource.GetMemberResource(ResourceMemberKey)
            resource.Delete()
            If Not String.IsNullOrEmpty(resource.FilePath) Then
                File.Delete(Path.Combine(Config.MemberResourcePath, resource.FilePath))
            End If
            resource.Save()
            Server.Transfer("ResourceManagerSelection.aspx")
        End If
    End Sub

    Protected Sub TypeButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles TypeButton.Click
        If Not IsValid Then Return
        Dim rtype As ResourceType = ResourceType.NewResourceType
        rtype.Description = NewTypeTextBox.Text
        rtype.AlwaysShow = ASCheckBox.Checked
        rtype.Save()
        InitMemberResourcePage()
        ReDisplayResourceTypes()
    End Sub

    Protected Sub OtherButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles OtherButton.Click
        If Not IsValid Then Return
        Dim otype As ResourceOtherType = ResourceOtherType.NewResourceOtherType
        otype.Description = NewOtherTextBox.Text
        otype.Save()
        InitMemberResourcePage()
        ReDisplayResourceTypes()
    End Sub

    Protected Sub TypeRadioButtonList_SelectedIndexChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles TypeRadioButtonList.SelectedIndexChanged
    End Sub

    Protected Sub OtherCheckBoxList_SelectedIndexChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles OtherCheckBoxList.SelectedIndexChanged
    End Sub

    Protected Sub NewTypeLinkButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles NewTypeLinkButton.Click
        InitTagsResourcePage()
        NewTypeTextBox.Enabled = True
        NewTypeTextBox.Visible = True
        TypeNameFVal.Enabled = True
        TypeNameFVal.Visible = True
        lblNewTypeTextBox.Enabled = True
        lblNewTypeTextBox.Visible = True
        ASCheckBox.Enabled = True
        ASCheckBox.Visible = True
        TypeButton.Enabled = True
        TypeButton.Visible = True
        CancelNewResourceBtn.Enabled = True
        CancelNewResourceBtn.Visible = True
        NewOtherTextBox.Visible = False
        lblNewOtherTextBox.Visible = False
        lblNewOtherTextBox.Enabled = False
        OtherButton.Enabled = False
        OtherButton.Visible = False
        CancelOtherButton.Enabled = False
        CancelOtherButton.Visible = False
    End Sub

    Protected Sub CancelOtherButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles CancelOtherButton.Click
        InitMemberResourcePage()
    End Sub

    Protected Sub NewOtherLinkButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles NewOtherLinkButton.Click
        InitTagsResourcePage()
        NewOtherTextBox.Enabled = True
        NewOtherTextBox.Visible = True
        OtherFVal.Enabled = True
        OtherFVal.Visible = True
        lblNewOtherTextBox.Visible = True
        lblNewOtherTextBox.Enabled = True
        OtherButton.Enabled = True
        OtherButton.Visible = True
        CancelOtherButton.Enabled = True
        CancelOtherButton.Visible = True
        NewTypeTextBox.Enabled = False
        NewTypeTextBox.Visible = False
        lblNewTypeTextBox.Enabled = False
        lblNewTypeTextBox.Visible = False
        ASCheckBox.Enabled = False
        ASCheckBox.Visible = False
        TypeButton.Enabled = False
        TypeButton.Visible = False
        CancelNewResourceBtn.Enabled = False
        CancelNewResourceBtn.Visible = False
    End Sub

    Protected Sub btnCancel_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnCancel.Click
        Server.Transfer("ResourceManagerSelection.aspx")
    End Sub

    Protected Sub CancelNewResourceBtn_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles CancelNewResourceBtn.Click
        InitMemberResourcePage()
    End Sub

    Protected Sub InitMemberResourcePage()
        Teaser.Visible = True
        FileUpload.Enabled = True
        EmailNotify.Enabled = True
        NewTypeLinkButton.Enabled = True
        NewTypeTextBox.Enabled = False
        NewTypeTextBox.Visible = False
        lblNewTypeTextBox.Enabled = False
        lblNewTypeTextBox.Visible = False
        ASCheckBox.Enabled = False
        ASCheckBox.Visible = False
        TypeButton.Enabled = False
        TypeButton.Visible = False
        CancelNewResourceBtn.Enabled = False
        CancelNewResourceBtn.Visible = False
        TitleTextBox.Enabled = True
        AuthorTextBox.Enabled = True
        TagsTreeView.Enabled = True
        TypeRadioButtonList.Enabled = True
        OtherCheckBoxList.Enabled = True
        OtherButton.Enabled = True
        btnDelete.Enabled = True
        btnSave.Enabled = True
        NewOtherLinkButton.Enabled = True
        NewOtherTextBox.Enabled = False
        NewOtherTextBox.Visible = False
        lblNewOtherTextBox.Visible = False
        lblNewOtherTextBox.Enabled = False
        OtherButton.Enabled = False
        OtherButton.Visible = False
        CancelOtherButton.Enabled = False
        CancelOtherButton.Visible = False
        TypeFVal.Enabled = True
        TypeNameFVal.Enabled = False
        TypeNameFVal.Visible = False
        TitleFVal.Enabled = True
        AuthorFVal.Enabled = True
        OtherFVal.Enabled = False
        OtherFVal.Visible = False
    End Sub

    Protected Sub InitTagsResourcePage()
        Teaser.Visible = False
        FileUpload.Enabled = False
        EmailNotify.Enabled = False
        NewTypeLinkButton.Enabled = False
        TitleTextBox.Enabled = False
        AuthorTextBox.Enabled = False
        TagsTreeView.Enabled = False
        TypeRadioButtonList.Enabled = False
        OtherCheckBoxList.Enabled = False
        OtherButton.Enabled = False
        btnDelete.Enabled = False
        btnSave.Enabled = False
        NewOtherLinkButton.Enabled = False
        NewOtherTextBox.Enabled = False
        TypeFVal.Enabled = False
        TitleFVal.Enabled = False
        AuthorFVal.Enabled = False
    End Sub

    Protected Sub ReDisplayResourceTypes()
        Dim saveOtherTypes As New ListItemCollection
        Dim saveTypes As RadioButtonList = Me.TypeRadioButtonList
        Dim i As Integer

        For i = 0 To Me.OtherCheckBoxList.Items.Count - 1
            If Me.OtherCheckBoxList.Items(i).Selected Then
                saveOtherTypes.Add(Me.OtherCheckBoxList.Items(i))
            End If
        Next

        Dim selectedResourceId As String = ""
        If Not String.IsNullOrEmpty(saveTypes.SelectedValue) Then
            Dim type As ResourceType = ResourceType.GetByKey(CInt(saveTypes.SelectedValue))
            selectedResourceId = type.Id.ToString()
        End If

        Me.InitResourceType()
        If Not String.IsNullOrEmpty(selectedResourceId) Then
            Me.TypeRadioButtonList.SelectedValue = selectedResourceId
        End If

        Me.InitResourceOtherType()
        For Each item As ListItem In saveOtherTypes
            For i = 0 To Me.OtherCheckBoxList.Items.Count - 1
                If item.Value = Me.OtherCheckBoxList.Items(i).Value Then
                    Me.OtherCheckBoxList.Items(i).Selected = True
                End If
            Next
        Next
    End Sub

    Protected Sub TitleCustomValidator_ServerValidate(ByVal source As System.Object, ByVal args As System.Web.UI.WebControls.ServerValidateEventArgs) Handles TitleCustomValidator.ServerValidate
        Dim resource As MemberResource = MemberResource.GetMemberResourceByTitle(args.Value)
        args.IsValid = (resource Is Nothing)
    End Sub

    Protected Sub NewTypeTextBox_ServerValidate(ByVal source As System.Object, ByVal args As System.Web.UI.WebControls.ServerValidateEventArgs) Handles cvNewTypeTextBox.ServerValidate
        Dim type As ResourceType = ResourceType.GetByDescription(args.Value)
        args.IsValid = (type Is Nothing)
    End Sub

    Protected Sub NewOtherTextBox_ServerValidate(ByVal source As System.Object, ByVal args As System.Web.UI.WebControls.ServerValidateEventArgs) Handles cvNewOtherTextBox.ServerValidate
        Dim type As ResourceOtherType = ResourceOtherType.GetByDescription(args.Value)
        args.IsValid = (type Is Nothing)
    End Sub

    ''' <summary>
    ''' Event fired when clicking on the "Resource" button.
    ''' </summary>
    ''' <param name="sender"><see cref="System.Object">System parameter</see></param>
    ''' <param name="e"><see cref="System.EventArgs">System parameter</see></param>
    ''' <remarks>
    '''   <para>
    '''   Rick Christenham (09/06/2007): NRC eToolkit Enhancement II
    '''   </para> 
    ''' </remarks>
    Protected Sub ButtonResource_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ButtonResource.Click
        FormatTabButtons(TabIndex.Resource)
    End Sub

    ''' <summary>
    ''' Event fired when clicking on the "Map Questions" button.
    ''' </summary>
    ''' <param name="sender"><see cref="System.Object">System parameter</see></param>
    ''' <param name="e"><see cref="System.EventArgs">System parameter</see></param>
    ''' <remarks>
    '''   <para>
    '''   Rick Christenham (09/06/2007): NRC eToolkit Enhancement II
    '''   </para> 
    ''' </remarks>
    Protected Sub ButtonMapQuestions_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ButtonMapQuestions.Click
        FormatTabButtons(TabIndex.MapQuestions)
    End Sub

    ''' <summary>
    ''' Event fired when clicking on the "Map Clients" button.
    ''' </summary>
    ''' <param name="sender"><see cref="System.Object">System parameter</see></param>
    ''' <param name="e"><see cref="System.EventArgs">System parameter</see></param>
    ''' <remarks>
    '''   <para>
    '''   Rick Christenham (09/06/2007): NRC eToolkit Enhancement II
    '''   </para> 
    ''' </remarks>
    Protected Sub ButtonMapClients_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ButtonMapClients.Click
        FormatTabButtons(TabIndex.MapClients)
    End Sub

    ''' <summary>
    ''' Formats the tab buttons to visually indicate the currently selected tab. 
    ''' </summary>
    ''' <param name="selectedTab"><see cref="TabIndex">The tab clicked</see></param>
    ''' <remarks>
    '''   <para>
    '''   Rick Christenham (09/06/2007): NRC eToolkit Enhancement II
    '''   </para>  
    ''' </remarks>
    Private Sub FormatTabButtons(ByVal selectedTab As TabIndex)

        Dim currentTab As Integer

        Me.MultiViewContent.ActiveViewIndex = selectedTab
        For currentTab = 0 To 2
            With Me.ButtonResource
                .Font.Bold = Convert.ToBoolean(IIf(selectedTab.Equals(TabIndex.Resource), True, False))
                .BorderStyle = CType(IIf(selectedTab.Equals(TabIndex.Resource), BorderStyle.Inset, BorderStyle.NotSet), BorderStyle)
            End With

            With Me.ButtonMapQuestions
                .Font.Bold = Convert.ToBoolean(IIf(selectedTab.Equals(TabIndex.MapQuestions), True, False))
                .BorderStyle = CType(IIf(selectedTab.Equals(TabIndex.MapQuestions), BorderStyle.Inset, BorderStyle.NotSet), BorderStyle)
            End With

            With Me.ButtonMapClients
                .Font.Bold = Convert.ToBoolean(IIf(selectedTab.Equals(TabIndex.MapClients), True, False))
                .BorderStyle = CType(IIf(selectedTab.Equals(TabIndex.MapClients), BorderStyle.Inset, BorderStyle.NotSet), BorderStyle)
            End With
        Next

    End Sub

    Protected Sub ImageButtonCollapseQuestions_Click(ByVal sender As System.Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ImageButtonCollapseQuestions.Click
        ExpandCollapseChildren(Me.TagsTreeView.SelectedNode, False)
    End Sub

    Protected Sub ImageButtonExpandQuestions_Click(ByVal sender As System.Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ImageButtonExpandQuestions.Click
        ExpandCollapseChildren(Me.TagsTreeView.SelectedNode, True)
    End Sub

    Protected Sub ImageButtonUncheckQuestions_Click(ByVal sender As System.Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ImageButtonUncheckQuestions.Click
        ExpandCollapseChildren(Me.TagsTreeView.SelectedNode, False)
        CheckUncheckChildren(Me.TagsTreeView.SelectedNode, False)
    End Sub

    Protected Sub ImageButtonCheckQuestions_Click(ByVal sender As System.Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ImageButtonCheckQuestions.Click
        ExpandCollapseChildren(Me.TagsTreeView.SelectedNode, True)
        CheckUncheckChildren(Me.TagsTreeView.SelectedNode, True)
    End Sub

    Protected Sub ImageButtonCollapseClients_Click(ByVal sender As System.Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ImageButtonCollapseClients.Click
        ExpandCollapseChildren(Me.TreeViewOrgUnits.SelectedNode, False)
    End Sub

    Protected Sub ImageButtonExpandClients_Click(ByVal sender As System.Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ImageButtonExpandClients.Click
        ExpandCollapseChildren(Me.TreeViewOrgUnits.SelectedNode, True)
    End Sub

    Protected Sub ImageButtonUncheckClients_Click(ByVal sender As System.Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ImageButtonUncheckClients.Click
        ExpandCollapseChildren(Me.TreeViewOrgUnits.SelectedNode, False)
        CheckUncheckChildren(Me.TreeViewOrgUnits.SelectedNode, False)
    End Sub

    Protected Sub ImageButtonCheckClients_Click(ByVal sender As System.Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ImageButtonCheckClients.Click
        ExpandCollapseChildren(Me.TreeViewOrgUnits.SelectedNode, True)
        CheckUncheckChildren(Me.TreeViewOrgUnits.SelectedNode, True)
    End Sub

    Private Sub CheckUncheckChildren(ByVal root As TreeNode, ByVal check As Boolean)

        For Each child As TreeNode In root.ChildNodes
            If Convert.ToBoolean(child.ShowCheckBox) Then
                child.Checked = check
            Else
                CheckUncheckChildren(child, check)
            End If
        Next

    End Sub

    Private Sub ExpandCollapseChildren(ByVal root As TreeNode, ByVal expand As Boolean)
        If expand Then
            root.ExpandAll()
        Else
            root.CollapseAll()
        End If
    End Sub

    Protected Sub TagsTreeView_SelectedNodeChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles TagsTreeView.SelectedNodeChanged
        If Not Me.ImageButtonCollapseQuestions.Enabled Then
            Me.ImageButtonCollapseQuestions.Enabled = True
            Me.ImageButtonExpandQuestions.Enabled = True
            Me.ImageButtonUncheckQuestions.Enabled = True
            Me.ImageButtonCheckQuestions.Enabled = True
        End If
    End Sub

    Protected Sub TreeViewOrgUnits_SelectedNodeChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles TreeViewOrgUnits.SelectedNodeChanged
        If Not Me.ImageButtonCollapseClients.Enabled Then
            Me.ImageButtonCollapseClients.Enabled = True
            Me.ImageButtonExpandClients.Enabled = True
            Me.ImageButtonUncheckClients.Enabled = True
            Me.ImageButtonCheckClients.Enabled = True
        End If
    End Sub

    Private Sub UpdateClientGroupCheckboxes(ByVal resource As MemberResource)
        If Not resource Is Nothing Then
            Dim groups As MemberResourceGroupCollection = resource.Groups()
            For Each root As TreeNode In Me.TreeViewOrgUnits.Nodes
                If UpdateClientGroupChildCheckboxes(root, groups) Then
                    root.Expand()
                Else
                    root.Collapse()
                End If
            Next
        End If
    End Sub

    Private Function UpdateClientGroupChildCheckboxes(ByVal root As TreeNode, _
                                                      ByVal groups As MemberResourceGroupCollection) As Boolean
        Dim anyChecked As Boolean = False

        For Each child As TreeNode In root.ChildNodes
            If Convert.ToBoolean(child.ShowCheckBox) Then
                '   Appears to be a Group node:
                Dim groupId As Integer = Convert.ToInt32(child.Value)

                Dim group As MemberResourceGroup = groups.Find(groupId)
                '   We are storing EXCLUSIONS in the database, not inclusions:
                If group Is Nothing Then
                    child.Checked = True
                    anyChecked = True
                Else
                    child.Checked = False
                End If
            Else
                '   Appears to be an OrgUnit node:
                If UpdateClientGroupChildCheckboxes(child, groups) Then
                    anyChecked = True
                    child.Expand()
                Else
                    child.Collapse()
                End If
            End If
        Next

        Return anyChecked
    End Function

    Private Sub UpdateGroupRecords(ByVal root As TreeNode, _
                                   ByVal resource As MemberResource)

        For Each child As TreeNode In root.ChildNodes
            If Convert.ToBoolean(child.ShowCheckBox) Then
                '   Appears to be a Group node:
                Dim groupId As Integer = Convert.ToInt32(child.Value)
                Dim group As MemberResourceGroup = resource.Groups.Find(groupId)

                '   We are storing EXCLUSIONS in the database, not inclusions:
                If child.Checked Then
                    If Not group Is Nothing Then
                        resource.Groups.Remove(group)
                    End If
                Else
                    If group Is Nothing Then
                        group = MemberResourceGroup.NewMemberResourceGroup(groupId)
                        resource.Groups.Add(group)
                    End If
                End If
            Else
                '   Appears to be an OrgUnit node:
                UpdateGroupRecords(child, resource)
            End If
        Next

    End Sub

End Class