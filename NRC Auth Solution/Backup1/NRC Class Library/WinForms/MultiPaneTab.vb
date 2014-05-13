' Custom control that draws the caption for each pane. Contains an active 
' state and draws the caption different for each state. Caption is drawn
' with a gradient fill and antialias font.

Imports System.Drawing.Drawing2D
Imports System.ComponentModel
Imports System.Drawing
Imports System.Windows.Forms

Namespace WinForms
    ''' -----------------------------------------------------------------------------
    ''' Project	 : NRC_Common_Classes
    ''' Class	 : WinForms.MultiPaneTab
    ''' 
    ''' -----------------------------------------------------------------------------
    ''' <summary>
    ''' This class represents a single tab in the MultiPane control
    ''' </summary>
    ''' <history>
    ''' 	[JCamp]	6/22/2004	Created
    ''' </history>
    ''' -----------------------------------------------------------------------------
    Public Class MultiPaneTab
        Inherits System.Windows.Forms.Control

#Region " Windows Form Designer generated code "

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
        <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
            '
            'MultiPaneTab
            '
            Me.Cursor = System.Windows.Forms.Cursors.Hand
            Me.Name = "MultiPaneTab"
            Me.Size = New System.Drawing.Size(150, 36)

        End Sub

#End Region

#Region " Private Members "
        ' const values
        Private Const DEFAULTHEIGHT As Integer = 36
        Private Const DEFAULTFONTNAME As String = "Tahoma"
        Private Const DEFAULTFONTSIZE As Integer = 10

        ' internal members
        Private mActive As Boolean = False
        Private mHover As Boolean = False
        Private mAntiAlias As Boolean = True
        Private mAllowActive As Boolean = True
        Private mText As String = ""
        Private mUseThemeColors As Boolean = True

        Private mColorActiveText As Color = Color.Black
        Private mColorInactiveActiveText As Color = Color.Black

        Private mColorActiveLow As Color = Color.FromArgb(238, 149, 21)
        Private mColorActiveHigh As Color = Color.FromArgb(251, 230, 148)
        Private mColorInactiveLow As Color = Color.FromArgb(125, 165, 224)
        Private mColorInactiveHigh As Color = Color.FromArgb(203, 225, 252)
        Private mColorHoverLow As Color = Color.FromArgb(247, 218, 124)
        Private mColorHoverHigh As Color = Color.FromArgb(232, 127, 8)
        Private mPenTop As Pen

        ' gdi objects
        Private mBrushActiveText As SolidBrush
        Private mBrushInactiveText As SolidBrush
        Private mBrushActive As LinearGradientBrush
        Private mBrushInactive As LinearGradientBrush
        Private mBrushHover As LinearGradientBrush
        Private mFormat As StringFormat

        Private mIcon As Icon
        Private mIconWidth As Integer = 32
        Private mIconHeight As Integer = 32
#End Region

#Region " Public Properties "

        ''' -----------------------------------------------------------------------------
        ''' <summary>
        ''' The text to be displayed on the tab
        ''' </summary>
        ''' <history>
        ''' 	[JCamp]	6/22/2004	Created
        ''' </history>
        ''' -----------------------------------------------------------------------------
        <Description("Text displayed in the caption."), Category("Appearance"), DefaultValue("")> _
        Public Property Caption() As String
            Get
                Return mText
            End Get

            Set(ByVal value As String)
                mText = value
                Invalidate()
            End Set
        End Property

        ''' -----------------------------------------------------------------------------
        ''' <summary>
        ''' The text to be displayed on the tab
        ''' </summary>
        ''' <history>
        ''' 	[JCamp]	6/22/2004	Created
        ''' </history>
        ''' -----------------------------------------------------------------------------
        Public Overrides Property Text() As String
            Get
                Return Me.Caption
            End Get
            Set(ByVal Value As String)
                Me.Caption = Value
            End Set
        End Property

        ''' -----------------------------------------------------------------------------
        ''' <summary>
        ''' Returns true if the tab is currently active (selected)
        ''' </summary>
        ''' <history>
        ''' 	[JCamp]	6/22/2004	Created
        ''' </history>
        ''' -----------------------------------------------------------------------------
        <Description("The active state of the caption, draws the caption with different gradient colors."), Category("Appearance"), DefaultValue(False)> _
        Public Property Active() As Boolean
            Get
                Return mActive
            End Get
            Set(ByVal value As Boolean)
                mActive = value
                Invalidate()
            End Set
        End Property

        ''' -----------------------------------------------------------------------------
        ''' <summary>
        ''' Determines if the control needs to change between active and inactive states
        ''' </summary>
        ''' <history>
        ''' 	[JCamp]	6/22/2004	Created
        ''' </history>
        ''' -----------------------------------------------------------------------------
        <Description("True always uses the inactive state colors, false maintains an active and inactive state."), Category("Appearance"), DefaultValue(True)> _
        Public Property AllowActive() As Boolean
            Get
                Return mAllowActive
            End Get
            Set(ByVal value As Boolean)
                mAllowActive = value
                Invalidate()
            End Set
        End Property

        <Description("Determines if the Windows XP theme colors should be used.  If true overrides the color properties defined."), Category("Appearance"), DefaultValue(True)> _
        Public Property UseThemeColors() As Boolean
            Get
                Return mUseThemeColors
            End Get
            Set(ByVal Value As Boolean)
                mUseThemeColors = Value
                CreateGradientBrushes()
                Invalidate()
            End Set
        End Property

        ''' -----------------------------------------------------------------------------
        ''' <summary>
        ''' Determines if Anti-Aliasing should be used to render the text on the control
        ''' </summary>
        ''' <history>
        ''' 	[JCamp]	6/22/2004	Created
        ''' </history>
        ''' -----------------------------------------------------------------------------
        <Description("If should draw the text as antialiased."), Category("Appearance"), DefaultValue(True)> _
        Public Property AntiAlias() As Boolean
            Get
                Return mAntiAlias
            End Get
            Set(ByVal value As Boolean)
                mAntiAlias = value
                Invalidate()
            End Set
        End Property

        ''' -----------------------------------------------------------------------------
        ''' <summary>
        ''' The icon to be displayed on the tab control
        ''' </summary>
        ''' <history>
        ''' 	[JCamp]	6/22/2004	Created
        ''' </history>
        ''' -----------------------------------------------------------------------------
        <Browsable(True), Description("The icon to display with the tab."), Category("Appearance")> _
        Public Property Icon() As Icon
            Get
                Return Me.mIcon
            End Get
            Set(ByVal Value As Icon)
                Me.mIcon = Value
            End Set
        End Property

        ''' -----------------------------------------------------------------------------
        ''' <summary>
        ''' The width of the icon to be displayed
        ''' </summary>
        ''' <history>
        ''' 	[JCamp]	6/22/2004	Created
        ''' </history>
        ''' -----------------------------------------------------------------------------
        <Browsable(True), Description("The width of the icon to be displayed."), Category("Appearance")> _
        Public Property IconWidth() As Integer
            Get
                Return mIconWidth
            End Get
            Set(ByVal Value As Integer)
                mIconWidth = Value
            End Set
        End Property
        ''' -----------------------------------------------------------------------------
        ''' <summary>
        ''' The height of the icon to be displayed
        ''' </summary>
        ''' <history>
        ''' 	[JCamp]	6/22/2004	Created
        ''' </history>
        ''' -----------------------------------------------------------------------------
        <Browsable(True), Description("The height of the icon to be displayed."), Category("Appearance")> _
        Public Property IconHeight() As Integer
            Get
                Return mIconHeight
            End Get
            Set(ByVal Value As Integer)
                mIconHeight = Value
            End Set
        End Property




#Region " color properties "

        ''' -----------------------------------------------------------------------------
        <Description("Color of the text when active."), Category("Appearance"), DefaultValue(GetType(Color), "Black")> _
        Public Property ActiveTextColor() As Color
            Get
                Return mColorActiveText
            End Get
            Set(ByVal Value As Color)
                If Value.Equals(Color.Empty) Then Value = Color.Black
                mColorActiveText = Value
                mBrushActiveText = New SolidBrush(mColorActiveText)
                Invalidate()
            End Set
        End Property

        ''' -----------------------------------------------------------------------------
        ''' <summary>
        ''' The color of the text when the tab is inactive
        ''' </summary>
        ''' <history>
        ''' 	[JCamp]	6/22/2004	Created
        ''' </history>
        ''' -----------------------------------------------------------------------------
        <Description("Color of the text when inactive."), Category("Appearance"), DefaultValue(GetType(Color), "White")> _
        Public Property InactiveTextColor() As Color
            Get
                Return mColorInactiveActiveText
            End Get
            Set(ByVal Value As Color)
                If Value.Equals(Color.Empty) Then Value = Color.White
                mColorInactiveActiveText = Value
                mBrushInactiveText = New SolidBrush(mColorInactiveActiveText)
                Invalidate()
            End Set
        End Property


        ''' -----------------------------------------------------------------------------
        ''' <summary>
        ''' The bottom color of the tab gradient when the tab is active
        ''' </summary>
        ''' <history>
        ''' 	[JCamp]	6/22/2004	Created
        ''' </history>
        ''' -----------------------------------------------------------------------------
        <Description("Low color of the active gradient."), Category("Appearance"), DefaultValue(GetType(Color), "255, 165, 78")> _
        Public Property ActiveGradientLowColor() As Color
            Get
                Return mColorActiveLow
            End Get
            Set(ByVal Value As Color)
                If Value.Equals(Color.Empty) Then Value = Color.FromArgb(255, 165, 78)
                mColorActiveLow = Value
                CreateGradientBrushes()
                Invalidate()
            End Set
        End Property


        ''' -----------------------------------------------------------------------------
        ''' <summary>
        ''' The top color of the tab gradient when the tab is active
        ''' </summary>
        ''' <history>
        ''' 	[JCamp]	6/22/2004	Created
        ''' </history>
        ''' -----------------------------------------------------------------------------
        <Description("High color of the active gradient."), Category("Appearance"), DefaultValue(GetType(Color), "255, 225, 155")> _
        Public Property ActiveGradientHighColor() As Color
            Get
                Return mColorActiveHigh
            End Get
            Set(ByVal Value As Color)
                If Value.Equals(Color.Empty) Then Value = Color.FromArgb(255, 225, 155)
                mColorActiveHigh = Value
                CreateGradientBrushes()
                Invalidate()
            End Set
        End Property


        ''' -----------------------------------------------------------------------------
        ''' <summary>
        ''' The bottom color of the tab gradient when the tab is inactive
        ''' </summary>
        ''' <history>
        ''' 	[JCamp]	6/22/2004	Created
        ''' </history>
        ''' -----------------------------------------------------------------------------
        <Description("Low color of the inactive gradient."), Category("Appearance"), DefaultValue(GetType(Color), "3, 55, 145")> _
          Public Property InactiveGradientLowColor() As Color
            Get
                Return mColorInactiveLow
            End Get
            Set(ByVal Value As Color)
                If Value.Equals(Color.Empty) Then Value = Color.FromArgb(3, 55, 145)
                mColorInactiveLow = Value
                CreateGradientBrushes()
                Invalidate()
            End Set
        End Property

        ''' -----------------------------------------------------------------------------
        ''' <summary>
        ''' The top color of the tab gradient when the tab is inactive
        ''' </summary>
        ''' <history>
        ''' 	[JCamp]	6/22/2004	Created
        ''' </history>
        ''' -----------------------------------------------------------------------------
        <Description("High color of the inactive gradient."), Category("Appearance"), DefaultValue(GetType(Color), "90, 135, 215")> _
          Public Property InactiveGradientHighColor() As Color
            Get
                Return mColorInactiveHigh
            End Get
            Set(ByVal Value As Color)
                If Value.Equals(Color.Empty) Then Value = Color.FromArgb(90, 135, 215)
                mColorInactiveHigh = Value
                CreateGradientBrushes()
                Invalidate()
            End Set
        End Property

        ''' -----------------------------------------------------------------------------
        ''' <summary>
        ''' The bottom color of the tab gradient when the mouse is hovering over the tab
        ''' </summary>
        ''' <history>
        ''' 	[JCamp]	6/22/2004	Created
        ''' </history>
        ''' -----------------------------------------------------------------------------
        <Description("Low color of the hover gradient."), Category("Appearance"), DefaultValue(GetType(Color), "3, 55, 145")> _
        Public Property HoverGradientLowColor() As Color
            Get
                Return mColorHoverLow
            End Get
            Set(ByVal Value As Color)
                If Value.Equals(Color.Empty) Then Value = Color.FromArgb(3, 55, 145)
                mColorHoverLow = Value
                CreateGradientBrushes()
                Invalidate()
            End Set
        End Property

        ''' -----------------------------------------------------------------------------
        ''' <summary>
        ''' The top color of the tab gradient when the mouse is hovering over the tab
        ''' </summary>
        ''' <history>
        ''' 	[JCamp]	6/22/2004	Created
        ''' </history>
        ''' -----------------------------------------------------------------------------
        <Description("High color of the hover gradient."), Category("Appearance"), DefaultValue(GetType(Color), "90, 135, 215")> _
        Public Property HoverGradientHighColor() As Color
            Get
                Return mColorHoverHigh
            End Get
            Set(ByVal Value As Color)
                If Value.Equals(Color.Empty) Then Value = Color.FromArgb(90, 135, 215)
                mColorHoverHigh = Value
                CreateGradientBrushes()
                Invalidate()
            End Set
        End Property
#End Region

#End Region

#Region " Private Properties "
        ' brush used to draw the caption
        Private ReadOnly Property TextBrush() As SolidBrush
            Get
                Return CType(IIf(mActive AndAlso mAllowActive, _
                 mBrushActiveText, mBrushInactiveText), SolidBrush)
            End Get
        End Property

        ' gradient brush for the background
        Private ReadOnly Property BackBrush() As LinearGradientBrush
            Get
                If mHover Then
                    Return mBrushHover
                Else
                    Return CType(IIf(mActive AndAlso mAllowActive, _
                     mBrushActive, mBrushInactive), LinearGradientBrush)
                End If
            End Get
        End Property
#End Region

#Region " Constructors "
        ''' -----------------------------------------------------------------------------
        ''' <summary>
        ''' Default constructor.
        ''' </summary>
        ''' <history>
        ''' 	[JCamp]	6/22/2004	Created
        ''' </history>
        ''' -----------------------------------------------------------------------------
        Public Sub New()
            MyBase.New()

            ' this call is required by the Windows Form Designer
            InitializeComponent()

            ' set double buffer styles
            Me.SetStyle(ControlStyles.DoubleBuffer Or ControlStyles.UserPaint Or _
             ControlStyles.AllPaintingInWmPaint Or ControlStyles.ResizeRedraw, True)

            ' init the height
            Me.Height = DEFAULTHEIGHT

            ' format used when drawing the text
            mFormat = New StringFormat
            mFormat.FormatFlags = StringFormatFlags.NoWrap
            mFormat.LineAlignment = StringAlignment.Center
            mFormat.Trimming = StringTrimming.EllipsisCharacter

            ' init the font
            Me.Font = New Font(DEFAULTFONTNAME, DEFAULTFONTSIZE, FontStyle.Regular)

            ' create gdi objects
            Me.ActiveTextColor = mColorActiveText
            Me.InactiveTextColor = mColorInactiveActiveText

            ' setting the height above actually does this, but leave
            ' in incase change the code (and forget to init the 
            ' gradient brushes)
            CreateGradientBrushes()
            'Handle the ColorSchemeChanged event to recompute colors
            AddHandler ThemeInfo.ColorSchemeChanged, AddressOf OnUserColorSchemeChanged
        End Sub

#End Region

        Private Sub OnUserColorSchemeChanged(ByVal sender As Object, ByVal e As EventArgs)
            'Re-initialize the brushes
            CreateGradientBrushes()
        End Sub

#Region " Protected Members "
        ' the caption needs to be drawn
        Protected Overrides Sub OnPaint(ByVal e As PaintEventArgs)
            DrawCaption(e)

            MyBase.OnPaint(e)
        End Sub

        ' clicking on the caption does not give focus,
        ' handle the mouse down event and set focus to self
        Protected Overrides Sub OnMouseDown(ByVal e As MouseEventArgs)
            MyBase.OnMouseDown(e)
            If Me.mAllowActive Then Me.Focus()
        End Sub

        Protected Overrides Sub OnSizeChanged(ByVal e As System.EventArgs)
            MyBase.OnSizeChanged(e)

            ' create the gradient brushes based on the new size
            CreateGradientBrushes()
        End Sub
#End Region

#Region " Private Members "
        ' draw the caption
        Private Sub DrawCaption(ByVal e As PaintEventArgs)
            Dim g As Graphics = e.Graphics
            Dim rect As Rectangle = Me.DisplayRectangle

            ' background
            g.FillRectangle(Me.BackBrush, rect)

            If Not mIcon Is Nothing Then
                rect.X += mIconWidth + 2
                rect.Width -= mIconWidth + 2
            End If

            'Dim rectF As New RectangleF(rect.X, rect.Y, rect.Width, rect.Height)

            ' caption
            If mAntiAlias Then
                g.TextRenderingHint = Drawing.Text.TextRenderingHint.AntiAlias
            End If

            ' need a rectangle when want to use ellipsis
            g.DrawString(mText, Me.Font, Me.TextBrush, RectangleF.op_Implicit(rect), mFormat)
            If Not mIcon Is Nothing Then
                g.DrawIcon(mIcon, New Rectangle(2, 2, mIconWidth, mIconHeight))
            End If
            g.DrawLine(mPenTop, 0, 0, Me.Width - 1, 0)
        End Sub

        Private Sub CreateGradientBrushes()
            ' can only create brushes when have a width and height
            If Me.Width > 0 AndAlso Me.Height > 0 Then
                If Not mBrushActive Is Nothing Then mBrushActive.Dispose()
                If Not mBrushInactive Is Nothing Then mBrushInactive.Dispose()
                If Not mBrushHover Is Nothing Then mBrushHover.Dispose()
                If Not mPenTop Is Nothing Then mPenTop.Dispose()

                If Me.mUseThemeColors Then
                    mBrushActive = New LinearGradientBrush(Me.DisplayRectangle, ProColors.ButtonCheckedGradientBegin, ProColors.ButtonCheckedGradientEnd, LinearGradientMode.Vertical)
                    mBrushInactive = New LinearGradientBrush(Me.DisplayRectangle, ProColors.ToolStripGradientBegin, ProColors.ToolStripGradientEnd, LinearGradientMode.Vertical)
                    mBrushHover = New LinearGradientBrush(Me.DisplayRectangle, ProColors.ButtonCheckedGradientEnd, ProColors.ButtonCheckedGradientBegin, LinearGradientMode.Vertical)
                    mPenTop = New Pen(ProColors.ToolStripBorder)
                Else
                    mBrushActive = New LinearGradientBrush(Me.DisplayRectangle, mColorActiveHigh, mColorActiveLow, LinearGradientMode.Vertical)
                    mBrushInactive = New LinearGradientBrush(Me.DisplayRectangle, mColorInactiveHigh, mColorInactiveLow, LinearGradientMode.Vertical)
                    mBrushHover = New LinearGradientBrush(Me.DisplayRectangle, mColorHoverHigh, mColorHoverLow, LinearGradientMode.Vertical)
                    mPenTop = New Pen(Color.FromArgb(0, 45, 150))
                End If
            End If
        End Sub

        Private Sub MultiPaneTab_MouseEnter(ByVal sender As Object, ByVal e As System.EventArgs) Handles MyBase.MouseEnter
            mHover = True
            Me.Invalidate()
        End Sub

        Private Sub MultiPaneTab_MouseLeave(ByVal sender As Object, ByVal e As System.EventArgs) Handles MyBase.MouseLeave
            mHover = False
            Me.Invalidate()
        End Sub
#End Region

    End Class


    ''' -----------------------------------------------------------------------------
    ''' Project	 : NRC_Common_Classes
    ''' Class	 : WinForms.MultiPaneTabCollection
    ''' 
    ''' -----------------------------------------------------------------------------
    ''' <summary>
    ''' A collection of MultiPaneTab controls
    ''' </summary>
    ''' <history>
    ''' 	[JCamp]	6/22/2004	Created
    ''' </history>
    ''' -----------------------------------------------------------------------------
    Public Class MultiPaneTabCollection
        Inherits CollectionBase

        Default Public Property Item(ByVal index As Integer) As MultiPaneTab
            Get
                Return MyBase.InnerList(index)
            End Get
            Set(ByVal Value As MultiPaneTab)
                MyBase.InnerList(index) = Value
            End Set
        End Property

        Public Function Add(ByVal tab As MultiPaneTab) As Integer
            MyBase.InnerList.Add(tab)
        End Function

        Public Sub Remove(ByVal tab As MultiPaneTab)
            MyBase.List.Remove(tab)
        End Sub
    End Class
End Namespace
