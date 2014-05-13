Imports Nrc.Qualisys.Library
Public Class ForceRecalculate

#Region "Private Members"

    Private mMedicareNumber As MedicareNumber

#End Region

#Region "Constructors"

    Public Sub New(ByVal medicareNum As MedicareNumber)

        InitializeComponent()

        mMedicareNumber = medicareNum
        InitMedicareValues()

    End Sub

#End Region

#Region "Event Handlers"

    Private Sub ForceRecalculate_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        'Set the section header
        Me.Caption = String.Format("Force Recalculation For: {0} ({1})", mMedicareNumber.MedicareNumber, mMedicareNumber.Name)

    End Sub

    Private Sub cmdCancel_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdCancel.Click

        Me.DialogResult = Windows.Forms.DialogResult.Cancel
        Me.Close()

    End Sub

    Private Sub cmdCalculate_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdCalculate.Click

        Try
            'Set the wait cursor
            Me.Cursor = Cursors.WaitCursor

            If Not mMedicareNumber.SamplingLocked Then
                Dim message As String = String.Empty
                Dim sampleLockNotifyFailed As Boolean = False
                If mMedicareNumber.ForceRecalculate(CDate(cboCalcDates.SelectedItem), CurrentUser.MemberID, sampleLockNotifyFailed) Then
                    'Display a success message to the user
                    message = "Calculation Successful."

                    'Determine if we need to notify the user of a sample lock
                    If mMedicareNumber.SamplingLocked Then
                        message &= vbCrLf & vbCrLf & "Sampling has been locked due to the new proportion" & vbCrLf & _
                                                     "exceeding the allowable threshold."

                        'Determine if we need to display the sample lock notification failed message
                        If sampleLockNotifyFailed Then
                            message &= vbCrLf & vbCrLf & "The system was unable to send a notification to the" & vbCrLf & _
                                                         "HCAHPSThresholdExceeded email group."
                        End If
                    End If

                    MessageBox.Show(message, "Proportion Calculation", MessageBoxButtons.OK, MessageBoxIcon.Information)
                    Me.DialogResult = Windows.Forms.DialogResult.OK
                    Me.Close()
                Else
                    'Display an error message to the user
                    message = "Calculation Failed!." & vbCrLf
                    For Each errString As String In mMedicareNumber.CalculationErrors
                        message &= vbCrLf & errString
                    Next
                    MessageBox.Show(message, "Proportion Calculation Error!", MessageBoxButtons.OK, MessageBoxIcon.Error)
                End If
            Else
                'Tell the user that they need to unlock sampling first
                MessageBox.Show("Sampling must first be unlocked before calculating the proportion.", "Proportion Calculation Error!", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End If

        Catch ex As Exception
            Globals.ReportException(ex, "Proportion Calculation Error")

        Finally
            'Reset the wait cursor
            Me.Cursor = Me.DefaultCursor

        End Try

    End Sub

#End Region

#Region "Private Methods"

    Private Sub InitMedicareValues()

        Dim setMonth As Integer = 0
        Dim index As Integer = 0
        Dim globalRecalcDates As MedicareGlobalCalcDateCollection = MedicareGlobalCalcDate.GetAll()
        Dim monthList As New List(Of Integer)

        For Each item As MedicareGlobalCalcDate In globalRecalcDates
            monthList.Add(item.ReCalcMonth)
        Next
        monthList.Sort()

        Dim dte As Date = Now
        For j As Integer = 0 To monthList.Count - 1
            If dte.Month >= monthList(j) Then
                setMonth = monthList(j)
                index = j
            End If
        Next

        cboCalcDates.Items.Add(CDate(setMonth & "/1/" & dte.Year))
        If monthList(0) = setMonth Then
            cboCalcDates.Items.Add(CDate(monthList(monthList.Count - 1) & "/1/" & (dte.Year - 1)))
        Else
            cboCalcDates.Items.Add(CDate(monthList(index - 1) & "/1/" & dte.Year))
        End If

    End Sub

#End Region

End Class
