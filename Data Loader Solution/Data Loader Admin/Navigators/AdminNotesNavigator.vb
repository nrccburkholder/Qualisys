Imports Nrc.Qualisys.Library
Imports System.Collections.ObjectModel
Public Class AdminNotesNavigator
    Private mSection As Section
    Private Const ClientImage As String = "Client"
    Private Const StudyImage As String = "Study"

    Public Event SelectionChanged As EventHandler

    ''' <summary>Here we populate the tree and assign the imagelist to it.</summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <CreateBy>Arman Mnatsakanyan</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub AdminNotesNavigator_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Me.TreeViewClientStudy.ImageList = Me.imageListTree
        Dim clients As Collection(Of Client) = Client.GetClientsByUser(CurrentUser.UserName, Client.PopulateDepth.Study)
        Me.PopulateTree(clients)
    End Sub
    ''' <summary>Populates the Tree with clients and Studies</summary>
    ''' <param name="clients">A generic collection of Client objects</param>
    ''' <CreateBy>Arman Mnatsakanyan</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub PopulateTree(ByVal clients As Collection(Of Client))
        Dim newClientNode As TreeNode

        For Each clnt As Client In clients
            newClientNode = New TreeNode(clnt.DisplayLabel)
            newClientNode.ImageKey = ClientImage
            newClientNode.SelectedImageKey = ClientImage
            newClientNode.Tag = clnt
            TreeViewClientStudy.Nodes.Add(newClientNode)

            Dim newStudyNode As TreeNode
            For Each stdy As Study In clnt.Studies
                newStudyNode = New TreeNode(stdy.DisplayLabel)
                newStudyNode.ImageKey = StudyImage
                newStudyNode.SelectedImageKey = StudyImage
                newStudyNode.Tag = stdy
                newClientNode.Nodes.Add(newStudyNode)
            Next
        Next
    End Sub
    Private mSelectedStudies As New Collection(Of Study)
    ''' <summary>Retrieves the selected studies from TreeViewClientStudy </summary>
    ''' <value></value>
    ''' <CreateBy>Arman Mnatsakanyan</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public ReadOnly Property SelectedStudies() As Collection(Of Study)
        Get
            mSelectedStudies.Clear()
            For Each node As TreeNode In Me.TreeViewClientStudy.SelectedNodes
                If node.Level = 1 Then
                    mSelectedStudies.Add(TryCast(node.Tag, Study))
                End If
            Next
            Return mSelectedStudies
        End Get
    End Property
    ''' <summary>Here we control the tree behaviour. Cross-Client selection is not allowed but users can select 
    ''' more than one studies under the same client. Clicking on a client toggles the client node.</summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <CreateBy>Arman Mnatsakanyan</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub SurveyTree_BeforeSelect(ByVal sender As Object, ByVal e As System.Windows.Forms.TreeViewCancelEventArgs) Handles TreeViewClientStudy.BeforeSelect
        If TypeOf (e.Node.Tag) Is Client Then
            e.Node.Toggle()
            e.Cancel = True
        ElseIf TypeOf (e.Node.Tag) Is Study Then
            Dim ModifierKeyIsPressed As Boolean = _
                (MultiSelectTreeView.ModifierKeys = Keys.Shift) _
                Or (MultiSelectTreeView.ModifierKeys = Keys.Control)
            Dim selectedstudy As Study = CType(e.Node.Tag, Study)

            If Me.TreeViewClientStudy.SelectedNodes.Count > 0 Then 'User has selected Studies
                'If Selected the study belongs to the same client
                If Me.TreeViewClientStudy.SelectedNodes(0).Parent IsNot e.Node.Parent Then
                    If ModifierKeyIsPressed Then
                        e.Cancel = True
                    Else
                        Me.TreeViewClientStudy.DeselectAllSelectedNodes()
                    End If
                End If
            End If
        End If
    End Sub

    ''' <summary>Handles <b>TreeViewClientStudy.SelectionChanged</b> event and raises
    ''' <b>AdminNotesNavigator.SelectionChanged</b> event which is handled in
    ''' <b>NotesSection </b>control.</summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <CreateBy>Arman Mnatsakanyan</CreateBy>
    ''' <RevisionList><list type="table">
    ''' <listheader>
    ''' <term>Date Modified - Modified By</term>
    ''' <description>Description</description></listheader>
    ''' <item>
    ''' <term>	</term>
    ''' <description>
    ''' <para></para></description></item>
    ''' <item>
    ''' <term>	</term>
    ''' <description>
    ''' <para></para></description></item></list></RevisionList>
    Private Sub SurveyTree_SelectionChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles TreeViewClientStudy.SelectionChanged
        RaiseEvent SelectionChanged(Me, EventArgs.Empty)
    End Sub

End Class
