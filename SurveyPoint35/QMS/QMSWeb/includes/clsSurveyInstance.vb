Public Enum tblSurveyInstances
    SurveyInstanceID = 0
    SurveyID = 1
    ClientID = 2
    ProtocolID = 3
    Name = 4
    InstanceDate = 5
    StartDate = 6
    Active = 7
    GroupByHousehold = 8
    Keyword = 9
    SurveyName = 10
    ClientName = 11
    ProtocolName = 12
    FormattedSurveyInstanceName = 13

End Enum

<Obsolete("Use QMS.clsSurveyInstance")> _
Public Class clsSurveyInstance
    Inherits clsDBEntity

    Protected _iClientID As Integer = 0

    Protected _iSurveyID As Integer = 0

    Protected _iProtocolID As Integer = 0

    Protected _sKeyword As String = ""

    Sub New(Optional ByVal sConn As String = "", Optional ByVal iEntityID As Integer = 0)
        MyBase.New(sConn, iEntityID)

    End Sub

    Default Public Overloads Property Details(ByVal eField As tblSurveyInstances) As Object
        Get
            If eField = tblSurveyInstances.Keyword Then
                Return Me._sKeyword

            End If

            Return MyBase.Details(eField.ToString)

        End Get

        Set(ByVal Value As Object)
            If eField = tblSurveyInstances.SurveyInstanceID Then
                Me._iEntityID = Value

            ElseIf eField = tblSurveyInstances.ClientID Then
                Me._iClientID = Value

            ElseIf eField = tblSurveyInstances.SurveyID Then
                Me._iSurveyID = Value

            ElseIf eField = tblSurveyInstances.ProtocolID Then
                Me._iProtocolID = Value

            ElseIf eField = tblSurveyInstances.Keyword Then
                Me._sKeyword = Value
                Return

            End If

            MyBase.Details(eField.ToString) = Value

        End Set

    End Property

    Public Overrides Property DataSet() As System.Data.DataSet
        Get
            Return Me._dsEntity

        End Get

        Set(ByVal Value As DataSet)
            Me._dsEntity = Value

            If Me._dsEntity.Tables.IndexOf(Me._sTableName) > -1 Then
                If Me._dsEntity.Tables(Me._sTableName).Rows.Count > 0 Then
                    Me._iEntityID = Me.Details(tblSurveyInstances.SurveyInstanceID)
                    Me._iClientID = Me.Details(tblSurveyInstances.ClientID)
                    Me._iSurveyID = Me.Details(tblSurveyInstances.SurveyID)
                    Me._iProtocolID = Me.Details(tblSurveyInstances.ProtocolID)

                End If
            End If
        End Set

    End Property

    Protected Overrides Sub InitClass()

        'Define table
        Me._sTableName = "SurveyInstances"

        'INSERT SQL for Users table
        Me._sInsertSQL = "INSERT INTO SurveyInstances(SurveyID, ClientID, ProtocolID, Name, InstanceDate, StartDate, Active, GroupByHousehold) "
        Me._sInsertSQL &= "VALUES({1},{2},{3},{4},{5},{6},{7},{8})"

        'UPDATE SQL for Users table
        Me._sUpdateSQL = "UPDATE SurveyInstances SET SurveyID = {1}, ClientID = {2}, ProtocolID = {3}, Name = {4}, "
        Me._sUpdateSQL &= "InstanceDate = {5}, StartDate = {6}, Active = {7}, GroupByHousehold = {8} "
        Me._sUpdateSQL &= "WHERE SurveyInstanceID = {0}"

        'DELETE SQL for Users table
        Me._sDeleteSQL = "DELETE FROM SurveyInstanceEvents WHERE SurveyInstanceID = {0}; "
        Me._sDeleteSQL &= "DELETE FROM SurveyInstances WHERE SurveyInstanceID = {0} "

        'SELECT SQL for Users table
        Me._sSelectSQL = "SELECT si.SurveyInstanceID, si.SurveyID, si.ClientID, si.ProtocolID, si.Name, si.InstanceDate, si.StartDate, si.Active, si.GroupByHousehold, c.Name AS ClientName, "
        Me._sSelectSQL &= "s.Name AS SurveyName, p.Name AS ProtocolName, s.Name + ':' + c.Name + ':' + si.Name AS FormattedSurveyInstanceName "
        Me._sSelectSQL &= "FROM SurveyInstances si INNER JOIN "
        Me._sSelectSQL &= "Clients c ON si.ClientID = c.ClientID INNER JOIN "
        Me._sSelectSQL &= "Protocols p ON si.ProtocolID = p.ProtocolID INNER JOIN "
        Me._sSelectSQL &= "Surveys s ON si.SurveyID = s.SurveyID "

    End Sub


    Protected Overrides Function GetSearchSQL() As String
        Dim sWHERESQL As New System.Text.StringBuilder()

        If Me._iEntityID > 0 Then
            sWHERESQL.AppendFormat("si.SurveyInstanceID = {0} AND ", Me._iEntityID)

        Else

            If Not IsDBNull(Me.Details(tblSurveyInstances.SurveyID)) Then
                sWHERESQL.AppendFormat("si.SurveyID = {0} AND ", Details(tblSurveyInstances.SurveyID))

            End If

            If Not IsDBNull(Me.Details(tblSurveyInstances.ClientID)) Then
                sWHERESQL.AppendFormat("si.ClientID = {0} AND ", Details(tblSurveyInstances.ClientID))

            End If

            If Not IsDBNull(Me.Details(tblSurveyInstances.ProtocolID)) Then
                sWHERESQL.AppendFormat("si.ProtocolID = {0} AND ", Details(tblSurveyInstances.ProtocolID))

            End If

            If Me.Details(tblSurveyInstances.Name).ToString.Length > 0 Then
                sWHERESQL.AppendFormat("si.Name LIKE {0} AND ", DMI.DataHandler.QuoteString(Details(tblSurveyInstances.Name)))

            End If

            If Me.Details(tblSurveyInstances.Active).ToString.Length > 0 Then
                sWHERESQL.AppendFormat("si.Active = {0} AND ", Math.Abs(Details(tblSurveyInstances.Active)))

            End If

            If Me.Details(tblSurveyInstances.GroupByHousehold).ToString.Length > 0 Then
                sWHERESQL.AppendFormat("si.GroupByHousehold = {0} AND ", Math.Abs(Details(tblSurveyInstances.GroupByHousehold)))

            End If

            If Me._sKeyword <> "" Then
                sWHERESQL.AppendFormat("si.Name + ' ' + s.Name + ' ' + c.Name LIKE {0}", Me._sKeyword)
            End If

        End If

        If sWHERESQL.Length > 0 Then
            sWHERESQL.Insert(0, "WHERE ")
            sWHERESQL.Remove(sWHERESQL.Length - 4, 4)

        End If

        sWHERESQL.Insert(0, Me._sSelectSQL)
        sWHERESQL.Append("ORDER BY FormattedSurveyInstanceName")

        Return sWHERESQL.ToString

    End Function

    Protected Overrides Function GetInsertSQL() As String
        Dim sSQL As String

        sSQL = Me._sInsertSQL

        sSQL = String.Format(sSQL, Details(tblSurveyInstances.SurveyInstanceID), _
                            Details(tblSurveyInstances.SurveyID), _
                            Details(tblSurveyInstances.ClientID), _
                            Details(tblSurveyInstances.ProtocolID), _
                            DMI.DataHandler.QuoteString(Details(tblSurveyInstances.Name)), _
                            DMI.DataHandler.QuoteString(Details(tblSurveyInstances.InstanceDate)), _
                            DMI.DataHandler.QuoteString(Details(tblSurveyInstances.StartDate)), _
                            Math.Abs(Details(tblSurveyInstances.Active)), _
                            Math.Abs(Details(tblSurveyInstances.GroupByHousehold)))

        Return sSQL

    End Function

    Protected Overrides Function GetUpdateSQL() As String
        Dim sSQL As String

        sSQL = Me._sUpdateSQL

        sSQL = String.Format(sSQL, Details(tblSurveyInstances.SurveyInstanceID), _
                            Details(tblSurveyInstances.SurveyID), _
                            Details(tblSurveyInstances.ClientID), _
                            Details(tblSurveyInstances.ProtocolID), _
                            DMI.DataHandler.QuoteString(Details(tblSurveyInstances.Name)), _
                            DMI.DataHandler.QuoteString(Details(tblSurveyInstances.InstanceDate)), _
                            DMI.DataHandler.QuoteString(Details(tblSurveyInstances.StartDate)), _
                            Math.Abs(Details(tblSurveyInstances.Active)), _
                            Math.Abs(Details(tblSurveyInstances.GroupByHousehold)))

        Return sSQL

    End Function

    Protected Overrides Function GetDeleteSQL() As String
        Dim sSQL As String

        sSQL = String.Format(Me._sDeleteSQL, Details(tblSurveyInstances.SurveyInstanceID))

        Return sSQL

    End Function

    Protected Overrides Sub SetRecordDefaults(ByRef dr As DataRow)
        dr.Item("SurveyInstanceID") = 0
        dr.Item("SurveyID") = Me._iSurveyID
        dr.Item("ClientID") = Me._iClientID
        dr.Item("ProtocolID") = Me._iProtocolID
        dr.Item("Name") = ""
        dr.Item("InstanceDate") = String.Format("{0:d}", Now())
        dr.Item("StartDate") = String.Format("{0:d}", Now())
        dr.Item("Active") = 1
        dr.Item("GroupByHousehold") = 0

    End Sub

    Protected Overrides Function VerifyDelete() As String
        Dim sSQL As String
        Dim ds As DataSet

        sSQL = "SELECT si.Active, COUNT(r.RespondentID) AS RespondentCount "
        sSQL &= "FROM SurveyInstances si LEFT OUTER JOIN "
        sSQL &= "Respondents r ON si.SurveyInstanceID = r.SurveyInstanceID "
        sSQL &= String.Format("WHERE si.SurveyInstanceID = {0} GROUP BY si.Active ", Me._iEntityID)

        If DMI.DataHandler.GetDS(Me.ConnectionString, ds, sSQL) Then
            If ds.Tables(0).Rows(0).Item("Active") = 0 Then
                If ds.Tables(0).Rows(0).Item("RespondentCount") = 0 Then
                    Return ""

                Else
                    Return String.Format("Survey instance id {0} cannot be deleted. Survey instance has respondents in system.\n", Me._iEntityID)

                End If
            Else
                Return String.Format("Survey instance id {0} cannot be deleted. Survey instance still active.\n", Me._iEntityID)

            End If
        End If

        Return "Problems verifying delete."

    End Function

    Protected Overrides Function Create() As DataSet
        Dim ds As DataSet
        Dim sSQL As String

        If Not IsDBNull(Details(tblSurveyInstances.ClientID)) And _
                Not IsDBNull(Details(tblSurveyInstances.SurveyID)) Then

            If Details(tblSurveyInstances.ClientID) > 0 And _
                Details(tblSurveyInstances.SurveyID) > 0 Then

                sSQL = "SELECT 0 AS SurveyInstanceID, s.SurveyID, c.ClientID, 0 AS ProtocolID, '' AS Name, GETDATE() AS InstanceDate, GETDATE() AS StartDate, "
                sSQL &= "1 AS Active, 0 As GroupByHousehold, c.Name AS ClientName, s.Name AS SurveyName "
                sSQL &= "FROM Surveys s CROSS JOIN Clients c "
                sSQL &= String.Format("WHERE (s.SurveyID = {0}) AND (c.ClientID = {1}) ", _
                    Details(tblSurveyInstances.SurveyID), _
                    Details(tblSurveyInstances.ClientID))

                If Not Me._dsEntity Is Nothing Then
                    Me._dsEntity = Nothing
                End If

                If DMI.DataHandler.GetDS(Me.ConnectionString, Me._dsEntity, sSQL, Me._sTableName) Then
                    Me._iEntityID = -1

                    Return Me._dsEntity

                End If

            End If

        End If

        Return MyBase.Create()

    End Function

    'Insert survey instance events for a survey instance
    Public Sub InitSurveyInstanceEvents()
        Dim sSQL As String

        If Me._iEntityID > 0 Then
            sSQL = "DELETE FROM SurveyInstanceEvents WHERE SurveyInstanceID = {0}; "
            sSQL &= "INSERT INTO SurveyInstanceEvents (SurveyInstanceID, EventID, TranslationValue, Final, NonContactHours) "
            sSQL &= "SELECT SurveyInstanceID, EventID, TranslationValue, Final, NonContactHours FROM v_SurveyInstanceEvents "
            sSQL &= "WHERE SurveyInstanceID ={0} "
            sSQL = String.Format(sSQL, Me._iEntityID)

            DMI.SqlHelper.ExecuteNonQuery(Me.ConnectionString, CommandType.Text, sSQL)

        End If

    End Sub

    Public Function Copy(ByVal iSurveyInstanceID) As Integer
        Dim sSQL As String
        Dim iNewSurveyInstanceID As Integer

        'copy survey instance record
        sSQL = "INSERT INTO SurveyInstances (SurveyID, ClientID, ProtocolID, Name, InstanceDate, StartDate, Active, GroupByHousehold) "
        sSQL &= "SELECT SurveyID, ClientID, ProtocolID, 'Copy of ' + Name, InstanceDate, GETDATE(), Active, GroupByHousehold FROM SurveyInstances "
        sSQL &= "WHERE SurveyInstanceID = {0}; SELECT ISNULL(@@IDENTITY,0) "
        sSQL = String.Format(sSQL, iSurveyInstanceID)
        iNewSurveyInstanceID = CInt(DMI.SqlHelper.ExecuteScalar(Me.ConnectionString, CommandType.Text, sSQL))

        'copy survey instance event records
        sSQL = "INSERT INTO SurveyInstanceEvents (SurveyInstanceID, EventID, TranslationValue, Final, NonContactHours) "
        sSQL &= "SELECT {1}, EventID, TranslationValue, Final, NonContactHours FROM SurveyInstanceEvents "
        sSQL &= "WHERE SurveyInstanceID = {0} "
        sSQL = String.Format(sSQL, iSurveyInstanceID, iNewSurveyInstanceID)
        DMI.SqlHelper.ExecuteNonQuery(Me.ConnectionString, CommandType.Text, sSQL)

        'copy mailing seed records
        sSQL = "INSERT INTO Respondents (SurveyInstanceID, FirstName, MiddleInitial, LastName, Address1, Address2, City, State, PostalCode) "
        sSQL &= "SELECT {1}, FirstName, MiddleInitial, LastName, Address1, Address2, City, State, PostalCode FROM Respondents "
        sSQL &= "WHERE SurveyInstanceID = {0} AND MailingSeedFlag = 1"
        sSQL = String.Format(sSQL, iSurveyInstanceID, iNewSurveyInstanceID)
        DMI.SqlHelper.ExecuteNonQuery(Me.ConnectionString, CommandType.Text, sSQL)

        Return iNewSurveyInstanceID

    End Function

End Class
