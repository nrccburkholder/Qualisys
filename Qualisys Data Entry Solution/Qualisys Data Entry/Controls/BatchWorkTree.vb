Imports Nrc.Qualisys.QualisysDataEntry.Library
Public Class BatchWorkTree
    Inherits TreeView

#Region " Private Members "
    Private mnuBeginWork As MenuItem
    Private mnuNewBatch As MenuItem
    Private mnuDeleteBatch As MenuItem
    Private mCurrentStage As QDEForm.WorkStage  'The current list type populated
    Private mWorkSection As IWorkSection
    Private WithEvents mnuContext As ContextMenu
#End Region

#Region " BeginWork Event "
    Public Delegate Sub BeginWorkEventHandler(ByVal sender As Object, ByVal e As BeginWorkEventArgs)
    Public Event BeginWork As BeginWorkEventHandler
    Public Class BeginWorkEventArgs
        Private mBatchID As Integer
        Private mTemplateName As String
        Private mWorkStage As QDEForm.WorkStage

        Public ReadOnly Property BatchID() As Integer
            Get
                Return mBatchID
            End Get
        End Property
        Public ReadOnly Property TemplateName() As String
            Get
                Return mTemplateName
            End Get
        End Property
        Public ReadOnly Property WorkStage() As QDEForm.WorkStage
            Get
                Return mWorkStage
            End Get
        End Property

        Sub New(ByVal batchID As Integer, ByVal template As String, ByVal stage As QDEForm.WorkStage)
            mBatchID = batchID
            mTemplateName = template
            mWorkStage = stage
        End Sub
    End Class

    'Method to raise the OnBeginWork event
    Private Sub OnBeginWork(ByVal sender As Object, ByVal e As EventArgs)
        Dim node As BatchNode = DirectCast(Me.SelectedNode, BatchNode)
        RaiseEvent BeginWork(Me, New BeginWorkEventArgs(node.BatchID, node.TemplateName, mCurrentStage))
    End Sub
#End Region

#Region " Public Properties "
    Public Shadows Property SelctedNode() As BatchNode
        Get
            Return DirectCast(MyBase.SelectedNode, BatchNode)
        End Get
        Set(ByVal Value As BatchNode)
            MyBase.SelectedNode = Value
        End Set
    End Property

#End Region

#Region " Constructors "
    Sub New()
        MyBase.New()

        Me.FullRowSelect = True
        Me.HideSelection = False
        Me.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))

        mnuContext = New ContextMenu

        mnuBeginWork = New MenuItem("Begin Work", New EventHandler(AddressOf OnBeginWork))
        mnuContext.MenuItems.Add(mnuBeginWork)

        mnuNewBatch = New MenuItem("New Batch...", New EventHandler(AddressOf AddNewBatchHandler))
        mnuContext.MenuItems.Add(mnuNewBatch)

        mnuDeleteBatch = New MenuItem("Delete Batch", New EventHandler(AddressOf DeleteBatchHandler))
        mnuContext.MenuItems.Add(mnuDeleteBatch)

        Me.ContextMenu = mnuContext
    End Sub

#End Region

#Region " Public Methods "
    'Populate the list with the work to be done for the specified stage
    Public Sub PopulateList(ByVal stage As QDEForm.WorkStage, ByVal workSection As IWorkSection)

        'Store the work section
        mWorkSection = workSection

        'Populate the list
        PopulateList(stage)

    End Sub

    Private Sub PopulateList(ByVal stage As QDEForm.WorkStage)
        Dim tbl As DataTable
        Dim row As DataRow
        Dim batchId As Integer
        Dim batchName As String
        Dim templateName As String
        Dim currentBatch As Integer
        Dim parent As BatchNode = Nothing
        Dim node As BatchNode

        'Store the current stage
        mCurrentStage = stage

        'Get the DataTable
        tbl = Batch.GetBatchWorkList(stage, CurrentUser.LoginName)
        Me.Nodes.Clear()

        'For each record, add a new item
        If Not tbl Is Nothing Then
            For Each row In tbl.Rows

                batchId = CInt(row("Batch_id"))
                batchName = row("strBatchName").ToString
                templateName = row("strTemplateName").ToString

                If Not batchId = currentBatch Then
                    currentBatch = batchId
                    parent = New BatchNode(batchId, batchName)
                    parent.Text = batchName
                    Me.Nodes.Add(parent)
                End If

                node = New BatchNode(batchId, batchName, templateName)
                node.Text = row("Label").ToString
                node.HasWorkForUser = (CInt(row("Available")) > 0)
                If Not node.HasWorkForUser Then
                    node.ForeColor = Color.Gray
                End If
                parent.Nodes.Add(node)
            Next
        End If

        Me.ExpandAll()
    End Sub

    'Refresh the list for the current work stage
    Public Sub RefreshList()
        PopulateList(mCurrentStage)
    End Sub
#End Region

#Region " Event Handlers "
    'When the right mouse button is clicked then just select the node beneath it
    Protected Overrides Sub OnMouseDown(ByVal e As System.Windows.Forms.MouseEventArgs)
        Dim node As BatchNode
        If e.Button = Windows.Forms.MouseButtons.Right Then
            node = DirectCast(Me.GetNodeAt(e.X, e.Y), BatchNode)
            If Not node Is Nothing Then
                Me.SelctedNode = node
            End If
        End If

    End Sub

    'When the context menu pops up we need to check what kind of node was clicked and show appropriate options
    Private Sub mnuContext_Popup(ByVal sender As Object, ByVal e As System.EventArgs) Handles mnuContext.Popup
        'Get the mouse point
        Dim pt As Point = Me.PointToClient(System.Windows.Forms.Cursor.Position)

        'Get the item under mouse
        Dim node As BatchNode = DirectCast(Me.GetNodeAt(pt.X, pt.Y), BatchNode)

        'Determine which items should be shown
        Dim isBatch As Boolean = (Not node Is Nothing) AndAlso (node.NodeType = BatchNode.BatchNodeType.Batch)
        Dim isTemplate As Boolean = (Not node Is Nothing) AndAlso (node.NodeType = BatchNode.BatchNodeType.Template)
        Dim isBlankSpace As Boolean = (node Is Nothing)
        Dim isWorking As Boolean = (Not mWorkSection Is Nothing AndAlso mWorkSection.IsWorking)

        mnuBeginWork.Visible = (isTemplate AndAlso node.HasWorkForUser)
        mnuDeleteBatch.Visible = (isBatch AndAlso CurrentUser.IsAdministrator AndAlso Not isWorking)
        mnuNewBatch.Visible = isBlankSpace AndAlso mCurrentStage = QDEForm.WorkStage.ToBeKeyed
    End Sub

    'Displays the "New Batch" dialog
    Private Sub AddNewBatchHandler(ByVal sender As Object, ByVal e As EventArgs)
        Dim frmNewBatch As New frmNewBatchDialog
        frmNewBatch.ShowDialog()
        RefreshList()
    End Sub

    Private Sub DeleteBatchHandler(ByVal sender As Object, ByVal e As EventArgs)
        Dim node As BatchNode = DirectCast(Me.SelectedNode, BatchNode)
        Try
            Batch.DeleteBatch(node.BatchID)
            RefreshList()
        Catch ex As Exception
            ReportException(ex, "Error Deleting Batch")
        End Try
    End Sub

#End Region



#Region " BatchNode Class "
    Public Class BatchNode
        Inherits TreeNode

        Private mBatchID As Integer
        Private mBatchName As String
        Private mTemplateName As String
        Private mNodeType As BatchNodeType
        Private mHasWorkForUser As Boolean

        Public Enum BatchNodeType
            Batch = 0
            Template
        End Enum


#Region " Public Properties "
        Public Property BatchID() As Integer
            Get
                Return mBatchID
            End Get
            Set(ByVal Value As Integer)
                mBatchID = Value
            End Set
        End Property

        Public Property BatchName() As String
            Get
                Return mBatchName
            End Get
            Set(ByVal Value As String)
                mBatchName = Value
            End Set
        End Property

        Public Property TemplateName() As String
            Get
                Return mTemplateName
            End Get
            Set(ByVal Value As String)
                mTemplateName = Value
            End Set
        End Property

        Public Property NodeType() As BatchNodeType
            Get
                Return mNodeType
            End Get
            Set(ByVal Value As BatchNodeType)
                mNodeType = Value
            End Set
        End Property
        Public Property HasWorkForUser() As Boolean
            Get
                Return mHasWorkForUser
            End Get
            Set(ByVal Value As Boolean)
                mHasWorkForUser = Value
            End Set
        End Property
#End Region

#Region " Constructors "
        Sub New(ByVal batchId As Integer, ByVal batchName As String, ByVal templateName As String)
            Me.New(batchId, batchName)
            mTemplateName = templateName
            mNodeType = BatchNodeType.Template
        End Sub
        Sub New(ByVal batchId As Integer, ByVal batchName As String)
            MyBase.New()
            mBatchID = batchId
            mBatchName = batchName
            mNodeType = BatchNodeType.Batch
        End Sub
#End Region
    End Class

#End Region

End Class
