Imports System.Collections.ObjectModel
Imports Nrc.DataMart.MySolutions.Library

Partial Public Class eToolKit_Admin_QuestionManager
    Inherits ToolKitPage

#Region " Private/Protected Properties "
    Protected Overrides ReadOnly Property LogPageRequest() As Boolean
        Get
            Return False
        End Get
    End Property

    Private ReadOnly Property SelectedQuestionId() As Integer
        Get
            If String.IsNullOrEmpty(Request.QueryString("QuestionId")) Then
                Return 0
            Else
                Dim id As Integer = -1
                Integer.TryParse(Request.QueryString("QuestionId"), id)
                Return id
            End If
        End Get
    End Property

    Private Property QuestionContent() As QuestionContent
        Get
            Dim qc As QuestionContent = TryCast(ViewState("QuestionContent"), QuestionContent)
            Return qc
        End Get
        Set(ByVal value As QuestionContent)
            ViewState("QuestionContent") = value
        End Set
    End Property

    Private ReadOnly Property SelectedContentType() As QuestionContentType
        Get
            Select Case Me.ContentTypeMenu.SelectedItem.Value.ToUpper
                Case "IMPORTANCE"
                    Return QuestionContentType.QuestionImportance
                Case "QUICKCHECK"
                    Return QuestionContentType.QuickCheck
                Case "RECOMMENDATIONS"
                    Return QuestionContentType.Recommendations
                Case "RESOURCES"
                    Return QuestionContentType.Resources
                Case Else
                    Return QuestionContentType.None
            End Select
        End Get
    End Property
#End Region

#Region " Page Events "
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Me.ThemeGridErrorLabel.Text = ""
        Me.RelatedGridErrorLabel.Text = ""

        If Not Page.IsPostBack Then
            Me.QuestionId.Focus()
            If Me.SelectedQuestionId <> 0 Then
                Me.InitQuestionContent()

                If Me.QuestionContent IsNot Nothing Then
                    Me.InitModelTree()
                    Me.BindThemeGrid()
                    Me.BindRelatedQuestionsGrid()
                    Me.BindQuestionContent()
                End If
            End If
        End If
    End Sub

    Private Sub Page_PreRender(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.PreRender
        Me.InitCheckBoxJavascript()
    End Sub

#End Region

#Region " Page Initialization "
    Private Sub InitModelTree()
        Dim serviceTypes As ServiceTypeCollection = ServiceType.GetAll
        Me.ModelTreeView.Nodes.Clear()

        For Each st As ServiceType In serviceTypes
            Dim serviceNode As New TreeNode(st.Name, st.Id.ToString)
            serviceNode.SelectAction = TreeNodeSelectAction.Expand

            For Each v As View In st.Views
                Dim viewNode As New TreeNode(v.Name, v.Id.ToString)
                viewNode.SelectAction = TreeNodeSelectAction.Expand

                For Each t As Theme In v.Themes
                    Dim themeNode As New TreeNode(t.Name, t.Id.ToString)
                    themeNode.NavigateUrl = "javascript:void(0);"
                    viewNode.ChildNodes.Add(themeNode)
                Next

                serviceNode.ChildNodes.Add(viewNode)
            Next

            Me.ModelTreeView.Nodes.Add(serviceNode)
        Next
    End Sub

    Private Sub BindThemeGrid()
        Dim questions As Collection(Of ThemeQuestion)

        If SelectedQuestionId = 0 Then
            questions = New Collection(Of ThemeQuestion)
        Else
            questions = ThemeQuestion.GetByQuestionId(SelectedQuestionId)
        End If

        Me.ThemeGrid.DataSource = questions
        Me.ThemeGrid.DataBind()
    End Sub

    Private Sub BindRelatedQuestionsGrid()
        Dim tbl As DataTable

        'Get the list of ThemeQuestions that share content with the selected question
        If SelectedQuestionId = 0 Then
            tbl = Nothing
        Else
            tbl = QuestionContent.GetRelatedQuestions(Me.SelectedQuestionId)
        End If

        'Bind the list of related questions
        Me.RelatedQuestionsGrid.DataSource = tbl
        Me.RelatedQuestionsGrid.DataBind()

        Me.UseCurrentContentRadioButton.Text = "Use content from Question " & Me.SelectedQuestionId
    End Sub

    Private Sub InitQuestionContent()
        Dim qc As QuestionContent = QuestionContent.GetByQuestionId(Me.SelectedQuestionId)
        If qc Is Nothing Then
            Me.PageTitle.Text = "Invalid Question"
            Me.QuestionEditorDiv.Visible = False
            Me.ContentEditorDiv.Visible = False
        Else
            Me.QuestionContent = qc
            Me.PageTitle.Text = "Q" & Me.SelectedQuestionId & ": "
            Me.QuestionTextLabel.Text = Me.QuestionContent.QuestionText
            Me.QuestionTextPreviewLabel.Text = Me.QuestionContent.QuestionText
            Me.QuestionEditorDiv.Visible = True
            Me.ContentEditorDiv.Visible = True
        End If
    End Sub

    Private Sub BindQuestionContent()
        Dim contentHtml As String = ""
        Dim isNew As Boolean
        Dim isDirty As Boolean

        Select Case Me.SelectedContentType
            Case QuestionContentType.QuestionImportance
                contentHtml = Me.QuestionContent.ImportanceHtml
                isNew = Me.QuestionContent.ImportanceIsNew
                isDirty = Me.QuestionContent.ImportanceIsDirty
                Me.PageLogo2.Title = "Question Importance"

            Case QuestionContentType.QuickCheck
                contentHtml = Me.QuestionContent.QuickCheckHtml
                isNew = Me.QuestionContent.QuickCheckIsNew
                isDirty = Me.QuestionContent.QuickCheckIsDirty
                Me.PageLogo2.Title = "Quick Check"

            Case QuestionContentType.Recommendations
                contentHtml = Me.QuestionContent.RecommendationsHtml
                isNew = Me.QuestionContent.RecommendationsIsNew
                isDirty = Me.QuestionContent.ReccomendationsIsDirty
                Me.PageLogo2.Title = "What is Recommended?"

            Case QuestionContentType.Resources
                contentHtml = Me.QuestionContent.ResourcesHtml
                isNew = Me.QuestionContent.ResourcesIsNew
                isDirty = Me.QuestionContent.ResourcesIsDirty
                Me.PageLogo2.Title = "Resources"

        End Select

        Me.ContentLiteral.Text = contentHtml
        Me.NewContentImage.Visible = isNew
        Me.IsNewContent.Checked = False

        Me.PreviewDiv.Visible = True
        Me.EditDiv.Visible = False
        Me.EditButton.Enabled = True
        Me.PreviewButton.Enabled = False
        Me.PublishButton.Enabled = isDirty
        Me.CancelContentButton.Enabled = isDirty
    End Sub

    Private Sub InitCheckBoxJavascript()
        For Each row As GridViewRow In Me.ThemeGrid.Rows
            Dim cbx As CheckBox = DirectCast(row.FindControl("SelectThemeCheckBox"), CheckBox)
            ClientScript.RegisterArrayDeclaration("ThemeCheckBoxIDs", String.Concat("'", cbx.ClientID, "'"))
        Next

        For Each row As GridViewRow In Me.RelatedQuestionsGrid.Rows
            Dim cbx As CheckBox = DirectCast(row.FindControl("SelectQuestionCheckBox"), CheckBox)
            ClientScript.RegisterArrayDeclaration("QuestionsCheckBoxIDs", String.Concat("'", cbx.ClientID, "'"))
        Next

    End Sub
#End Region

#Region " Control Event Handlers "
    Private Sub SelectThemeButton_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles SelectThemeButton.Click
        Dim themeId As Integer = CInt(Me.ModelTreeView.SelectedValue)
        Try
            ThemeQuestion.AddQuestionToTheme(themeId, Me.SelectedQuestionId, CurrentUser.Name)
        Catch ex As Exception
            Me.ThemeGridErrorLabel.Text = ex.Message
        End Try
        Me.ModelTreeView.SelectedNode.Selected = False
        Me.BindThemeGrid()
    End Sub

    Protected Sub LoadQuestionButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles LoadQuestionButton.Click
        Response.Redirect("QuestionManager.aspx?QuestionId=" & Me.QuestionId.Text)
    End Sub

    Private Sub Menu1_MenuItemClick(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.MenuEventArgs) Handles ContentTypeMenu.MenuItemClick
        Me.BindQuestionContent()
    End Sub

    Private Sub EditButton_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles EditButton.Click
        Me.PreviewDiv.Visible = False
        Me.EditDiv.Visible = True
        Me.ContentEditor.Text = Me.ContentLiteral.Text

        Me.EditButton.Enabled = False
        Me.PreviewButton.Enabled = True
        Me.PublishButton.Enabled = False
        Me.CancelButton.Enabled = True
    End Sub

    Private Sub PreviewButton_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles PreviewButton.Click
        Me.PreviewDiv.Visible = True
        Me.EditDiv.Visible = False
        Dim isDirty As Boolean

        Select Case Me.SelectedContentType
            Case QuestionContentType.QuestionImportance
                Me.QuestionContent.ImportanceHtml = Me.ContentEditor.Text
                Me.QuestionContent.ImportanceIsNew = Me.IsNewContent.Checked
                isDirty = Me.QuestionContent.ImportanceIsDirty
            Case QuestionContentType.QuickCheck
                Me.QuestionContent.QuickCheckHtml = Me.ContentEditor.Text
                Me.QuestionContent.QuickCheckIsNew = Me.IsNewContent.Checked
                isDirty = Me.QuestionContent.QuickCheckIsDirty
            Case QuestionContentType.Recommendations
                Me.QuestionContent.RecommendationsHtml = Me.ContentEditor.Text
                Me.QuestionContent.RecommendationsIsNew = Me.IsNewContent.Checked
                isDirty = Me.QuestionContent.ReccomendationsIsDirty
            Case QuestionContentType.Resources
                Me.QuestionContent.ResourcesHtml = Me.ContentEditor.Text
                Me.QuestionContent.ResourcesIsNew = Me.IsNewContent.Checked
                isDirty = Me.QuestionContent.ResourcesIsDirty
        End Select

        Me.ContentLiteral.Text = Me.ContentEditor.Text
        Me.NewContentImage.Visible = Me.IsNewContent.Checked

        Me.EditButton.Enabled = True
        Me.PreviewButton.Enabled = False
        Me.PublishButton.Enabled = isDirty
        Me.CancelContentButton.Enabled = isDirty
    End Sub

    Private Sub PublishButton_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles PublishButton.Click
        Me.QuestionContent.Save(Me.SelectedContentType)
        Me.InitQuestionContent()
        Me.BindQuestionContent()
    End Sub

    Private Sub CancelButton_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles CancelContentButton.Click
        Me.InitQuestionContent()
        Me.BindQuestionContent()
    End Sub

    Protected Sub UnassignButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles UnassignButton.Click
        For i As Integer = 0 To Me.ThemeGrid.Rows.Count - 1
            Dim cbx As CheckBox = TryCast(ThemeGrid.Rows(i).Cells(0).FindControl("SelectThemeCheckBox"), CheckBox)
            If cbx IsNot Nothing Then
                If cbx.Checked Then
                    Dim themeId As Integer = CInt(Me.ThemeGrid.DataKeys(i).Value)
                    ThemeQuestion.RemoveQuestionFromTheme(themeId, Me.SelectedQuestionId, CurrentUser.Name)
                End If
            End If
        Next

        Me.BindThemeGrid()
    End Sub

    Protected Sub RelateOkButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles RelateOkButton.Click
        Dim questionId As Integer = 0
        If Integer.TryParse(Me.RelateQuestionId.Text, questionId) Then

            If questionId = Me.SelectedQuestionId Then
                Me.RelatedGridErrorLabel.Text = "A question cannot be related to itself."
                Exit Sub
            End If

            'Check to see that this is a valid question
            Dim qc As QuestionContent = QuestionContent.GetByQuestionId(questionId)
            If qc IsNot Nothing Then
                Dim useRelated As Boolean = Me.UseRelatedContentRadioButton.Checked
                QuestionContent.RelateQuestionContent(SelectedQuestionId, questionId, useRelated)
            Else
                Me.RelatedGridErrorLabel.Text = "You have entered an invalid question ID."
            End If
        Else
            Me.RelatedGridErrorLabel.Text = "You have entered an invalid question ID."
        End If

        Me.RelateQuestionId.Text = ""
        Me.BindRelatedQuestionsGrid()
        Me.InitQuestionContent()
        Me.BindQuestionContent()
    End Sub

    Protected Sub UnrelateButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles UnrelateButton.Click
        For i As Integer = 0 To Me.RelatedQuestionsGrid.Rows.Count - 1
            Dim cbx As CheckBox = TryCast(RelatedQuestionsGrid.Rows(i).Cells(0).FindControl("SelectQuestionCheckBox"), CheckBox)
            If cbx IsNot Nothing Then
                If cbx.Checked Then
                    Dim questionId As Integer = CInt(Me.RelatedQuestionsGrid.DataKeys(i).Value)
                    QuestionContent.UnrelateQuestionContent(questionId)
                End If
            End If
        Next

        Me.BindRelatedQuestionsGrid()
    End Sub
#End Region

#Region " RelatedQuestionGridRow "
    Private Class RelatedQuestionGridRow
        Private mQuestionId As Integer
        Private mQuestionText As String
        Private mServiceTypeName As String

        Public Property QuestionId() As Integer
            Get
                Return mQuestionId
            End Get
            Set(ByVal value As Integer)
                mQuestionId = value
            End Set
        End Property
        Public Property QuestionText() As String
            Get
                Return mQuestionText
            End Get
            Set(ByVal value As String)
                mQuestionText = value
            End Set
        End Property
        Public Property ServiceTypeName() As String
            Get
                Return mServiceTypeName
            End Get
            Set(ByVal value As String)
                mServiceTypeName = value
            End Set
        End Property
    End Class
#End Region

#Region " Protected Methods "
    Protected Function IsThemeCheckable(ByVal statusValue As Object) As Boolean
        Dim status As ThemeQuestionStatus = DirectCast(statusValue, ThemeQuestionStatus)
        Return (status = ThemeQuestionStatus.Live OrElse status = ThemeQuestionStatus.PendingAdd)
    End Function
#End Region

End Class