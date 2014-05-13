Imports System.Linq
Imports System.Windows.Forms
Imports System.Collections.Generic

Namespace OUH
    ' This class represents a single node in the DevExpress treeview, corresponding to a single OU
    Public Class OUNode
        Inherits TreeNode

#Region "Private Members"
        ' The ID of the corresponding OU
        Private _ID As Integer
        ' Whether the OU is disabled (grayed out and can't be selected)
        Private _enabled As Boolean = True
#End Region

#Region "Public Properties"
        ' The public accessor for ID
        Public ReadOnly Property ID() As Integer
            Get
                Return _ID
            End Get
        End Property

        ' The public accessor for the enabled property
        Public Property Enabled() As Boolean
            Get
                Return _enabled
            End Get
            Set(ByVal value As Boolean)
                _enabled = value
                If (value) Then
                    ForeColor = Drawing.Color.Black
                Else
                    ForeColor = Drawing.Color.Gray
                End If
            End Set
        End Property
#End Region

#Region "Constructors"
        ' Constructs an OUNode and its children, given a list of all OUs for an Organization
        Private Sub New(ByVal orgUnit As vw_OrganizationUnit, ByVal ous As List(Of vw_OrganizationUnit))
            MyBase.New(orgUnit.OrgUnitName + " (" + orgUnit.LevelName + ")")
            _ID = orgUnit.OrganizationUnitID

            Nodes.AddRange(ous.Where(Function(ou) ou.ParentOrgUnitID.HasValue AndAlso orgUnit.OrganizationUnitID = ou.ParentOrgUnitID.Value) _
                              .Select(Function(ou) New OUNode(ou, ous)) _
                              .ToArray())

            Expand()
        End Sub

        ' The public static constructor - pass it a list of all OUs for the organization
        Public Shared Function GetOUNodes(ous As List(Of vw_OrganizationUnit)) As OUNode()
            Return ous.Where(Function(ou) Not ou.ParentOrgUnitID.HasValue) _
                      .Select(Function(ou) New OUNode(ou, ous)) _
                      .ToArray()
        End Function
#End Region

#Region "Tree Methods"
        Public Sub CheckChildren()
            For Each node As OUNode In Nodes
                node.Checked = True
                node.CheckChildren()
            Next
        End Sub

        Public Sub UncheckChildren()
            For Each node As OUNode In Nodes
                node.Checked = False
                node.UncheckChildren()
            Next
        End Sub

        Public Sub EnableChildren()
            For Each node As OUNode In Nodes
                node.Enabled = True
                node.EnableChildren()
            Next
        End Sub

        Public Sub DisableChildren()
            For Each node As OUNode In Nodes
                node.Enabled = False
                node.DisableChildren()
            Next
        End Sub
#End Region

    End Class
End Namespace