'********************************************************************************
' Concrete SqlProvider Class
'********************************************************************************
Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports System.Data.Common
Imports NRC.Framework.Data


Friend Class VendorFile_VoviciDetailProvider
	Inherits QualiSys.Library.VendorFile_VoviciDetailProvider

    Private ReadOnly Property Db() As Database
        Get
            Return Globals.Db
        End Get
    End Property

	
#Region " VendorFile_VoviciDetail Procs "

	Private Function PopulateVendorFile_VoviciDetail(ByVal rdr As SafeDataReader) As VendorFile_VoviciDetail
		Dim newObject As VendorFile_VoviciDetail = VendorFile_VoviciDetail.NewVendorFile_VoviciDetail
		Dim privateInterface As IVendorFile_VoviciDetail = newObject
		newObject.BeginPopulate()
		privateInterface.VendorFile_VoviciDetailId = rdr.GetInteger("VendorFile_VoviciDetail_ID")
		newObject.SurveyId = rdr.GetInteger("Survey_ID")
		newObject.MailingStepId = rdr.GetInteger("MailingStep_ID")
		newObject.VoviciSurveyId = rdr.GetInteger("VoviciSurvey_ID")
		newObject.VoviciSurveyName = rdr.GetString("VoviciSurvey_nm")
		newObject.EndPopulate()
		
		Return newObject
	End Function
	
	Public Overrides Function SelectVendorFile_VoviciDetail(ByVal vendorFile_VoviciDetailId As Integer) As VendorFile_VoviciDetail
		Dim cmd As DBCommand = Db.GetStoredProcCommand(SP.SelectVendorFile_VoviciDetail, vendorFile_VoviciDetailId)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))		
			If Not rdr.Read Then
				Return Nothing
			Else
				Return PopulateVendorFile_VoviciDetail(rdr)
			End If
		End Using
	End Function

	Public Overrides Function SelectAllVendorFile_VoviciDetails() As VendorFile_VoviciDetailCollection
		Dim cmd As DBCommand = Db.GetStoredProcCommand(SP.SelectAllVendorFile_VoviciDetails)
		Using rdr As New SafeDataReader(ExecuteReader(cmd))
			Return PopulateCollection(Of VendorFile_VoviciDetailCollection, VendorFile_VoviciDetail)(rdr, AddressOf PopulateVendorFile_VoviciDetail)
		End Using
	End Function

	Public Overrides Function SelectVendorFile_VoviciDetailsBySurveyId(ByVal surveyId As Integer) As VendorFile_VoviciDetailCollection
		Dim cmd As DBCommand = Db.GetStoredProcCommand(SP.SelectVendorFile_VoviciDetailsBySurveyId, surveyId)
		Using rdr As New SafeDataReader(ExecuteReader(cmd))
			Return PopulateCollection(Of VendorFile_VoviciDetailCollection, VendorFile_VoviciDetail)(rdr, AddressOf PopulateVendorFile_VoviciDetail)
		End Using
	End Function

	Public Overrides Function SelectVendorFile_VoviciDetailsByMailingStepId(ByVal mailingStepId As Integer) As VendorFile_VoviciDetailCollection
		Dim cmd As DBCommand = Db.GetStoredProcCommand(SP.SelectVendorFile_VoviciDetailsByMailingStepId, mailingStepId)
		Using rdr As New SafeDataReader(ExecuteReader(cmd))
			Return PopulateCollection(Of VendorFile_VoviciDetailCollection, VendorFile_VoviciDetail)(rdr, AddressOf PopulateVendorFile_VoviciDetail)
		End Using
	End Function

	Public Overrides Function InsertVendorFile_VoviciDetail(ByVal instance As VendorFile_VoviciDetail) As Integer
		Dim cmd As DBCommand = Db.GetStoredProcCommand(SP.InsertVendorFile_VoviciDetail, instance.SurveyId, instance.MailingStepId, instance.VoviciSurveyId, instance.VoviciSurveyName)
		Return ExecuteInteger(cmd)
	End Function

	Public Overrides Sub UpdateVendorFile_VoviciDetail(ByVal instance As VendorFile_VoviciDetail)
		Dim cmd As DBCommand = Db.GetStoredProcCommand(SP.UpdateVendorFile_VoviciDetail, instance.VendorFile_VoviciDetailId, instance.SurveyId, instance.MailingStepId, instance.VoviciSurveyId, instance.VoviciSurveyName)
		ExecuteNonQuery(cmd)
	End Sub

	Public Overrides Sub DeleteVendorFile_VoviciDetail(ByVal instance As VendorFile_VoviciDetail)
        If instance IsNot Nothing Then
            Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.DeleteVendorFile_VoviciDetail, instance.VendorFile_VoviciDetailId)
            ExecuteNonQuery(cmd)
        End If
	End Sub

#End Region


End Class
