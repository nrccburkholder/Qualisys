Imports Nrc.SurveyPoint.Library

Public Class UpdateEventSection

#Region "Private Members"

    Private mSubSection As Section

    Private WithEvents mNavigator As UpdateEventNavigator

#End Region

#Region "Baseclass Overrides"

    Public Overrides Sub RegisterNavControl(ByVal navCtrl As Navigator)

        mNavigator = DirectCast(navCtrl, UpdateEventNavigator)

    End Sub

    Public Overrides Function AllowInactivate() As Boolean

        If mSubSection Is Nothing Then
            Return True
        Else
            Return mSubSection.AllowInactivate
        End If

    End Function

#End Region

#Region "Events"

    Private Sub mNavigator_ButtonClicked(ByVal sender As Object, ByVal e As UpdateEventButtonClickedEventArgs) Handles mNavigator.ButtonClicked

        'Check to see if we are already displaying the right one
        If (e.ButtonClicked = UpdateEventButtonsEnum.UpdateCodes AndAlso TypeOf mSubSection Is UpdateEventCodesSection) OrElse _
           (e.ButtonClicked = UpdateEventButtonsEnum.ViewLog AndAlso TypeOf mSubSection Is UpdateEventLogSection) Then
            Exit Sub
        End If

        'Check to see if we are allowed to switch views
        If Not AllowInactivate() Then
            Exit Sub
        End If

        'Clear the current control
        Me.Controls.Clear()

        'Create the new control
        Select Case e.ButtonClicked
            Case UpdateEventButtonsEnum.UpdateCodes
                mSubSection = New UpdateEventCodesSection(UpdateEventCodesViewModes.FileMode)

            Case UpdateEventButtonsEnum.ViewLog
                mSubSection = New UpdateEventLogSection(Me)

        End Select

        'Display the new control
        mSubSection.Dock = DockStyle.Fill
        Me.Controls.Add(mSubSection)

    End Sub

#End Region

#Region "Public Methods"

    Public Sub RerunLogItem(ByVal logItem As UpdateFileLog)

        'Clear the current control
        Me.Controls.Clear()

        'Create the new control
        mSubSection = New UpdateEventCodesSection(UpdateEventCodesViewModes.EventLogMode, logItem)

        'Display the new control
        mSubSection.Dock = DockStyle.Fill
        Me.Controls.Add(mSubSection)

    End Sub

#End Region

End Class
