'Imports Siberix

'Namespace Web
'    Public Class ReportColumnGroup

'#Region " Private Members "
'        Private mTable As ReportTable
'        Private mColumns As ReportColumnCollection
'        Private mGroupName As String
'        Private mWidth As Single
'#End Region

'#Region " Public Properties "
'        Public ReadOnly Property Columns() As ReportColumnCollection
'            Get
'                Return mColumns
'            End Get
'        End Property

'        Public Property GroupName() As String
'            Get
'                Return mGroupName
'            End Get
'            Set(ByVal Value As String)
'                mGroupName = Value
'            End Set
'        End Property

'        Public ReadOnly Property GroupWidth() As Single
'            Get
'                Return mWidth
'            End Get
'        End Property
'#End Region

'#Region " Constructors "
'        Sub New(ByVal parentTable As ReportTable)
'            mTable = parentTable
'            mColumns = New ReportColumnCollection(mTable)
'        End Sub
'#End Region

'        Friend Sub RenderPDF(ByVal g As PDF.Graphics, ByVal x As Single, ByVal y As Single, ByVal startRow As Integer, ByVal endRow As Integer)
'            Dim padding As Integer = mTable.CellPadding
'            Dim rowHeight As Integer = mTable.RowHeight
'            Dim col As ReportColumn
'            Dim penX, penY As Single

'            'Set Width Data
'            SetGroupWidth(g)

'            'Draw group label
'            If mTable.RenderGroupHeaders Then
'                g.DrawRectangle(x, y, mWidth, rowHeight)
'                g.DrawString(x + padding, y + padding, mGroupName)
'            End If

'            penX = x
'            If mTable.RenderGroupHeaders Then
'                penY = y + rowHeight
'            Else
'                penY = y
'            End If
'            For Each col In mColumns
'                col.RenderPDF(g, penX, penY, startRow, endRow)
'                penX += col.Width
'            Next

'        End Sub

'        Public Sub SetGroupWidth(ByVal g As PDF.Graphics)
'            Dim padding As Integer = mTable.CellPadding
'            Dim col As ReportColumn
'            Dim labelWidth As Single
'            Dim extra As Single

'            For Each col In mColumns
'                col.SetColumnWidth(g)
'            Next
'            labelWidth = g.StringWidth(mGroupName) + (2 * padding)

'            'If the group label is bigger then the max column width
'            If mTable.RenderGroupHeaders AndAlso labelWidth > mColumns.TotalWidth Then
'                'Set the group width to be the label width
'                mWidth = labelWidth
'                'Find how much bigger it is then all the columns together
'                extra = labelWidth - mColumns.TotalWidth

'                'Divide the extra amount equally between all columns
'                For Each col In mColumns
'                    col.Width += (extra / mColumns.Count)
'                Next
'            Else
'                'Set group width to the the total column width
'                mWidth = mColumns.TotalWidth
'            End If

'        End Sub

'    End Class

'    Public Class ReportColumnGroupCollection
'        Inherits CollectionBase

'#Region " Event Declarations "
'        Public Class GroupEventArgs
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
'        Public Delegate Sub GroupEventHandler(ByVal sender As Object, ByVal e As GroupEventArgs)
'        Public Event GroupAdded As GroupEventHandler
'        Public Event GroupRemoved As GroupEventHandler
'        Public Event GroupsCleared As EventHandler

'        Public Delegate Sub GroupColumnsChangedEventHandler(ByVal sender As Object, ByVal e As EventArgs)
'        Public Event GroupColumnsChanged As GroupColumnsChangedEventHandler
'#End Region

'#Region " Private Members "
'        Private mTable As ReportTable

'#End Region

'#Region " Public Properties "
'        Default Public ReadOnly Property Item(ByVal index As Integer) As ReportColumnGroup
'            Get
'                Return DirectCast(MyBase.List(index), ReportColumnGroup)
'            End Get
'        End Property
'#End Region

'#Region " Constructors "
'        Sub New(ByVal parent As ReportTable)
'            mTable = parent
'        End Sub
'#End Region

'#Region " Public Methods "
'        Public Function Add(ByVal groupName As String) As ReportColumnGroup
'            Dim group As New ReportColumnGroup(mTable)
'            group.GroupName = groupName
'            AddHandler group.Columns.ColumnAdded, AddressOf ColumnAdded
'            AddHandler group.Columns.ColumnRemoved, AddressOf ColumnRemoved
'            AddHandler group.Columns.ColumnsCleared, AddressOf ColumnsCleared

'            MyBase.List.Add(group)

'            Return group
'        End Function

'        Public Shadows Sub RemoveAt(ByVal index As Integer)
'            Dim grp As ReportColumnGroup = DirectCast(MyBase.List(index), ReportColumnGroup)
'            If Not grp Is Nothing Then
'                RemoveHandler grp.Columns.ColumnAdded, AddressOf ColumnAdded
'                RemoveHandler grp.Columns.ColumnRemoved, AddressOf ColumnRemoved
'                RemoveHandler grp.Columns.ColumnsCleared, AddressOf ColumnsCleared
'            End If

'            MyBase.RemoveAt(index)
'        End Sub
'#End Region

'#Region " Protected Methods "
'        Protected Overrides Sub OnInsertComplete(ByVal index As Integer, ByVal value As Object)
'            RaiseEvent GroupAdded(Me, New GroupEventArgs(index))
'        End Sub

'        Protected Overrides Sub OnRemoveComplete(ByVal index As Integer, ByVal value As Object)
'            RaiseEvent GroupRemoved(Me, New GroupEventArgs(index))
'        End Sub

'        Protected Overrides Sub OnClearComplete()
'            RaiseEvent GroupsCleared(Me, New EventArgs)
'        End Sub
'#End Region

'#Region " Private Methods "
'        Private Sub ColumnAdded(ByVal sender As Object, ByVal e As ReportColumnCollection.ColumnEventArgs)
'            RaiseEvent GroupColumnsChanged(sender, New EventArgs)
'        End Sub
'        Private Sub ColumnRemoved(ByVal sender As Object, ByVal e As ReportColumnCollection.ColumnEventArgs)
'            RaiseEvent GroupColumnsChanged(sender, New EventArgs)
'        End Sub
'        Private Sub ColumnsCleared(ByVal sender As Object, ByVal e As EventArgs)
'            RaiseEvent GroupColumnsChanged(sender, e)
'        End Sub

'#End Region



'    End Class

'End Namespace