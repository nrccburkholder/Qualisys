Public Class ScheduleForm

    Private mBoard As InOutBoard = InOutBoard.Instance
    Private mAutoChange As Boolean = False
    Private mSchedule As Schedule = DirectCast(mBoard.Schedule.Clone, Schedule)

    Private Sub mnuEvents_Popup(ByVal sender As Object, ByVal e As System.ComponentModel.CancelEventArgs) Handles EventsMenu.Opening
        Dim pt As Point = lbxEvents.PointToClient(System.Windows.Forms.Cursor.Position)
        Dim item As ListViewItem = lbxEvents.GetItemAt(pt.X, pt.Y)
        e.Cancel = item Is Nothing
    End Sub

    Private Sub frmSchedule_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        PopulateStatusList()
        PopulateEvents()

        txtTime.Text = InOutClient.ScheduleEvent.Time.FromTimeSpan(DateTime.Now.TimeOfDay).ToString
        Me.txtTime_Leave(Me, New EventArgs)
    End Sub

#Region " Item Structure "

#End Region
    Private Structure Item
        Private _name As String
        Private _value As Integer

        Public ReadOnly Property Name() As String
            Get
                Return _name
            End Get
        End Property
        Public ReadOnly Property Value() As Integer
            Get
                Return _value
            End Get
        End Property
        Sub New(ByVal name As String, ByVal value As Integer)
            _name = name
            _value = value
        End Sub
    End Structure

    Private Sub PopulateStatusList()
        Dim items(mBoard.StatusList.Length - 1) As Item
        Dim item As Item
        Dim i As Integer = 0
        For Each stat As InOutService.StatusInfo In mBoard.StatusList
            item = New Item(stat.Status, stat.InOutStatusID)
            items(i) = item
            i += 1
        Next

        ddlStatus.Items.Clear()
        ddlStatus.DataSource = items
        ddlStatus.DisplayMember = "Name"
        ddlStatus.ValueMember = "Value"
        ddlStatus.SelectedIndex = 0
    End Sub

    Private Sub DeleteToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles DeleteToolStripMenuItem.Click
        Dim evnt As ScheduleEvent = DirectCast(lbxEvents.SelectedItems(0).Tag, ScheduleEvent)
        mSchedule.Events.Remove(evnt)
        PopulateEvents()
    End Sub

    Private Sub btnAdd_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnAdd.Click
        Dim freq As ScheduleEvent.EventFrequency
        Try
            freq = Me.SelectedFrequency
        Catch ex As Exception
            MessageBox.Show(ex.Message, "Event Creation Exception", MessageBoxButtons.OK, MessageBoxIcon.Error)
            Exit Sub
        End Try

        Dim span As TimeSpan = DateTime.Parse(txtTime.Text).TimeOfDay

        mSchedule.Events.Add(New ScheduleEvent(freq, New InOutClient.ScheduleEvent.Time(span.Hours, span.Minutes), CType(ddlStatus.SelectedValue, Integer)))
        PopulateEvents()
    End Sub

    Private Sub btnOK_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnOK.Click
        mSchedule.Serialize()
        mBoard.Schedule = mSchedule
        Me.DialogResult = Windows.Forms.DialogResult.OK
    End Sub

    Private Sub btnCancel_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnCancel.Click
        Me.DialogResult = Windows.Forms.DialogResult.Cancel
    End Sub


    Private ReadOnly Property SelectedFrequency() As ScheduleEvent.EventFrequency
        Get
            Dim freq As ScheduleEvent.EventFrequency = 0

            If rbDaily.Checked Then
                freq = ScheduleEvent.EventFrequency.Daily
            ElseIf rbWeekdays.Checked Then
                freq = ScheduleEvent.EventFrequency.Weekdays
            ElseIf rbWeekEnds.Checked Then
                freq = ScheduleEvent.EventFrequency.Weekends
            ElseIf rbOther.Checked Then
                If cbxSunday.Checked Then
                    freq = (freq Or ScheduleEvent.EventFrequency.Sunday)
                End If
                If cbxMonday.Checked Then
                    freq = (freq Or ScheduleEvent.EventFrequency.Monday)
                End If
                If cbxTuesday.Checked Then
                    freq = (freq Or ScheduleEvent.EventFrequency.Tuesday)
                End If
                If cbxWednesday.Checked Then
                    freq = (freq Or ScheduleEvent.EventFrequency.Wednesday)
                End If
                If cbxThursday.Checked Then
                    freq = (freq Or ScheduleEvent.EventFrequency.Thursday)
                End If
                If cbxFriday.Checked Then
                    freq = (freq Or ScheduleEvent.EventFrequency.Friday)
                End If
                If cbxSaturday.Checked Then
                    freq = (freq Or ScheduleEvent.EventFrequency.Saturday)
                End If
            End If

            If freq = 0 Then
                Throw New ApplicationException("No day has been selected for the frequency.")
            End If

            Return freq
        End Get
    End Property

    Private Sub PopulateEvents()
        lbxEvents.Items.Clear()
        Dim item As New ListViewItem
        For Each evnt As ScheduleEvent In mSchedule.Events
            item = New ListViewItem
            'item.Text = System.Enum.GetName(GetType(ScheduleEvent.EventFrequency), evnt.Frequency)
            item.Text = evnt.Frequency.ToString
            item.SubItems.Add(evnt.ScheduledTime.ToString)
            item.SubItems.Add(GetStatusText(evnt.StatusId))
            item.Tag = evnt
            lbxEvents.Items.Add(item)
        Next
    End Sub

    Private Function GetStatusText(ByVal statusId As Integer) As String
        For Each status As InOutService.StatusInfo In mBoard.StatusList
            If status.InOutStatusID = statusId Then
                Return status.Status
            End If
        Next
        Return ""
    End Function

    Private Sub txtTime_Leave(ByVal sender As Object, ByVal e As System.EventArgs) Handles txtTime.Leave
        Dim time As DateTime
        Try
            time = DateTime.Parse(txtTime.Text)
        Catch ex As Exception
            MessageBox.Show("You must enter a valid time value.", "Time Validation Exception", MessageBoxButtons.OK, MessageBoxIcon.Error)
            txtTime.Focus()
        End Try

        Dim minString As String
        Dim timeString As String
        If time.Minute <= 15 Then
            minString = "00"
        Else
            minString = "30"
        End If
        If time.Hour > 12 Then
            timeString = String.Format("{0}:{1} PM", time.Hour - 12, minString)
        Else
            timeString = String.Format("{0}:{1} AM", time.Hour, minString)
        End If
        mAutoChange = True
        ddlTime.Text = timeString
    End Sub

    Private Sub ddlTime_SelectedIndexChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ddlTime.SelectedIndexChanged
        If mAutoChange Then
            mAutoChange = False
        Else
            txtTime.Text = ddlTime.Text
        End If
    End Sub

    Private Sub FreqCheckedChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles rbDaily.CheckedChanged, rbWeekdays.CheckedChanged, rbWeekEnds.CheckedChanged, rbOther.CheckedChanged
        SetDayState()
    End Sub

    Private Sub SetDayState()
        Dim enabled As Boolean = False
        Dim weekDays As Boolean = False
        Dim weekEnds As Boolean = False
        If Me.rbDaily.Checked Then
            enabled = False
            weekDays = True
            weekEnds = True
        ElseIf Me.rbWeekdays.Checked Then
            enabled = False
            weekDays = True
            weekEnds = False
        ElseIf Me.rbWeekEnds.Checked Then
            enabled = False
            weekDays = False
            weekEnds = True
        ElseIf Me.rbOther.Checked Then
            enabled = True
            weekDays = False
            weekEnds = False
        End If

        cbxSunday.Checked = weekEnds
        cbxMonday.Checked = weekDays
        cbxTuesday.Checked = weekDays
        cbxWednesday.Checked = weekDays
        cbxThursday.Checked = weekDays
        cbxFriday.Checked = weekDays
        cbxSaturday.Checked = weekEnds

        cbxSunday.Enabled = enabled
        cbxMonday.Enabled = enabled
        cbxTuesday.Enabled = enabled
        cbxWednesday.Enabled = enabled
        cbxThursday.Enabled = enabled
        cbxFriday.Enabled = enabled
        cbxSaturday.Enabled = enabled
    End Sub

End Class