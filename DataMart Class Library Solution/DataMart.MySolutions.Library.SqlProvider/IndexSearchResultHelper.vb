Imports Nrc.Framework.Data

Friend Class IndexSearchResultHelper

    Private ReadOnly mResultSet As Guid

    Public Sub New(ByVal resultSet As Guid)
        mResultSet = resultSet
    End Sub

    Public Function PopulateIndexSearchResult(ByVal rdr As SafeDataReader) As IndexSearchResult
        Dim newObject As IndexSearchResult = IndexSearchResult.NewIndexSearchResult
        newObject.Title = rdr.GetString("FileName")
        newObject.Rank = rdr.GetInteger("Rank")
        newObject.ResultSet = mResultSet
        Return newObject
    End Function

End Class

