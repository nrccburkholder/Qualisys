Public Class ColumnCollection
    Inherits CollectionBase
    Implements ICloneable

#Region " Public Properties "

    Default Public Property Item(ByVal index As Integer) As Column
        Get
            Return DirectCast(MyBase.List.Item(index), Column)
        End Get
        Set(ByVal Value As Column)
            MyBase.List.Item(index) = Value
        End Set
    End Property

    Default Public ReadOnly Property Item(ByVal name As String) As Column
        Get
            Return FindByName(name)
        End Get
    End Property

#End Region

#Region " Public Methods "

    Public Sub Add(ByVal Col As Column)

        MyBase.List.Add(Col)

    End Sub

    Public Function GetSourceColumn(ByVal sourceID As Integer) As SourceColumn

        Dim col As SourceColumn

        For Each col In MyBase.List
            If col.SourceID = sourceID Then Return col
        Next

        Return Nothing

    End Function

    Public Function ColumnNameDuplicated(ByRef errColumn As Integer, ByRef errMsg As String) As Boolean

        Dim colNames As New ArrayList(Count)

        For cnt As Integer = 0 To Count - 1
            colNames.Add(Item(cnt).ColumnName.ToUpper)
        Next

        colNames.Sort()

        For cnt1 As Integer = 0 To colNames.Count - 2
            If (CStr(colNames(cnt1)) = CStr(colNames(cnt1 + 1))) Then
                errMsg = String.Format("More than one columns have the name of ""{0}""", CStr(colNames(cnt1)))

                'Get the error column index
                For cnt2 As Integer = 0 To Count - 1
                    If (CStr(colNames(cnt1)) = Item(cnt2).ColumnName.ToUpper) Then
                        errColumn = cnt2
                        Exit For
                    End If
                Next

                Return True
            End If
        Next

        Return False

    End Function

    Public Function OriginalColumnNameDuplicated(ByRef errColumn As Integer, ByRef errMsg As String) As Boolean

        Dim colNames As New ArrayList(Count)

        For cnt As Integer = 0 To Count - 1
            If (Not Item(cnt).GetType Is GetType(SourceColumn)) Then
                Return False
            End If

            colNames.Add(CType(Item(cnt), SourceColumn).OriginalName.ToUpper)
        Next

        colNames.Sort()

        For cnt1 As Integer = 0 To colNames.Count - 2
            If (CStr(colNames(cnt1)) = CStr(colNames(cnt1 + 1))) Then
                errMsg = String.Format("More than one columns have the original column name of ""{0}""", CStr(colNames(cnt1)))

                'Get the error column index
                For cnt2 As Integer = 0 To Count - 1
                    If (CStr(colNames(cnt1)) = CType(Item(cnt1), SourceColumn).OriginalName.ToUpper) Then
                        errColumn = cnt2
                        Exit For
                    End If
                Next

                Return True
            End If
        Next

        Return False

    End Function

    Public Function CloneMe() As Object Implements System.ICloneable.Clone

        Return Clone()

    End Function

    Public Function Clone() As ColumnCollection

        Dim columns As New ColumnCollection

        For Each col As Column In Me
            columns.Add(DirectCast(col.Clone, Column))
        Next

        Return columns

    End Function

#End Region

#Region " Private Methods "

    Private Function FindByName(ByVal name As String) As Column

        For Each col As Column In MyBase.List
            If col.ColumnName.ToUpper = name.ToUpper Then Return col
        Next

        Return Nothing

    End Function

#End Region

End Class
