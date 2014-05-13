'********************************************************************************
' Concrete SqlProvider Class
'********************************************************************************
Imports Nrc.Framework.Data
Imports Nrc.Framework.BusinessLogic
Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports System.Data.Common
Imports Nrc.DataLoader.Library

Friend Class UploadActionsProvider
    Inherits NRC.DataLoader.Library.UploadActionsProvider

    Private ReadOnly Property Db() As Database
        Get
            Return DatabaseHelper.Db
        End Get
    End Property

#Region " SP Declarations "
    Private NotInheritable Class SP
        Private Sub New()
        End Sub
        'Public Const DeleteUploadAction As String = "dbo.DeleteUploadAction"
        'Public Const InsertUploadAction As String = "dbo.InsertUploadAction"
        'Public Const UpdateUploadAction As String = "dbo.UpdateUploadAction"
        Public Const SelectAllUploadActions As String = "dbo.LD_SelectAllUploadActions"
        Public Const SelectUploadAction As String = "dbo.LD_SelectUploadAction"
    End Class
#End Region

#Region " UploadAction Procs "

    Private Function PopulateUploadAction(ByVal rdr As SafeDataReader) As UploadAction
        Dim newObject As UploadAction = UploadAction.NewUploadAction
        Dim privateInterface As IUploadAction = newObject
        newObject.BeginPopulate()
        privateInterface.Id = rdr.GetInteger("UploadAction_id")
        newObject.UploadActionName = rdr.GetString("UploadAction_Nm")
        newObject.FolderName = rdr.GetString("Folder_Nm")
        newObject.UploadFileTypeAction = UploadFileTypeAction.Get(rdr.GetInteger("UploadFileTypeAction_id"))
        newObject.EndPopulate()

        Return newObject
    End Function

    Public Overrides Function SelectUploadAction(ByVal uploadActionId As Integer) As UploadAction
        Dim cmd As DBCommand = Db.GetStoredProcCommand(SP.SelectUploadAction, uploadActionId)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            If Not rdr.Read Then
                Return Nothing
            Else
                Return PopulateUploadAction(rdr)
            End If
        End Using
    End Function

    Public Overrides Function SelectAllUploadActions() As UploadActionCollection
        Dim cmd As DBCommand = Db.GetStoredProcCommand(SP.SelectAllUploadActions)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            Return PopulateCollection(Of UploadActionCollection, UploadAction)(rdr, AddressOf PopulateUploadAction)
        End Using
    End Function

    'Public Overrides Function InsertUploadAction(ByVal instance As UploadAction) As Integer
    '    Dim cmd As DBCommand = Db.GetStoredProcCommand(SP.InsertUploadAction, instance.UploadActionName)
    '    Return ExecuteInteger(cmd)
    'End Function

    'Public Overrides Sub UpdateUploadAction(ByVal instance As UploadAction)
    '    Dim cmd As DBCommand = Db.GetStoredProcCommand(SP.UpdateUploadAction, instance.UploadActionId, instance.UploadActionName)
    '    ExecuteNonQuery(cmd)
    'End Sub

    'Public Overrides Sub DeleteUploadAction(ByVal uploadActionId As Integer)
    '    Dim cmd As DBCommand = Db.GetStoredProcCommand(SP.DeleteUploadAction, uploadActionId)
    '    ExecuteNonQuery(cmd)
    'End Sub

#End Region


End Class
