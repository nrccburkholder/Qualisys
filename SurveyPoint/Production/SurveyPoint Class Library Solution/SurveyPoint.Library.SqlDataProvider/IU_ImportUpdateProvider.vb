
'********************************************************************************
' Concrete SqlProvider Class
'********************************************************************************
Imports Nrc.Framework.Data
Imports Nrc.Framework.BusinessLogic
Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports System.Data.Common
Imports System.ComponentModel


Friend Class IU_ImportUpdateProvider
    Inherits Nrc.SurveyPoint.Library.DataProviders.IU_ImportUpdateProvider

    Private ReadOnly Property Db() As Database
        Get
            Return DatabaseHelper.Db
        End Get
    End Property


#Region " Procs "
    Public Overrides Function GetQuestionValues(ByVal questionID As Integer) As System.Data.DataTable
        Dim table As New DataTable("Question")
        table.Columns.Add("QuestionName")
        table.Columns.Add("QuestionTypeID")
        table.Columns.Add("QuestionID")
        Dim sql As String = "Select QuestionName, QuestionTypeID, QuestionID from Questions where QuestionID = " & questionID & ""
        Dim cmd As DbCommand = Db.GetSqlStringCommand(sql)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            While rdr.Read
                table.Rows.Add(rdr.GetString("QuestionName"), rdr.GetInteger("QuestionTypeID"), rdr.GetInteger("QuestionID"))
            End While
        End Using
        Return table
    End Function
    Public Overrides Function GetSurveyQuestionValues(ByVal itemorder As Integer, ByVal surveyid As Integer) As System.Data.DataTable
        Dim table As New DataTable("SurveyQuestion")
        table.Columns.Add("QuestionID")
        table.Columns.Add("SurveyQuestionID")        
        Dim sql As String = "Select QuestionID, SurveyQuestionID from SurveyQuestions where ItemOrder = " & itemorder & " and surveyID = " & surveyid & ""
        Dim cmd As DbCommand = Db.GetSqlStringCommand(sql)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            While rdr.Read
                table.Rows.Add(rdr.GetInteger("QuestionID"), rdr.GetInteger("SurveyQuestionID"))
            End While
        End Using
        Return table
    End Function
    Public Overrides Function GetResponseCount(ByVal respondentID As Integer) As Integer
        Dim sql As String = "Select Count(*) as RespCount from Responses Where RespondentID = " & respondentID
        Dim cmd As DbCommand = Db.GetSqlStringCommand(sql)
        Dim respCount As Integer = 0
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            While rdr.Read
                respCount = rdr.GetInteger("RespCount")
            End While
        End Using
    End Function
    Public Overrides Function GetSurveyInstaceID(ByVal respondentID As Integer, ByVal clientID As Integer, ByVal surveyID As Integer) As Integer
        Dim sql As String = "Select SI.SurveyInstanceID from Respondents R inner join "
        sql += "SurveyInstances SI on R.SurveyInstanceID = SI.SurveyInstanceID "
        sql += "Inner Join Clients C on SI.ClientID = C.ClientID "
        sql += "Inner Join Surveys S on SI.SurveyID = S.SurveyID "
        sql += "where S.SurveyID = " & surveyID & " And C.ClientID = " & clientID & " And R.RespondentID = " & respondentID & " "
        sql += "And SI.Active = 1"
        Dim cmd As DbCommand = Db.GetSqlStringCommand(sql)
        Dim surveyInstanceID As Integer = 0
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            While rdr.Read
                surveyInstanceID = rdr.GetInteger("SurveyInstanceID")
            End While
        End Using
        Return surveyInstanceID
    End Function
    Public Overrides Function GetFileDefByFileDefID(ByVal filedefid As Integer) As System.Data.DataTable
        Dim table As New DataTable("FileDefColumns")
        Dim sql As String
        sql = "Select C.FileDefColumnID, C.FileDefID, C.ColumnName, C.DisplayOrder, C.Width, C.FormatString From FileDefs F Inner Join "
        sql = sql & "FileDefColumns C on F.FileDefID = C.FileDefID Where FileDefID = " & filedefid & " Order By DisplayOrder"
        Dim cmd As DbCommand = Db.GetSqlStringCommand(sql)
        table.Columns.Add("FileDefColumnID")
        table.Columns.Add("FileDefID")
        table.Columns.Add("ColumnName")
        table.Columns.Add("DisplayOrder")
        table.Columns.Add("Width")
        table.Columns.Add("FormatString")
        table.Columns.Add("TextValue")
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            While rdr.Read
                table.Rows.Add(rdr.GetInteger("FileDefColumnID"), rdr.GetInteger("FileDefID"), rdr.GetString("ColumnName"), rdr.GetInteger("DisplayOrder"), rdr.GetInteger("Width"), rdr.GetString("FormatString"), "")
            End While
        End Using
        Return table
    End Function
    Public Overrides Function GetFileDefReaderByTemplateID(ByVal templateID As Integer) As DataTable
        Dim clientID As Integer = 0
        Dim fileDefID As Integer = 0
        Dim scriptID As Integer = 0
        Dim fileDefTypeID As Integer = 0
        Dim surveyID As Integer = 0
        Dim fileTypeID As Integer = 0
        Dim cmd As DbCommand = Db.GetStoredProcCommand("dbo.IU_GetFileDefByTemplateID", templateID)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            While rdr.Read
                clientID = rdr.GetInteger("ClientID")
                fileDefID = rdr.GetInteger("FileDefID")
                scriptID = rdr.GetInteger("ScriptID")
            End While
        End Using
        cmd = Db.GetSqlStringCommand("Select SurveyID, ClientID, FileDefTypeID, FileTypeID from FileDefs Where FileDefID = " & fileDefID & "")
        Dim tempClientID As Integer = 0
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            While rdr.Read
                tempClientID = rdr.GetInteger("ClientID")
                fileDefTypeID = rdr.GetInteger("FileDefTypeID")
                surveyID = rdr.GetInteger("SurveyID")
                fileTypeID = rdr.GetInteger("FileTypeID")
            End While
        End Using
        If tempClientID <> clientID Then clientID = 0
        Dim table As New DataTable("FileDefData")
        table.Columns.Add("TemplateID")
        table.Columns.Add("ClientID")
        table.Columns.Add("FileDefID")
        table.Columns.Add("ScriptID")
        table.Columns.Add("SurveyID")
        table.Columns.Add("FileDefTypeID")
        table.Columns.Add("FileTypeID")
        table.Rows.Add(templateID, clientID, fileDefID, scriptID, surveyID, fileDefTypeID, fileTypeID)
        Return table
    End Function
#End Region


End Class

