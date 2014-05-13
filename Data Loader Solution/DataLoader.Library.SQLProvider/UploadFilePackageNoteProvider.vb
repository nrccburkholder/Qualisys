'********************************************************************************
' Concrete SqlProvider Class
'********************************************************************************
Imports Nrc.Framework.Data
Imports Nrc.Framework.BusinessLogic
Imports Nrc.Qualisys.QLoader.Library
Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports System.Data.Common

Friend Class UploadFilePackageNoteProvider
    Inherits NRC.DataLoader.Library.UploadFilePackageNoteProvider


    Private ReadOnly Property Db() As Database
        Get
            Return DatabaseHelper.Db
        End Get
    End Property

#Region " SP Declarations "
    Private NotInheritable Class SP
        Private Sub New()
        End Sub
        Public Const UpdateUploadFilePackageNote As String = "dbo.LD_UpdateUploadFilePackageNotes"
        Public Const DeleteUploadFilePackageNote As String = "dbo.LD_DeleteUploadFilePackageNotes"
        Public Const InsertUploadFilePackageNote As String = "dbo.LD_InsertUploadFilePackageNotes"
        Public Const SelectUploadFilePackageNote As String = "dbo.LD_SelectUploadFilePackageNotes"
        Public Const SelectUploadFilePackageNotesByUploadFilePackageIDs As String = "dbo.LD_SelectUploadFilePackageNotesByUploadFilePackageIDs"

    End Class
#End Region

#Region " UploadFilePackageNote Procs "

    Private Function PopulateUploadFilePackageNote(ByVal rdr As SafeDataReader) As UploadFilePackageNote
        Dim newObject As UploadFilePackageNote = UploadFilePackageNote.NewUploadFilePackageNote
        Dim privateInterface As IUploadFilePackageNote = newObject
        newObject.BeginPopulate()
        privateInterface.NoteId = rdr.GetInteger("Note_ID")
        newObject.DateCreated = rdr.GetDate("DatCreated")
        newObject.Note = rdr.GetString("Note")
        newObject.UploadFilePackageId = rdr.GetInteger("UploadFilePackage_Id")
        newObject.Username = rdr.GetString("Username")
        newObject.EndPopulate()

        Return newObject
    End Function


#End Region

    Public Overrides Function SelectUploadFilePackageNotesByUploadFilePackageIDs(ByVal ids As String) As UploadFilePackageNoteCollection
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectUploadFilePackageNotesByUploadFilePackageIDs, ids)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            Return PopulateCollection(Of UploadFilePackageNoteCollection, UploadFilePackageNote)(rdr, AddressOf PopulateUploadFilePackageNote)
        End Using
    End Function

    Public Overrides Function SelectUploadFilePackageNote(ByVal id As Integer) As UploadFilePackageNote
        Dim cmd As DBCommand = Db.GetStoredProcCommand(SP.SelectUploadFilePackageNote, id)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            If Not rdr.Read Then
                Return Nothing
            Else
                Return PopulateUploadFilePackageNote(rdr)
            End If
        End Using
    End Function

    Public Overrides Function InsertUploadFilePackageNote(ByVal instance As UploadFilePackageNote) As Integer
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.InsertUploadFilePackageNote, instance.UploadFilePackageId, instance.DateCreated, instance.Username, instance.Note)
        Return ExecuteInteger(cmd)
    End Function

    Public Overrides Sub UpdateUploadFilePackageNote(ByVal instance As UploadFilePackageNote)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.UpdateUploadFilePackageNote, instance.NoteId, instance.UploadFilePackageId, instance.DateCreated, instance.Username, instance.Note)
        ExecuteNonQuery(cmd)
    End Sub

    Public Overrides Sub DeleteUploadFilePackageNote(ByVal uploadFilePackageNoteId As Integer)
        Dim cmd As DBCommand = Db.GetStoredProcCommand(SP.DeleteUploadFilePackageNote, uploadFilePackageNoteId)
        ExecuteNonQuery(cmd)
    End Sub





End Class
