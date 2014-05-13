Imports Nrc.QualiSys.Library

Public Class PriorityUnitLabel

#Region " Private Members "
    'By default make the user drag 5 pixels before starting drag
    Private Const mDragMargin As Integer = 5

    Private mUnit As SampleUnit
    Private mIsMouseOver As Boolean
    Private mDragRegion As Rectangle
    Private mIsMouseDown As Boolean
#End Region

#Region " Public Properties "
    Public Property SampleUnit() As SampleUnit
        Get
            Return mUnit
        End Get
        Set(ByVal value As SampleUnit)
            mUnit = value
            Me.Text = mUnit.Name
        End Set
    End Property

#End Region

#Region " Public Events "
    Public Event ItemDrag As EventHandler(Of ItemDragEventArgs)
#End Region

#Region " Constructors "
    Public Sub New()

        ' This call is required by the Windows Form Designer.
        InitializeComponent()

        ' Add any initialization after the InitializeComponent() call.
        Me.TextAlign = ContentAlignment.MiddleLeft
        Me.AutoSize = True
        Me.Padding = New Padding(3)
    End Sub
#End Region

#Region " Base Class Overrides "
    Protected Overrides Sub OnPaintBackground(ByVal pevent As System.Windows.Forms.PaintEventArgs)
        MyBase.OnPaintBackground(pevent)
        Dim g As Graphics = pevent.Graphics

        'If the mouse is over then highlight label
        If Me.mIsMouseOver Then
            Dim rect As Rectangle = Me.DisplayRectangle
            rect.Inflate(-1, -1)
            Using backBrush As New SolidBrush(ProfessionalColors.ImageMarginGradientEnd)
                g.FillRectangle(backBrush, rect)
            End Using
        End If

    End Sub

    Protected Overrides Sub OnPaint(ByVal pe As System.Windows.Forms.PaintEventArgs)
        MyBase.OnPaint(pe)
        Dim g As Graphics = pe.Graphics

        'If the mouse is over then highlight label
        If Me.mIsMouseOver Then
            Dim rect As Rectangle = Me.DisplayRectangle
            rect.Inflate(-1, -1)
            Using borderPen As New Pen(ProfessionalColors.ToolStripBorder)
                g.DrawRectangle(borderPen, rect)
            End Using
        End If
    End Sub

    Protected Overrides Sub OnMouseEnter(ByVal e As System.EventArgs)
        MyBase.OnMouseEnter(e)
        'Set MouseOver 
        Me.mIsMouseOver = True
        Me.Invalidate()
    End Sub

    Protected Overrides Sub OnMouseLeave(ByVal e As System.EventArgs)
        MyBase.OnMouseLeave(e)
        'Reset MouseOver 
        Me.mIsMouseOver = False
        Me.Invalidate()
    End Sub

    Protected Overrides Sub OnMouseDown(ByVal e As System.Windows.Forms.MouseEventArgs)
        MyBase.OnMouseDown(e)
        'When the user Left-Clicks then calculate the region that the mouse
        'can move in before dragging will start
        If e.Button = Windows.Forms.MouseButtons.Left Then
            Me.mIsMouseDown = True
            Dim pt As Point = e.Location
            Me.mDragRegion = New Rectangle(pt.X - mDragMargin, pt.Y - mDragMargin, 2 * mDragMargin, 2 * mDragMargin)
        End If
    End Sub

    Protected Overrides Sub OnMouseUp(ByVal e As System.Windows.Forms.MouseEventArgs)
        MyBase.OnMouseUp(e)
        If e.Button = Windows.Forms.MouseButtons.Left Then
            'Reset MouseDown flag
            Me.mIsMouseDown = False
        End If
    End Sub

    Protected Overrides Sub OnMouseMove(ByVal e As System.Windows.Forms.MouseEventArgs)
        'If the mouse is down then check to see if we have exceeded
        'the drag region, if so then begin dragging
        If Me.mIsMouseDown Then
            If Not Me.mDragRegion.Contains(e.Location) Then
                Me.OnItemDrag(New ItemDragEventArgs(Windows.Forms.MouseButtons.Left))
            End If
        End If
    End Sub

#End Region

#Region " Protected Methods "
    Protected Overridable Sub OnItemDrag(ByVal e As ItemDragEventArgs)
        RaiseEvent ItemDrag(Me, e)
    End Sub
#End Region

End Class
