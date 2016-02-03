'********************************************************************************
' Concrete SqlProvider Class
'********************************************************************************
Imports Nrc.Framework.Data
Imports Nrc.Framework.BusinessLogic
Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports System.Data.Common

Friend Class SPETL_RespondentImportValidatorProvider
    Inherits Nrc.SurveyPoint.Library.DataProviders.SPETL_RespondentImportValidatorProvider

    Private ReadOnly Property Db() As Database
        Get
            Return DatabaseHelper.Db
        End Get
    End Property

#Region " SP Declarations "
    Private NotInheritable Class SP
        Private Sub New()
        End Sub
        Public Const SPETL_GetTemplateInfo As String = "dbo.SPETL_GetTemplateInfo"
        Public Const SPETL_GetFileDefColumns As String = "dbo.SPETL_GetFileDefColumns"
        Public Const SPETL_GetBaseRespondentInfo As String = "dbo.SPETL_GetBaseRespondentInfo"
        Public Const SPETL_GetRespondentData As String = "dbo.SPETL_GetRespondentData"
        Public Const SPETL_GetRespondentProperties As String = "dbo.SPETL_GetRespondentProperties"
        Public Const SPETL_GetRespondentEventLog As String = "dbo.SPETL_GetRespondentEventLog"
    End Class
#End Region

#Region " SPETL_RespondentImportValidatorProvider Procs "
    Public Overrides Sub GetTemplateInfo(ByVal instance As SPETL_RespondentImportValidator)      
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SPETL_GetTemplateInfo, instance.TemplateID)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            While rdr.Read
                instance.TemplateID = rdr.GetInteger("TemplateID")
                instance.ClientID = rdr.GetInteger("ClientID")
                instance.ScriptID = rdr.GetInteger("ScriptID")
                instance.FileDefID = rdr.GetInteger("FileDefID")
            End While
        End Using        
    End Sub
    Public Overrides Function GetFileDefTable(ByVal fileDefID As Integer) As System.Data.DataTable
        Dim ds As New DataSet
        ds.Tables.Add("FileDefTable")
        ds.Tables(0).Columns.Add(New DataColumn("FileDefID"))
        ds.Tables(0).Columns.Add(New DataColumn("FileDefColumnID"))
        ds.Tables(0).Columns.Add(New DataColumn("ColumnName"))
        ds.Tables(0).Columns.Add(New DataColumn("DisplayOrder"))
        ds.Tables(0).Columns.Add(New DataColumn("Width"))
        ds.Tables(0).Columns.Add(New DataColumn("FileValue"))
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SPETL_GetFileDefColumns, fileDefID)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            While rdr.Read
                ds.Tables(0).Rows.Add(rdr.GetInteger("FileDefID"), rdr.GetInteger("FileDefColumnID"), _
                    rdr.GetString("ColumnName"), rdr.GetInteger("DisplayOrder"), _
                    rdr.GetInteger("Width"), "No Value Retrieved")
            End While
        End Using
        Return ds.Tables(0)
    End Function
    Public Overrides Function GetRespondentBaseInformation(ByVal fileDefID As Integer, ByVal scriptID As Integer, ByVal templateID As Integer, ByVal respondentID As Integer) As System.Data.DataTable
        Dim ds As New DataSet
        ds.Tables.Add("BaseRespondentData")
        ds.Tables(0).Columns.Add(New DataColumn("FileDef"))
        ds.Tables(0).Columns.Add(New DataColumn("Script"))
        ds.Tables(0).Columns.Add(New DataColumn("Template"))
        ds.Tables(0).Columns.Add(New DataColumn("Respondent"))
        ds.Tables(0).Columns.Add(New DataColumn("Survey"))
        ds.Tables(0).Columns.Add(New DataColumn("Client"))
        ds.Tables(0).Columns.Add(New DataColumn("SurveyInstance"))
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SPETL_GetBaseRespondentInfo, fileDefID, scriptID, templateID, respondentID)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            While rdr.Read
                ds.Tables(0).Rows.Add(rdr.GetString("FileDef"), rdr.GetString("Script"), rdr.GetString("Template"), _
                    rdr.GetString("Respondent"), rdr.GetString("Survey"), rdr.GetString("Client"), rdr.GetString("SurveyInstance"))
            End While
        End Using
        Return ds.Tables(0)
    End Function
    Public Overrides Function GetRespondentData(ByVal respondentID As Integer) As System.Data.DataTable
        Dim ds As New DataSet
        ds.Tables.Add("RespondentData")
        ds.Tables(0).Columns.Add(New DataColumn("RespondentID"))
        ds.Tables(0).Columns.Add(New DataColumn("SurveyInstanceID"))
        ds.Tables(0).Columns.Add(New DataColumn("FirstName"))
        ds.Tables(0).Columns.Add(New DataColumn("LastName"))
        ds.Tables(0).Columns.Add(New DataColumn("Address1"))
        ds.Tables(0).Columns.Add(New DataColumn("City"))
        ds.Tables(0).Columns.Add(New DataColumn("State"))
        ds.Tables(0).Columns.Add(New DataColumn("PostalCode"))
        ds.Tables(0).Columns.Add(New DataColumn("TelephoneDay"))
        ds.Tables(0).Columns.Add(New DataColumn("DOB"))
        ds.Tables(0).Columns.Add(New DataColumn("Gender"))
        ds.Tables(0).Columns.Add(New DataColumn("ClientRespondentID"))
        ds.Tables(0).Columns.Add(New DataColumn("BatchID"))
        ds.Tables(0).Columns.Add(New DataColumn("Final"))
        ds.Tables(0).Columns.Add(New DataColumn("NextContact"))
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SPETL_GetRespondentData, respondentID)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            While rdr.Read
                ds.Tables(0).Rows.Add(CastNullString(rdr("RespondentID")), CastNullString(rdr("SurveyInstanceID")), CastNullString(rdr("FirstName")), _
                    CastNullString(rdr("LastName")), CastNullString(rdr("Address1")), CastNullString(rdr("City")), CastNullString(rdr("State")), _
                    CastNullString(rdr("PostalCode")), CastNullString(rdr("TelephoneDay")), CastNullString(rdr("DOB")), CastNullString(rdr("Gender")), _
                    CastNullString(rdr("ClientRespondentID")), CastNullString(rdr("BatchID")), CastNullString(rdr("Final")), _
                    CastNullString(rdr("NextContact")))
            End While
        End Using
        Return ds.Tables(0)
    End Function
    Public Overrides Function GetRespondentProperties(ByVal respondentID As Integer) As System.Data.DataTable
        Dim ds As New DataSet
        ds.Tables.Add("RespondentProperties")
        ds.Tables(0).Columns.Add(New DataColumn("PropertyName"))
        ds.Tables(0).Columns.Add(New DataColumn("PropertyValue"))        
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SPETL_GetRespondentProperties, respondentID)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            While rdr.Read
                ds.Tables(0).Rows.Add(CastNullString(rdr("PropertyName")), CastNullString(rdr("PropertyValue")))
            End While
        End Using
        Return ds.Tables(0)
    End Function
    Public Overrides Function GetRespondentEventLog(ByVal respondentID As Integer) As System.Data.DataTable
        Dim ds As New DataSet
        ds.Tables.Add("RespondentEventLog")
        ds.Tables(0).Columns.Add(New DataColumn("EventID"))
        ds.Tables(0).Columns.Add(New DataColumn("EventName"))
        ds.Tables(0).Columns.Add(New DataColumn("EventDate"))
        ds.Tables(0).Columns.Add(New DataColumn("UserID"))
        ds.Tables(0).Columns.Add(New DataColumn("EventParameters"))
        ds.Tables(0).Columns.Add(New DataColumn("SurveyInstanceID"))
        ds.Tables(0).Columns.Add(New DataColumn("SurveyID"))
        ds.Tables(0).Columns.Add(New DataColumn("ClientID"))
        ds.Tables(0).Columns.Add(New DataColumn("EventTypeID"))
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SPETL_GetRespondentEventLog, respondentID)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            While rdr.Read
                ds.Tables(0).Rows.Add(CastNullString(rdr("EventID")), CastNullString(rdr("EventName")), CastNullString(rdr("EventDate")), _
                CastNullString(rdr("UserID")), CastNullString(rdr("EventParameters")), CastNullString(rdr("SurveyInstanceID")), _
                CastNullString(rdr("SurveyID")), CastNullString(rdr("ClientID")), CastNullString(rdr("EventTypeID")))
            End While
        End Using
        Return ds.Tables(0)
    End Function
#End Region
    Private Function CastNullString(ByVal obj As Object) As String
        Dim retVal As String = "'"
        If Not IsDBNull(obj) Then
            retVal = CStr(obj)
        End If
        Return retVal
    End Function

End Class
