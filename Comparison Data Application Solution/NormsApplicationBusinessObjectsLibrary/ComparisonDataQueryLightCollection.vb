Public Class ComparisonDataQueryLightCollection
    Inherits CollectionBase

    Default Public ReadOnly Property Item(ByVal index As Integer) As ComparisonDataQueryLight
        Get
            Return DirectCast(MyBase.List(index), ComparisonDataQueryLight)
        End Get
    End Property

    Public Function Add(ByVal newComparisonDataQuery As ComparisonDataQueryLight) As Integer
        Return MyBase.List.Add(newComparisonDataQuery)
    End Function

    Public Shared Function GetAvailableQueries(ByVal memberID As Integer, ByVal reportType As ComparisonDataQuery.enuReportType) As ComparisonDataQueryLightCollection
        Dim ds As DataSet
        Dim queryList As New ComparisonDataQueryLightCollection
        Dim query As ComparisonDataQueryLight
        ds = DataAccess.getSavedQueries(memberID, reportType)
        If ds.Tables.Count > 0 Then
            For Each row As DataRow In ds.Tables(0).Rows
                query = New ComparisonDataQueryLight
                query.ID = row.Item("NormReport_ID")
                query.Label = row.Item("Label")
                query.Description = row.Item("Description")
                query.WhoCreated = row.Item("strMember_nm")
                query.WhenCreated = row.Item("DateCreated")
                queryList.Add(query)
            Next
        End If
        Return queryList
    End Function
End Class
