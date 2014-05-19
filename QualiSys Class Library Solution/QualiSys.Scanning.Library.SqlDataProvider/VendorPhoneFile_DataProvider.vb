'********************************************************************************
' Concrete SqlProvider Class
'********************************************************************************
Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports System.Data.Common
Imports NRC.Framework.Data


Friend Class VendorPhoneFile_DataProvider
	Inherits QualiSys.Scanning.Library.VendorPhoneFile_DataProvider

    Private ReadOnly Property Db() As Database
        Get
            Return QualiSysDatabaseHelper.Db
        End Get
    End Property

	
#Region " VendorPhoneFile_Data Procs "

    Private Function PopulateVendorPhoneFile_Data(ByVal rdr As SafeDataReader) As VendorPhoneFile_Data

        Dim newObject As VendorPhoneFile_Data = VendorPhoneFile_Data.NewVendorPhoneFile_Data
        Dim privateInterface As IVendorPhoneFile_Data = newObject

        newObject.BeginPopulate()
        privateInterface.VendorFile_DataId = rdr.GetInteger("VendorFile_Data_ID")
        newObject.VendorFileId = rdr.GetInteger("VendorFile_ID")
        newObject.HCAHPSSamp = rdr.GetInteger("HCAHPSSamp")
        newObject.Litho = rdr.GetString("Litho")
        newObject.SurveyId = rdr.GetInteger("Survey_ID")
        newObject.SamplesetId = rdr.GetInteger("Sampleset_ID")
        newObject.Phone = rdr.GetString("Phone")
        newObject.AltPhone = rdr.GetString("AltPhone")
        newObject.FName = rdr.GetString("FName")
        newObject.LName = rdr.GetString("LName")
        newObject.Addr = rdr.GetString("Addr")
        newObject.Addr2 = rdr.GetString("Addr2")
        newObject.City = rdr.GetString("City")
        newObject.St = rdr.GetString("St")
        newObject.Zip5 = rdr.GetString("Zip5")
        newObject.PhServDate = rdr.GetDate("PhServDate")
        newObject.LangID = rdr.GetInteger("LangID")
        newObject.Telematch = rdr.GetString("Telematch")
        newObject.PhFacName = rdr.GetString("PhFacName")
        newObject.PhServInd1 = rdr.GetString("PhServInd1")
        newObject.PhServInd2 = rdr.GetString("PhServInd2")
        newObject.PhServInd3 = rdr.GetString("PhServInd3")
        newObject.PhServInd4 = rdr.GetString("PhServInd4")
        newObject.PhServInd5 = rdr.GetString("PhServInd5")
        newObject.PhServInd6 = rdr.GetString("PhServInd6")
        newObject.PhServInd7 = rdr.GetString("PhServInd7")
        newObject.PhServInd8 = rdr.GetString("PhServInd8")
        newObject.PhServInd9 = rdr.GetString("PhServInd9")
        newObject.PhServInd10 = rdr.GetString("PhServInd10")
        newObject.PhServInd11 = rdr.GetString("PhServInd11")
        newObject.PhServInd12 = rdr.GetString("PhServInd12")
        newObject.Province = rdr.GetString("Province")
        newObject.PostalCode = rdr.GetString("PostalCode")
        newObject.EndPopulate()

        Return newObject

    End Function
	
    Private Function PopulateVendorPhoneFile_SurveyIDLithoPair(ByVal rdr As SafeDataReader) As VendorPhoneFile_Data

        Dim newObject As VendorPhoneFile_Data = VendorPhoneFile_Data.NewVendorPhoneFile_Data
        Dim privateInterface As IVendorPhoneFile_Data = newObject

        newObject.BeginPopulate()
        newObject.Litho = rdr.GetString("Litho")
        newObject.SurveyId = rdr.GetInteger("Survey_ID")
        newObject.EndPopulate()

        Return newObject

    End Function
    Public Overrides Function SelectVendorPhoneFile_Data(ByVal vendorFile_DataId As Integer) As VendorPhoneFile_Data

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectVendorPhoneFile_Data, vendorFile_DataId)
        Using rdr As New SafeDataReader(QualiSysDatabaseHelper.ExecuteReader(cmd))
            If Not rdr.Read Then
                Return Nothing
            Else
                Return PopulateVendorPhoneFile_Data(rdr)
            End If
        End Using

    End Function

    Public Overrides Function SelectAllVendorPhoneFile_Datas() As VendorPhoneFile_DataCollection

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectAllVendorPhoneFile_Datas)
        Using rdr As New SafeDataReader(QualiSysDatabaseHelper.ExecuteReader(cmd))
            Return QualiSysDatabaseHelper.PopulateCollection(Of VendorPhoneFile_DataCollection, VendorPhoneFile_Data)(rdr, AddressOf PopulateVendorPhoneFile_Data)
        End Using

    End Function

    Public Overrides Function SelectVendorPhoneFile_DatasByVendorFileId(ByVal vendorFileId As Integer) As VendorPhoneFile_DataCollection

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectVendorPhoneFile_DatasByVendorFileId, vendorFileId)
        Using rdr As New SafeDataReader(QualiSysDatabaseHelper.ExecuteReader(cmd))
            Return QualiSysDatabaseHelper.PopulateCollection(Of VendorPhoneFile_DataCollection, VendorPhoneFile_Data)(rdr, AddressOf PopulateVendorPhoneFile_Data)
        End Using

    End Function

    Public Overrides Function GeneratePhoneVendorCancelFile(ByVal vendorFileId As Integer) As VendorPhoneFile_DataCollection

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.PhoneVendorCancelList, vendorFileId)
        Using rdr As New SafeDataReader(QualiSysDatabaseHelper.ExecuteReader(cmd))
            Return QualiSysDatabaseHelper.PopulateCollection(Of VendorPhoneFile_DataCollection, VendorPhoneFile_Data)(rdr, AddressOf PopulateVendorPhoneFile_SurveyIDLithoPair)
        End Using

    End Function

    Public Overrides Function InsertVendorPhoneFile_Data(ByVal instance As VendorPhoneFile_Data) As Integer

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.InsertVendorPhoneFile_Data, instance.VendorFileId, instance.HCAHPSSamp, instance.Litho, instance.SurveyId, instance.SamplesetId, instance.Phone, instance.AltPhone, instance.FName, instance.LName, instance.Addr, instance.Addr2, instance.City, instance.St, instance.Zip5, SafeDataReader.ToDBValue(instance.PhServDate), instance.LangID, instance.Telematch, instance.PhFacName, instance.PhServInd1, instance.PhServInd2, instance.PhServInd3, instance.PhServInd4, instance.PhServInd5, instance.PhServInd6, instance.PhServInd7, instance.PhServInd8, instance.PhServInd9, instance.PhServInd10, instance.PhServInd11, instance.PhServInd12, instance.Province, instance.PostalCode)
        Return QualiSysDatabaseHelper.ExecuteInteger(cmd)

    End Function

    Public Overrides Sub UpdateVendorPhoneFile_Data(ByVal instance As VendorPhoneFile_Data)

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.UpdateVendorPhoneFile_Data, instance.VendorFile_DataId, instance.VendorFileId, instance.HCAHPSSamp, instance.Litho, instance.SurveyId, instance.SamplesetId, instance.Phone, instance.AltPhone, instance.FName, instance.LName, instance.Addr, instance.Addr2, instance.City, instance.St, instance.Zip5, SafeDataReader.ToDBValue(instance.PhServDate), instance.LangID, instance.Telematch, instance.PhFacName, instance.PhServInd1, instance.PhServInd2, instance.PhServInd3, instance.PhServInd4, instance.PhServInd5, instance.PhServInd6, instance.PhServInd7, instance.PhServInd8, instance.PhServInd9, instance.PhServInd10, instance.PhServInd11, instance.PhServInd12, instance.Province, instance.PostalCode)
        QualiSysDatabaseHelper.ExecuteNonQuery(cmd)

    End Sub

    Public Overrides Sub MarkPhoneVendorCancelFileSent(ByVal Vendor_id As Integer)

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.PhoneVendorListSent, Vendor_id)
        QualiSysDatabaseHelper.ExecuteNonQuery(cmd)

    End Sub

    Public Overrides Sub DeleteVendorPhoneFile_Data(ByVal instance As VendorPhoneFile_Data)

        If instance IsNot Nothing Then
            Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.DeleteVendorPhoneFile_Data, instance.VendorFile_DataId)
            QualiSysDatabaseHelper.ExecuteNonQuery(cmd)
        End If

    End Sub

#End Region

End Class
