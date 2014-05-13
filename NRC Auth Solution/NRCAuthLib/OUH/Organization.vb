Imports System.Collections.Generic

Namespace OUH
    ' This class extends the Organization class provided by EF with properties and methods,
    ' primarily to allow for loading and rendering OUNodes for use in a TreeView
    Partial Public Class Organization

#Region "Private Members"
        ' Stores the top-level OUNodes for this organization
        Private _OUNodes As OUNode() = Nothing
#End Region

#Region "Readonly Properties"
        ' Renders the name of the Organization suitable for display in an OUH drop-down selector,
        ' including a hint indicating the number of selected nodes
        Public ReadOnly Property DisplayName() As String
            Get
                If (IsLoaded) Then
                    Dim checked As Integer = OUNodes.Where(Function(n) n.Checked).Count()
                    If (checked > 0) Then
                        Return String.Format("{0} ({1} nodes selected)", OrganizationName, checked)
                    End If
                End If
                Return OrganizationName
            End Get
        End Property

        ' Since an Organization's OUNodes are loaded as-needed, this property describes whether the
        ' nodes have been loaded
        Public ReadOnly Property IsLoaded() As Boolean
            Get
                Return _OUNodes IsNot Nothing
            End Get
        End Property

        ' Provides access to all of the OUNodes for an Organization
        Public ReadOnly Property OUNodes() As OUNode()
            Get
                Dim nodes As New List(Of OUNode)(TopOUNodes)
                nodes.AddRange(FlattenNodes(TopOUNodes))
                Return nodes.ToArray()
            End Get
        End Property

        ' Provides access to the top level OUNodes for an organization
        Public ReadOnly Property TopOUNodes() As OUNode()
            Get
                If (_OUNodes Is Nothing) Then
                    Throw New ObjectNotFoundException("OUNodes not loaded.  Run LoadNodes() before accessing")
                End If
                Return _OUNodes.ToArray()
            End Get
        End Property
#End Region

#Region "Public Methods"
        ' Loads the OUNodes for this Organization from the database
        Public Sub LoadNodes()
            If (Not IsLoaded) Then
                _OUNodes = OUNode.GetOUNodes(OUHModel.GetOUsForOrganization(Me))
            End If
        End Sub

        ' Loads the OUNodes for this Organization from the database, pre-checking a list of OUNodes
        ' based off the OU IDs
        Public Sub LoadNodes(ByVal orgUnitIDs As Integer())
            LoadNodes()
            For Each node As OUNode In OUNodes
                If (orgUnitIDs.Contains(node.ID)) Then
                    node.Checked = True
                    node.CheckChildren()
                    node.DisableChildren()
                End If
            Next
        End Sub
#End Region

#Region "Private Methods"
        ' Given an IEnumerable of OUNodes, returns an array of those nodes and all their children
        Private Shared Function FlattenNodes(ByVal nodes As IEnumerable(Of OUNode)) As OUNode()
            Dim children As List(Of OUNode) = nodes.SelectMany(Of OUNode)(Function(n) n.Nodes _
                                                                                       .Cast(Of OUNode)()) _
                                                   .ToList()

            If (children.Count <> 0) Then
                children.AddRange(FlattenNodes(children))
            End If
            Return children.ToArray()
        End Function
#End Region
    End Class
End Namespace