Public Enum tblClients
    ClientID = 0
    Name = 1
    Address1 = 2
    Address2 = 3
    City = 4
    State = 5
    PostalCode = 6
    Telephone = 7
    Fax = 8
    Active = 9
    FormattedAddress = 10

End Enum

<Obsolete("use qms.clsClient")> _
Public Class clsClient
    Inherits clsDBEntity

    Sub New(Optional ByVal sConn As String = "", Optional ByVal iEntityID As Integer = 0)
        MyBase.New(sConn, iEntityID)

    End Sub

    Default Public Overloads Property Details(ByVal eField As tblClients) As Object
        Get
            Return MyBase.Details(eField.ToString)

        End Get

        Set(ByVal Value As Object)
            If eField = tblClients.ClientID Then
                Me._iEntityID = Value

            End If

            MyBase.Details(eField.ToString) = Value

        End Set

    End Property

    Protected Overrides Sub InitClass()

        'Define table
        Me._sTableName = "Clients"

        'INSERT SQL for Users table
        Me._sInsertSQL = "INSERT INTO Clients(Name, Address1, Address2, City, State, PostalCode, Telephone, Fax, Active) "
        Me._sInsertSQL &= "VALUES({1},{2},{3},{4},{5},{6},{7},{8},{9})"

        'UPDATE SQL for Users table
        Me._sUpdateSQL = "UPDATE Clients SET Name = {1}, Address1 = {2}, Address2 = {3}, City = {4}, "
        Me._sUpdateSQL &= "State = {5}, PostalCode = {6}, Telephone = {7}, Fax = {8}, Active = {9} "
        Me._sUpdateSQL &= "WHERE ClientID = {0}"

        'DELETE SQL for Users table
        Me._sDeleteSQL = "DELETE FROM Clients WHERE ClientID = {0}"

        'SELECT SQL for Users table
        Me._sSelectSQL = "SELECT ClientID, Name, Address1, Address2, City, State, PostalCode, Telephone, Fax, Active, FormattedAddress "
        Me._sSelectSQL &= "FROM v_Clients "

    End Sub


    Protected Overrides Function GetSearchSQL() As String
        Dim sWHERESQL As New System.Text.StringBuilder()

        If Me._iEntityID > 0 Then
            sWHERESQL.AppendFormat("ClientID = {0} AND ", Me._iEntityID)

        Else
            If Me.Details(tblClients.Name).ToString.Length > 0 Then
                sWHERESQL.AppendFormat("Name LIKE {0} AND ", DMI.DataHandler.QuoteString(Details(tblClients.Name)))

            End If

            If Me.Details(tblClients.Address1).ToString.Length > 0 Then
                sWHERESQL.AppendFormat("Address1 LIKE {0} AND ", DMI.DataHandler.QuoteString(Details(tblClients.Address1)))

            End If

            If Me.Details(tblClients.Address2).ToString.Length > 0 Then
                sWHERESQL.AppendFormat("Address2 LIKE {0} AND ", DMI.DataHandler.QuoteString(Details(tblClients.Address2)))

            End If

            If Me.Details(tblClients.City).ToString.Length > 0 Then
                sWHERESQL.AppendFormat("City LIKE {0} AND ", DMI.DataHandler.QuoteString(Details(tblClients.City)))

            End If

            If Me.Details(tblClients.State).ToString.Length > 0 Then
                sWHERESQL.AppendFormat("State = {0} AND ", DMI.DataHandler.QuoteString(Details(tblClients.State)))

            End If

            If Me.Details(tblClients.PostalCode).ToString.Length > 0 Then
                sWHERESQL.AppendFormat("PostalCode LIKE {0} AND ", DMI.DataHandler.QuoteString(Details(tblClients.PostalCode)))

            End If

            If Me.Details(tblClients.Telephone).ToString.Length > 0 Then
                sWHERESQL.AppendFormat("Telephone LIKE {0} AND ", DMI.DataHandler.QuoteString(Details(tblClients.Telephone)))

            End If

            If Me.Details(tblClients.Fax).ToString.Length > 0 Then
                sWHERESQL.AppendFormat("Fax LIKE {0} AND ", DMI.DataHandler.QuoteString(Details(tblClients.Fax)))

            End If

            If Me.Details(tblClients.Active).ToString.Length > 0 Then
                sWHERESQL.AppendFormat("Active = {0} AND ", Math.Abs(Details(tblClients.Active)))

            End If

        End If

        If sWHERESQL.Length > 0 Then
            sWHERESQL.Insert(0, "WHERE ")
            sWHERESQL.Remove(sWHERESQL.Length - 4, 4)

        End If

        sWHERESQL.Insert(0, Me._sSelectSQL)
        sWHERESQL.Append("ORDER BY Name")

        Return sWHERESQL.ToString

    End Function

    Protected Overrides Function GetInsertSQL() As String
        Dim sSQL As String

        sSQL = Me._sInsertSQL

        sSQL = String.Format(sSQL, Details(tblClients.ClientID), _
                            DMI.DataHandler.QuoteString(Details(tblClients.Name)), _
                            DMI.DataHandler.QuoteString(Details(tblClients.Address1)), _
                            DMI.DataHandler.QuoteString(Details(tblClients.Address2)), _
                            DMI.DataHandler.QuoteString(Details(tblClients.City)), _
                            DMI.DataHandler.QuoteString(Details(tblClients.State)), _
                            DMI.DataHandler.QuoteString(Details(tblClients.PostalCode)), _
                            DMI.DataHandler.QuoteString(Details(tblClients.Telephone)), _
                            DMI.DataHandler.QuoteString(Details(tblClients.Fax)), _
                            Math.Abs(Details(tblClients.Active)))

        Return sSQL

    End Function

    Protected Overrides Function GetUpdateSQL() As String
        Dim sSQL As String

        sSQL = Me._sUpdateSQL

        sSQL = String.Format(sSQL, Details(tblClients.ClientID), _
                            DMI.DataHandler.QuoteString(Details(tblClients.Name)), _
                            DMI.DataHandler.QuoteString(Details(tblClients.Address1)), _
                            DMI.DataHandler.QuoteString(Details(tblClients.Address2)), _
                            DMI.DataHandler.QuoteString(Details(tblClients.City)), _
                            DMI.DataHandler.QuoteString(Details(tblClients.State)), _
                            DMI.DataHandler.QuoteString(Details(tblClients.PostalCode)), _
                            DMI.DataHandler.QuoteString(Details(tblClients.Telephone)), _
                            DMI.DataHandler.QuoteString(Details(tblClients.Fax)), _
                            Math.Abs(Details(tblClients.Active)))

        Return sSQL

    End Function

    Protected Overrides Function GetDeleteSQL() As String
        Dim sSQL As String

        sSQL = String.Format(Me._sDeleteSQL, Details(tblClients.ClientID))

        Return sSQL

    End Function

    Protected Overrides Sub SetRecordDefaults(ByRef dr As DataRow)
        dr.Item("ClientID") = 0
        dr.Item("Name") = ""
        dr.Item("Address1") = ""
        dr.Item("Address2") = ""
        dr.Item("City") = ""
        dr.Item("State") = ""
        dr.Item("PostalCode") = ""
        dr.Item("Telephone") = ""
        dr.Item("Fax") = ""
        dr.Item("Active") = 1

    End Sub

    Protected Overrides Function VerifyDelete() As String
        Dim sSQL As String

        sSQL = "SELECT COUNT(si.SurveyInstanceID) AS SurveyInstanceCount "
        sSQL &= "FROM SurveyInstances si RIGHT OUTER JOIN Clients c "
        sSQL &= "ON si.ClientID = c.ClientID "
        sSQL &= String.Format("WHERE (c.ClientID = {0}) ", Me._iEntityID)

        If CInt(DMI.SqlHelper.ExecuteScalar(Me.ConnectionString, CommandType.Text, sSQL)) > 0 Then
            Return String.Format("Client id {0} cannot be deleted. Client still has survey instances.\n", Me._iEntityID)

        Else
            Return ""

        End If


    End Function

    Public Function GetSurveyInstances() As DataTable
        Dim q As New clsSurveyInstance(Me.ConnectionString)
        Dim dt As DataTable

        If Me._dsEntity.Tables.IndexOf("SurveyInstances") > -1 Then
            Me._dsEntity.Tables.Remove("SurveyInstances")

        End If

        q.Details(tblSurveyInstances.ClientID) = Me._iEntityID
        dt = q.GetDetails().Tables("SurveyInstances").Copy

        Me._dsEntity.Tables.Add(dt)

        Return dt

    End Function

End Class
