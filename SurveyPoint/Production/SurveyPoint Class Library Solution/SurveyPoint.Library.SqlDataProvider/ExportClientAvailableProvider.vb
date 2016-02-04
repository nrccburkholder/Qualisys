
'********************************************************************************
' Concrete SqlProvider Class
'********************************************************************************
Imports Nrc.Framework.Data
Imports Nrc.Framework.BusinessLogic
Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports System.Data.Common
Imports System.ComponentModel


Friend Class ExportClientAvailableProvider
    Inherits Nrc.SurveyPoint.Library.DataProviders.ExportClientAvailableProvider

    Private ReadOnly Property Db() As Database
        Get
            Return DatabaseHelper.Db
        End Get
    End Property


#Region " ExportClientAvailable Procs "

    Private Function PopulateClient(ByVal rdr As SafeDataReader) As ExportClientAvailable
        Dim newObject As ExportClientAvailable = ExportClientAvailable.NewClient
        Dim privateInterface As IExportClientAvailable = newObject
        newObject.BeginPopulate()
        privateInterface.ClientID = rdr.GetInteger("ClientID")
        newObject.Name = rdr.GetString("Name")
        newObject.Address1 = rdr.GetString("Address1")
        newObject.Address2 = rdr.GetString("Address2")
        newObject.City = rdr.GetString("City")
        newObject.State = rdr.GetString("State")
        newObject.PostalCode = rdr.GetString("PostalCode")
        newObject.Telephone = rdr.GetString("Telephone")
        newObject.Fax = rdr.GetString("Fax")
        newObject.Active = rdr.GetByte("Active")
        newObject.EndPopulate()

        Return newObject
    End Function

    Public Overrides Function GetBySurveyID(ByVal SurveyID As Integer) As ExportClientAvailableCollection
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SP_GetBySurveyID, SurveyID)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            Return PopulateCollection(Of ExportClientAvailableCollection, ExportClientAvailable)(rdr, AddressOf PopulateClient)
        End Using
    End Function
    Public Overrides Function GetClientByClientID(ByVal clientID As Integer) As ExportClientAvailable
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SP_GetClientByClientID, clientID)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            While rdr.Read
                Return PopulateClient(rdr)
            End While
        End Using
        Return Nothing
    End Function

    'TP 10/16/2008  Used in Template  importer to get list of all clients.
    Public Overrides Function SelectAllClients() As ExportClientAvailableCollection
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SP_SelectAllClients)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            Return PopulateCollection(Of ExportClientAvailableCollection, ExportClientAvailable)(rdr, AddressOf PopulateClient)
        End Using        
    End Function
#End Region


End Class
