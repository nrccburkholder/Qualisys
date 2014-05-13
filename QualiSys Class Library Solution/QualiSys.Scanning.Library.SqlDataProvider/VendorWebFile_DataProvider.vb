'********************************************************************************
' Concrete SqlProvider Class
'********************************************************************************
Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports System.Data.Common
Imports NRC.Framework.Data


Friend Class VendorWebFile_DataProvider
    Inherits QualiSys.Scanning.Library.VendorWebFile_DataProvider

    Private ReadOnly Property Db() As Database
        Get
            Return QualiSysDatabaseHelper.Db
        End Get
    End Property


#Region " VendorWebFile_Data Procs "

    Private Function PopulateVendorWebFile_Data(ByVal rdr As SafeDataReader) As VendorWebFile_Data

        Dim newObject As VendorWebFile_Data = VendorWebFile_Data.NewVendorWebFile_Data
        Dim privateInterface As IVendorWebFile_Data = newObject

        newObject.BeginPopulate()
        privateInterface.Id = rdr.GetInteger("VendorWebFile_Data_ID")
        newObject.VendorFileId = rdr.GetInteger("VendorFile_ID")
        newObject.SurveyId = rdr.GetInteger("Survey_ID")
        newObject.SamplesetId = rdr.GetInteger("Sampleset_ID")
        newObject.Litho = rdr.GetString("Litho")
        newObject.WAC = rdr.GetString("WAC")
        newObject.FName = rdr.GetString("FName")
        newObject.LName = rdr.GetString("LName")
        newObject.LangId = rdr.GetInteger("LangID")
        newObject.EmailAddr = rdr.GetString("Email_Address")
        newObject.WbServDate = rdr.GetNullableDate("WbServDate")
        newObject.wbServInd1 = rdr.GetString("wbServInd1")
        newObject.wbServInd2 = rdr.GetString("wbServInd2")
        newObject.wbServInd3 = rdr.GetString("wbServInd3")
        newObject.wbServInd4 = rdr.GetString("wbServInd4")
        newObject.wbServInd5 = rdr.GetString("wbServInd5")
        newObject.wbServInd6 = rdr.GetString("wbServInd6")
        newObject.ExternalRespondentID = rdr.GetString("ExternalRespondentID")
        newObject.SentToVendor = rdr.GetBoolean("bitSentToVendor")
        newObject.EndPopulate()

        Return newObject

    End Function

    Public Overrides Function SelectVendorWebFile_Data(ByVal id As Integer) As VendorWebFile_Data

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectVendorWebFile_Data, id)

        Using rdr As New SafeDataReader(QualiSysDatabaseHelper.ExecuteReader(cmd))
            If Not rdr.Read Then
                Return Nothing
            Else
                Return PopulateVendorWebFile_Data(rdr)
            End If
        End Using

    End Function

    Public Overrides Function SelectAllVendorWebFile_Datas() As VendorWebFile_DataCollection

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectAllVendorWebFile_Datas)

        Using rdr As New SafeDataReader(QualiSysDatabaseHelper.ExecuteReader(cmd))
            Return QualiSysDatabaseHelper.PopulateCollection(Of VendorWebFile_DataCollection, VendorWebFile_Data)(rdr, AddressOf PopulateVendorWebFile_Data)
        End Using

    End Function

    Public Overrides Function SelectVendorWebFile_DatasByVendorFileId(ByVal vendorFileId As Integer, ByVal HidePII As Boolean) As VendorWebFile_DataCollection

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectVendorWebFile_DatasByVendorFileId, vendorFileId, HidePII)

        Using rdr As New SafeDataReader(QualiSysDatabaseHelper.ExecuteReader(cmd))
            Return QualiSysDatabaseHelper.PopulateCollection(Of VendorWebFile_DataCollection, VendorWebFile_Data)(rdr, AddressOf PopulateVendorWebFile_Data)
        End Using

    End Function

    Public Overrides Function SelectVendorWebFile_DatasByLitho(ByVal litho As String) As VendorWebFile_Data

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectVendorWebFile_DatasByLitho, litho)

        Using rdr As New SafeDataReader(QualiSysDatabaseHelper.ExecuteReader(cmd))
            If Not rdr.Read Then
                Return Nothing
            Else
                Return PopulateVendorWebFile_Data(rdr)
            End If
        End Using

    End Function

    Public Overrides Function InsertVendorWebFile_Data(ByVal instance As VendorWebFile_Data) As Integer

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.InsertVendorWebFile_Data, instance.VendorFileId, instance.SurveyId, instance.SamplesetId, instance.Litho, instance.WAC, instance.FName, instance.LName, instance.LangId, instance.EmailAddr, SafeDataReader.ToDBValue(instance.WbServDate), instance.wbServInd1, instance.wbServInd2, instance.wbServInd3, instance.wbServInd4, instance.wbServInd5, instance.wbServInd6, instance.ExternalRespondentID, instance.SentToVendor)
        Return QualiSysDatabaseHelper.ExecuteInteger(cmd)

    End Function

    Public Overrides Sub UpdateVendorWebFile_Data(ByVal instance As VendorWebFile_Data)

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.UpdateVendorWebFile_Data, instance.Id, instance.VendorFileId, instance.SurveyId, instance.SamplesetId, instance.Litho, instance.WAC, instance.FName, instance.LName, instance.LangId, instance.EmailAddr, SafeDataReader.ToDBValue(instance.WbServDate), instance.wbServInd1, instance.wbServInd2, instance.wbServInd3, instance.wbServInd4, instance.wbServInd5, instance.wbServInd6, instance.ExternalRespondentID, instance.SentToVendor)
        QualiSysDatabaseHelper.ExecuteNonQuery(cmd)

    End Sub

    Public Overrides Sub DeleteVendorWebFile_Data(ByVal instance As VendorWebFile_Data)

        If instance IsNot Nothing Then
            Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.DeleteVendorWebFile_Data, instance.Id)
            QualiSysDatabaseHelper.ExecuteNonQuery(cmd)
        End If

    End Sub

#End Region

End Class
