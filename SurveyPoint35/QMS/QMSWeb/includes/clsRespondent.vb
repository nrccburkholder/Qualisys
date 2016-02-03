Public Enum tblRespondents
    RespondentID = 0
    SurveyInstanceID = 1
    FirstName = 2
    MiddleInitial = 3
    LastName = 4
    Address1 = 5
    Address2 = 6
    City = 7
    State = 8
    PostalCode = 9
    TelephoneDay = 10
    TelephoneEvening = 11
    Email = 12
    DOB = 13
    Gender = 14
    ClientRespondentID = 15
    SSN = 16
    BatchID = 17
    SurveyInstanceName = 18
    ClientName = 19
    SurveyName = 20
    ClientID = 21
    SurveyID = 22
    FormattedName = 23
    FormattedAddress = 24
    GroupByHousehold = 25
    Name = 26
    Telephone = 27

End Enum

<Obsolete("Use QMS.clsRespondents")> _
Public Class clsRespondents
    Inherits clsDBEntity

    Sub New(Optional ByVal sConn As String = "", Optional ByVal iEntityID As Integer = 0)
        MyBase.New(sConn, iEntityID)

    End Sub

    Private _sName As String = ""

    Private _sTelephone As String = ""

    Private _iClientID As Integer = 0

    Private _iSurveyID As Integer = 0

    Private _oProperties As clsRespondentProperties

    Default Public Overloads Property Details(ByVal eField As tblRespondents) As Object
        Get
            If eField = tblRespondents.Name Then
                Return Me._sName

            ElseIf eField = tblRespondents.Telephone Then
                Return Me._sTelephone

            ElseIf eField = tblRespondents.ClientID Then
                Return Me._iClientID

            ElseIf eField = tblRespondents.SurveyID Then
                Return Me._iSurveyID

            End If

            Return MyBase.Details(eField.ToString)

        End Get

        Set(ByVal Value As Object)
            If eField = tblRespondents.RespondentID Then
                Me._iEntityID = Value

            ElseIf eField = tblRespondents.Name Then
                Me._sName = Value
                Return

            ElseIf eField = tblRespondents.Telephone Then
                Me._sTelephone = Value
                Return

            ElseIf eField = tblRespondents.ClientID Then
                Me._iClientID = Value
                Return

            ElseIf eField = tblRespondents.SurveyID Then
                Me._iSurveyID = Value
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
                    Me._iEntityID = Me.Details(tblRespondents.RespondentID)

                End If
            End If
        End Set

    End Property

    Protected Overrides Sub InitClass()

        'Define table
        Me._sTableName = "Respondents"

        'INSERT SQL
        Me._sInsertSQL = "INSERT INTO Respondents (SurveyInstanceID, FirstName, MiddleInitial, LastName, Address1, Address2, City, State, PostalCode, TelephoneDay, TelephoneEvening, Email, DOB, Gender, ClientRespondentID, SSN, BatchID, MailingSeedFlag ) "
        Me._sInsertSQL &= "VALUES({1}, {2}, {3}, {4}, {5}, {6}, {7}, {8}, {9}, {10}, {11}, {12}, {13}, {14}, {15}, {16}, 0)"

        'UPDATE SQL
        Me._sUpdateSQL = "UPDATE Respondents SET FirstName = {2}, MiddleInitial = {3}, LastName = {4}, "
        Me._sUpdateSQL &= "Address1 = {5}, Address2 = {6}, City = {7}, State = {8}, PostalCode = {9}, "
        Me._sUpdateSQL &= "TelephoneDay = {10}, TelephoneEvening = {11}, Email = {12}, DOB = {13}, Gender = {14}, ClientRespondentID = {15}, SSN = {16}, BatchID = {17} "
        Me._sUpdateSQL &= "WHERE RespondentID = {0}"

        'DELETE SQL
        Me._sDeleteSQL = "DELETE FROM Respondents WHERE RespondentID = {0}"

        'SELECT SQL
        Me._sSelectSQL = "SELECT RespondentID, SurveyInstanceID, FirstName, MiddleInitial, LastName, Address1, Address2, City, State, PostalCode, TelephoneDay, "
        Me._sSelectSQL &= "TelephoneEvening, Email, DOB, Gender, ClientRespondentID, SSN, BatchID, SurveyInstanceName, ClientName, SurveyName, ClientID, SurveyID, "
        Me._sSelectSQL &= "FormattedName, FormattedAddress, GroupByHousehold FROM v_Respondents "

    End Sub


    Protected Overrides Function GetSearchSQL() As String
        Dim sWHERESQL As String = ""
        Dim bIdentity As Boolean = False

        'Identity criteria
        If Me._iEntityID > 0 Then
            sWHERESQL &= String.Format("RespondentID = {0} AND ", Me._iEntityID)
            bIdentity = True

        End If

        'If no identity criteria, check other criteria
        If Not bIdentity Then

            If Not IsDBNull(Me.Details(tblRespondents.SurveyInstanceID)) Then
                If Me.Details(tblRespondents.SurveyInstanceID) > 0 Then
                    sWHERESQL &= String.Format("SurveyInstanceID = {0} AND ", Details(tblRespondents.SurveyInstanceID))

                End If

            End If

            If Me._sName <> "" Then
                sWHERESQL &= String.Format("FirstName + ' ' + MiddleInitial + ' ' + LastName LIKE {0} AND ", DMI.DataHandler.QuoteString(Me._sName))

            End If

            If Me.Details(tblRespondents.FirstName).ToString.Length > 0 Then
                sWHERESQL &= String.Format("FirstName LIKE {0} AND ", DMI.DataHandler.QuoteString(Details(tblRespondents.FirstName)))

            End If

            If Me.Details(tblRespondents.MiddleInitial).ToString.Length > 0 Then
                sWHERESQL &= String.Format("MiddleInitial LIKE {0} AND ", DMI.DataHandler.QuoteString(Details(tblRespondents.MiddleInitial)))

            End If

            If Me.Details(tblRespondents.LastName).ToString.Length > 0 Then
                sWHERESQL &= String.Format("LastName LIKE {0} AND ", DMI.DataHandler.QuoteString(Details(tblRespondents.LastName)))

            End If

            If Me.Details(tblRespondents.Address1).ToString.Length > 0 Then
                sWHERESQL &= String.Format("Address1 LIKE {0} AND ", DMI.DataHandler.QuoteString(Details(tblRespondents.Address1)))

            End If

            If Me.Details(tblRespondents.Address2).ToString.Length > 0 Then
                sWHERESQL &= String.Format("Address2 LIKE {0} AND ", DMI.DataHandler.QuoteString(Details(tblRespondents.Address2)))

            End If

            If Me.Details(tblRespondents.City).ToString.Length > 0 Then
                sWHERESQL &= String.Format("City LIKE {0} AND ", DMI.DataHandler.QuoteString(Details(tblRespondents.City)))

            End If

            If Me.Details(tblRespondents.State).ToString.Length > 0 Then
                sWHERESQL &= String.Format("State = {0} AND ", DMI.DataHandler.QuoteString(Details(tblRespondents.State)))

            End If

            If Me.Details(tblRespondents.PostalCode).ToString.Length > 0 Then
                sWHERESQL &= String.Format("PostalCode LIKE {0} AND ", DMI.DataHandler.QuoteString(Details(tblRespondents.PostalCode)))

            End If

            If Me._sName.Length > 0 Then
                sWHERESQL &= String.Format("FormattedName LIKE {0} AND ", DMI.DataHandler.QuoteString(Me._sName))

            End If

            If Not IsDBNull(Me.Details(tblRespondents.BatchID)) Then
                If IsNumeric(Me.Details(tblRespondents.BatchID)) Then
                    sWHERESQL &= String.Format("BatchID = {0} AND ", DMI.DataHandler.QuoteString(Me.Details(tblRespondents.BatchID)))

                End If
            End If

            If Me._sTelephone.Length > 0 Then
                sWHERESQL &= String.Format("(TelephoneDay LIKE {0} OR TelephoneEvening LIKE {0}) AND ", DMI.DataHandler.QuoteString(Me.Details(tblRespondents.BatchID)))

            End If

            If Me._iClientID > 0 Then
                sWHERESQL &= String.Format("ClientID = {0} AND ", Details(tblRespondents.ClientID))

            End If

            If Me._iSurveyID > 0 Then
                sWHERESQL &= String.Format("SurveyID = {0} AND ", Details(tblRespondents.SurveyID))

            End If

        End If

        If sWHERESQL <> "" Then
            sWHERESQL = "WHERE " & sWHERESQL
            sWHERESQL = Left(sWHERESQL, Len(sWHERESQL) - 4)

        End If

        Return Me._sSelectSQL & sWHERESQL

    End Function

    Protected Overrides Function GetInsertSQL() As String
        Dim sSQL As String

        sSQL = Me._sInsertSQL

        sSQL = String.Format(sSQL, Details(tblRespondents.RespondentID), _
                            Details(tblRespondents.SurveyInstanceID), _
                            DMI.DataHandler.QuoteString(Details(tblRespondents.FirstName)), _
                            DMI.DataHandler.QuoteString(Details(tblRespondents.MiddleInitial)), _
                            DMI.DataHandler.QuoteString(Details(tblRespondents.LastName)), _
                            DMI.DataHandler.QuoteString(Details(tblRespondents.Address1)), _
                            DMI.DataHandler.QuoteString(Details(tblRespondents.Address2)), _
                            DMI.DataHandler.QuoteString(Details(tblRespondents.City)), _
                            IIf(Details(tblRespondents.State) Is DBNull.Value, "NULL", DMI.DataHandler.QuoteString(Details(tblRespondents.State))), _
                            DMI.DataHandler.QuoteString(Details(tblRespondents.PostalCode)), _
                            DMI.DataHandler.QuoteString(Details(tblRespondents.TelephoneDay)), _
                            DMI.DataHandler.QuoteString(Details(tblRespondents.TelephoneEvening)), _
                            DMI.DataHandler.QuoteString(Details(tblRespondents.Email)), _
                            IIf(Details(tblRespondents.DOB) Is DBNull.Value, "NULL", DMI.DataHandler.QuoteString(Details(tblRespondents.DOB))), _
                            DMI.DataHandler.QuoteString(Details(tblRespondents.Gender)), _
                            DMI.DataHandler.QuoteString(Details(tblRespondents.ClientRespondentID)), _
                            DMI.DataHandler.QuoteString(Details(tblRespondents.SSN)), _
                            IIf(Details(tblRespondents.BatchID) Is DBNull.Value, "NULL", Details(tblRespondents.BatchID)))

        Return sSQL

    End Function

    Protected Overrides Function GetUpdateSQL() As String
        Dim sSQL As String

        sSQL = Me._sUpdateSQL

        sSQL = String.Format(sSQL, Details(tblRespondents.RespondentID), _
                                    Details(tblRespondents.SurveyInstanceID), _
                                    DMI.DataHandler.QuoteString(Details(tblRespondents.FirstName)), _
                                    DMI.DataHandler.QuoteString(Details(tblRespondents.MiddleInitial)), _
                                    DMI.DataHandler.QuoteString(Details(tblRespondents.LastName)), _
                                    DMI.DataHandler.QuoteString(Details(tblRespondents.Address1)), _
                                    DMI.DataHandler.QuoteString(Details(tblRespondents.Address2)), _
                                    DMI.DataHandler.QuoteString(Details(tblRespondents.City)), _
                                    IIf(Details(tblRespondents.State) Is DBNull.Value, "NULL", DMI.DataHandler.QuoteString(Details(tblRespondents.State))), _
                                    DMI.DataHandler.QuoteString(Details(tblRespondents.PostalCode)), _
                                    DMI.DataHandler.QuoteString(Details(tblRespondents.TelephoneDay)), _
                                    DMI.DataHandler.QuoteString(Details(tblRespondents.TelephoneEvening)), _
                                    DMI.DataHandler.QuoteString(Details(tblRespondents.Email)), _
                                    IIf(Details(tblRespondents.DOB) Is DBNull.Value, "NULL", DMI.DataHandler.QuoteString(Details(tblRespondents.DOB))), _
                                    DMI.DataHandler.QuoteString(Details(tblRespondents.Gender)), _
                                    DMI.DataHandler.QuoteString(Details(tblRespondents.ClientRespondentID)), _
                                    DMI.DataHandler.QuoteString(Details(tblRespondents.SSN)), _
                                    IIf(Details(tblRespondents.BatchID) Is DBNull.Value, "NULL", Details(tblRespondents.BatchID)))

        Return sSQL

    End Function

    Protected Overrides Function GetDeleteSQL() As String
        Dim sSQL As String

        sSQL = String.Format(Me._sDeleteSQL, Details(tblRespondents.RespondentID))

        Return sSQL

    End Function

    Protected Overrides Sub SetRecordDefaults(ByRef dr As DataRow)
        dr.Item("RespondentID") = 0
        dr.Item("FirstName") = ""
        dr.Item("MiddleInitial") = ""
        dr.Item("LastName") = ""
        dr.Item("Address1") = ""
        dr.Item("Address2") = ""
        dr.Item("City") = ""
        dr.Item("State") = ""
        dr.Item("PostalCode") = ""
        dr.Item("TelephoneDay") = ""
        dr.Item("TelephoneEvening") = ""
        dr.Item("Email") = ""
        dr.Item("Gender") = ""
        dr.Item("ClientRespondentID") = ""
        dr.Item("SSN") = ""

    End Sub

    Public Function GetEvents() As DataTable
        Dim ds As DataSet
        Dim sSQL As String

        If Me._dsEntity.Tables.IndexOf("RespondentEvents") > -1 Then
            Me._dsEntity.Tables.Remove("RespondentEvents")

        End If

        sSQL = String.Format("SELECT * FROM v_RespondentEventLog WHERE RespondentID = {0} ", Me._iEntityID)

        DMI.DataHandler.GetDS(Me.ConnectionString, ds, sSQL, "RespondentEvents")

        Me._dsEntity.Tables.Add(ds.Tables(0).Copy)

        Return Me._dsEntity.Tables("RespondentEvents")

    End Function

    Public Sub DeleteEvent(ByVal iEventLogID As Integer)
        Dim sSQL As String

        sSQL = String.Format("DELETE FROM EventLog WHERE EventLogID = {0} ", iEventLogID)

        DMI.SqlHelper.ExecuteNonQuery(Me.ConnectionString, CommandType.Text, sSQL)

    End Sub

    Public Sub InsertEvent(ByVal iEventID As Integer, ByVal iUserID As Integer, Optional ByVal sParam As String = "")
        InsertEvent(iEventID, Me._iEntityID, iUserID, sParam)

    End Sub

    Public Shared Sub InsertEvent(ByVal iEventID As Integer, ByVal iRespondentID As Integer, ByVal iUserID As Integer, Optional ByVal sParam As String = "")
        Dim sSQL As String

        sSQL = "INSERT INTO EventLog (EventDate, EventID, UserID, RespondentID, EventParameters) VALUES(GETDATE(), {0}, {1}, {2}, {3})"
        sSQL = String.Format(sSQL, iEventID, iUserID, iRespondentID, DMI.DataHandler.QuoteString(sParam))

        DMI.SqlHelper.ExecuteNonQuery(DMI.DataHandler.sConnection, CommandType.Text, sSQL)

    End Sub

    Public Sub SelectedForInput(ByVal iInputMode As QMS.qmsInputMode, ByVal iByUserID As Integer)
        SelectedForInput(iInputMode, Me._iEntityID, iByUserID)

    End Sub

    Public Shared Sub SelectedForInput(ByVal iInputMode As QMS.qmsInputMode, ByVal iRespondentID As Integer, ByVal iByUserID As Integer)
        Dim iEventCode As QMS.qmsEvents

        Select Case iInputMode
            Case QMS.qmsInputMode.DATAENTRY
                iEventCode = QMS.qmsEvents.RESPONDENT_SELECTED_DATAENTRY

            Case QMS.qmsInputMode.VERIFY
                iEventCode = QMS.qmsEvents.RESPONDENT_SELECTED_VERIFICATION

            Case QMS.qmsInputMode.CATI
                iEventCode = QMS.qmsEvents.RESPONDENT_SELECTED_CATICALL

            Case QMS.qmsInputMode.RCALL
                iEventCode = QMS.qmsEvents.RESPONDENT_SELECTED_REMINDERCALL

            Case Else
                iEventCode = QMS.qmsEvents.RESPONDENT_SELECTED_VIEWING

        End Select

        InsertEvent(CInt(iEventCode), iRespondentID, iByUserID)

    End Sub

    Public Sub ClearCompleteness()
        Dim sSQL As String

        sSQL = String.Format("DELETE FROM EventLog WHERE RespondentID = {0} AND EventID >= 3000 AND EventID <= 3999", Me._iEntityID)

        DMI.SqlHelper.ExecuteNonQuery(Me.ConnectionString, CommandType.Text, sSQL)

    End Sub

    Public Function GetProperties() As clsRespondentProperties
        Dim oProperties As New clsRespondentProperties(Me.ConnectionString)
        Dim ds As New DataSet()

        If Me._dsEntity.Tables.IndexOf("RespondentProperties") > -1 Then
            ds.Tables.Add(Me._dsEntity.Tables("RespondentProperties").Copy)
            oProperties.DataSet = ds

        Else
            oProperties.Details(tblRespondentProperties.RespondentID) = Me.Details(tblRespondents.RespondentID)
            oProperties.GetDetails()
            oProperties.DataSet.Tables("RespondentProperties").DefaultView.Sort = "PropertyName"
            Me.UpdateProperties(oProperties.DataSet.Tables("RespondentProperties"))

        End If

        Return oProperties

    End Function

    Public Sub UpdateProperties(ByVal dt As DataTable)

        Me.ClearProperties()
        Me._dsEntity.Tables.Add(dt.Copy)

    End Sub

    Public Sub ClearProperties()
        If Me._dsEntity.Tables.IndexOf("RespondentProperties") > -1 Then
            Me._dsEntity.Tables.Remove("RespondentProperties")

        End If

    End Sub

    Public Function IsFinal() As Boolean
        Dim sSQL As String

        sSQL = String.Format("SELECT COUNT(*) As IsFinal FROM v_RespondentEventLog WHERE RespondentID = {0} AND Final = 1", Me._iEntityID)

        If CInt(DMI.SqlHelper.ExecuteScalar(Me.ConnectionString, CommandType.Text, sSQL)) > 0 Then
            Return True

        Else
            Return False

        End If

    End Function

    Public Function CheckCallAttempts(ByVal iInputMode As QMS.qmsInputMode) As Boolean
        Dim sSQL As String
        Dim iCallAttemptsMade As Integer
        Dim iMaxCallAttempts As Integer

        sSQL = "SELECT COUNT(EventLog.EventLogID) AS CallAttemptsMade FROM EventLog INNER JOIN Events ON EventLog.EventID = Events.EventID "
        sSQL &= String.Format("WHERE (EventLog.RespondentID = {0}) AND (Events.EventTypeID = 5)", Me._iEntityID)

        iCallAttemptsMade = CInt(DMI.SqlHelper.ExecuteScalar(Me.ConnectionString, CommandType.Text, sSQL))

        sSQL = "SELECT CAST(ISNULL(CAST(MAX(psp.ProtocolStepParamValue) AS varchar), '0') AS int) AS MaxCallAttempts FROM ProtocolStepTypeParameters pstp INNER JOIN "
        sSQL &= "ProtocolStepParameters psp ON pstp.ProtocolStepTypeParamID = psp.ProtocolStepTypeParamID INNER JOIN "
        sSQL &= "ProtocolSteps ps ON psp.ProtocolStepID = ps.ProtocolStepID INNER JOIN SurveyInstances si ON ps.ProtocolID = si.ProtocolID "
        sSQL &= "WHERE (si.SurveyInstanceID = {0}) AND (pstp.ProtocolStepTypeID = {1}) AND (psp.ProtocolStepTypeParamID IN (8, 10)) "
        If iInputMode = QMS.qmsInputMode.RCALL Then
            sSQL = String.Format(sSQL, Me.Details(tblRespondents.SurveyInstanceID), 6)

        Else
            sSQL = String.Format(sSQL, Me.Details(tblRespondents.SurveyInstanceID), 5)

        End If

        iMaxCallAttempts = CInt(DMI.SqlHelper.ExecuteScalar(Me.ConnectionString, CommandType.Text, sSQL))

        If iCallAttemptsMade < iMaxCallAttempts Then
            Return True

        Else
            Return False

        End If

    End Function

End Class
