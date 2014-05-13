'********************************************************************************
' Concrete SqlProvider Class
'********************************************************************************
Imports Nrc.Framework.Data
Imports Nrc.Framework.BusinessLogic
Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports System.Data.Common
Imports NRC.Qualisys.QLoader.Library

Friend Class UploadFileHistoryProvider
    Inherits NRC.DataLoader.Library.UploadFileHistoryProvider

    Private ReadOnly Property Db() As Database
        Get
            Return DatabaseHelper.Db
        End Get
    End Property

#Region " SP Declarations "
    Private NotInheritable Class SP
        Private Sub New()
        End Sub
        
        Public Const SelectUploadFilesByGroupId As String = "dbo.LD_SelectUploadFilesByGroupID"
        Public Const SelectUploadFile As String = "dbo.LD_SelectUploadFile"
        
    End Class
#End Region

#Region " UploadFile Procs "

    Private Function PopulateUploadFileHistory(ByVal rdr As SafeDataReader) As UploadFileHistory
        Dim newObject As UploadFileHistory = UploadFileHistory.NewUploadFileHistory
        Dim privateInterface As IUploadFile = newObject
        newObject.BeginPopulate()
        privateInterface.Id = rdr.GetInteger("UploadFile_id")
        newObject.OrigFileName = rdr.GetString("OrigFile_Nm")
        newObject.UserNotes = rdr.GetString("UserNotes")
        newObject.MemberId = rdr.GetInteger("Member_id")
        newObject.GroupID = rdr.GetInteger("Group_id")
        newObject.datOccurred = rdr.GetDate("datOccurred")
        newObject.ProjectManager = ProjectManager.GetByMemberID(rdr.GetInteger("PM_Member_ID"))
        newObject.EndPopulate()
        Return newObject
    End Function


    Public Overrides Function SelectUploadFilesByGroupId(ByVal GroupId As Integer) As UploadFileHistoryCollection
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectUploadFilesByGroupId, GroupId)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            Return PopulateCollection(Of UploadFileHistoryCollection, UploadFileHistory)(rdr, AddressOf PopulateUploadFileHistory)
        End Using
    End Function

  
#End Region


End Class
