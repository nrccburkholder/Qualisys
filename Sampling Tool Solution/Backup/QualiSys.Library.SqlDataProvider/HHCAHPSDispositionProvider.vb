'********************************************************************************
' Concrete SqlProvider Class
'********************************************************************************
Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports System.Data.Common
Imports NRC.Framework.Data


Friend Class HHCAHPSDispositionProvider
    Inherits QualiSys.Library.HHCAHPSDispositionProvider

    Private ReadOnly Property Db() As Database
        Get
            Return Globals.Db
        End Get
    End Property

	
#Region " HHCAHPSDisposition Procs "

	Private Function PopulateHHCAHPSDisposition(ByVal rdr As SafeDataReader) As HHCAHPSDisposition
		Dim newObject As HHCAHPSDisposition = HHCAHPSDisposition.NewHHCAHPSDisposition
		Dim privateInterface As IHHCAHPSDisposition = newObject
		newObject.BeginPopulate()
		privateInterface.HHCAHPSDispositionID = rdr.GetInteger("HHCAHPSDispositionID")
		newObject.DispositionId = rdr.GetInteger("Disposition_ID")
		newObject.HHCAHPSValue = rdr.GetString("HHCAHPSValue")
		newObject.HHCAHPSHierarchy = rdr.GetInteger("HHCAHPSHierarchy")
		newObject.HHCAHPSDesc = rdr.GetString("HHCAHPSDesc")
		newObject.EndPopulate()
		
		Return newObject
	End Function
	
	Public Overrides Function SelectHHCAHPSDisposition(ByVal hHCAHPSDispositionID As Integer) As HHCAHPSDisposition
		Dim cmd As DBCommand = Db.GetStoredProcCommand(SP.SelectHHCAHPSDisposition, hHCAHPSDispositionID)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))		
			If Not rdr.Read Then
				Return Nothing
			Else
				Return PopulateHHCAHPSDisposition(rdr)
			End If
		End Using
	End Function

	Public Overrides Function SelectAllHHCAHPSDispositions() As HHCAHPSDispositionCollection
		Dim cmd As DBCommand = Db.GetStoredProcCommand(SP.SelectAllHHCAHPSDispositions)
		Using rdr As New SafeDataReader(ExecuteReader(cmd))
			Return PopulateCollection(Of HHCAHPSDispositionCollection, HHCAHPSDisposition)(rdr, AddressOf PopulateHHCAHPSDisposition)
		End Using
	End Function

	Public Overrides Function SelectHHCAHPSDispositionsByDispositionId(ByVal dispositionId As Integer) As HHCAHPSDispositionCollection
		Dim cmd As DBCommand = Db.GetStoredProcCommand(SP.SelectHHCAHPSDispositionsByDispositionId, dispositionId)
		Using rdr As New SafeDataReader(ExecuteReader(cmd))
			Return PopulateCollection(Of HHCAHPSDispositionCollection, HHCAHPSDisposition)(rdr, AddressOf PopulateHHCAHPSDisposition)
		End Using
	End Function

	Public Overrides Function InsertHHCAHPSDisposition(ByVal instance As HHCAHPSDisposition) As Integer
		Dim cmd As DBCommand = Db.GetStoredProcCommand(SP.InsertHHCAHPSDisposition, instance.DispositionId, instance.HHCAHPSValue, instance.HHCAHPSHierarchy, instance.HHCAHPSDesc)
		Return ExecuteInteger(cmd)
	End Function

	Public Overrides Sub UpdateHHCAHPSDisposition(ByVal instance As HHCAHPSDisposition)
		Dim cmd As DBCommand = Db.GetStoredProcCommand(SP.UpdateHHCAHPSDisposition, instance.HHCAHPSDispositionID, instance.DispositionId, instance.HHCAHPSValue, instance.HHCAHPSHierarchy, instance.HHCAHPSDesc)
		ExecuteNonQuery(cmd)
	End Sub

	Public Overrides Sub DeleteHHCAHPSDisposition(ByVal instance As HHCAHPSDisposition)
        If instance IsNot Nothing Then
            Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.DeleteHHCAHPSDisposition, instance.HHCAHPSDispositionID)
            ExecuteNonQuery(cmd)
        End If
	End Sub

#End Region


End Class
