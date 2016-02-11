Imports Microsoft.ApplicationBlocks.Data
Imports DMI
Imports System.Data.Common

<Obsolete("use QMS.clshousehold")> _
Public Class clsHouseholdOld
    Private _sbUpdateFields As New Text.StringBuilder

    'update fields
    Public Enum field
        Address1 = 1
        Address2 = 2
        City = 3
        State = 4
        PostalCode = 5
        TelephoneDay = 6
        TelephoneEvening = 7

    End Enum

    'returns datatable of other respondents in household
    Public Shared Sub GetHousehold(ByVal iRespondentID As Integer, ByRef ds As Data.DataSet)
        Dim sbSQL As New Text.StringBuilder

        sbSQL.AppendFormat("EXEC spGetHousehold {0}", iRespondentID)

        If ds.Tables.Contains("Household") Then ds.Tables.Remove("Household")

        DMI.DataHandler.GetDS(DMI.DataHandler.sConnection, ds, sbSQL.ToString, "Household")

        sbSQL = Nothing

    End Sub

    'insert event code for everyone in household
    Public Shared Sub InsertEvent(ByVal iRespondentID As Integer, ByVal iEventID As Integer, ByVal iUserID As Integer, Optional ByVal sParam As String = "")

        SqlHelper.ExecuteNonQuery(DMI.DataHandler.sConnection, CommandType.StoredProcedure, _
            "spInsertHouseholdEventLog", _
            New SqlClient.SqlParameter("@RespondentID", iRespondentID), _
            New SqlClient.SqlParameter("@EventID", iEventID), _
            New SqlClient.SqlParameter("@UserID", iUserID), _
            New SqlClient.SqlParameter("@EventParameters", sParam))

    End Sub

    'clear update fields
    Public Sub ClearUpdate()
        _sbUpdateFields.Remove(0, _sbUpdateFields.Length)

    End Sub

    'adds field values to be updated for entire household
    Public Sub AddUpdateField(ByVal FieldName As field, ByVal sFieldValue As String)
        Dim sTemplate As String

        If _sbUpdateFields.Length > 0 Then
            sTemplate = ", {0} = {1}"
        Else
            sTemplate = "{0} = {1}"
        End If

        _sbUpdateFields.AppendFormat(sTemplate, FieldName.ToString, DMI.DataHandler.QuoteString(sFieldValue))

    End Sub

    'updates address and telephone fields for a household
    Public Sub UpdateHousehold(ByVal iRespondentID As Integer)
        Dim sbSQL As New Text.StringBuilder
        Dim dr As SqlClient.SqlDataReader
        'Dim ds As New DataSet()
        'Dim dr As DataRow

        'check if there are fields to update
        If _sbUpdateFields.Length > 0 Then
            'build update sql
            sbSQL.AppendFormat("UPDATE Respondents SET {0} WHERE RespondentID IN (-1", _sbUpdateFields.ToString)

            'append household respondent ids to update criteria
            dr = SqlHelper.ExecuteReader(DMI.DataHandler.sConnection, CommandType.StoredProcedure, _
                "spGetHousehold", New SqlClient.SqlParameter("@RespondentID", iRespondentID))

            Do Until Not dr.Read()
                sbSQL.AppendFormat(",{0}", dr.Item("RespondentID"))
            Loop

            sbSQL.Append(")")

            'execute update
            SqlHelper.ExecuteNonQuery(DMI.DataHandler.sConnection, CommandType.Text, sbSQL.ToString)

        End If

        'clean up
        If Not IsNothing(dr) Then dr.Close()
        dr = Nothing
        sbSQL = Nothing

    End Sub

End Class
