Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports DMI
Imports System.Data.Common
Public Class clsRespondentProperties
    Inherits DMI.clsDBEntity2

    Private _iRespondentID As Integer

#Region "dbEntity2 Overrides"
    Public Sub New(ByRef conn As SqlClient.SqlConnection)
        MyBase.New(conn)

    End Sub

    Public Sub New(ByRef conn As String)
        MyBase.New(conn)

    End Sub

    Protected Overrides Sub _FillLookups(ByRef drCriteria As System.Data.DataRow)
        'no lookups

    End Sub

    Protected Overrides Function BuildSelectSQL(ByVal drCriteria As DataRow) As String
        Dim sbSQLRespondents As New Text.StringBuilder("") 'query against respondents table
        Dim sbSQLEventLog As New Text.StringBuilder("") 'query against eventlog table
        Dim sbSQLProperties As New Text.StringBuilder("") 'query against respondent properties table
        Dim sbSQLSurveyInstance As New Text.StringBuilder("") 'querty against survey instance table
        Dim sbSQLStates As New Text.StringBuilder("") 'querty against state table
        Dim dh As DMI.DataHandler
        Dim dr As QMS.dsRespondentProperties.SearchRow

        dr = CType(drCriteria, QMS.dsRespondentProperties.SearchRow)

        '*** survey instance table
        'Survey instance start date criteria
        If Not dr.IsSurveyInstanceStartRangeNull Then sbSQLSurveyInstance.AppendFormat("InstanceDate >= '{0:d}' AND ", dr.SurveyInstanceStartRange)
        'Survey instance end date criteria
        If Not dr.IsSurveyInstanceEndRangeNull Then sbSQLSurveyInstance.AppendFormat("InstanceDate <= '{0:d}' AND ", dr.SurveyInstanceEndRange)
        'Active criteria
        If Not dr.IsActiveNull And dr.IsSurveyInstanceIDNull Then sbSQLSurveyInstance.AppendFormat("Active ={0} AND ", dr.Active)
        If sbSQLSurveyInstance.Length > 0 Then
            'Survey instance id criteria
            If Not dr.IsSurveyInstanceIDNull Then sbSQLSurveyInstance.AppendFormat("SurveyInstanceID = {0} AND ", dr.SurveyInstanceID)
            'Survey id criteria
            If Not dr.IsSurveyIDNull Then sbSQLSurveyInstance.AppendFormat("SurveyID = {0} AND ", dr.SurveyID)
            'Client id criteria
            If Not dr.IsClientIDNull Then sbSQLSurveyInstance.AppendFormat("ClientID = {0} AND ", dr.ClientID)

        End If
        ''Survey id criteria
        'If Not dr.IsSurveyIDNull Then sbSQLSurveyInstance.AppendFormat("SurveyID = {0} AND ", dr.SurveyID)
        ''Client id criteria
        'If Not dr.IsClientIDNull Then sbSQLSurveyInstance.AppendFormat("ClientID = {0} AND ", dr.ClientID)

        '** event log table
        'Event id criteria
        If Not dr.IsEventIDNull Then sbSQLEventLog.AppendFormat("EventID = {0} AND ", dr.EventID)
        'Event log start date criteria
        If Not dr.IsEventStartRangeNull Then sbSQLEventLog.AppendFormat("EventDate >= '{0:d}' AND ", dr.EventStartRange)
        'Event log end date criteria
        If Not dr.IsEventEndRangeNull Then sbSQLEventLog.AppendFormat("EventDate <= '{0:d} 23:59:59' AND ", dr.EventEndRange)
        If sbSQLEventLog.Length > 0 Then
            'Survey instance id criteria
            If Not dr.IsSurveyInstanceIDNull Then sbSQLEventLog.AppendFormat("SurveyInstanceID = {0} AND ", dr.SurveyInstanceID)
            'Survey id criteria
            If Not dr.IsSurveyIDNull Then sbSQLEventLog.AppendFormat("SurveyID = {0} AND ", dr.SurveyID)
            'Client id criteria
            If Not dr.IsClientIDNull Then sbSQLEventLog.AppendFormat("ClientID = {0} AND ", dr.ClientID)
            'append respondent id criteria only if respondent table will be used
            If Not dr.IsRespondentIDNull Then sbSQLEventLog.AppendFormat("RespondentID = {0} AND ", dr.RespondentID)

        End If

        '** state table
        'filter by time difference
        If Not dr.IsTimeZoneDifferenceNull Then sbSQLStates.AppendFormat("TimeDifference = {0} AND ", dr.TimeZoneDifference)
        'filter by time range
        If Not dr.IsLocalTimeStartRangeNull And Not dr.IsLocalTimeEndRangeNull Then
            sbSQLStates.AppendFormat("DATEADD(hour, TimeDifference + 1, GETUTCDATE()) BETWEEN '{0}' AND '{1}') AND ", _
                        dr.LocalTimeStartRange, dr.LocalTimeEndRange)

        ElseIf Not dr.IsLocalTimeStartRangeNull Then
            sbSQLStates.AppendFormat("DATEADD(hour, TimeDifference + 1, GETUTCDATE()) >= '{0}' AND ", _
                        dr.LocalTimeStartRange)

        ElseIf Not dr.IsLocalTimeEndRangeNull Then
            sbSQLStates.AppendFormat("DATEADD(hour, TimeDifference + 1, GETUTCDATE()) <= '{0}' AND ", _
                        dr.LocalTimeEndRange)

        End If

        '** respondent table
        'Survey instance id criteria
        If Not dr.IsSurveyInstanceIDNull Then sbSQLRespondents.AppendFormat("SurveyInstanceID = {0} AND ", dr.SurveyInstanceID)
        'Respondent name criteria
        If Not dr.IsRespondentNameNull Then sbSQLRespondents.AppendFormat("ISNULL(FirstName,'') + ' ' + LastName LIKE {0} AND ", dh.QuoteString(dr.RespondentName))
        'Address criteria
        If Not dr.IsAddressNull Then sbSQLRespondents.AppendFormat("ISNULL(Address1,'') + ISNULL(Address2,'') LIKE {0} AND ", dh.QuoteString(dr.Address))
        'City criteria
        If Not dr.IsCityNull Then sbSQLRespondents.AppendFormat("City LIKE {0} AND ", dh.QuoteString(dr.City))
        'State criteria
        If Not dr.IsStateNull Then sbSQLRespondents.AppendFormat("State LIKE {0} AND ", dh.QuoteString(dr.State))
        'Postal code criteria
        If Not dr.IsPostalCodeNull Then sbSQLRespondents.AppendFormat("PostalCode LIKE {0} AND ", dh.QuoteString(dr.PostalCode))
        'Telephone criteria
        If Not dr.IsTelephoneNull Then sbSQLRespondents.AppendFormat("ISNULL(TelephoneDay + ' ','')  + ISNULL(TelephoneEvening,'') LIKE {0} AND ", dh.QuoteString(dr.Telephone))
        'Email criteria
        If Not dr.IsEmailNull Then sbSQLRespondents.AppendFormat("Email LIKE {0} AND ", dh.QuoteString(dr.Email))
        'Gender criteria
        If Not dr.IsGenderNull Then sbSQLRespondents.AppendFormat("Gender = {0} AND ", dh.QuoteString(dr.Gender))
        'SSN criteria
        If Not dr.IsSSNNull Then sbSQLRespondents.AppendFormat("SSN LIKE {0} AND ", dh.QuoteString(dr.SSN))
        'Client respondent id criteria
        If Not dr.IsClientRespondentIDNull Then sbSQLRespondents.AppendFormat("ClientRespondentID LIKE {0} AND ", dh.QuoteString(dr.ClientRespondentID))
        'Batch id criteria
        If Not dr.IsBatchIDNull Then sbSQLRespondents.AppendFormat("BatchID = {0} AND ", dr.BatchID)
        'Survey id criteria
        If Not dr.IsSurveyIDNull Then sbSQLRespondents.AppendFormat("SurveyID = {0} AND ", dr.SurveyID)
        'Client id criteria
        If Not dr.IsClientIDNull Then sbSQLRespondents.AppendFormat("ClientID = {0} AND ", dr.ClientID)
        'DOB date range
        If Not dr.IsDOBStartRangeNull Then sbSQLRespondents.AppendFormat("DOB >= '{0:d}' AND ", dr.DOBStartRange)
        If Not dr.IsDOBEndRangeNull Then sbSQLRespondents.AppendFormat("DOB <= '{0:d}' AND ", dr.DOBEndRange)
        'Batch id list criteria
        If Not dr.IsBatchIDListNull Then sbSQLRespondents.AppendFormat("BatchID IN ({0}) AND ", dr.BatchIDList)
        'Final criteria
        If Not dr.IsFinalNull Then sbSQLRespondents.AppendFormat("Final = {0} AND ", dr.Final)
        'Call attempts criteria
        If Not dr.IsCallAttemptsMadeNull Then sbSQLRespondents.AppendFormat("CallsMade = {0} AND ", dr.CallAttemptsMade)
        'Exclude final code criteria
        If Not dr.IsExcludeFinalCodesNull Then sbSQLRespondents.Append("Final = 0 AND ")
        'File definition filter criteria
        If Not dr.IsFileDefFilterIDNull Then sbSQLRespondents.AppendFormat("({0}) AND ", clsFileDefs.GetFileDefFilter(_oConn, dr.FileDefFilterID))
        'Event log table criteria
        If sbSQLEventLog.Length > 0 Then
            DMI.clsUtil.Chop(sbSQLEventLog, 4)
            sbSQLRespondents.AppendFormat("EXISTS (SELECT 'x' FROM EventLog WHERE (r.RespondentID = EventLog.RespondentID) AND ({0})) AND ", sbSQLEventLog.ToString)
            'sbSQLRespondents.AppendFormat("RespondentID IN (SELECT RespondentID FROM EventLog WHERE {0}) AND ", sbSQLEventLog.ToString)
        End If
        'State table criteria
        If sbSQLStates.Length > 0 Then
            DMI.clsUtil.Chop(sbSQLStates, 4)
            sbSQLRespondents.AppendFormat("State IN (SELECT State FROM States WHERE {0}) AND ", sbSQLStates.ToString)
        End If
        'append respondent id criteria only if respondent table will be used
        If sbSQLRespondents.Length > 0 And Not dr.IsRespondentIDNull Then sbSQLRespondents.AppendFormat("RespondentID = {0} AND ", dr.RespondentID)

        '** respondent properties table
        'Primary key criteria
        If Not dr.IsRespondentIDNull Then sbSQLProperties.AppendFormat("RespondentID = {0} AND ", dr.RespondentID)
        'respondent property primary key
        If Not dr.IsRespondentPropertyIDNull Then sbSQLProperties.AppendFormat("RespondentPropertyID = {0} AND ", dr.RespondentPropertyID)
        'Property name criteria
        If Not dr.IsPropertyNameNull Then sbSQLProperties.AppendFormat("PropertyName = {0} AND ", dh.QuoteString(dr.PropertyName))
        'Property value criteria
        If Not dr.IsPropertyValueNull Then sbSQLProperties.AppendFormat("PropertyValue = {0} AND ", dh.QuoteString(dr.PropertyValue))
        'Property name list criteria
        If Not dr.IsPropertyNameListNull Then sbSQLProperties.AppendFormat("PropertyName IN ({0}) AND ", dr.PropertyNameList)
        'Property level criteria
        If Not dr.IsPropertyLevelNull Then sbSQLProperties.AppendFormat("PropertyLevel <= {0} AND ", dr.PropertyLevel)
        'Respondent table criteria
        If sbSQLRespondents.Length > 0 Then
            DMI.clsUtil.Chop(sbSQLRespondents, 4)
            sbSQLProperties.AppendFormat("RespondentID IN (SELECT RespondentID FROM vw_Respondents r WHERE {0}) AND ", sbSQLRespondents.ToString)
        End If


        'Clean up criteria
        If sbSQLProperties.Length > 0 Then
            DMI.clsUtil.Chop(sbSQLProperties, 4)
            sbSQLProperties.Insert(0, "WHERE ")

        End If

        'Add select statement
        sbSQLProperties.Insert(0, "SELECT RespondentProperties.*, Properties.PropertyLevel AS PropertyLevel FROM RespondentProperties INNER JOIN Properties ON RespondentProperties.PropertyName = Properties.PropertyName ")

        Return sbSQLProperties.ToString

    End Function

    Protected Overrides Function DeleteCommand() As System.Data.SqlClient.SqlCommand
        Dim oCmd As SqlClient.SqlCommand

        oCmd = New SqlClient.SqlCommand("delete_RespondentProperties", Me._oConn)
        oCmd.CommandType = CommandType.StoredProcedure
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@RespondentPropertyID", SqlDbType.Int, 4, "RespondentPropertyID"))

        Return oCmd

    End Function

    Protected Overrides Sub InitSettings()
        'init class variables
        _ds = New dsRespondentProperties
        _dtMainTable = _ds.Tables("RespondentProperties")
        _sDeleteFilter = "RespondentPropertyID = {0}"

    End Sub

    Protected Overrides Function InsertCommand() As System.Data.SqlClient.SqlCommand
        Dim oCmd As SqlClient.SqlCommand

        oCmd = New SqlClient.SqlCommand("insert_RespondentProperties", Me._oConn)
        oCmd.CommandType = CommandType.StoredProcedure
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@RespondentPropertyID", SqlDbType.Int, 4, "RespondentPropertyID"))
        oCmd.Parameters("@RespondentPropertyID").Direction = ParameterDirection.Output
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@RespondentID", SqlDbType.Int, 4, "RespondentID"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@PropertyName", SqlDbType.VarChar, 100, "PropertyName"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@PropertyValue", SqlDbType.VarChar, 100, "PropertyValue"))
        Return oCmd

    End Function

    Protected Overrides Sub SetIdentityFilter(ByVal iEntityID As Integer, ByRef drCriteria As System.Data.DataRow)
        drCriteria.Item("RespondentPropertyID") = iEntityID

    End Sub

    Protected Overrides Function UpdateCommand() As System.Data.SqlClient.SqlCommand
        Dim oCmd As SqlClient.SqlCommand

        oCmd = New SqlClient.SqlCommand("update_RespondentProperties", Me._oConn)
        oCmd.CommandType = CommandType.StoredProcedure
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@RespondentPropertyID", SqlDbType.Int, 4, "RespondentPropertyID"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@RespondentID", SqlDbType.Int, 4, "RespondentID"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@PropertyName", SqlDbType.VarChar, 100, "PropertyName"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@PropertyValue", SqlDbType.VarChar, 100, "PropertyValue"))

        Return oCmd

    End Function

    Protected Overrides Sub SetNewRowDefaults(ByRef dr As System.Data.DataRow)
        dr.Item("RespondentID") = Me._iRespondentID
        dr.Item("PropertyName") = ""
        dr.Item("PropertyValue") = ""

    End Sub

#End Region

    Public Property RespondentID() As Integer
        Get
            Return _iRespondentID

        End Get
        Set(ByVal Value As Integer)
            _iRespondentID = Value

        End Set
    End Property

    Public Shared Sub SaveRespondentProperty(ByVal connection As SqlClient.SqlConnection, ByVal respondentID As Integer, ByVal propertyName As String, ByVal propertyValue As String)
        SqlHelper.ExecuteNonQuery(connection, CommandType.StoredProcedure, "insert_RespondentProperties", _
            New SqlClient.SqlParameter("@RespondentPropertyID", DBNull.Value), _
            New SqlClient.SqlParameter("@RespondentID", respondentID), _
            New SqlClient.SqlParameter("@PropertyName", ClipText(propertyName, 100)), _
            New SqlClient.SqlParameter("@PropertyValue", ClipText(propertyValue, 400)))

    End Sub

    Public Shared Sub SaveRespondentProperty(ByVal transaction As SqlClient.SqlTransaction, ByVal respondentID As Integer, ByVal propertyName As String, ByVal propertyValue As String)
        SqlHelper.ExecuteNonQuery(transaction, CommandType.StoredProcedure, "insert_RespondentProperties", _
            New SqlClient.SqlParameter("@RespondentPropertyID", DBNull.Value), _
            New SqlClient.SqlParameter("@RespondentID", respondentID), _
            New SqlClient.SqlParameter("@PropertyName", ClipText(propertyName, 100)), _
            New SqlClient.SqlParameter("@PropertyValue", ClipText(propertyValue, 400)))

    End Sub

    Private Shared Function ClipText(ByVal strValue As String, ByVal maxLength As Integer) As String
        Dim result As String
        If (Not IsNothing(strValue) AndAlso strValue.Length > maxLength) Then
            result = strValue.Substring(0, maxLength)
        Else
            result = strValue
        End If
        Return result
    End Function
End Class

