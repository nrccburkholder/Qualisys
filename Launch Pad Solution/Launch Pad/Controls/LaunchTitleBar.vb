Imports System.Drawing
Imports System.Drawing.Drawing2D
Imports System.ComponentModel

<DefaultEvent("CloseButtonClicked")> _
Public Class LaunchTitleBar
    Inherits ContainerControl


    Private mBackColorLeft As Color
    Private mBackColorRight As Color
    Private mIcon As Icon = New Icon(GetType(Form), "wfc.ico")


    Private WithEvents mCloseButton As WindowButton
    Private WithEvents mMinimizeButton As WindowButton
    Private WithEvents mIconImage As PictureBox
    Private WithEvents mTitleLabel As Label

    Private mBackBrush As Brush
    Private mIsDragging As Boolean
    Private mDragBeginMousePoint As Point
    Private mDragBeginWindowPoint As Point

    Public Event CloseButtonClicked As EventHandler
    Public Event MinimizeButtonClicked As EventHandler

    <Category("Appearance"), DefaultValue(GetType(System.Drawing.Color), "SteelBlue")> _
    Public Property BackColorLeft() As Color
        Get
            Return mBackColorLeft
        End Get
        Set(ByVal value As Color)
            mBackColorLeft = value
            Me.InitBrushes()
            Me.Invalidate()
        End Set
    End Property

    <Category("Appearance"), DefaultValue(GetType(System.Drawing.Color), "LightSteelBlue")> _
    Public Property BackColorRight() As Color
        Get
            Return mBackColorRight
        End Get
        Set(ByVal value As Color)
            mBackColorRight = value
            Me.InitBrushes()
            Me.Invalidate()
        End Set
    End Property

    <Category("Appearance"), AmbientValue(CType(Nothing, String)), Localizable(True)> _
    Public Property Icon() As Icon
        Get
            Return mIcon
        End Get
        Set(ByVal value As Icon)
            mIcon = value
            If mIconImage IsNot Nothing Then
                mIconImage.Image = Icon.ToBitmap
            End If
        End Set
    End Property

    Public Overrides Property Text() As String
        Get
            Return MyBase.Text
        End Get
        Set(ByVal value As String)
            MyBase.Text = value
        End Set
    End Property

    Private Shadows Property BackColor() As Color
        Get
            Return MyBase.BackColor
        End Get
        Set(ByVal value As Color)
            MyBase.BackColor = value
        End Set
    End Property

    Sub New()
        Me.SetStyle(ControlStyles.OptimizedDoubleBuffer, True)
        Me.mBackColorLeft = Color.SteelBlue
        Me.mBackColorRight = Color.LightSteelBlue
        Me.mCloseButton = New WindowButton
        Me.mMinimizeButton = New WindowButton(WindowButtonType.Minimize)
        Me.mIconImage = New PictureBox
        Me.mTitleLabel = New Label
        Me.Size = New Size(100, 25)
        Me.Padding = New Padding(2)

        Me.InitBrushes()
        Me.AddCloseButton()
    End Sub

    Private Sub InitBrushes()
        If mBackBrush IsNot Nothing Then mBackBrush.Dispose()

        If Me.Width > 0 AndAlso Me.Height > 0 Then
            Dim rect As New Rectangle(0, 0, Me.Width, Me.Height)
            mBackBrush = New LinearGradientBrush(rect, mBackColorLeft, mBackColorRight, LinearGradientMode.Horizontal)
        End If
    End Sub

    Private Sub AddCloseButton()
        Me.Controls.Remove(mCloseButton)

        Dim buttonHeight As Integer = Me.Height - Me.Padding.Top - Me.Padding.Bottom
        mCloseButton.Size = New Size(buttonHeight, buttonHeight)
        Dim buttonX As Integer = Me.Width - mCloseButton.Width - Me.Padding.Right
        Dim buttonY As Integer = Me.Padding.Top
        mCloseButton.Location = New Point(buttonX, buttonY)
        mCloseButton.Anchor = AnchorStyles.Top Or AnchorStyles.Right

        Me.Controls.Add(mCloseButton)

        ''''''
        Me.Controls.Remove(mMinimizeButton)
        mMinimizeButton.Size = New Size(buttonHeight, buttonHeight)
        buttonX -= mCloseButton.Width + 4
        mMinimizeButton.Location = New Point(buttonX, buttonY)
        mMinimizeButton.Anchor = AnchorStyles.Top Or AnchorStyles.Right
        Me.Controls.Add(mMinimizeButton)
    End Sub

    Protected Overrides Sub OnPaintBackground(ByVal e As System.Windows.Forms.PaintEventArgs)
        'MyBase.OnPaintBackground(e)
        If Me.Width > 0 AndAlso Me.Height > 0 Then
            Dim rect As New Rectangle(0, 0, Me.Width, Me.Height)
            e.Graphics.FillRectangle(mBackBrush, rect)
        End If
    End Sub

    Protected Overrides Sub OnPaint(ByVal e As System.Windows.Forms.PaintEventArgs)
        MyBase.OnPaint(e)
        If Me.Width > 0 AndAlso Me.Height > 0 Then
            Dim clientRect As New Rectangle(Me.Padding.Left, Me.Padding.Top, Me.Width - Me.Padding.Horizontal, Me.Height - Me.Padding.Vertical)

            Me.PaintIcon(e.Graphics, clientRect)
            Me.PaintText(e.Graphics, clientRect)
        End If
    End Sub

    Private Sub PaintIcon(ByVal g As Graphics, ByVal clientRect As Rectangle)
        If mIcon IsNot Nothing Then
            Dim imgHeight As Integer = clientRect.Height
            Dim rect As New Rectangle(clientRect.Left, clientRect.Top, imgHeight, imgHeight)
            g.DrawIcon(mIcon, rect)
        End If
    End Sub

    Private Sub PaintText(ByVal g As Graphics, ByVal clientRect As Rectangle)
        Dim textRect As Rectangle
        Dim x As Integer
        Dim textWidth As Integer

        If mIcon IsNot Nothing Then
            x += clientRect.Height + 2
        End If
        textWidth = clientRect.Width - x - clientRect.Height
        textRect = New Rectangle(x, clientRect.Top, textWidth, clientRect.Height)

        Dim textFormat As New StringFormat
        textFormat.LineAlignment = StringAlignment.Center
        Using brush As New SolidBrush(Me.ForeColor)
            g.DrawString(Me.Text, Me.Font, brush, textRect, textFormat)
        End Using
    End Sub

    Protected Overrides Sub OnResize(ByVal e As System.EventArgs)
        MyBase.OnResize(e)
        Me.InitBrushes()
        Me.AddCloseButton()
        Me.Invalidate()
    End Sub

    Protected Overrides Sub OnPaddingChanged(ByVal e As System.EventArgs)
        MyBase.OnPaddingChanged(e)
        Me.AddCloseButton()
        Me.Invalidate()
    End Sub

    Private Sub CloseButton_Click(ByVal sender As Object, ByVal e As EventArgs) Handles mCloseButton.Click
        RaiseEvent CloseButtonClicked(sender, e)
    End Sub

    Private Sub MinimizeButton_Click(ByVal sender As Object, ByVal e As EventArgs) Handles mMinimizeButton.Click
        RaiseEvent MinimizeButtonClicked(sender, e)
    End Sub

    Protected Overrides Sub OnMouseDown(ByVal e As System.Windows.Forms.MouseEventArgs)
        MyBase.OnMouseDown(e)
        If e.Button = Windows.Forms.MouseButtons.Left Then
            mIsDragging = True
            mDragBeginMousePoint = System.Windows.Forms.Cursor.Position
            If Me.ParentForm IsNot Nothing Then
                Me.mDragBeginWindowPoint = Me.ParentForm.Location
            End If
        End If
    End Sub

    Protected Overrides Sub OnMouseUp(ByVal e As System.Windows.Forms.MouseEventArgs)
        MyBase.OnMouseUp(e)
        If e.Button = Windows.Forms.MouseButtons.Left Then
            mIsDragging = False
        End If
    End Sub

    Protected Overrides Sub OnMouseMove(ByVal e As System.Windows.Forms.MouseEventArgs)
        MyBase.OnMouseMove(e)
        If mIsDragging AndAlso Not Me.ParentForm Is Nothing Then
            Dim newMousePoint As Point = System.Windows.Forms.Cursor.Position
            Dim deltaX As Integer = newMousePoint.X - mDragBeginMousePoint.X
            Dim deltaY As Integer = newMousePoint.Y - mDragBeginMousePoint.Y
            Me.ParentForm.Location = New Point(mDragBeginWindowPoint.X + deltaX, mDragBeginWindowPoint.Y + deltaY)
        End If
    End Sub
End Class
