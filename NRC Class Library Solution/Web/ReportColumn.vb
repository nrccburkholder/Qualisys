'Imports Siberix
'Imports System.Drawing
'Namespace Web
'    Public Class ReportColumn

'#Region " Private Members "
'        Private mCollection As ReportColumnCollection
'        Private mTable As ReportTable

'        Private mColumnName As String
'        Private mWidth As Single
'        Private mBackColor As Color

'        Private mData As ArrayList
'#End Region

'#Region " Public Properties "
'        Public Property ColumnName() As String
'            Get
'                Return mColumnName
'            End Get
'            Set(ByVal Value As String)
'                mColumnName = Value
'            End Set
'        End Property

'        Public Property Width() As Single
'            Get
'                Return mWidth
'            End Get
'            Set(ByVal Value As Single)
'                mWidth = Value
'            End Set
'        End Property

'        Public Property BackColor() As Color
'            Get
'                Return mBackColor
'            End Get
'            Set(ByVal Value As Color)
'                mBackColor = Value
'            End Set
'        End Property

'        Default Public Property Item(ByVal recordNum As Integer) As Object
'            Get
'                If recordNum > mData.Count - 1 Then
'                    Throw New ArgumentOutOfRangeException("recordNum", "Record " & recordNum & " does not exist.")
'                Else
'                    Return mData(recordNum)
'                End If
'            End Get
'            Set(ByVal Value As Object)
'                Dim i As Integer
'                If recordNum > mData.Count - 1 Then
'                    For i = mData.Count To recordNum
'                        mData.Add("")
'                    Next
'                End If

'                mData(recordNum) = Value
'            End Set
'        End Property
'#End Region

'#Region " Constructors "
'        Friend Sub New(ByVal collection As ReportColumnCollection, ByVal table As ReportTable)
'            mData = New ArrayList
'            mCollection = collection
'            mTable = table
'            mBackColor = Color.Transparent

'            AddHandler mTable.Rows.RowAdded, AddressOf mTable_RowAdded
'            AddHandler mTable.Rows.RowRemoved, AddressOf mTable_RowRemoved
'            AddHandler mTable.Rows.RowsCleared, AddressOf mTable_RowsCleared
'        End Sub
'#End Region

'#Region " Public Methods "
'        Public Sub SetColumnWidth(ByVal g As PDF.Graphics)
'            mWidth = GetMaxWidth(g) + (2 * mTable.CellPadding)
'        End Sub

'        Friend Sub RenderPDF(ByVal g As PDF.Graphics, ByVal x As Single, ByVal y As Single, ByVal startRow As Integer, ByVal endRow As Integer)
'            Dim padding As Integer = mTable.CellPadding
'            Dim rowHeight As Integer = mTable.RowHeight
'            Dim rowCount As Integer = (endRow - startRow) + 1
'            Dim columnHeight As Integer = rowHeight * (rowCount + 1)
'            Dim backColor As Color
'            Dim penX, penY As Single
'            Dim i As Integer
'            Dim obj As Object

'            g.SaveState()
'            'Draw border
'            'Outer rectangle
'            g.DrawRectangle(x, y, mWidth, columnHeight)

'            'Line for each row
'            'penY = y + rowHeight
'            'For penY = (y + rowHeight) To (y + columnHeight) Step rowHeight
'            '    g.DrawLine(x, penY, x + mWidth, penY)
'            'Next

'            'Draw Data
'            penX = x
'            penY = y
'            'Column Header
'            g.DrawString(penX + padding, penY + padding, mColumnName)
'            penY += rowHeight
'            'Data items
'            For i = startRow To endRow
'                If mBackColor.Equals(Color.Transparent) Then
'                    backColor = mTable.Rows(i).BackColor
'                Else
'                    backColor = mBackColor
'                End If
'                g.Brush = New System.Drawing.SolidBrush(backColor)
'                g.FillRectangle(penX, penY, mWidth, rowHeight)
'                g.Brush = Brushes.Black

'                g.DrawLine(penX, penY, penX + mWidth, penY)
'                g.DrawString(penX + padding, penY + padding, mData(i).ToString)
'                penY += rowHeight
'            Next

'            g.RestoreState()
'        End Sub
'#End Region

'#Region " Private Methods "
'        Private Function GetMaxWidth(ByVal g As PDF.Graphics) As Single
'            Dim max As Single = g.StringWidth(mColumnName)
'            Dim width As Single
'            Dim obj As Object

'            For Each obj In mData
'                If Not obj Is Nothing Then
'                    width = g.StringWidth(obj.ToString)
'                    If width > max Then max = width
'                End If
'            Next

'            If max < 0 Then max = 0

'            Return max
'        End Function

'        Private Sub DeleteRecord(ByVal recordNum As Integer)
'            If recordNum > mData.Count - 1 Then
'                Throw New ArgumentOutOfRangeException("recordNum", "Record " & recordNum & " does not exist.")
'            Else
'                mData.RemoveAt(recordNum)
'            End If
'        End Sub

'        Private Sub mTable_RowAdded(ByVal sender As Object, ByVal e As ReportRowCollection.RowEventArgs)
'            mData.Insert(e.Index, New Object)
'        End Sub

'        Private Sub mTable_RowRemoved(ByVal sender As Object, ByVal e As ReportRowCollection.RowEventArgs)
'            DeleteRecord(e.Index)
'        End Sub

'        Private Sub mTable_RowsCleared(ByVal sender As Object, ByVal e As System.EventArgs)
'            mData.Clear()
'        End Sub
'#End Region

'    End Class

'#Region " ReportColumnCollection Class "
'    Public Class ReportColumnCollection
'        Inherits CollectionBase

'#Region " Event Declarations "
'        Public Class ColumnEventArgs
'            Private mIndex As Integer

'            Public ReadOnly Property Index() As Integer
'                Get
'                    Return mIndex
'                End Get
'            End Property

'            Public Sub New(ByVal index As Integer)
'                mIndex = index
'            End Sub
'        End Class
'        Public Delegate Sub ColumnEventHandler(ByVal sender As Object, ByVal e As ColumnEventArgs)
'        Public Event ColumnAdded As ColumnEventHandler
'        Public Event ColumnRemoved As ColumnEventHandler
'        Public Event ColumnsCleared As EventHandler

'#End Region

'        Private mParent As ReportTable

'        Default Public ReadOnly Property Item(ByVal index As Integer) As ReportColumn
'            Get
'                Return DirectCast(MyBase.InnerList(index), ReportColumn)
'            End Get
'        End Property

'        Public ReadOnly Property TotalWidth() As Single
'            Get
'                Dim width As Single
'                Dim i As Integer
'                For i = 0 To Me.Count - 1
'                    width += DirectCast(Me.InnerList(i), ReportColumn).Width
'                Next

'                Return width
'            End Get
'        End Property

'        Sub New(ByVal parentTable As ReportTable)
'            mParent = parentTable
'        End Sub

'        Public Function Add(ByVal columnName As String) As Integer
'            Dim column As New ReportColumn(Me, mParent)
'            column.ColumnName = columnName

'            Return MyBase.List.Add(column)
'        End Function

'        Protected Overrides Sub OnInsertComplete(ByVal index As Integer, ByVal value As Object)
'            RaiseEvent ColumnAdded(Me, New ColumnEventArgs(index))
'        End Sub

'        Protected Overrides Sub OnClearComplete()
'            RaiseEvent ColumnsCleared(Me, New EventArgs)
'        End Sub

'        Protected Overrides Sub OnRemoveComplete(ByVal index As Integer, ByVal value As Object)
'            RaiseEvent ColumnRemoved(Me, New ColumnEventArgs(index))
'        End Sub
'    End Class

'#End Region

'End Namespace