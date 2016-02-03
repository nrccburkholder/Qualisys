
'********************************************************************************
' Concrete SqlProvider Class
'********************************************************************************
Imports Nrc.Framework.Data
Imports Nrc.Framework.BusinessLogic
Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports System.Data.Common
Imports System.ComponentModel


Friend Class ExportClientSelectedProvider
    Inherits Nrc.SurveyPoint.Library.DataProviders.ExportClientSelectedProvider

    Private ReadOnly Property Db() As Database
        Get
            Return DatabaseHelper.Db
        End Get
    End Property


#Region " ExportClientSelected Procs "

    Private Function PopulateExportClientSelected(ByVal rdr As SafeDataReader) As ExportClientSelected
        Dim newObject As ExportClientSelected = ExportClientSelected.NewClient
        Dim privateInterface As IExportClientSelected = newObject
        newObject.BeginPopulate()
        privateInterface.ClientID = rdr.GetInteger("ClientID")
        newObject.Active = rdr.GetByte("Active")
        newObject.Address1 = rdr.GetString("Address1")
        newObject.Address2 = rdr.GetString("Address2")
        newObject.City = rdr.GetString("City")
        newObject.Fax = rdr.GetString("Fax")
        newObject.Name = rdr.GetString("Name")
        newObject.PostalCode = rdr.GetString("PostalCode")
        newObject.State = rdr.GetString("State")
        newObject.Telephone = rdr.GetString("Telephone")
        'newObject.ClientExtensionID = rdr.GetInteger("ClientExtensionID")
        'newObject.ExportGroupID = rdr.GetInteger("ExportGroupID")
        newObject.MiscChar1 = rdr.GetString("MiscChar1")
        newObject.MiscChar1Name = rdr.GetString("MiscChar1Name")
        newObject.MiscChar2 = rdr.GetString("MiscChar2")
        newObject.MiscChar2Name = rdr.GetString("MiscChar2Name")
        newObject.MiscChar3 = rdr.GetString("MiscChar3")
        newObject.MiscChar3Name = rdr.GetString("MiscChar3Name")
        newObject.MiscChar4 = rdr.GetString("MiscChar4")
        newObject.MiscChar4Name = rdr.GetString("MiscChar4Name")
        newObject.MiscChar5 = rdr.GetString("MiscChar5")
        newObject.MiscChar5Name = rdr.GetString("MiscChar5Name")
        newObject.MiscChar6 = rdr.GetString("MiscChar6")
        newObject.MiscChar6Name = rdr.GetString("MiscChar6Name")
        newObject.MiscDate1 = rdr.GetNullableDate("MiscDate1")
        newObject.MiscDate1Name = rdr.GetString("MiscDate1Name")
        newObject.MiscDate2 = rdr.GetNullableDate("MiscDate2")
        newObject.MiscDate2Name = rdr.GetString("MiscDate2Name")
        newObject.MiscDate3 = rdr.GetNullableDate("MiscDate3")
        newObject.MiscDate3Name = rdr.GetString("MiscDate3Name")
        newObject.MiscNum2Name = rdr.GetString("MiscNum2Name")
        newObject.MiscNum1 = rdr.GetNullableDecimal("MiscNum1")
        newObject.MiscNum1Name = rdr.GetString("MiscNum1Name")
        newObject.MiscNum2 = rdr.GetNullableDecimal("MiscNum2")
        newObject.MiscNum3 = rdr.GetNullableDecimal("MiscNum3")
        newObject.MiscNum3Name = rdr.GetString("MiscNum3Name")
        newObject.ExportClientExtensionCollection = Me.PopulateExportClientExtensionCollection(newObject)
        newObject.EndPopulate()
        Return newObject
    End Function

    Private Function PopulateExportClientSelectedWithEmptyExtensions(ByVal rdr As SafeDataReader) As ExportClientSelected
        Dim newObject As ExportClientSelected = ExportClientSelected.NewClient
        Dim privateInterface As IExportClientSelected = newObject
        newObject.BeginPopulate()
        privateInterface.ClientID = rdr.GetInteger("ClientID")
        newObject.Active = rdr.GetByte("Active")
        newObject.Address1 = rdr.GetString("Address1")
        newObject.Address2 = rdr.GetString("Address2")
        newObject.City = rdr.GetString("City")
        newObject.Fax = rdr.GetString("Fax")
        newObject.Name = rdr.GetString("Name")
        newObject.PostalCode = rdr.GetString("PostalCode")
        newObject.State = rdr.GetString("State")
        newObject.Telephone = rdr.GetString("Telephone")
        'newObject.ClientExtensionID = rdr.GetInteger("ClientExtensionID")
        'newObject.ExportGroupID = rdr.GetInteger("ExportGroupID")
        'newObject.LinkedSurvey = mLinkedSurvey
        newObject.MiscChar1 = String.Empty
        'TODO DB fix
        newObject.MiscChar1Name = "" 'rdr.GetString("MiscChar1Name")
        newObject.MiscChar2 = String.Empty
        newObject.MiscChar2Name = String.Empty
        newObject.MiscChar3 = String.Empty
        'TODO DB fix
        newObject.MiscChar3Name = "" 'rdr.GetString("MiscChar3Name")
        newObject.MiscChar4 = String.Empty
        'TODO DB fix
        newObject.MiscChar4Name = "" 'rdr.GetString("MiscChar4Name")
        newObject.MiscChar5 = String.Empty
        newObject.MiscChar5Name = String.Empty
        newObject.MiscChar6 = String.Empty
        'TODO DB fix
        newObject.MiscChar6Name = "" 'rdr.GetString("MiscChar6Name")
        newObject.MiscDate1 = Nothing
        newObject.MiscDate1Name = String.Empty
        newObject.MiscDate2 = Nothing
        newObject.MiscDate2Name = String.Empty
        newObject.MiscDate3 = Nothing
        newObject.MiscDate3Name = String.Empty
        newObject.MiscNum1 = Nothing
        newObject.MiscNum1Name = String.Empty
        newObject.MiscNum2 = Nothing
        newObject.MiscNum2Name = String.Empty
        newObject.MiscNum3 = Nothing
        newObject.MiscNum3Name = String.Empty
        newObject.ExportClientExtensionCollection = Me.PopulateExportClientExtensionCollection(newObject)
        newObject.EndPopulate()
        Return newObject
    End Function
    Public Overrides Function GetSelectedClientByClientID(ByVal clientID As Integer) As ExportClientSelected
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SP_GetSelectedClientByClientID, clientID)
        Dim retVal As ExportClientSelected = Nothing
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            While rdr.Read
                retVal = PopulateExportClientSelectedWithEmptyExtensions(rdr)
            End While
        End Using
        Return retVal
    End Function

    Public Overrides Function GetSelectedClients(ByVal Group As ExportGroup, ByVal Survey As ExportSurvey) As ExportClientSelectedCollection
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SP_GetSelectedClients, Group.ExportGroupID, Survey.SurveyID)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            Dim ResultCollection As ExportClientSelectedCollection = _
                PopulateCollection(Of ExportClientSelectedCollection, ExportClientSelected)(rdr, AddressOf PopulateExportClientSelected)
             Return ResultCollection
        End Using
    End Function

    Public Overrides Sub InsertClient(ByVal client As ExportClientSelected, ByVal surveyID As Integer, ByVal exportGroupID As Integer)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.InsertClientExtension, client.ClientID, _
            exportGroupID, surveyID, client.MiscChar1, client.MiscChar1Name, client.MiscChar2, _
            client.MiscChar2Name, client.MiscChar3, client.MiscChar3Name, client.MiscChar4, _
            client.MiscChar4Name, client.MiscChar5, client.MiscChar5Name, client.MiscChar6, _
            client.MiscChar6Name, SafeDataReader.ToDBValue(client.MiscNum1), client.MiscNum1Name, SafeDataReader.ToDBValue(client.MiscNum2), _
            client.MiscNum2Name, SafeDataReader.ToDBValue(client.MiscNum3), client.MiscNum3Name, SafeDataReader.ToDBValue(client.MiscDate1), _
            client.MiscDate1Name, SafeDataReader.ToDBValue(client.MiscDate2), client.MiscDate2Name, SafeDataReader.ToDBValue(client.MiscDate3), _
            client.MiscDate3Name)
        ExecuteNonQuery(cmd)
    End Sub

#End Region

    Private Function PopulateExportClientExtensionCollection(ByVal NewObject As ExportClientSelected) As ExportClientExtensionCollection
        Dim newExportClientExtensionCollection As New ExportClientExtensionCollection

        Dim MiscChar1Extension As ExportClientExtension = ExportClientExtension.NewExportClientExtension(NewObject, "MiscChar1", NewObject.MiscChar1Name, NewObject.MiscChar1)
        newExportClientExtensionCollection.Add(MiscChar1Extension)

        Dim MiscChar2Extension As ExportClientExtension = ExportClientExtension.NewExportClientExtension(NewObject, "MiscChar2", NewObject.MiscChar2Name, NewObject.MiscChar2)
        newExportClientExtensionCollection.Add(MiscChar2Extension)

        Dim MiscChar3Extension As ExportClientExtension = ExportClientExtension.NewExportClientExtension(NewObject, "MiscChar3", NewObject.MiscChar3Name, NewObject.MiscChar3)
        newExportClientExtensionCollection.Add(MiscChar3Extension)

        Dim MiscChar4Extension As ExportClientExtension = ExportClientExtension.NewExportClientExtension(NewObject, "MiscChar4", NewObject.MiscChar4Name, NewObject.MiscChar4)
        newExportClientExtensionCollection.Add(MiscChar4Extension)

        Dim MiscChar5Extension As ExportClientExtension = ExportClientExtension.NewExportClientExtension(NewObject, "MiscChar5", NewObject.MiscChar5Name, NewObject.MiscChar5)
        newExportClientExtensionCollection.Add(MiscChar5Extension)

        Dim MiscChar6Extension As ExportClientExtension = ExportClientExtension.NewExportClientExtension(NewObject, "MiscChar6", NewObject.MiscChar6Name, NewObject.MiscChar6)
        newExportClientExtensionCollection.Add(MiscChar6Extension)

        Dim MiscNum1Extension As ExportClientExtension = ExportClientExtension.NewExportClientExtension(NewObject, "MiscNum1", NewObject.MiscNum1Name, NewObject.MiscNum1.ToString)
        newExportClientExtensionCollection.Add(MiscNum1Extension)

        Dim MiscNum2Extension As ExportClientExtension = ExportClientExtension.NewExportClientExtension(NewObject, "MiscNum2", NewObject.MiscNum2Name, NewObject.MiscNum2.ToString)
        newExportClientExtensionCollection.Add(MiscNum2Extension)

        Dim MiscNum3Extension As ExportClientExtension = ExportClientExtension.NewExportClientExtension(NewObject, "MiscNum3", NewObject.MiscNum3Name, NewObject.MiscNum3.ToString)
        newExportClientExtensionCollection.Add(MiscNum3Extension)

        Dim MiscDate1Extension As ExportClientExtension = ExportClientExtension.NewExportClientExtension(NewObject, "MiscDate1", NewObject.MiscDate1Name, NewObject.MiscDate1.ToString)
        newExportClientExtensionCollection.Add(MiscDate1Extension)

        Dim MiscDate2Extension As ExportClientExtension = ExportClientExtension.NewExportClientExtension(NewObject, "MiscDate2", NewObject.MiscDate2Name, NewObject.MiscDate2.ToString)
        newExportClientExtensionCollection.Add(MiscDate2Extension)

        Dim MiscDate3Extension As ExportClientExtension = ExportClientExtension.NewExportClientExtension(NewObject, "MiscDate3", NewObject.MiscDate3Name, NewObject.MiscDate3.ToString)
        newExportClientExtensionCollection.Add(MiscDate3Extension)


        Return newExportClientExtensionCollection
    End Function
 End Class
