

Namespace ODSDBDataAccess

    Public Interface IODSDBRepository

        'Function GetHoldsTable(ByVal clientid As Integer, ByVal studyid As Integer, ByVal surveyIDs As List(Of String)) As DataTable
        Function GetHoldsTable(ByVal clientid As Integer, ByVal studyid As Integer, ByVal surveyIDs As Dictionary(Of String, String)) As DataTable

        Function GetMinEncounterHoldDate(ByVal clientid As Integer, ByVal studyid As Integer, ByVal surveyID As Integer) As Date

        Function GetCustomerSettings(ByVal ClientId As Integer, ConnectSurveyTypeId As String) As Dictionary(Of String, Object)

    End Interface

End Namespace

