Public Enum tblSurveyInstanceEvents
    SurveyInstanceEventID = 0
    SurveyInstanceID = 1
    EventID = 2
    TranslationValue = 3
    Final = 4
    NonContactHours = 5
    EventName = 6
    EventDescription = 7
    EventTypeID = 8
    EventTypeName = 9
    UseEvent = 10

End Enum

Public Class clsSurveyInstanceEvent
    Inherits clsDBEntity

    Sub New(Optional ByVal sConn As String = "", Optional ByVal iEntityID As Integer = 0)
        MyBase.New(sConn, iEntityID)

    End Sub

    Protected _iSurveyInstanceID As Integer

    Default Public Overloads Property Details(ByVal eField As tblSurveyInstanceEvents) As Object
        Get
            Return MyBase.Details(eField.ToString)

        End Get

        Set(ByVal Value As Object)
            If eField = tblSurveyInstanceEvents.SurveyInstanceEventID Then
                Me._iEntityID = Value

            ElseIf eField = tblSurveyInstanceEvents.SurveyInstanceID Then
                Me._iSurveyInstanceID = Value

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
                    Me._iEntityID = Me.Details(tblSurveyInstanceEvents.SurveyInstanceEventID)
                    Me._iSurveyInstanceID = Me.Details(tblSurveyInstanceEvents.SurveyInstanceID)

                End If
            End If
        End Set

    End Property

    'Function to provide all class parameters, like _sTableName
    Protected Overrides Sub InitClass()

        'Define table
        Me._sTableName = "SurveyInstanceEvents"

        'INSERT SQL
        Me._sInsertSQL = "INSERT INTO SurveyInstanceEvents (SurveyInstanceID, EventID, TranslationValue, Final, NonContactHours) "
        Me._sInsertSQL &= "VALUES ({1}, {2}, {3}, {4}, {5}) "

        'UPDATE SQL
        Me._sUpdateSQL = "UPDATE SurveyInstanceEvents SET TranslationValue = {3}, Final = {4}, NonContactHours = {5} "
        Me._sUpdateSQL &= "WHERE SurveyInstanceEventID = {0}"

        'DELETE SQL
        Me._sDeleteSQL = "DELETE FROM SurveyInstanceEvents WHERE SurveyInstanceEventID = {0} "

        'SELECT SQL
        Me._sSelectSQL = "SELECT SurveyInstanceEventID, SurveyInstanceID, EventID, TranslationValue, Final, "
        Me._sSelectSQL &= "NonContactHours, EventName, EventDescription, EventTypeID, EventTypeName, UseEvent "
        Me._sSelectSQL &= "FROM v_SurveyInstanceEvents "

    End Sub

    'Builds insert SQL from dataset
    Protected Overrides Function GetInsertSQL() As String

        Return String.Format(Me._sInsertSQL, Details(tblSurveyInstanceEvents.SurveyInstanceEventID), _
                            Details(tblSurveyInstanceEvents.SurveyInstanceID), _
                            Details(tblSurveyInstanceEvents.EventID), _
                            DMI.DataHandler.QuoteString(Details(tblSurveyInstanceEvents.TranslationValue)), _
                            Details(tblSurveyInstanceEvents.Final), _
                            Details(tblSurveyInstanceEvents.NonContactHours))

    End Function

    'Builds update SQL from dataset
    Protected Overrides Function GetUpdateSQL() As String

        Return String.Format(Me._sUpdateSQL, Details(tblSurveyInstanceEvents.SurveyInstanceEventID), _
                            Details(tblSurveyInstanceEvents.SurveyInstanceID), _
                            Details(tblSurveyInstanceEvents.EventID), _
                            DMI.DataHandler.QuoteString(Details(tblSurveyInstanceEvents.TranslationValue)), _
                            Details(tblSurveyInstanceEvents.Final), _
                            Details(tblSurveyInstanceEvents.NonContactHours))

    End Function

    'Builds select SQL from dataset for search
    Protected Overrides Function GetSearchSQL() As String
        Dim sWHERESQL As String = ""
        Dim bIdentity As Boolean = False

        If Me._iEntityID > 0 Then
            sWHERESQL = String.Format("SurveyInstanceEventID = {0} AND ", Me._iEntityID)
            bIdentity = True

        End If

        If Not bIdentity Then

            If Not IsDBNull(Details(tblSurveyInstanceEvents.SurveyInstanceID)) Then
                sWHERESQL &= String.Format("SurveyInstanceID = {0} AND ", Details(tblSurveyInstanceEvents.SurveyInstanceID))

            End If

            If Not IsDBNull(Details(tblSurveyInstanceEvents.EventID)) Then
                sWHERESQL &= String.Format("EventID = {0} AND ", Details(tblSurveyInstanceEvents.EventID))

            End If

            If Details(tblSurveyInstanceEvents.TranslationValue).ToString.Length > 0 Then
                sWHERESQL &= String.Format("TranslationValue LIKE {0} AND ", DMI.DataHandler.QuoteString(Details(tblSurveyInstanceEvents.TranslationValue)))

            End If

            If Not IsDBNull(Details(tblSurveyInstanceEvents.Final)) Then
                sWHERESQL &= String.Format("Final = {0} AND ", Details(tblSurveyInstanceEvents.Final))

            End If

            If Not IsDBNull(Details(tblSurveyInstanceEvents.NonContactHours)) Then
                sWHERESQL &= String.Format("NonContactHours = {0} AND ", Details(tblSurveyInstanceEvents.NonContactHours))

            End If

        End If

        If sWHERESQL <> "" Then
            sWHERESQL = "WHERE " & sWHERESQL
            sWHERESQL = Left(sWHERESQL, Len(sWHERESQL) - 4)

        End If

        Return Me._sSelectSQL & sWHERESQL

    End Function

    'Builds delete SQL from dataset
    Protected Overrides Function GetDeleteSQL() As String

        Return String.Format(Me._sDeleteSQL, Details(tblSurveyInstanceEvents.SurveyInstanceEventID))

    End Function

    'Called by Create method to fill datarow with default values for new record
    Protected Overrides Sub SetRecordDefaults(ByRef dr As DataRow)

        dr.Item("SurveyInstanceEventID") = 0
        dr.Item("SurveyInstanceID") = Me._iSurveyInstanceID
        dr.Item("EventID") = 0
        dr.Item("TranslationValue") = ""
        dr.Item("Final") = 0
        dr.Item("NonContactHours") = 0

    End Sub

End Class
