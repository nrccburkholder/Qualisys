Imports System.Drawing
Imports System.Drawing.Drawing2D

Public Class BluesRenderer
    Inherits ToolStripProfessionalRenderer

    Private mMenuStripBeginColor As Color = Color.FromArgb(158, 190, 245)
    Private mMenuStripEndColor As Color = Color.FromArgb(196, 218, 250)
    Private mImageMarginBeginColor As Color = Color.FromArgb(227, 239, 255)
    Private mImageMarginMiddleColor As Color = Color.FromArgb(203, 225, 252)
    Private mImageMarginEndColor As Color = Color.FromArgb(123, 164, 224)

    Protected Overrides Sub OnRenderToolStripBackground(ByVal e As System.Windows.Forms.ToolStripRenderEventArgs)
        Dim strip As ToolStrip = e.ToolStrip
        If TypeOf strip Is ToolStripDropDown Then
            Me.RenderToolStripDropDownBackground(e)
        Else
            If TypeOf strip Is MenuStrip Then
                Me.RenderMenuStripBackground(e)
            Else
                If TypeOf strip Is StatusStrip Then
                    Me.RenderStatusStripBackground(e)
                Else
                    Me.RenderToolStripBackgroundInternal(e)
                End If
            End If
        End If

    End Sub

    Protected Overrides Sub OnRenderImageMargin(ByVal e As System.Windows.Forms.ToolStripRenderEventArgs)
        Dim g As Graphics = e.Graphics
        Dim rect As Rectangle = e.AffectedBounds
        rect.Y = (rect.Y + 2)
        rect.Height = (rect.Height - 4)
        Dim direction As RightToLeft = e.ToolStrip.RightToLeft
        Dim beginColor As Color
        Dim endColor As Color
        If direction = RightToLeft.No Then
            beginColor = mImageMarginBeginColor
            endColor = mImageMarginEndColor
        Else
            beginColor = mImageMarginEndColor
            endColor = mImageMarginBeginColor
        End If

        Me.FillWithDoubleGradient(beginColor, mImageMarginMiddleColor, endColor, e.Graphics, rect, 12, 12, LinearGradientMode.Horizontal, (e.ToolStrip.RightToLeft = RightToLeft.Yes))
    End Sub

    Private Sub RenderToolStripDropDownBackground(ByVal e As ToolStripRenderEventArgs)
        Dim strip As ToolStrip = e.ToolStrip
        Dim rect As New Rectangle(Point.Empty, e.ToolStrip.Size)
        Using backBrush As Brush = New SolidBrush(Me.ColorTable.ToolStripDropDownBackground)
            e.Graphics.FillRectangle(backBrush, rect)
        End Using


    End Sub

    Private Sub RenderMenuStripBackground(ByVal e As ToolStripRenderEventArgs)
        'Me.RenderBackgroundGradient(e.Graphics, e.ToolStrip, Me.ColorTable.MenuStripGradientBegin, Me.ColorTable.MenuStripGradientEnd, e.ToolStrip.Orientation)
        Me.RenderBackgroundGradient(e.Graphics, e.ToolStrip, mMenuStripBeginColor, mMenuStripEndColor, e.ToolStrip.Orientation)
    End Sub

    Private Sub RenderStatusStripBackground(ByVal e As ToolStripRenderEventArgs)
        Dim strip As StatusStrip = TryCast(e.ToolStrip, StatusStrip)
        'Me.RenderBackgroundGradient(e.Graphics, strip, Me.ColorTable.StatusStripGradientBegin, Me.ColorTable.StatusStripGradientEnd, strip.Orientation)
        Me.RenderBackgroundGradient(e.Graphics, strip, mMenuStripBeginColor, mMenuStripEndColor, strip.Orientation)
    End Sub

    Private Sub RenderToolStripBackgroundInternal(ByVal e As ToolStripRenderEventArgs)
        Dim strip1 As ToolStrip = e.ToolStrip
        Dim graphics1 As Graphics = e.Graphics
        Dim rectangle1 As New Rectangle(Point.Empty, e.ToolStrip.Size)
        Dim mode1 As LinearGradientMode
        If strip1.Orientation = Orientation.Horizontal Then
            mode1 = LinearGradientMode.Vertical
        Else
            mode1 = LinearGradientMode.Horizontal
        End If
        Me.FillWithDoubleGradient(Me.ColorTable.ToolStripGradientBegin, Me.ColorTable.ToolStripGradientMiddle, Me.ColorTable.ToolStripGradientEnd, e.Graphics, rectangle1, 12, 12, mode1, False)
    End Sub

    Private Sub FillWithDoubleGradient(ByVal beginColor As Color, ByVal middleColor As Color, ByVal endColor As Color, ByVal g As Graphics, ByVal bounds As Rectangle, ByVal firstGradientWidth As Integer, ByVal secondGradientWidth As Integer, ByVal mode As LinearGradientMode, ByVal flipHorizontal As Boolean)
        If ((bounds.Width <> 0) AndAlso (bounds.Height <> 0)) Then
            Dim rectangle1 As Rectangle = bounds
            Dim rectangle2 As Rectangle = bounds
            Dim flag1 As Boolean = True
            If (mode = LinearGradientMode.Horizontal) Then
                If flipHorizontal Then
                    Dim color1 As Color = endColor
                    endColor = beginColor
                    beginColor = color1
                End If
                rectangle2.Width = firstGradientWidth
                rectangle1.Width = (secondGradientWidth + 1)
                rectangle1.X = (bounds.Right - rectangle1.Width)
                flag1 = (bounds.Width > (firstGradientWidth + secondGradientWidth))
            Else
                rectangle2.Height = firstGradientWidth
                rectangle1.Height = (secondGradientWidth + 1)
                rectangle1.Y = (bounds.Bottom - rectangle1.Height)
                flag1 = (bounds.Height > (firstGradientWidth + secondGradientWidth))
            End If
            If flag1 Then
                Using brush1 As Brush = New SolidBrush(middleColor)
                    g.FillRectangle(brush1, bounds)
                End Using
                Using brush2 As Brush = New LinearGradientBrush(rectangle2, beginColor, middleColor, mode)
                    g.FillRectangle(brush2, rectangle2)
                End Using
                Using brush3 As LinearGradientBrush = New LinearGradientBrush(rectangle1, middleColor, endColor, mode)
                    If (mode = LinearGradientMode.Horizontal) Then
                        rectangle1.X += 1
                        rectangle1.Width -= 1
                    Else
                        rectangle1.Y += 1
                        rectangle1.Height -= 1
                    End If
                    g.FillRectangle(brush3, rectangle1)
                    Return
                End Using
            End If
            Using brush4 As Brush = New LinearGradientBrush(bounds, beginColor, endColor, mode)
                g.FillRectangle(brush4, bounds)
            End Using
        End If
    End Sub

    Private Sub RenderBackgroundGradient(ByVal g As Graphics, ByVal control As Control, ByVal beginColor As Color, ByVal endColor As Color, ByVal orientation As Orientation)
        If (control.RightToLeft = RightToLeft.Yes) Then
            Dim color1 As Color = beginColor
            beginColor = endColor
            endColor = color1
        End If
        If (orientation = Orientation.Horizontal) Then
            Dim control1 As Control = control.Parent
            If (Not control1 Is Nothing) Then
                Dim rectangle1 As New Rectangle(Point.Empty, control1.Size)
                If rectangle1.Height = 0 OrElse rectangle1.Width = 0 Then
                    Return
                End If
                Using brush1 As LinearGradientBrush = New LinearGradientBrush(rectangle1, beginColor, endColor, LinearGradientMode.Horizontal)
                    brush1.TranslateTransform(CType((control1.Width - control.Location.X), Single), CType((control1.Height - control.Location.Y), Single))
                    g.FillRectangle(brush1, New Rectangle(Point.Empty, control.Size))
                    Return
                End Using
            End If
            Dim rectangle2 As New Rectangle(Point.Empty, control.Size)
            If rectangle2.Height = 0 OrElse rectangle2.Width = 0 Then
                Return
            End If
            Using brush2 As LinearGradientBrush = New LinearGradientBrush(rectangle2, beginColor, endColor, LinearGradientMode.Horizontal)
                g.FillRectangle(brush2, rectangle2)
                Return
            End Using
        End If
        Using brush3 As Brush = New SolidBrush(beginColor)
            g.FillRectangle(brush3, New Rectangle(Point.Empty, control.Size))
        End Using
    End Sub

    'Protected Overrides Sub OnRenderImageMargin(ByVal e As System.Windows.Forms.ToolStripRenderEventArgs)
    '    MyBase.OnRenderImageMargin(e)
    '    Using backBrush As New LinearGradientBrush(e.AffectedBounds, Color.Gainsboro, Color.LightSlateGray, LinearGradientMode.Horizontal)
    '        e.Graphics.FillRectangle(backBrush, e.AffectedBounds)
    '    End Using
    'End Sub

End Class
