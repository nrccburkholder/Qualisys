Imports System.Drawing
Imports System.Drawing.Drawing2D

Public Class ListLaunchButton
    Inherits LaunchButton

    Private mBorderPen As Pen
    Private mBorderPenHot As Pen
    Private mBackBrush As Brush
    Private mBackBrushHot As Brush
    Private mImageSize As Size
    Private mBorderPath As GraphicsPath

    Sub New()
        MyBase.New()
        Me.Size = New Size(150, 42)
        mImageSize = New Size(32, 32)
        InitBrushes()
        InitBorderPath()
    End Sub

    Protected Overrides Sub InitBrushes()
        DisposeBrushes()

        Me.mBackBrush = New SolidBrush(Me.BackColor)
        Me.mBackBrushHot = New SolidBrush(Color.LemonChiffon)

        If Windows.Forms.Application.RenderWithVisualStyles Then
            Me.mBorderPen = New Pen(ProfessionalColors.ToolStripBorder)
            Me.mBorderPenHot = New Pen(ProfessionalColors.MenuItemSelectedGradientBegin)
        Else
            Me.mBorderPen = New Pen(Color.FromArgb(59, 97, 156))
            Me.mBorderPenHot = New Pen(Color.FromArgb(255, 255, 222))
        End If
    End Sub

    Private Sub InitBorderPath()
        If mBorderPath IsNot Nothing Then mBorderPath.Dispose()

        mBorderPath = GetRoundedRectPath(New Rectangle(0, 0, Me.Width - 1, Me.Height - 1), 10)
    End Sub


    Protected Overrides Sub DisposeBrushes()
        If mBackBrush IsNot Nothing Then mBackBrush.Dispose()
        If mBackBrushHot IsNot Nothing Then mBackBrushHot.Dispose()
        If mBorderPen IsNot Nothing Then mBorderPen.Dispose()
        If mBorderPenHot IsNot Nothing Then mBorderPenHot.Dispose()
    End Sub

    Protected Overrides Sub PaintBackground(ByVal g As System.Drawing.Graphics)
        g.FillRectangle(mBackBrush, Me.DisplayRectangle)
        'If IsPushed Then
        '    g.FillRectangle(mBackBrush, Me.DisplayRectangle)
        'ElseIf IsHot Then
        '    g.FillRectangle(mBackBrushHot, Me.DisplayRectangle)
        'Else
        '    g.FillRectangle(mBackBrush, Me.DisplayRectangle)
        'End If
    End Sub

    Protected Overrides Sub PaintControl(ByVal g As System.Drawing.Graphics)
        Dim outerRect As New Rectangle(0, 0, Me.Width - 1, Me.Height - 1)
        PaintBorder(g, outerRect)

        Dim innerRect As New Rectangle(5, 5, Me.Width - 6, Me.Height - 6)
        PaintButton(g, innerRect)
    End Sub

    Private Sub PaintBorder(ByVal g As Graphics, ByVal rect As Rectangle)
        Dim state As GraphicsState = g.Save
        g.SmoothingMode = SmoothingMode.AntiAlias

        If IsPushed Then
            'g.DrawPath(mBorderPen, mBorderPath)
        ElseIf IsHot Then
            g.DrawPath(mBorderPenHot, mBorderPath)
        Else
            'g.DrawPath(mBorderPen, mBorderPath)
        End If

        g.Restore(state)
    End Sub

    Private Sub PaintButton(ByVal g As Graphics, ByVal rect As Rectangle)
        Dim imageRect As New Rectangle(rect.Left, rect.Top, mImageSize.Width, mImageSize.Height)
        Dim textRect As New Rectangle(rect.Left + mImageSize.Width + 2, rect.Top, rect.Width - mImageSize.Width - 2, rect.Height)
        Dim textFormat As New StringFormat

        If Me.Application IsNot Nothing Then
            textFormat.Alignment = StringAlignment.Near
            textFormat.LineAlignment = StringAlignment.Center
            textFormat.Trimming = StringTrimming.EllipsisWord
            Using fontBrush As New SolidBrush(Me.ForeColor)
                g.DrawString(Me.Application.Name, Me.Font, fontBrush, textRect, textFormat)
            End Using

            If Me.Application.Image IsNot Nothing Then
                g.DrawImage(Me.Application.Image, imageRect)
            End If
        End If
    End Sub

    Protected Overrides Sub OnResize(ByVal e As System.EventArgs)
        MyBase.OnResize(e)

        InitBorderPath()
        Me.Invalidate()
    End Sub
End Class
