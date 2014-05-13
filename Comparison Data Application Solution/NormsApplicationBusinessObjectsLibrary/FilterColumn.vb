Public Class FilterColumn

    Private mColumnName As String
    Private mcolumnDesciption As String
    Private mDataType As String
    Private mDataValues As New Collections.ArrayList

    Public Property ColumnName() As String
        Get
            Return mColumnName
        End Get
        Set(ByVal Value As String)
            mColumnName = Value
        End Set
    End Property

    Public Property ColumnDescription() As String
        Get
            Return mcolumnDesciption
        End Get
        Set(ByVal Value As String)
            mcolumnDesciption = Value
        End Set
    End Property

    Public Property DataType() As String
        Get
            Return mDataType
        End Get
        Set(ByVal Value As String)
            mDataType = Value
        End Set
    End Property

    Public ReadOnly Property DataValues() As Collections.ArrayList
        Get
            If mDataValues.Count = 0 Then getFilterValues()
            Return mDataValues
        End Get
    End Property

#Region "private Methods"
    Private Sub getFilterValues()
        Dim ds As DataSet
        mDataValues.Clear()
        ds = DataAccess.GetFilterValues(mColumnName)
        For Each row As DataRow In ds.Tables(0).Rows
            mDataValues.Add(row("Value"))
        Next
    End Sub
#End Region

#Region "Public Methods"
    Public Sub AddDataValue(ByVal Value As String)
        mDataValues.Add(Value)
    End Sub

    Public Shared Function GetallFilterColumns() As FilterColumnCollection
        Dim ds As DataSet

        Dim tmpFilterColumn As FilterColumn
        Dim tmpFilterColumnCollection As New FilterColumnCollection
        ds = DataAccess.GetFilterColumns()
        For Each row As DataRow In ds.Tables(0).Rows
            tmpFilterColumn = New FilterColumn
            With tmpFilterColumn
                .mColumnName = row("column_name")
                .mcolumnDesciption = row("strservice_nm")
                .mDataType = row("data_type")
                If .mDataType = "bit" Then
                    .mDataValues.Add("True")
                    .mDataValues.Add("False")
                End If
            End With
            tmpFilterColumnCollection.Add(tmpFilterColumn)
        Next
        Return tmpFilterColumnCollection
    End Function
#End Region

End Class

