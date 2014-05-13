Option Explicit On 
Option Strict On

Imports System
Imports System.Windows.Forms
Imports System.Runtime.InteropServices
Imports System.Drawing
Imports NRC.WinForms

Namespace WinForms

    Public Class NRCListView
        Inherits System.Windows.Forms.ListView

#Region " Events"

        Event Sorted(ByVal sender As Object, ByVal e As ListViewSortedEventArgs)

#End Region

#Region " Private Fields"

        Private mSortColumn As Integer = -1
        Private mSortOrder As SortOrder = SortOrder.NotSorted
        Private mAlternateColor1 As Color = Color.White
        Private mAlternateColor2 As Color = Color.Gainsboro

#End Region

#Region " Public Properties"

        Public Property SortColumn() As Integer
            Get
                Return mSortColumn
            End Get
            Set(ByVal Value As Integer)
                ResetColumnTitle(mSortColumn)
                If (Value < -1 OrElse Value >= Me.Columns.Count) Then
                    mSortColumn = -1
                Else
                    mSortColumn = Value
                End If
                Sort()
            End Set
        End Property

        Public Property SortOrder() As SortOrder
            Get
                Return mSortOrder
            End Get
            Set(ByVal Value As SortOrder)
                ResetColumnTitle(mSortColumn)
                mSortOrder = Value
                Sort()
            End Set
        End Property

        Public Property AlternateColor1() As Color
            Get
                Return mAlternateColor1
            End Get
            Set(ByVal Value As Color)
                mAlternateColor1 = Value
            End Set
        End Property

        Public Property AlternateColor2() As Color
            Get
                Return mAlternateColor2
            End Get
            Set(ByVal Value As Color)
                mAlternateColor2 = Value
            End Set
        End Property

#End Region

#Region " Windows API"

        <DllImport("user32.dll")> _
        Public Overloads Shared Function SendMessage( _
                ByVal hWnd As IntPtr, _
                ByVal Msg As Integer, _
                ByVal wParam As IntPtr, _
                ByVal lParam As IntPtr _
               ) As Integer
        End Function

        <DllImport("user32.dll")> _
        Public Overloads Shared Function SendMessage( _
                ByVal hWnd As IntPtr, _
                ByVal msg As Int32, _
                ByVal wParam As Int32, _
                ByRef lParam As LV_ITEM _
               ) As Boolean
        End Function

#End Region

#Region " Public Classes/Structures "

        <StructLayoutAttribute(LayoutKind.Sequential)> _
        Public Structure LV_ITEM
            Public Mask As UInt32
            Public Item As Int32
            Public SubItem As Int32
            Public State As UInt32
            Public StateMask As UInt32
            Public Text As String
            Public TextMax As Int32
            Public Image As Int32
            Public lParam As IntPtr
        End Structure 'LV_ITEM

        Public Class MatchedListViewItemCollection
            Inherits CollectionBase

            Default Public Property Item(ByVal index As Integer) As ListViewItem
                Get
                    Return CType(MyBase.List.Item(index), ListViewItem)
                End Get
                Set(ByVal Value As ListViewItem)
                    MyBase.List.Item(index) = Value
                End Set
            End Property

            Public Sub Add(ByVal dest As ListViewItem)
                MyBase.List.Add(dest)
            End Sub

        End Class
#End Region

#Region " Public Constants"

        Public Const LVM_FIRST As Int32 = &H1000
        Public Const LVM_GETITEM As Int32 = LVM_FIRST + 5
        Public Const LVM_SETITEM As Int32 = LVM_FIRST + 6
        Public Const LVIF_TEXT As Int32 = &H1
        Public Const LVIF_IMAGE As Int32 = &H2

        Public Const LVW_FIRST As Integer = &H1000
        Public Const LVM_SETEXTENDEDLISTVIEWSTYLE As Integer = LVW_FIRST + 54

        Public Const LVS_EX_GRIDLINES As Integer = &H1
        Public Const LVS_EX_SUBITEMIMAGES As Integer = &H2
        Public Const LVS_EX_CHECKBOXES As Integer = &H4
        Public Const LVS_EX_TRACKSELECT As Integer = &H8
        Public Const LVS_EX_HEADERDRAGDROP As Integer = &H10
        Public Const LVS_EX_FULLROWSELECT As Integer = &H20 ' applies to report mode only
        Public Const LVS_EX_ONECLICKACTIVATE As Integer = &H40

#End Region

#Region " Public Methods"

        Public Sub New()
            ' Change the style of listview to accept image on subitems
            Dim m As New Message
            m.HWnd = Me.Handle
            m.Msg = LVM_SETEXTENDEDLISTVIEWSTYLE
            ' m.LParam = New IntPtr(LVS_EX_GRIDLINES Or LVS_EX_FULLROWSELECT Or LVS_EX_SUBITEMIMAGES Or LVS_EX_CHECKBOXES Or LVS_EX_TRACKSELECT)
            m.LParam = New IntPtr(LVS_EX_SUBITEMIMAGES)
            m.WParam = IntPtr.Zero
            Me.WndProc(m)
        End Sub

        Public Sub ShowSubItemImage()
            Dim i As Integer
            Dim j As Integer
            Dim lvi As LV_ITEM
            Dim item As ListViewItem
            Dim subitem As NRCListViewSubItem

            For i = 0 To Me.Items.Count - 1
                item = Me.Items(i)
                For j = 0 To item.SubItems.Count - 1
                    If (Not item.SubItems(j).GetType Is GetType(NRCListViewSubItem)) Then GoTo NextColumn
                    subitem = CType(item.SubItems(j), NRCListViewSubItem)
                    If (subitem.ImageIndex < 0) Then GoTo nextcolumn

                    lvi = New LV_ITEM
                    lvi.Item = i
                    lvi.SubItem = j
                    lvi.Text = subitem.Text
                    lvi.Mask = Convert.ToUInt32(LVIF_IMAGE Or LVIF_TEXT)
                    lvi.Image = subitem.ImageIndex
                    SendMessage(Me.Handle, LVM_SETITEM, 0, lvi)
NextColumn:
                Next j
            Next i

        End Sub

        Public Shadows Sub Sort()
            If (Me.mSortColumn < 0 OrElse Me.mSortColumn >= Me.Columns.Count) Then Return
            If (Me.mSortOrder <> SortOrder.Ascend AndAlso Me.mSortOrder <> SortOrder.Descend) Then Return

            Me.BeginUpdate()

            'Reset title of the original sorted column 
            ResetColumnTitle(Me.mSortColumn)

            'Get data type of the column
            Dim dataType As DataType
            If (Me.Columns(mSortColumn).GetType Is GetType(NRCColumnHeader)) Then
                Dim column As NRCColumnHeader
                column = CType(Me.Columns(mSortColumn), NRCColumnHeader)
                dataType = column.DataType
            Else
                dataType = dataType._Unknown
            End If

            'Sort
            Dim criteria As New ListViewSortCriteria(mSortColumn, dataType, mSortOrder)
            Me.ListViewItemSorter = New ListViewItemComparer(criteria)
            MyBase.Sort()
            Me.ListViewItemSorter = Nothing

            'Change column title
            Me.Columns(Me.mSortColumn).Text += criteria.SortOrderIcon

            Me.EndUpdate()

            RaiseEvent Sorted(Me, New ListViewSortedEventArgs(Me.mSortColumn, Me.mSortOrder))
        End Sub

        Public Sub SetAllChecked(ByVal value As Boolean)
            Dim item As ListViewItem
            Me.BeginUpdate()
            For Each item In Me.Items
                item.Checked = value
            Next
            Me.EndUpdate()
        End Sub

        Public Sub SetSelectedChecked(ByVal value As Boolean)
            Dim item As ListViewItem
            Me.BeginUpdate()
            For Each item In Me.SelectedItems
                item.Checked = value
            Next
            Me.EndUpdate()
        End Sub

        Public Sub PaintAlternatingBackColor()
            PaintAlternatingBackColor(Me.mAlternateColor1, Me.mAlternateColor2)
        End Sub

        Public Sub PaintAlternatingBackColor(ByVal color1 As Color, ByVal color2 As Color)
            Dim item As ListViewItem
            Dim subitem As ListViewItem.ListViewSubItem

            For Each item In Me.Items
                If (item.Index Mod 2 = 0) Then
                    item.BackColor = color1
                Else
                    item.BackColor = color2
                End If

                For Each subitem In item.SubItems
                    subitem.BackColor = item.BackColor
                Next
            Next
        End Sub

        Public Sub AutoFitColumnWidth()
            Dim gr As Graphics = Me.CreateGraphics
            Dim font As Font
            Dim size As SizeF
            Dim item As ListViewItem
            Dim maxWidth As Single
            Dim col As Integer
            Dim width As Single

            Me.BeginUpdate()

            For col = 0 To Me.Columns.Count - 1
                font = Me.Font
                size = gr.MeasureString(Me.Columns(col).Text, font)
                maxWidth = size.Width + 10
                For Each item In Me.Items
                    font = item.SubItems(col).Font
                    size = gr.MeasureString(item.SubItems(col).Text, font)
                    width = size.Width + 8
                    If (Me.CheckBoxes = True And col = 0) Then width += 15
                    If (width > maxWidth) Then maxWidth = width
                Next
                Me.Columns(col).Width = CInt(Math.Ceiling(maxWidth))
            Next

            Me.EndUpdate()
        End Sub

        '
        'Distribute the adjustable width of the listview among
        'adjustable columns based on column width propoertion fact.
        'If adjusted column width < minWidth, set adjusted column
        'width to minWidth
        '
        Public Sub AutoAdjustColumnWidth(ByVal minWidth As Integer)
            Const ScrollBarWidth As Integer = 22
            Dim col As ColumnHeader
            Dim nrcCol As NRCColumnHeader
            Dim totalProportion As Integer
            Dim fixedWidth As Integer
            Dim adjustWidth As Integer
            Dim colWidth As Integer

            'Dim msg As String
            'msg = String.Format("list={0},col0={1},col1={2},col2={3},col3={4},col4={5},col5={6}", Me.Width, Me.Columns(0).Width, Me.Columns(1).Width, Me.Columns(2).Width, Me.Columns(3).Width, Me.Columns(4).Width, Me.Columns(5).Width)
            'MessageBox.Show(msg, "", MessageBoxButtons.OK)

            For Each col In Me.Columns
                If (col.GetType Is GetType(NRCColumnHeader)) Then
                    nrcCol = CType(col, NRCColumnHeader)
                    If (nrcCol.WidthAutoAdjust) Then
                        totalProportion += nrcCol.WidthProportion
                    Else
                        fixedWidth += col.Width
                    End If
                Else
                    fixedWidth += col.Width
                End If
            Next

            adjustWidth = Me.Width - fixedWidth - ScrollBarWidth
            If (adjustWidth <= 0) Then Return

            'msg = String.Format("total={0}, used={1}, unused={2}, total proportion={3}", Me.Width, usedWidth, unusedWidth, totalProportion)
            'MessageBox.Show(msg, "", MessageBoxButtons.OK)

            Me.BeginUpdate()

            For Each col In Me.Columns
                If (col.GetType Is GetType(NRCColumnHeader)) Then
                    nrcCol = CType(col, NRCColumnHeader)
                    If (nrcCol.WidthAutoAdjust) Then
                        colWidth = CInt(Math.Floor(adjustWidth * nrcCol.WidthProportion / totalProportion))
                        If (colWidth < minWidth) Then colWidth = minWidth
                        col.Width = colWidth
                    End If
                End If
            Next

            Me.EndUpdate()

            'msg = String.Format("list={0},col0={1},col1={2},col2={3},col3={4},col4={5},col5={6}", Me.Width, Me.Columns(0).Width, Me.Columns(1).Width, Me.Columns(2).Width, Me.Columns(3).Width, Me.Columns(4).Width, Me.Columns(5).Width)
            'MessageBox.Show(msg, "", MessageBoxButtons.OK)

        End Sub

        '
        'Distribute unused width of the listview among
        'adjustable columns based on column width propoertion fact.
        '
        Public Sub AutoAdjustColumnWidth()
            Const ScrollBarWidth As Integer = 22
            Dim col As ColumnHeader
            Dim nrcCol As NRCColumnHeader
            Dim totalProportion As Integer
            Dim usedWidth As Integer
            Dim unusedWidth As Integer
            Dim colWidth As Integer

            'Dim msg As String
            'msg = String.Format("list={0},col0={1},col1={2},col2={3},col3={4},col4={5},col5={6}", Me.Width, Me.Columns(0).Width, Me.Columns(1).Width, Me.Columns(2).Width, Me.Columns(3).Width, Me.Columns(4).Width, Me.Columns(5).Width)
            'MessageBox.Show(msg, "", MessageBoxButtons.OK)

            For Each col In Me.Columns
                usedWidth += col.Width
                If (col.GetType Is GetType(NRCColumnHeader)) Then
                    nrcCol = CType(col, NRCColumnHeader)
                    If (nrcCol.WidthAutoAdjust) Then
                        totalProportion += nrcCol.WidthProportion
                    End If
                End If
            Next

            unusedWidth = Me.Width - usedWidth - ScrollBarWidth
            If (unusedWidth <= 0) Then Return

            'msg = String.Format("total={0}, used={1}, unused={2}, total proportion={3}", Me.Width, usedWidth, unusedWidth, totalProportion)
            'MessageBox.Show(msg, "", MessageBoxButtons.OK)

            Me.BeginUpdate()

            For Each col In Me.Columns
                If (col.GetType Is GetType(NRCColumnHeader)) Then
                    nrcCol = CType(col, NRCColumnHeader)
                    If (nrcCol.WidthAutoAdjust) Then
                        colWidth = CInt(Math.Floor(unusedWidth * nrcCol.WidthProportion / totalProportion))
                        col.Width += colWidth
                    End If
                End If
            Next

            Me.EndUpdate()

            'msg = String.Format("list={0},col0={1},col1={2},col2={3},col3={4},col4={5},col5={6}", Me.Width, Me.Columns(0).Width, Me.Columns(1).Width, Me.Columns(2).Width, Me.Columns(3).Width, Me.Columns(4).Width, Me.Columns(5).Width)
            'MessageBox.Show(msg, "", MessageBoxButtons.OK)

        End Sub

        Public Function MatchedItems(ByVal columIndex As Integer, ByVal value As String, ByVal caseSensitive As Boolean) As MatchedListViewItemCollection
            If (Me.Columns.Count <= columIndex) Then
                Throw New ArgumentException("Column index is out of column bound")
            End If

            Dim item As ListViewItem
            Dim items As New MatchedListViewItemCollection

            If (caseSensitive) Then value = value.ToUpper
            For Each item In Me.Items
                If ((caseSensitive AndAlso (item.SubItems(columIndex).Text.ToUpper = value)) OrElse _
                    ((Not caseSensitive) AndAlso (item.SubItems(columIndex).Text = value))) Then
                    items.Add(item)
                End If
            Next

            Return items
        End Function

        Public Function MatchedItems(ByVal columIndex As Integer, ByVal value As Integer) As MatchedListViewItemCollection
            If (Me.Columns.Count <= columIndex) Then
                Throw New ArgumentException("Column index is out of column bound")
            End If

            Dim item As ListViewItem
            Dim items As New MatchedListViewItemCollection

            For Each item In Me.Items
                If (CInt(item.SubItems(columIndex).Text) = value) Then
                    items.Add(item)
                End If
            Next

            Return items
        End Function

        Public Function MatchedItems(ByVal columIndex As Integer, ByVal value As Date) As MatchedListViewItemCollection
            If (Me.Columns.Count <= columIndex) Then
                Throw New ArgumentException("Column index is out of column bound")
            End If

            Dim item As ListViewItem
            Dim items As New MatchedListViewItemCollection

            For Each item In Me.Items
                If (CDate(item.SubItems(columIndex).Text) = value) Then
                    items.Add(item)
                End If
            Next

            Return items
        End Function

#End Region

#Region " Private & Protected Methods"

        Protected Overrides Sub OnColumnClick(ByVal e As System.Windows.Forms.ColumnClickEventArgs)
            MyBase.OnColumnClick(e)

            'Reset title of the original sorted column 
            ResetColumnTitle(Me.mSortColumn)

            'Set sort column and order
            If (e.Column = Me.mSortColumn) Then
                If (mSortOrder = SortOrder.Ascend) Then
                    mSortOrder = SortOrder.Descend
                Else
                    mSortOrder = SortOrder.Ascend
                End If
            Else
                Me.mSortColumn = e.Column
                mSortOrder = SortOrder.Ascend
            End If

            'Sort
            Sort()
        End Sub

        Private Sub ResetColumnTitle(ByVal column As Integer)
            If (column < 0 OrElse column >= Me.Columns.Count) Then Return

            Dim label As String = Me.Columns(column).Text
            Dim i As Integer = label.IndexOf(ListViewSortCriteria.SortAscendIcon)
            If (i >= 0) Then
                Me.Columns(column).Text = label.Substring(0, i)
            Else
                i = label.IndexOf(ListViewSortCriteria.SortDescendIcon)
                If (i >= 0) Then
                    Me.Columns(column).Text = label.Substring(0, i)
                End If
            End If
        End Sub

#End Region

    End Class


    Public Class NRCListViewSubItem
        Inherits ListViewItem.ListViewSubItem

        Private mImageIndex As Integer = -1

        Public Property ImageIndex() As Integer
            Get
                Return mImageIndex
            End Get
            Set(ByVal Value As Integer)
                mImageIndex = Value
            End Set
        End Property
    End Class


    Public Class NRCColumnHeader
        Inherits ColumnHeader

        Private mDataType As DataType = DataType._Unknown
        Private mWidthAutoAdjust As Boolean = False
        Private mWidthProportion As Integer

        Public Property DataType() As DataType
            Get
                Return mDataType
            End Get
            Set(ByVal Value As DataType)
                mDataType = Value
            End Set
        End Property

        Public Property WidthAutoAdjust() As Boolean
            Get
                Return mWidthAutoAdjust
            End Get
            Set(ByVal Value As Boolean)
                mWidthAutoAdjust = Value
            End Set
        End Property

        Public Property WidthProportion() As Integer
            Get
                Return mWidthProportion
            End Get
            Set(ByVal Value As Integer)
                mWidthProportion = Value
            End Set
        End Property

        Sub New()
        End Sub

        Sub New(ByVal dataType As DataType)
            mDataType = dataType
        End Sub

        Sub New(ByVal dataType As DataType, ByVal widthAutoAdjust As Boolean)
            mDataType = dataType
            mWidthAutoAdjust = widthAutoAdjust
        End Sub

        Sub New(ByVal dataType As DataType, ByVal widthAutoAdjust As Boolean, ByVal widthProportion As Integer)
            mDataType = dataType
            mWidthAutoAdjust = widthAutoAdjust
            mWidthProportion = widthProportion
        End Sub

    End Class

    Public Class ListViewSortedEventArgs
        Inherits System.EventArgs

        Private mSortColumnIndex As Integer
        Private mSortOrder As SortOrder

        Public ReadOnly Property SortColumnIndex() As Integer
            Get
                Return mSortColumnIndex
            End Get
        End Property

        Public ReadOnly Property SortOrder() As SortOrder
            Get
                Return mSortOrder
            End Get
        End Property

        Sub New(ByVal sortColumnIndex As Integer, ByVal sortOrder As SortOrder)
            mSortColumnIndex = sortColumnIndex
            mSortOrder = sortOrder
        End Sub

    End Class

End Namespace
