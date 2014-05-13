'Imports System.Drawing
'Namespace Web
'    Public Class ReportRow

'#Region " Private Members "
'        Private mCollection As ReportRowCollection
'        Private mTable As ReportTable

'        Private mRowLabel As String
'        Private mBackColor As Color
'#End Region

'#Region " Public Properties "
'        Default Public Property Item(ByVal index As Integer) As Object
'            Get
'                Dim recordNum As Integer = mCollection.GetIndexOf(Me)
'                If recordNum < 0 Then Throw New ApplicationException("Row could not be indexed.")

'                Return mTable.Column(index)(recordNum)
'            End Get
'            Set(ByVal Value As Object)
'                Dim recordNum As Integer = mCollection.GetIndexOf(Me)
'                If recordNum < 0 Then Throw New ApplicationException("Row could not be indexed.")

'                mTable.Column(index)(recordNum) = Value
'            End Set
'        End Property

'        Public Property RowLabel() As String
'            Get
'                Return mRowLabel
'            End Get
'            Set(ByVal Value As String)
'                mRowLabel = Value
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

'#End Region

'        Public Sub New(ByVal parentCollection As ReportRowCollection, ByVal parentTable As ReportTable)
'            mCollection = parentCollection
'            mTable = parentTable
'            mBackColor = Color.White
'        End Sub

'    End Class

'#Region " ReportTableRowCollection Class "
'    Public Class ReportRowCollection
'        Inherits CollectionBase

'#Region " Event Declarations "
'        Public Class RowEventArgs
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
'        Public Delegate Sub RowEventHandler(ByVal sender As Object, ByVal e As RowEventArgs)
'        Public Event RowAdded As RowEventHandler
'        Public Event RowRemoved As RowEventHandler
'        Public Event RowsCleared As EventHandler

'#End Region

'        Private mTable As ReportTable

'        Default Public ReadOnly Property Item(ByVal index As Integer) As ReportRow
'            Get
'                Return DirectCast(MyBase.InnerList(index), ReportRow)
'            End Get
'        End Property

'        Public Sub New(ByVal parentTable As ReportTable)
'            mTable = parentTable
'        End Sub

'        Public Function Add(ByVal rowLabel As String) As ReportRow
'            Dim row As New ReportRow(Me, mTable)
'            row.RowLabel = rowLabel

'            Me.List.Add(row)
'            Return row
'        End Function

'        Public Function GetIndexOf(ByVal row As ReportRow) As Integer
'            Dim i As Integer
'            For i = 0 To list.Count
'                If list(i) Is row Then
'                    Return i
'                End If
'            Next

'            Return -1
'        End Function

'        Protected Overrides Sub OnInsertComplete(ByVal index As Integer, ByVal value As Object)
'            RaiseEvent RowAdded(Me, New RowEventArgs(index))
'        End Sub

'        Protected Overrides Sub OnClearComplete()
'            RaiseEvent RowsCleared(Me, New EventArgs)
'        End Sub

'        Protected Overrides Sub OnRemoveComplete(ByVal index As Integer, ByVal value As Object)
'            RaiseEvent RowRemoved(Me, New RowEventArgs(index))
'        End Sub
'    End Class

'#End Region

'End Namespace