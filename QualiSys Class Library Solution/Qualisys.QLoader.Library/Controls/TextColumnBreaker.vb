Option Explicit On 
Option Strict On

Imports System.Drawing

Public Class TextColumnBreaker
    Inherits System.Windows.Forms.UserControl

#Region " Private Members "

    Private mColumns As ColumnCollection
    Private mFields()() As String
    Private mCharWidth As Integer
    Private mCharHeight As Integer
    Private mVisibleLeft As Integer
    Private mVisibleRight As Integer
    Private mVScrollPos As Integer
    Private mCanSelectColumn As Boolean
    Private mSelectedColumn As Integer = -1
    Private mDrawColumnBorder As Boolean = True
    Private mPrevVisibleLeft As Integer = -1
    Private mFirstVisibleRow As Integer = -1
    Private mColumnSizes() As TextColumnSize

#End Region

#Region " User Events "

    Event BreakerColumnSelected(ByVal index As Integer) 'column selected event
    Event VisibleAreaMoved(ByVal visibleAreaLeft As Integer) 'visible area moved

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
        'TextColumnBreaker
        '
        Me.BackColor = System.Drawing.Color.White
        Me.Name = "TextColumnBreaker"
        Me.Size = New System.Drawing.Size(248, 184)

    End Sub

#End Region

#Region " Public Properties "
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

    Public Property Fields() As String()()
        Get
            Return (mFields)
        End Get
        Set(ByVal Value As String()())
            mFields = Value
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
            PaintText(False)
        End Set
    End Property

    Public Property VScrollPos() As Integer
        Get
            Return (mVScrollPos)
        End Get
        Set(ByVal Value As Integer)
            mVScrollPos = Value
            PaintText(False)
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

    Public Property SelectedColumn() As Integer
        Get
            Return (mSelectedColumn)
        End Get
        Set(ByVal Value As Integer)
            mSelectedColumn = Value
            Me.PaintText(True)
        End Set
    End Property

    Public Property DrawColumnBorder() As Boolean
        Get
            Return (mDrawColumnBorder)
        End Get
        Set(ByVal Value As Boolean)
            mDrawColumnBorder = Value
        End Set
    End Property

    'Public ReadOnly Property HScrollPos(ByVal column As Integer) As Integer
    '    Get
    '        If (column < 0 OrElse column >= mColumnSizes.Length) Then Return -1
    '        Return (mColumnSizes(column).HScrollPosMax)
    '    End Get
    'End Property
#End Region

#Region " Public/Protect/Friend Methods "

    Public Sub SendClick(ByVal pt As Point)
        SelectColumn(pt)
    End Sub

    Protected Overrides Sub OnPaint(ByVal e As System.Windows.Forms.PaintEventArgs)
        MyBase.OnPaint(e)
        PaintText(e.Graphics, True)
    End Sub

    Friend Sub PaintText(ByVal mustDraw As Boolean)
        PaintText(Me.CreateGraphics, mustDraw)
    End Sub

    Public Sub ResetPosition()
        mVisibleLeft = 0
        mVisibleRight = Me.Width - 1
        mVScrollPos = 0
        mSelectedColumn = -1
        mFirstVisibleRow = -1
        PaintText(True)
    End Sub

    Public Sub Moving(ByVal direction As MoveDirections)
        If Not CanSelectColumn Then Return
        Dim colPos As Integer = 0

        Select Case direction
            Case MoveDirections.Backward
                If (mSelectedColumn = 0) Then
                    Return
                Else
                    mSelectedColumn -= 1
                End If

            Case MoveDirections.Forward
                If (mSelectedColumn = mColumns.Count - 1) Then
                    Return
                Else
                    mSelectedColumn += 1
                End If
        End Select

        PaintText(True)
        VisibleColumn(mSelectedColumn)
        RaiseEvent BreakerColumnSelected(mSelectedColumn)

    End Sub

#End Region

#Region " Private Methods "

    Private Sub TextColumnBreaker_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles MyBase.Click
        If (Not CanSelectColumn) Then Return
        Dim pt As Point = Me.PointToClient(System.Windows.Forms.Cursor.Position)
        SelectColumn(pt)
    End Sub

    Private Sub SelectColumn(ByVal pt As Point)
        If Not CanSelectColumn Then Return

        Dim cursorX As Integer = mVisibleLeft + pt.X
        Dim i As Integer

        For i = 0 To mColumnSizes.GetUpperBound(0)
            If (mColumnSizes(i).Left <= cursorX AndAlso _
                mColumnSizes(i).Right >= cursorX) Then
                mSelectedColumn = i
                PaintText(True)
                RaiseEvent BreakerColumnSelected(mSelectedColumn)
                Return
            End If
        Next

    End Sub

    Private Sub PaintText(ByVal graph As Graphics, ByVal mustDraw As Boolean)
        Dim pen As New pen(Color.Black)
        Dim blackBrush As New SolidBrush(Color.Black)
        Dim whiteBrush As New SolidBrush(Color.White)
        Dim brush As SolidBrush
        Dim row As Integer
        Dim col As Integer
        Dim chr As Integer
        Dim x As Integer
        Dim y As Integer
        'Dim colPos As Integer
        Dim len As Integer
        Dim firstVisibleColumn As Integer = -1
        Dim lastVisibleColumn As Integer
        Dim firstVisibleRow As Integer = -1
        Dim lastVisibleRow As Integer
        Dim lastDrawColumn As Integer
        Dim maxVisibleRow As Integer
        Dim totalRow As Integer
        Dim rowText() As String
        Dim columnNum As Integer
        Dim lastColumn As Integer
        Dim width As Integer

        If ((mColumns Is Nothing) OrElse _
            (mFields Is Nothing) OrElse _
            (mCharHeight = 0)) Then Return

        columnNum = mColumns.Count
        lastColumn = columnNum - 1

        If (mFields Is Nothing) Then
            totalRow = 0
        Else
            totalRow = mFields.GetUpperBound(0) + 1
        End If
        maxVisibleRow = CInt(Math.Ceiling(Me.Height / mCharHeight))

        'Find the first and last visible row
        firstVisibleRow = CInt((totalRow - maxVisibleRow) * mVScrollPos / 100.0)
        If (firstVisibleRow < 0) Then firstVisibleRow = 0
        lastVisibleRow = firstVisibleRow + maxVisibleRow - 1
        If (lastVisibleRow > totalRow - 1) Then lastVisibleRow = totalRow - 1

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
        If ((Not mustDraw) AndAlso _
            (firstVisibleRow = mFirstVisibleRow) AndAlso _
            (mVisibleLeft = mPrevVisibleLeft)) Then
            Return
        End If

        'Save first visible row
        mFirstVisibleRow = firstVisibleRow
        'Save visible area left border
        mPrevVisibleLeft = mVisibleLeft

        'reset background and draw breaker area border
        graph.Clear(Me.BackColor)
        graph.DrawRectangle(System.Drawing.Pens.Black, 0, 0, Me.Width - 1, Me.Height - 1)

        'reverse the background color of selected column
        If (firstVisibleColumn <= mSelectedColumn AndAlso _
            mSelectedColumn <= lastVisibleColumn) Then
            x = mColumnSizes(mSelectedColumn).Left - mVisibleLeft
            width = mColumnSizes(mSelectedColumn).Width
            graph.FillRectangle(blackBrush, x, 0, width, Me.Height)
        End If

        'Draw column's right border
        If (mDrawColumnBorder) Then
            For col = firstVisibleColumn To lastVisibleColumn
                x = mColumnSizes(col).Right - mVisibleLeft
                graph.DrawLine(pen, x, 0, x, Me.Height)
            Next
        End If

        'Loop each row to draw text
        y = 1
        For row = firstVisibleRow To lastVisibleRow
            If (mFields(row) Is Nothing) Then GoTo NextRow
            rowText = mFields(row)
            lastDrawColumn = CInt(IIf(rowText.GetUpperBound(0) < lastVisibleColumn, _
                                      rowText.GetUpperBound(0), lastVisibleColumn))

            'Loop each column
            For col = firstVisibleColumn To lastDrawColumn
                If (rowText(col) Is Nothing) Then GoTo NextColumn
                x = mColumnSizes(col).Left - mVisibleLeft _
                    + TextColumnDefaultValue.COLUMN_HORIZONTAL_PADDING _
                    - TextColumnDefaultValue.X_OFFSET
                len = CInt(IIf(rowText(col).Length < mColumnSizes(col).Length, _
                               rowText(col).Length, mColumnSizes(col).Length))
                brush = CType(IIf(col = mSelectedColumn, whiteBrush, blackBrush), SolidBrush)

                'Loop each character in a column
                For chr = 0 To len - 1
                    graph.DrawString(rowText(col).Substring(chr, 1), _
                                     Me.Font, _
                                     brush, _
                                     x, _
                                     y)
                    x += mCharWidth + TextColumnDefaultValue.CHAR_SPACING
                Next
NextColumn:
            Next col
NextRow:
            y += mCharHeight
        Next row


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

    '    'show all the columns if column breaker area is wide enough
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
    '                .HScrollPosMax = 0
    '            Else
    '                .HScrollPosMax = CInt(Math.Floor(100.0 * (preWidth + .width - 1) / scrollableWidth))
    '                If (.HScrollPosMax > 100) Then .HScrollPosMax = 100
    '                If (.HScrollPosMax < 0) Then .HScrollPosMax = 0
    '                preWidth += .width
    '            End If
    '        End With
    '    Next
    'End Sub

    Public Sub VisibleColumn(ByVal column As Integer)
        Dim visibleAreaLeft As Integer

        With mColumnSizes(column)
            'Check if specified column is visible
            If ((mVisibleLeft <= .Left AndAlso .Left <= mVisibleRight - 8) OrElse _
                (mVisibleLeft + 8 <= .Right AndAlso .Right < mVisibleRight)) Then
                Return
            End If

            'If column is outside of left edge of visible area,
            'move it to the leftmost visible column
            If (.Right < mVisibleLeft + 8) Then
                visibleAreaLeft = .Left
            End If

            'If column is outside of right edge of visible area,
            'move it to the rightmost visible column
            If (.Left > mVisibleRight - 8) Then
                If (.Width >= Me.Width) Then
                    visibleAreaLeft = .Left
                Else
                    visibleAreaLeft = .Left - (Me.Width - .Width)
                End If
            End If
        End With

        RaiseEvent VisibleAreaMoved(visibleAreaLeft)

    End Sub

#End Region

End Class

