Option Explicit On 
Option Strict On

Public Class ApbReportListCollection
    Inherits CollectionBase

    Default Public ReadOnly Property Item(ByVal index As Integer) As ApbReport
        Get
            Return DirectCast(MyBase.List(index), ApbReport)
        End Get
    End Property

    Public Function Add(ByVal job As ApbReport) As Integer
        Return MyBase.List.Add(job)
    End Function

End Class
