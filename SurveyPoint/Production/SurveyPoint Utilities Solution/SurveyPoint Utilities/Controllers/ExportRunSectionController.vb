
Imports Nrc.SurveyPoint.Library
Public Class ExportRunSectionController
    Private mExportGroup As ExportGroup
    Private mExportClientSelected As ExportClientSelected
    Private mSelectedScript As ExportScriptSelected
    Private mSelectedClient As ExportClientSelected
    Private mExportGroupFilePropertiesLabel As String
    Private mClientFilePropertiesLabel As String
    Private mScriptFilePropertiesLabel As String
    Private mSelectedFileLayout As ExportFileLayout
    Public Property SelectedFileLayout() As ExportFileLayout
        Get
            If Me.mSelectedFileLayout Is Nothing Then
                Me.mSelectedFileLayout = Me.ExportGroup.ExportFileLayout
            End If
            'If there's no layout selected for the current exportgroup then pick the first one in the list as a default value
            If Me.mSelectedFileLayout Is Nothing Then
                Me.mSelectedFileLayout = Me.AllFileLayouts(0)
                Me.ExportGroup.ExportFileLayout = Me.mSelectedFileLayout
            End If
            Return Me.mSelectedFileLayout
        End Get
        Set(ByVal value As ExportFileLayout)
            mSelectedFileLayout = value
        End Set
    End Property
    Public ReadOnly Property ScriptFilePropertiesLabel() As String
        Get
            If SelectedScript IsNot Nothing Then
                Return "File Properties For (" & Me.SelectedScript.ScriptID & ") " & Me.SelectedScript.Name
            Else
                Return "Please Select a Script to View the Properties"
            End If
        End Get
    End Property
    Public ReadOnly Property ExportGroupFilePropertiesLabel() As String
        Get
            Return "File Properties For " & Me.ExportGroup.Name
        End Get
    End Property
    Public ReadOnly Property ClientFilePropertiesLabel() As String
        Get
            If SelectedClient IsNot Nothing Then
                Return "File Properties For " & Me.SelectedClient.Name
            Else
                Return "Please Select a Client to View the Properties"
            End If
        End Get
    End Property

    Public Property SelectedClient() As ExportClientSelected
        Get
            If mSelectedClient Is Nothing Then
                If Not Me.SelectedClients Is Nothing Then
                    If Me.SelectedClients.Count > 0 Then
                        mSelectedClient = Me.SelectedClients(0)
                    End If
                End If
            End If
            Return mSelectedClient
        End Get
        Set(ByVal value As ExportClientSelected)
            mSelectedClient = value
        End Set
    End Property
    Public ReadOnly Property SelectedClientExtensions() As ExportClientExtensionCollection
        Get
            If SelectedClient IsNot Nothing Then
                Return SelectedClient.ExportClientExtensionCollection
            Else
                Return Nothing
            End If
        End Get
    End Property
    Public ReadOnly Property SelectedScriptExtensions() As ExportScriptExtensionCollection
        Get
            If SelectedScript IsNot Nothing Then
                Return SelectedScript.ExportScriptExtensionCollection
            Else
                Return Nothing
            End If
        End Get
    End Property
    Public Property ExportGroup() As ExportGroup
        Get
            Return mExportGroup
        End Get
        Set(ByVal value As ExportGroup)
            mExportGroup = value
            Me.mSelectedFileLayout = Nothing 'reset the SelectedFileLayout 
        End Set
    End Property

    Public ReadOnly Property AllFileLayouts() As ExportFileLayoutCollection
        Get
            Return ExportFileLayout.GetAll()
        End Get
    End Property


    Public Sub LoadExportGroup(ByVal exportGroupID As Integer)
        Me.SelectedClient = Nothing
        Me.SelectedScript = Nothing
        ExportGroup = ExportGroup.Get(exportGroupID)

    End Sub
    Public Sub NewExportGroup()
        ExportGroup = ExportGroup.NewExportGroup()
    End Sub


    Public ReadOnly Property ExportGroupExtensions() As ExportGroupExtensionCollection
        Get
            If mExportGroup IsNot Nothing Then
                Return ExportGroup.ExportGroupExtensionCollection
            Else
                Return Nothing
            End If
        End Get
    End Property
    Public ReadOnly Property AllSurveys() As ExportSurveyCollection
        Get
            Return ExportSurvey.GetAll()
        End Get
    End Property
    Public Property SelectedScript() As ExportScriptSelected
        Get
            Return mSelectedScript
        End Get
        Set(ByVal value As ExportScriptSelected)
            mSelectedScript = value
        End Set
    End Property
    Public Property SelectedSurvey() As ExportSurvey
        Get
            If Me.ExportGroup.ExportSelectedSurvey Is Nothing Then
                If AllSurveys.Count > 0 Then
                    ExportGroup.ExportSelectedSurvey = AllSurveys(0)
                Else
                    Throw New Exception("No Survey Found")
                End If
            End If
            Return ExportGroup.ExportSelectedSurvey()
        End Get
        Set(ByVal value As ExportSurvey)
            Debug.Assert(ExportGroup IsNot Nothing)
            ExportGroup.ExportSelectedSurvey = value
        End Set
    End Property
    Public ReadOnly Property AvailableClients() As ExportClientAvailableCollection
        Get
            Return SelectedSurvey.ExportClientAvailableCollection
        End Get
    End Property

    Public ReadOnly Property SelectedClients() As ExportClientSelectedCollection
        Get
            Return SelectedSurvey.ExportClientSelectedCollection
        End Get
    End Property
    Public ReadOnly Property AvailableScripts() As ExportScriptAvailableCollection
        Get
            Return SelectedSurvey.ExportScriptAvailableCollection
        End Get
    End Property
    Public ReadOnly Property SelectedScripts() As ExportScriptSelectedCollection
        Get
            Return SelectedSurvey.ExportScriptSelectedCollection
        End Get
    End Property
    Public ReadOnly Property AvailableEvents() As ExportEventAvailableCollection
        Get
            'Return ExportEventAvailable.GetAll()
            Return ExportGroup.ExportAvailableEventCollection
        End Get
    End Property
    Public ReadOnly Property IncludedEvents() As ExportEventSelectedCollection
        Get
            'Return ExportEventSelected.GetIncludedEvents(Me.mExportGroup.ExportGroupID)
            Return ExportGroup.ExportIncludeEventCollection
        End Get
    End Property
    Public ReadOnly Property ExcludedEvents() As ExportEventSelectedCollection
        Get
            'Return ExportEventSelected.GetExcludedEvents(Me.mExportGroup.ExportGroupID)
            Return ExportGroup.ExportExcludeEventCollection
        End Get
    End Property
    Public Sub MoveToIncludedEvents(ByVal SelectedEvents As ExportEventAvailableCollection)
        ExportGroup.MoveToIncludedEvents(SelectedEvents)
    End Sub
    Public Sub MoveFromIncludedEvents(ByVal SelectedEvents As ExportEventSelectedCollection)
        ExportGroup.MoveFromIncludedEvents(SelectedEvents)
    End Sub
    Public Sub MoveToExcludedEvents(ByVal SelectedEvents As ExportEventAvailableCollection)
        ExportGroup.MoveToExcludedEvents(SelectedEvents)
    End Sub
    Public Sub MoveFromExcludedEvents(ByVal SelectedEvents As ExportEventSelectedCollection)
        ExportGroup.MoveFromExcludedEvents(SelectedEvents)
    End Sub
    Public Sub MoveToSelectedScripts(ByVal scriptIDs As List(Of Integer))
        SelectedSurvey.MoveScripts(scriptIDs, ExportGroupMoveDirection.AddSelected)
    End Sub
    Public Sub MoveToAvailableScripts(ByVal scriptIDs As List(Of Integer))
        SelectedSurvey.MoveScripts(scriptIDs, ExportGroupMoveDirection.RemoveSelected)
    End Sub
    Public Sub MoveToSelectedClients(ByVal clientIDs As List(Of Integer))
        SelectedSurvey.MoveClients(clientIDs, ExportGroupMoveDirection.AddSelected)
    End Sub
    Public Sub MoveToAvailableClients(ByVal clientIDs As List(Of Integer))
        SelectedSurvey.MoveClients(clientIDs, ExportGroupMoveDirection.RemoveSelected)
    End Sub



End Class
