Imports DevExpress.XtraScheduler
Public Class SamplePeriodsSchedulingWizardDialog

#Region "Private Members"
    Private mRecurrenceInfo As New RecurrenceInfo
    Private mSelectedRecurrenceControl As New UI.RecurrenceControlBase
    Private mCheckedRadioButton As RadioButton
    Private mOccurrenceNumber As Integer
#End Region

#Region "Properties"

    ''' <summary>
    ''' Label that appears next to the occurrence number control
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Property OccurrenceNumberLabel() As String
        Get
            Return Me.SchedulingWizardControl.OccurrenceLabel.Text
        End Get
        Set(ByVal value As String)
            Me.SchedulingWizardControl.OccurrenceLabel.Text = value
        End Set
    End Property

    ''' <summary>
    ''' Label that appears next to the baseline date incrementor control
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Property BaseLineDateIncrementLabel() As String
        Get
            Return Me.SchedulingWizardControl.BaseLineDateIncrementNumberLabel.Text
        End Get
        Set(ByVal value As String)
            Me.SchedulingWizardControl.BaseLineDateIncrementNumberLabel.Text = value
        End Set
    End Property

    ''' <summary>
    ''' Gets or sets the checked Radion button
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Property SamplingSchedule() As Qualisys.Library.SamplePeriod.SamplingSchedule
        Get
            Return Me.SchedulingWizardControl.SamplingSchedule
        End Get
        Set(ByVal value As Qualisys.Library.SamplePeriod.SamplingSchedule)
            Me.SchedulingWizardControl.SamplingSchedule = value
        End Set
    End Property
#End Region

#Region "Constructors"
    Public Sub New(ByVal occurrenceNumberLabel As String, ByVal baselineDateIncrementLabel As String)
        Me.InitializeComponent()
        Me.OccurrenceNumberLabel = occurrenceNumberLabel
        Me.BaseLineDateIncrementLabel = baselineDateIncrementLabel
    End Sub
#End Region

#Region "Event Handlers"
    Private Sub OKButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles OKButton.Click
        Me.DialogResult = Windows.Forms.DialogResult.OK
        Me.Close()
    End Sub

    Private Sub CancelButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Cancel_Button.Click
        Me.DialogResult = Windows.Forms.DialogResult.Cancel
        Me.Close()
    End Sub
#End Region

#Region "Public Methods"
    ''' <summary>
    ''' Returns a collection of dates based on the scheduling settings and the baseline date.
    ''' </summary>
    ''' <param name="baseLineDate"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Function CalculateDates(ByVal baseLineDate As Date) As Collection(Of Date)
        Return Me.SchedulingWizardControl.CalculateDates(baseLineDate)
    End Function

    ''' <summary>
    ''' Returns a collection of dates based on the scheduling settings and the baseline date.
    ''' </summary>
    ''' <returns></returns>
    ''' <remarks>Uses the current date as the baseline</remarks>
    Public Function CalculateDates() As Collection(Of Date)
        Return Me.SchedulingWizardControl.CalculateDates(Today)
    End Function
#End Region

End Class