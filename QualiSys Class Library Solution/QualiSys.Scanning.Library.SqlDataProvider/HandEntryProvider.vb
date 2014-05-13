'********************************************************************************
' Concrete SqlProvider Class
'********************************************************************************
Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports System.Data.Common
Imports NRC.Framework.Data


Friend Class HandEntryProvider
	Inherits QualiSys.Scanning.Library.HandEntryProvider

    Private ReadOnly Property Db() As Database
        Get
            Return QualiSysDatabaseHelper.Db
        End Get
    End Property

	
#Region " HandEntry Procs "

    Private Function PopulateHandEntry(ByVal rdr As SafeDataReader) As HandEntry

        Dim newObject As HandEntry = HandEntry.NewHandEntry
        Dim privateInterface As IHandEntry = newObject

        newObject.BeginPopulate()
        privateInterface.HandEntryId = rdr.GetInteger("DL_HandEntry_ID")
        newObject.LithoCodeId = rdr.GetInteger("DL_LithoCode_ID")
        If rdr.IsDBNull("DL_Error_ID") Then
            newObject.ErrorId = TransferErrorCodes.None
        Else
            newObject.ErrorId = rdr.GetEnum(Of TransferErrorCodes)("DL_Error_ID")
        End If
        newObject.QstnCore = rdr.GetInteger("QstnCore")
        newObject.ItemNumber = rdr.GetInteger("ItemNumber")
        newObject.LineNumber = rdr.GetInteger("LineNumber")
        newObject.HandEntryText = rdr.GetString("HandEntryText")
        newObject.EndPopulate()

        Return newObject

    End Function

    Public Overrides Function SelectHandEntry(ByVal handEntryId As Integer) As HandEntry

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectHandEntry, handEntryId)
        Using rdr As New SafeDataReader(QualiSysDatabaseHelper.ExecuteReader(cmd))
            If Not rdr.Read Then
                Return Nothing
            Else
                Return PopulateHandEntry(rdr)
            End If
        End Using

    End Function

    Public Overrides Function SelectHandEntriesByLithoCodeId(ByVal lithoCodeId As Integer) As HandEntryCollection

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectHandEntriesByLithoCodeId, lithoCodeId)
        Using rdr As New SafeDataReader(QualiSysDatabaseHelper.ExecuteReader(cmd))
            Return QualiSysDatabaseHelper.PopulateCollection(Of HandEntryCollection, HandEntry)(rdr, AddressOf PopulateHandEntry)
        End Using

    End Function

    Public Overrides Function SelectHandEntryItemNumberFromResponseValue(ByVal lithoCode As String, ByVal qstnCore As Integer, ByVal itemVal As Integer) As Integer

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectHandEntryItemNumberFromResponseValue, lithoCode, qstnCore, itemVal)
        Return QualiSysDatabaseHelper.ExecuteInteger(cmd)

    End Function

    Public Overrides Function InsertHandEntry(ByVal instance As HandEntry) As Integer

        Dim errorID As Object = DBNull.Value
        If instance.ErrorId <> TransferErrorCodes.None Then
            errorID = instance.ErrorId
        End If
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.InsertHandEntry, instance.LithoCodeId, errorID, instance.QstnCore, instance.ItemNumber, instance.LineNumber, instance.HandEntryText)
        Return QualiSysDatabaseHelper.ExecuteInteger(cmd)

    End Function

    Public Overrides Sub UpdateHandEntry(ByVal instance As HandEntry)

        Dim errorID As Object = DBNull.Value
        If instance.ErrorId <> TransferErrorCodes.None Then
            errorID = instance.ErrorId
        End If
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.UpdateHandEntry, instance.HandEntryId, instance.LithoCodeId, errorID, instance.QstnCore, instance.ItemNumber, instance.LineNumber, instance.HandEntryText)
        QualiSysDatabaseHelper.ExecuteNonQuery(cmd)

    End Sub

    Public Overrides Sub DeleteHandEntry(ByVal instance As HandEntry)

        If instance IsNot Nothing Then
            Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.DeleteHandEntry, instance.HandEntryId)
            QualiSysDatabaseHelper.ExecuteNonQuery(cmd)
        End If

    End Sub

#End Region

End Class
