'********************************************************************************
' Concrete SqlProvider Class
'********************************************************************************
Imports Nrc.Framework.Data
Imports Nrc.Framework.BusinessLogic
Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports System.Data.Common
Imports System.ComponentModel

Friend Class ExportEventSelectedProvider
    Inherits Nrc.SurveyPoint.Library.DataProviders.ExportEventSelectedProvider

    Private ReadOnly Property Db() As Database
        Get
            Return DatabaseHelper.Db
        End Get
    End Property


#Region " SPU_ExportEvent Procs "

    Private Function PopulateExportEvent(ByVal rdr As SafeDataReader) As ExportEventSelected
        Dim newObject As ExportEventSelected = ExportEventSelected.NewExportEvent
        Dim privateInterface As IExportEventSelected = newObject
        newObject.BeginPopulate()
        privateInterface.EventID = rdr.GetInteger("EventID")
        newObject.Name = rdr.GetString("Name")
        newObject.EndPopulate()
        Return newObject
    End Function

    Public Overrides Function [Get](ByVal eventID As Integer) As ExportEventSelected
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectedEventByID, eventID)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            If rdr.Read Then
                Return PopulateExportEvent(rdr)
            Else
                Return Nothing
            End If
        End Using
    End Function
    Public Overrides Function GetExcludedExportEvents(ByVal exportGroupID As Integer) As ExportEventSelectedCollection
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectSelectedExportEvents, exportGroupID)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            Return PopulateExcludedCollection(Of ExportEventSelectedCollection, ExportEventSelected)(rdr, AddressOf PopulateExportEvent)
        End Using
    End Function

    Public Overrides Function GetIncludedExportEvents(ByVal exportGroupID As Integer) As ExportEventSelectedCollection
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectSelectedExportEvents, exportGroupID)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            Return PopulateIncludedCollection(Of ExportEventSelectedCollection, ExportEventSelected)(rdr, AddressOf PopulateExportEvent)
        End Using
    End Function
    Public Overrides Sub InsertExcludeEvent(ByVal eventID As Integer, ByVal exportGroupID As Integer)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.InsertExportEvent, exportGroupID, eventID, 0)
        ExecuteNonQuery(cmd)
    End Sub
    Public Overrides Sub InsertIncludeEvent(ByVal eventID As Integer, ByVal exportGroupID As Integer)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.InsertExportEvent, exportGroupID, eventID, 1)
        ExecuteNonQuery(cmd)
    End Sub
#End Region


    ''' <summary>This function will return a list populated with only events that have the Included bit.</summary>
    ''' <CreatedBy>Steve Kennedy</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Function PopulateIncludedCollection(Of C As {BusinessListBase(Of C, T), New}, T As BusinessBase(Of T))(ByVal rdr As SafeDataReader, ByVal populateMethod As FillMethod(Of T)) As C
        Dim list As New C
        While rdr.Read
            If rdr.GetInteger("isIncluded") = 1 Then
                list.Add(populateMethod(rdr))
            End If
        End While
        Return list
    End Function

    ''' <summary>This function will return a list populated with only events that do not have the Included bit.</summary>
    ''' <CreatedBy>Steve Kennedy</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Function PopulateExcludedCollection(Of C As {BusinessListBase(Of C, T), New}, T As BusinessBase(Of T))(ByVal rdr As SafeDataReader, ByVal populateMethod As FillMethod(Of T)) As C
        Dim list As New C
        While rdr.Read
            If rdr.GetInteger("isIncluded") = 0 Then list.Add(populateMethod(rdr))
        End While
        Return list
    End Function



End Class
