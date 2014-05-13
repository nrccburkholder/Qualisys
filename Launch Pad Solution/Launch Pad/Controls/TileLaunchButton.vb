Imports System.Drawing
Imports System.Drawing.Drawing2D

Public Class TileLaunchButton
    Inherits LaunchButton

    Private mBorderPen As Pen
    Private mBorderPenHot As Pen
    Private mBackBrush As Brush
    Private mBackBrushHot As Brush
    Private mBackBrushPushed As Brush
    Private mBorderPath As GraphicsPath

    Private ReadOnly mImageSize As Size

    Private ReadOnly Property BackBrush() As Brush
        Get
            If IsPushed Then
                Return mBackBrushPushed
            ElseIf IsHot Then
                Return mBackBrushHot
            Else
                Return mBackBrush
            End If
        End Get
    End Property


    Sub New()
        MyBase.New()
        Me.Size = New Size(100, 75)
        mImageSize = New Size(32, 32)
        InitBrushes()
        InitBorderPath()
    End Sub

    Protected Overrides Sub InitBrushes()
        Me.DisposeBrushes()

        mBackBrush = New SolidBrush(Me.BackColor)
        mBackBrushHot = New SolidBrush(Me.BackColor)
        mBackBrushPushed = New SolidBrush(Color.SteelBlue)

        If Windows.Forms.Application.RenderWithVisualStyles Then
            mBorderPen = New Pen(ProfessionalColors.ToolStripBorder)
            mBorderPenHot = New Pen(ProfessionalColors.MenuItemSelectedGradientBegin)
        Else
            mBorderPen = New Pen(Color.FromArgb(59, 97, 156))
            mBorderPenHot = New Pen(Color.FromArgb(255, 255, 222))
        End If
    End Sub

    Protected Overrides Sub DisposeBrushes()
        If mBackBrush IsNot Nothing Then mBackBrush.Dispose()
        If mBackBrushHot IsNot Nothing Then mBackBrushHot.Dispose()
        If mBackBrushPushed IsNot Nothing Then mBackBrushPushed.Dispose()
        If mBorderPen IsNot Nothing Then mBorderPen.Dispose()
        If mBorderPenHot IsNot Nothing Then mBorderPenHot.Dispose()
    End Sub

    Private Sub InitBorderPath()
        If mBorderPath IsNot Nothing Then mBorderPath.Dispose()

        mBorderPath = GetRoundedRectPath(New Rectangle(0, 0, Me.Width - 1, Me.Height - 1), 10)
    End Sub

    Protected Overrides Sub PaintControl(ByVal g As Graphics)
        Dim outerRect As New Rectangle(0, 0, Me.Width - 1, Me.Height - 1)
        Me.PaintBorder(g, outerRect)

        Dim innerRect As New Rectangle(5, 5, Me.Width - 10, Me.Height - 10)
        Me.PaintButton(g, innerRect)
    End Sub

    Protected Overrides Sub PaintBackground(ByVal g As Graphics)
        g.FillRectangle(mBackBrush, Me.DisplayRectangle)

        If IsPushed Then
            g.FillPath(mBackBrushPushed, mBorderPath)
        End If
    End Sub

    Private Sub PaintBorder(ByVal g As Graphics, ByVal rect As Rectangle)
        Dim state As GraphicsState = g.Save
        g.SmoothingMode = SmoothingMode.AntiAlias

        If IsPushed Then
            g.DrawPath(mBorderPen, mBorderPath)
        ElseIf IsHot Then
            g.DrawPath(mBorderPenHot, mBorderPath)
        Else
            g.DrawPath(mBorderPen, mBorderPath)
        End If

        g.Restore(state)
    End Sub

    Private Sub PaintButton(ByVal g As Graphics, ByVal rect As Rectangle)
        Dim imageRect As New Rectangle((rect.Width \ 2) - (mImageSize.Width \ 2) + 5, rect.Top, mImageSize.Width, mImageSize.Height)
        Dim textRect As New Rectangle(rect.Left, mImageSize.Height, rect.Width, rect.Height - mImageSize.Height)
        Dim textFormat As New StringFormat

        If Me.Application IsNot Nothing Then
            textFormat.Alignment = StringAlignment.Center
            textFormat.LineAlignment = StringAlignment.Far
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
        Me.InitBorderPath()
        Me.Invalidate()
    End Sub


End Class
