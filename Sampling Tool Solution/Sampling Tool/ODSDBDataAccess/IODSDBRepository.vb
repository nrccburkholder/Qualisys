﻿

Namespace ODSDBDataAccess

    Public Interface IODSDBRepository

        Function GetHoldsTable(ByVal clientid As Integer, ByVal studyid As Integer, ByVal surveyIDs As List(Of String)) As DataTable

        Function GetMinEncounterHoldDate(ByVal clientid As Integer, ByVal studyid As Integer, ByVal surveyID As Integer) As Date

    End Interface

End Namespace

