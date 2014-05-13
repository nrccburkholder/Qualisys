'********************************************************************************
' Concrete SqlProvider Class
'********************************************************************************
Imports Nrc.Framework.Data
Imports Nrc.Framework.BusinessLogic
Imports Nrc.Qualisys.QLoader.Library
Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports System.Data.Common

Friend Class UploadFilePackageProvider
    Inherits NRC.DataLoader.Library.UploadFilePackageProvider


    Private ReadOnly Property Db() As Database
        Get
            Return DatabaseHelper.Db
        End Get
    End Property

#Region " SP Declarations "
    Private NotInheritable Class SP
        Private Sub New()
        End Sub
        Public Const DeleteUploadFilePackage As String = "dbo.LD_DeleteUploadFilePackage"
        Public Const InsertUploadFilePackage As String = "dbo.LD_InsertUploadFilePackage"
        Public Const SelectUploadFilePackage As String = "dbo.LD_SelectUploadFilePackage"
        Public Const SelectAllUploadFilePackagesByUploadFile As String = "dbo.LD_SelectUploadFilePackagesByUploadFileID"
        Public Const DeleteByUploadFile As String = "dbo.LD_DeleteByUploadFile"
    End Class
#End Region

#Region " UploadFilePackage Procs "

    Private Function PopulateUploadFilePackage(ByVal rdr As SafeDataReader) As UploadFilePackage
        Dim newObject As UploadFilePackage = UploadFilePackage.NewUploadFilePackage
        Dim privateInterface As IUploadFilePackage = newObject
        newObject.BeginPopulate()
        privateInterface.Id = rdr.GetInteger("UploadFilePackage_ID")
        newObject.UploadFileId = rdr.GetInteger("UploadFile_id")
        newObject.SetPackageID(rdr.GetInteger("Package_id")) 'for lazy population
        newObject.EndPopulate()

        Return newObject
    End Function

    'Public Overrides Function SelectUploadFilePackage(ByVal id As Integer) As UploadFilePackage
    '    Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectUploadFilePackage, id)
    '    Using rdr As New SafeDataReader(ExecuteReader(cmd))
    '        If Not rdr.Read Then
    '            Return Nothing
    '        Else
    '            Return PopulateUploadFilePackage(rdr)
    '        End If
    '    End Using
    'End Function

    Public Overrides Function SelectUploadFilePackagesByUploadFile(ByVal UploadFile As UploadFile) As UploadFilePackageCollection
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectAllUploadFilePackagesByUploadFile, UploadFile.Id)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            Return PopulateCollection(Of UploadFilePackageCollection, UploadFilePackage)(rdr, AddressOf PopulateUploadFilePackage)
        End Using
    End Function

    Public Overrides Function InsertUploadFilePackage(ByVal instance As UploadFilePackage) As Integer
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.InsertUploadFilePackage, instance.UploadFileId, instance.Package.PackageID)
        Return ExecuteInteger(cmd)
    End Function

    Public Overrides Sub UpdateUploadFilePackage(ByVal instance As UploadFilePackage)
        DeleteByUploadFile(instance.UploadFileId)
        InsertUploadFilePackage(instance)
    End Sub

    Public Overrides Sub DeleteUploadFilePackage(ByVal id As Integer)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.DeleteUploadFilePackage, id)
        ExecuteNonQuery(cmd)
    End Sub

#End Region


    Public Overrides Sub DeleteByUploadFile(ByVal uploadFileID As Integer)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.DeleteUploadFilePackage, uploadFileID)
        ExecuteNonQuery(cmd)
    End Sub
End Class
