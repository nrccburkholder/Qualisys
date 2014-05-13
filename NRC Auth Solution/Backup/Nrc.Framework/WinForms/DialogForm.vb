Imports System.ComponentModel
Imports System.Drawing
Imports System.Windows.Forms
Namespace WinForms
    ''' -----------------------------------------------------------------------------
    ''' Project	 : NRC_Common_Classes
    ''' Class	 : WinForms.DialogForm
    ''' 
    ''' -----------------------------------------------------------------------------
    ''' <summary>
    ''' This class is a simple form that uses a pre-formatted design for drawing pop-up
    ''' dialog windows.
    ''' </summary>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[JCamp]	6/22/2004	Created
    ''' </history>
    ''' -----------------------------------------------------------------------------
    Public Class DialogForm
        Inherits System.Windows.Forms.Form

#Region " Private Members "
        Private mPenBorder As Pen
        Protected WithEvents mPaneCaption As PaneCaption

        'Window drag members
        Private mIsDragging As Boolean = False
        Private mMouseX As Integer
        Private mMouseY As Integer
        Private mFormLeft As Integer
        Private mFormTop As Integer
#End Region

#Region " Public Properties "

        ''' -----------------------------------------------------------------------------
        ''' <summary>
        ''' The caption to be displayed in the form's title bar
        ''' </summary>
        ''' <history>
        ''' 	[JCamp]	6/22/2004	Created
        ''' </history>
        ''' -----------------------------------------------------------------------------
        <Browsable(True), Description("The caption to display in the title bar"), Category("Appearance"), DesignerSerializationVisibility(DesignerSerializationVisibility.Visible)> _
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
        ''' The color of the form's border
        ''' </summary>
        ''' <history>
        ''' 	[JCamp]	6/22/2004	Created
        ''' </history>
        ''' -----------------------------------------------------------------------------
        <Description("The border color."), Category("Appearance")> _
        Public Property BorderColor() As Color
            Get
                Return mPenBorder.Color
            End Get
            Set(ByVal Value As Color)
                mPenBorder.Color = Value
            End Set
        End Property
#End Region


        ''' -----------------------------------------------------------------------------
        ''' <summary>
        ''' Default constructor.
        ''' </summary>
        ''' <remarks>
        ''' </remarks>
        ''' <history>
        ''' 	[JCamp]	6/22/2004	Created
        ''' </history>
        ''' -----------------------------------------------------------------------------
        Public Sub New()
            MyBase.New()

            Me.StartPosition = Windows.Forms.FormStartPosition.CenterParent
            Me.ShowInTaskbar = False
            Me.FormBorderStyle = Windows.Forms.FormBorderStyle.None
            Me.DockPadding.All = 1

            mPaneCaption = New PaneCaption
            mPaneCaption.Dock = Windows.Forms.DockStyle.Top
            mPaneCaption.TabStop = False
            Me.Controls.Add(mPaneCaption)

            Me.mPenBorder = New Pen(ProfessionalColors.ToolStripBorder)
        End Sub


#Region " Window Drag Events "
        Private Sub mPaneCaption_MouseDown(ByVal sender As Object, ByVal e As System.Windows.Forms.MouseEventArgs) Handles mPaneCaption.MouseDown
            mIsDragging = True
            mMouseX = System.Windows.Forms.Cursor.Position.X
            mMouseY = System.Windows.Forms.Cursor.Position.Y
            mFormLeft = Me.Left
            mFormTop = Me.Top
        End Sub

        Private Sub mPaneCaption_MouseMove(ByVal sender As Object, ByVal e As System.Windows.Forms.MouseEventArgs) Handles mPaneCaption.MouseMove
            If Not mIsDragging Then Exit Sub

            Dim difX As Integer = mMouseX - System.Windows.Forms.Cursor.Position.X
            Dim difY As Integer = mMouseY - System.Windows.Forms.Cursor.Position.Y

            Me.Left = mFormLeft - difX
            Me.Top = mFormTop - difY
        End Sub

        Private Sub mPaneCaption_MouseUp(ByVal sender As Object, ByVal e As System.Windows.Forms.MouseEventArgs) Handles mPaneCaption.MouseUp
            mIsDragging = False
        End Sub
#End Region

#Region " Border Drawing Methods "
        Protected Overrides Sub OnPaint(ByVal e As System.Windows.Forms.PaintEventArgs)
            DrawBorder(e.Graphics)
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
#End Region

        Private Sub InitializeComponent()
            '
            'DialogForm
            '
            Me.AutoScaleBaseSize = New System.Drawing.Size(5, 13)
            Me.ClientSize = New System.Drawing.Size(292, 273)
            Me.Name = "DialogForm"
            Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent

        End Sub
    End Class
End Namespace
