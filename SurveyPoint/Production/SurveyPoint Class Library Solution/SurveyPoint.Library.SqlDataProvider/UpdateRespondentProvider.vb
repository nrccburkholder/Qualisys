Imports Nrc.Framework.Data
Imports Nrc.Framework.BusinessLogic
Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports System.Data.Common
Imports System.Collections.ObjectModel

Friend Class UpdateRespondentProvider
    Inherits Nrc.SurveyPoint.Library.DataProviders.UpdateRespondentProvider

    Private Function Populate(ByVal rdr As SafeDataReader) As UpdateRespondent

        Dim newObject As UpdateRespondent = UpdateRespondent.NewUpdateRespondent
        Dim privateInterface As IUpdateRespondent = newObject
        newObject.BeginPopulate()
        privateInterface.RespondentID = rdr.GetInteger("RespondentID")
        newObject.FirstName = rdr.GetString("FirstName")
        newObject.LastName = rdr.GetString("LastName")
        newObject.EndPopulate()

        Return newObject

    End Function

    Public Overrides Function [Select](ByVal id As Integer) As UpdateRespondent

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectUpdateRespondent, id)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            If Not rdr.Read Then
                Return Nothing
            Else
                Return Populate(rdr)
            End If
        End Using

    End Function

    Public Overrides Function SelectByAlreadyUpdated(ByVal respondentIDs As String) As UpdateRespondentCollection

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectUpdateRespondentsByAlreadyUpdated, respondentIDs, DBNull.Value)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            Return PopulateCollection(Of UpdateRespondentCollection, UpdateRespondent)(rdr, AddressOf Populate)
        End Using

    End Function

    Public Overrides Function SelectByMissingStartCodes(ByVal respondentIDs As String, ByVal importDate As Date) As UpdateRespondentCollection

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectUpdateRespondentsByMissingStartCodes, respondentIDs, importDate)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            Return PopulateCollection(Of UpdateRespondentCollection, UpdateRespondent)(rdr, AddressOf Populate)
        End Using

    End Function

    Public Overrides Function UpdateMissingEventCodes(ByVal respondentIDs As String) As UpdateRespondentCollection

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.UpdateMissingEventCodes, respondentIDs, 1, 1)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            Return PopulateCollection(Of UpdateRespondentCollection, UpdateRespondent)(rdr, AddressOf Populate)
        End Using

    End Function

    Public Overrides Function UpdateMapping(ByVal respondentID As Integer, ByVal oldEventCode As Integer, ByVal newEventCode As Integer) As Integer

        'Update this code
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.UpdateMapping, respondentID, oldEventCode, newEventCode)
        Return ExecuteInteger(cmd)

        ''Determine what type of update we are performing
        'If oldEventCode = -1 AndAlso newEventCode > -1 Then
        '    'We need to insert this code
        '    Dim eventLogID As Integer
        '    Dim eventParams As String = String.Empty
        '    Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.InsertMapping, eventLogID, newEventCode, 1, respondentID, eventParams)
        '    ExecuteNonQuery(cmd)

        'ElseIf oldEventCode > -1 AndAlso newEventCode = -1 Then
        '    'We need to delete this code
        '    Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.DeleteMapping, respondentID, oldEventCode)
        '    ExecuteNonQuery(cmd)

        'ElseIf oldEventCode > -1 AndAlso newEventCode > -1 Then
        '    'We need to update this code
        '    Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.UpdateMapping, respondentID, oldEventCode, newEventCode)
        '    ExecuteNonQuery(cmd)

        'End If

    End Function

End Class
