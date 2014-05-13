Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports System.Data.Common
Imports NRC.Framework.Data

Friend Class QuestionResultProvider
	Inherits QualiSys.Scanning.Library.QuestionResultProvider

    Private ReadOnly Property Db() As Database
        Get
            Return QualiSysDatabaseHelper.Db
        End Get
    End Property

#Region " QuestionResult Procs "

    Private Function PopulateQuestionResult(ByVal rdr As SafeDataReader) As QuestionResult

        Dim newObject As QuestionResult = QuestionResult.NewQuestionResult
        Dim privateInterface As IQuestionResult = newObject

        newObject.BeginPopulate()
        privateInterface.QuestionResultId = rdr.GetInteger("DL_QuestionResult_ID")
        newObject.LithoCodeId = rdr.GetInteger("DL_LithoCode_ID")
        If rdr.IsDBNull("DL_Error_ID") Then
            newObject.ErrorId = TransferErrorCodes.None
        Else
            newObject.ErrorId = rdr.GetEnum(Of TransferErrorCodes)("DL_Error_ID")
        End If
        newObject.QstnCore = rdr.GetInteger("QstnCore")
        newObject.ResponseVal = rdr.GetString("ResponseVal")
        newObject.MultipleResponse = rdr.GetBoolean("MultipleResponse")
        newObject.DateCreated = rdr.GetDate("DateCreated")
        newObject.EndPopulate()

        Return newObject

    End Function
	
    Public Overrides Function SelectQuestionResult(ByVal questionResultId As Integer) As QuestionResult

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectQuestionResult, questionResultId)
        Using rdr As New SafeDataReader(QualiSysDatabaseHelper.ExecuteReader(cmd))
            If Not rdr.Read Then
                Return Nothing
            Else
                Return PopulateQuestionResult(rdr)
            End If
        End Using

    End Function

    Public Overrides Function SelectQuestionResultsByLithoCodeId(ByVal lithoCodeId As Integer) As QuestionResultCollection

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectQuestionResultsByLithoCodeId, lithoCodeId)
        Using rdr As New SafeDataReader(QualiSysDatabaseHelper.ExecuteReader(cmd))
            Return QualiSysDatabaseHelper.PopulateCollection(Of QuestionResultCollection, QuestionResult)(rdr, AddressOf PopulateQuestionResult)
        End Using

    End Function

    Public Overrides Function InsertQuestionResult(ByVal instance As QuestionResult) As Integer

        Dim errorID As Object = DBNull.Value
        If instance.ErrorId <> TransferErrorCodes.None Then
            errorID = instance.ErrorId
        End If
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.InsertQuestionResult, instance.LithoCodeId, errorID, instance.QstnCore, instance.ResponseVal, instance.MultipleResponse, SafeDataReader.ToDBValue(instance.DateCreated))
        Return QualiSysDatabaseHelper.ExecuteInteger(cmd)

    End Function

    Public Overrides Sub UpdateQuestionResult(ByVal instance As QuestionResult)

        Dim errorID As Object = DBNull.Value
        If instance.ErrorId <> TransferErrorCodes.None Then
            errorID = instance.ErrorId
        End If
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.UpdateQuestionResult, instance.QuestionResultId, instance.LithoCodeId, errorID, instance.QstnCore, instance.ResponseVal, instance.MultipleResponse, SafeDataReader.ToDBValue(instance.DateCreated))
        QualiSysDatabaseHelper.ExecuteNonQuery(cmd)

    End Sub

    Public Overrides Sub DeleteQuestionResult(ByVal instance As QuestionResult)

        If instance IsNot Nothing Then
            Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.DeleteQuestionResult, instance.QuestionResultId)
            QualiSysDatabaseHelper.ExecuteNonQuery(cmd)
        End If

    End Sub

#End Region

End Class
