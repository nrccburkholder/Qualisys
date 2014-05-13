Imports Nrc.QualiSys.Library

Public Class SamplePlanModule
    Inherits ConfigurationModule

#Region " Fields and Properties "

    Public Overrides ReadOnly Property Image() As System.Drawing.Image
        Get
            Return My.Resources.SamplePlan16
        End Get
    End Property

    Public Overrides ReadOnly Property Name() As String
        Get
            Return "Sample Plan"
        End Get
    End Property

    Private mEndConfigCallBack As EndConfigCallBackMethod
    Protected Property EndConfigCallBack() As EndConfigCallBackMethod
        Get
            Return mEndConfigCallBack
        End Get
        Set(ByVal value As EndConfigCallBackMethod)
            mEndConfigCallBack = value
        End Set
    End Property

    Private mIsLocked As Boolean
    Private Property IsLocked() As Boolean
        Get
            Return mIsLocked
        End Get
        Set(ByVal value As Boolean)
            mIsLocked = value
        End Set
    End Property

    Private mStudy As Library.Study
    Public Property Study() As Library.Study
        Get
            Return mStudy
        End Get
        Protected Set(ByVal value As Library.Study)
            mStudy = value
        End Set
    End Property

    Private mSurvey As Library.Survey
    Public Property Survey() As Library.Survey
        Get
            Return mSurvey
        End Get
        Protected Set(ByVal value As Library.Survey)
            mSurvey = value
        End Set
    End Property

    Private mSampleUnits As Collection(Of SampleUnit)
    Public Property SampleUnits() As Collection(Of SampleUnit)
        Get
            Return mSampleUnits
        End Get
        Protected Set(ByVal value As Collection(Of SampleUnit))
            mSampleUnits = value
        End Set
    End Property

    Public ReadOnly Property FacilityList() As Collection(Of Facility)
        Get
            'Add a entry "N/A" at the beginning
            Dim items As New Collection(Of Facility)
            Dim fac As Facility = Facility.NewFacility
            fac.Name = "N/A"
            items.Add(fac)
            Dim clientId As Integer = Me.Study.ClientId
            For Each fac In Facility.GetByClientId(clientId)
                items.Add(fac)
            Next
            Return items
        End Get
    End Property

    Private mIsEditable As Boolean = True
    Public Property IsEditable() As Boolean
        Get
            Return mIsEditable
        End Get
        Protected Set(ByVal value As Boolean)
            mIsEditable = value
        End Set
    End Property

    Private mInformation As String
    Public Property Information() As String
        Get
            Return mInformation
        End Get
        Protected Set(ByVal value As String)
            mInformation = value
        End Set
    End Property

    Private mPrioritizerViewMode As SampleUnitPrioritizer.DataViewMode = SampleUnitPrioritizer.DataViewMode.TreeAndList
    Private Property PrioritizerViewMode() As SampleUnitPrioritizer.DataViewMode
        Get
            Return mPrioritizerViewMode
        End Get
        Set(ByVal value As SampleUnitPrioritizer.DataViewMode)
            mPrioritizerViewMode = value
        End Set
    End Property

    Private mEditor As SamplePlanEditor

#End Region

#Region " Constructors "

    Public Sub New(ByVal configPanel As Panel)
        MyBase.New(configPanel)
    End Sub

#End Region

#Region " Public Methods "

    Public Overrides Sub BeginConfig(ByVal selectedClientGroup As Navigation.ClientGroupNavNode, ByVal selectedClient As Navigation.ClientNavNode, ByVal selectedStudy As Navigation.StudyNavNode, ByVal selectedSurvey As Navigation.SurveyNavNode, ByVal endConfigCallback As EndConfigCallBackMethod)
        If (selectedStudy Is Nothing OrElse selectedSurvey Is Nothing) Then Return

        Try
            Me.Reset()
            Me.Study = selectedStudy.GetStudy
            Me.Survey = selectedSurvey.GetSurvey
            Me.EndConfigCallBack = endConfigCallback

            'Get sample units. Create one if no root unit exists.
            Me.mSampleUnits = SampleUnit.GetSampleUnitsBySurveyId(Me.Survey)
            If (Me.mSampleUnits Is Nothing) Then Me.mSampleUnits = New Collection(Of SampleUnit)

            'If no unit available, create a new one
            If (Me.mSampleUnits.Count = 0) Then
                Dim unit As SampleUnit = NewSampleUnit("Root", Nothing)
            End If

            'Reset priorities to omit the gap
            SampleUnit.ReorderPriority(Me.mSampleUnits)

            If Me.Survey.IsValidated Then
                Me.Information = "You have to clear the survey validation flag before editing."
                Me.IsEditable = False
            Else
                Dim lockCategory As ConcurrencyLockCategory = ConcurrencyLockCategory.Survey
                If ConcurrencyManager.AcquireLock(lockCategory, Me.Survey.Id, CurrentUser.UserName, Environment.MachineName, Process.GetCurrentProcess.ProcessName) Then
                    Me.IsLocked = True
                Else
                    Me.IsEditable = False
                    Dim lock As ConcurrencyLock = ConcurrencyManager.ViewLock(lockCategory, Me.Survey.Id)
                    Dim lockCategoryName As String = System.Enum.GetName(lock.LockCategory.GetType, lockCategory)
                    Me.Information = String.Format("{0} Locked by {1}; process={2}; machineID={3}", lockCategoryName, lock.UserName, lock.ProcessName, lock.MachineName)
                End If
            End If

            Me.ConfigPanel.Controls.Clear()
            mEditor = New SamplePlanEditor(New EndConfigCallBackMethod(AddressOf EndConfig), Me)
            AddHandler mEditor.PrioritierViewModeChanged, AddressOf SamplePlanEditor_PrioritizerViewModeChanged
            mEditor.PrioritizerViewMode = Me.PrioritizerViewMode
            mEditor.Dock = DockStyle.Fill
            Me.ConfigPanel.Controls.Add(mEditor)

        Catch ex As Exception
            If Me.IsLocked Then
                Me.IsLocked = False
                ConcurrencyManager.ReleaseLock(ConcurrencyLockCategory.Survey, Me.Survey.Id)
            End If
            Throw
        End Try

    End Sub

    Public Shared Function GetSampleSelectionTypes() As List(Of ListItem(Of SampleSelectionType))
        Dim items As New List(Of ListItem(Of SampleSelectionType))
        items.Add(New ListItem(Of SampleSelectionType)("Non Exclusive", SampleSelectionType.NonExclusive))
        items.Add(New ListItem(Of SampleSelectionType)("Exclusive", SampleSelectionType.Exclusive))
        items.Add(New ListItem(Of SampleSelectionType)("Minor Module", SampleSelectionType.MinorModule))
        Return items
    End Function

    Public Shared Function GetCAHPSTypes(ByVal survey As Library.Survey) As List(Of ListItem(Of CAHPSType))
        Dim items As New List(Of ListItem(Of CAHPSType))
        Select Case survey.SurveyType
            Case SurveyTypes.ACOcahps
                items.Add(New ListItem(Of CAHPSType)("None", CAHPSType.None))
                items.Add(New ListItem(Of CAHPSType)("ACO CAHPS", CAHPSType.ACOCAHPS))
            Case SurveyTypes.Hcahps
                items.Add(New ListItem(Of CAHPSType)("None", CAHPSType.None))
                items.Add(New ListItem(Of CAHPSType)("HCAHPS", CAHPSType.HCAHPS))
                items.Add(New ListItem(Of CAHPSType)("HCAHPS + CHART", CAHPSType.CHART))
            Case SurveyTypes.HHcahps
                items.Add(New ListItem(Of CAHPSType)("None", CAHPSType.None))
                items.Add(New ListItem(Of CAHPSType)("Home Health CAHPS", CAHPSType.HHCAHPS))
            Case SurveyTypes.MNCM
                items.Add(New ListItem(Of CAHPSType)("None", CAHPSType.None))
                items.Add(New ListItem(Of CAHPSType)("MNCM", CAHPSType.MNCM))
            Case Else
                items.Add(New ListItem(Of CAHPSType)("None", CAHPSType.None))
        End Select
        Return items
    End Function

    Public Function NewSampleUnit(ByVal parentUnit As SampleUnit) As SampleUnit
        Return NewSampleUnit("New", parentUnit)
    End Function

#End Region

#Region " Private Methods "

    Private Sub Reset()
        mEndConfigCallBack = Nothing
        mStudy = Nothing
        mSurvey = Nothing
        mSampleUnits = Nothing
        mIsEditable = True
        mInformation = Nothing
        mEditor = Nothing
    End Sub

    Private Sub EndConfig(ByVal action As ConfigResultActions, ByVal data As Object)
        If (Me.IsEditable AndAlso _
            (action = ConfigResultActions.SampleUnitRefresh OrElse _
             action = ConfigResultActions.SampleUnitApply)) Then
            Try
                'Reorder priorities
                SampleUnit.ReorderPriority(Me.SampleUnits)

                'Update units
                For Each unit As SampleUnit In Me.SampleUnits
                    unit.Update(CurrentUser.Employee.Id)
                Next

            Catch ex As Exception
                Globals.ReportException(ex)
                Cleanup(action)
                Return
            End Try
        End If

        'If apply, we needn't close the editor.
        'Just let the editor refresh
        If (action = ConfigResultActions.SampleUnitApply) Then
            mEditor.RefreshAfterApply()
            Return
        End If

        Cleanup(action)
    End Sub

    Private Sub Cleanup(ByVal action As ConfigResultActions)
        If Me.IsLocked Then
            Me.IsLocked = False
            ConcurrencyManager.ReleaseLock(ConcurrencyLockCategory.Survey, Me.Survey.Id)
        End If
        Me.ConfigPanel.Controls.Clear()
        Dim EndConfigCallBack As EndConfigCallBackMethod = Me.EndConfigCallBack
        If (EndConfigCallBack IsNot Nothing) Then
            EndConfigCallBack(action, Nothing)
            Me.EndConfigCallBack = Nothing
        End If
    End Sub

    Private Sub SamplePlanEditor_PrioritizerViewModeChanged(ByVal sender As Object, ByVal e As PrioritierViewModeChangedEventArgs)
        Me.PrioritizerViewMode = e.ViewMode
    End Sub

    Private Function NewSampleUnit(ByVal name As String, ByVal parentUnit As SampleUnit) As SampleUnit
        Dim unit As SampleUnit

        If parentUnit Is Nothing Then
            unit = New SampleUnit(Me.Survey)
        Else
            unit = New SampleUnit(parentUnit)
        End If

        unit.Name = name
        unit.Priority = 1
        unit.SelectionType = SampleSelectionType.Exclusive
        unit.IsHcahps = False
        unit.IsACOcahps = False
        unit.IsHHcahps = False
        unit.IsCHART = False
        unit.IsMNCM = False
        unit.Criteria = New Criteria(Me.Study.Id)
        If (parentUnit Is Nothing) Then
            Me.mSampleUnits.Add(unit)
        Else
            parentUnit.ChildUnits.Add(unit)
        End If
        Return unit
    End Function

#End Region

End Class
