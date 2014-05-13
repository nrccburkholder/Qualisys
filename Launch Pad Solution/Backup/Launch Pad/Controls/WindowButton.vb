Imports System.ComponentModel
Imports System.Windows.Forms.VisualStyles

Public Enum WindowButtonType
    Close
    Minimize
    Maximize
    Restore
End Enum

Public Class WindowButton
    Inherits ButtonBase

    Private mIsPushed As Boolean
    Private mIsHot As Boolean

    Private mButtonType As WindowButtonType = LaunchPad.WindowButtonType.Close

    Private mHotRenderer As VisualStyleRenderer
    Private mPushedRenderer As VisualStyleRenderer
    Private mNormalRenderer As VisualStyleRenderer
    Private mDisabledRenderer As VisualStyleRenderer

    <Category("Appearance")> _
    Public Property WindowButtonType() As WindowButtonType
        Get
            Return mButtonType
        End Get
        Set(ByVal value As WindowButtonType)
            mButtonType = value
            Me.InitRenderers()
            Me.Invalidate()
        End Set
    End Property

    Sub New()
        Me.Size = New Size(20, 20)
        InitRenderers()
    End Sub

    Sub New(ByVal buttonType As WindowButtonType)
        Me.New()
        Me.WindowButtonType = buttonType
    End Sub

    Private Sub InitRenderers()
        If System.Windows.Forms.Application.RenderWithVisualStyles Then
            Select Case Me.mButtonType
                Case LaunchPad.WindowButtonType.Close
                    mHotRenderer = New VisualStyleRenderer(VisualStyleElement.Window.CloseButton.Hot)
                    mPushedRenderer = New VisualStyleRenderer(VisualStyleElement.Window.CloseButton.Pressed)
                    mNormalRenderer = New VisualStyleRenderer(VisualStyleElement.Window.CloseButton.Normal)
                    mDisabledRenderer = New VisualStyleRenderer(VisualStyleElement.Window.CloseButton.Disabled)
                Case LaunchPad.WindowButtonType.Maximize
                    mHotRenderer = New VisualStyleRenderer(VisualStyleElement.Window.MaxButton.Hot)
                    mPushedRenderer = New VisualStyleRenderer(VisualStyleElement.Window.MaxButton.Pressed)
                    mNormalRenderer = New VisualStyleRenderer(VisualStyleElement.Window.MaxButton.Normal)
                    mDisabledRenderer = New VisualStyleRenderer(VisualStyleElement.Window.MaxButton.Disabled)
                Case LaunchPad.WindowButtonType.Minimize
                    mHotRenderer = New VisualStyleRenderer(VisualStyleElement.Window.MinButton.Hot)
                    mPushedRenderer = New VisualStyleRenderer(VisualStyleElement.Window.MinButton.Pressed)
                    mNormalRenderer = New VisualStyleRenderer(VisualStyleElement.Window.MinButton.Normal)
                    mDisabledRenderer = New VisualStyleRenderer(VisualStyleElement.Window.MinButton.Disabled)
                Case LaunchPad.WindowButtonType.Restore
                    mHotRenderer = New VisualStyleRenderer(VisualStyleElement.Window.RestoreButton.Hot)
                    mPushedRenderer = New VisualStyleRenderer(VisualStyleElement.Window.RestoreButton.Pressed)
                    mNormalRenderer = New VisualStyleRenderer(VisualStyleElement.Window.RestoreButton.Normal)
                    mDisabledRenderer = New VisualStyleRenderer(VisualStyleElement.Window.RestoreButton.Disabled)
            End Select
        End If
    End Sub

    Protected Overrides Sub OnPaint(ByVal pevent As System.Windows.Forms.PaintEventArgs)
        'MyBase.OnPaint(pevent)
        If Not Me.Enabled Then
            Me.DrawButton(pevent.Graphics, mDisabledRenderer)
        ElseIf mIsPushed Then
            Me.DrawButton(pevent.Graphics, mPushedRenderer)
        ElseIf mIsHot Then
            Me.DrawButton(pevent.Graphics, mHotRenderer)
        Else
            Me.DrawButton(pevent.Graphics, mNormalRenderer)
        End If
    End Sub

    Private Sub DrawButton(ByVal g As Graphics, ByVal renderer As VisualStyleRenderer)
        If System.Windows.Forms.Application.RenderWithVisualStyles Then
            renderer.DrawBackground(g, Me.DisplayRectangle)
        Else
            If Me.mIsPushed Then
                'System.Windows.Forms.ControlPaint.DrawButton(g, Me.DisplayRectangle, ButtonState.Pushed)
                Select Case Me.mButtonType
                    Case LaunchPad.WindowButtonType.Close
                        g.DrawImage(My.Resources.CloseImage, Me.DisplayRectangle)
                    Case LaunchPad.WindowButtonType.Minimize
                        g.DrawImage(My.Resources.MinimizeImage, Me.DisplayRectangle)
                End Select
            Else
                'System.Windows.Forms.ControlPaint.DrawButton(g, Me.DisplayRectangle, ButtonState.Normal)
                Select Case Me.mButtonType
                    Case LaunchPad.WindowButtonType.Close
                        g.DrawImage(My.Resources.CloseImage, Me.DisplayRectangle)
                    Case LaunchPad.WindowButtonType.Minimize
                        g.DrawImage(My.Resources.MinimizeImage, Me.DisplayRectangle)
                End Select
            End If
        End If
    End Sub

    Protected Overrides Sub OnMouseDown(ByVal mevent As System.Windows.Forms.MouseEventArgs)
        MyBase.OnMouseDown(mevent)
        If mevent.Button = Windows.Forms.MouseButtons.Left Then
            Me.mIsPushed = True
            Me.Invalidate()
        End If
    End Sub
    Protected Overrides Sub OnMouseUp(ByVal mevent As System.Windows.Forms.MouseEventArgs)
        MyBase.OnMouseUp(mevent)
        If mevent.Button = Windows.Forms.MouseButtons.Left Then
            Me.mIsPushed = False
            Me.Invalidate()
        End If
    End Sub

    Protected Overrides Sub OnMouseEnter(ByVal eventargs As System.EventArgs)
        MyBase.OnMouseEnter(eventargs)
        mIsHot = True
        Me.Invalidate()
    End Sub

    Protected Overrides Sub OnMouseLeave(ByVal eventargs As System.EventArgs)
        MyBase.OnMouseLeave(eventargs)
        mIsHot = False
        Me.Invalidate()
    End Sub

End Class
