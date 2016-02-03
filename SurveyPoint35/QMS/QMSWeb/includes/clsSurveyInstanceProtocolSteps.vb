Public Enum tblSurveyInstanceProtocolSteps
    SurveyInstanceProtocolStepID = 0
    SurveyInstanceID = 1
    ProtocolStepID = 2
    ClearedTimeStamp = 3
    ClearedUserID = 4
    SurveyID = 5
    ClientID = 6
    StartDate = 7
    Active = 8
    ClientName = 9
    SurveyName = 10
    InstanceName = 11
    ProtocolStepTypeID = 12
    ProtocolStepTypeName = 13
    ProtocolStepName = 14
    StartDay = 15
    ProtocolStepDate = 16
    Cleared = 17
    ProtocolStepDateBefore = 18
    URL = 19
    RespondentCount = 20

End Enum

<Obsolete("use QMS.clsSurveyInstanceProtocolSteps")> _
Public Class clsSurveyInstanceProtocolSteps
    Inherits clsDBEntity

    Sub New(Optional ByVal sConn As String = "", Optional ByVal iEntityID As Integer = 0)
        MyBase.New(sConn, iEntityID)

    End Sub

    Private _iSurveyInstanceID As Integer = 0

    Private _iProtocolStepID As Integer = 0

    Private _iClearedUserID As Integer = 0

    Private _sProtocolStepBeforeDate As String = ""

    Public Overrides Sub Clear()
        Dim dc As DataColumn
        Dim dr As DataRow

        If Not Me._dsEntity Is Nothing Then
            Me._dsEntity = Nothing
        End If

        If DMI.DataHandler.GetSchemaSQL(Me._dsEntity, Me._sSelectSQL, Me._sTableName, Me.ConnectionString) Then
            For Each dc In Me._dsEntity.Tables(Me._sTableName).Columns
                dc.AllowDBNull = True
                dc.ReadOnly = False

            Next

            dr = Me._dsEntity.Tables(Me._sTableName).NewRow
            dr.Item(0) = -1

            Me._dsEntity.Tables(Me._sTableName).Rows.Add(dr)

        End If

        Me._iEntityID = -1

    End Sub

    Default Public Overloads Property Details(ByVal eField As tblSurveyInstanceProtocolSteps) As Object
        Get
            If eField = tblSurveyInstanceProtocolSteps.ProtocolStepDateBefore Then
                Return Me._sProtocolStepBeforeDate

            End If

            Return MyBase.Details(eField.ToString)

        End Get

        Set(ByVal Value As Object)
            If eField = tblSurveyInstanceProtocolSteps.SurveyInstanceProtocolStepID Then
                Me._iEntityID = Value

            ElseIf eField = tblSurveyInstanceProtocolSteps.SurveyInstanceID Then
                Me._iSurveyInstanceID = Value

            ElseIf eField = tblSurveyInstanceProtocolSteps.ProtocolStepID Then
                Me._iProtocolStepID = Value

            ElseIf eField = tblSurveyInstanceProtocolSteps.ClearedUserID Then
                Me._iClearedUserID = Value

            ElseIf eField = tblSurveyInstanceProtocolSteps.ProtocolStepDateBefore Then
                Me._sProtocolStepBeforeDate = Value
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

        End Set

    End Property

    Protected Overrides Sub InitClass()

        'Define table
        Me._sTableName = "SurveyInstanceProtocolSteps"

        'INSERT SQL
        Me._sInsertSQL = "INSERT INTO SurveyInstanceProtocolSteps (SurveyInstanceID, ProtocolID, ClearedTimeStamp, ClearedUserID) "
        Me._sInsertSQL &= "VALUES({1},{2},GETDATE(),{3})"

        'UPDATE SQL
        Me._sUpdateSQL = "UPDATE SurveyInstanceProtocolSteps SET SurveyInstanceID = {1}, ProtocolID = {2}, ClearedTimeStamp = GETDATE(), ClearedUserID = {4} "
        Me._sUpdateSQL &= "WHERE SurveyInstanceProtocolStepID = {0}"

        'DELETE SQL
        Me._sDeleteSQL = "DELETE FROM SurveyInstanceProtocolSteps WHERE SurveyInstanceProtocolStepID = {0}"

        'SELECT SQL
        Me._sSelectSQL = "SELECT * FROM v_SurveyInstanceProtocolSteps "

    End Sub


    Protected Overrides Function GetSearchSQL() As String
        Dim sWHERESQL As String = ""

        If Not IsDBNull(Me.Details(tblSurveyInstanceProtocolSteps.SurveyInstanceID)) Then
            If Me.Details(tblSurveyInstanceProtocolSteps.SurveyInstanceID) > 0 Then
                sWHERESQL &= String.Format("SurveyInstanceID = {0} AND ", Details(tblSurveyInstanceProtocolSteps.SurveyInstanceID))

            End If

        End If

        If Not IsDBNull(Me.Details(tblSurveyInstanceProtocolSteps.ProtocolStepID)) Then
            If Me.Details(tblSurveyInstanceProtocolSteps.ProtocolStepID) > 0 Then
                sWHERESQL &= String.Format("ProtocolStepID = {0} AND ", Details(tblSurveyInstanceProtocolSteps.ProtocolStepID))

            End If

        End If

        If Not IsDBNull(Me.Details(tblSurveyInstanceProtocolSteps.SurveyID)) Then
            sWHERESQL &= String.Format("SurveyID = {0} AND ", Details(tblSurveyInstanceProtocolSteps.SurveyID))

        End If

        If Not IsDBNull(Me.Details(tblSurveyInstanceProtocolSteps.ClientID)) Then
            sWHERESQL &= String.Format("ClientID = {0} AND ", Details(tblSurveyInstanceProtocolSteps.ClientID))

        End If

        If Not IsDBNull(Me.Details(tblSurveyInstanceProtocolSteps.Active)) Then
            sWHERESQL &= String.Format("Active = {0} AND ", Details(tblSurveyInstanceProtocolSteps.Active))

        End If

        If Not IsDBNull(Me.Details(tblSurveyInstanceProtocolSteps.Cleared)) Then
            sWHERESQL &= String.Format("Cleared = {0} AND ", Details(tblSurveyInstanceProtocolSteps.Cleared))

        End If

        If Not IsDBNull(Me.Details(tblSurveyInstanceProtocolSteps.ProtocolStepTypeID)) Then
            sWHERESQL &= String.Format("ProtocolStepTypeID = {0} AND ", Details(tblSurveyInstanceProtocolSteps.ProtocolStepTypeID))

        End If

        If Not IsDBNull(Me.Details(tblSurveyInstanceProtocolSteps.ProtocolStepDate)) Then
            If IsDate(Me.Details(tblSurveyInstanceProtocolSteps.ProtocolStepDate)) Then
                sWHERESQL &= String.Format("ProtocolStepDate >= {0} AND ", DMI.DataHandler.QuoteString(Details(tblSurveyInstanceProtocolSteps.ProtocolStepDate)))

            End If

        End If

        If Me._sProtocolStepBeforeDate.Length > 0 Then
            If IsDate(Me._sProtocolStepBeforeDate) Then
                sWHERESQL &= String.Format("ProtocolStepDate <= {0} AND ", DMI.DataHandler.QuoteString(Me._sProtocolStepBeforeDate))

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

        sSQL = String.Format(sSQL, Details(tblSurveyInstanceProtocolSteps.SurveyInstanceProtocolStepID), _
                            Details(tblSurveyInstanceProtocolSteps.SurveyInstanceID), _
                            DMI.DataHandler.QuoteString(Details(tblSurveyInstanceProtocolSteps.SurveyInstanceID)), _
                            DMI.DataHandler.QuoteString(Details(tblSurveyInstanceProtocolSteps.ProtocolStepID)), _
                            DMI.DataHandler.QuoteString(Details(tblSurveyInstanceProtocolSteps.ClearedUserID)))

        Return sSQL

    End Function

    Protected Overrides Function GetUpdateSQL() As String
        Dim sSQL As String

        sSQL = Me._sUpdateSQL

        sSQL = String.Format(sSQL, Details(tblSurveyInstanceProtocolSteps.SurveyInstanceProtocolStepID), _
                            Details(tblSurveyInstanceProtocolSteps.SurveyInstanceID), _
                            DMI.DataHandler.QuoteString(Details(tblSurveyInstanceProtocolSteps.SurveyInstanceID)), _
                            DMI.DataHandler.QuoteString(Details(tblSurveyInstanceProtocolSteps.ProtocolStepID)), _
                            DMI.DataHandler.QuoteString(Details(tblSurveyInstanceProtocolSteps.ClearedUserID)))

        Return sSQL

    End Function

    Protected Overrides Function GetDeleteSQL() As String
        Dim sSQL As String

        sSQL = String.Format(Me._sDeleteSQL, Details(tblSurveyInstanceProtocolSteps.SurveyInstanceProtocolStepID))

        Return sSQL

    End Function

    Protected Overrides Sub SetRecordDefaults(ByRef dr As DataRow)
        dr.Item("SurveyInstanceProtocolStepID") = 0
        dr.Item("SurveyInstanceID") = Me._iSurveyInstanceID
        dr.Item("ProtocolStepID") = Me._iProtocolStepID
        dr.Item("ClearedUserID") = Me._iClearedUserID

    End Sub

    Public Sub Completed(ByVal iRowID As Integer, ByVal iUserID As Integer)
        Dim sSQL As String

        sSQL = "INSERT INTO SurveyInstanceProtocolSteps (SurveyInstanceID, ProtocolStepID, ClearedTimeStamp, ClearedUserID) "
        sSQL &= "SELECT SurveyInstanceID, ProtocolStepID, GETDATE(), {1} FROM v_SurveyInstanceProtocolSteps WHERE RowID = {0} "
        sSQL = String.Format(sSQL, iRowID, iUserID)

        DMI.SqlHelper.ExecuteNonQuery(Me.ConnectionString, CommandType.Text, sSQL)

    End Sub

End Class
