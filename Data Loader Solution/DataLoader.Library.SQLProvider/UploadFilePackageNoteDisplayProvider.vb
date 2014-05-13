'********************************************************************************
' Concrete SqlProvider Class
'********************************************************************************
Imports Nrc.Framework.Data
Imports Nrc.Framework.BusinessLogic
Imports Nrc.Qualisys.QLoader.Library
Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports System.Data.Common

Friend Class UploadFilePackageNoteDisplayProvider
    Inherits NRC.DataLoader.Library.UploadFilePackageNoteDisplayProvider


    Private ReadOnly Property Db() As Database
        Get
            Return DatabaseHelper.Db
        End Get
    End Property

#Region " SP Declarations "
    Private NotInheritable Class SP
        Private Sub New()
        End Sub
       
        Public Const SelectUploadFilePackageNotesByUploadFilePackageIDs As String = "dbo.LD_SelectUploadFilePackageNotesByUploadFilePackageIDs"

    End Class
#End Region

#Region " UploadFilePackageNote Procs "

    Private Function PopulateUploadFilePackageNoteDisplay(ByVal rdr As SafeDataReader) As UploadFilePackageNoteDisplay
        Dim newObject As UploadFilePackageNoteDisplay = UploadFilePackageNoteDisplay.NewUploadFilePackageNoteDisplay
        Dim privateInterface As IUploadFilePackageNoteDisplay = newObject
        newObject.BeginPopulate()
        privateInterface.NoteId = rdr.GetInteger("Note_ID")
        newObject.DateCreated = rdr.GetDate("DatCreated")
        newObject.Note = rdr.GetString("Note")
        newObject.UploadFilePackageId = rdr.GetInteger("UploadFilePackage_Id")
        newObject.Username = rdr.GetString("Username")
        newObject.UploadFileId = rdr.GetInteger("uploadfile_id")
        newObject.PackageId = rdr.GetInteger("package_id")
        newObject.EndPopulate()
        Return newObject
    End Function


#End Region

    Public Overrides Function SelectUploadFilePackageNotesByUploadFilePackageIDs(ByVal ids As String) As UploadFilePackageNoteDisplayCollection
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectUploadFilePackageNotesByUploadFilePackageIDs, ids)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            Return PopulateCollection(Of UploadFilePackageNoteDisplayCollection, UploadFilePackageNoteDisplay)(rdr, AddressOf PopulateUploadFilePackageNoteDisplay)
        End Using
    End Function

  





End Class
