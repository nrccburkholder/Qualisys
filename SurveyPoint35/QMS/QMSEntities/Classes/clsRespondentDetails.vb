Public Class clsRespondentDetails

    Private _oConn As SqlClient.SqlConnection
    Private _ds As New dsRespondentDetails()
    Private _oRespondent As clsRespondents
    Private _oRespondentProperties As clsRespondentProperties
    Private _oEventLog As clsEventLog
    Private _oHousehold As clsHouseholds
    Private _drRespondent As dsRespondentDetails.RespondentsRow
    Private _iUserID As Integer

    Public Sub New(ByVal oConn As SqlClient.SqlConnection)
        _oConn = oConn

    End Sub

    Public Sub Close()
        If Not IsNothing(_oRespondent) Then _oRespondent.Close()
        If Not IsNothing(_oRespondentProperties) Then _oRespondentProperties.Close()
        If Not IsNothing(_oEventLog) Then _oEventLog.Close()
        If Not IsNothing(_oHousehold) Then _oHousehold.Close()
        _oConn = Nothing
        _ds = Nothing
        _oRespondent = Nothing
        _oRespondentProperties = Nothing
        _oEventLog = Nothing
        _oHousehold = Nothing

    End Sub

#Region "Objects"
    Public ReadOnly Property Respondent() As clsRespondents
        Get
            If IsNothing(_oRespondent) Then
                _oRespondent = New clsRespondents(_oConn)
                _oRespondent.MainDataTable = _ds.Tables("Respondents")

            End If

            Return _oRespondent

        End Get
    End Property

    Public ReadOnly Property RespondentProperties() As clsRespondentProperties
        Get
            'create object
            If IsNothing(_oRespondentProperties) Then
                _oRespondentProperties = New clsRespondentProperties(_oConn)
                _oRespondentProperties.MainDataTable = _ds.Tables("RespondentProperties")
            End If

            'set respondent id
            If Respondent.MainDataTable.Rows.Count > 0 Then
                _oRespondentProperties.RespondentID = CInt(Respondent.MainDataTable.Rows(0).Item("RespondentID"))

            End If

            Return _oRespondentProperties

        End Get
    End Property

    Public ReadOnly Property EventLog() As clsEventLog
        Get
            If IsNothing(_oEventLog) Then
                _oEventLog = New clsEventLog(_oConn)
                _oEventLog.MainDataTable = _ds.Tables("EventLog")

            End If

            Return _oEventLog

        End Get
    End Property

    Public ReadOnly Property Household() As clsHouseholds
        Get
            If IsNothing(_oHousehold) Then
                _oHousehold = New clsHouseholds(_oConn)
                _oHousehold.MainDataTable = _ds.Tables("Household")

            End If

            Return _oHousehold

        End Get
    End Property

#End Region

#Region "Respondent"
    Public Sub Fill(ByVal iRespondentID)
        Dim r As clsRespondents

        FillLookups()
        r = Respondent
        r.UserID = Me.UserID
        r.FillMain(iRespondentID)
        FillChildTables()
        If r.MainDataTable.Rows.Count > 0 Then
            _drRespondent = CType(r.MainDataTable.Rows(0), dsRespondentDetails.RespondentsRow)

        End If

    End Sub

    Public Sub Refresh()
        Dim iRespondentID As Integer
        Dim r As clsRespondents = Me.Respondent

        If r.MainDataTable.Rows.Count > 0 Then
            iRespondentID = CInt(r.MainDataTable.Rows(0).Item("RespondentID"))
            _ds.EnforceConstraints = False
            r.FillMain(iRespondentID)
            FillEventLog(iRespondentID)
            _ds.EnforceConstraints = True

        End If

    End Sub

#End Region

#Region "Lookup table functions"
    Public Sub FillLookups()
        FillEvents()
        FillUsers()

    End Sub

    Private Sub FillEvents()
        Dim oEvents As New clsEvents(_oConn)

        oEvents.MainDataTable = _ds.Tables("tblEvents")
        oEvents.FillMain()
        oEvents.Close()
        oEvents = Nothing

    End Sub

    Private Sub FillUsers()
        Dim oUsers As New clsUsers(_oConn)

        oUsers.MainDataTable = _ds.Tables("Users")
        oUsers.FillMain()
        oUsers.Close()
        oUsers = Nothing

    End Sub

#End Region

#Region "Fill child table functions"
    Public Sub FillChildTables()
        Dim iRespondentID As Integer

        If Respondent.MainDataTable.Rows.Count > 0 Then
            iRespondentID = CInt(Respondent.MainDataTable.Rows(0).Item("RespondentID"))
            FillRespondentProperties(iRespondentID)
            FillEventLog(iRespondentID)
            If Respondent.GroupByHousehold Then FillHousehold(iRespondentID)

        End If

    End Sub

    Private Sub FillRespondentProperties(ByVal iRespondentID As Integer, Optional ByVal propertyLevel As Integer = 0)
        Dim dr As dsRespondentProperties.SearchRow = RespondentProperties.NewSearchRow

        dr.Item("RespondentID") = iRespondentID
        dr.Item("PropertyLevel") = propertyLevel
        RespondentProperties.FillMain(dr)

    End Sub

    Private Sub FillEventLog(ByVal iRespondentID As Integer)
        Dim dr As dsEventLog.SearchRow = EventLog.NewSearchRow

        dr.Item("RespondentID") = iRespondentID
        dr.Item("ExcludeEventIDList") = "2205"
        EventLog.FillMain(dr)

    End Sub

    Private Sub FillHousehold(ByVal iRespondentID As Integer)
        Dim h As clsHouseholds = Me.Household
        Dim dr As dsHousehold.SearchRow = h.NewSearchRow

        If clsRespondents.HasHousehold(Me._oConn, iRespondentID) Then
            dr.Item("RespondentID") = iRespondentID
            h.UserID = Me.UserID
            h.FillMain(dr)

        End If

    End Sub

    Public ReadOnly Property HasHousehold() As Boolean
        Get
            If Household.MainDataTable.Rows.Count > 0 Then Return True
            Return False

        End Get
    End Property

#End Region

    Public Property UserID() As Integer
        Get
            Return _iUserID

        End Get
        Set(ByVal Value As Integer)
            _iUserID = Value

        End Set
    End Property

End Class
