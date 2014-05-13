Imports Nrc.Qualisys.Library.Navigation

Public Class CopyDataStructureDialog

#Region " Private Members "

    Private mSelectedStudy As StudyNavNode

#End Region

#Region " Public Properties "

    Public ReadOnly Property SelectedStudy() As StudyNavNode
        Get
            Return mSelectedStudy
        End Get
    End Property

#End Region

#Region " Constructors "

    Public Sub New(ByVal clientFilterIndex As Integer, ByVal showAll As Boolean, ByVal showClientGroups As Boolean, ByVal selectedStudyID As Integer)

        ' This call is required by the Windows Form Designer.
        InitializeComponent()

        ' Add any initialization after the InitializeComponent() call.
        StudySelector.InitializeTree(clientFilterIndex, showAll, showClientGroups, selectedStudyID)

    End Sub

#End Region

#Region " Event Handlers "

    Private Sub StudySelector_SelectionChanged(ByVal sender As Object, ByVal e As ClientStudySurveySelectionChangedEventArgs) Handles StudySelector.SelectionChanged

        If e.SelectionType = Library.Navigation.NavigationNodeType.Study Then
            OKButton.Enabled = True
            mSelectedStudy = StudySelector.SelectedStudy
        Else
            OKButton.Enabled = False
            mSelectedStudy = Nothing
        End If

    End Sub

    Private Sub UseDefaultButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles UseDefaultButton.Click

        mSelectedStudy = Nothing
        DialogResult = Windows.Forms.DialogResult.OK
        Close()

    End Sub

    Private Sub OKButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles OKButton.Click

        DialogResult = Windows.Forms.DialogResult.OK
        Close()

    End Sub

    Private Sub Cancel_Button_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Cancel_Button.Click

        mSelectedStudy = Nothing
        DialogResult = Windows.Forms.DialogResult.Cancel
        Close()

    End Sub

#End Region

End Class
