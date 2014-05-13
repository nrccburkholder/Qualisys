Option Explicit On 
Option Strict On

'Public Class ApbReportCollection
'    Inherits CollectionBase

'    Default Public ReadOnly Property Item(ByVal index As Integer) As ApbReport
'        Get
'            Return DirectCast(MyBase.List(index), ApbReport)
'        End Get
'    End Property

'    Public Function Add(ByVal job As ApbReport) As Integer
'        Return MyBase.List.Add(job)
'    End Function

'End Class

Public Class ApbReportCollection
    Inherits DictionaryBase

    Public Sub Add(ByVal key As String, ByVal value As ApbReport)
        MyBase.Dictionary.Add(key, value)
    End Sub

    Public Sub Add(ByVal key As Integer, ByVal value As ApbReport)
        MyBase.Dictionary.Add(key.ToString, value)
    End Sub

    Default Public Property Item(ByVal key As String) As ApbReport
        Get
            Return CType(MyBase.Dictionary.Item(key), ApbReport)
        End Get
        Set(ByVal Value As ApbReport)
            MyBase.Dictionary(key) = Value
        End Set
    End Property

    Default Public Property Item(ByVal key As Integer) As ApbReport
        Get
            Return CType(MyBase.Dictionary.Item(key.ToString), ApbReport)
        End Get
        Set(ByVal Value As ApbReport)
            MyBase.Dictionary(key.ToString) = Value
        End Set
    End Property

    Public ReadOnly Property Values() As ICollection
        Get
            Return Dictionary.Values
        End Get
    End Property

End Class