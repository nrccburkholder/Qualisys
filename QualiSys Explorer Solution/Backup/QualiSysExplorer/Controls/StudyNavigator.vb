Imports Nrc.QualiSys.Library
Imports System.Collections.ObjectModel

Public Class StudyNavigator
    Inherits System.Windows.Forms.UserControl

#Region " Windows Form Designer generated code "

    Public Sub New()
        MyBase.New()

        'This call is required by the Windows Form Designer.
        InitializeComponent()

        'Add any initialization after the InitializeComponent() call
        LoadTree()
    End Sub

    'UserControl overrides dispose to clean up the component list.
    Protected Overloads Overrides Sub Dispose(ByVal disposing As Boolean)
        If disposing Then
            If Not (components Is Nothing) Then
                components.Dispose()
            End If
        End If
        MyBase.Dispose(disposing)
    End Sub

    'Required by the Windows Form Designer
    Private components As System.ComponentModel.IContainer

    'NOTE: The following procedure is required by the Windows Form Designer
    'It can be modified using the Windows Form Designer.  
    'Do not modify it using the code editor.
    Friend WithEvents StudyTree As System.Windows.Forms.TreeView
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.StudyTree = New System.Windows.Forms.TreeView
        Me.SuspendLayout()
        '
        'StudyTree
        '
        Me.StudyTree.Dock = System.Windows.Forms.DockStyle.Fill
        Me.StudyTree.FullRowSelect = True
        Me.StudyTree.HideSelection = False
        Me.StudyTree.ImageIndex = -1
        Me.StudyTree.Location = New System.Drawing.Point(0, 0)
        Me.StudyTree.Name = "StudyTree"
        Me.StudyTree.SelectedImageIndex = -1
        Me.StudyTree.Size = New System.Drawing.Size(248, 504)
        Me.StudyTree.TabIndex = 0
        '
        'StudyNavigator
        '
        Me.Controls.Add(Me.StudyTree)
        Me.Name = "StudyNavigator"
        Me.Size = New System.Drawing.Size(248, 504)
        Me.ResumeLayout(False)

    End Sub

#End Region

#Region " StudyChanged Event "
    Public Class StudyChangedEventArgs
        Inherits EventArgs

        Private mStudy As Study

        Public ReadOnly Property NewStudy() As Study
            Get
                Return mStudy
            End Get
        End Property
        Sub New(ByVal newStudy As Study)
            mStudy = newStudy
        End Sub
    End Class
    Public Delegate Sub StudyChangedEventHandler(ByVal sender As Object, ByVal e As StudyChangedEventArgs)
    Public Event StudyChanged As StudyChangedEventHandler
#End Region

    Private mLastStudyNode As StudyNode

    Public ReadOnly Property SelectedStudy() As Study
        Get
            If Me.StudyTree.SelectedNode Is Nothing Then
                Return Nothing
            Else
                If TypeOf Me.StudyTree.SelectedNode Is ClientNode Then
                    Return Nothing
                ElseIf TypeOf Me.StudyTree.SelectedNode Is StudyNode Then
                    Return DirectCast(Me.StudyTree.SelectedNode, StudyNode).Study
                Else
                    Return Nothing
                End If
            End If
        End Get
    End Property

    Private Sub LoadTree()
        Dim clients As Collection(Of Client) = Client.GetClientsByUser(CurrentUser.UserName, PopulateDepth.Study)
        Dim cNode As TreeNode
        Dim sNode As TreeNode
        For Each clnt As Client In clients
            cNode = New ClientNode(clnt)

            For Each stdy As Study In clnt.Studies
                sNode = New StudyNode(stdy)
                cNode.Nodes.Add(sNode)
            Next
            Me.StudyTree.Nodes.Add(cNode)
        Next
    End Sub

    Public Class ClientNode
        Inherits TreeNode

        Private mClient As Client

        Public ReadOnly Property Client() As Client
            Get
                Return mClient
            End Get
        End Property
        Public ReadOnly Property ClientId() As Integer
            Get
                Return mClient.Id
            End Get
        End Property
        Public ReadOnly Property ClientName() As String
            Get
                Return mClient.Name
            End Get
        End Property
        Sub New(ByVal c As Client)
            MyBase.New()
            mClient = c
            Me.Text = mClient.DisplayLabel
        End Sub
    End Class
    Public Class StudyNode
        Inherits TreeNode

        Private mStudy As Study

        Public ReadOnly Property Study() As Study
            Get
                Return mStudy
            End Get
        End Property
        Public ReadOnly Property ClientId() As Integer
            Get
                Return mStudy.ClientId
            End Get
        End Property
        Public ReadOnly Property StudyId() As Integer
            Get
                Return mStudy.Id
            End Get
        End Property
        Public ReadOnly Property StudyName() As String
            Get
                Return mStudy.Name
            End Get
        End Property

        Sub New(ByVal s As Study)
            MyBase.New()
            mStudy = s
            Me.Text = mStudy.DisplayLabel
        End Sub
    End Class

    Private Sub StudyTree_AfterSelect(ByVal sender As Object, ByVal e As System.Windows.Forms.TreeViewEventArgs) Handles StudyTree.AfterSelect
        If TypeOf e.Node Is StudyNode AndAlso Not e.Node Is mLastStudyNode Then
            mLastStudyNode = DirectCast(e.Node, StudyNode)
            RaiseEvent StudyChanged(Me, New StudyChangedEventArgs(mLastStudyNode.Study))
        End If
    End Sub
End Class
