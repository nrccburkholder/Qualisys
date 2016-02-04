Public Enum tblMailingSeeds
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
    SurveyInstanceName = 10
    ClientName = 11
    SurveyName = 12
    ClientID = 13
    SurveyID = 14
    FormattedName = 15
    FormattedAddress = 16
    Name = 17

End Enum

<Obsolete("Use QMS.clsMailingSeeds")> _
Public Class clsMailingSeeds
    Inherits clsDBEntity

    Sub New(Optional ByVal sConn As String = "", Optional ByVal iEntityID As Integer = 0)
        MyBase.New(sConn, iEntityID)

    End Sub

    Private _iSurveyInstanceID As Integer = 0

    Private _sName As String = ""

    Default Public Overloads Property Details(ByVal eField As tblMailingSeeds) As Object
        Get
            If eField = tblMailingSeeds.Name Then
                Return Me._sName

            ElseIf eField = tblMailingSeeds.SurveyInstanceID Then
                Return Me._iSurveyInstanceID

            End If

            Return MyBase.Details(eField.ToString)

        End Get

        Set(ByVal Value As Object)
            If eField = tblMailingSeeds.RespondentID Then
                Me._iEntityID = Value

            ElseIf eField = tblMailingSeeds.SurveyInstanceID Then
                Me._iSurveyInstanceID = Value

            ElseIf eField = tblMailingSeeds.Name Then
                Me._sName = Value
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
                    Me._iEntityID = Me.Details(tblMailingSeeds.RespondentID)
                    Me._iSurveyInstanceID = Me.Details(tblMailingSeeds.SurveyInstanceID)

                End If
            End If
        End Set

    End Property

    Protected Overrides Sub InitClass()

        'Define table
        Me._sTableName = "Respondents"

        'INSERT SQL
        Me._sInsertSQL = "INSERT INTO Respondents (SurveyInstanceID, FirstName, MiddleInitial, LastName, Address1, Address2, City, State, PostalCode, MailingSeedFlag) "
        Me._sInsertSQL &= "VALUES({1},{2},{3},{4},{5},{6},{7},{8},{9},1)"

        'UPDATE SQL
        Me._sUpdateSQL = "UPDATE Respondents SET FirstName = {2}, MiddleInitial = {3}, "
        Me._sUpdateSQL &= "LastName = {4}, Address1 = {5}, Address2 = {6}, City = {7}, State = {8}, PostalCode = {9} "
        Me._sUpdateSQL &= "WHERE RespondentID = {0}"

        'DELETE SQL
        Me._sDeleteSQL = "DELETE FROM Respondents WHERE RespondentID = {0}"

        'SELECT SQL
        Me._sSelectSQL = "SELECT RespondentID, SurveyInstanceID, FirstName, MiddleInitial, LastName, Address1, "
        Me._sSelectSQL &= "Address2, City, State, PostalCode, SurveyInstanceName, ClientName, SurveyName, "
        Me._sSelectSQL &= "FormattedName, FormattedAddress "
        Me._sSelectSQL &= "FROM v_MailingSeeds "

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

            If Not IsDBNull(Me.Details(tblMailingSeeds.SurveyInstanceID)) Then
                sWHERESQL &= String.Format("SurveyInstanceID = {0} AND ", Details(tblMailingSeeds.SurveyInstanceID))

            End If

            If Me._sName <> "" Then
                sWHERESQL &= String.Format("FirstName + ' ' + Initial + ' ' + LastName LIKE {0} AND ", Me._sName)

            End If

            If Me.Details(tblMailingSeeds.FirstName).ToString.Length > 0 Then
                sWHERESQL &= String.Format("FirstName LIKE {0} AND ", DMI.DataHandler.QuoteString(Details(tblMailingSeeds.FirstName)))

            End If

            If Me.Details(tblMailingSeeds.MiddleInitial).ToString.Length > 0 Then
                sWHERESQL &= String.Format("Initial LIKE {0} AND ", DMI.DataHandler.QuoteString(Details(tblMailingSeeds.MiddleInitial)))

            End If

            If Me.Details(tblMailingSeeds.LastName).ToString.Length > 0 Then
                sWHERESQL &= String.Format("LastName LIKE {0} AND ", DMI.DataHandler.QuoteString(Details(tblMailingSeeds.LastName)))

            End If

            If Me.Details(tblMailingSeeds.Address1).ToString.Length > 0 Then
                sWHERESQL &= String.Format("Address1 LIKE {0} AND ", DMI.DataHandler.QuoteString(Details(tblMailingSeeds.Address1)))

            End If

            If Me.Details(tblMailingSeeds.Address2).ToString.Length > 0 Then
                sWHERESQL &= String.Format("Address2 LIKE {0} AND ", DMI.DataHandler.QuoteString(Details(tblMailingSeeds.Address2)))

            End If

            If Me.Details(tblMailingSeeds.City).ToString.Length > 0 Then
                sWHERESQL &= String.Format("City LIKE {0} AND ", DMI.DataHandler.QuoteString(Details(tblMailingSeeds.City)))

            End If

            If Me.Details(tblMailingSeeds.State).ToString.Length > 0 Then
                sWHERESQL &= String.Format("State = {0} AND ", DMI.DataHandler.QuoteString(Details(tblMailingSeeds.State)))

            End If

            If Me.Details(tblMailingSeeds.PostalCode).ToString.Length > 0 Then
                sWHERESQL &= String.Format("PostalCode LIKE {0} AND ", DMI.DataHandler.QuoteString(Details(tblMailingSeeds.PostalCode)))

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

        sSQL = String.Format(sSQL, Details(tblMailingSeeds.RespondentID), _
                            Details(tblMailingSeeds.SurveyInstanceID), _
                            DMI.DataHandler.QuoteString(Details(tblMailingSeeds.FirstName)), _
                            DMI.DataHandler.QuoteString(Details(tblMailingSeeds.MiddleInitial)), _
                            DMI.DataHandler.QuoteString(Details(tblMailingSeeds.LastName)), _
                            DMI.DataHandler.QuoteString(Details(tblMailingSeeds.Address1)), _
                            DMI.DataHandler.QuoteString(Details(tblMailingSeeds.Address2)), _
                            DMI.DataHandler.QuoteString(Details(tblMailingSeeds.City)), _
                            DMI.DataHandler.QuoteString(Details(tblMailingSeeds.State)), _
                            DMI.DataHandler.QuoteString(Details(tblMailingSeeds.PostalCode)))
        Return sSQL

    End Function

    Protected Overrides Function GetUpdateSQL() As String
        Dim sSQL As String

        sSQL = Me._sUpdateSQL

        sSQL = String.Format(sSQL, Details(tblMailingSeeds.RespondentID), _
                            Details(tblMailingSeeds.SurveyInstanceID), _
                            DMI.DataHandler.QuoteString(Details(tblMailingSeeds.FirstName)), _
                            DMI.DataHandler.QuoteString(Details(tblMailingSeeds.MiddleInitial)), _
                            DMI.DataHandler.QuoteString(Details(tblMailingSeeds.LastName)), _
                            DMI.DataHandler.QuoteString(Details(tblMailingSeeds.Address1)), _
                            DMI.DataHandler.QuoteString(Details(tblMailingSeeds.Address2)), _
                            DMI.DataHandler.QuoteString(Details(tblMailingSeeds.City)), _
                            DMI.DataHandler.QuoteString(Details(tblMailingSeeds.State)), _
                            DMI.DataHandler.QuoteString(Details(tblMailingSeeds.PostalCode)))

        Return sSQL

    End Function

    Protected Overrides Function GetDeleteSQL() As String
        Dim sSQL As String

        sSQL = String.Format(Me._sDeleteSQL, Details(tblMailingSeeds.RespondentID))

        Return sSQL

    End Function

    Protected Overrides Sub SetRecordDefaults(ByRef dr As DataRow)
        dr.Item("RespondentID") = 0
        dr.Item("SurveyInstanceID") = Me._iSurveyInstanceID
        dr.Item("FirstName") = ""
        dr.Item("MiddleInitial") = ""
        dr.Item("LastName") = ""
        dr.Item("Address1") = ""
        dr.Item("Address2") = ""
        dr.Item("City") = ""
        dr.Item("State") = ""
        dr.Item("PostalCode") = ""

    End Sub

    Public Sub AddMailingSeed()
        Dim dr As DataRow

        dr = Me._dsEntity.Tables("Respondents").NewRow
        Me.SetRecordDefaults(dr)

        Me._dsEntity.Tables("Respondents").Rows.Add(dr)

    End Sub

End Class
