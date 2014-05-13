Imports System.ComponentModel
Imports System.Windows.Forms
Imports System.Drawing

Namespace WinForms

    ''' -----------------------------------------------------------------------------
    ''' Project	 : NRC_Common_Classes
    ''' Class	 : WinForms.SectionPanel
    ''' 
    ''' -----------------------------------------------------------------------------
    ''' <summary>
    ''' Represents a section on a form drawn with a colored border around it and an
    ''' optional PaneCaption at the top.
    ''' </summary>
    ''' <remarks>
    ''' This control is used to distinguish different sections of the form much like how
    ''' a group box would be used.
    ''' </remarks>
    ''' <history>
    ''' 	[JCamp]	7/14/2004	Created
    ''' </history>
    ''' -----------------------------------------------------------------------------
    Public Class SectionPanel
        Inherits Panel

#Region " Private Members "
        Private mBorderColor As Color = Color.FromArgb(0, 45, 150)
        Private mPenBorder As Pen
        Private mPaneCaption As PaneCaption
        Private mShowPaneCaption As Boolean = False
        Private mUseThemeColors As Boolean = True
#End Region

#Region " Public Properties "

        ''' -----------------------------------------------------------------------------
        ''' <summary>
        ''' If ShowCaption is True then this text will be displayed in the Pane Caption at the top of the SectionPanel control.
        ''' </summary>
        ''' <history>
        ''' 	[JCamp]	7/14/2004	Created
        ''' </history>
        ''' -----------------------------------------------------------------------------
        <Browsable(True), Description("The caption to display in the header."), Category("Appearance"), DesignerSerializationVisibility(DesignerSerializationVisibility.Visible)> _
        Public Property Caption() As String
            Get
                Return mPaneCaption.Caption
            End Get
            Set(ByVal Value As String)
                mPaneCaption.Caption = Value
            End Set
        End Property

        ''' -----------------------------------------------------------------------------
        ''' <summary>
        ''' Determines if the PaneCaption at the top of the control will be displayed.
        ''' </summary>
        ''' <history>
        ''' 	[JCamp]	7/14/2004	Created
        ''' </history>
        ''' -----------------------------------------------------------------------------
        <Browsable(True), Description("Determines if the pane caption is painted on the panel"), Category("Appearance"), DesignerSerializationVisibility(DesignerSerializationVisibility.Visible)> _
        Public Property ShowCaption() As Boolean
            Get
                Return mShowPaneCaption
            End Get
            Set(ByVal Value As Boolean)
                mShowPaneCaption = Value
                If mShowPaneCaption Then
                    If Not Me.Controls.Contains(mPaneCaption) Then
                        Me.Controls.Add(mPaneCaption)
                    End If
                Else
                    If Me.Controls.Contains(mPaneCaption) Then
                        Me.Controls.Remove(mPaneCaption)
                    End If
                End If
            End Set
        End Property


        ''' -----------------------------------------------------------------------------
        ''' <summary>
        ''' The color of the border drawn around the section.
        ''' </summary>
        ''' <history>
        ''' 	[JCamp]	7/14/2004	Created
        ''' </history>
        ''' -----------------------------------------------------------------------------
        <Browsable(True), Description("The color of the border drawn around the section."), Category("Appearance"), DesignerSerializationVisibility(DesignerSerializationVisibility.Visible)> _
        Public Property BorderColor() As Color
            Get
                Return mBorderColor
            End Get
            Set(ByVal Value As Color)
                mBorderColor = Value
                InitPen()
            End Set
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

#Region " Consructors "
        ''' -----------------------------------------------------------------------------
        ''' <summary>
        ''' Default constructor to initialize the SectionPanel control.
        ''' </summary>
        ''' <remarks>
        ''' </remarks>
        ''' <history>
        ''' 	[JCamp]	7/14/2004	Created
        ''' </history>
        ''' -----------------------------------------------------------------------------
        Public Sub New()
            'MyBase.New()
            Me.SetStyle(ControlStyles.DoubleBuffer Or ControlStyles.UserPaint Or _
              ControlStyles.AllPaintingInWmPaint Or ControlStyles.ResizeRedraw, True)

            Me.DockPadding.All = 1

            mPaneCaption = New PaneCaption
            mPaneCaption.Width = Me.Width
            mPaneCaption.Dock = DockStyle.Top
            InitPen()
            'Handle the ColorSchemeChanged event to reset the colors
            AddHandler ThemeInfo.ColorSchemeChanged, AddressOf OnColorSchemeChanged
        End Sub
#End Region

#Region " Protected Methods "
        ''' -----------------------------------------------------------------------------
        ''' <summary>
        ''' Overrides OnPaint to also draw a border around the control.
        ''' </summary>
        ''' <param name="e">the PaintEventArgs for this control</param>
        ''' <remarks>
        ''' </remarks>
        ''' <history>
        ''' 	[JCamp]	7/14/2004	Created
        ''' </history>
        ''' -----------------------------------------------------------------------------
        Protected Overrides Sub OnPaint(ByVal e As System.Windows.Forms.PaintEventArgs)
            DrawBorder(e.Graphics)
            MyBase.OnPaint(e)
        End Sub
#End Region

#Region " Private Methods "
        Private Sub OnColorSchemeChanged(ByVal sender As Object, ByVal e As EventArgs)
            'Reset the colors
            InitPen()
        End Sub

        Private Sub InitPen()
            If Not mPenBorder Is Nothing Then mPenBorder.Dispose()

            If Me.mUseThemeColors Then
                mPenBorder = New Pen(ProColors.ToolStripBorder)
            Else
                mPenBorder = New Pen(mBorderColor)
            End If
        End Sub
        ''' -----------------------------------------------------------------------------
        ''' <summary>
        ''' Draws a 1 pixel border around the outside of the control.
        ''' </summary>
        ''' <param name="g"></param>
        ''' <remarks>
        ''' </remarks>
        ''' <history>
        ''' 	[JCamp]	7/14/2004	Created
        ''' </history>
        ''' -----------------------------------------------------------------------------
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
#End Region

        Protected Overrides Sub OnResize(ByVal eventargs As System.EventArgs)
            MyBase.OnResize(eventargs)
            Me.mPaneCaption.Width = Me.Width
        End Sub
    End Class

End Namespace
