Imports Nrc.QualiSys.Library
Imports Nrc.QualiSys.Scanning.Library
Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports System.Data.Common
Imports NRC.Framework.Data

Friend Class VendorFileNavigatorTreeProvider
    Inherits QualiSys.Scanning.Library.VendorFileNavigatorTreeProvider

    Private ReadOnly Property Db() As Database
        Get
            Return QualiSysDatabaseHelper.Db
        End Get
    End Property

#Region " VendorFileNavigatorTree Procs "

    Private Function PopulateVendorFileNavigatorTree(ByVal rdr As SafeDataReader) As VendorFileNavigatorTree

        Dim newObject As VendorFileNavigatorTree = VendorFileNavigatorTree.NewVendorFileNavigatorTree
        Dim privateInterface As IVendorFileNavigatorTree = newObject

        newObject.BeginPopulate()
        privateInterface.VendorFileID = rdr.GetInteger("VendorFile_ID")
        newObject.ClientName = rdr.GetString("strClient_Nm")
        newObject.ClientID = rdr.GetInteger("Client_ID")
        newObject.StudyName = rdr.GetString("strStudy_Nm")
        newObject.StudyID = rdr.GetInteger("Study_ID")
        newObject.SurveyName = rdr.GetString("strSurvey_Nm")
        newObject.SurveyID = rdr.GetInteger("Survey_ID")
        newObject.SampleSetID = rdr.GetInteger("SampleSet_ID")
        newObject.MailingStepMethodName = rdr.GetString("MailingStepMethod_Nm")
        newObject.MailingStepMethodID = rdr.GetEnum(Of MailingStepMethodCodes)("MailingStepMethod_ID")
        newObject.VendorFileStatusName = rdr.GetString("VendorFileStatus_Nm")
        newObject.VendorFileStatusID = rdr.GetEnum(Of VendorFileStatusCodes)("VendorFileStatus_ID")
        newObject.DisplayName = rdr.GetString("Name")
        newObject.ShowInTree = rdr.GetBoolean("ShowInTree")
        newObject.ErrorDesc = rdr.GetString("ErrorDesc")
        newObject.VendorID = rdr.GetNullableInteger("Vendor_ID")
        newObject.DateFileCreated = rdr.GetNullableDate("DateFileCreated")
        newObject.TelematchLog_datSent = rdr.GetNullableDate("TelematchLog_datSent")
        newObject.TelematchLog_datReturned = rdr.GetNullableDate("TelematchLog_datReturned")
        newObject.EndPopulate()

        Return newObject

    End Function

#End Region

    Public Overrides Function SelectVendorFileNavigatorTreeByDateRange(ByVal statusID As Integer, ByVal startDate As Date) As VendorFileNavigatorTreeCollection

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectVendorFileNavigatorTreeByDateRange, statusID, startDate, Convert.DBNull)
        Using rdr As New SafeDataReader(QualiSysDatabaseHelper.ExecuteReader(cmd))
            Return QualiSysDatabaseHelper.PopulateCollection(Of VendorFileNavigatorTreeCollection, VendorFileNavigatorTree)(rdr, AddressOf PopulateVendorFileNavigatorTree)
        End Using

    End Function

End Class
