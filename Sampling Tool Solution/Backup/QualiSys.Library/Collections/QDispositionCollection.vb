''' -----------------------------------------------------------------------------
''' Project	 : PopulationManagerLibrary
''' Class	 : PopulationManager.Library.DispositionCollection
''' 
''' -----------------------------------------------------------------------------
''' <summary>
''' A collection of Disposition objects.
''' </summary>
''' <remarks>
''' </remarks>
''' <history>
''' 	[jcamp]	10/4/2005	Created
''' </history>
''' -----------------------------------------------------------------------------
<Serializable()> _
Public Class QDispositionCollection
    Inherits CollectionBase

    Default Public ReadOnly Property Item(ByVal index As Integer) As QDisposition
        Get
            Return DirectCast(MyBase.List(index), QDisposition)
        End Get
    End Property

    Public Function Add(ByVal dispo As QDisposition) As Integer
        Return MyBase.List.Add(dispo)
    End Function

    Public Function FindById(ByVal id As Integer) As QDisposition
        For Each dispo As QDisposition In Me
            If dispo.Id = id Then
                Return dispo
            End If
        Next

        Return Nothing
    End Function

    Public Sub Sort()
        Me.InnerList.Sort()
    End Sub

End Class