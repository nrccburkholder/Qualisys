Imports System.Drawing.Drawing2D
Imports System.ComponentModel
Imports System.Windows.Forms
Imports System.Drawing

Namespace WinForms
    ''' -----------------------------------------------------------------------------
    ''' Project	 : NRC_Common_Classes
    ''' Class	 : WinForms.SectionHeader
    ''' 
    ''' -----------------------------------------------------------------------------
    ''' <summary>
    ''' A colored panel that represents a "header" region for a section of a form.
    ''' </summary>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[JCamp]	7/14/2004	Created
    ''' </history>
    ''' -----------------------------------------------------------------------------
    Public Class SectionHeader
        Inherits Panel

#Region " Private Members "
        Private COLORLOW As Color = Color.FromArgb(175, 200, 245)
        Private COLORHIGH As Color = Color.FromArgb(205, 225, 250)
        Private PENTOP As Pen
        Private PENBOTTOM As Pen
        Private Const POSOFFSET As Integer = 4

        Private mUseThemeColors As Boolean = True
        Private mBrush As LinearGradientBrush
        Private mText As String = ""
#End Region

#Region " Public Properties "

        ''' -----------------------------------------------------------------------------
        ''' <summary>
        ''' The text that should be rendered in the header if desired.
        ''' </summary>
        ''' <history>
        ''' 	[JCamp]	7/14/2004	Created
        ''' </history>
        ''' -----------------------------------------------------------------------------
        <Description("Header text."), Category("Appearance"), DefaultValue("")> _
        Public Property HeaderText() As String
            Get
                Return mText
            End Get

            Set(ByVal value As String)
                mText = value
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
                InitBrush()
                Invalidate()
            End Set
        End Property

#End Region

#Region " Constructors "
        ''' -----------------------------------------------------------------------------
        ''' <summary>
        ''' Default constructor.
        ''' </summary>
        ''' <history>
        ''' 	[JCamp]	7/14/2004	Created
        ''' </history>
        ''' -----------------------------------------------------------------------------
        Public Sub New()
            ' set double buffer styles
            Me.SetStyle(ControlStyles.DoubleBuffer Or ControlStyles.UserPaint Or _
             ControlStyles.AllPaintingInWmPaint Or ControlStyles.ResizeRedraw, True)

            InitBrush()
            'Handle the ColorSchemeChanged event to reset the colors
            AddHandler ThemeInfo.ColorSchemeChanged, AddressOf OnColorSchemeChanged
        End Sub

#End Region

   

#Region " Protected Methods "
        ''' -----------------------------------------------------------------------------
        ''' <summary>
        ''' Overrides the baseclass OnPaint method to draw the SectionHeader
        ''' </summary>
        ''' <param name="e">the PaintEventArgs for the control</param>
        ''' <history>
        ''' 	[JCamp]	7/14/2004	Created
        ''' </history>
        ''' -----------------------------------------------------------------------------
        Protected Overrides Sub OnPaint(ByVal e As PaintEventArgs)
            Draw(e.Graphics)
            MyBase.OnPaint(e)
        End Sub

        ''' -----------------------------------------------------------------------------
        ''' <summary>
        ''' Overrides the baseclass OnSizeChanged method to resize the brushes.
        ''' </summary>
        ''' <param name="e">The EventArgs for the event</param>
        ''' <history>
        ''' 	[JCamp]	7/14/2004	Created
        ''' </history>
        ''' -----------------------------------------------------------------------------
        Protected Overrides Sub OnSizeChanged(ByVal e As System.EventArgs)
            MyBase.OnSizeChanged(e)

            If Me.Width > 0 AndAlso Me.Height > 0 Then
                ' create the gradient brush when the control is resized
                InitBrush()
            End If
        End Sub
#End Region

#Region " Private Methods "

        Private Sub OnColorSchemeChanged(ByVal sender As Object, ByVal e As EventArgs)
            'Reset the colors
            InitBrush()
        End Sub

        Private Sub InitBrush()
            If Not mBrush Is Nothing Then mBrush.Dispose()
            If Not PENTOP Is Nothing Then PENTOP.Dispose()
            If Not PENBOTTOM Is Nothing Then PENBOTTOM.Dispose()

            If Me.mUseThemeColors Then
                mBrush = New LinearGradientBrush(Me.DisplayRectangle, ProColors.MenuStripGradientEnd, ProColors.MenuStripGradientBegin, LinearGradientMode.Vertical)
                PENTOP = New Pen(ProColors.ToolStripBorder)
                PENBOTTOM = New Pen(ProColors.ToolStripBorder)
            Else
                mBrush = New LinearGradientBrush(Me.DisplayRectangle, COLORHIGH, COLORLOW, LinearGradientMode.Vertical)
                PENTOP = New Pen(Color.FromArgb(180, 210, 245))
                PENBOTTOM = New Pen(SystemColors.InactiveCaption)
            End If
        End Sub
        ''' -----------------------------------------------------------------------------
        ''' <summary>
        ''' Draws the gradient box and the header text onto the panel
        ''' </summary>
        ''' <param name="g">the Graphics object for the panel control</param>
        ''' <remarks>
        ''' </remarks>
        ''' <history>
        ''' 	[JCamp]	7/14/2004	Created
        ''' </history>
        ''' -----------------------------------------------------------------------------
        Private Sub Draw(ByVal g As Graphics)
            If Me.Width = 0 OrElse Me.Height = 0 Then Return

            ' background
            g.FillRectangle(mBrush, Me.DisplayRectangle)

            ' header text
            g.DrawString(mText, Me.Font, SystemBrushes.ControlText, _
             POSOFFSET, (Me.Height - Me.Font.Height) \ 2)

            ' top and bottom lines
            g.DrawLine(PENTOP, 0, 0, Me.Width - 1, 0)
            g.DrawLine(PENBOTTOM, 0, Me.Height - 1, Me.Width - 1, Me.Height - 1)
        End Sub
#End Region

    End Class

End Namespace
