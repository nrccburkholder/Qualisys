Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports DMI
Imports System.Data.Common

Public Enum qmsProtocolStepTypes As Integer
    MAILING = 1
    BATCHING = 2
    DATAENTRY = 3
    VERIFICATION = 4
    CATI = 5
    REMINDER = 6
    EXPORT = 7
    IMPORT = 8
    REPORT = 9
    EMAIL = 10
    OPEN_WEB = 11
    CLOSED_WEB = 12
    INCOMING = 99

End Enum

Public Class clsProtocolSteps
    Inherits DMI.clsDBEntity2

    Private _iProtocolID As Integer = 0
    Private _iProtocolStepTypeID As Integer = 0
    Private _oProtocolStepParams As clsProtocolStepParameters

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
        Dim dr As dsProtocolSteps.SearchRow
        Dim sbSQL As New System.Text.StringBuilder

        dr = CType(drCriteria, dsProtocolSteps.SearchRow)

        'Primary key criteria
        If Not dr.IsProtocolStepIDNull Then sbSQL.AppendFormat("ProtocolStepID = {0} AND ", dr.ProtocolStepID)
        'protocol id criteria
        If Not dr.IsProtocolIDNull Then sbSQL.AppendFormat("ProtocolID = {0} AND ", dr.ProtocolID)
        'name criteria
        If Not dr.IsNameNull Then sbSQL.AppendFormat("Name LIKE {0} AND ", DMI.DataHandler.QuoteString(dr.Name))
        'protocol step type
        If Not dr.IsProtocolStepTypeIDNull Then sbSQL.AppendFormat("ProtocolStepTypeID = {0} AND ", dr.ProtocolStepTypeID)
        'start day
        If Not dr.IsStartDayNull Then sbSQL.AppendFormat("StartDay = {0} AND ", dr.StartDay)

        'Clean up criteria
        If sbSQL.Length > 0 Then
            DMI.clsUtil.Chop(sbSQL, 4)
            sbSQL.Insert(0, "WHERE ")

        End If

        'Add select statement
        sbSQL.Insert(0, "SELECT * FROM ProtocolSteps ")

        Return sbSQL.ToString

    End Function

    Protected Overrides Function DeleteCommand() As System.Data.SqlClient.SqlCommand
        Dim oCmd As SqlClient.SqlCommand

        oCmd = New SqlClient.SqlCommand("delete_ProtocolSteps", Me._oConn)
        oCmd.CommandType = CommandType.StoredProcedure
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@ProtocolStepID", SqlDbType.Int, 4, "ProtocolStepID"))

        Return oCmd

    End Function

    Protected Overrides Sub InitSettings()
        'init class variables
        _ds = New dsProtocolSteps
        _dtMainTable = _ds.Tables("ProtocolSteps")
        _sDeleteFilter = "ProtocolStepID = {0}"

    End Sub

    Protected Overrides Function InsertCommand() As System.Data.SqlClient.SqlCommand
        Dim oCmd As SqlClient.SqlCommand

        oCmd = New SqlClient.SqlCommand("insert_ProtocolSteps", Me._oConn)
        oCmd.CommandType = CommandType.StoredProcedure
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@ProtocolStepID", SqlDbType.Int, 4, "ProtocolStepID"))
        oCmd.Parameters("@ProtocolStepID").Direction = ParameterDirection.Output
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@ProtocolID", SqlDbType.Int, 4, "ProtocolID"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@Name", SqlDbType.VarChar, 100, "Name"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@ProtocolStepTypeID", SqlDbType.Int, 4, "ProtocolStepTypeID"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@StartDay", SqlDbType.Int, 4, "StartDay"))

        Return oCmd

    End Function

    Protected Overrides Sub SetIdentityFilter(ByVal iEntityID As Integer, ByRef drCriteria As System.Data.DataRow)
        drCriteria.Item("ProtocolStepID") = iEntityID

    End Sub

    Protected Overrides Function UpdateCommand() As System.Data.SqlClient.SqlCommand
        Dim oCmd As SqlClient.SqlCommand

        oCmd = New SqlClient.SqlCommand("update_ProtocolSteps", Me._oConn)
        oCmd.CommandType = CommandType.StoredProcedure
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@ProtocolStepID", SqlDbType.Int, 4, "ProtocolStepID"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@ProtocolID", SqlDbType.Int, 4, "ProtocolID"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@Name", SqlDbType.VarChar, 100, "Name"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@ProtocolStepTypeID", SqlDbType.Int, 4, "ProtocolStepTypeID"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@StartDay", SqlDbType.Int, 4, "StartDay"))

        Return oCmd

    End Function

    Protected Overrides Sub SetNewRowDefaults(ByRef dr As System.Data.DataRow)

        dr.Item("ProtocolID") = _iProtocolID
        dr.Item("Name") = ""
        dr.Item("ProtocolStepTypeID") = _iProtocolStepTypeID
        dr.Item("StartDay") = NextStartDay()

    End Sub

    'override delete to handle removal of step parameters
    'otherwise there is a constraint violation
    Public Overrides Function Delete(ByVal sRowFilter As String) As Boolean
        Dim drs As DataRow()
        Dim dr As DataRow
        Dim drParams As DataRow()
        Dim drParam As DataRow

        'check for delete rights
        If Me.CanDelete Then
            drs = _dtMainTable.Select(sRowFilter)

            If drs.Length > 0 Then

                For Each dr In drs
                    'delete step, cascade will delete params
                    dr.Delete()
                    'step delete command will delete params, so do not commit param delete to database - just accept deletes
                    If Not Me._oProtocolStepParams Is Nothing Then _oProtocolStepParams.MainDataTable.AcceptChanges()

                Next

            Else
                Me._sErrorMsg = "No Rows Available For Delete"
                Return False

            End If

            Return True

        Else
            Throw New DMI.dbEntitySecurityException("User does not have delete rights")

        End If

    End Function

    'override to add parameters for new steps
    Public Overloads Overrides Function AddMainRow() As System.Data.DataRow
        Dim dr As DataRow

        'get new step
        dr = MyBase.AddMainRow
        'get params for new step
        ProtocolStepParameters.NewProtocolStepParameters(dr)

        Return dr

    End Function

    'override save to automaticall add parameters for new steps
    Public Overloads Overrides Sub Save()
        'save steps
        MyBase.Save()
        'save step parameters
        If Me._sErrorMsg.Length = 0 AndAlso Not _oProtocolStepParams Is Nothing Then _oProtocolStepParams.Save()

    End Sub

    Protected Overrides Function VerifyInsert(ByVal dr As System.Data.DataRow) As Boolean
        Return VerifyStartDay(dr)

    End Function

    Protected Overrides Function VerifyUpdate(ByVal dr As System.Data.DataRow) As Boolean
        Return VerifyStartDay(dr)

    End Function

#End Region

    Public Property ProtocolID() As Integer
        Get
            Return _iProtocolID

        End Get
        Set(ByVal Value As Integer)
            _iProtocolID = Value

        End Set
    End Property


    Public Property ProtocolStepTypeID() As Integer
        Get
            Return _iProtocolStepTypeID

        End Get
        Set(ByVal Value As Integer)
            _iProtocolStepTypeID = Value

        End Set
    End Property

    Private Function NextStartDay() As Integer
        If _iProtocolID > 0 Then
            Return SqlHelper.ExecuteScalar(_oConn, CommandType.Text, String.Format("SELECT ISNULL(MAX(StartDay) + 1, 1) FROM ProtocolSteps WHERE ProtocolID = {0}", _iProtocolID))

        Else
            Return 0

        End If

    End Function

    Public Property ProtocolStepParameters() As clsProtocolStepParameters
        Get
            Return _oProtocolStepParams

        End Get
        Set(ByVal Value As clsProtocolStepParameters)
            _oProtocolStepParams = Value

        End Set
    End Property

    ''returns array of new rows in datatable
    Private Function GetNewRows(ByVal dt As DataTable) As DataRow()
        Dim drs As DataRow()
        Dim drv As DataRowView
        Dim iCount As Integer = 0

        'get new rows
        MainDataTable.DefaultView.RowStateFilter = DataViewRowState.Added
        'determine how many new rows
        For Each drv In MainDataTable.DefaultView
            iCount += 1

        Next
        If iCount > 0 Then
            'size array
            ReDim drs(iCount - 1)
            'get reference to new rows
            iCount = 0
            For Each drv In MainDataTable.DefaultView
                drs(iCount) = drv.Row
                iCount += 1

            Next

        End If

        MainDataTable.DefaultView.RowStateFilter = DataViewRowState.CurrentRows
        Return drs

    End Function

    Private Sub InitNewStepParams(ByVal drs As DataRow())
        Dim dr As DataRow

        For Each dr In drs
            _oProtocolStepParams.NewProtocolStepParameters(dr)

        Next

        _oProtocolStepParams.Save()

    End Sub

    Private Function VerifyStartDay(ByVal dr As DataRow) As Boolean
        Dim sbSQL As New Text.StringBuilder

        sbSQL.AppendFormat("SELECT COUNT(ProtocolStepID) FROM ProtocolSteps WHERE StartDay = {0} AND ProtocolStepTypeID = {1} AND ProtocolStepID <> {2} AND ProtocolID = {3}", _
            dr.Item("StartDay"), dr.Item("ProtocolStepTypeID"), dr.Item("ProtocolStepID"), dr.Item("ProtocolID"))

        If CInt(SqlHelper.ExecuteScalar(_oConn, CommandType.Text, sbSQL.ToString)) > 0 Then
            'username already in use
            Me._sErrorMsg &= String.Format("Step type {0} already exists on start day {1}. Please change start day.", _
                dr.GetParentRow("ProtocolStepTypesProtocolSteps").Item("Name"), dr.Item("StartDay"))
            Return False

        End If

        Return True

    End Function

#Region "Protocol Step Type Lookup"
    Public Shared Sub FillProtocolStepType(ByVal oConn As SqlClient.SqlConnection, ByVal dt As DataTable)
        Dim da As New SqlClient.SqlDataAdapter("SELECT * FROM ProtocolStepTypes", oConn)

        da.Fill(dt)
        da.Dispose()
        da = Nothing

    End Sub

#End Region

    Public Shared Function GetProtocolStepTypesDataSource(ByVal oConn As SqlClient.SqlConnection) As SqlClient.SqlDataReader
        Return SqlHelper.ExecuteReader(oConn, CommandType.Text, _
            "SELECT * FROM ProtocolStepTypes ORDER BY Name")

    End Function

    Public Shared Function GetSurveyInstanceProtocolSteps(ByVal oConn As SqlClient.SqlConnection, ByVal iProtocolStepTypeID As Integer) As SqlClient.SqlDataReader
        Return SqlHelper.ExecuteReader(oConn, CommandType.Text, _
            String.Format("SELECT CAST(SurveyInstanceID AS varchar) + ',' + CAST(ProtocolStepID AS varchar) AS RowID, CONVERT(varchar(10), StartDate, 1) + ' ' + SurveyName + ': ' + ClientName + ': ' + InstanceName + ': ' + ProtocolStepName AS Name FROM v_SurveyInstanceProtocolSteps WHERE Active = 1 AND Cleared = 0 AND ProtocolStepTypeID = {0} ORDER BY SurveyName, ClientName, InstanceName, StartDate DESC", iProtocolStepTypeID))

    End Function

    Public Shared Function GetProtocolStepsByDay(ByVal connection As SqlClient.SqlConnection, ByVal dtDay As DateTime) As SqlClient.SqlDataReader
        Dim sql As String
        Dim filter As New DMI.DBFilterBag

        filter.AddSelectCustomFilter("ProtocolStepDate", String.Format("(ProtocolStepDate = '{0:d}')", dtDay))
        filter.AddSelectCustomFilter("ProtocolStepTypeID", "(ProtocolStepTypeID NOT IN (2,3,4))")
        filter.AddSelectNumericFilter("Active", "1")
        sql = String.Format("SELECT * FROM vw_SurveyTasks {0}", filter.GenerateWhereClause())

        Return SqlHelper.ExecuteReader(connection, CommandType.Text, sql)

    End Function

    Public Shared Function IsMaxAttemptStep(ByVal connection As SqlClient.SqlConnection, ByVal iProtocolStepID As Integer) As Boolean
        Dim result As Object

        result = SqlHelper.ExecuteScalar(connection, CommandType.Text, _
            "SELECT CAST(ProtocolStepParamValue AS int) FROM ProtocolStepParameters WHERE (ProtocolStepID = @ProtocolStepID) AND (ProtocolStepTypeParamID IN (63, 73))", _
            New SqlClient.SqlParameter("@ProtocolStepID", iProtocolStepID))
        If (Not IsNothing(result) AndAlso Not IsDBNull(result) AndAlso CInt(result) = 1) Then
            Return True
        Else
            Return False
        End If

    End Function
End Class
