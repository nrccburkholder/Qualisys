'********************************************************************************
' Concrete SqlProvider Class
'********************************************************************************
Imports Nrc.Framework.Data
Imports Nrc.Framework.BusinessLogic
Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports System.Data.Common

Friend Class UploadFilePackageDisplayProvider
    Inherits NRC.DataLoader.Library.UploadFilePackageDisplayProvider

    Private ReadOnly Property Db() As Database
        Get
            Return DatabaseHelper.Db
        End Get
    End Property

#Region " SP Declarations "
    Private NotInheritable Class SP
        Private Sub New()
        End Sub
        Public Const SelectAllUploadFilePackageDisplaies As String = "dbo.LD_SelectUploadFilesByStudyIDs"
    End Class
#End Region

#Region " UploadFilePackageDisplay Procs "

    Private Function PopulateUploadFilePackageDisplay(ByVal rdr As SafeDataReader) As UploadFilePackageDisplay
        Dim newObject As UploadFilePackageDisplay = UploadFilePackageDisplay.NewUploadFilePackageDisplay
        newObject.BeginPopulate()
        newObject.uploadfileId = rdr.GetInteger("uploadfile_id")
        newObject.fileName = rdr.GetString("file_nm")
        newObject.packageId = rdr.GetInteger("package_id")
        newObject.UploadFilePackageID = rdr.GetInteger("UploadFilePackage_ID")
        newObject.packageName = rdr.GetString("strpackage_nm")
        newObject.uploadstateName = rdr.GetString("uploadstate_nm")
        newObject.studyId = rdr.GetInteger("study_id")
        newObject.[Date] = rdr.GetDate("datOccurred")
        newObject.EndPopulate()

        Return newObject
    End Function


    Public Overrides Function GetByStudiesAndDateRange(ByVal StudyList As String, ByVal StartDate As Date, ByVal EndDate As Date) As UploadFilePackageDisplayCollection
        'this way if EndDate is #08/20/2008# then #08/20/2008 23:59:59# will still be <= EndDate
        Dim tmpEndDate As Date = EndDate.Date.AddDays(1).AddMilliseconds(-1)
        Dim tmpStartDate As Date = StartDate.Date

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectAllUploadFilePackageDisplaies, StudyList, tmpStartDate, tmpEndDate)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            Return PopulateCollection(Of UploadFilePackageDisplayCollection, UploadFilePackageDisplay)(rdr, AddressOf PopulateUploadFilePackageDisplay)
        End Using
    End Function

#End Region


End Class