Public Enum tblBatches
    BatchID = 0
    SurveyID = 1
    ClientID = 2
    SurveyInstanceID = 3
    SurveyName = 4
    ClientName = 5
    SurveyInstanceName = 6
    RespondentCount = 7
    BatchSize = 8
    GroupBySurvey = 9
    GroupByClient = 10
    GroupBySurveyInstance = 11

End Enum

<Obsolete("use QMS.clsBatches", True)> _
Public Class clsBatches

    Sub New(ByVal sConnStr As String, Optional ByVal iEntityID As Integer = 0)
        ConnectionString = sConnStr
        _iEntityID = iEntityID
        Me.InitClass()

    End Sub

    Public ConnectionString As String = ""

    Public _iEntityID As Integer = 0

    Private _dsEntity As DataSet

    Private _sTableName As String

    Private _sSelectSQL As String

    Private _sErrorMsg As String = ""

    Private _iSurveyInstanceID As Integer = 0

    Private _iSurveyID As Integer = 0

    Private _iClientID As Integer = 0

    Default Public Overloads Property Details(ByVal eField As tblBatches) As Object
        Get
            Return Me._dsEntity.Tables(Me._sTableName).Rows(0).Item(eField.ToString)

        End Get

        Set(ByVal Value As Object)
            If eField = tblBatches.BatchID Then
                Me._iEntityID = Value

            ElseIf eField = tblBatches.SurveyInstanceID Then
                Me._iSurveyInstanceID = Value

            ElseIf eField = tblBatches.SurveyID Then
                Me._iSurveyID = Value

            ElseIf eField = tblBatches.ClientID Then
                Me._iClientID = Value

            End If

        End Set

    End Property

    Public Property DataSet() As System.Data.DataSet
        Get
            Return Me._dsEntity

        End Get

        Set(ByVal Value As DataSet)
            Me._dsEntity = Value

            If Me._dsEntity.Tables.IndexOf(Me._sTableName) > -1 Then
                If Me._dsEntity.Tables(Me._sTableName).Rows.Count > 0 Then
                    Me._iEntityID = IIf(Me.Details(tblBatches.BatchID) Is DBNull.Value, 0, Me.Details(tblBatches.BatchID))

                End If
            End If
        End Set

    End Property

    Public ReadOnly Property NamedDataSet(ByVal sName As String) As DataSet
        Get

            If sName.Length > 0 Then Me._dsEntity.DataSetName = sName

            Return Me._dsEntity

        End Get

    End Property


    Public Function VerifyNamedDataSet(ByVal ds As DataSet, ByVal sName As String) As Boolean

        If ds.DataSetName.ToUpper = sName.ToUpper Then
            'signed dataset matches signature
            Me.DataSet = ds
            Return True

        End If

        Return False

    End Function

    Public ReadOnly Property ErrorMsgs() As String
        Get
            Return Me._sErrorMsg
        End Get

    End Property

    Protected Sub InitClass()

        'Define table
        Me._sTableName = "Batches"

        'SELECT SQL
        Me._sSelectSQL = "SELECT BatchID, SurveyID, ClientID, SurveyInstanceID, SurveyName, ClientName, "
        Me._sSelectSQL &= "SurveyInstanceName, ProtocolID, GroupBySurvey, GroupByClient, "
        Me._sSelectSQL &= "GroupBySurveyInstance, BatchSize, RespondentCount FROM v_Batches "

    End Sub

    Public Sub Clear()
        Me._iEntityID = 0
        Me._iClientID = 0
        Me._iSurveyID = 0
        Me._iSurveyInstanceID = 0

    End Sub

    Public Function GetDetails() As DataSet
        Dim sSQL As String

        sSQL = Me.GetSearchSQL()

        If Not IsNothing(Me._dsEntity) Then
            If Me._dsEntity.Tables.IndexOf(Me._sTableName) > -1 Then
                Me._dsEntity.Tables.Remove(Me._sTableName)

            End If

        End If

        If DMI.DataHandler.GetDS(Me.ConnectionString, Me._dsEntity, sSQL, Me._sTableName) Then
            Return Me._dsEntity

        End If

    End Function

    Protected Function GetSearchSQL() As String
        Dim sWHERESQL As String = "BatchID IS NOT NULL AND "
        Dim bIdentity As Boolean = False

        'Identity criteria
        If Me._iEntityID > 0 Then
            sWHERESQL &= String.Format("BatchID = {0} AND ", Me._iEntityID)
            bIdentity = True

        End If

        'If no identity criteria, check other criteria
        If Not bIdentity Then

            If Me._iSurveyInstanceID > 0 Then
                sWHERESQL &= String.Format("SurveyInstanceID = {0} AND ", Me._iSurveyInstanceID)

            End If

            If Me._iSurveyID > 0 Then
                sWHERESQL &= String.Format("SurveyID = {0} AND ", Me._iSurveyID)

            End If

            If Me._iClientID > 0 Then
                sWHERESQL &= String.Format("ClientID = {0} AND ", Me._iClientID)

            End If

        End If

        If sWHERESQL <> "" Then
            sWHERESQL = "WHERE " & sWHERESQL
            sWHERESQL = Left(sWHERESQL, Len(sWHERESQL) - 4)

        End If

        Return Me._sSelectSQL & sWHERESQL

    End Function

    Public Function BatchSurvey(ByVal iRespondentID As Integer, Optional ByVal iLastBatchID As Integer = 0) As Integer
        Dim sSQL As String
        Dim ds As DataSet
        Dim rNewBatch As DataRow
        Dim rLastBatch As DataRow

        'clear errors
        Me._sErrorMsg = ""

        'Get batch configuration for respondent's survey instance
        sSQL = "SELECT TOP 1 b.GroupBySurvey * b.SurveyID AS SurveyID, b.GroupByClient * b.ClientID AS ClientID, "
        sSQL &= "b.GroupBySurveyInstance * b.SurveyInstanceID AS SurveyInstanceID, ISNULL(r.BatchID,0) AS BatchID "
        sSQL &= "FROM v_Batches b INNER JOIN Respondents r ON b.SurveyInstanceID = r.SurveyInstanceID "
        sSQL &= String.Format("WHERE (r.RespondentID = {0}) ", iRespondentID)

        'previous batch exists
        If iLastBatchID > 0 Then

            'Get batch configuration for last batch id
            sSQL &= "; SELECT BatchID, MAX(SurveyID) * MAX(GroupBySurvey) AS SurveyID, MAX(ClientID) * MAX(GroupByClient) AS ClientID, "
            sSQL &= "MAX(SurveyInstanceID) * MAX(GroupBySurveyInstance) AS SurveyInstanceID, MAX(BatchSize) AS BatchSize, "
            sSQL &= "SUM(RespondentCount) AS RespondentCount FROM v_Batches GROUP BY BatchID "
            sSQL &= String.Format("HAVING (BatchID = {0})", iLastBatchID)

        End If

        DMI.DataHandler.GetDS(Me.ConnectionString, ds, sSQL)

        'Does survey instance have batch protocol step
        If ds.Tables(0).Rows.Count > 0 Then
            rNewBatch = ds.Tables(0).Rows(0)

            'check if respondent already batched
            If rNewBatch.Item("BatchID") > 0 Then
                Me._sErrorMsg = String.Format("Respondent {0} already in batch {1}", iRespondentID, rNewBatch.Item("BatchID"))
                Return -1 * rNewBatch.Item("BatchID")

            End If

            'previous batch exists, compare batch settings
            If iLastBatchID > 0 Then

                rLastBatch = ds.Tables(1).Rows(0)

                'do batch survey config match
                If rNewBatch.Item("SurveyID") = rLastBatch.Item("SurveyID") Then
                    'do batch client config match
                    If rNewBatch.Item("ClientID") = rLastBatch.Item("ClientID") Then
                        'do batch survey instance config match
                        If rNewBatch.Item("SurveyInstanceID") = rLastBatch.Item("SurveyInstanceID") Then
                            'try to batch respondent into last batch
                            sSQL = String.Format("EXEC spBatchSurvey {0}, {1}, {2}", iRespondentID, iLastBatchID, rLastBatch.Item("BatchSize"))
                            Return CInt(DMI.SqlHelper.ExecuteScalar(Me.ConnectionString, CommandType.Text, sSQL))

                        End If
                    End If
                End If

            End If

            'batch respondent into new batch
            sSQL = String.Format("EXEC spBatchSurvey {0}, NULL, 0", iRespondentID)
            Return CInt(DMI.SqlHelper.ExecuteScalar(Me.ConnectionString, CommandType.Text, sSQL))

        Else
            Me._sErrorMsg = "Respondent cannot be batched. Respondent's survey instance does not have a batching protocol step."
            Return -1

        End If


    End Function

End Class
