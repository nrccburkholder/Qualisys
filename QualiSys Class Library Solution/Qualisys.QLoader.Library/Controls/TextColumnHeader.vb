Option Explicit On 
Option Strict On
Imports System.Drawing

Public Class TextColumnHeader
    Inherits System.Windows.Forms.UserControl

#Region " Private Members "

    Private mShowHeader As Boolean
    Private mColumns As ColumnCollection
    Private mCharWidth As Integer
    Private mCharHeight As Integer
    Private mVisibleLeft As Integer
    Private mVisibleRight As Integer
    Private mCanSelectColumn As Boolean
    Private mDrawColumnBorder As Boolean = True
    Private mPrevVisibleLeft As Integer = -1
    Private mColumnSizes() As TextColumnSize

#End Region

#Region " User Events "

    Event HeaderClick(ByVal pt As Point)    'On click event

#End Region

#Region " Windows Form Designer generated code "

    Public Sub New()
        MyBase.New()

        'This call is required by the Windows Form Designer.
        InitializeComponent()

        'Add any initialization after the InitializeComponent() call

    End Sub

    'UserControl overrides dispose to clean up the component list.
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
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        '
        'TextColumnHeader
        '
        Me.BackColor = System.Drawing.SystemColors.Control
        Me.Name = "TextColumnHeader"
        Me.Size = New System.Drawing.Size(150, 24)

    End Sub

#End Region

#Region " Public Properties "
    Public Property ShowHeader() As Boolean
        Get
            Return (mShowHeader)
        End Get
        Set(ByVal Value As Boolean)
            mShowHeader = Value
            Me.Visible = Value
        End Set
    End Property

    Public Property Columns() As ColumnCollection
        Get
            Return (mColumns)
        End Get
        Set(ByVal Value As ColumnCollection)
            If (Value Is Nothing) Then Return
            If (Value.Count = 0) Then Return
            mColumns = Value
            ResetColumnSize()
        End Set
    End Property

    Public Property CharWidth() As Integer
        Get
            Return (mCharWidth)
        End Get
        Set(ByVal Value As Integer)
            mCharWidth = Value
            ResetColumnSize()
        End Set
    End Property

    Public Property CharHeight() As Integer
        Get
            Return (mCharHeight)
        End Get
        Set(ByVal Value As Integer)
            mCharHeight = Value
        End Set
    End Property

    Public Property HScrollPos() As Integer
        Get
            Return (mVisibleLeft)
        End Get
        Set(ByVal Value As Integer)
            mVisibleLeft = Value
            mVisibleRight = Value + Me.Width - 1
            PaintHeader(False)
        End Set
    End Property

    Public Property CanSelectColumn() As Boolean
        Get
            Return (mCanSelectColumn)
        End Get
        Set(ByVal Value As Boolean)
            mCanSelectColumn = Value
        End Set
    End Property

    Public Property ColumnName(ByVal index As Integer) As String
        Get
            If (mColumns Is Nothing) Then Return ""
            If (index < 0 Or index >= mColumns.Count) Then Return ""
            Return (mColumns(index).ColumnName)
        End Get
        Set(ByVal Value As String)
            If (mColumns Is Nothing) Then Return
            If (index < 0 Or index >= mColumns.Count) Then Return
            mColumns(index).ColumnName = Value
        End Set
    End Property

    Public ReadOnly Property ColumnLength(ByVal index As Integer) As Integer
        Get
            If (mColumns Is Nothing) Then Return 0
            If (index < 0 Or index >= mColumns.Count) Then Return 0
            Return (mColumns(index).Length)
        End Get
    End Property
    Public Property DrawColumnBorder() As Boolean
        Get
            Return (mDrawColumnBorder)
        End Get
        Set(ByVal Value As Boolean)
            mDrawColumnBorder = Value
        End Set
    End Property

#End Region

#Region " Public/Protected/Friend Methods "

    Protected Overrides Sub OnPaint(ByVal e As System.Windows.Forms.PaintEventArgs)
        MyBase.OnPaint(e)
        PaintHeader(e.Graphics, True)
    End Sub

    Friend Sub PaintHeader(ByVal mustDraw As Boolean)
        PaintHeader(Me.CreateGraphics, mustDraw)
    End Sub


    Public Sub ResetPosition()
        mVisibleLeft = 0
        mVisibleRight = Me.Width - 1
        mPrevVisibleLeft = -1
        Me.PaintHeader(True)
    End Sub

#End Region

#Region " Private Methods "

    Private Sub PaintHeader(ByVal graph As Graphics, ByVal mustDraw As Boolean)
        Dim pen As New pen(Color.Black)
        Dim brush As New SolidBrush(Color.Black)
        Dim col As Integer
        Dim chr As Integer
        Dim x As Integer
        Dim y As Integer = TextColumnDefaultValue.HEADER_VERTICAL_PADDING
        Dim len As Integer
        Dim firstVisibleColumn As Integer = -1
        Dim lastVisibleColumn As Integer
        Dim columnNum As Integer
        Dim lastColumn As Integer

        If (Not ShowHeader) Then Return
        If (Columns Is Nothing) Then Return

        columnNum = Columns.Count
        lastColumn = columnNum - 1

        'Find the first and last visible column
        For col = 0 To lastColumn
            If (mColumnSizes(col).Left <= mVisibleLeft AndAlso _
                mColumnSizes(col).Right >= mVisibleLeft) Then
                firstVisibleColumn = col
                Exit For
            End If
        Next

        For col = firstVisibleColumn To lastColumn
            If (mColumnSizes(col).Left > mVisibleRight) Then Exit For
            lastVisibleColumn = col
        Next

        'Check the validity of "firstVisibleColumn" and "lastVisibleColumn".
        'Hope this will never be used
        If (firstVisibleColumn < 0) Then
            firstVisibleColumn = lastColumn
        End If
        If (lastVisibleColumn > lastColumn) Then
            lastVisibleColumn = lastColumn
        End If
        If (lastVisibleColumn < firstVisibleColumn) Then
            lastVisibleColumn = firstVisibleColumn
        End If

        'Check if need to draw or not
        If ((Not mustDraw) AndAlso (mVisibleLeft = mPrevVisibleLeft)) Then
            Return
        End If

        'Save visible area left border
        mPrevVisibleLeft = mVisibleLeft

        'reset background and draw header area border
        graph.Clear(Me.BackColor)
        graph.DrawRectangle(pen, 0, 0, Me.Width - 1, Me.Height - 1)

        'Draw column's right border
        If (mDrawColumnBorder) Then
            For col = firstVisibleColumn To lastVisibleColumn
                x = mColumnSizes(col).Right - mVisibleLeft
                graph.DrawLine(pen, x, 0, x, Me.Height)
            Next
        End If

        'Draw text
        For col = firstVisibleColumn To lastVisibleColumn
            If (ColumnName(col) Is Nothing) Then GoTo NextColumn
            With mColumnSizes(col)
                x = mColumnSizes(col).Left - mVisibleLeft _
                    + TextColumnDefaultValue.COLUMN_HORIZONTAL_PADDING _
                    - TextColumnDefaultValue.X_OFFSET
                len = CInt(IIf(ColumnName(col).Length < .Length, ColumnName(col).Length, .Length))
                For chr = 0 To len - 1
                    graph.DrawString(ColumnName(col).Substring(chr, 1), _
                                     Me.Font, _
                                     brush, _
                                     x, _
                                     y)
                    x += mCharWidth + TextColumnDefaultValue.CHAR_SPACING
                Next
            End With
NextColumn:
        Next

    End Sub

    Private Sub ResetColumnSize()
        If ((mColumns Is Nothing) OrElse (mColumns.Count = 0)) Then Return
        ReDim mColumnSizes(mColumns.Count - 1)
        Dim i As Integer
        Dim pos As Integer = 0
        Dim width As Integer

        For i = 0 To mColumns.Count - 1
            width = mCharWidth * Columns(i).Length _
                     + 2 * TextColumnDefaultValue.COLUMN_HORIZONTAL_PADDING _
                     + TextColumnDefaultValue.BREAK_LINE_WIDTH

            With mColumnSizes(i)
                .Left = pos
                .Width = width
                .Right = .Left + width - 1
                .Length = Columns(i).Length
                pos = .Right + 1
            End With
        Next
    End Sub

    'Private Sub ResetColumnSize()
    '    If (mColumnSizes Is Nothing) Then Return

    '    Dim i As Integer
    '    Dim totalWidth As Integer = 0

    '    'Calculate column width (pixel)
    '    For i = 0 To mColumnSizes.GetUpperBound(0)
    '        With mColumnSizes(i)
    '            .width = mCharWidth * .Length + 2 * TextColumnDefaultValue.COLUMN_HORIZONTAL_PADDING
    '            totalWidth += .width
    '        End With
    '    Next

    '    'show all the columns if Header area is wide enough
    '    If (totalWidth <= Me.Width) Then
    '        For i = 0 To mColumnSizes.GetUpperBound(0)
    '            mColumnSizes(i).HScrollPosMax = 100
    '        Next
    '        Return
    '    End If

    '    'calculate how many columns from the end can be shown in the visible 
    '    'area when scroll to the right end
    '    Dim showWidth As Integer = 0
    '    For i = mColumnSizes.GetUpperBound(0) To 0 Step -1
    '        If (showWidth + mColumnSizes(i).width > Me.Width) Then
    '            Exit For
    '        End If
    '        showWidth += mColumnSizes(i).width
    '    Next
    '    'At least the last column need to be shown
    '    If (showWidth = 0) Then
    '        showWidth = mColumnSizes(mColumnSizes.GetUpperBound(0)).width
    '    End If

    '    'calculate the max HScrollPos for each column
    '    Dim scrollableWidth As Integer = totalWidth - showWidth
    '    If (scrollableWidth < 0) Then scrollableWidth = 0

    '    Dim preWidth As Integer = 0
    '    For i = 0 To mColumnSizes.GetUpperBound(0)
    '        With mColumnSizes(i)
    '            If (scrollableWidth = 0) Then
    '                .HScrollPosMax = 100
    '            Else
    '                .HScrollPosMax = CInt(Math.Floor(100.0 * (preWidth + .width - 1) / scrollableWidth))
    '                If (.HScrollPosMax > 100) Then .HScrollPosMax = 100
    '                If (.HScrollPosMax < 0) Then .HScrollPosMax = 0
    '                preWidth += .width
    '            End If
    '        End With
    '    Next
    'End Sub

    Private Sub TextColumnHeader_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles MyBase.Click
        If (Not mCanSelectColumn) Then Return

        'get the mouse point relative to this control
        Dim pt As Point = Me.PointToClient(System.Windows.Forms.Cursor.Position)

        'Raise the click event
        RaiseEvent HeaderClick(pt)
    End Sub

#End Region

End Class
