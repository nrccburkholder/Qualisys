Imports System.Windows.Forms.Design
Imports System.ComponentModel
Imports System.Drawing
Imports System.Drawing.Drawing2D

<Designer(GetType(ParentControlDesigner))> _
Public Class StackStripPanel

    Private WithEvents mItems As New StackStripPanelItemCollection

    <DesignerSerializationVisibility(DesignerSerializationVisibility.Content)> _
    Public ReadOnly Property Items() As StackStripPanelItemCollection
        Get
            Return mItems
        End Get
    End Property

    Public Event SelectedItemChanged As EventHandler

    Private mMaxVisibleItemCount As Integer = 4
    Private mVisibleItemCount As Integer = -1
    Private mLowerPanelHeight As Integer
    Private mIsSplitterInitialized As Boolean
    Private mButtonSet As New List(Of ButtonRelation)
    Private mSelectedItem As ToolStripButton

#Region " Button Relation Code "
    Private Class ButtonRelation
        Private mItem As StackStripPanelItem
        Private mButton As ToolStripButton
        Private mOverflowButton As ToolStripButton

        Public ReadOnly Property Item() As StackStripPanelItem
            Get
                Return mItem
            End Get
        End Property

        Public ReadOnly Property Button() As ToolStripButton
            Get
                Return mButton
            End Get
        End Property

        Public ReadOnly Property OverflowButton() As ToolStripButton
            Get
                Return mOverflowButton
            End Get
        End Property

        Public Sub New(ByVal item As StackStripPanelItem, ByVal button As ToolStripButton, ByVal overflowButton As ToolStripButton)
            Me.mItem = item
            Me.mButton = button
            Me.mOverflowButton = overflowButton
        End Sub
    End Class
    Private Function FindRelationByItem(ByVal item As StackStripPanelItem) As ButtonRelation
        For Each relation As ButtonRelation In mButtonSet
            If relation.Item Is item Then
                Return relation
            End If
        Next

        Return Nothing
    End Function
    Private Function FindRelationByButton(ByVal btn As ToolStripButton) As ButtonRelation
        For Each relation As ButtonRelation In mButtonSet
            If relation.Button Is btn Then
                Return relation
            End If
        Next

        Return Nothing
    End Function
    Private Function FindRelationByOverflowButton(ByVal btn As ToolStripButton) As ButtonRelation
        For Each relation As ButtonRelation In mButtonSet
            If relation.OverflowButton Is btn Then
                Return relation
            End If
        Next

        Return Nothing
    End Function

#End Region

    Public Sub New()
        Me.TabStop = False

        ' This call is required by the Windows Form Designer.
        InitializeComponent()
        Me.OverFlowStrip.CanOverflow = True
    End Sub

    Public Property MaximumItemsDisplayed() As Integer
        Get
            Return Me.mMaxVisibleItemCount
        End Get
        Set(ByVal value As Integer)
            Me.mMaxVisibleItemCount = value
            Me.InitializeSplitter(Math.Min(Me.mItems.Count, Me.mMaxVisibleItemCount))
        End Set
    End Property

    Private Sub ItemAdded(ByVal sender As Object, ByVal e As EventArgs) Handles mItems.ItemAdded, mItems.ItemRemoved
        If Me.mIsSplitterInitialized Then
            Me.LoadItems()

            Me.InitializeSplitter(Math.Max(Me.mVisibleItemCount, Math.Min(Me.mItems.Count, Me.mMaxVisibleItemCount)))
            Me.SetOverflowButtonVisibility()
        End If
    End Sub

    Private Sub LoadItems()
        For Each item As StackStripPanelItem In Me.mItems
            If Me.FindRelationByItem(item) Is Nothing Then
                'Create main toolstrip button
                Dim stripButton As New ToolStripButton(item.Text, item.Image)
                stripButton.CheckOnClick = True
                stripButton.ImageAlign = ContentAlignment.MiddleLeft
                stripButton.ImageTransparentColor = item.ImageTransparentColor
                stripButton.Margin = New Padding(0)
                stripButton.Padding = New Padding(2)

                'Create overflow strip button
                Dim overflowButton As New ToolStripButton(item.Text, item.Image)
                overflowButton.ImageTransparentColor = item.ImageTransparentColor
                overflowButton.DisplayStyle = ToolStripItemDisplayStyle.Image
                overflowButton.Alignment = ToolStripItemAlignment.Right
                overflowButton.CheckOnClick = False
                overflowButton.Visible = False
                AddHandler overflowButton.Click, AddressOf OverflowItemClicked

                'Add the buttons
                Me.StackStrip1.Items.Add(stripButton)
                Me.OverFlowStrip.Items.Insert(1, overflowButton)
                'Me.mButtonPairs.Add(stripButton, overflowButton)
                Me.mButtonSet.Add(New ButtonRelation(item, stripButton, overflowButton))
            End If
        Next

        If Me.StackStrip1.SelectedButton Is Nothing Then
            If Me.mSelectedItem Is Nothing Then
                Me.StackStrip1.SelectedButton = TryCast(Me.StackStrip1.Items(0), ToolStripButton)
            Else
                Me.StackStrip1.SelectedButton = Me.mSelectedItem
            End If
        End If
    End Sub

    Private Sub StackStripPanel_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Me.LoadItems()

        'Set height
        Me.InitializeSplitter(Me.mMaxVisibleItemCount)

        'Set parent padding
        'Me.Parent.Padding = New Padding(3, 3, 0, 3)
        Me.Padding = New Padding(1)
    End Sub

    Protected Overrides Sub OnPaint(ByVal e As System.Windows.Forms.PaintEventArgs)
        MyBase.OnPaint(e)

        Dim rect As New Rectangle(0, 0, Me.Width - 1, Me.Height - 1)
        e.Graphics.DrawRectangle(SystemPens.ControlDarkDark, rect)
    End Sub

    Private Sub OverflowItemClicked(ByVal sender As Object, ByVal e As EventArgs)
        Dim btn As ToolStripButton = TryCast(sender, ToolStripButton)
        Dim relation As ButtonRelation = Me.FindRelationByOverflowButton(btn)
        If relation IsNot Nothing Then
            relation.Button.Checked = True
        End If
    End Sub

    Private Sub SplitContainer1_Paint(ByVal sender As Object, ByVal e As System.Windows.Forms.PaintEventArgs) Handles StackStripSplitter.Paint
        Dim pct As ProfessionalColorTable = New ProfessionalColorTable
        Dim rect As Rectangle = CType(sender, SplitContainer).SplitterRectangle
        Dim squares As Integer
        Dim maxSquares As Integer = 9
        Dim squareSize As Integer = 4
        Dim boxSize As Integer = 2
        ' Make sure we need to do work
        If ((rect.Width > 0) _
                    AndAlso (rect.Height > 0)) Then
            Dim g As Graphics = e.Graphics
            ' Setup colors from the provided renderer
            Dim begin As Color = pct.OverflowButtonGradientMiddle
            Dim endColor As Color = pct.OverflowButtonGradientEnd
            ' Make sure we need to do work
            Dim b As Brush = New LinearGradientBrush(rect, begin, endColor, LinearGradientMode.Vertical)
            g.FillRectangle(b, rect)
            ' Calculate squares
            If ((rect.Width > squareSize) AndAlso (rect.Height > squareSize)) Then
                squares = Math.Min((rect.Width \ squareSize), maxSquares)

                ' Calculate start
                Dim start As Integer = ((rect.Width - (squares * squareSize)) \ 2)
                Dim Y As Integer = (rect.Y + 1)
                ' Get brushes
                Dim dark As Brush = New SolidBrush(pct.GripDark)
                Dim middle As Brush = New SolidBrush(pct.ToolStripBorder)
                Dim light As Brush = New SolidBrush(pct.ToolStripDropDownBackground)
                ' Draw
                Dim idx As Integer = 0
                Do While (idx < squares)
                    ' Draw grips
                    g.FillRectangle(dark, start, Y, boxSize, boxSize)
                    g.FillRectangle(light, (start + 1), (Y + 1), boxSize, boxSize)
                    g.FillRectangle(middle, (start + 1), (Y + 1), 1, 1)
                    start = (start + squareSize)
                    idx = (idx + 1)
                Loop
                dark.Dispose()
                middle.Dispose()
                light.Dispose()
            End If
        End If

    End Sub

    Private Sub StackStrip1_ItemHeightChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        Me.InitializeSplitter(Me.mVisibleItemCount)
    End Sub

    Private Sub SplitContainer1_SplitterMoved(ByVal sender As Object, ByVal e As System.Windows.Forms.SplitterEventArgs) Handles StackStripSplitter.SplitterMoved
        Debug.WriteLine("Splitter moved to (" & e.SplitX & "," & e.SplitY & ")")
        If Me.mIsSplitterInitialized AndAlso Me.StackStrip1.ItemHeight > 0 Then
            Me.mVisibleItemCount = Me.StackStrip1.Height \ Me.StackStrip1.ItemHeight

            Me.SetOverflowButtonVisibility()
        End If
    End Sub

    Private Sub SetOverflowButtonVisibility()
        For i As Integer = 0 To Me.StackStrip1.Items.Count - 1
            Dim btn As ToolStripButton = TryCast(Me.StackStrip1.Items(i), ToolStripButton)

            If i < Me.mVisibleItemCount Then
                Me.FindRelationByButton(btn).OverflowButton.Visible = False
                'Me.mButtonPairs(btn).Visible = False
            Else
                Me.FindRelationByButton(btn).OverflowButton.Visible = True
                'Me.mButtonPairs(btn).Visible = True
            End If
        Next
    End Sub
    Private Sub InitializeSplitter(ByVal itemsVisible As Integer)
        If (Me.StackStrip1.ItemHeight >= 0) Then

            ' Set slider increment
            Me.StackStripSplitter.SplitterIncrement = Me.StackStrip1.ItemHeight

            ' Find visible count
            'If mVisibleCount < 0 Then mVisibleCount = Me.StackStrip1.InitialDisplayCount
            mVisibleItemCount = itemsVisible

            ' Set Overflow strip height
            Me.OverFlowStrip.Height = Me.StackStrip1.ItemHeight

            ' calculate the splitter distance
            Me.mLowerPanelHeight = Me.StackStripSplitter.SplitterWidth + (itemsVisible * Me.StackStrip1.ItemHeight) + Me.OverFlowStrip.Height
            Dim distance As Integer = Me.StackStripSplitter.Height - Me.mLowerPanelHeight

            ' Set Max
            'Me.mMaxHeight = Me.mLowerPanelHeight

            'If the control is sized to small than the distance could be negative
            If (distance < 0) Then distance = (Me.StackStrip1.ItemHeight + Me.OverFlowStrip.Height)

            ' Set Min/Max
            Dim lowerHalfMaxSize As Integer = (Me.StackStrip1.Items.Count * Me.StackStrip1.ItemHeight) + Me.OverFlowStrip.Height
            Dim lowerHalfMinSize As Integer = Me.OverFlowStrip.Height
            Dim upperHalfMaxSize As Integer = Me.StackStripSplitter.Height - lowerHalfMaxSize - Me.StackStripSplitter.SplitterWidth

            Me.StackStripSplitter.Panel2MinSize = lowerHalfMinSize

            If upperHalfMaxSize > 0 Then
                Me.StackStripSplitter.Panel1MinSize = upperHalfMaxSize
            End If

            Me.mIsSplitterInitialized = True

            'Set the splitter distance
            Me.StackStripSplitter.SplitterDistance = distance
        End If
    End Sub

    Private Sub StackStripSplitter_Resize(ByVal sender As Object, ByVal e As System.EventArgs) Handles StackStripSplitter.Resize
        If Me.mIsSplitterInitialized Then Me.InitializeSplitter(Me.mVisibleItemCount)
    End Sub

    Private Sub ControlPanel_Paint(ByVal sender As Object, ByVal e As System.Windows.Forms.PaintEventArgs) Handles ControlPanel.Paint
        Using gradBrush As New Drawing2D.LinearGradientBrush(ControlPanel.DisplayRectangle, Color.LightGray, Color.White, Drawing2D.LinearGradientMode.BackwardDiagonal)
            e.Graphics.FillRectangle(gradBrush, ControlPanel.DisplayRectangle)
        End Using

        Dim format As New StringFormat
        format.Alignment = StringAlignment.Center
        format.LineAlignment = StringAlignment.Center
        e.Graphics.DrawString("Navigation Control Goes Here", ControlPanel.Font, Brushes.Gray, ControlPanel.DisplayRectangle, format)
        e.Graphics.DrawRectangle(Pens.Gainsboro, 3, 3, ControlPanel.Width - 6, ControlPanel.Height - 6)
    End Sub

    Private Sub StackStrip1_SelectedItemChanged(ByVal sender As Object, ByVal e As WinForms.SelectedItemChangedEventArgs) Handles StackStrip1.SelectedItemChanged
        Dim oldButton As ToolStripButton = TryCast(e.OldItem, ToolStripButton)
        Dim newButton As ToolStripButton = TryCast(e.NewItem, ToolStripButton)

        If oldButton IsNot Nothing Then
            Me.FindRelationByButton(oldButton).OverflowButton.Checked = False
        End If
        If newButton IsNot Nothing Then
            Me.FindRelationByButton(newButton).OverflowButton.Checked = True
        End If

        If mSelectedItem IsNot newButton Then
            Me.mSelectedItem = newButton
            RaiseEvent SelectedItemChanged(Me, EventArgs.Empty)
        End If
    End Sub

    Private Sub ShowMoreButtonsToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ShowMoreButtonsToolStripMenuItem.Click
        Me.MaximumItemsDisplayed += 1
    End Sub

    Private Sub ShowFewerButtonsToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ShowFewerButtonsToolStripMenuItem.Click
        If Me.MaximumItemsDisplayed > 0 Then
            Me.MaximumItemsDisplayed -= 1
        End If
    End Sub
End Class
