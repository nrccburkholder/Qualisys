'********************************************************************************
' Concrete SqlProvider Class
'********************************************************************************
Imports Nrc.Framework.Data
Imports Nrc.Framework.BusinessLogic
Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports System.Data.Common

Friend Class UploadFileStateProvider
    Inherits NRC.DataLoader.Library.UploadFileStateProvider

    Private ReadOnly Property Db() As Database
        Get
            Return DatabaseHelper.Db
        End Get
    End Property

#Region " SP Declarations "
    Private NotInheritable Class SP
        Private Sub New()
        End Sub
        Public Const DeleteUploadFileState As String = "dbo.LD_DeleteUploadFileState"
        Public Const InsertUploadFileState As String = "dbo.LD_InsertUploadFileState"
        'Public Const SelectAllUploadFileStates As String = "dbo.LD_SelectAllUploadFileStates"
        Public Const SelectUploadFileState As String = "dbo.LD_SelectUploadFileState"
        Public Const SelectUploadFileStateByUploadFileID As String = "dbo.LD_SelectUploadFileStateByUploadFileID"
        Public Const UpdateUploadFileState As String = "dbo.LD_UpdateUploadFileState"
    End Class
#End Region

#Region " UploadFileState Procs "

    Private Function PopulateUploadFileState(ByVal rdr As SafeDataReader) As UploadFileState
        Dim newObject As UploadFileState = UploadFileState.NewUploadFileState
        Dim privateInterface As IUploadFileState = newObject
        newObject.BeginPopulate()
        privateInterface.Id = rdr.GetInteger("UploadFileState_id")
        newObject.UploadFileId = rdr.GetInteger("UploadFile_id")
        newObject.SetUploadStateID(rdr.GetInteger("UploadState_id"))
        newObject.datOccurred = rdr.GetDate("datOccurred")
        newObject.StateParameter = rdr.GetString("StateParameter")
        newObject.EndPopulate()

        Return newObject
    End Function
    Public Overrides Function SelectUploadFileState(ByVal id As Integer) As UploadFileState
        Dim cmd As DBCommand = Db.GetStoredProcCommand(SP.SelectUploadFileState, id)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            If Not rdr.Read Then
                Return Nothing
            Else
                Return PopulateUploadFileState(rdr)
            End If
        End Using
    End Function

    Public Overrides Function SelectUploadFileStateByUploadFileID(ByVal id As Integer) As UploadFileState
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectUploadFileStateByUploadFileID, id)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            If Not rdr.Read Then
                Return Nothing
            Else
                Return PopulateUploadFileState(rdr)
            End If
        End Using
    End Function

    'Public Overrides Function SelectAllUploadFileStates() As UploadFileStateCollection
    '    Dim cmd As DBCommand = Db.GetStoredProcCommand(SP.SelectAllUploadFileStates)
    '    Using rdr As New SafeDataReader(ExecuteReader(cmd))
    '        Return PopulateCollection(Of UploadFileStateCollection, UploadFileState)(rdr, AddressOf PopulateUploadFileState)
    '    End Using
    'End Function

    Public Overrides Function InsertUploadFileState(ByVal instance As UploadFileState) As Integer
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.InsertUploadFileState, instance.UploadFileId, instance.StateOfUpload.UploadStateId, SafeDataReader.ToDBValue(instance.datOccurred), instance.StateParameter)
        Return ExecuteInteger(cmd)
    End Function

    Public Overrides Sub UpdateUploadFileState(ByVal instance As UploadFileState)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.UpdateUploadFileState, instance.Id, instance.UploadFileId, instance.StateOfUpload.UploadStateId, SafeDataReader.ToDBValue(instance.datOccurred), instance.StateParameter)
        ExecuteNonQuery(cmd)
        'DeleteUploadFileState(instance.Id)
        'InsertUploadFileState(instance)
    End Sub

    Public Overrides Sub DeleteUploadFileState(ByVal id As Integer)
        Dim cmd As DBCommand = Db.GetStoredProcCommand(SP.DeleteUploadFileState, id)
        ExecuteNonQuery(cmd)
    End Sub

#End Region


End Class
