Imports System.Configuration
Imports System.Linq
Imports System.Windows.Forms
Imports Nrc.NRCAuthLib.OUH

' This control provides selection of Org Units from an NRC_CatalystStar database.  It provides a dropdown of Organizations
' Hierarchies to select from, dropdowns to filter those Organizations by client and category, and a hierarchical tree selector
' to select Org Units across those Organizations.
'
' NOTE: NRCAuth has its own concept of "Org Units", which is just great, but hey, I didn't name any of this.  In the code, I
' always refer to "Organizations" or "OUHS", and the individual items as "OUs".
'
' Alex Gallichotte 8/25/13
Public Class OUHEditor

#Region "Private Members"
    ' We get passed an anonymous function that gets the current OU IDs for whatever member/group we're configuring
    Private _getOUIDs As Func(Of Integer())

    ' this is used to change state of certain controls without triggering handlers
    Private _enableEvents As Boolean = False
    ' We store our Organizations by ID for persistent use in our dropdown list and tree OU selector
    Private _organizations As Dictionary(Of Integer, Organization)

    ' get the value of the DatasourceSelection dropdown
    Private ReadOnly Property OUHConnectionString As ConnectionStringSettings
        Get
            Return CType(DatabaseSelector.SelectedValue, ConnectionStringSettings)
        End Get
    End Property

    ' get the value of the ClientFilter dropdown
    Private ReadOnly Property SelectedClientID As Integer
        Get
            Return CType(ClientFilter.SelectedValue, Client).ClientID
        End Get
    End Property

    ' get the value of the CategoryFilter dropdown
    Private ReadOnly Property SelectedCategory As String
        Get
            Return CategoryFilter.SelectedValue.ToString()
        End Get
    End Property

    ' get or set the value of the Organization dropdown
    Private Property SelectedOrganization As Organization
        Get
            Return CType(OUHSelector.SelectedValue, Organization)
        End Get
        Set(value As Organization)
            OUHSelector.SelectedItem = _organizations(value.OrganizationID)
        End Set
    End Property

#End Region
#Region "Public Properties"
    ' the external interface to this control, provides a list of selected OUs across all Organizations
    Public ReadOnly Property CheckedOrgUnitIDs() As Integer()
        Get
            Return _organizations.Values.Where(Function(o) o.IsLoaded) _
                                        .SelectMany(Function(o) o.OUNodes) _
                                        .Where(Function(n) n.Enabled And n.Checked) _
                                        .Select(Function(n) n.ID) _
                                        .ToArray()
        End Get
    End Property
#End Region

#Region "Constructor"
    ' Constructs a new OUHEditor control, with a list of OU IDs preselected
    Public Sub New(ByVal getOUIDs As Func(Of Integer()))
        InitializeComponent()

        ' save our anonymous "Get OUs" function
        _getOUIDs = getOUIDs

        ' grab our catalyststar connectionstrings and let the user select them
        DatabaseSelector.DisplayMember = "Name"
        DatabaseSelector.DataSource = ConfigurationManager.ConnectionStrings _
                                                          .Cast(Of ConnectionStringSettings) _
                                                          .Where(Function(cs) cs.Name.Contains("CatalystStar")) _
                                                          .ToList()

        Database_Select(Nothing, Nothing)
    End Sub

#End Region

#Region "Event Handlers"
    ' When a new database is selected, repopulate all the other controls
    Private Sub Database_Select(ByVal sender As System.Object, ByVal e As System.EventArgs) _
                Handles DatabaseSelector.SelectedIndexChanged
        OUHModel.ConnectionString = OUHConnectionString

        ' load organizations into our dictionary
        _organizations = OUHModel.GetOrganizations().ToDictionary(Function(o) o.OrganizationID, Function(o) o)

        ' set filters open
        ClientFilter.DisplayMember = "ClientName"
        ClientFilter.DataSource = OUHModel.GetClients()

        OUHSelector.DisplayMember = "DisplayName"
        CategoryFilter.DataSource = OUHModel.GetCategories()

        ' show all organizations in the selector
        OUHSelector.DataSource = _organizations.Values.OrderBy(Function(o) o.OrganizationName) _
                                                      .ToList()

        ' activate the event handlers
        _enableEvents = True

        ' fire the Filter handler to populate our Organization list
        Filter_Select(Nothing, Nothing)

        ' fire the Organization handler to populate our initial treeview
        OUHSelector_Select(Nothing, Nothing)

        ' if we have any org units already assigned
        Dim currentOUIDs As Integer() = _getOUIDs()
        If currentOUIDs.Length <> 0 Then
            ' grab the organizations we already have selected nodes for
            Dim existingOrgs As List(Of Organization) = OUHModel.GetOrganizationsForOUs(currentOUIDs)

            ' ensure they're loaded and OUs selected appropriately
            existingOrgs.ForEach(Sub(o) _organizations(o.OrganizationID).LoadNodes(currentOUIDs))

            ' set our Organization selector to one of them
            SelectedOrganization = existingOrgs.First()
        End If
    End Sub


    ' When the filter(s) change, select a new list of Organizations
    Private Sub Filter_Select(ByVal sender As System.Object, ByVal e As System.EventArgs) _
                Handles ClientFilter.SelectedIndexChanged, CategoryFilter.SelectedIndexChanged
        If (_enableEvents) Then
            OUHSelector.DataSource = OUHModel.GetOrganizations(SelectedClientID, SelectedCategory) _
                                             .Select(Function(o) _organizations(o.OrganizationID)) _
                                             .ToList()
        End If
    End Sub

    ' When OUHSelector changes, populate our TreeView
    Private Sub OUHSelector_Select(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles OUHSelector.SelectedIndexChanged
        If (_enableEvents) Then
            If (SelectedOrganization IsNot Nothing) Then
                If (Not SelectedOrganization.IsLoaded) Then
                    SelectedOrganization.LoadNodes()
                End If
                OUSelector.Nodes.Clear()
                OUSelector.Nodes.AddRange(SelectedOrganization.TopOUNodes)

                _enableEvents = False
                CheckAllBox.Checked = False
                _enableEvents = True
            Else
                OUHSelector.ResetText()
                OUSelector.Nodes.Clear()
            End If
        End If
    End Sub

    ' Handle an OU checkbox being checked or unchecked
    Private Sub OUSelector_AfterCheck(ByVal sender As System.Object, ByVal e As TreeViewEventArgs) Handles OUSelector.AfterCheck
        Dim ouNode As OUNode = CType(e.Node, OUNode)
        ' If a node is being checked, disable the children from being selected
        If (ouNode.Checked) Then
            ouNode.CheckChildren()
            ouNode.DisableChildren()
        Else
            ' If a node is being unchecked
            If (CheckAllBox.Checked) Then
                ' If the checkallbox is checked, disable it since it no longer applies
                _enableEvents = False
                CheckAllBox.Checked = False
                _enableEvents = True
            End If
            ' Enable and uncheck the children
            ouNode.EnableChildren()
            ouNode.UncheckChildren()
        End If

        ' Update the OUH dropdown to reflect a different selection (e.g. "(2 nodes selected)")
        ReloadOUHDropdown()
    End Sub

    ' If the checkbox is disabled, cancel the event (so you can't check it)
    Private Sub OUSelector_BeforeCheck(ByVal sender As System.Object, ByVal e As TreeViewCancelEventArgs) Handles OUSelector.BeforeCheck
        e.Cancel = Not CType(e.Node, OUNode).Enabled
    End Sub

    ' Handle the check-all box being changed
    Private Sub CheckAllBox_CheckedChanged() Handles CheckAllBox.CheckedChanged
        If (_enableEvents) Then
            If (CheckAllBox.Checked) Then
                For Each node As OUNode In OUSelector.Nodes
                    node.Checked = True
                Next
            Else
                For Each node As OUNode In OUSelector.Nodes
                    ' check then uncheck to ensure we clear it and all its children
                    node.Checked = True
                    node.Checked = False
                Next
            End If
        End If
    End Sub

#End Region

#Region "Private Methods"
    ' Update the OUH dropdown for "(N nodes selected)" hints
    Private Sub ReloadOUHDropdown()
        _enableEvents = False
        Dim index As Integer = OUHSelector.SelectedIndex
        Dim items As New List(Of Organization)(CType(OUHSelector.DataSource, IList(Of Organization)))
        OUHSelector.DataSource = items
        OUHSelector.SelectedIndex = index
        _enableEvents = True
    End Sub
#End Region

End Class
