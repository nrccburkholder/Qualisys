Option Explicit On 
Option Strict On

Public Class ListViewSortCriteria
    Private mSortColumn As Integer
    Private mDataType As DataType
    Private mSortOrder As SortOrder = SortOrder.Ascend

    Sub New(ByVal sortColumn As Integer, ByVal dataType As DataType, ByVal sortOrder As SortOrder)
        Me.mSortColumn = sortColumn
        Me.mDataType = dataType
        Me.mSortOrder = sortOrder
    End Sub

    Public Property SortColumn() As Integer
        Get
            Return mSortColumn
        End Get
        Set(ByVal Value As Integer)
            If (Value = mSortColumn) Then
                mSortOrder = CType(IIf(mSortOrder = SortOrder.Ascend, SortOrder.Descend, SortOrder.Ascend), SortOrder)
            Else
                mSortOrder = SortOrder.Ascend
            End If
            mSortColumn = Value
        End Set
    End Property

    Public Property DataType() As DataType
        Get
            Return mDataType
        End Get
        Set(ByVal Value As DataType)
            mDataType = Value
        End Set
    End Property

    Public ReadOnly Property SortOrder() As SortOrder
        Get
            Return mSortOrder
        End Get
    End Property

    Public ReadOnly Property SortOrderIcon() As String
        Get
            If (mSortOrder = SortOrder.Ascend) Then
                Return (" ▲")
            Else
                Return (" ▼")
            End If
        End Get
    End Property
End Class

