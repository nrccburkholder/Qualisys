Imports DMI
Imports System.Data.Common

Public Class clsTelephoneAppointment
    Inherits DMI.clsDBEntity2

    Public Sub New(ByRef conn As SqlClient.SqlConnection)
        MyBase.New(conn)

    End Sub

    Public Sub New(ByRef conn As String)
        MyBase.New(conn)

    End Sub

    Protected Overrides Sub _FillLookups(ByRef drCriteria As System.Data.DataRow)
        'none
    End Sub

    Protected Overrides Function BuildSelectSQL(ByVal drCriteria As System.Data.DataRow) As String
        Dim dr As dsTelephoneAppointments.SearchRow
        Dim sbSQL As New Text.StringBuilder

        dr = CType(drCriteria, dsTelephoneAppointments.SearchRow)
        If Not dr.IsAppointmentDateStartNull Then sbSQL.AppendFormat("AppointmentDate >= '{0:d}' AND ", dr.AppointmentDateStart)
        If Not dr.IsAppointmentDateEndNull Then sbSQL.AppendFormat("AppointmentDate <= '{0:d}' AND ", dr.AppointmentDateEnd)
        If Not dr.IsClientIDNull Then sbSQL.AppendFormat("ClientID = {0} AND ", dr.ClientID)
        If Not dr.IsRespondentIDNull Then sbSQL.AppendFormat("RespondentID = {0} AND ", dr.RespondentID)
        If Not dr.IsSurveyIDNull Then sbSQL.AppendFormat("SurveyID = {0} AND ", dr.SurveyID)
        If Not dr.IsSurveyInstanceIDNull Then sbSQL.AppendFormat("SurveyInstanceID = {0} AND ", dr.SurveyInstanceID)

        'Clean up criteria
        If sbSQL.Length > 0 Then
            DMI.clsUtil.Chop(sbSQL, 4)
            sbSQL.Insert(0, "WHERE ")

        End If

        'Add select statement
        sbSQL.Insert(0, "SELECT * FROM vw_TelephoneAppointments ")

        Return sbSQL.ToString

    End Function

    Protected Overrides Function DeleteCommand() As System.Data.SqlClient.SqlCommand
        'none, read-only object

    End Function

    Protected Overrides Sub InitSettings()
        'init class variables
        _ds = New dsTelephoneAppointments
        _dtMainTable = _ds.Tables("TelephoneAppointments")
        _sDeleteFilter = "RespondentID = {0}"

    End Sub

    Protected Overrides Function InsertCommand() As System.Data.SqlClient.SqlCommand
        'none, read-only object

    End Function

    Protected Overrides Sub SetIdentityFilter(ByVal iEntityID As Integer, ByRef drCriteria As System.Data.DataRow)
        drCriteria.Item("RespondentID") = iEntityID

    End Sub

    Protected Overrides Function UpdateCommand() As System.Data.SqlClient.SqlCommand
        'none, read-only object

    End Function
End Class
