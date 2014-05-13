Imports Nrc.NRCAuthLib

Partial Public Class UserControls_QuickGroupSelector
    Inherits System.Web.UI.UserControl

    'Private WithEvents mRootMenuItem As New MenuItem

    'Private ReadOnly Property MemberGroups() As GroupCollection
    '    Get
    '        Dim cacheKey As String = "MemberGroups." & CurrentUser.Member.Id
    '        Dim groups As GroupCollection = TryCast(Cache(cacheKey), GroupCollection)
    '        If groups Is Nothing Then
    '            groups = CurrentUser.Member.GetMemberGroups
    '            Cache.Add(cacheKey, groups, Nothing, Caching.Cache.NoAbsoluteExpiration, TimeSpan.FromMinutes(5), CacheItemPriority.Default, Nothing)
    '        End If
    '        Return groups
    '    End Get
    'End Property

    'Private Sub Page_Init(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Init
    '    If Not Page.IsPostBack Then
    '        Me.PopulateGroupList()
    '    End If
    'End Sub

    'Private Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
    '    If Page.IsPostBack Then
    '        Me.mRootMenuItem = Me.GroupMenu.Items(0)
    '    End If
    'End Sub

    'Private Sub PopulateGroupList()
    '    Me.GroupMenu.Items.Clear()
    '    If CurrentUser.HasSelectedGroup Then
    '        mRootMenuItem.Text = CurrentUser.SelectedGroup.Name
    '        mRootMenuItem.NavigateUrl = Me.ResolveUrl("~/MyAccount/GroupSelection.aspx")
    '    Else
    '        mRootMenuItem.Text = "Select a group"
    '    End If

    '    For Each grp As Group In MemberGroups
    '        Dim item As New MenuItem(grp.Name, grp.GroupId.ToString)
    '        If CurrentUser.HasSelectedGroup AndAlso grp.GroupId = CurrentUser.SelectedGroup.Id Then
    '            item.Selected = True
    '        End If
    '        mRootMenuItem.ChildItems.Add(item)
    '    Next
    '    Me.GroupMenu.Items.Add(mRootMenuItem)
    'End Sub

    Protected Sub GroupMenu_MenuItemClick(ByVal sender As System.Object, ByVal e As System.Web.UI.WebControls.MenuEventArgs) Handles GroupMenu.MenuItemClick
        'Nrc.NRCAuthLib.WebContext.CurrentGroupId = CInt(e.Item.Value)
        'mRootMenuItem.Text = CurrentUser.SelectedGroup.Name
    End Sub

End Class