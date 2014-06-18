Imports Nrc.Qualisys.Library

Public Class NewSurveyModule
    Inherits SurveyPropertiesModule

    Sub New(ByVal configPanel As Panel)

        MyBase.New(configPanel)

    End Sub

    Public Overrides ReadOnly Property Name() As String
        Get
            Return "New Survey"
        End Get
    End Property

    Public Overrides ReadOnly Property Image() As System.Drawing.Image
        Get
            Return My.Resources.New16
        End Get
    End Property

    Public Overrides Sub BeginConfig(ByVal selectedClientGroup As Navigation.ClientGroupNavNode, ByVal selectedClient As Navigation.ClientNavNode, ByVal selectedStudy As Navigation.StudyNavNode, ByVal selectedSurvey As Navigation.SurveyNavNode, ByVal endConfigCallback As EndConfigCallBackMethod)

        Reset()

        Study = selectedStudy.GetStudy
        Dim survey As Survey = New Survey()
        survey.SurveyType = SurveyTypes.DefaultSurvey
        EditingSurvey = New Library.Survey(Study)
        With EditingSurvey
            .SurveyStartDate = Date.Today
            .SurveyEndDate = Date.Today.AddDays(1)
            .ResponseRateRecalculationPeriod = 14
            .ResurveyMethod = ResurveyMethod.NumberOfDays
            .ResurveyPeriod = survey.ResurveyExclusionPeriodsNumericDefault
            .IsActive = True
            .SamplingAlgorithm = SamplingAlgorithm.StaticPlus
        End With
        Me.EndConfigCallBack = endConfigCallback

        ConfigPanel.Controls.Clear()
        Dim ctrl As New SurveyPropertiesEditor(Me, New EndConfigCallBackMethod(AddressOf EndConfig))
        ctrl.Dock = DockStyle.Fill
        ConfigPanel.Controls.Add(ctrl)

    End Sub

    Private Sub EndConfig(ByVal action As ConfigResultActions, ByVal data As Object)

        Try
            If (action = ConfigResultActions.SurveyRefresh) Then
                With EditingSurvey
                    EditingSurvey = QualiSys.Library.Survey.CreateNew(.StudyId, .Name, .Description, .ResponseRateRecalculationPeriod, .ResurveyMethod, _
                                                                      .ResurveyPeriod, .SurveyStartDate, .SurveyEndDate, .SamplingAlgorithm, .EnforceSkip, _
                                                                      CStr(.CutoffResponseCode), .CutoffTableId, .CutoffFieldId, .SampleEncounterField, _
                                                                      .ClientFacingName, .SurveyType, .SurveyTypeDefId, .HouseHoldingType, .ContractNumber, _
                                                                      .IsActive, .ContractedLanguages, .SurveySubType.Id)
                End With
                Study.Surveys.Add(EditingSurvey)
            End If

        Catch ex As Exception
            Globals.ReportException(ex)

        Finally
            Cleanup(action)

        End Try

    End Sub

    Private Sub Cleanup(ByVal action As ConfigResultActions)

        ConfigPanel.Controls.Clear()
        Dim EndConfigCallBack As EndConfigCallBackMethod = Me.EndConfigCallBack
        If (EndConfigCallBack IsNot Nothing) Then
            If (action = ConfigResultActions.SurveyRefresh) Then
                EndConfigCallBack(ConfigResultActions.SurveyAdded, EditingSurvey)
            Else
                EndConfigCallBack(action, Nothing)
            End If
            Me.EndConfigCallBack = Nothing
        End If

    End Sub

End Class
