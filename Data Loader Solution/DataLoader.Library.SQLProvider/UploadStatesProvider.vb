
'********************************************************************************
' Concrete SqlProvider Class
'********************************************************************************
Imports Nrc.Framework.Data
Imports Nrc.Framework.BusinessLogic
Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports System.Data.Common

Friend Class UploadStatesProvider
    Inherits NRC.DataLoader.Library.UploadStatesProvider

    Private ReadOnly Property Db() As Database
        Get
            Return DatabaseHelper.Db
        End Get
    End Property

#Region " SP Declarations "
    Private NotInheritable Class SP
        Private Sub New()
        End Sub
        'Public Const DeleteUploadState As String = "dbo.DeleteUploadState"
        'Public Const InsertUploadState As String = "dbo.InsertUploadState"
        'Public Const UpdateUploadState As String = "dbo.UpdateUploadState"
        Public Const SelectAllUploadStates As String = "dbo.LD_SelectAllUploadStates"
        Public Const SelectUploadState As String = "dbo.LD_SelectUploadState"
        Public Const SelectUploadStateByName As String = "dbo.LD_SelectUploadStateByName"

    End Class
#End Region
	
#Region " UploadState Procs "

	Private Function PopulateUploadState(ByVal rdr As SafeDataReader) As UploadState
		Dim newObject As UploadState = UploadState.NewUploadState
		Dim privateInterface As IUploadState = newObject
		newObject.BeginPopulate()
		privateInterface.UploadStateId = rdr.GetInteger("UploadState_id")
		newObject.UploadStateName = rdr.GetString("UploadState_Nm")
		newObject.EndPopulate()
		
		Return newObject
	End Function
	
	Public Overrides Function SelectUploadState(ByVal uploadStateId As Integer) As UploadState
		Dim cmd As DBCommand = Db.GetStoredProcCommand(SP.SelectUploadState, uploadStateId)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))		
			If Not rdr.Read Then
				Return Nothing
			Else
				Return PopulateUploadState(rdr)
			End If
		End Using
	End Function

	Public Overrides Function SelectAllUploadStates() As UploadStateCollection
		Dim cmd As DBCommand = Db.GetStoredProcCommand(SP.SelectAllUploadStates)
		Using rdr As New SafeDataReader(ExecuteReader(cmd))
			Return PopulateCollection(Of UploadStateCollection, UploadState)(rdr, AddressOf PopulateUploadState)
		End Using
	End Function
    Public Overrides Function SelectUploadStateByName(ByVal name As String) As UploadState
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectUploadStateByName, name)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            If Not rdr.Read Then
                Return Nothing
            Else
                Return PopulateUploadState(rdr)
            End If
        End Using
    End Function

    'Public Overrides Function InsertUploadState(ByVal instance As UploadState) As Integer
    '	Dim cmd As DBCommand = Db.GetStoredProcCommand(SP.InsertUploadState, instance.UploadStateName)
    '	Return ExecuteInteger(cmd)
    'End Function
    'Public Overrides Sub UpdateUploadState(ByVal instance As UploadState)
    '	Dim cmd As DBCommand = Db.GetStoredProcCommand(SP.UpdateUploadState, instance.UploadStateId, instance.UploadStateName)
    '	ExecuteNonQuery(cmd)
    'End Sub
    'Public Overrides Sub DeleteUploadState(ByVal uploadStateId As Integer)
    '	Dim cmd As DBCommand = Db.GetStoredProcCommand(SP.DeleteUploadState, uploadStateId)
    '	ExecuteNonQuery(cmd)
    'End Sub

#End Region


End Class
