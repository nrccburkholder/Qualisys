Imports System.Windows.Forms

''' <summary>
''' This class is a simple dialog control to prompt a user to schedule a sample generation date
''' </summary>
Public Class GenerationDateDialog

#Region " Private Members "
    Private Const GENERATION_FUTURE_DAYS_WARNING As Integer = 5
#End Region

#Region " Public Properties "
    ''' <summary>
    ''' The date that is selected in the dialog
    ''' </summary>
    Public ReadOnly Property SelectedDate() As Date
        Get
            Return Me.GenerationDate.Value
        End Get
    End Property
#End Region

#Region " Private Methods "

#Region " Control Event Handlers "
    Private Sub GenerationDateDialog_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        'Initialize the generation date to today by default
        Me.GenerationDate.Value = Date.Today
    End Sub

    Private Sub OK_Button_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles OK_Button.Click
        'Close the form and return OK
        Me.DialogResult = System.Windows.Forms.DialogResult.OK
        Me.Close()
    End Sub

    Private Sub Cancel_Button_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Cancel_Button.Click
        'Close the form and return CANCEL
        Me.DialogResult = System.Windows.Forms.DialogResult.Cancel
        Me.Close()
    End Sub

    Private Sub GenerationDate_ValueChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles GenerationDate.ValueChanged
        'When the date changes check to see if we need to display a warning

        'If the date is in the past, then show a warning
        If GenerationDate.Value < Date.Today Then
            Me.ShowWarning("The generation date is in the past!")
            Return
        End If

        'If the date is more than X days in the future, then show a warning
        If GenerationDate.Value > Date.Today.AddDays(GENERATION_FUTURE_DAYS_WARNING) Then
            Me.ShowWarning("The generation will not occur for {0} days!", GenerationDate.Value.Subtract(Date.Today).Days)
            Return
        End If

        'No warnings found so hide the warning
        Me.ToggleWarningVisibility(False)
    End Sub

#End Region

    ''' <summary>
    ''' Displays a warning message on the screen
    ''' </summary>
    ''' <param name="messageFormat">The warning message as a parameterized string</param>
    ''' <param name="args">The list of parameters to be concatenated with the string</param>
    Private Sub ShowWarning(ByVal messageFormat As String, ByVal ParamArray args() As Object)
        Me.ShowWarning(String.Format(messageFormat, args))
    End Sub

    ''' <summary>
    ''' Displays a warning message on the screen
    ''' </summary>
    Private Sub ShowWarning(ByVal message As String)
        Me.WarningLabel.Text = message
        Me.ToggleWarningVisibility(True)
    End Sub

    ''' <summary>
    ''' Turns ON or OFF the visibility of the warning
    ''' </summary>
    ''' <param name="isVisible">If True, the warning will be visible, otherwise it will be invisible</param>
    ''' <remarks></remarks>
    Private Sub ToggleWarningVisibility(ByVal isVisible As Boolean)
        Me.WarningLabel.Visible = isVisible
        Me.WarningImage.Visible = isVisible
    End Sub

#End Region

End Class
