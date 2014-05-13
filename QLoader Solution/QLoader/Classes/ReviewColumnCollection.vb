'Used for review
Public Class ReviewColumnCollection
    Inherits CollectionBase

    Default Public Property Item(ByVal index As Integer) As ReviewColumn
        Get
            Return DirectCast(MyBase.List.Item(index), ReviewColumn)
        End Get
        Set(ByVal Value As ReviewColumn)
            MyBase.List.Item(index) = Value
        End Set
    End Property

    Public Sub Add(ByVal Col As ReviewColumn)
        MyBase.List.Add(Col)
    End Sub

    Public Sub CopySourceColumn(ByVal dtsSourceColumns As ColumnCollection)
        Dim col As ReviewColumn
        Dim dtsCol As SourceColumn

        For Each dtsCol In dtsSourceColumns
            col = New ReviewColumn
            col.Ordinal = dtsCol.Ordinal
            col.ColumnName = dtsCol.ColumnName
            Me.Add(col)
        Next

    End Sub
End Class
