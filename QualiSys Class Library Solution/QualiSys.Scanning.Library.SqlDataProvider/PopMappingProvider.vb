Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports System.Data.Common
Imports NRC.Framework.Data


Friend Class PopMappingProvider
    Inherits Nrc.QualiSys.Scanning.Library.PopMappingProvider

    Private ReadOnly Property Db() As Database
        Get
            Return QualiSysDatabaseHelper.Db
        End Get
    End Property

#Region " DL_PopMapping Procs "

    Private Function PopulatePopMapping(ByVal rdr As SafeDataReader) As PopMapping

        Dim newObject As PopMapping = PopMapping.NewPopMapping
        Dim privateInterface As IPopMapping = newObject

        newObject.BeginPopulate()
        privateInterface.PopMappingId = rdr.GetInteger("DL_PopMapping_ID")
        newObject.LithoCodeId = rdr.GetInteger("DL_LithoCode_ID")
        If rdr.IsDBNull("DL_Error_ID") Then
            newObject.ErrorId = TransferErrorCodes.None
        Else
            newObject.ErrorId = rdr.GetEnum(Of TransferErrorCodes)("DL_Error_ID")
        End If
        newObject.QstnCore = rdr.GetInteger("QstnCore")
        newObject.PopMappingText = rdr.GetString("PopMappingText")
        newObject.EndPopulate()

        Return newObject

    End Function

    Public Overrides Function SelectPopMapping(ByVal id As Integer) As PopMapping

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectPopMapping, id)
        Using rdr As New SafeDataReader(QualiSysDatabaseHelper.ExecuteReader(cmd))
            If Not rdr.Read Then
                Return Nothing
            Else
                Return PopulatePopMapping(rdr)
            End If
        End Using

    End Function

    Public Overrides Function SelectPopMappingsByLithoCodeId(ByVal lithoCodeId As Integer) As PopMappingCollection

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectPopMappingsByLithoCodeId, lithoCodeId)
        Using rdr As New SafeDataReader(QualiSysDatabaseHelper.ExecuteReader(cmd))
            Return QualiSysDatabaseHelper.PopulateCollection(Of PopMappingCollection, PopMapping)(rdr, AddressOf PopulatePopMapping)
        End Using

    End Function

    Public Overrides Function InsertPopMapping(ByVal instance As PopMapping) As Integer

        Dim errorID As Object = DBNull.Value
        If instance.ErrorId <> TransferErrorCodes.None Then
            errorID = instance.ErrorId
        End If
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.InsertPopMapping, instance.LithoCodeId, errorID, instance.QstnCore, instance.PopMappingText)
        Return QualiSysDatabaseHelper.ExecuteInteger(cmd)

    End Function

    Public Overrides Sub UpdatePopMapping(ByVal instance As PopMapping)

        Dim errorID As Object = DBNull.Value
        If instance.ErrorId <> TransferErrorCodes.None Then
            errorID = instance.ErrorId
        End If
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.UpdatePopMapping, instance.PopMappingId, instance.LithoCodeId, errorID, instance.QstnCore, instance.PopMappingText)
        QualiSysDatabaseHelper.ExecuteNonQuery(cmd)

    End Sub

    Public Overrides Sub DeletePopMapping(ByVal instance As PopMapping)

        If instance IsNot Nothing Then
            Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.DeletePopMapping, instance.PopMappingId)
            QualiSysDatabaseHelper.ExecuteNonQuery(cmd)
        End If

    End Sub

#End Region

End Class
