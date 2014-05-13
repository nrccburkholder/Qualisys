Imports System.Runtime.InteropServices
Imports System.Drawing
Imports System.ComponentModel

Namespace WinForms

    Public Class BalloonTip
        Inherits System.ComponentModel.Component

#Region " Private Members "
        Private mDisplayPoint As Point
        Private mSlideShow As Boolean = False
        Private mMessageFont As Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Private mTitleFont As Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Private mBackgroundColor As Color = Color.LemonChiffon
        Private mBorderColor As Color = Color.Black
        Private mText As String
        Private mTitle As String
        Private WithEvents mBalloonForm As BalloonForm
#End Region

#Region " Public Properties "

        <Category("Appearance"), DesignerSerializationVisibility(DesignerSerializationVisibility.Visible)> _
        Public Property MessageFont() As Font
            Get
                Return mMessageFont
            End Get
            Set(ByVal Value As Font)
                mMessageFont = Value
            End Set
        End Property

        <Category("Appearance"), DesignerSerializationVisibility(DesignerSerializationVisibility.Visible)> _
        Public Property TitleFont() As Font
            Get
                Return mTitleFont
            End Get
            Set(ByVal Value As Font)
                mTitleFont = Value
            End Set
        End Property
        <Category("Appearance"), DesignerSerializationVisibility(DesignerSerializationVisibility.Visible)> _
        Public Property BackgroundColor() As Color
            Get
                Return mBackgroundColor
            End Get
            Set(ByVal Value As Color)
                mBackgroundColor = Value
            End Set
        End Property
        <Category("Appearance"), DesignerSerializationVisibility(DesignerSerializationVisibility.Visible)> _
        Public Property BorderColor() As Color
            Get
                Return mBorderColor
            End Get
            Set(ByVal Value As Color)
                mBorderColor = Value
            End Set
        End Property

        <Category("Data"), DesignerSerializationVisibility(DesignerSerializationVisibility.Visible)> _
        Public Property Title() As String
            Get
                Return mTitle
            End Get
            Set(ByVal Value As String)
                mTitle = Value
            End Set
        End Property

        <Category("Data"), DesignerSerializationVisibility(DesignerSerializationVisibility.Visible)> _
        Public Property Text() As String
            Get
                Return mText
            End Get
            Set(ByVal Value As String)
                mText = Value
            End Set
        End Property
#End Region

#Region " Event Declarations "

#Region " BalloonTipClick Event "
        Public Delegate Sub BalloonTipClickEventHandler(ByVal sender As Object, ByVal e As BalloonTipClickEventArgs)
        Public Event BalloonTipClick As BalloonTipClickEventHandler
        Public Class BalloonTipClickEventArgs
            Inherits EventArgs
        End Class
#End Region

#Region " BalloonTipClosed Event "
        Public Delegate Sub BalloonTipClosedEventHandler(ByVal sender As Object, ByVal e As BalloonTipClosedEventArgs)
        Public Event BalloonTipClosed As BalloonTipClosedEventHandler
        Public Class BalloonTipClosedEventArgs
            Inherits EventArgs
        End Class
#End Region

#End Region

#Region " Enumerations "
        Public Enum BalloonIcon
            Information = 0
            Help
            Warning
            [Error]
            None
        End Enum
#End Region

#Region " Constructors "
        Sub New()
            MyBase.New()
            Dim pt As Point = GetNotificationRect.Location
            pt.Y -= 10
            mDisplayPoint = pt
        End Sub
        Sub New(ByVal components As System.ComponentModel.IContainer)
            MyBase.New()
            Dim pt As Point = GetNotificationRect.Location
            pt.Y -= 10
            mDisplayPoint = pt

            components.Add(Me)
        End Sub
        Sub New(ByVal components As System.ComponentModel.IContainer, ByVal displayPoint As Point)
            MyBase.New()
            mDisplayPoint = displayPoint

            components.Add(Me)
        End Sub
#End Region

#Region " External Function Declarations "
        <DllImport("user32.dll")> _
        Private Shared Function FindWindowEx(ByVal parentWnd As IntPtr, ByVal childAfter As IntPtr, ByVal lpClassName As String, ByVal lpWindowName As String) As IntPtr
        End Function

        <DllImport("user32.dll")> _
        Private Shared Function GetWindowRect(ByVal hWnd As IntPtr, <Out()> ByRef lpRect As Rectangle) As Integer
        End Function

        Private Shared Function GetNotificationRect() As Rectangle
            Dim rc As Rectangle
            Dim hwnd As System.IntPtr = FindWindowEx(IntPtr.Zero, IntPtr.Zero, "Shell_TrayWnd", Nothing)

            hwnd = FindWindowEx(hwnd, IntPtr.Zero, "TrayNotifyWnd", Nothing)
            hwnd = FindWindowEx(hwnd, IntPtr.Zero, "SysPager", Nothing)
            If Not (hwnd.Equals(IntPtr.Zero)) Then
                hwnd = FindWindowEx(hwnd, IntPtr.Zero, Nothing, "Notification Area")
                If Not (hwnd.Equals(IntPtr.Zero)) Then
                    If Not (GetWindowRect(hwnd, rc) = 0) Then
                        Return rc
                    End If
                End If
            End If

        End Function
#End Region

#Region " Public Methods "
        Public Sub ShowBalloonTip(ByVal iconType As BalloonIcon, ByVal slideShow As Boolean, ByVal isClickable As Boolean)
            Me.ShowBalloonTip(iconType, slideShow, isClickable, mTitle, mText)
        End Sub
        Public Sub ShowBalloonTip(ByVal iconType As BalloonIcon, ByVal slideShow As Boolean, ByVal isClickable As Boolean, ByVal title As String, ByVal messageText As String)
            mBalloonForm = New BalloonForm(mDisplayPoint)
            mBalloonForm.TitleFont = mTitleFont
            mBalloonForm.MessageFont = mMessageFont
            mBalloonForm.BackgroundColor = mBackgroundColor
            mBalloonForm.BorderColor = mBorderColor
            'mBalloonForm.Width = 50

            mBalloonForm.Show(iconType, slideShow, isClickable, title, messageText)
        End Sub
#End Region

        Private Sub mBalloonForm_MessageClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles mBalloonForm.MessageClick
            RaiseEvent BalloonTipClick(Me, New BalloonTipClickEventArgs)
            mBalloonForm.Close()
        End Sub

#Region " BalloonForm Class "
        Public Class BalloonForm
            Inherits System.Windows.Forms.Form

#Region " Windows Form Designer generated code "

            Public Sub New(ByVal displayPoint As Point)
                MyBase.New()

                'This call is required by the Windows Form Designer.
                InitializeComponent()

                'Add any initialization after the InitializeComponent() call
                Me.Visible = False
                mDisplayPoint = displayPoint
                CloseIcon.Image = BalloonIcons.Images(0)
            End Sub

            'Form overrides dispose to clean up the component list.
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
            Friend WithEvents BalloonIcons As System.Windows.Forms.ImageList
            Friend WithEvents CloseIcon As System.Windows.Forms.PictureBox
            Friend WithEvents lblTitle As System.Windows.Forms.Label
            Friend WithEvents lblMessage As System.Windows.Forms.Label
            Friend WithEvents btnMessage As System.Windows.Forms.LinkLabel
            Friend WithEvents BalloonIcon As System.Windows.Forms.PictureBox
            <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
                Me.components = New System.ComponentModel.Container
                Dim resources As System.Resources.ResourceManager = New System.Resources.ResourceManager("NRC.WinForms.BalloonTip", System.Reflection.Assembly.GetCallingAssembly)
                Me.BalloonIcon = New System.Windows.Forms.PictureBox
                Me.lblTitle = New System.Windows.Forms.Label
                Me.lblMessage = New System.Windows.Forms.Label
                Me.CloseIcon = New System.Windows.Forms.PictureBox
                Me.BalloonIcons = New System.Windows.Forms.ImageList(Me.components)
                Me.btnMessage = New System.Windows.Forms.LinkLabel
                Me.SuspendLayout()
                '
                'BalloonIcon
                '
                Me.BalloonIcon.BackColor = System.Drawing.Color.Transparent
                Me.BalloonIcon.Location = New System.Drawing.Point(8, 8)
                Me.BalloonIcon.Name = "BalloonIcon"
                Me.BalloonIcon.Size = New System.Drawing.Size(16, 16)
                Me.BalloonIcon.SizeMode = System.Windows.Forms.PictureBoxSizeMode.AutoSize
                Me.BalloonIcon.TabIndex = 0
                Me.BalloonIcon.TabStop = False
                '
                'lblTitle
                '
                Me.lblTitle.BackColor = System.Drawing.Color.Transparent
                Me.lblTitle.Location = New System.Drawing.Point(32, 8)
                Me.lblTitle.Font = mTitleFont
                Me.lblTitle.Name = "lblTitle"
                Me.lblTitle.Size = New System.Drawing.Size(288, 23)
                Me.lblTitle.TabIndex = 1
                Me.lblTitle.Text = "Balloon Tip Title"
                '
                'lblMessage
                '
                Me.lblMessage.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                            Or System.Windows.Forms.AnchorStyles.Left) _
                            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
                Me.lblMessage.BackColor = System.Drawing.Color.Transparent
                Me.lblMessage.Location = New System.Drawing.Point(32, 32)
                Me.lblMessage.Font = mMessageFont
                Me.lblMessage.Name = "lblMessage"
                Me.lblMessage.Size = New System.Drawing.Size(288, 56)
                Me.lblMessage.TabIndex = 1
                Me.lblMessage.Text = "Here is all my cool balloon text.  Do you like it?  I hope so because I really do" & _
                "!"
                Me.lblMessage.Visible = False
                '
                'CloseIcon
                '
                Me.CloseIcon.BackColor = System.Drawing.Color.Transparent
                Me.CloseIcon.Location = New System.Drawing.Point(336, 8)
                Me.CloseIcon.Name = "CloseIcon"
                Me.CloseIcon.Size = New System.Drawing.Size(16, 16)
                Me.CloseIcon.SizeMode = System.Windows.Forms.PictureBoxSizeMode.AutoSize
                Me.CloseIcon.TabIndex = 2
                Me.CloseIcon.TabStop = False
                '
                'BalloonIcons
                '
                Me.BalloonIcons.ImageSize = New System.Drawing.Size(16, 16)
                Me.BalloonIcons.ImageStream = CType(resources.GetObject("BalloonIcons.ImageStream"), System.Windows.Forms.ImageListStreamer)
                Me.BalloonIcons.TransparentColor = System.Drawing.Color.Transparent
                '
                'btnMessage
                '
                Me.btnMessage.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                            Or System.Windows.Forms.AnchorStyles.Left) _
                            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
                Me.btnMessage.BackColor = System.Drawing.Color.Transparent
                Me.btnMessage.FlatStyle = System.Windows.Forms.FlatStyle.System
                Me.btnMessage.Font = mMessageFont
                Me.btnMessage.Location = New System.Drawing.Point(32, 32)
                Me.btnMessage.Name = "btnMessage"
                Me.btnMessage.Size = New System.Drawing.Size(288, 56)
                Me.btnMessage.TabIndex = 3
                Me.btnMessage.TabStop = True
                Me.btnMessage.Text = "Here is all my cool balloon text.  Do you like it?  I hope so because I really do" & _
                "!"
                Me.btnMessage.Visible = False
                '
                'BalloonForm
                '
                Me.AutoScaleBaseSize = New System.Drawing.Size(5, 13)
                Me.BackColor = System.Drawing.SystemColors.Control
                Me.ClientSize = New System.Drawing.Size(360, 96)
                Me.ControlBox = False
                Me.Controls.Add(Me.btnMessage)
                Me.Controls.Add(Me.CloseIcon)
                Me.Controls.Add(Me.lblTitle)
                Me.Controls.Add(Me.BalloonIcon)
                Me.Controls.Add(Me.lblMessage)
                Me.FormBorderStyle = System.Windows.Forms.FormBorderStyle.None
                Me.Name = "BalloonForm"
                Me.Opacity = 0
                Me.ShowInTaskbar = False
                Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen
                Me.Text = "BalloonForm"
                Me.TransparencyKey = System.Drawing.SystemColors.Control
                Me.ResumeLayout(False)

            End Sub

#End Region

#Region " Private Members "
            Private Delegate Sub ShowBalloon()

            Private mDisplayPoint As Point
            Private mSlideShow As Boolean = False
            Private mMessageFont As Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
            Private mTitleFont As Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
            Private mBackgroundColor As Color = Color.LemonChiffon
            Private mBackgroundBrush As SolidBrush = New SolidBrush(mBackgroundColor)
            Private mBorderColor As Color = Color.Black
            Private mBorderPen As Pen = New Pen(mBorderColor)

            Private Const CURVE_DIAMETER As Integer = 50
            Private Const CURVE_RADIUS As Integer = CURVE_DIAMETER / 2
            Private Const TRIANGLE_SPACING As Integer = 20
            Private Const TRIANGLE_WIDTH As Integer = 20
            Private Const TRIANGLE_HEIGHT As Integer = 20
#End Region

#Region " Public Properties "
            Public Property MessageFont() As Font
                Get
                    Return mMessageFont
                End Get
                Set(ByVal Value As Font)
                    mMessageFont = Value
                End Set
            End Property
            Public Property TitleFont() As Font
                Get
                    Return mTitleFont
                End Get
                Set(ByVal Value As Font)
                    mTitleFont = Value
                End Set
            End Property
            Public Property BackgroundColor() As Color
                Get
                    Return mBackgroundColor
                End Get
                Set(ByVal Value As Color)
                    mBackgroundColor = Value
                    mBackgroundBrush = New SolidBrush(mBackgroundColor)
                End Set
            End Property
            Public Property BorderColor() As Color
                Get
                    Return mBorderColor
                End Get
                Set(ByVal Value As Color)
                    mBorderColor = Value
                    mBorderPen = New Pen(mBorderColor)
                End Set
            End Property
#End Region

#Region " Event Declarations "
            Public Delegate Sub MessageClickEventHandler(ByVal sender As Object, ByVal e As EventArgs)
            Public Event MessageClick As MessageClickEventHandler
#End Region

            Public Shadows Sub Show(ByVal iconType As BalloonTip.BalloonIcon, ByVal slideShow As Boolean, ByVal isClickable As Boolean, ByVal title As String, ByVal message As String)
                mSlideShow = slideShow
                lblTitle.Text = title
                lblMessage.Text = message
                btnMessage.Text = message

                lblMessage.Visible = Not isClickable
                btnMessage.Visible = isClickable

                Select Case iconType
                    Case BalloonTip.BalloonIcon.Information
                        BalloonIcon.Image = BalloonIcons.Images(2)
                    Case BalloonTip.BalloonIcon.Help
                        BalloonIcon.Image = BalloonIcons.Images(3)
                    Case BalloonTip.BalloonIcon.Warning
                        BalloonIcon.Image = BalloonIcons.Images(4)
                    Case BalloonTip.BalloonIcon.Error
                        BalloonIcon.Image = BalloonIcons.Images(5)
                    Case BalloonTip.BalloonIcon.None
                        BalloonIcon.Visible = False
                End Select

                MyBase.Show()
            End Sub

            Private Sub BalloonForm_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
                Me.Activate()
                Me.Refresh()

                'Move display point from triangle corner to form upper-left
                mDisplayPoint.X -= (Me.Width - TRIANGLE_SPACING)
                mDisplayPoint.Y -= Me.Height

                Me.Top = mDisplayPoint.Y
                Me.Left = mDisplayPoint.X

                If mSlideShow Then
                    Dim o As New ShowBalloon(AddressOf ExecuteShow)
                    o.BeginInvoke(New AsyncCallback(AddressOf ShowBalloonCallBack), o)
                Else
                    Me.Visible = True
                    Me.Opacity = 100
                    Me.BringToFront()
                End If
            End Sub

            Private Sub ExecuteShow()
                Me.Top = System.Windows.Forms.Screen.PrimaryScreen.Bounds.Height
                Dim max As Integer = mDisplayPoint.Y
                Dim i As Integer

                Me.Visible = True
                Me.Opacity = 100

                While Me.Top > max
                    Me.Top -= 3
                    Me.Refresh()
                End While

                Me.BringToFront()
            End Sub
            Private Sub ShowBalloonCallBack(ByVal ar As System.IAsyncResult)
            End Sub

            Protected Overrides Sub OnPaint(ByVal e As System.Windows.Forms.PaintEventArgs)
                MyBase.OnPaint(e)

                Dim g As Graphics = e.Graphics
                Dim width As Integer = Me.ClientRectangle.Width
                Dim height As Integer = Me.ClientRectangle.Height - TRIANGLE_HEIGHT
                Dim rect As Rectangle = New Rectangle(0, 0, width - 1, height - 1)
                Dim path As Drawing2D.GraphicsPath


                path = GetBalloonPath(rect, CInt(height / 10))
                g.FillPath(mBackgroundBrush, path)
                g.DrawPath(mBorderPen, path)
                path.Dispose()
            End Sub

            Protected Overrides Sub OnResize(ByVal e As System.EventArgs)
                MyBase.OnResize(e)
                Me.Invalidate()
            End Sub

            Private Function GetBalloonPath(ByVal rect As Rectangle, ByVal radius As Integer) As Drawing2D.GraphicsPath
                Dim diameter As Integer = 2 * radius
                Dim arcRect As Rectangle = New Rectangle(rect.Location, New Size(diameter, diameter))
                Dim path As New Drawing2D.GraphicsPath

                path.AddArc(arcRect, 180, 90)
                arcRect.X = rect.Right - diameter
                path.AddArc(arcRect, 270, 90)
                arcRect.Y = rect.Bottom - diameter
                path.AddArc(arcRect, 0, 90)

                Dim points(2) As Point
                points(0) = New Point(rect.Width - TRIANGLE_SPACING, rect.Top + rect.Height)
                points(1) = New Point(rect.Width - TRIANGLE_SPACING, rect.Top + rect.Height + TRIANGLE_HEIGHT)
                points(2) = New Point(rect.Width - (TRIANGLE_SPACING + TRIANGLE_WIDTH), rect.Top + rect.Height)
                path.AddLine(points(0), points(1))
                path.AddLine(points(1), points(2))

                arcRect.X = rect.Left
                path.AddArc(arcRect, 90, 90)

                path.CloseFigure()

                Return path
            End Function

            'Private Sub BalloonForm_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles MyBase.Click
            '    Me.Top += 20
            'End Sub

            Private Sub CloseIcon_MouseEnter(ByVal sender As Object, ByVal e As System.EventArgs) Handles CloseIcon.MouseEnter
                CloseIcon.Image = BalloonIcons.Images(1)
            End Sub

            Private Sub CloseIcon_MouseLeave(ByVal sender As Object, ByVal e As System.EventArgs) Handles CloseIcon.MouseLeave
                CloseIcon.Image = BalloonIcons.Images(0)
            End Sub

            Private Sub CloseIcon_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles CloseIcon.Click
                Me.Close()
            End Sub

            Protected Overrides Sub OnLoad(ByVal e As System.EventArgs)
                Me.Visible = False
                MyBase.OnLoad(e)
            End Sub

            Private Sub btnMessage_LinkClicked(ByVal sender As Object, ByVal e As System.Windows.Forms.LinkLabelLinkClickedEventArgs) Handles btnMessage.LinkClicked
                RaiseEvent MessageClick(Me, New EventArgs)
            End Sub
        End Class

#End Region

        Private Sub mBalloonForm_Closed(ByVal sender As Object, ByVal e As System.EventArgs) Handles mBalloonForm.Closed
            RaiseEvent BalloonTipClosed(Me, New BalloonTipClosedEventArgs)
        End Sub
    End Class

End Namespace
