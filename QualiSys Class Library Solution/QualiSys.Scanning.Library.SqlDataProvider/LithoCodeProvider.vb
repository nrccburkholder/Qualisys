Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports System.Data.Common
Imports NRC.Framework.Data

Friend Class LithoCodeProvider
    Inherits QualiSys.Scanning.Library.LithoCodeProvider

    Private ReadOnly Property Db() As Database
        Get
            Return QualiSysDatabaseHelper.Db
        End Get
    End Property

#Region " LithoCode Procs "

    Private Function PopulateLithoCode(ByVal rdr As SafeDataReader) As LithoCode

        Dim newObject As LithoCode = LithoCode.NewLithoCode
        Dim privateInterface As ILithoCode = newObject

        newObject.BeginPopulate()
        privateInterface.LithoCodeId = rdr.GetInteger("DL_LithoCode_ID")
        newObject.SurveyDataLoadId = rdr.GetInteger("SurveyDataLoad_ID")
        If rdr.IsDBNull("DL_Error_ID") Then
            newObject.ErrorId = TransferErrorCodes.None
        Else
            newObject.ErrorId = rdr.GetEnum(Of TransferErrorCodes)("DL_Error_ID")
        End If
        newObject.ResponseType = rdr.GetString("TranslationCode")
        newObject.LithoCode = rdr.GetString("strLithoCode")
        newObject.Ignore = rdr.GetBoolean("bitIgnore")
        newObject.Submitted = rdr.GetBoolean("bitSubmitted")
        newObject.Extracted = rdr.GetBoolean("bitExtracted")
        newObject.SkipDuplicate = rdr.GetBoolean("bitSkipDuplicate")
        newObject.DispositionUpdate = rdr.GetBoolean("bitDispositionUpdate")
        newObject.DateCreated = rdr.GetDate("DateCreated")

        privateInterface.SentMailId = rdr.GetInteger("SentMail_id", -1)
        privateInterface.QuestionFormId = rdr.GetInteger("QuestionForm_id", -1)
        privateInterface.StudyId = rdr.GetInteger("Study_id", -1)
        privateInterface.SurveyId = rdr.GetInteger("Survey_id", -1)
        privateInterface.SamplePopId = rdr.GetInteger("SamplePop_id", -1)
        privateInterface.SampleSetId = rdr.GetInteger("SampleSet_id", -1)
        privateInterface.PopId = rdr.GetInteger("Pop_id", -1)
        privateInterface.LangID = rdr.GetInteger("LangID", -1)
        privateInterface.ResultsImported = rdr.GetDate("datResultsImported")
        privateInterface.Returned = rdr.GetDate("datReturned")
        If rdr.IsDBNull("UnusedReturn_id") Then
            privateInterface.UnusedReturnId = UnusedReturnCodes.None
        Else
            privateInterface.UnusedReturnId = rdr.GetEnum(Of UnusedReturnCodes)("UnusedReturn_id")
        End If
        privateInterface.OtherStepImported = rdr.GetBoolean("OtherStepImported")
        privateInterface.DateExpired = rdr.GetDate("datExpire")
        privateInterface.SurveyName = rdr.GetString("strSurvey_Nm", String.Empty)
        privateInterface.ClientName = rdr.GetString("strClient_Nm", String.Empty)
        newObject.EndPopulate()

        Return newObject

    End Function

    Private Sub PopulateAdditionalInfo(ByVal rdr As SafeDataReader, ByVal instance As LithoCode)

        Dim privateInterface As ILithoCode = instance

        privateInterface.SentMailId = rdr.GetInteger("SentMail_id", -1)
        privateInterface.QuestionFormId = rdr.GetInteger("QuestionForm_id", -1)
        privateInterface.StudyId = rdr.GetInteger("Study_id", -1)
        privateInterface.SurveyId = rdr.GetInteger("Survey_id", -1)
        privateInterface.SamplePopId = rdr.GetInteger("SamplePop_id", -1)
        privateInterface.SampleSetId = rdr.GetInteger("SampleSet_id", -1)
        privateInterface.PopId = rdr.GetInteger("Pop_id", -1)
        privateInterface.LangID = rdr.GetInteger("LangID", -1)
        privateInterface.ResultsImported = rdr.GetDate("datResultsImported")
        privateInterface.Returned = rdr.GetDate("datReturned")
        If rdr.IsDBNull("UnusedReturn_id") Then
            privateInterface.UnusedReturnId = UnusedReturnCodes.None
        Else
            privateInterface.UnusedReturnId = rdr.GetEnum(Of UnusedReturnCodes)("UnusedReturn_id")
        End If
        privateInterface.OtherStepImported = rdr.GetBoolean("OtherStepImported")
        privateInterface.DateExpired = rdr.GetDate("datExpire")
        privateInterface.SurveyName = rdr.GetString("strSurvey_Nm", String.Empty)
        privateInterface.ClientName = rdr.GetString("strClient_Nm", String.Empty)

    End Sub

    Public Overrides Function SelectLithoCode(ByVal lithoCodeId As Integer) As LithoCode

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectLithoCode, lithoCodeId)
        Using rdr As New SafeDataReader(QualiSysDatabaseHelper.ExecuteReader(cmd))
            If Not rdr.Read Then
                Return Nothing
            Else
                Return PopulateLithoCode(rdr)
            End If
        End Using

    End Function

    Public Overrides Function SelectLithoCodesBySurveyDataLoadId(ByVal surveyDataLoadId As Integer) As LithoCodeCollection

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectLithoCodesBySurveyDataLoadId, surveyDataLoadId)
        Using rdr As New SafeDataReader(QualiSysDatabaseHelper.ExecuteReader(cmd))
            Return QualiSysDatabaseHelper.PopulateCollection(Of LithoCodeCollection, LithoCode)(rdr, AddressOf PopulateLithoCode)
        End Using

    End Function

    Public Overrides Function InsertLithoCode(ByVal instance As LithoCode) As Integer

        Dim errorID As Object = DBNull.Value
        If instance.ErrorId <> TransferErrorCodes.None Then
            errorID = instance.ErrorId
        End If
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.InsertLithoCode, instance.SurveyDataLoadId, errorID, instance.ResponseType, instance.LithoCode, instance.Ignore, instance.Submitted, instance.Extracted, instance.SkipDuplicate, instance.DispositionUpdate, SafeDataReader.ToDBValue(instance.DateCreated))
        Return QualiSysDatabaseHelper.ExecuteInteger(cmd)

    End Function

    Public Overrides Sub UpdateLithoCode(ByVal instance As LithoCode)

        Dim errorID As Object = DBNull.Value
        If instance.ErrorId <> TransferErrorCodes.None Then
            errorID = instance.ErrorId
        End If
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.UpdateLithoCode, instance.LithoCodeId, instance.SurveyDataLoadId, errorID, instance.ResponseType, instance.LithoCode, instance.Ignore, instance.Submitted, instance.Extracted, instance.SkipDuplicate, instance.DispositionUpdate, SafeDataReader.ToDBValue(instance.DateCreated))
        QualiSysDatabaseHelper.ExecuteNonQuery(cmd)

    End Sub

    Public Overrides Sub DeleteLithoCode(ByVal instance As LithoCode)

        If instance IsNot Nothing Then
            Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.DeleteLithoCode, instance.LithoCodeId)
            QualiSysDatabaseHelper.ExecuteNonQuery(cmd)
        End If

    End Sub

    Public Overrides Sub GetAdditionalInfo(ByVal instance As LithoCode)

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.GetAdditionalInfo, instance.LithoCode)
        Using rdr As New SafeDataReader(QualiSysDatabaseHelper.ExecuteReader(cmd))
            If rdr.Read Then
                PopulateAdditionalInfo(rdr, instance)
            End If
        End Using

    End Sub

    Public Overrides Function SelectLithoCodePrevFinalDispoCount(ByVal instance As LithoCode) As Integer

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectLithoCodePrevFinalDispoCount, instance.LithoCodeId, instance.LithoCode)
        Return QualiSysDatabaseHelper.ExecuteInteger(cmd)

    End Function

    Public Overrides Function BeginTransaction() As DbTransaction

        Dim conn As DbConnection = Db.CreateConnection()
        conn.Open()
        Return conn.BeginTransaction

    End Function

    Public Overrides Sub SaveLithoCodeToQualiSys(ByVal litho As LithoCode, ByVal transaction As DbTransaction)

        Dim finalDispo As Disposition = litho.Dispositions.GetFinalDisposition

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SaveLithoCodeToQualiSys, litho.SentMailId, litho.QuestionFormId, finalDispo.DispositionDate, "NewOffTr", litho.ReceiptType.Id)
        QualiSysDatabaseHelper.ExecuteNonQuery(cmd, transaction)

    End Sub

    Public Overrides Sub SaveQuestionResultToQualiSys(ByVal questionFormID As Integer, ByVal sampleUnitID As Integer, ByVal qstnCore As Integer, ByVal responseVal As Integer, ByVal transaction As DbTransaction)

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SaveQuestionResultToQualiSys, questionFormID, sampleUnitID, qstnCore, responseVal)
        QualiSysDatabaseHelper.ExecuteNonQuery(cmd, transaction)

    End Sub

    Public Overrides Sub SaveHandEntryToQualiSys(ByVal litho As LithoCode, ByVal hand As HandEntry, ByVal transaction As DbTransaction)

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SaveHandEntryToQualiSys, litho.StudyId, litho.PopId, litho.SamplePopId, litho.QuestionFormId, hand.SetClause, hand.FieldName, 4)
        QualiSysDatabaseHelper.ExecuteNonQuery(cmd, transaction)

    End Sub

    Public Overrides Sub SavePopMappingToQualiSys(ByVal litho As LithoCode, ByVal pop As PopMapping, ByVal transaction As DbTransaction)

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SavePopMappingToQualiSys, litho.StudyId, litho.PopId, litho.SamplePopId, litho.QuestionFormId, pop.SetClause, pop.FieldName, 4)
        QualiSysDatabaseHelper.ExecuteNonQuery(cmd, transaction)

    End Sub

    Public Overrides Sub SaveDispositionToQualiSys(ByVal litho As LithoCode, ByVal dispo As Disposition, ByVal userName As String, ByVal transaction As DbTransaction)

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SaveDispositionToQualiSys, litho.LithoCodeId, dispo.VendorDispo.VendorDispositionId, litho.LithoCode, litho.SentMailId, litho.SamplePopId, dispo.DispositionDate, litho.ReceiptType.Id, userName, dispo.VendorDispo.DispositionId, dispo.VendorDispo.QCLDisposition.Action, dispo.IsFinal)
        QualiSysDatabaseHelper.ExecuteNonQuery(cmd, transaction)

    End Sub

    Public Overrides Sub SaveLangIdToQualiSys(ByVal litho As LithoCode, ByVal transaction As DbTransaction)

        Dim setClause As String = String.Concat("LangID = ", litho.LangId.ToString)

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SaveLangIdToQualiSys, litho.StudyId, litho.PopId, litho.SamplePopId, litho.QuestionFormId, setClause, "LangID", 4)
        QualiSysDatabaseHelper.ExecuteNonQuery(cmd, transaction)

    End Sub

#End Region

End Class
