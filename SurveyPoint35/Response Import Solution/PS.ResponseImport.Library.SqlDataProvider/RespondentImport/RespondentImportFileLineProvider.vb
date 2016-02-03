Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports System.Data.Common
Imports PS.Framework.Data

Public Class RespondentImportFileLineProvider
    Inherits PS.ResponseImport.Library.RespondentImportFileLineProvider

    Private ReadOnly Property Db(ByVal connString As String) As Database
        Get
            Return DatabaseHelper.Db(connString)
        End Get
    End Property
    Public Overrides Function GetSurveyInstanceID(ByVal respID As Integer, ByVal clientID As Integer, ByVal surveyID As Integer) As Integer
        Dim cmd As DbCommand = Db(Config.QMSConnection).GetStoredProcCommand(SP.GetSurveyInstanceID, respID, clientID, surveyID)
        Dim SIID As Integer = 0        
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            While rdr.Read
                SIID = rdr.GetInteger("SurveyInstanceID")
            End While
        End Using
        Return SIID
    End Function
    Public Overrides Function HasResponses(ByVal respID As Integer) As Boolean
        Dim retVal As Boolean = False
        Dim cmd As DbCommand = Db(Config.QMSConnection).GetStoredProcCommand(SP.RespondentHasResponses, respID)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            While rdr.Read
                If rdr.GetInteger("HasResponses") = 1 Then
                    retVal = True
                ElseIf rdr.GetInteger("HasResponses") = 0 Then
                    retVal = False
                Else
                    Throw New System.Exception("Has Responses Proc returned and invalid value")
                End If
            End While
        End Using
        Return retVal
    End Function    
    Public Overrides Sub ImportResponseToStaging(ByVal respondentID As Integer, ByVal templateID As Integer, ByVal surveyQuestionItemOrder As Integer, _
                                            ByVal answerValue As Integer, ByVal answerText As String, _
                                            ByVal fileGuid As String, ByVal lineGuid As String)
        Dim cmd As DbCommand = Db(Config.QMSConnection).GetStoredProcCommand(SP.ImportResponsesToStaging, respondentID, templateID, _
                                                        surveyQuestionItemOrder, answerValue, Left(Trim(StringHelpers.ReplaceTicks(answerText)), 6000), _
                                                        fileGuid, lineGuid)
        ExecuteNonQuery(cmd)
    End Sub
    Public Overrides Function GetFileDefVarsByTemplateID(ByVal templateID As Integer) As System.Data.DataTable
        Dim cmd As DbCommand = Db(Config.QMSConnection).GetStoredProcCommand(SP.GetFileDefVarsByTemplateID, templateID)
        Dim DT As New DataTable("FileDefVars")
        DT.Columns.Add(New DataColumn("ClientID"))
        DT.Columns.Add(New DataColumn("ScriptID"))
        DT.Columns.Add(New DataColumn("FileDefID"))
        DT.Columns.Add(New DataColumn("SurveyID"))
        DT.Columns.Add(New DataColumn("FileDefTypeID"))
        DT.Columns.Add(New DataColumn("FileTypeID"))
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            While rdr.Read
                DT.Rows.Add(rdr.GetInteger("ClientID"), rdr.GetInteger("ScriptID"), rdr.GetInteger("FileDefID"), _
                            rdr.GetInteger("SurveyID"), rdr.GetInteger("FileDefTypeID"), rdr.GetInteger("FileTypeID"))
            End While
        End Using
        Return DT
    End Function
    Public Overrides Function ImportResponses(ByVal lineGuid As String, ByVal fileGuid As String, ByVal clientID As Integer, _
                                                    ByVal surveyID As Integer, ByVal surveyInstanceID As Integer, ByVal respondentID As Integer, _
                                                    ByVal templateID As Integer, ByVal fileDefID As Integer, ByVal userID As Integer, _
                                                    ByVal batchID As String, ByVal scriptID As Integer, ByVal surveySystemType As SurveySystemType) As DataTable
        Dim DT As New DataTable("ImportErrors")
        DT.Columns.Add(New DataColumn("ErrorID"))
        DT.Columns.Add(New DataColumn("ErrDescription"))
        Dim cmd As DbCommand = Db(Config.QMSConnection).GetStoredProcCommand(SP.ImportResponseLine, lineGuid, fileGuid, clientID, _
                                                                             surveyID, surveyInstanceID, respondentID, templateID, fileDefID, _
                                                                             userID, batchID, scriptID, surveySystemType.ToString())
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            While rdr.Read
                DT.Rows.Add(rdr.GetInteger("ErrorID"), rdr.GetString("ErrDescription"))
            End While
        End Using
        Return DT
    End Function
    Public Overrides Function HasCompleteCode(ByVal respondentID As Integer) As Boolean
        Dim retVal As Integer = 0
        Dim cmd As DbCommand = Db(Config.QMSConnection).GetStoredProcCommand(SP.HasCompleteCode, respondentID)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            While rdr.Read
                retVal = rdr.GetInteger("Result")                
            End While
        End Using
        If retVal = 1 Then
            Return True
        Else
            Return False
        End If
    End Function
    Public Overrides Sub RemoveImportResponses(ByVal fileGuid As String, ByVal lineGuid As String)
        Dim cmd As DbCommand = Db(Config.QMSConnection).GetStoredProcCommand(SP.RemoveResponesFromStaging, fileGuid, lineGuid)
        ExecuteNonQuery(cmd)
    End Sub
    Public Overrides Function GetFileDefTableByFileDefID(ByVal fileDefID As Integer) As System.Data.DataTable        
        Dim DT As New DataTable("FileDefColumns")
        DT.Columns.Add(New DataColumn("FileDefColumnID"))
        DT.Columns.Add(New DataColumn("FileDefID"))
        DT.Columns.Add(New DataColumn("ColumnName"))
        DT.Columns.Add(New DataColumn("Width"))
        DT.Columns.Add(New DataColumn("FileDefItemOrder"))
        DT.Columns.Add(New DataColumn("DFAnswerValue"))
        DT.Columns.Add(New DataColumn("DFAnswerText"))
        DT.Columns.Add(New DataColumn("SurveyQuestionItemOrder"))
        DT.Columns.Add(New DataColumn("FieldType"))
        DT.Columns.Add(New DataColumn("TextValue"))
        DT.Columns.Add(New DataColumn("ContainsDESC"))
        Dim cmd As DbCommand = Db(Config.QMSConnection).GetStoredProcCommand(SP.GetFileDefTableByFileDefID, fileDefID)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            While rdr.Read
                DT.Rows.Add(rdr.GetInteger("FileDefColumnID"), rdr.GetInteger("FileDefID"), _
                            rdr.GetString("ColumnName"), rdr.GetInteger("Width"), rdr.GetInteger("DisplayOrder"))
            End While
        End Using
        Return DT
    End Function
End Class