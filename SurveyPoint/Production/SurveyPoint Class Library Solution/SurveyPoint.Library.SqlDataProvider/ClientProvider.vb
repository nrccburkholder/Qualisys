
'********************************************************************************
' Concrete SqlProvider Class
'********************************************************************************
Imports Nrc.Framework.Data
Imports Nrc.Framework.BusinessLogic
Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports System.Data.Common
Imports System.ComponentModel


Friend Class ClientProvider
    Inherits Nrc.SurveyPoint.Library.DataProviders.ClientProvider

    Private ReadOnly Property Db() As Database
        Get
            Return DatabaseHelper.Db
        End Get
    End Property


#Region " TEMP_SPU_GetAllClient Procs "

    Private Function PopulateClient(ByVal rdr As SafeDataReader) As Client
        Dim newObject As Client = Client.NewClient
        Dim privateInterface As IClient = newObject
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

    Public Overrides Function GetSelectedClients(ByVal ExportGroupID As Integer, ByVal SurveyID As Integer) As ClientCollection
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SP_GetSelectedClients, ExportGroupID, SurveyID)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            Return PopulateCollection(Of ClientCollection, Client)(rdr, AddressOf PopulateClient)
        End Using
    End Function

    Public Overrides Function GetBySurveyID(ByVal SurveyID As Integer) As ClientCollection
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SP_GetBySurveyID, SurveyID)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            Return PopulateCollection(Of ClientCollection, Client)(rdr, AddressOf PopulateClient)
        End Using
    End Function


#End Region


End Class
