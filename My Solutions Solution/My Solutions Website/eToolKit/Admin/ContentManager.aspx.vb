Imports Nrc.DataMart.MySolutions.Library

Partial Public Class eToolKit_Admin_ContentManager
    Inherits ToolKitPage

    Protected Overrides ReadOnly Property LogPageRequest() As Boolean
        Get
            Return False
        End Get
    End Property

    Private Enum Mode
        EditMode = 0
        NewKey = 1
        NewCategoryAndKey = 2
    End Enum
    Private Property EditMode() As Mode
        Get
            If ViewState("EditMode") Is Nothing Then
                ViewState("EditMode") = Mode.EditMode
            End If
            Return CType(ViewState("EditMode"), Mode)
        End Get
        Set(ByVal Value As Mode)
            ViewState("EditMode") = Value
        End Set
    End Property

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            PopulateCategories()
            PopulateKeys(ddlCategory.SelectedValue)
            PopulateContent()
            btnDelete.Attributes.Add("OnClick", "return confirm('Are you sure?');")
        End If
    End Sub

    Private Sub PopulateCategories()
        Dim categories As List(Of String) = ManagedContent.GetCategoryList
        ddlCategory.DataSource = categories
        ddlCategory.DataBind()
    End Sub

    Private Sub PopulateKeys(ByVal category As String)
        Dim keys As List(Of String) = ManagedContent.GetKeyList(category)
        ddlKey.DataSource = keys
        ddlKey.DataBind()
    End Sub

    Private Sub PopulateContent()
        Dim mc As ManagedContent
        mc = ManagedContent.GetByKey(ddlCategory.SelectedValue, ddlKey.SelectedValue)

        If Not mc Is Nothing Then
            Me.IsActive.Checked = mc.IsActive
            Me.Teaser.Text = mc.Teaser
            Me.Content.Text = mc.Content
        Else
            ClearContent()
        End If
    End Sub

    Private Sub ClearContent()
        Me.Teaser.Text = ""
        Me.Content.Text = ""
        IsActive.Checked = False
        txtCategory.Text = ""
        txtKey.Text = ""
    End Sub

    Private Sub ddlCategory_SelectedIndexChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ddlCategory.SelectedIndexChanged
        If EditMode = Mode.EditMode Then
            PopulateKeys(ddlCategory.SelectedValue)
            PopulateContent()
        End If
    End Sub

    Private Sub ddlKey_SelectedIndexChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ddlKey.SelectedIndexChanged
        If EditMode = Mode.EditMode Then
            PopulateContent()
        End If
    End Sub



    Private Sub btnSave_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnSave.Click
        Dim mc As ManagedContent = Nothing

        Select Case EditMode
            Case Mode.EditMode
                mc = ManagedContent.GetByKey(ddlCategory.SelectedValue, ddlKey.SelectedValue)
            Case Mode.NewKey
                mc = ManagedContent.NewManagedContent(ddlCategory.SelectedValue, txtKey.Text)
            Case Mode.NewCategoryAndKey
                mc = ManagedContent.NewManagedContent(txtCategory.Text, txtKey.Text)
        End Select

        mc.IsActive = Me.IsActive.Checked
        mc.Teaser = Me.Teaser.Text
        mc.Content = Me.Content.Text

        If EditMode = Mode.EditMode Then
            mc.Save()
        Else
            mc.Save()
            PopulateCategories()
            ddlCategory.SelectedValue = mc.Category
            PopulateKeys(ddlCategory.SelectedValue)
            ddlKey.SelectedValue = mc.Key
            PopulateContent()
        End If
        ClearCache()
        EditMode = Mode.EditMode
    End Sub

    Private Sub ClearCache()
        Dim cache As System.Web.Caching.Cache = HttpContext.Current.Cache
        Dim cacheEnum As IDictionaryEnumerator = cache.GetEnumerator
        Dim keys As New ArrayList
        While cacheEnum.MoveNext
            If cacheEnum.Key.ToString.StartsWith("Rscm") Then
                keys.Add(cacheEnum.Key)
            End If
        End While
        For Each key As String In keys
            cache.Remove(key)
        Next
    End Sub


    Private Sub Page_PreRender(ByVal sender As Object, ByVal e As System.EventArgs) Handles MyBase.PreRender
        trCategoryDDL.Visible = Not (EditMode = Mode.NewCategoryAndKey)
        trKeyDDL.Visible = (EditMode = Mode.EditMode)
        trActive.Visible = (EditMode = Mode.EditMode)
        trCategoryTXT.Visible = (EditMode = Mode.NewCategoryAndKey)
        trKeyTXT.Visible = Not (EditMode = Mode.EditMode)
        btnNewCategory.Visible = (EditMode = Mode.EditMode)
        btnNewKey.Visible = (EditMode = Mode.EditMode)
        btnCancel.Visible = Not (EditMode = Mode.EditMode)
        btnDelete.Visible = (EditMode = Mode.EditMode)
    End Sub

    Private Sub btnCancel_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnCancel.Click
        EditMode = Mode.EditMode
    End Sub

    Private Sub btnNewCategory_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnNewCategory.Click
        EditMode = Mode.NewCategoryAndKey
        ClearContent()
    End Sub

    Private Sub btnNewKey_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnNewKey.Click
        EditMode = Mode.NewKey
        ClearContent()
    End Sub

    Private Sub btnDelete_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnDelete.Click
        Dim content As ManagedContent
        content = ManagedContent.GetByKey(ddlCategory.SelectedValue, ddlKey.SelectedValue)
        content.Delete()
        content.Save()
        PopulateCategories()
        PopulateKeys(ddlCategory.SelectedValue)
        PopulateContent()
        ClearCache()
    End Sub

End Class