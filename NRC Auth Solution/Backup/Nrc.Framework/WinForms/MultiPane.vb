Imports System.ComponentModel
Imports System.Windows.Forms
Imports System.Drawing

Namespace WinForms
    Public Class MultiPane
        Inherits Control

#Region " Private Instance Fields "
        Private Const TAB_HEIGHT As Integer = 32
        Private Const TABTRAY_HEIGHT As Integer = TAB_HEIGHT + 1

        Private WithEvents mTabs As MultiPaneTabCollection
        Private WithEvents mMainPanel As Panel
        Private WithEvents mTopPanel As Panel
        Private WithEvents mNavigationPanel As Panel
        Private WithEvents mBottompanel As Panel
        Private WithEvents mSplitter As NavSplitter
        Private WithEvents mTitleBar As PaneCaption
        Private WithEvents mTabTray As TabTray
        Private WithEvents mToolTip As New System.Windows.Forms.ToolTip()

        Private mMaxShownTabs As Integer = 4
        Private mIsSplitterMoving As Boolean
        Private mSplitterMouseLocation As Point
#End Region

#Region " Public Properties "
        <Description("The collection of tabs in this control"), Category("Data"), DesignerSerializationVisibility(DesignerSerializationVisibility.Content)> _
        Public ReadOnly Property Tabs() As MultiPaneTabCollection
            Get
                Return mTabs
            End Get
        End Property

        <Description("The maximum number of tabs that will be shown."), Category("Appearance")> _
        Public Property MaxShownTabs() As Integer
            Get
                Return mMaxShownTabs
            End Get
            Set(ByVal value As Integer)
                If Not mMaxShownTabs = value Then
                    mMaxShownTabs = value
                    Me.LoadTabs()
                    Me.Invalidate()
                End If
            End Set
        End Property

        <Browsable(False), DesignerSerializationVisibility(DesignerSerializationVisibility.Hidden), EditorBrowsable(EditorBrowsableState.Never)> _
        Public Property SelectedTab() As MultiPaneTab
            Get
                Return mTabs.SelectedTab
            End Get
            Set(ByVal value As MultiPaneTab)
                mTabs.SelectedTab = value
            End Set
        End Property
#End Region

#Region " Private Properties "
        Private ReadOnly Property ShownTabCount() As Integer
            Get
                Return Math.Min(mMaxShownTabs, mTabs.Count)
            End Get
        End Property

        Private ReadOnly Property HiddenTabCount() As Integer
            Get
                Return mTabs.Count - ShownTabCount
            End Get
        End Property

        Private ReadOnly Property TabPanelHeight() As Integer
            Get
                If HiddenTabCount > 0 Then
                    Return (ShownTabCount * TAB_HEIGHT) + TABTRAY_HEIGHT
                Else
                    Return (ShownTabCount * TAB_HEIGHT)
                End If
            End Get
        End Property
#End Region

#Region " Constructors "
        Sub New()
            Me.SetStyle(ControlStyles.OptimizedDoubleBuffer, True)
            Me.Size = New Size(200, 300)
            mMainPanel = New Panel
            mTabs = New MultiPaneTabCollection
            mTopPanel = New Panel
            mNavigationPanel = New Panel
            mBottompanel = New Panel
            mSplitter = New NavSplitter

            mTabTray = New TabTray
            mTabTray.Height = TABTRAY_HEIGHT


            mMainPanel.Name = "mMainPanel"
            mMainPanel.Dock = DockStyle.Fill
            'mMainPanel.BackColor = ProfessionalColors.ToolStripBorder
            mMainPanel.Padding = New Padding(1)

            mTopPanel.Name = "mTopPanel"
            mTopPanel.Height = 26
            mTopPanel.Dock = DockStyle.Top

            mBottompanel.Name = "mBottomPanel"
            mBottompanel.Height = TabPanelHeight
            mBottompanel.Dock = DockStyle.Bottom

            mNavigationPanel.Name = "mNavigationPanel"
            mNavigationPanel.BackColor = Color.White
            mNavigationPanel.Dock = DockStyle.Fill

            mSplitter.Name = "mSplitter"
            mSplitter.Dock = DockStyle.Bottom

            Me.Controls.Add(mMainPanel)
            mMainPanel.Controls.Add(mNavigationPanel)
            mMainPanel.Controls.Add(mTopPanel)
            mMainPanel.Controls.Add(mSplitter)
            mMainPanel.Controls.Add(mBottompanel)

            mTitleBar = New PaneCaption
            mTitleBar.Name = "mTitleBar"
            mTitleBar.Text = "MultiPane Control"
            mTitleBar.Dock = DockStyle.Top
            mTopPanel.Controls.Add(mTitleBar)

            Me.LoadTabs()
        End Sub
#End Region

#Region " Event Declarations "
        Public Event SelectedTabChanging As EventHandler(Of SelectedTabChangingEventArgs)
        Public Event SelectedTabChanged As EventHandler(Of SelectedTabChangedEventArgs)
#End Region

#Region " Event Handlers "
        Private Sub navigationPanel_Paint(ByVal sender As Object, ByVal e As System.Windows.Forms.PaintEventArgs) Handles mNavigationPanel.Paint
            If Me.DesignMode Then
                Using gradBrush As New Drawing2D.LinearGradientBrush(mNavigationPanel.DisplayRectangle, Color.LightGray, Color.White, Drawing2D.LinearGradientMode.BackwardDiagonal)
                    e.Graphics.FillRectangle(gradBrush, mNavigationPanel.DisplayRectangle)
                End Using
                'e.Graphics.FillRectangle(Brushes.White, mNavigationPanel.DisplayRectangle)
                Dim format As New StringFormat
                format.Alignment = StringAlignment.Center
                format.LineAlignment = StringAlignment.Center
                e.Graphics.DrawString("Navigation Control Goes Here", mNavigationPanel.Font, Brushes.Gray, mNavigationPanel.DisplayRectangle, format)
                e.Graphics.DrawRectangle(Pens.Gainsboro, 3, 3, mNavigationPanel.Width - 6, mNavigationPanel.Height - 6)
            End If
        End Sub

        Private Sub mTabs_SelectedTabChanged(ByVal sender As Object, ByVal e As SelectedTabChangedEventArgs) Handles mTabs.SelectedTabChanged
            Me.OnSelectedTabChanged(Me, e)
            If e.NewTab Is Nothing Then
                Me.SetTitleBarText(String.Empty)
            Else
                Me.SetTitleBarText(e.NewTab.Text)
            End If
        End Sub

        Private Sub mTabs_SelectedTabChanging(ByVal sender As Object, ByVal e As SelectedTabChangingEventArgs) Handles mTabs.SelectedTabChanging
            Me.OnSelectedTabChanging(Me, e)
        End Sub

        Private Sub mTabs_TabAdded(ByVal sender As Object, ByVal e As System.EventArgs) Handles mTabs.TabAdded
            Me.RegisterTabEvents()
            Me.LoadTabs()
            Me.Invalidate()
        End Sub

        Private Sub mTabs_TabRemoved(ByVal sender As Object, ByVal e As System.EventArgs) Handles mTabs.TabRemoved
            Me.LoadTabs()
            Me.Invalidate()
        End Sub

        Private Sub mSplitter_MouseDown(ByVal sender As Object, ByVal e As System.Windows.Forms.MouseEventArgs) Handles mSplitter.MouseDown
            If e.Button = Windows.Forms.MouseButtons.Left Then
                mSplitterMouseLocation = System.Windows.Forms.Cursor.Position
                mIsSplitterMoving = True
            End If
        End Sub

        Private Sub mSplitter_MouseUp(ByVal sender As Object, ByVal e As System.Windows.Forms.MouseEventArgs) Handles mSplitter.MouseUp
            If e.Button = Windows.Forms.MouseButtons.Left Then
                mIsSplitterMoving = False
            End If
        End Sub

        Private Sub Splitter_MouseMove(ByVal sender As Object, ByVal e As System.Windows.Forms.MouseEventArgs) Handles mSplitter.MouseMove
            If mIsSplitterMoving Then
                Dim delta As Integer = (mSplitterMouseLocation.Y - System.Windows.Forms.Cursor.Position.Y) \ TAB_HEIGHT
                Dim newTabCount As Integer
                If Not delta = 0 Then
                    newTabCount = mMaxShownTabs + delta
                    If (delta > 0 AndAlso newTabCount <= mTabs.Count) OrElse (delta < 0 AndAlso newTabCount >= 0) Then
                        mSplitterMouseLocation = System.Windows.Forms.Cursor.Position
                        If newTabCount < 0 Then
                            Me.MaxShownTabs = 0
                        ElseIf newTabCount > mTabs.Count Then
                            Me.MaxShownTabs = mTabs.Count
                        Else
                            Me.MaxShownTabs = newTabCount
                        End If
                    End If
                End If
            End If
        End Sub
#End Region

#Region " Private Methods "
        'Private Sub LoadNavigationControl(ByVal selectedTab As MultiPaneTab)
        '    Dim navCtrl As Control

        '    Me.mNavigationPanel.Controls.Clear()
        '    If selectedTab IsNot Nothing AndAlso Not String.IsNullOrEmpty(selectedTab.NavControlTypeName) Then
        '        Dim navKey As String = selectedTab.NavControlTypeName & "_" & selectedTab.NavControlId

        '        If Me.mNavControls.ContainsKey(navKey) Then
        '            navCtrl = Me.mNavControls(navKey)
        '        Else
        '            Dim navTypeName As String = selectedTab.NavControlTypeName
        '            Dim navType As Type = Nothing
        '            navType = System.Type.GetType(navTypeName, True, True)
        '            navCtrl = DirectCast(Activator.CreateInstance(navType), Control)
        '        End If

        '        If navCtrl IsNot Nothing Then
        '            navCtrl.Dock = DockStyle.Fill
        '            Me.mNavigationPanel.Controls.Add(navCtrl)
        '        End If
        '    End If
        'End Sub
        Private Sub LoadTabs()
            mBottompanel.Controls.Clear()
            Me.mToolTip.RemoveAll()
            mBottompanel.Height = TabPanelHeight
            mNavigationPanel.Invalidate()

            Dim y As Integer = 0
            Dim tab As MultiPaneTab
            For i As Integer = 0 To ShownTabCount - 1
                tab = Me.mTabs(i)
                tab.Width = Me.Width
                tab.Height = TAB_HEIGHT
                tab.Location = New Point(0, y)
                tab.Anchor = (AnchorStyles.Left Or AnchorStyles.Right)
                mBottompanel.Controls.Add(tab)
                y += TAB_HEIGHT
            Next

            If HiddenTabCount > 0 Then
                mTabTray.Location = New Point(0, y)
                mTabTray.Width = Me.Width
                mTabTray.Height = TABTRAY_HEIGHT
                mTabTray.Anchor = (AnchorStyles.Left Or AnchorStyles.Right)
                Me.mBottompanel.Controls.Add(mTabTray)

                mTabTray.Controls.Clear()
                Dim miniTabX As Integer = Me.Width - ((TAB_HEIGHT + 3) * HiddenTabCount) - 5
                For i As Integer = ShownTabCount To mTabs.Count - 1
                    tab = Me.mTabs(i)
                    tab.Width = TAB_HEIGHT
                    tab.Height = TAB_HEIGHT
                    tab.Location = New Point(miniTabX, 1)
                    tab.Anchor = AnchorStyles.Right
                    mTabTray.Controls.Add(tab)
                    Me.mToolTip.SetToolTip(tab, tab.Text)
                    miniTabX += TAB_HEIGHT + 3
                Next
            End If
        End Sub

        Private Sub RegisterTabEvents()
            For Each tab As MultiPaneTab In mTabs
                RemoveHandler tab.TextChanged, AddressOf TabTextChanged
                AddHandler tab.TextChanged, AddressOf TabTextChanged
            Next
        End Sub

        Private Sub TabTextChanged(ByVal sender As Object, ByVal e As EventArgs)
            Dim tab As MultiPaneTab = TryCast(sender, MultiPaneTab)
            If mTabs.SelectedTab Is tab Then
                Me.SetTitleBarText(tab.Text)
            End If
        End Sub
#End Region

#Region " Protected Methods "
        Protected Sub OnSelectedTabChanging(ByVal sender As Object, ByVal e As SelectedTabChangingEventArgs)
            RaiseEvent SelectedTabChanging(sender, e)
        End Sub

        Protected Sub OnSelectedTabChanged(ByVal sender As Object, ByVal e As SelectedTabChangedEventArgs)
            RaiseEvent SelectedTabChanged(sender, e)
        End Sub
#End Region

#Region " NavSplitter Class "
        Private Class NavSplitter
            Inherits Control

            Private Const GRIPPER_WIDTH As Integer = 35
            Private Const GRIP_COUNT As Integer = 9
            Private mFillBrush As System.Drawing.Drawing2D.LinearGradientBrush

            Sub New()
                Me.Size = New Size(100, 7)
                Me.Cursor = Cursors.SizeNS
                Me.SetStyle(ControlStyles.ResizeRedraw Or ControlStyles.OptimizedDoubleBuffer, True)
                Me.InitBrushes()
                AddHandler ThemeInfo.ColorSchemeChanged, AddressOf OnColorSchemeChanged
            End Sub

            Private Sub InitBrushes()
                If mFillBrush IsNot Nothing Then mFillBrush.Dispose()

                mFillBrush = New Drawing2D.LinearGradientBrush(Me.DisplayRectangle, ProfessionalColors.OverflowButtonGradientMiddle, ProfessionalColors.OverflowButtonGradientEnd, Drawing2D.LinearGradientMode.Vertical)
            End Sub

            Protected Overrides Sub OnPaint(ByVal e As System.Windows.Forms.PaintEventArgs)
                MyBase.OnPaint(e)
                Dim gripperStart As Integer = (Me.Width \ 2) - (GRIPPER_WIDTH \ 2)
                e.Graphics.FillRectangle(mFillBrush, Me.DisplayRectangle)

                For i As Integer = 0 To GRIP_COUNT - 1
                    Dim gripStart As Integer = gripperStart + (i * 4)
                    e.Graphics.FillRectangle(Brushes.Black, gripStart, 1, 2, 2)
                Next

                gripperStart += 1

                For i As Integer = 0 To GRIP_COUNT - 1
                    Dim gripStart As Integer = gripperStart + (i * 4)
                    e.Graphics.FillRectangle(Brushes.White, gripStart, 2, 2, 2)
                Next
                For i As Integer = 0 To GRIP_COUNT - 1
                    Dim gripStart As Integer = gripperStart + (i * 4)
                    e.Graphics.FillRectangle(Brushes.Gray, gripStart, 2, 1, 1)
                Next

            End Sub

            Private Sub OnColorSchemeChanged(ByVal sender As Object, ByVal e As EventArgs)
                Me.InitBrushes()
                Me.Invalidate()
            End Sub
        End Class
#End Region

#Region " TabTrayClass "
        Friend Class TabTray
            Inherits Control

            Private mBorderPen As Pen
            Private mFillBrush As Drawing2D.LinearGradientBrush

            Sub New()
                Me.Size = New Size(150, TAB_HEIGHT)
                Me.InitBrushes()
                AddHandler ThemeInfo.ColorSchemeChanged, AddressOf OnColorSchemeChanged
            End Sub

            Private Sub InitBrushes()
                If mFillBrush IsNot Nothing Then mFillBrush.Dispose()
                If mBorderPen IsNot Nothing Then mBorderPen.Dispose()

                If Application.RenderWithVisualStyles Then
                    mFillBrush = New Drawing2D.LinearGradientBrush(Me.DisplayRectangle, ProfessionalColors.ToolStripGradientBegin, ProfessionalColors.ToolStripGradientEnd, Drawing2D.LinearGradientMode.Vertical)
                    mBorderPen = New Pen(ProfessionalColors.ToolStripBorder)
                Else
                    mFillBrush = New Drawing2D.LinearGradientBrush(Me.DisplayRectangle, Color.White, Color.FromArgb(213, 209, 201), Drawing2D.LinearGradientMode.Vertical)
                    mBorderPen = New Pen(Color.Gray)
                End If
            End Sub

            Protected Overrides Sub OnPaint(ByVal e As System.Windows.Forms.PaintEventArgs)
                MyBase.OnPaint(e)
                e.Graphics.FillRectangle(mFillBrush, Me.DisplayRectangle)
                e.Graphics.DrawLine(mBorderPen, 0, 0, Me.Width, 0)
            End Sub

            Protected Overrides Sub OnResize(ByVal e As System.EventArgs)
                MyBase.OnResize(e)
                Me.InitBrushes()
                Me.Invalidate()
            End Sub

            Private Sub OnColorSchemeChanged(ByVal sender As Object, ByVal e As EventArgs)
                Me.InitBrushes()
                Me.Invalidate()
            End Sub

        End Class
#End Region

        Public Sub LoadNavigationControl(ByVal ctrl As Control)
            Me.mNavigationPanel.Controls.Clear()
            If ctrl IsNot Nothing Then
                ctrl.Dock = DockStyle.Fill
                Me.mNavigationPanel.Controls.Add(ctrl)
            End If
        End Sub
        Protected Overrides Sub InitLayout()
            MyBase.InitLayout()
            Me.LoadTabs()
            Me.Invalidate()
            If mTabs.SelectedTab IsNot Nothing Then
                Me.SetTitleBarText(mTabs.SelectedTab.Text)
            End If
        End Sub

        Private Sub SetTitleBarText(ByVal text As String)
            Me.mTitleBar.Text = text
            Me.mTitleBar.Invalidate()
        End Sub

        Private Sub mMainPanel_Paint(ByVal sender As Object, ByVal e As System.Windows.Forms.PaintEventArgs) Handles mMainPanel.Paint
            Dim rect As New Rectangle(0, 0, Me.mMainPanel.Width - 1, Me.mMainPanel.Height - 1)
            If Application.RenderWithVisualStyles Then
                Using borderPen As New Pen(ProfessionalColors.ToolStripBorder)
                    e.Graphics.DrawRectangle(borderPen, rect)
                End Using
            Else
                Using borderPen As New Pen(Color.Gray)
                    e.Graphics.DrawRectangle(borderPen, rect)
                End Using
            End If
        End Sub
    End Class

End Namespace
