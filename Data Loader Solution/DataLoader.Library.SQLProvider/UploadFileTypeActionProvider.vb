'********************************************************************************
' Concrete SqlProvider Class
'********************************************************************************
Imports Nrc.Framework.Data
Imports Nrc.Framework.BusinessLogic
Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports System.Data.Common

Friend Class UploadFileTypeActionProvider
    Inherits DataLoader.Library.UploadFileTypeActionProvider

    Private ReadOnly Property Db() As Database
        Get
            Return DatabaseHelper.Db
        End Get
    End Property

#Region " SP Declarations "
    Private NotInheritable Class SP
        Private Sub New()
        End Sub
        Public Const DeleteUploadFileTypeAction As String = "dbo.LD_DeleteUploadFileTypeAction"
        Public Const InsertUploadFileTypeAction As String = "dbo.LD_InsertUploadFileTypeAction"
        Public Const SelectAllUploadFileTypeActions As String = "dbo.LD_SelectAllUploadFileTypeActions"
        Public Const SelectUploadFileTypeAction As String = "dbo.LD_SelectUploadFileTypeAction"
        Public Const UpdateUploadFileTypeAction As String = "dbo.LD_UpdateUploadFileTypeAction"
        Public Const SelectUploadFileTypeActionByName As String = "dbo.LD_SelectUploadFileTypeActionByName"
    End Class
#End Region

#Region " UploadFileTypeAction Procs "

    Private Function PopulateUploadFileTypeAction(ByVal rdr As SafeDataReader) As UploadFileTypeAction
        Dim newObject As UploadFileTypeAction = UploadFileTypeAction.NewUploadFileTypeAction
        Dim privateInterface As IUploadFileTypeAction = newObject
        newObject.BeginPopulate()
        privateInterface.Id = rdr.GetInteger("UploadFileTypeAction_id")
        newObject.Name = rdr.GetString("UploadFileTypeAction_Nm")
        newObject.EndPopulate()

        Return newObject
    End Function

    Public Overrides Function SelectUploadFileTypeAction(ByVal id As Integer) As UploadFileTypeAction
        Dim cmd As DBCommand = Db.GetStoredProcCommand(SP.SelectUploadFileTypeAction, id)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            If Not rdr.Read Then
                Return Nothing
            Else
                Return PopulateUploadFileTypeAction(rdr)
            End If
        End Using
    End Function
    Public Overrides Function SelectUploadFileTypeActionByName(ByVal name As String) As UploadFileTypeAction
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectUploadFileTypeActionByName, name)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            If Not rdr.Read Then
                Return Nothing
            Else
                Return PopulateUploadFileTypeAction(rdr)
            End If
        End Using
    End Function

    Public Overrides Function SelectAllUploadFileTypeActions() As UploadFileTypeActionCollection
        Dim cmd As DBCommand = Db.GetStoredProcCommand(SP.SelectAllUploadFileTypeActions)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            Return PopulateCollection(Of UploadFileTypeActionCollection, UploadFileTypeAction)(rdr, AddressOf PopulateUploadFileTypeAction)
        End Using
    End Function

    Public Overrides Function InsertUploadFileTypeAction(ByVal instance As UploadFileTypeAction) As Integer
        Dim cmd As DBCommand = Db.GetStoredProcCommand(SP.InsertUploadFileTypeAction, instance.Name)
        Return ExecuteInteger(cmd)
    End Function

    Public Overrides Sub UpdateUploadFileTypeAction(ByVal instance As UploadFileTypeAction)
        Dim cmd As DBCommand = Db.GetStoredProcCommand(SP.UpdateUploadFileTypeAction, instance.Id, instance.Name)
        ExecuteNonQuery(cmd)
    End Sub

    Public Overrides Sub DeleteUploadFileTypeAction(ByVal id As Integer)
        Dim cmd As DBCommand = Db.GetStoredProcCommand(SP.DeleteUploadFileTypeAction, id)
        ExecuteNonQuery(cmd)
    End Sub

#End Region


End Class
