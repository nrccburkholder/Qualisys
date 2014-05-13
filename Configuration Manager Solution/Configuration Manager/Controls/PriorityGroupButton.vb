Imports System.Drawing.Drawing2D
Imports System.Collections.ObjectModel
Imports Nrc.QualiSys.Library

Public Class PriorityGroupButton

#Region " Private Members "
    Private mSmallFont As Font
    Private mPriority As Integer
    Private mBorderPath As GraphicsPath
    Private mIsDragOver As Boolean
    Private mIsSelected As Boolean
    Private mSelectedUnits As New Collection(Of SampleUnit)
    Private mBackColor As Color
    Private mBackColorSelected As Color
    Private mBackColorHover As Color
    Private mBorderColor As Color
#End Region

#Region " Public Properties "
    Public Property Priority() As Integer
        Get
            Return mPriority
        End Get
        Set(ByVal value As Integer)
            mPriority = value
            Me.SetUnitPriorities()
        End Set
    End Property

    Public Property IsSelected() As Boolean
        Get
            Return mIsSelected
        End Get
        Set(ByVal value As Boolean)
            mIsSelected = value
            Me.Invalidate()
        End Set
    End Property

    Public Property SampleUnits() As Collection(Of SampleUnit)
        Get
            Return mSelectedUnits
        End Get
        Set(ByVal value As Collection(Of SampleUnit))
            mSelectedUnits = value
            Me.SetUnitPriorities()
        End Set
    End Property

    Public ReadOnly Property IsDeletable() As Boolean
        Get
            If (mSelectedUnits Is Nothing OrElse mSelectedUnits.Count = 0) Then
                Return True
            Else
                Return False
            End If
        End Get
    End Property

    Private Property SmallFont() As Font
        Get
            Return mSmallFont
        End Get
        Set(ByVal value As Font)
            mSmallFont = value
        End Set
    End Property

#End Region

#Region " Constructors "
    Sub New()
        ' This call is required by the Windows Form Designer.
        InitializeComponent()

        'Set the default size
        Me.Size = New Size(50, 50)
        'Set the default font
        Me.Font = New System.Drawing.Font("Tahoma", 18.0!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.SmallFont = New System.Drawing.Font("Tahoma", 8.0!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))

        'Allow drop
        Me.AllowDrop = True
        Me.InitColors()
        AddHandler Microsoft.Win32.SystemEvents.UserPreferenceChanged, AddressOf UserPreferenceChangedEventHandler
    End Sub
#End Region

#Region " Base Class Overrides "
    Protected Overrides Sub OnPaint(ByVal pe As System.Windows.Forms.PaintEventArgs)
        MyBase.OnPaint(pe)

        Dim g As Graphics = pe.Graphics
        Dim rect As Rectangle = Me.DisplayRectangle
        Dim drawRect As Rectangle
        Dim space As Single = (rect.Height - Me.Font.GetHeight(g) - Me.SmallFont.GetHeight(g)) / 3
        Dim x1, x2, y1, y2, width, height As Integer

        'Draw the priority string
        Dim format As New StringFormat
        format.Alignment = StringAlignment.Center
        format.LineAlignment = StringAlignment.Center

        x1 = rect.X
        y1 = CInt(space)
        width = rect.Width
        height = CInt(Me.Font.GetHeight(g))
        drawRect = New Rectangle(x1, y1, width, height)
        g.DrawString(Me.mPriority.ToString, Me.Font, Brushes.Black, drawRect, format)

        'Draw the sample unit count
        x1 = rect.X
        y1 = CInt(space + Me.Font.GetHeight(g) + space)
        width = rect.Width
        height = CInt(Me.SmallFont.GetHeight(g))
        drawRect = New Rectangle(x1, y1, width, height)
        g.DrawString("(" & Me.mSelectedUnits.Count & ")", Me.SmallFont, Brushes.Black, drawRect, format)

        'Determine the background color 
        Dim backColor As Color
        If Me.mIsSelected Then
            backColor = Me.mBackColorSelected
        ElseIf Me.mIsDragOver Then
            backColor = Me.mBackColorHover
        Else
            backColor = Me.mBackColor
        End If

        'Now take the background color and make it semi-transparent
        backColor = Color.FromArgb(128, backColor.R, backColor.G, backColor.B)

        'Fill the rounded rect with the back color
        Using backbrush As New SolidBrush(backColor)
            g.FillPath(backbrush, Me.mBorderPath)
        End Using

        Using borderPen As New Pen(mBorderColor)
            'Draw the border of the rounded rect
            g.DrawPath(borderPen, Me.mBorderPath)

            'Draw separator line
            x1 = rect.X + CInt(rect.Width / 6)
            x2 = rect.X + CInt(rect.Width * 5 / 6)
            y1 = CInt(space + Me.Font.GetHeight(g) - 1)
            y2 = y1
            g.DrawLine(borderPen, x1, y1, x2, y2)
        End Using
    End Sub

    Protected Overrides Sub OnResize(ByVal e As System.EventArgs)
        MyBase.OnResize(e)
        'Recalculate the rounded rect border
        Me.SetBorderPath()
        Me.Invalidate()
    End Sub

    Protected Overrides Sub OnDragEnter(ByVal drgevent As System.Windows.Forms.DragEventArgs)
        MyBase.OnDragEnter(drgevent)
        If (drgevent.Effect = DragDropEffects.None) Then Return

        'Allow dragging for SampleUnit data
        If (drgevent.Data.GetDataPresent(GetType(SampleUnit)) OrElse _
            drgevent.Data.GetDataPresent(GetType(Collection(Of SampleUnit)))) Then

            drgevent.Effect = DragDropEffects.Move

            'Set the Drag Flag so background changes
            Me.mIsDragOver = True
            Me.Invalidate()
        End If
    End Sub

    Protected Overrides Sub OnDragDrop(ByVal drgevent As System.Windows.Forms.DragEventArgs)
        MyBase.OnDragDrop(drgevent)

        'Reset the flag so background changes back
        Me.mIsDragOver = False
        Me.Invalidate()
    End Sub

    Protected Overrides Sub OnDragLeave(ByVal e As System.EventArgs)
        MyBase.OnDragLeave(e)

        'Reset the flag so background changes back
        Me.mIsDragOver = False
        Me.Invalidate()
    End Sub
#End Region

#Region " Private Methods "
    Private Sub UserPreferenceChangedEventHandler(ByVal sender As Object, ByVal e As Microsoft.Win32.UserPreferenceChangedEventArgs)
        Me.InitColors()
        Me.Invalidate()
    End Sub
    Private Sub InitColors()
        'Determine the background colors
        If Application.RenderWithVisualStyles Then
            Me.mBackColor = ProfessionalColors.ImageMarginGradientMiddle
            Me.mBackColorSelected = ProfessionalColors.ImageMarginGradientEnd
            Me.mBackColorHover = ProfessionalColors.ButtonPressedHighlight
            Me.mBorderColor = ProfessionalColors.ToolStripBorder
        Else
            Me.mBackColor = Color.FromArgb(203, 255, 252)
            Me.mBackColorSelected = Color.FromArgb(123, 164, 224)
            Me.mBackColorHover = Color.FromArgb(150, 179, 225)
            Me.mBorderColor = Color.FromArgb(59, 97, 156)
        End If
    End Sub
    Private Sub SetBorderPath()
        'Compute and store the border path
        Dim rect As Rectangle = Me.DisplayRectangle
        rect.Inflate(-1, -1)

        mBorderPath = GetRoundedRectPath(rect, 10)
    End Sub

    Private Sub SetUnitPriorities()
        'Set all units to be the priority of this control
        For Each unit As SampleUnit In Me.mSelectedUnits
            unit.Priority = Me.mPriority
        Next
    End Sub

    Private Shared Function GetRoundedRectPath(ByVal rect As Rectangle, ByVal radius As Integer) As GraphicsPath
        'Creates a rounded rectangle path

        Dim diameter As Integer = 2 * radius
        Dim arcRect As New Rectangle(rect.Location, New Size(diameter, diameter))
        Dim path As New GraphicsPath

        'top left
        path.AddArc(arcRect, 180, 90)

        'top right
        arcRect.X = rect.Right - diameter
        path.AddArc(arcRect, 270, 90)

        'bottom right
        arcRect.Y = rect.Bottom - diameter
        path.AddArc(arcRect, 0, 90)

        'bottom left
        arcRect.X = rect.Left
        path.AddArc(arcRect, 90, 90)

        path.CloseFigure()
        Return path
    End Function
#End Region

End Class
