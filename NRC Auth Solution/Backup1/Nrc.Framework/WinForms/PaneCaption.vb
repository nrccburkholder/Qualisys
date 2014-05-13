Imports System.Drawing.Drawing2D
Imports System.ComponentModel
Imports System.Drawing
Imports System.Windows.Forms

Namespace WinForms
    ''' -----------------------------------------------------------------------------
    ''' Project	 : NRC_Common_Classes
    ''' Class	 : WinForms.PaneCaption
    ''' 
    ''' -----------------------------------------------------------------------------
    ''' <summary>
    ''' This class is a UserControl that renders a caption in a pane on a form.  The
    ''' caption is drawn with a gradient and anti-alias font.
    ''' </summary>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[JCamp]	6/22/2004	Created
    ''' </history>
    ''' -----------------------------------------------------------------------------
    Public Class PaneCaption
        Inherits System.Windows.Forms.Control

#Region " Private Members "
        Private Const DEFAULT_HEIGHT As Integer = 26
        Private Const DEFAULT_FONTNAME As String = "Tahoma"
        Private Const DEFAULT_FONTSIZE As Integer = 12
        Private Const POS_OFFSET As Integer = 4

        Private mActive As Boolean = False
        Private mAntiAlias As Boolean = True
        Private mAllowActive As Boolean = True
        Private mText As String = ""
        Private mUseThemeColors As Boolean = True

        Private mColorActiveText As Color = Color.Black
        Private mColorInactiveText As Color = Color.White

        Private mColorActiveLow As Color = Color.FromArgb(255, 165, 78)
        Private mColorActiveHigh As Color = Color.FromArgb(255, 225, 155)
        Private mColorInactiveLow As Color = Color.FromArgb(3, 55, 145)
        Private mColorInactiveHigh As Color = Color.FromArgb(90, 135, 215)

        ' gdi objects
        Private mBrushActiveText As Brush
        Private mBrushInactiveText As Brush
        Private mBrushActive As Brush
        Private mBrushInactive As Brush
        Private mFormat As StringFormat

#End Region

#Region " Public Properties "
        ''' -----------------------------------------------------------------------------
        ''' <summary>
        ''' The text the be rendered in the caption
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
        ''' The text the be rendered in the caption
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
        ''' Returns true if the caption is in the active state
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
        ''' Determines if the caption can change between an active and inactive state
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
        ''' Determines if Anit-Aliasing should be used to draw the text on the caption
        ''' </summary>
        ''' <history>
        ''' 	[JCamp]	6/22/2004	Created
        ''' </history>
        ''' -----------------------------------------------------------------------------
        ''' 
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
#Region " color properties "


        ''' -----------------------------------------------------------------------------
        ''' <summary>
        ''' The color of the text with the pane caption is active
        ''' </summary>
        ''' <history>
        ''' 	[JCamp]	7/14/2004	Created
        ''' </history>
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
        ''' The color of the text with the pane caption is inactive
        ''' </summary>
        ''' <history>
        ''' 	[JCamp]	7/14/2004	Created
        ''' </history>
        ''' -----------------------------------------------------------------------------
        <Description("Color of the text when inactive."), Category("Appearance"), DefaultValue(GetType(Color), "White")> _
        Public Property InactiveTextColor() As Color
            Get
                Return mColorInactiveText
            End Get
            Set(ByVal Value As Color)
                If Value.Equals(Color.Empty) Then Value = Color.White
                mColorInactiveText = Value
                mBrushInactiveText = New SolidBrush(mColorInactiveText)
                Invalidate()
            End Set
        End Property

        ''' -----------------------------------------------------------------------------
        ''' <summary>
        ''' The low gradient color when the pane caption is active
        ''' </summary>
        ''' <history>
        ''' 	[JCamp]	7/14/2004	Created
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
        ''' The high gradient color when the pane caption is active
        ''' </summary>
        ''' <history>
        ''' 	[JCamp]	7/14/2004	Created
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
        ''' The low gradient color when the pane caption is inactive
        ''' </summary>
        ''' <history>
        ''' 	[JCamp]	7/14/2004	Created
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
        ''' The high gradient color when the pane caption is inactive
        ''' </summary>
        ''' <history>
        ''' 	[JCamp]	7/14/2004	Created
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

#End Region

#End Region

#Region " Private Properties "

        ''' -----------------------------------------------------------------------------
        ''' <summary>
        ''' Brush used to draw the caption text
        ''' </summary>
        ''' <history>
        ''' 	[JCamp]	7/14/2004	Created
        ''' </history>
        ''' -----------------------------------------------------------------------------
        Private ReadOnly Property TextBrush() As Brush
            Get
                If mActive AndAlso mAllowActive Then
                    Return mBrushActiveText
                Else
                    Return mBrushInactiveText
                End If
            End Get
        End Property

        ''' -----------------------------------------------------------------------------
        ''' <summary>
        ''' Brush used to draw the gradient background
        ''' </summary>
        ''' <history>
        ''' 	[JCamp]	7/14/2004	Created
        ''' </history>
        ''' -----------------------------------------------------------------------------
        Private ReadOnly Property BackBrush() As Brush
            Get
                If mActive AndAlso mAllowActive Then
                    Return mBrushActive
                Else
                    Return mBrushInactive
                End If
            End Get
        End Property
#End Region

#Region " Constructors "
        ''' -----------------------------------------------------------------------------
        ''' <summary>
        ''' Default constructor
        ''' </summary>
        ''' <remarks>
        ''' </remarks>
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
            Me.Height = DEFAULT_HEIGHT

            ' format used when drawing the text
            mFormat = New StringFormat
            mFormat.FormatFlags = StringFormatFlags.NoWrap
            mFormat.LineAlignment = StringAlignment.Center
            mFormat.Trimming = StringTrimming.EllipsisCharacter

            ' init the font
            Me.Font = New Font(DEFAULT_FONTNAME, DEFAULT_FONTSIZE, FontStyle.Bold)

            ' create gdi objects
            Me.ActiveTextColor = mColorActiveText
            Me.InactiveTextColor = mColorInactiveText

            ' setting the height above actually does this, but leave
            ' in incase change the code (and forget to init the 
            ' gradient brushes)
            CreateGradientBrushes()
            'Handle the ColorSchemeChanged event to reset colors
            AddHandler ThemeInfo.ColorSchemeChanged, AddressOf OnColorSchemeChanged
        End Sub
#End Region

        Private Sub OnColorSchemeChanged(ByVal sender As Object, ByVal e As EventArgs)
            'Reset the colors
            CreateGradientBrushes()
        End Sub


#Region " Protected Methods "
        ''' -----------------------------------------------------------------------------
        ''' <summary>
        ''' Overrides the baseclass OnPaint and additionally draws the PaneCaption.
        ''' </summary>
        ''' <param name="e">the PaintEventArgs for this control</param>
        ''' <history>
        ''' 	[JCamp]	7/14/2004	Created
        ''' </history>
        ''' -----------------------------------------------------------------------------
        Protected Overrides Sub OnPaint(ByVal e As PaintEventArgs)
            DrawCaption(e.Graphics)
            MyBase.OnPaint(e)
        End Sub

        ''' -----------------------------------------------------------------------------
        ''' <summary>
        ''' Overrides the baseclass OnMouseDown so that the control gets focus if AllowActive is true.
        ''' </summary>
        ''' <param name="e">the MouseEventArgs for the event</param>
        ''' <history>
        ''' 	[JCamp]	7/14/2004	Created
        ''' </history>
        ''' -----------------------------------------------------------------------------
        Protected Overrides Sub OnMouseDown(ByVal e As MouseEventArgs)
            MyBase.OnMouseDown(e)
            If Me.mAllowActive Then Me.Focus()
        End Sub

        ''' -----------------------------------------------------------------------------
        ''' <summary>
        ''' Overrides the baseclass OnSizeChanged to redraw the PaneCaption
        ''' </summary>
        ''' <param name="e">The EventArgs for the event</param>
        ''' <history>
        ''' 	[JCamp]	7/14/2004	Created
        ''' </history>
        ''' -----------------------------------------------------------------------------
        Protected Overrides Sub OnSizeChanged(ByVal e As System.EventArgs)
            MyBase.OnSizeChanged(e)

            ' create the gradient brushes based on the new size
            CreateGradientBrushes()
        End Sub
#End Region

#Region " Private Methods "
        ''' -----------------------------------------------------------------------------
        ''' <summary>
        ''' Draws the caption gradient and text onto the control
        ''' </summary>
        ''' <param name="g">the Graphics object of the control</param>
        ''' <history>
        ''' 	[JCamp]	7/14/2004	Created
        ''' </history>
        ''' -----------------------------------------------------------------------------
        Private Sub DrawCaption(ByVal g As Graphics)
            ' background
            g.FillRectangle(Me.BackBrush, Me.DisplayRectangle)

            ' caption
            If mAntiAlias Then
                g.TextRenderingHint = Drawing.Text.TextRenderingHint.AntiAlias
            End If

            ' need a rectangle when want to use ellipsis
            Dim bounds As RectangleF = New RectangleF(POS_OFFSET, 0, _
             Me.DisplayRectangle.Width - POS_OFFSET, Me.DisplayRectangle.Height)

            g.DrawString(mText, Me.Font, Me.TextBrush, bounds, mFormat)
        End Sub

        ''' -----------------------------------------------------------------------------
        ''' <summary>
        ''' Create the brushes for drawing the control
        ''' </summary>
        ''' <history>
        ''' 	[JCamp]	7/14/2004	Created
        ''' </history>
        ''' -----------------------------------------------------------------------------
        Private Sub CreateGradientBrushes()
            ' can only create brushes when have a width and height
            If Me.Width > 0 AndAlso Me.Height > 0 Then
                If Not (mBrushActive Is Nothing) Then mBrushActive.Dispose()
                If Not (mBrushInactive Is Nothing) Then mBrushInactive.Dispose()

                If Me.mUseThemeColors Then
                    If Application.RenderWithVisualStyles Then
                        mBrushActive = New LinearGradientBrush(Me.DisplayRectangle, ProfessionalColors.ButtonCheckedGradientBegin, ProfessionalColors.ButtonCheckedGradientEnd, LinearGradientMode.Vertical)
                        mBrushInactive = New LinearGradientBrush(Me.DisplayRectangle, ProfessionalColors.OverflowButtonGradientMiddle, ProfessionalColors.OverflowButtonGradientEnd, LinearGradientMode.Vertical)
                    Else
                        mBrushActive = New LinearGradientBrush(Me.DisplayRectangle, ProfessionalColors.ButtonCheckedGradientBegin, ProfessionalColors.ButtonCheckedGradientEnd, LinearGradientMode.Vertical)
                        mBrushInactive = New SolidBrush(Color.Gray)
                    End If
                Else
                    mBrushActive = New LinearGradientBrush(Me.DisplayRectangle, mColorActiveHigh, mColorActiveLow, LinearGradientMode.Vertical)
                    mBrushInactive = New LinearGradientBrush(Me.DisplayRectangle, mColorInactiveHigh, mColorInactiveLow, LinearGradientMode.Vertical)
                End If
            End If
        End Sub

#End Region

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
            'PaneCaption
            '
            Me.Name = "PaneCaption"
            Me.Size = New System.Drawing.Size(150, 30)
        End Sub

#End Region

    End Class

End Namespace
