Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports DMI
Imports System.Data.Common

Public Class clsDataExtractView
    Inherits DMI.clsProtoDataObject

    Protected _SurveyID As Integer
    Protected _View As DataTable
    Protected _FileDefColumns As clsFileDefColumns
    Protected _ValidatedView As Boolean = False
    Protected _SelectSQL As String = ""
    Public Const RESPONDENT_ID_COLNAME As String = "RESPONDENT_ID"
    Public Const DATA_EXTRACT_NAME_FORMAT As String = "xv_SurveyID_{0}"

    Sub New(ByVal Connection As SqlClient.SqlConnection)
        MyBase.New(Connection)

    End Sub

    Public Property SurveyID() As Integer
        Get
            Return _SurveyID
        End Get
        Set(ByVal Value As Integer)
            If _SurveyID <> Value Then
                Me._ValidatedView = False
                _SurveyID = Value

            End If
        End Set
    End Property

    Public Property ViewTable() As DataTable
        Get
            Return _View
        End Get
        Set(ByVal Value As DataTable)
            _View = Value
        End Set
    End Property

    Public Property FileDefColumns() As clsFileDefColumns
        Get
            Return _FileDefColumns
        End Get
        Set(ByVal Value As clsFileDefColumns)
            _FileDefColumns = Value
        End Set
    End Property

    Public Sub FillTable(ByVal Criteria As DataRow)
        Dim SQL As String

        'Get SELECT SQL statement
        SQL = GetSQL(Criteria)

        'fill datatable
        If Not IsNothing(SQL) And Not IsNothing(_View) Then
            ValidateView()

            Dim da As New SqlClient.SqlDataAdapter
            da.SelectCommand = New SqlClient.SqlCommand(SQL, _Connection)
            da.Fill(Me._View)

            da = Nothing

        End If

    End Sub

    Public Function GetDataReader(ByVal DRConnection As SqlClient.SqlConnection, ByVal Criteria As DataRow) As SqlClient.SqlDataReader
        Dim SQL As String

        'Get SELECT SQL statement
        SQL = GetSQL(Criteria)

        'get datareader
        If SQL.Length > 0 Then
            ValidateView()
            'TP Change
            Return DirectCast(SqlHelper.Db(DRConnection.ConnectionString).ExecuteReader(CommandType.Text, SQL), SqlClient.SqlDataReader)
            'Return SqlHelper.ExecuteReader(DRConnection, CommandType.Text, SQL)
        End If

        'no sql, return nothing
        Return Nothing

    End Function

    Public Function GetDXDataReader(ByVal DRConnection As SqlClient.SqlConnection, ByVal Criteria As DataRow) As SqlClient.SqlDataReader
        Dim SQL As String

        'Get SELECT SQL statement
        SQL = String.Format("{0} r {1} ", GetSELECTSQL(), GetWHERESQL(Criteria))
        SQL = GetSQL(Criteria)

        'get datareader
        If SQL.Length > 0 Then
            ValidateView()
            'TP Change
            Return DirectCast(SqlHelper.Db(DRConnection.ConnectionString).ExecuteReader(CommandType.Text, SQL), SqlClient.SqlDataReader)
            'Return SqlHelper.ExecuteReader(DRConnection, CommandType.Text, SQL)
        End If

        'no sql, return nothing
        Return Nothing

    End Function

    Public Function GetRespondentIdDataReader(ByVal DRConnection As SqlClient.SqlConnection, ByVal Criteria As DataRow) As SqlClient.SqlDataReader
        Dim SQL As String

        'Get SELECT SQL statement
        ' TODO: use data extract view here instead of the vw_respondents
        SQL = String.Format("SELECT RespondentID AS RESPONDENT_ID FROM {0} r {1} ", Me.ViewName(), GetWHERESQL(Criteria))

        'get datareader
        If SQL.Length > 0 Then
            'TP Change
            Return DirectCast(SqlHelper.Db(DRConnection.ConnectionString).ExecuteReader(CommandType.Text, SQL), SqlClient.SqlDataReader)
            'Return SqlHelper.ExecuteReader(DRConnection, CommandType.Text, SQL)
        End If

        'no sql, return nothing
        Return Nothing

    End Function

    '
    Public Function GetDataReaderNoTimeout(ByVal DRConnection As SqlClient.SqlConnection, ByVal Criteria As DataRow) As SqlClient.SqlDataReader
        Dim SQL As String

        'Get SELECT SQL statement
        SQL = GetSQL(Criteria)

        'get datareader
        If SQL.Length > 0 Then
            ValidateView()
            Return SqlHelperNoTimeout.ExecuteReader(DRConnection, CommandType.Text, SQL)
        End If

        'no sql, return nothing
        Return Nothing

    End Function

    Public Function GetDXDataReaderNoTimeout(ByVal DRConnection As SqlClient.SqlConnection, ByVal Criteria As DataRow) As SqlClient.SqlDataReader
        Dim SQL As String

        'Get SELECT SQL statement
        SQL = String.Format("{0} r {1} ", GetSELECTSQL(), GetWHERESQL(Criteria))
        SQL = GetSQL(Criteria)

        'get datareader
        If SQL.Length > 0 Then
            ValidateView()
            Return SqlHelperNoTimeout.ExecuteReader(DRConnection, CommandType.Text, SQL)
        End If

        'no sql, return nothing
        Return Nothing

    End Function

    Public Function GetRespondentIdDataReaderNoTimeout(ByVal DRConnection As SqlClient.SqlConnection, ByVal Criteria As DataRow) As SqlClient.SqlDataReader
        Dim SQL As String

        'Get SELECT SQL statement
        ' TODO: use data extract view here instead of the vw_respondents
        SQL = String.Format("SELECT RespondentID AS RESPONDENT_ID FROM {0} r {1} ", Me.ViewName(), GetWHERESQL(Criteria))

        'get datareader
        If SQL.Length > 0 Then
            Return SqlHelperNoTimeout.ExecuteReader(DRConnection, CommandType.Text, SQL)
        End If

        'no sql, return nothing
        Return Nothing

    End Function

    Public Function GetDXRespondent(ByVal connection As SqlClient.SqlConnection, ByVal respondentID As Integer) As DataRow
        Dim SQL As String
        Dim ds As New DataSet

        'Get SELECT SQL statement
        SQL = String.Format("{0} WHERE RespondentID = {1} ", GetSELECTSQL(), respondentID)

        'get datareader
        ValidateView()
        Return DMI.DataHandler.GetDataRow(SQL, connection)

    End Function

    Protected Sub ValidateView()
        If Me._ValidatedView = False Then
            If CheckBuildView() Then BuildView()
            Me._ValidatedView = True

        End If

    End Sub

    Protected Sub BuildView()
        Dim dr As SqlClient.SqlDataReader
        Dim sqlCreateTable As New Text.StringBuilder
        Dim cmd As New SqlClient.SqlCommand

        Try
            'drop view if it already exists, something changed in the survey so the view needs a rebuild
            'TP Change
            If Me.ViewExists Then SqlHelper.Db(Me._Connection.ConnectionString).ExecuteNonQuery(CommandType.Text, String.Format("drop view [{0}]", Me.ViewName))
            'If Me.ViewExists Then SqlHelper.ExecuteNonQuery(Me._Connection, CommandType.Text, _
            '    String.Format("drop view [{0}]", Me.ViewName))

            'create view
            cmd.Connection = Me._Connection
            cmd.CommandType = CommandType.StoredProcedure
            cmd.CommandText = "create_DXView"
            cmd.Parameters.Add(New SqlClient.SqlParameter("@SurveyID", SurveyID))
            cmd.CommandTimeout = 600

            dr = cmd.ExecuteReader

            'dr = SqlHelper.ExecuteReader(Me._Connection, CommandType.StoredProcedure, _
            '    "create_DXView", _
            '    New SqlClient.SqlParameter("@SurveyID", SurveyID))

            While dr.Read
                sqlCreateTable.Append(dr.Item(0))

            End While
            dr.Close()
            dr = Nothing
            'TP Change
            SqlHelper.Db(Me._Connection.ConnectionString).ExecuteNonQuery(CommandType.Text, sqlCreateTable.ToString)
            'SqlHelper.ExecuteNonQuery(Me._Connection, CommandType.Text, sqlCreateTable.ToString)

        Catch ex As Exception
            Throw ex

        Finally
            If Not IsNothing(dr) Then
                If Not dr.IsClosed Then dr.Close()

            End If

        End Try

    End Sub

    Protected Function CheckBuildView() As Boolean
        'rebuild if view does not exist
        If Not Me.ViewExists Then Return True
        'rebuild if survey has changed
        If Me.SurveyChanged Then Return True

        'view exists and survey has not change, do not rebuild view
        Return False

    End Function

    Protected Function GetSQL(ByVal Criteria As DataRow) As String
        Return String.Format("{0} {1} ", GetSELECTSQL(), GetWHERESQL(Criteria))

    End Function

    Protected Function GetSELECTSQL() As String

        If _SelectSQL.Length = 0 Then
            Dim drv As DataRowView
            Dim dc As New clsDataColumn
            Dim fdc As clsFileDefColumns = FileDefColumns
            Dim SQL As New Text.StringBuilder

            'Always include respondent id
            SQL.AppendFormat("RespondentID AS {0}, ", Me.RESPONDENT_ID_COLNAME)

            'sort file columns in correct order
            fdc.MainDataTable.DefaultView.Sort = "DisplayOrder"

            'now dynamically generate working table
            For Each drv In fdc.MainDataTable.DefaultView
                'set data column name
                dc.FileDefColName = drv.Item("ColumnName").ToString

                If ColumnExists(dc.DestColName) Then
                    'column exists in view
                    SQL.AppendFormat("{0}, ", dc.DestColName)
                Else
                    'column does not exist in view, set value to null
                    SQL.AppendFormat("NULL AS {0}, ", dc.DestColName)
                End If

            Next
            'clean up
            dc = Nothing
            fdc.Close()
            fdc = Nothing

            If SQL.Length > 0 Then
                'remove last comma
                DMI.clsUtil.Chop(SQL, 2)

                'add SELECT... FROM tablename
                SQL.Insert(0, "SELECT ")
                SQL.AppendFormat(" FROM {0} r", ViewName)

            End If

            _SelectSQL = SQL.ToString

        End If

        Return _SelectSQL

    End Function

    Protected Function GetWHERESQL(ByVal Criteria As DataRow) As String
        Dim r As New clsRespondents(_Connection)
        Dim SQL As String = r.GetWhereSQL(Criteria)

        'clean up
        r.Close()
        r = Nothing

        Return SQL

    End Function

    Protected Function ViewExists() As Boolean
        If Not IsNothing(SurveyID) Then
            Dim SQL As String
            SQL = String.Format("SELECT COUNT(*) FROM dbo.sysobjects WHERE name LIKE '{0}' AND OBJECTPROPERTY(id, N'IsView') = 1", ViewName())
            'TP Change
            If CInt(SqlHelper.Db(_Connection.ConnectionString).ExecuteScalar(CommandType.Text, SQL)) > 0 Then Return True
            'If CInt(SqlHelper.ExecuteScalar(_Connection, CommandType.Text, SQL)) > 0 Then Return True
        End If

        Return False

    End Function

    Protected Function ViewName() As String
        If Not IsNothing(SurveyID) Then Return String.Format(DATA_EXTRACT_NAME_FORMAT, SurveyID)
        Return Nothing

    End Function

    Protected Function SurveyChanged() As Boolean
        Dim CreationDate As DateTime = ViewCreationDate()

        If Not IsNothing(CreationDate) Then
            If Not PropertiesChanged(CreationDate) Then
                If Not QuestionsChanged(CreationDate) Then
                    If Not AnswerCategoriesChanged(CreationDate) Then
                        Return False

                    End If
                End If
            End If
        End If

        Return True

    End Function

    Protected Function ViewCreationDate() As DateTime
        If Not IsNothing(SurveyID) Then
            Dim SQL As String
            SQL = String.Format("SELECT crdate FROM dbo.sysobjects WHERE name LIKE '{0}' AND OBJECTPROPERTY(id, N'IsView') = 1", ViewName())
            'TP Change
            Return CDate(SqlHelper.Db(_Connection.ConnectionString).ExecuteScalar(CommandType.Text, SQL))
            'Return CDate(SqlHelper.ExecuteScalar(_Connection, CommandType.Text, SQL))

        End If

        Return Nothing

    End Function

    Protected Function PropertiesChanged(ByVal FromDate As DateTime) As Boolean
        Dim SQL As New Text.StringBuilder

        SQL.Append("SELECT COUNT(*) FROM ")
        SQL.Append("(SELECT MIN(sip.jn_datetime) AS Changed FROM SurveyInstanceProperties_jn sip ")
        SQL.Append("INNER JOIN SurveyInstances si ON sip.SurveyInstanceID = si.SurveyInstanceID ")
        SQL.AppendFormat("WHERE (si.SurveyID = {0}) GROUP BY sip.PropertyName ", SurveyID)
        SQL.AppendFormat("HAVING (MIN(sip.jn_datetime) > CONVERT(DATETIME, '{0:d} {0:t}', 102))) x", FromDate)
        'TP Change
        If CInt(SqlHelper.Db(_Connection.ConnectionString).ExecuteScalar(CommandType.Text, SQL.ToString())) > 0 Then Return True
        'If CInt(SqlHelper.ExecuteScalar(_Connection, CommandType.Text, SQL.ToString)) > 0 Then Return True

        Return False

    End Function

    Protected Function QuestionsChanged(ByVal FromDate As DateTime) As Boolean
        Dim SQL As String

        SQL = String.Format("SELECT COUNT(*) FROM SurveyQuestions_jn WHERE (jn_datetime > CONVERT(DATETIME, '{1:d} {1:t}', 102)) AND (SurveyID = {0})", SurveyID, FromDate)
        'TP Change
        If CInt(SqlHelper.Db(_Connection.ConnectionString).ExecuteScalar(CommandType.Text, SQL)) > 0 Then Return True
        'If CInt(SqlHelper.ExecuteScalar(_Connection, CommandType.Text, SQL)) > 0 Then Return True

        Return False

    End Function

    Protected Function AnswerCategoriesChanged(ByVal FromDate As DateTime) As Boolean
        Dim SQL As String

        SQL = String.Format("SELECT COUNT(*) FROM AnswerCategories_jn WHERE (QuestionID IN (SELECT QuestionID FROM SurveyQuestions WHERE SurveyID = {0})) AND (jn_datetime > CONVERT(DATETIME, '{1:d} {1:t}', 102))", SurveyID, FromDate)
        'TP Change
        If CInt(SqlHelper.Db(_Connection.ConnectionString).ExecuteScalar(CommandType.Text, SQL)) > 0 Then Return True
        'If CInt(SqlHelper.ExecuteScalar(_Connection, CommandType.Text, SQL)) > 0 Then Return True

        Return False

    End Function

    Protected Function ColumnExists(ByVal ColName As String) As Boolean
        Dim ColSQL As New Text.StringBuilder

        ColSQL.Append("SELECT COUNT(*) FROM sysobjects ")
        ColSQL.Append("INNER JOIN syscolumns ON sysobjects.id = syscolumns.id ")
        ColSQL.AppendFormat("WHERE sysobjects.name LIKE {0} ", DMI.DataHandler.QuoteString(ViewName))
        ColSQL.Append("AND OBJECTPROPERTY(sysobjects.id, N'IsView') = 1 ")
        ColSQL.AppendFormat("AND syscolumns.name LIKE {0}", DMI.DataHandler.QuoteString(ColName))
        'TP Change
        If CInt(SqlHelper.Db(_Connection.ConnectionString).ExecuteScalar(CommandType.Text, ColSQL.ToString())) = 1 Then
            Return True
        Else
            Return False
        End If
        'If CInt(SqlHelper.ExecuteScalar(Me._Connection, CommandType.Text, ColSQL.ToString)) = 1 Then
        '    Return True
        'Else
        '    Return False
        'End If

    End Function

    Public Function RespondentCount(ByVal Criteria As DataRow) As Integer
        Dim SQL As String

        ValidateView()

        SQL = String.Format("SELECT COUNT(*) FROM {0} r {1}", ViewName, GetWHERESQL(Criteria))
        'TP Change
        Return CInt(SqlHelper.Db(Me._Connection.ConnectionString).ExecuteScalar(CommandType.Text, SQL))
        'Return CInt(SqlHelper.ExecuteScalar(Me._Connection, CommandType.Text, SQL))

    End Function

End Class
