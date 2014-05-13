Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports System.Data.Common
Imports NRC.Framework.Data

Friend Class QSIDataResultProvider
	Inherits NRC.QualiSys.Scanning.Library.QSIDataResultProvider

#Region " Private ReadOnly Properties "

    Private ReadOnly Property Db() As Database
        Get
            Return QualiSysDatabaseHelper.Db
        End Get
    End Property

#End Region

#Region " QSIDataResult Procs "

    Private Function PopulateQSIDataResult(ByVal rdr As SafeDataReader) As QSIDataResult

        Dim newObject As QSIDataResult = QSIDataResult.NewQSIDataResult
        Dim privateInterface As IQSIDataResult = newObject

        newObject.BeginPopulate()
        privateInterface.ResultId = rdr.GetInteger("Result_ID")
        newObject.FormId = rdr.GetInteger("Form_ID")
        newObject.QstnCore = rdr.GetInteger("QstnCore")
        newObject.ResponseValue = rdr.GetInteger("ResponseValue")
        newObject.EndPopulate()

        Return newObject

    End Function
	
    Public Overrides Function SelectQSIDataResult(ByVal resultId As Integer) As QSIDataResult

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectQSIDataResult, resultId)
        Using rdr As New SafeDataReader(QualiSysDatabaseHelper.ExecuteReader(cmd))
            If Not rdr.Read Then
                Return Nothing
            Else
                Return PopulateQSIDataResult(rdr)
            End If
        End Using

    End Function

    Public Overrides Function SelectQSIDataResultsByFormId(ByVal formId As Integer) As QSIDataResultCollection

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectQSIDataResultsByFormId, formId)
        Using rdr As New SafeDataReader(QualiSysDatabaseHelper.ExecuteReader(cmd))
            Return QualiSysDatabaseHelper.PopulateCollection(Of QSIDataResultCollection, QSIDataResult)(rdr, AddressOf PopulateQSIDataResult)
        End Using

    End Function

    Public Overrides Function InsertQSIDataResult(ByVal instance As QSIDataResult) As Integer

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.InsertQSIDataResult, instance.FormId, instance.QstnCore, instance.ResponseValue)
        Return QualiSysDatabaseHelper.ExecuteInteger(cmd)

    End Function

    Public Overrides Sub UpdateQSIDataResult(ByVal instance As QSIDataResult)

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.UpdateQSIDataResult, instance.ResultId, instance.FormId, instance.QstnCore, instance.ResponseValue)
        QualiSysDatabaseHelper.ExecuteNonQuery(cmd)

    End Sub

    Public Overrides Sub DeleteQSIDataResult(ByVal instance As QSIDataResult)

        If instance IsNot Nothing Then
            Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.DeleteQSIDataResult, instance.ResultId)
            QualiSysDatabaseHelper.ExecuteNonQuery(cmd)
        End If

    End Sub

    Public Overrides Sub DeleteQSIDataResultsByFormId(ByVal formId As Integer)

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.DeleteQSIDataResultsByFormId, formId)
        QualiSysDatabaseHelper.ExecuteNonQuery(cmd)

    End Sub

    Public Overrides Sub DeleteQSIDataResultsByQstnCore(ByVal formId As Integer, ByVal qstnCore As Integer)

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.DeleteQSIDataResultsByQstnCore, formId, qstnCore)
        QualiSysDatabaseHelper.ExecuteNonQuery(cmd)

    End Sub

#End Region

End Class
