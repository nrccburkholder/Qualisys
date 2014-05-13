Imports System.ComponentModel
Imports System.Windows.Forms
Imports System.Drawing

Namespace WinForms
    ''' -----------------------------------------------------------------------------
    ''' Project	 : NRC_Common_Classes
    ''' Class	 : WinForms.MultiPane
    ''' 
    ''' -----------------------------------------------------------------------------
    ''' <summary>
    ''' This class is an Outlook 2003 style tab navigation control.  This control renders
    ''' clickable tabs that change the navigation control in the MultiPane and can also
    ''' change the main content of the containing form.
    ''' </summary>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[JCamp]	6/22/2004	Created
    ''' </history>
    ''' -----------------------------------------------------------------------------
    <DefaultEvent("PaneChanged")> _
    Public Class MultiPane
        Inherits System.Windows.Forms.UserControl

#Region " Windows Form Designer generated code "

        Public Sub New()
            MyBase.New()

            Me.SetStyle(ControlStyles.DoubleBuffer Or ControlStyles.UserPaint Or _
            ControlStyles.AllPaintingInWmPaint Or ControlStyles.ResizeRedraw, True)

            'This call is required by the Windows Form Designer.
            InitializeComponent()

            'Add any initialization after the InitializeComponent() call
            InitPen()
            'Handle the ColorSchemeChanged event
            AddHandler ThemeInfo.ColorSchemeChanged, AddressOf OnColorSchemeChanged
        End Sub

        'UserControl overrides dispose to clean up the component list.
        Protected Overloads Overrides Sub Dispose(ByVal disposing As Boolean)
            If disposing Then
                If Not (components Is Nothing) Then
                    components.Dispose()
                End If
                Dim ctrl As Control
                For Each ctrl In Me.Controls
                    If TypeOf ctrl Is MultiPaneTab Then
                        RemoveHandler ctrl.Click, AddressOf TabClick
                    End If
                Next
            End If
            MyBase.Dispose(disposing)
        End Sub

        'Required by the Windows Form Designer
        Private components As System.ComponentModel.IContainer

        'NOTE: The following procedure is required by the Windows Form Designer
        'It can be modified using the Windows Form Designer.  
        'Do not modify it using the code editor.
        Friend WithEvents SectionHeader1 As SectionHeader
        Friend WithEvents ControlPanel As System.Windows.Forms.Panel
        Friend WithEvents SubCaptionLabel As System.Windows.Forms.Label
        Friend WithEvents PaneCaption1 As PaneCaption
        <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
            Me.SectionHeader1 = New SectionHeader
            Me.SubCaptionLabel = New System.Windows.Forms.Label
            Me.ControlPanel = New System.Windows.Forms.Panel
            Me.PaneCaption1 = New PaneCaption
            Me.SectionHeader1.SuspendLayout()
            Me.SuspendLayout()
            '
            'SectionHeader1
            '
            Me.SectionHeader1.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                        Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
            Me.SectionHeader1.Controls.Add(Me.SubCaptionLabel)
            Me.SectionHeader1.Location = New System.Drawing.Point(0, 24)
            Me.SectionHeader1.Name = "SectionHeader1"
            Me.SectionHeader1.Size = New System.Drawing.Size(158, 24)
            Me.SectionHeader1.TabIndex = 1
            '
            'SubCaptionLabel
            '
            Me.SubCaptionLabel.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                        Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
            Me.SubCaptionLabel.BackColor = System.Drawing.Color.Transparent
            Me.SubCaptionLabel.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
            Me.SubCaptionLabel.Location = New System.Drawing.Point(4, 0)
            Me.SubCaptionLabel.Name = "SubCaptionLabel"
            Me.SubCaptionLabel.Size = New System.Drawing.Size(158, 24)
            Me.SubCaptionLabel.TabIndex = 0
            Me.SubCaptionLabel.Text = "Subcaption"
            Me.SubCaptionLabel.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
            '
            'ControlPanel
            '
            Me.ControlPanel.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                        Or System.Windows.Forms.AnchorStyles.Left) _
                        Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
            Me.ControlPanel.BackColor = System.Drawing.Color.Transparent
            Me.ControlPanel.Location = New System.Drawing.Point(0, 48)
            Me.ControlPanel.Name = "ControlPanel"
            Me.ControlPanel.Size = New System.Drawing.Size(160, 152)
            Me.ControlPanel.TabIndex = 2
            '
            'PaneCaption1
            '
            Me.PaneCaption1.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                        Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
            Me.PaneCaption1.Caption = "MultiPane"
            Me.PaneCaption1.Font = New System.Drawing.Font("Tahoma", 12.0!, System.Drawing.FontStyle.Bold)
            Me.PaneCaption1.Location = New System.Drawing.Point(0, 0)
            Me.PaneCaption1.Name = "PaneCaption1"
            Me.PaneCaption1.Size = New System.Drawing.Size(160, 24)
            Me.PaneCaption1.TabIndex = 3
            '
            'MultiPane
            '
            Me.BackColor = System.Drawing.Color.White
            Me.Controls.Add(Me.PaneCaption1)
            Me.Controls.Add(Me.ControlPanel)
            Me.Controls.Add(Me.SectionHeader1)
            Me.Name = "MultiPane"
            Me.Size = New System.Drawing.Size(168, 272)
            Me.SectionHeader1.ResumeLayout(False)
            Me.ResumeLayout(False)

        End Sub

#End Region

#Region " PaneChangedEvent "
        Public Delegate Sub PaneChangedEventHandler(ByVal sender As Object, ByVal e As PaneChangedEventArgs)
        Public Event PaneChanged As PaneChangedEventHandler
        Public Class PaneChangedEventArgs
            Inherits System.EventArgs

            Private mOldTab As MultiPaneTab
            Private mNewTab As MultiPaneTab

            Public ReadOnly Property OldTab() As MultiPaneTab
                Get
                    Return mOldTab
                End Get
            End Property
            Public ReadOnly Property NewTab() As MultiPaneTab
                Get
                    Return mNewTab
                End Get
            End Property

            Public Sub New(ByVal oldTab As MultiPaneTab, ByVal newTab As MultiPaneTab)
                mOldTab = oldTab
                mNewTab = newTab
            End Sub
        End Class
#End Region

#Region " BeforePaneChangeEvent "
        Public Delegate Sub BeforePaneChangeEventHandler(ByVal sender As Object, ByVal e As BeforePaneChangeEventArgs)
        Public Event BeforePaneChange As BeforePaneChangeEventHandler
        Public Class BeforePaneChangeEventArgs
            Inherits System.ComponentModel.CancelEventArgs

            Private mOldTab As MultiPaneTab
            Private mNewTab As MultiPaneTab

            Public ReadOnly Property OldTab() As MultiPaneTab
                Get
                    Return mOldTab
                End Get
            End Property
            Public ReadOnly Property NewTab() As MultiPaneTab
                Get
                    Return mNewTab
                End Get
            End Property

            Public Sub New(ByVal oldTab As MultiPaneTab, ByVal newTab As MultiPaneTab)
                mOldTab = oldTab
                mNewTab = newTab
            End Sub
        End Class
#End Region

        Private mPenBorder As Pen
        Private mCurrentTab As MultiPaneTab
        Private mTabs As New MultiPaneTabCollection
        Private mPaneControl As Control
        Private mHandlersAdded As Boolean = False
        Private mUseThemeColors As Boolean = True

#Region " Public Properties "
        ''' -----------------------------------------------------------------------------
        ''' <summary>
        ''' The subcaption to display in the MultiForm
        ''' </summary>
        ''' <history>
        ''' 	[JCamp]	6/22/2004	Created
        ''' </history>
        ''' -----------------------------------------------------------------------------
        Public Property SubCaption() As String
            Get
                Return Me.SubCaptionLabel.Text
            End Get
            Set(ByVal Value As String)
                Me.SubCaptionLabel.Text = Value
            End Set
        End Property

        ''' -----------------------------------------------------------------------------
        ''' <summary>
        ''' The control that is loaded into the MultiPane navigation area.
        ''' </summary>
        ''' <remarks>
        ''' </remarks>
        ''' <history>
        ''' 	[JCamp]	6/22/2004	Created
        ''' </history>
        ''' -----------------------------------------------------------------------------
        Public Property PaneControl() As Control
            Get
                Return Me.mPaneControl
            End Get
            Set(ByVal Value As Control)
                Me.mPaneControl = Value
            End Set
        End Property


        ''' -----------------------------------------------------------------------------
        ''' <summary>
        ''' The collection of tabs that will be rendered on this control
        ''' </summary>
        ''' <remarks>
        ''' </remarks>
        ''' <history>
        ''' 	[JCamp]	6/22/2004	Created
        ''' </history>
        ''' -----------------------------------------------------------------------------
        <Browsable(True), Description("The collection of pane tabs."), Category("Appearance"), DesignerSerializationVisibility(DesignerSerializationVisibility.Content)> _
        Public Property Tabs() As MultiPaneTabCollection
            Get
                Return mTabs
            End Get
            Set(ByVal Value As MultiPaneTabCollection)
                mTabs = Value
            End Set
        End Property

        ''' -----------------------------------------------------------------------------
        ''' <summary>
        ''' The currently selected tab.
        ''' </summary>
        ''' <returns></returns>
        ''' <remarks>
        ''' </remarks>
        ''' <history>
        ''' 	[JCamp]	6/22/2004	Created
        ''' </history>
        ''' -----------------------------------------------------------------------------
        <Browsable(False), DesignerSerializationVisibility(DesignerSerializationVisibility.Hidden)> _
        Public Property SelectedTab() As MultiPaneTab
            Get
                Return mCurrentTab
            End Get
            Set(ByVal Value As MultiPaneTab)
                Dim oldTab As MultiPaneTab = mCurrentTab
                Dim newTab As MultiPaneTab = Value

                Dim cancelArgs As New BeforePaneChangeEventArgs(oldTab, newTab)

                RaiseEvent BeforePaneChange(Me, cancelArgs)
                If Not cancelArgs.Cancel Then
                    If Not oldTab Is Nothing Then
                        oldTab.Active = False
                    End If

                    mCurrentTab = newTab
                    mCurrentTab.Active = True
                    Me.PaneCaption1.Caption = mCurrentTab.Caption
                    RaiseEvent PaneChanged(Me, New PaneChangedEventArgs(oldTab, newTab))
                End If
            End Set
        End Property


        ''' -----------------------------------------------------------------------------
        ''' <summary>
        ''' Returns the index of the currently selected tab
        ''' </summary>
        ''' <value></value>
        ''' <remarks>
        ''' </remarks>
        ''' <history>
        ''' 	[JCamp]	6/22/2004	Created
        ''' </history>
        ''' -----------------------------------------------------------------------------
        <Browsable(False), DesignerSerializationVisibility(DesignerSerializationVisibility.Hidden)> _
        Public Property SelectedIndex() As Integer
            Get
                If mCurrentTab Is Nothing Then Return -1

                Dim tab As MultiPaneTab
                Dim i As Integer
                For i = 0 To Me.mTabs.Count - 1
                    tab = mTabs(i)
                    If tab Is mCurrentTab Then
                        Return i
                    End If
                Next

                Return -1
            End Get
            Set(ByVal Value As Integer)
                Dim oldTab As MultiPaneTab
                Dim newTab As MultiPaneTab

                If Value < 0 OrElse Value > Me.mTabs.Count - 1 Then
                    Exit Property
                End If
                oldTab = mCurrentTab
                newTab = mTabs(Value)
                Dim e As New BeforePaneChangeEventArgs(oldTab, newTab)

                RaiseEvent BeforePaneChange(Me, e)

                If Not e.Cancel Then
                    If Not oldTab Is Nothing Then
                        oldTab.Active = False
                    End If

                    mCurrentTab = newTab
                    mCurrentTab.Active = True
                    Me.PaneCaption1.Caption = mCurrentTab.Caption
                    RaiseEvent PaneChanged(Me, New PaneChangedEventArgs(oldTab, newTab))
                End If
            End Set
        End Property

        ''' -----------------------------------------------------------------------------
        ''' <summary>
        ''' Returns a reference to the SectionHeader control in the MultiPane.  This can
        ''' be used to dynamically add controls to the SectionHeader
        ''' </summary>
        ''' <history>
        ''' 	[JCamp]	6/22/2004	Created
        ''' </history>
        ''' -----------------------------------------------------------------------------
        Public ReadOnly Property SectionHeader() As SectionHeader
            Get
                Return Me.SectionHeader1
            End Get
        End Property

        <Description("Determines if the Windows XP theme colors should be used.  If true overrides the color properties defined."), Category("Appearance"), DefaultValue(True)> _
        Public Property UseThemeColors() As Boolean
            Get
                Return mUseThemeColors
            End Get
            Set(ByVal Value As Boolean)
                mUseThemeColors = Value
                InitPen()
                Invalidate()
            End Set
        End Property

#End Region

        Private Sub OnColorSchemeChanged(ByVal sender As Object, ByVal e As EventArgs)
            'If the color scheme changes then reinitialize the colors
            InitPen()
        End Sub

        Private Sub InitPen()
            If Not mPenBorder Is Nothing Then mPenBorder.Dispose()

            If Me.mUseThemeColors Then
                mPenBorder = New Pen(ProColors.ToolStripBorder)
            Else
                mPenBorder = New Pen(Color.FromArgb(0, 45, 150))
            End If
        End Sub

        Protected Overrides Sub OnPaint(ByVal e As System.Windows.Forms.PaintEventArgs)
            DrawBorder(e.Graphics)
            PositionTabs()
            MyBase.OnPaint(e)
        End Sub

        Private Sub DrawBorder(ByVal g As Graphics)
            'Top Border
            g.DrawLine(mPenBorder, 0, 0, Me.Width - 1, 0)
            'Bottom Border
            g.DrawLine(mPenBorder, 0, Me.Height - 1, Me.Width - 1, Me.Height - 1)
            'Left Border
            g.DrawLine(mPenBorder, 0, 0, 0, Me.Height - 1)
            'Right Border
            g.DrawLine(mPenBorder, Me.Width - 1, 0, Me.Width - 1, Me.Height - 1)
        End Sub


        Protected Overrides Sub OnLoad(ByVal e As System.EventArgs)
            MyBase.OnLoad(e)

            Dim ctrl As Control
            LoadTabs()

            If Not mHandlersAdded Then
                mHandlersAdded = True
                For Each ctrl In Me.Controls
                    If TypeOf ctrl Is MultiPaneTab Then
                        AddHandler DirectCast(ctrl, MultiPaneTab).Click, AddressOf TabClick
                    End If
                Next
            End If
            PositionCaption()

            If mTabs.Count > 0 Then
                mCurrentTab = mTabs(0)
                mCurrentTab.Active = True
                Me.PaneCaption1.Caption = mCurrentTab.Caption
            End If
        End Sub

        Private Sub TabClick(ByVal sender As Object, ByVal e As EventArgs)
            Dim oldTab As MultiPaneTab = mCurrentTab
            Dim args As New BeforePaneChangeEventArgs(oldTab, sender)

            RaiseEvent BeforePaneChange(Me, args)

            If Not args.Cancel Then
                If Not oldTab Is Nothing Then
                    oldTab.Active = False
                End If
                mCurrentTab = sender
                mCurrentTab.Active = True
                Me.PaneCaption1.Caption = mCurrentTab.Caption
                RaiseEvent PaneChanged(Me, New PaneChangedEventArgs(oldTab, mCurrentTab))
            End If
        End Sub

        Public Sub ReloadTabs()
            Me.LoadTabs()
            Me.PositionCaption()
            Me.Invalidate()
        End Sub

        Private Sub LoadTabs()
            Dim tab As MultiPaneTab
            Me.ClearTabs()

            If Not mTabs Is Nothing Then
                For Each tab In mTabs
                    Me.Controls.Add(tab)
                Next
            End If
        End Sub

        Private Sub ClearTabs()
            Dim ctrl As Control
            Dim clearList As String = ""
            Dim clearCount As Integer = 0
            Dim toDelete() As String
            Dim str As String

            Dim i As Integer
            For i = 0 To Me.Controls.Count - 1
                If TypeOf Me.Controls(i) Is MultiPaneTab Then
                    clearList &= (i - clearCount).ToString & ","
                    clearCount += 1
                End If
            Next

            If clearList.Length > 0 Then
                clearList = clearList.Substring(0, clearList.Length - 1)
                toDelete = clearList.Split(",")

                For Each str In toDelete
                    Me.Controls.RemoveAt(str)
                Next
            End If
        End Sub

        ''' -----------------------------------------------------------------------------
        ''' <summary>
        ''' Loads a control into the navigation area of the MultiPane
        ''' </summary>
        ''' <param name="paneControl">The control to be added to the MultiPane</param>
        ''' <history>
        ''' 	[JCamp]	6/22/2004	Created
        ''' </history>
        ''' -----------------------------------------------------------------------------
        Public Sub LoadControl(ByVal paneControl As Control)
            Me.ControlPanel.Controls.Clear()
            If Not paneControl Is Nothing Then
                paneControl.Anchor = AnchorStyles.Top Or AnchorStyles.Bottom Or AnchorStyles.Left Or AnchorStyles.Right
                paneControl.Location = New Point(0, 0)
                paneControl.Width = ControlPanel.Width
                paneControl.Height = ControlPanel.Height
                Me.ControlPanel.Controls.Add(paneControl)
            End If
        End Sub
        Private Sub PositionTabs()
            Dim tab As MultiPaneTab
            Dim y As Integer = Me.Height - 1

            If Not mTabs Is Nothing Then
                Dim index As Integer = 0
                For index = mTabs.Count - 1 To 0 Step -1
                    tab = mTabs(index)
                    y -= tab.Height
                    tab.Width = Me.Width - 2
                    tab.Location = New System.Drawing.Point(1, y)
                Next
            End If
        End Sub

        Private Sub PositionCaption()
            Dim y As Integer = 0

            Me.PaneCaption1.Location = New Point(1, 1)
            Me.PaneCaption1.Width = Me.Width - 2

            y += Me.PaneCaption1.Height
            Me.SectionHeader1.Location = New Point(1, y + 1)
            Me.SectionHeader1.Width = Me.Width - 2

            y += Me.SectionHeader1.Height
            Me.ControlPanel.Location = New Point(1, y + 1)

            Dim tab As MultiPaneTab
            For Each tab In Me.mTabs
                y += tab.Height
            Next
            Me.ControlPanel.Width = Me.Width - 2
            Me.ControlPanel.Height = Me.Height - y - 2
        End Sub

        Protected Overrides Sub OnSizeChanged(ByVal e As System.EventArgs)
            MyBase.OnSizeChanged(e)
            Me.Invalidate()
        End Sub

    End Class

End Namespace
