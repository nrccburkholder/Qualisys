Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports System.Data.Common
Imports NRC.Framework.Data


Friend Class DataFileStateProvider
	Inherits QualiSys.Pervasive.Library.DataFileStateProvider

    Private ReadOnly Property Db() As Database
        Get
            Return DatabaseHelper.Db
        End Get
    End Property

	
#Region " DataFileState Procs "

    Private Function PopulateDataFileState(ByVal rdr As SafeDataReader) As DataFileState

        Dim newObject As DataFileState = DataFileState.NewDataFileState
        Dim privateInterface As IDataFileState = newObject
        newObject.BeginPopulate()
        privateInterface.Id = rdr.GetInteger("DataFileState_id")
        newObject.DataFileId = rdr.GetInteger("DataFile_id")
        newObject.StateId = rdr.GetInteger("State_ID")
        newObject.datOccurred = rdr.GetDate("datOccurred")
        newObject.StateParameter = rdr.GetString("StateParameter")
        newObject.EndPopulate()

        Return newObject

    End Function
	
    Public Overrides Function SelectDataFileState(ByVal id As Integer) As DataFileState

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectDataFileState, id)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            If Not rdr.Read Then
                Return Nothing
            Else
                Return PopulateDataFileState(rdr)
            End If
        End Using

    End Function

    Public Overrides Function SelectAllDataFileStates() As DataFileStateCollection

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectAllDataFileStates)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            Return PopulateCollection(Of DataFileStateCollection, DataFileState)(rdr, AddressOf PopulateDataFileState)
        End Using

    End Function

    Public Overrides Function SelectDataFileStatesByDataFileId(ByVal dataFileId As Integer) As DataFileStateCollection

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectDataFileStatesByDataFileId, dataFileId)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            Return PopulateCollection(Of DataFileStateCollection, DataFileState)(rdr, AddressOf PopulateDataFileState)
        End Using

    End Function

    Public Overrides Function SelectDataFileStatesByStateId(ByVal stateId As Integer) As DataFileStateCollection

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectDataFileStatesByStateId, stateId)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            Return PopulateCollection(Of DataFileStateCollection, DataFileState)(rdr, AddressOf PopulateDataFileState)
        End Using

    End Function

    Public Overrides Function InsertDataFileState(ByVal instance As DataFileState) As Integer

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.InsertDataFileState, instance.DataFileId, instance.StateId, SafeDataReader.ToDBValue(instance.datOccurred), instance.StateParameter)
        Return ExecuteInteger(cmd)

    End Function

    Public Overrides Sub UpdateDataFileState(ByVal instance As DataFileState)

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.UpdateDataFileState, instance.Id, instance.DataFileId, instance.StateId, SafeDataReader.ToDBValue(instance.datOccurred), instance.StateParameter)
        ExecuteNonQuery(cmd)

    End Sub

    Public Overrides Sub DeleteDataFileState(ByVal instance As DataFileState)

        If instance IsNot Nothing Then
            Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.DeleteDataFileState, instance.Id)
            ExecuteNonQuery(cmd)
        End If

    End Sub

    Public Overrides Sub ChangeDataFileState(ByVal dataFileID As Integer, ByVal stateID As DataFileStates, ByVal stateParam As String)

        'Make sure the state parameter is not too long
        If stateParam.Length > 2000 Then
            stateParam = String.Format("{0}{1}{2}", stateParam.Substring(0, 1985), vbCrLf, "TRUNCATED")
        End If

        'Perform the update
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.UpdateDataFileStateChange, dataFileID, stateID, stateParam)
        ExecuteNonQuery(cmd)

    End Sub

#End Region

End Class
