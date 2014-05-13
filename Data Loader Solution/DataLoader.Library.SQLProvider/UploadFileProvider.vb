'********************************************************************************
' Concrete SqlProvider Class
'********************************************************************************
Imports Nrc.Framework.Data
Imports Nrc.Framework.BusinessLogic
Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports System.Data.Common
Imports NRC.Qualisys.QLoader.Library

Friend Class UploadFileProvider
    Inherits NRC.DataLoader.Library.UploadFileProvider

    Private ReadOnly Property Db() As Database
        Get
            Return DatabaseHelper.Db
        End Get
    End Property

#Region " SP Declarations "
    Private NotInheritable Class SP
        Private Sub New()
        End Sub
        Public Const DeleteUploadFile As String = "dbo.LD_DeleteUploadFile"
        Public Const InsertUploadFile As String = "dbo.LD_InsertUploadFile"
        Public Const SelectAllUploadFiles As String = "dbo.LD_SelectAllUploadFiles"
        Public Const SelectUploadFile As String = "dbo.LD_SelectUploadFile"
        Public Const UpdateUploadFile As String = "dbo.LD_UpdateUploadFile"
        Public Const CanRestoreAbandonedFile As String = "dbo.LD_FileCanBeRestored"
    End Class
#End Region

#Region " UploadFile Procs "

    Private Function PopulateUploadFile(ByVal rdr As SafeDataReader) As UploadFile
        Dim newObject As UploadFile = UploadFile.NewUploadFile
        Dim privateInterface As IUploadFile = newObject
        newObject.BeginPopulate()
        privateInterface.Id = rdr.GetInteger("UploadFile_id")
        newObject.OrigFileName = rdr.GetString("OrigFile_Nm")
        newObject.FileName = rdr.GetString("File_Nm")
        newObject.FileSize = rdr.GetInteger("FileSize")
        newObject.SetUploadActionID(rdr.GetInteger("UploadAction_id"))
        newObject.UserNotes = rdr.GetString("UserNotes")
        newObject.MemberId = rdr.GetInteger("Member_id")
        newObject.GroupID = rdr.GetInteger("Group_id")
        newObject.ProjectManager = ProjectManager.GetByMemberID(rdr.GetInteger("PM_Member_ID"))
        newObject.EndPopulate()
        Return newObject
    End Function

    Public Overrides Function SelectUploadFile(ByVal id As Integer) As UploadFile
        Dim cmd As DBCommand = Db.GetStoredProcCommand(SP.SelectUploadFile, id)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            If Not rdr.Read Then
                Return Nothing
            Else
                Return PopulateUploadFile(rdr)
            End If
        End Using
    End Function

    Public Overrides Function SelectAllUploadFiles() As UploadFileCollection
        Dim cmd As DBCommand = Db.GetStoredProcCommand(SP.SelectAllUploadFiles)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            Return PopulateCollection(Of UploadFileCollection, UploadFile)(rdr, AddressOf PopulateUploadFile)
        End Using
    End Function

    Public Overrides Function InsertUploadFile(ByVal instance As UploadFile) As Integer

        'This returned object not set to instance of an object
        'Dim PMMemberID As Object = IIf(instance.ProjectManager Is Nothing, DBNull.Value, instance.ProjectManager.MemberID)

        Dim PMMemberID As Object
        If instance.ProjectManager Is Nothing Then
            PMMemberID = DBNull.Value
        Else
            PMMemberID = instance.ProjectManager.MemberID
        End If

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.InsertUploadFile, instance.OrigFileName, instance.FileName, instance.FileSize, instance.UploadAction.UploadActionId, instance.UserNotes, instance.MemberId, instance.GroupID, PMMemberID)
        Return ExecuteInteger(cmd)
    End Function

    Public Overrides Sub UpdateUploadFile(ByVal instance As UploadFile)

        'This returned object not set to instance of an object
        'Dim PMMemberID As Object = IIf(instance.ProjectManager Is Nothing, DBNull.Value, instance.ProjectManager.MemberID)

        Dim PMMemberID As Object
        If instance.ProjectManager Is Nothing Then
            PMMemberID = DBNull.Value
        Else
            PMMemberID = instance.ProjectManager.MemberID
        End If

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.UpdateUploadFile, instance.Id, instance.OrigFileName, instance.FileName, instance.FileSize, instance.UploadAction.UploadActionId, instance.UserNotes, instance.MemberId, instance.GroupID, PMMemberID)
        ExecuteNonQuery(cmd)
    End Sub

    Public Overrides Sub DeleteUploadFile(ByVal id As Integer)
        Dim cmd As DBCommand = Db.GetStoredProcCommand(SP.DeleteUploadFile, id)
        ExecuteNonQuery(cmd)
    End Sub
    Public Overrides Function CanRestoreUbandonedFile(ByVal id As Integer) As UploadFile.RestoreRequestReturned
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.CanRestoreAbandonedFile, id)
        Return ExecuteInteger(cmd)
    End Function

#End Region


End Class
