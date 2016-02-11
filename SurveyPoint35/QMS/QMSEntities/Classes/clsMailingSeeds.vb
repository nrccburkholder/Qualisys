Public Class clsMailingSeeds
    Inherits DMI.clsDBEntity2

    Private m_iSurveyInstanceID As Integer = 0

#Region "dbEntity2 Overrides"

    Public Sub New(ByRef conn As SqlClient.SqlConnection, Optional ByVal iEntityID As Integer = 0, Optional ByVal bFillLookUps As Boolean = False)
        MyBase.New(conn, iEntityID, bFillLookUps)

    End Sub

    Public Sub New(ByRef conn As SqlClient.SqlConnection, ByVal bFillLookUps As Boolean)
        MyBase.New(conn, bFillLookUps)

    End Sub

    Public Sub New(ByRef sConn As String, Optional ByVal iEntityID As Integer = 0, Optional ByVal bFillLookUps As Boolean = True)
        MyBase.New(sConn, iEntityID, bFillLookUps)

    End Sub

    Public Sub New(ByRef sConn As String, ByVal bFillLookUps As Boolean)
        MyBase.New(sConn, bFillLookUps)

    End Sub

    Public Sub New(Optional ByVal iEntityID As Integer = 0, Optional ByVal bFillLookUps As Boolean = False)
        MyBase.New(iEntityID, bFillLookUps)

    End Sub

    Public Sub New(ByVal bFillLookUps As Boolean)
        MyBase.New(bFillLookUps)

    End Sub

    Protected Overrides Sub _FillLookups(ByRef drCriteria As System.Data.DataRow)
        'no lookups
    End Sub

    Protected Overrides Function BuildSelectSQL(ByVal drCriteria As DataRow) As String
        Dim dr As dsMailingSeeds.SearchRow
        Dim sbSQL As New System.Text.StringBuilder()

        dr = CType(drCriteria, dsMailingSeeds.SearchRow)

        sbSQL.Append("MailingSeedFlag = 1 AND ")

        'Primary key criteria
        If Not dr.IsRespondentIDNull Then sbSQL.AppendFormat("RespondentID = {0} AND ", dr.RespondentID)
        If Not dr.IsSurveyInstanceIDNull Then sbSQL.AppendFormat("SurveyInstanceID = {0} AND ", dr.SurveyInstanceID)
        If Not dr.IsSurveyIDNull Then sbSQL.AppendFormat("SurveyInstanceID IN (SELECT SurveyInstanceID FROM SurveyInstances WHERE SurveyID = {0}) AND ", dr.SurveyID)
        If Not dr.IsClientIDNull Then sbSQL.AppendFormat("SurveyInstanceID IN (SELECT SurveyInstanceID FROM SurveyInstances WHERE ClientID = {0}) AND ", dr.ClientID)

        'Clean up criteria
        If sbSQL.Length > 0 Then
            DMI.clsUtil.Chop(sbSQL, 4)
            sbSQL.Insert(0, "WHERE ")

        End If

        'Add select statement
        sbSQL.Insert(0, "SELECT * FROM Respondents ")

        Return sbSQL.ToString

    End Function

    Protected Overrides Function DeleteCommand() As System.Data.SqlClient.SqlCommand
        Dim oCmd As SqlClient.SqlCommand

        oCmd = New SqlClient.SqlCommand("delete_Respondents", Me._oConn)
        oCmd.CommandType = CommandType.StoredProcedure
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@RespondentID", SqlDbType.Int, 4, "RespondentID"))
        oCmd.Parameters("@RespondentID").Direction = ParameterDirection.Input

        Return oCmd

    End Function

    Protected Overrides Sub InitSettings()
        'init class variables
        _ds = New dsMailingSeeds()
        _dtMainTable = _ds.Tables("MailingSeeds")
        _sDeleteFilter = "RespondentID = {0}"

    End Sub

    Protected Overrides Function InsertCommand() As System.Data.SqlClient.SqlCommand
        Dim oCmd As SqlClient.SqlCommand

        oCmd = New SqlClient.SqlCommand("insert_MailingSeeds", Me._oConn)
        oCmd.CommandType = CommandType.StoredProcedure
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@RespondentID", SqlDbType.Int, 4, "RespondentID"))
        oCmd.Parameters("@RespondentID").Direction = ParameterDirection.Output
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@SurveyInstanceID", SqlDbType.Int, 4, "SurveyInstanceID"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@FirstName", SqlDbType.VarChar, 100, "FirstName"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@LastName", SqlDbType.VarChar, 100, "LastName"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@MiddleInitial", SqlDbType.VarChar, 10, "MiddleInitial"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@Address1", SqlDbType.VarChar, 250, "Address1"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@Address2", SqlDbType.VarChar, 250, "Address2"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@City", SqlDbType.VarChar, 100, "City"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@State", SqlDbType.Char, 2, "State"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@PostalCode", SqlDbType.VarChar, 50, "PostalCode"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@TelephoneDay", SqlDbType.VarChar, 50, "TelephoneDay"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@TelephoneEvening", SqlDbType.VarChar, 50, "TelephoneEvening"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@Email", SqlDbType.VarChar, 50, "Email"))

        Return oCmd

    End Function

    Protected Overrides Sub SetIdentityFilter(ByVal iEntityID As Integer, ByRef drCriteria As System.Data.DataRow)
        drCriteria.Item("RespondentID") = iEntityID

    End Sub

    Protected Overrides Function UpdateCommand() As System.Data.SqlClient.SqlCommand
        Dim oCmd As SqlClient.SqlCommand

        oCmd = New SqlClient.SqlCommand("update_MailingSeeds", Me._oConn)
        oCmd.CommandType = CommandType.StoredProcedure
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@RespondentID", SqlDbType.Int, 4, "RespondentID"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@SurveyInstanceID", SqlDbType.Int, 4, "SurveyInstanceID"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@FirstName", SqlDbType.VarChar, 100, "FirstName"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@LastName", SqlDbType.VarChar, 100, "LastName"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@MiddleInitial", SqlDbType.VarChar, 10, "MiddleInitial"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@Address1", SqlDbType.VarChar, 250, "Address1"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@Address2", SqlDbType.VarChar, 250, "Address2"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@City", SqlDbType.VarChar, 100, "City"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@State", SqlDbType.Char, 2, "State"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@PostalCode", SqlDbType.VarChar, 50, "PostalCode"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@TelephoneDay", SqlDbType.VarChar, 50, "TelephoneDay"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@TelephoneEvening", SqlDbType.VarChar, 50, "TelephoneEvening"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@Email", SqlDbType.VarChar, 50, "Email"))

        Return oCmd

    End Function

    Protected Overrides Sub SetNewRowDefaults(ByRef dr As System.Data.DataRow)
        dr.Item("FirstName") = ""
        dr.Item("MiddleInitial") = ""
        dr.Item("LastName") = ""
        dr.Item("Address1") = ""
        dr.Item("Address2") = ""
        dr.Item("City") = ""
        dr.Item("State") = ""
        dr.Item("PostalCode") = ""
        dr.Item("Email") = ""
        dr.Item("SurveyInstanceID") = m_iSurveyInstanceID

    End Sub

#End Region

    Public Property SurveyInstanceID() As Integer
        Get
            Return m_iSurveyInstanceID

        End Get
        Set(ByVal Value As Integer)
            m_iSurveyInstanceID = Value

        End Set
    End Property

End Class
