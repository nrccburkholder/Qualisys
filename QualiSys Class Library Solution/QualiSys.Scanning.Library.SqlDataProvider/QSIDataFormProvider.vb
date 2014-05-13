Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports System.Data.Common
Imports NRC.Framework.Data
Imports System.Collections.ObjectModel

Friend Class QSIDataFormProvider
	Inherits NRC.QualiSys.Scanning.Library.QSIDataFormProvider

#Region " Private ReadOnly Properties "

    Private ReadOnly Property Db() As Database
        Get
            Return QualiSysDatabaseHelper.Db
        End Get
    End Property

#End Region

#Region " QSIDataForm Procs "

    Private Function PopulateQSIDataForm(ByVal rdr As SafeDataReader) As QSIDataForm

        Dim newObject As QSIDataForm = QSIDataForm.NewQSIDataForm
        Dim privateInterface As IQSIDataForm = newObject

        newObject.BeginPopulate()
        privateInterface.FormId = rdr.GetInteger("Form_ID")
        privateInterface.TemplateName = rdr.GetString("TemplateName")
        newObject.BatchId = rdr.GetInteger("Batch_ID")
        newObject.LithoCode = rdr.GetString("LithoCode")
        newObject.SentMailId = rdr.GetInteger("SentMail_ID")
        newObject.QuestionFormId = rdr.GetInteger("QuestionForm_ID")
        newObject.SurveyId = rdr.GetInteger("Survey_ID")
        newObject.TemplateCode = rdr.GetString("TemplateCode")
        newObject.LangID = rdr.GetInteger("LangID")
        newObject.DateKeyed = rdr.GetDate("DateKeyed")
        newObject.KeyedBy = rdr.GetString("KeyedBy")
        newObject.DateVerified = rdr.GetDate("DateVerified")
        newObject.VerifiedBy = rdr.GetString("VerifiedBy")
        newObject.EndPopulate()

        Return newObject

    End Function
	
    Public Overrides Function SelectQSIDataForm(ByVal formId As Integer) As QSIDataForm

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectQSIDataForm, formId)
        Using rdr As New SafeDataReader(QualiSysDatabaseHelper.ExecuteReader(cmd))
            If Not rdr.Read Then
                Return Nothing
            Else
                Return PopulateQSIDataForm(rdr)
            End If
        End Using

    End Function

    Public Overrides Function SelectQSIDataFormsByBatchId(ByVal batchId As Integer) As QSIDataFormCollection

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectQSIDataFormsByBatchId, batchId)
        Using rdr As New SafeDataReader(QualiSysDatabaseHelper.ExecuteReader(cmd))
            Return QualiSysDatabaseHelper.PopulateCollection(Of QSIDataFormCollection, QSIDataForm)(rdr, AddressOf PopulateQSIDataForm)
        End Using

    End Function

    Public Overrides Function SelectQSIDataFormsByTemplateName(ByVal batchId As Integer, ByVal templateName As String, ByVal dataEntryMode As DataEntryModes) As QSIDataFormCollection

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectQSIDataFormsByTemplateName, batchId, templateName, dataEntryMode)
        Using rdr As New SafeDataReader(QualiSysDatabaseHelper.ExecuteReader(cmd))
            Return QualiSysDatabaseHelper.PopulateCollection(Of QSIDataFormCollection, QSIDataForm)(rdr, AddressOf PopulateQSIDataForm)
        End Using

    End Function

    Public Overrides Function InsertQSIDataForm(ByVal instance As QSIDataForm) As Integer

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.InsertQSIDataForm, instance.BatchId, instance.LithoCode, instance.SentMailId, instance.QuestionFormId, instance.SurveyId, instance.TemplateCode, instance.LangID, SafeDataReader.ToDBValue(instance.DateKeyed), instance.KeyedBy, SafeDataReader.ToDBValue(instance.DateVerified), instance.VerifiedBy)
        Return QualiSysDatabaseHelper.ExecuteInteger(cmd)

    End Function

    Public Overrides Sub UpdateQSIDataForm(ByVal instance As QSIDataForm)

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.UpdateQSIDataForm, instance.FormId, instance.BatchId, instance.LithoCode, instance.SentMailId, instance.QuestionFormId, instance.SurveyId, instance.TemplateCode, instance.LangID, SafeDataReader.ToDBValue(instance.DateKeyed), instance.KeyedBy, SafeDataReader.ToDBValue(instance.DateVerified), instance.VerifiedBy)
        QualiSysDatabaseHelper.ExecuteNonQuery(cmd)

    End Sub

    Public Overrides Sub DeleteQSIDataForm(ByVal instance As QSIDataForm)

        If instance IsNot Nothing Then
            Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.DeleteQSIDataForm, instance.FormId)
            QualiSysDatabaseHelper.ExecuteNonQuery(cmd)
        End If

    End Sub

    Public Overrides Function ValidateLithoCode(ByVal lithoCode As String) As String

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.ValidateLithoCode, lithoCode)
        Return QualiSysDatabaseHelper.ExecuteString(cmd)

    End Function

    Public Overrides Function CreateQSIDataForm(ByVal batchId As Integer, ByVal lithoCode As String) As QSIDataForm

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.CreateQSIDataForm, batchId, lithoCode)
        Using rdr As New SafeDataReader(QualiSysDatabaseHelper.ExecuteReader(cmd))
            If Not rdr.Read Then
                Return Nothing
            Else
                Return PopulateQSIDataForm(rdr)
            End If
        End Using

    End Function

    Public Overrides Function SelectQSIDataFormQuestions(ByVal questionFormID As Integer, ByVal surveyID As Integer, ByVal langID As Integer) As Collection(Of QSIDataFormQuestion)

        Dim question As QSIDataFormQuestion = Nothing
        Dim questions As New Collection(Of QSIDataFormQuestion)
        Dim qstnCore As Integer

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectQSIDataFormQuestions, questionFormID, surveyID, langID)
        Using rdr As New SafeDataReader(QualiSysDatabaseHelper.ExecuteReader(cmd))
            While rdr.Read
                'Add the question
                If qstnCore <> rdr.GetInteger("QstnCore") Then
                    question = New QSIDataFormQuestion
                    With question
                        .QstnCore = rdr.GetInteger("QstnCore")
                        .QuestionText = rdr.GetString("QuestionText", "Question Text is not available")
                        .SampleUnitId = rdr.GetInteger("SampleUnit_id")
                        .PageNumber = rdr.GetInteger("intPage_Num")
                        .BeginColumn = rdr.GetInteger("intBegColumn")
                        .ResponseWidth = rdr.GetInteger("intRespCol")
                        .ReadMethodId = rdr.GetInteger("ReadMethod_id")
                    End With

                    'Add question to the collection
                    questions.Add(question)
                    qstnCore = rdr.GetInteger("QstnCore")
                End If

                'Add the scale
                Dim scale As New QSIDataFormQuestionItem
                With scale
                    .ScaleItem = rdr.GetInteger("Item")
                    .ScaleItemText = rdr.GetString("ScaleItemText", "Scale Item Text is not available")
                    .ResponseValue = rdr.GetInteger("Val")
                    .ScaleOrder = rdr.GetInteger("ScaleOrder")
                End With

                'Add the scale to the collection
                question.ScaleItems.Add(scale)
            End While
        End Using

        Return questions

    End Function

#End Region

End Class
