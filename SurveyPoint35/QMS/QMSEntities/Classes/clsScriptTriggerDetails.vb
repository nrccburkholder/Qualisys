Public Class clsScriptTriggerDetails
    Inherits DMI.clsDSEntity

    Private _Triggers As clsTriggers
    Private _Criteria As clsCriteria
    Private _ScriptTriggers As clsScriptTriggers
    Private _ScriptScreens As clsScriptScreens

#Region "dsEntity overrides"
    Public Sub New(ByVal oConn As SqlClient.SqlConnection)
        MyBase.New(oConn)

    End Sub

    Protected Overrides Sub CleanUpEntityObjects()
        If Not IsNothing(_Triggers) Then _Triggers.Close()
        If Not IsNothing(_Criteria) Then _Criteria.Close()
        If Not IsNothing(_ScriptTriggers) Then _ScriptTriggers.Close()
        _Triggers = Nothing
        _Criteria = Nothing
        _ScriptTriggers = Nothing

    End Sub

    Protected Overrides Sub FillChildTables(ByVal drCriteria As System.Data.DataRow)
        If Not IsDBNull(Triggers.MainDataTable.Rows(0).Item("CriteriaID")) Then
            FillCriteria(CInt(Triggers.MainDataTable.Rows(0).Item("CriteriaID")))

        End If

    End Sub

    Protected Overrides Sub FillLookupTables(ByVal drCriteria As System.Data.DataRow)
        FillCriteriaTypes()
    End Sub

    Protected Overrides Sub FillMainTable(ByVal drCriteria As System.Data.DataRow)
        FillTriggers(drCriteria)
        FillScriptTriggers(drCriteria)

    End Sub

    Protected Overrides Sub SetTypedDataSet()
        Me._ds = New dsScriptTriggerDetails

    End Sub

#End Region

#Region "objects"
    Public ReadOnly Property Triggers() As clsTriggers
        Get
            If IsNothing(Me._Triggers) Then
                Me._Triggers = New clsTriggers(Me._oConn)
                Me._Triggers.MainDataTable = Me._ds.Tables("Triggers")

            End If

            Return Me._Triggers

        End Get
    End Property

    Public ReadOnly Property ScriptTriggers() As clsScriptTriggers
        Get
            If IsNothing(Me._ScriptTriggers) Then
                Me._ScriptTriggers = New clsScriptTriggers(Me._oConn)
                Me._ScriptTriggers.MainDataTable = Me._ds.Tables("ScriptedTriggers")

            End If

            Return Me._ScriptTriggers

        End Get
    End Property

    Public ReadOnly Property Criteria() As clsCriteria
        Get
            If IsNothing(Me._Criteria) Then
                _Criteria = New clsCriteria(Me._oConn)
                _Criteria.MainDataTable = Me._ds.Tables("Criteria")
                If Triggers.MainDataTable.Rows.Count > 0 Then
                    _Criteria.SurveyID = CInt(Me.Triggers.MainDataTable.Rows(0).Item("SurveyID"))

                End If
            End If

            Return Me._Criteria

        End Get
    End Property

    Public ReadOnly Property ScriptScreens() As clsScriptScreens
        Get
            If IsNothing(Me._ScriptScreens) Then
                Me._ScriptScreens = New clsScriptScreens(Me._oConn)
                Me._ScriptScreens.MainDataTable = Me._ds.Tables("ScriptScreens")

            End If

            Return Me._ScriptScreens

        End Get
    End Property
#End Region

#Region "fill functions"
    Public Sub FillScriptTriggers(ByVal dr As DataRow)
        Me.ScriptTriggers.FillMain(dr)

    End Sub

    Public Sub FillTriggers(ByVal dr As DataRow)
        Dim drSearch As DataRow
        drSearch = Me.Triggers.NewSearchRow

        If Not IsDBNull(dr.Item("ScriptedTriggerID")) Then drSearch.Item("ScriptedTriggerID") = dr.Item("ScriptedTriggerID")
        If Not IsDBNull(dr.Item("ScriptID")) Then drSearch.Item("ScriptID") = dr.Item("ScriptID")
        If Not IsDBNull(dr.Item("ScriptScreenID")) Then drSearch.Item("ScriptScreenID") = dr.Item("ScriptScreenID")
        If Not IsDBNull(dr.Item("RunBeforeAfter")) Then drSearch.Item("PrePostFlag") = dr.Item("RunBeforeAfter")

        Me.Triggers.FillMain(drSearch)

    End Sub

    Public Sub FillScriptScreens(ByVal dr As DataRow)
        Dim drSearch As DataRow
        drSearch = Me.ScriptScreens.NewSearchRow

        If Not IsDBNull(dr.Item("ScriptID")) Then drSearch.Item("ScriptID") = dr.Item("ScriptID")
        If Not IsDBNull(dr.Item("ScriptScreenID")) Then drSearch.Item("ScriptScreenID") = dr.Item("ScriptScreenID")

        Me.ScriptScreens.FillMain(drSearch)

    End Sub

    Public Sub FillCriteria(ByVal RootCriteriaID As Integer)
        Me.Criteria.ExpandCriteria(RootCriteriaID)

    End Sub

    Public Sub FillCriteriaTypes()
        Me.Criteria.FillCriteriaTypes(_oConn, Me._ds.Tables("CriteriaTypes"))

    End Sub

#End Region

End Class
