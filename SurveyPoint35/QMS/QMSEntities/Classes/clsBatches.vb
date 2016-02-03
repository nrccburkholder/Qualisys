Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports DMI
Imports System.Data.Common

Public Class clsBatches
    Inherits DMI.clsDBEntity2

#Region "dbEntity2 Overrides"
    Public Sub New(ByRef conn As SqlClient.SqlConnection)
        MyBase.New(conn)

    End Sub

    Public Sub New(ByRef sConn As String)
        MyBase.New(sConn)

    End Sub

    Protected Overrides Sub _FillLookups(ByRef drCriteria As System.Data.DataRow)
        'no lookups

    End Sub

    Protected Overrides Function BuildSelectSQL(ByVal drCriteria As DataRow) As String
        Dim dr As dsBatches.SearchRow
        Dim sbSQL As New System.Text.StringBuilder
        Dim sbSQLRespondent As New System.Text.StringBuilder

        'get row containing search criteria
        dr = CType(drCriteria, dsBatches.SearchRow)

        'batch criteria
        If Not dr.IsBatchIDNull Then sbSQL.AppendFormat("BatchID = {0} AND ", dr.BatchID)
        'survey criteria
        If Not dr.IsSurveyIDNull Then sbSQL.AppendFormat("SurveyID = {0} AND ", dr.SurveyID)
        'client criteria
        If Not dr.IsClientIDNull Then sbSQL.AppendFormat("ClientID = {0} AND ", dr.ClientID)
        'survey instance criteria
        If Not dr.IsSurveyInstanceIDNull Then sbSQL.AppendFormat("SurveyInstanceID = {0} AND ", dr.SurveyInstanceID)
        'group by criteria
        If Not dr.IsGroupBySurveyNull Then sbSQL.AppendFormat("GroupBySurvey = {0} AND ", dr.GroupBySurvey)
        If Not dr.IsGroupByClientNull Then sbSQL.AppendFormat("GroupByClient = {0} AND ", dr.GroupByClient)
        If Not dr.IsGroupBySurveyInstanceNull Then sbSQL.AppendFormat("GroupBySurveyInstance = {0} AND ", dr.GroupBySurveyInstance)

        'Clean up criteria
        If sbSQL.Length > 0 Then
            DMI.clsUtil.Chop(sbSQL, 4)
            sbSQL.Insert(0, "WHERE ")

        End If

        'Add select statement
        sbSQL.Insert(0, "SELECT * FROM v_Batches ")

        Return sbSQL.ToString

    End Function

    Protected Overrides Function DeleteCommand() As System.Data.SqlClient.SqlCommand

    End Function

    Protected Overrides Sub InitSettings()
        'init class variables
        _ds = New dsBatches
        _dtMainTable = _ds.Tables("Batches")
        _sDeleteFilter = "BatchID = {0}"

    End Sub

    Protected Overrides Function InsertCommand() As System.Data.SqlClient.SqlCommand

    End Function

    Protected Overrides Sub SetIdentityFilter(ByVal iEntityID As Integer, ByRef drCriteria As System.Data.DataRow)
        drCriteria.Item("BatchID") = iEntityID

    End Sub

    Protected Overrides Function UpdateCommand() As System.Data.SqlClient.SqlCommand

    End Function

    Protected Overrides Sub SetNewRowDefaults(ByRef dr As System.Data.DataRow)

    End Sub

#End Region

    Public Shared Function DisplayVerificationHTMLMsg(ByVal respondent As DataRow, ByVal newBatchID As Integer, ByVal lastBatchID As Integer) As String
        Dim msg As New System.Text.StringBuilder

        If newBatchID = lastBatchID Then
            msg.AppendFormat("Batch ID: {0}<br>{1}: {2}: {3}<br>Respondent ID: {4}<br>{6} {5}<br>{7}", _
                newBatchID, respondent.Item("SurveyName"), respondent.Item("ClientName"), respondent.Item("SurveyInstanceName"), _
                respondent.Item("RespondentID"), respondent.Item("LastName"), respondent.Item("FirstName"), _
                DMI.clsUtil.FormatHTMLAddress(respondent.Item("Address1"), respondent.Item("Address2"), respondent.Item("City"), respondent.Item("State"), respondent.Item("PostalCode")))

        Else
            msg.AppendFormat("<b>*** New Batch ID: {0} ***<b><br>{1}: {2}: {3}<br>Respondent ID: {4}<br>{6} {5}<br>{7}", _
                newBatchID, respondent.Item("SurveyName"), respondent.Item("ClientName"), respondent.Item("SurveyInstanceName"), _
                respondent.Item("RespondentID"), respondent.Item("LastName"), respondent.Item("FirstName"), _
                DMI.clsUtil.FormatHTMLAddress(respondent.Item("Address1"), respondent.Item("Address2"), respondent.Item("City"), respondent.Item("State"), respondent.Item("PostalCode")))

        End If

        Return msg.ToString

    End Function

End Class

Public Class clsBatchHandler
    Public Const BATCH_RESPONDENTID_MAILINGID_REGEX As String = "^(\w+)\-*(\w*)$"

    Private Shared _lock As Object = New Object
    Private _UserID As Integer
    Private _ID As String
    Private _MailingID As String = ""
    Private _PrevBatchID As Integer
    Private _Respondents As clsRespondents

    Public Enum BatchMode As Integer
        ByRespondentID = 0
        ByCRID = 1
    End Enum

    Public Function BatchScan(ByVal scanID As String, ByVal previousBatchID As Integer, ByVal userID As Integer, ByVal returnDate As DateTime, ByVal connection As SqlClient.SqlConnection, Optional ByVal mode As BatchMode = BatchMode.ByRespondentID) As Integer
        Try
            'setup
            _UserID = userID
            _PrevBatchID = previousBatchID
            _Respondents = New clsRespondents(connection)
            ParseScanID(scanID)

            'query database to find respondent
            If mode = BatchMode.ByRespondentID Then
                GetByRespondentID(_ID)
            Else
                GetByCRID(_ID)
            End If

            'validate respondent can be batched
            ValidateRespondent(connection)

            'log successful batch event
            _Respondents.InsertEvent(connection, qmsEvents.BATCH_RESPONDENT, userID, RespondentID, _MailingID)
            _Respondents.InsertEvent(connection, returnDate, qmsEvents.RETURN_DATE, userID, RespondentID)

            'get the next batch id
            RespondentsTable.Rows(0).Item("BatchID") = Batch(RespondentID, previousBatchID, connection)
            Return CInt(RespondentsTable.Rows(0).Item("BatchID"))

        Catch ex As Exception
            Throw ex

        Finally
            _Respondents.Close()

        End Try

    End Function

    Public Function BatchRespondent(ByVal respondentID As Integer, ByVal previousBatchID As Integer, ByVal userID As Integer, ByVal returnDate As DateTime, ByVal connection As SqlClient.SqlConnection, Optional ByVal mode As BatchMode = BatchMode.ByRespondentID) As Integer

        Try
            'setup
            _ID = respondentID.ToString
            _UserID = userID
            _PrevBatchID = previousBatchID
            _Respondents = New clsRespondents(connection)

            _Respondents.FindByRespondentID(respondentID)

            'validate respondent can be batched
            ValidateRespondent(connection)

            'log successful batch event
            _Respondents.InsertEvent(connection, qmsEvents.BATCH_RESPONDENT, userID, respondentID, _MailingID)
            _Respondents.InsertEvent(connection, returnDate, qmsEvents.RETURN_DATE, userID, respondentID)

            'get the next batch id
            RespondentsTable.Rows(0).Item("BatchID") = Batch(respondentID, previousBatchID, connection)
            Return CInt(RespondentsTable.Rows(0).Item("BatchID"))

        Catch ex As Exception
            Throw ex

        Finally
            _Respondents.Close()

        End Try

    End Function

    Public ReadOnly Property RespondentID() As Integer
        Get
            If RespondentsTable.Rows.Count = 1 Then
                Return CInt(RespondentsTable.Rows(0).Item("RespondentID"))
            End If
        End Get
    End Property

    Public ReadOnly Property RespondentsTable() As DataTable
        Get
            Return _Respondents.MainDataTable
        End Get
    End Property

    Public ReadOnly Property RespondentsObj() As clsRespondents
        Get
            Return _Respondents
        End Get
    End Property

    Public ReadOnly Property NewBatch() As Boolean
        Get
            'check if respondent is in a new batch
            Dim respondentDR As DataRow = RespondentsTable.Rows(0)
            Dim newBatchID As Integer = CInt(respondentDR.Item("BatchID"))
            Dim prevBatchID As Integer = _PrevBatchID

            Return (newBatchID <> prevBatchID)

        End Get
    End Property

    Public Property MailingID() As String
        Get
            Return _MailingID
        End Get
        Set(ByVal Value As String)
            _MailingID = Value
        End Set
    End Property

    Private Function Batch(ByVal respondentID As Integer, ByVal previousBatchID As Integer, ByVal connection As SqlClient.SqlConnection) As Integer
        Dim sbSQL As New Text.StringBuilder
        Dim ds As New DataSet
        Dim rNewBatch As DataRow
        Dim rLastBatch As DataRow

        'clear locks on respondent to allow data entry
        sbSQL.AppendFormat("DELETE FROM EventLog WHERE RespondentID = {0} AND EventID IN (2063)", respondentID)
        'TP Change
        SqlHelper.Db(connection.ConnectionString).ExecuteNonQuery(CommandType.Text, sbSQL.ToString)
        'SqlHelper.ExecuteNonQuery(connection, CommandType.Text, sbSQL.ToString)
        sbSQL.Remove(0, sbSQL.Length)

        'Get batch configuration for respondent's survey instance
        sbSQL.Append("SELECT TOP 1 b.GroupBySurvey * b.SurveyID AS SurveyID, b.GroupByClient * b.ClientID AS ClientID, ")
        sbSQL.Append("b.GroupBySurveyInstance * b.SurveyInstanceID AS SurveyInstanceID, ISNULL(r.BatchID,0) AS BatchID ")
        sbSQL.Append("FROM v_Batches b INNER JOIN Respondents r ON b.SurveyInstanceID = r.SurveyInstanceID ")
        sbSQL.AppendFormat("WHERE (r.RespondentID = {0}) ", respondentID)

        'previous batch exists
        If previousBatchID > 0 Then

            'Get batch configuration for last batch id
            sbSQL.Append("; SELECT BatchID, MAX(SurveyID) * MAX(GroupBySurvey) AS SurveyID, MAX(ClientID) * MAX(GroupByClient) AS ClientID, ")
            sbSQL.Append("MAX(SurveyInstanceID) * MAX(GroupBySurveyInstance) AS SurveyInstanceID, MAX(BatchSize) AS BatchSize, ")
            sbSQL.Append("SUM(RespondentCount) AS RespondentCount FROM v_Batches GROUP BY BatchID ")
            sbSQL.AppendFormat("HAVING (BatchID = {0})", previousBatchID)

        End If

        DMI.DataHandler.GetDS(connection, ds, sbSQL.ToString)
        sbSQL.Remove(0, sbSQL.Length)

        SyncLock _lock
            'Does survey instance have batch protocol step
            If ds.Tables(0).Rows.Count > 0 Then
                rNewBatch = ds.Tables(0).Rows(0)

                'previous batch exists, compare batch settings
                If previousBatchID > 0 Then

                    rLastBatch = ds.Tables(1).Rows(0)

                    'do batch survey config match
                    If CInt(rNewBatch.Item("SurveyID")) = CInt(rLastBatch.Item("SurveyID")) Then
                        'do batch client config match
                        If CInt(rNewBatch.Item("ClientID")) = CInt(rLastBatch.Item("ClientID")) Then
                            'do batch survey instance config match
                            If CInt(rNewBatch.Item("SurveyInstanceID")) = CInt(rLastBatch.Item("SurveyInstanceID")) Then
                                'try to batch respondent into last batch
                                sbSQL.AppendFormat("EXEC spBatchSurvey {0}, {1}, {2}", respondentID, previousBatchID, rLastBatch.Item("BatchSize"))
                                ds = Nothing
                                rNewBatch = Nothing
                                rLastBatch = Nothing
                                'TP Change
                                Return CInt(SqlHelper.Db(connection.ConnectionString).ExecuteScalar(CommandType.Text, sbSQL.ToString))
                                'Return CInt(SqlHelper.ExecuteScalar(connection, CommandType.Text, sbSQL.ToString))

                            End If
                        End If
                    End If

                End If

                'batch respondent into new batch
                sbSQL.AppendFormat("EXEC spBatchSurvey {0}, NULL, 0", respondentID)
                ds = Nothing
                rNewBatch = Nothing
                rLastBatch = Nothing
                'TP Change
                Return CInt(SqlHelper.Db(connection.ConnectionString).ExecuteScalar(CommandType.Text, sbSQL.ToString))
                'Return CInt(SqlHelper.ExecuteScalar(connection, CommandType.Text, sbSQL.ToString))

            End If

        End SyncLock

        ds = Nothing
        rNewBatch = Nothing
        rLastBatch = Nothing
        Return -1

    End Function

#Region "Validators"
    Private Sub ValidateRespondent(ByVal connection As SqlClient.SqlConnection)
        'CheckSurveyInstanceIsActive(connection, Me.RespondentID)
        CheckNoRespondentsFound()
        CheckMultiRespondentsFound()
        CheckAlreadyBatched(connection)
        CheckBatchingAllowed(connection)
        CheckIsRespondentBatchFinal(connection)
        CheckHasCompletedSurvey(connection)

    End Sub

    Private Sub CheckNoRespondentsFound()
        'check if no respondents were found
        If RespondentsTable.Rows.Count = 0 Then
            Throw New ApplicationException(String.Format("No respondents found with ID {0}", _ID))
        End If

    End Sub

    Private Sub CheckMultiRespondentsFound()
        'check if more than one respondent was found
        If RespondentsTable.Rows.Count > 1 Then
            Throw New ApplicationException(String.Format("More than one respondents found with ID {0}", _ID))
        End If

    End Sub

    Private Sub CheckAlreadyBatched(ByVal connection As SqlClient.SqlConnection)
        'check if respondent has already been batched
        If Not IsDBNull(RespondentsTable.Rows(0).Item("BatchID")) Then
            'log batch attempt
            _Respondents.InsertEvent(CInt(qmsEvents.BATCHED_ATTEMPT), _UserID, _MailingID)
            Throw New ApplicationException(String.Format("Respondent ({0}) already in batch {1}.", _ID, RespondentsTable.Rows(0).Item("BatchID")))
        End If

    End Sub

    Private Sub CheckBatchingAllowed(ByVal connection As SqlClient.SqlConnection)
        'check if respondent is in a survey instance that allows batching
        Dim protocolID As Integer

        protocolID = _Respondents.ProtocolID(connection, RespondentID)

        If Not clsProtocols.ContainsBatching(connection, protocolID) Then
            Throw New ApplicationException(String.Format("Survey instance for respondent ({0}) does not allow batching", _ID))

        End If

    End Sub

    Private Sub CheckIsRespondentBatchFinal(ByVal connection As SqlClient.SqlConnection)
        'check if respondent is final
        If _Respondents.IsBatchFinal(connection, RespondentID) Then
            'log batch attempt
            _Respondents.InsertEvent(CInt(qmsEvents.BATCHED_ATTEMPT), _UserID, _MailingID)
            Throw New ApplicationException(String.Format("Respondent ({0}) is final and cannot be batched.", _ID))
        End If
    End Sub

    Private Sub CheckHasCompletedSurvey(ByVal connection As SqlClient.SqlConnection)
        'check if respondent has already completed the survey
        If _Respondents.HasCompletedSurvey(connection, RespondentID) Then
            'log batch attempt
            _Respondents.InsertEvent(CInt(qmsEvents.BATCHED_ATTEMPT), _UserID, _MailingID)
            Throw New ApplicationException(String.Format("Respondent ({0}) has already completed survey and cannot be batched.", _ID))
        End If

    End Sub

    Private Sub CheckSurveyInstanceIsActive(ByVal connection As SqlClient.SqlConnection, ByVal respondentID As Integer)
        If Not clsRespondents.InActiveSurveyInstance(connection, respondentID) Then
            Throw New ApplicationException(String.Format("Respondent ({0}) is in an inactive survey instance.", respondentID))
        End If

    End Sub

#End Region

    Private Sub ParseScanID(ByVal scanID As String)
        'separate out the respondent and mailing ids from scan
        Dim rx As Text.RegularExpressions.Regex

        If rx.IsMatch(scanID, BATCH_RESPONDENTID_MAILINGID_REGEX) Then
            Dim match As Text.RegularExpressions.Match = rx.Match(scanID, BATCH_RESPONDENTID_MAILINGID_REGEX)
            If match.Groups(1).Length > 0 Then
                _ID = match.Groups(1).Value
            Else
                Throw New ApplicationException(String.Format("clsBatches.ParseScanID: Unable to find respondent id from scan '{0}'", scanID))
            End If
            If match.Groups(2).Length > 0 Then _MailingID = match.Groups(2).Value

        Else
            Throw New ApplicationException(String.Format("clsBatches.ParseScanID: Unable to parse scan id '{0}'", scanID))

        End If

    End Sub

    Private Sub GetByRespondentID(ByVal lookupID As String)
        'query the database by respondent id
        If IsNumeric(lookupID) Then
            _Respondents.FindByRespondentID(CInt(lookupID))
        Else
            Throw New ApplicationException(String.Format("ID ({0}) must be numeric to search by respondent id", lookupID))
        End If
    End Sub

    Private Sub GetByCRID(ByVal lookupID As String)
        'query the database by client respondent id
        _Respondents.FindByClientRespondentID(lookupID)
    End Sub

    Public Function DisplayVerificationHTMLMsg() As String
        'display batch verfication message in html format
        Dim respondentDR As DataRow = RespondentsTable.Rows(0)
        Dim newBatchID As Integer = CInt(respondentDR.Item("BatchID"))
        Dim prevBatchID As Integer = _PrevBatchID
        Dim msg As New System.Text.StringBuilder

        If newBatchID = prevBatchID Then
            msg.AppendFormat("Batch ID: {0}<br>{1}: {2}: {3}<br>Respondent ID: {4}<br>{6} {5}<br>{7}", _
                newBatchID, respondentDR.Item("SurveyName"), respondentDR.Item("ClientName"), respondentDR.Item("SurveyInstanceName"), _
                respondentDR.Item("RespondentID"), respondentDR.Item("LastName"), respondentDR.Item("FirstName"), _
                DMI.clsUtil.FormatHTMLAddress(respondentDR.Item("Address1"), respondentDR.Item("Address2"), respondentDR.Item("City"), respondentDR.Item("State"), respondentDR.Item("PostalCode")))

        Else
            msg.AppendFormat("<b>*** New Batch ID: {0} ***<b><br>{1}: {2}: {3}<br>Respondent ID: {4}<br>{6} {5}<br>{7}", _
                newBatchID, respondentDR.Item("SurveyName"), respondentDR.Item("ClientName"), respondentDR.Item("SurveyInstanceName"), _
                respondentDR.Item("RespondentID"), respondentDR.Item("LastName"), respondentDR.Item("FirstName"), _
                DMI.clsUtil.FormatHTMLAddress(respondentDR.Item("Address1"), respondentDR.Item("Address2"), respondentDR.Item("City"), respondentDR.Item("State"), respondentDR.Item("PostalCode")))

        End If

        Return msg.ToString

    End Function

End Class