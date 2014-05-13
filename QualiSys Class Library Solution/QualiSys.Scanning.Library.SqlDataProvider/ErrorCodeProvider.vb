'********************************************************************************
' Concrete SqlProvider Class
'********************************************************************************
Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports System.Data.Common
Imports NRC.Framework.Data


Friend Class ErrorCodeProvider
	Inherits QualiSys.Scanning.Library.ErrorCodeProvider

    Private ReadOnly Property Db() As Database
        Get
            Return QualiSysDatabaseHelper.Db
        End Get
    End Property

	
#Region " ErrorCode Procs "

    Private Function PopulateErrorCode(ByVal rdr As SafeDataReader) As ErrorCode

        Dim newObject As ErrorCode = ErrorCode.NewErrorCode
        Dim privateInterface As IErrorCode = newObject

        newObject.BeginPopulate()
        If rdr.IsDBNull("DL_Error_ID") Then
            privateInterface.ErrorId = TransferErrorCodes.None
        Else
            privateInterface.ErrorId = rdr.GetEnum(Of TransferErrorCodes)("DL_Error_ID")
        End If
        newObject.ErrorDesc = rdr.GetString("ErrorDesc")
        newObject.DateCreated = rdr.GetDate("DateCreated")
        newObject.EndPopulate()

        Return newObject

    End Function
	
    Public Overrides Function SelectErrorCode(ByVal errorId As Integer) As ErrorCode

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectErrorCode, errorId)
        Using rdr As New SafeDataReader(QualiSysDatabaseHelper.ExecuteReader(cmd))
            If Not rdr.Read Then
                Return Nothing
            Else
                Return PopulateErrorCode(rdr)
            End If
        End Using

    End Function

    Public Overrides Function SelectAllErrorCodes() As ErrorCodeCollection

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectAllErrorCodes)
        Using rdr As New SafeDataReader(QualiSysDatabaseHelper.ExecuteReader(cmd))
            Return QualiSysDatabaseHelper.PopulateCollection(Of ErrorCodeCollection, ErrorCode)(rdr, AddressOf PopulateErrorCode)
        End Using

    End Function

#End Region

End Class
