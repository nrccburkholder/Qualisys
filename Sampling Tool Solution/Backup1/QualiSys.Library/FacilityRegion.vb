Imports Nrc.QualiSys.Library.DataProvider

Public Class FacilityRegion
    Implements IComparable(Of FacilityRegion)

    Private mId As Integer
    Private mName As String

    Public ReadOnly Property Id() As Integer
        Get
            Return mId
        End Get
    End Property

    Public ReadOnly Property Name() As String
        Get
            Return mName
        End Get
    End Property

    Friend Sub New(ByVal id As Integer, ByVal name As String)
        mId = id
        mName = name
    End Sub

    Public Shared Function GetAll() As Collection(Of FacilityRegion)
        Return FacilityProvider.Instance.SelectAllFacilityRegions()
    End Function

    Public Function CompareTo(ByVal other As FacilityRegion) As Integer Implements System.IComparable(Of FacilityRegion).CompareTo
        Return Me.mName.CompareTo(other.mName)
    End Function
End Class
