'********************************************************************************
' Concrete SqlProvider Class
'********************************************************************************
Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports System.Data.Common
Imports NRC.Framework.Data


Friend Class DispositionProvider
	Inherits QualiSys.Scanning.Library.DispositionProvider

    Private ReadOnly Property Db() As Database
        Get
            Return QualiSysDatabaseHelper.Db
        End Get
    End Property

	
#Region " Disposition Procs "

    Private Function PopulateDisposition(ByVal rdr As SafeDataReader) As Disposition

        Dim newObject As Disposition = Disposition.NewDisposition
        Dim privateInterface As IDisposition = newObject

        newObject.BeginPopulate()
        privateInterface.DispositionId = rdr.GetInteger("DL_Disposition_ID")
        newObject.LithoCodeId = rdr.GetInteger("DL_LithoCode_ID")
        If rdr.IsDBNull("DL_Error_ID") Then
            newObject.ErrorId = TransferErrorCodes.None
        Else
            newObject.ErrorId = rdr.GetEnum(Of TransferErrorCodes)("DL_Error_ID")
        End If
        newObject.DispositionDate = rdr.GetDate("DispositionDate")
        newObject.VendorDispositionCode = rdr.GetString("VendorDispositionCode")
        newObject.IsFinal = rdr.GetBoolean("IsFinal")
        newObject.EndPopulate()

        Return newObject

    End Function
	
    Public Overrides Function SelectDisposition(ByVal dispositionId As Integer) As Disposition

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectDisposition, dispositionId)
        Using rdr As New SafeDataReader(QualiSysDatabaseHelper.ExecuteReader(cmd))
            If Not rdr.Read Then
                Return Nothing
            Else
                Return PopulateDisposition(rdr)
            End If
        End Using

    End Function

    Public Overrides Function SelectDispositionsByLithoCodeId(ByVal lithoCodeId As Integer) As DispositionCollection

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectDispositionsByLithoCodeId, lithoCodeId)
        Using rdr As New SafeDataReader(QualiSysDatabaseHelper.ExecuteReader(cmd))
            Return QualiSysDatabaseHelper.PopulateCollection(Of DispositionCollection, Disposition)(rdr, AddressOf PopulateDisposition)
        End Using

    End Function

    Public Overrides Function InsertDisposition(ByVal instance As Disposition) As Integer

        Dim errorID As Object = DBNull.Value
        If instance.ErrorId <> TransferErrorCodes.None Then
            errorID = instance.ErrorId
        End If
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.InsertDisposition, instance.LithoCodeId, errorID, SafeDataReader.ToDBValue(instance.DispositionDate), instance.VendorDispositionCode, instance.IsFinal)
        Return QualiSysDatabaseHelper.ExecuteInteger(cmd)

    End Function

    Public Overrides Sub UpdateDisposition(ByVal instance As Disposition)

        Dim errorID As Object = DBNull.Value
        If instance.ErrorId <> TransferErrorCodes.None Then
            errorID = instance.ErrorId
        End If
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.UpdateDisposition, instance.DispositionId, instance.LithoCodeId, errorID, SafeDataReader.ToDBValue(instance.DispositionDate), instance.VendorDispositionCode, instance.IsFinal)
        QualiSysDatabaseHelper.ExecuteNonQuery(cmd)

    End Sub

    Public Overrides Sub DeleteDisposition(ByVal instance As Disposition)

        If instance IsNot Nothing Then
            Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.DeleteDisposition, instance.DispositionId)
            QualiSysDatabaseHelper.ExecuteNonQuery(cmd)
        End If

    End Sub

#End Region

End Class
