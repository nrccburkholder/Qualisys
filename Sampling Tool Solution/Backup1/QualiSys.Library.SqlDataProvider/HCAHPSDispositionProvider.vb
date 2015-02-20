'********************************************************************************
' Concrete SqlProvider Class
'********************************************************************************
Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports System.Data.Common
Imports NRC.Framework.Data


Friend Class HCAHPSDispositionProvider
    Inherits QualiSys.Library.HCAHPSDispositionProvider

    Private ReadOnly Property Db() As Database
        Get
            Return Globals.Db
        End Get
    End Property

	
#Region " HCAHPSDisposition Procs "

	Private Function PopulateHCAHPSDisposition(ByVal rdr As SafeDataReader) As HCAHPSDisposition
		Dim newObject As HCAHPSDisposition = HCAHPSDisposition.NewHCAHPSDisposition
		Dim privateInterface As IHCAHPSDisposition = newObject
		newObject.BeginPopulate()
		privateInterface.HCAHPSDispositionID = rdr.GetInteger("HCAHPSDispositionID")
		newObject.DispositionId = rdr.GetInteger("Disposition_ID")
		newObject.HCAHPSValue = rdr.GetString("HCAHPSValue")
		newObject.HCAHPSHierarchy = rdr.GetInteger("HCAHPSHierarchy")
		newObject.HCAHPSDesc = rdr.GetString("HCAHPSDesc")
		newObject.EndPopulate()
		
		Return newObject
	End Function
	
	Public Overrides Function SelectHCAHPSDisposition(ByVal hCAHPSDispositionID As Integer) As HCAHPSDisposition
		Dim cmd As DBCommand = Db.GetStoredProcCommand(SP.SelectHCAHPSDisposition, hCAHPSDispositionID)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))		
			If Not rdr.Read Then
				Return Nothing
			Else
				Return PopulateHCAHPSDisposition(rdr)
			End If
		End Using
	End Function

	Public Overrides Function SelectAllHCAHPSDispositions() As HCAHPSDispositionCollection
		Dim cmd As DBCommand = Db.GetStoredProcCommand(SP.SelectAllHCAHPSDispositions)
		Using rdr As New SafeDataReader(ExecuteReader(cmd))
			Return PopulateCollection(Of HCAHPSDispositionCollection, HCAHPSDisposition)(rdr, AddressOf PopulateHCAHPSDisposition)
		End Using
	End Function

	Public Overrides Function SelectHCAHPSDispositionsByDispositionId(ByVal dispositionId As Integer) As HCAHPSDispositionCollection
		Dim cmd As DBCommand = Db.GetStoredProcCommand(SP.SelectHCAHPSDispositionsByDispositionId, dispositionId)
		Using rdr As New SafeDataReader(ExecuteReader(cmd))
			Return PopulateCollection(Of HCAHPSDispositionCollection, HCAHPSDisposition)(rdr, AddressOf PopulateHCAHPSDisposition)
		End Using
	End Function

	Public Overrides Function InsertHCAHPSDisposition(ByVal instance As HCAHPSDisposition) As Integer
		Dim cmd As DBCommand = Db.GetStoredProcCommand(SP.InsertHCAHPSDisposition, instance.DispositionId, instance.HCAHPSValue, instance.HCAHPSHierarchy, instance.HCAHPSDesc)
		Return ExecuteInteger(cmd)
	End Function

	Public Overrides Sub UpdateHCAHPSDisposition(ByVal instance As HCAHPSDisposition)
		Dim cmd As DBCommand = Db.GetStoredProcCommand(SP.UpdateHCAHPSDisposition, instance.HCAHPSDispositionID, instance.DispositionId, instance.HCAHPSValue, instance.HCAHPSHierarchy, instance.HCAHPSDesc)
		ExecuteNonQuery(cmd)
	End Sub

	Public Overrides Sub DeleteHCAHPSDisposition(ByVal instance As HCAHPSDisposition)
        If instance IsNot Nothing Then
            Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.DeleteHCAHPSDisposition, instance.HCAHPSDispositionID)
            ExecuteNonQuery(cmd)
        End If
	End Sub

#End Region


End Class
