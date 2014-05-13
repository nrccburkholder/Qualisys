Imports Nrc.InOutClient.InOutService

Module MainModule

#Region " Private Members "
    Private mBoard As InOutBoard
    Private mSelectedItem As StatusMenuItem
    Private WithEvents mSchedule As Schedule
    Private WithEvents mStatusMenu As ContextMenu
    Private WithEvents mTrayIcon As NotifyIcon
    Private Const mIconName As String = "InOutClient.InOut.ico"
    Private mAutoScheduleItem As MenuItem
    Private mEditScheduleItem As MenuItem
    Private mIsOnline As Boolean = False
    Private WithEvents mOnlineCheckTimer As Timer

    Private Delegate Sub UpdateStatusDelegate(ByVal statusId As Integer)
#End Region

#Region " Private Properties "
    Private ReadOnly Property IsDeveloper() As Boolean
        Get
            Dim p As System.Security.Principal.WindowsPrincipal
            p = New System.Security.Principal.WindowsPrincipal(System.Security.Principal.WindowsIdentity.GetCurrent)
            If p.IsInRole("NRC\Developers") Then
                Return True
            End If
            Return False
        End Get
    End Property
    Private Property SelectedItem() As StatusMenuItem
        Get
            Return mSelectedItem
        End Get
        Set(ByVal Value As StatusMenuItem)
            If Not mSelectedItem Is Nothing Then
                mSelectedItem.Checked = False
            End If
            mSelectedItem = Value
            mSelectedItem.Checked = True
            mTrayIcon.Text = "In/Out Board: " & Value.Status.Status
        End Set
    End Property

#End Region

#Region " Application Main Method "
    <STAThread()> _
    Public Sub Main()
        Using appSingleton As New System.Threading.Mutex(False, "In/Out Board Client")

            If appSingleton.WaitOne(0, False) Then
                AddHandler Microsoft.Win32.SystemEvents.SessionEnded, AddressOf SessionEnded
                AddHandler Application.ThreadException, AddressOf ThreadExceptionHandler
                AddHandler AppDomain.CurrentDomain.UnhandledException, AddressOf UnhandledExceptionHandler

                InitThemes()
                InitMessageBoard()
                InitMenu()
                If Not mIsOnline Then
                    mOnlineCheckTimer = New Timer
                    mOnlineCheckTimer.Interval = 60000
                    mOnlineCheckTimer.Start()
                End If
                mTrayIcon.Icon = My.Resources.InOutIcon
                mTrayIcon.ContextMenu = mStatusMenu
                mTrayIcon.Visible = True

                Application.Run()

                mTrayIcon.Visible = False
                RemoveHandler Microsoft.Win32.SystemEvents.SessionEnded, AddressOf SessionEnded
                RemoveHandler Application.ThreadException, AddressOf ThreadExceptionHandler
                RemoveHandler AppDomain.CurrentDomain.UnhandledException, AddressOf UnhandledExceptionHandler
            End If
        End Using
    End Sub
#End Region

#Region " Exception Handlers "
    Public Sub ThreadExceptionHandler(ByVal sender As Object, ByVal e As System.Threading.ThreadExceptionEventArgs)
        MessageBox.Show("An Exception occurred: " & e.Exception.Message, "In/Out Client Thread Exception", MessageBoxButtons.OK, MessageBoxIcon.Error)
    End Sub

    Public Sub UnhandledExceptionHandler(ByVal sender As Object, ByVal e As UnhandledExceptionEventArgs)
        MessageBox.Show("An Exception occurred: " & e.ExceptionObject.ToString, "In/Out Client Unhandled Exception", MessageBoxButtons.OK, MessageBoxIcon.Error)
    End Sub

#End Region

#Region " SessionEnded Event Handler "
    Private Sub SessionEnded(ByVal sender As Object, ByVal e As Microsoft.Win32.SessionEndedEventArgs)
        mTrayIcon.Visible = False
        Application.Exit()
    End Sub

#End Region

#Region " Initialization Methods "
    Private Sub InitThemes()
        If Environment.OSVersion.Platform = PlatformID.Win32NT AndAlso Environment.OSVersion.Version.Major >= 5 AndAlso Environment.OSVersion.Version.Minor > 0 Then
            If OSFeature.Feature.IsPresent(OSFeature.Themes) Then
                Application.EnableVisualStyles()
            End If
            Application.DoEvents()
        End If
    End Sub

    Private Sub InitMessageBoard()
        Try
            mTrayIcon = New NotifyIcon
            mBoard = InOutBoard.Instance
            mSchedule = mBoard.Schedule

            If mBoard.UserId < 0 Then
                MessageBox.Show(String.Format("Current user {0} cannot be found in the In/Out database.", mBoard.UserName), "Connection Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
                mIsOnline = False
                Application.Exit()
            End If
            mIsOnline = True
        Catch ex As System.TypeInitializationException
            mIsOnline = False
        Catch ex As System.Net.WebException
            mIsOnline = False
        Catch ex As Exception
            'Throw New ApplicationException("Unable to initialize In/Out Client.", ex)
            MessageBox.Show("Unable to connect to In/Out Board: " & vbCrLf & ex.ToString, "Connection Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            mIsOnline = False
        End Try
    End Sub

    Private Sub InitMenu()
        If mStatusMenu Is Nothing Then
            mStatusMenu = New ContextMenu
        End If
        Dim item As MenuItem

        mStatusMenu.MenuItems.Clear()
        If mIsOnline Then
            item = New MenuItem("Loading...")
            item.Enabled = False
            mStatusMenu.MenuItems.Add(item)

            Dim selectedId As Integer = mBoard.CurrentStatus.StatusID

            mStatusMenu.MenuItems.Clear()

            'Add Schedule Items
            item = New MenuItem("Auto Schedule", AddressOf ToggleSchedule)
            item.Checked = mBoard.Schedule.IsEnabled
            'item.Enabled = IsDeveloper
            item.Enabled = False
            mAutoScheduleItem = item
            mStatusMenu.MenuItems.Add(item)

            item = New MenuItem("Edit Schedule...", AddressOf ShowSchedule)
            'item.Enabled = IsDeveloper
            item.Enabled = False
            mEditScheduleItem = item
            mStatusMenu.MenuItems.Add(item)

            item = New MenuItem
            item.Text = "-"
            mStatusMenu.MenuItems.Add(item)

            'Add Status Items
            For Each status As StatusInfo In mBoard.StatusList
                item = New StatusMenuItem(status.Status, AddressOf StatusClick, status)
                If status.InOutStatusID = selectedId Then
                    SelectedItem = DirectCast(item, StatusMenuItem)
                    mTrayIcon.Text = Environment.UserName & ": " & status.Status
                End If
                mStatusMenu.MenuItems.Add(item)
            Next
        Else
            item = New MenuItem("Disconnected")
            item.Enabled = False
            mStatusMenu.MenuItems.Add(item)
        End If

        'Add menu break
        item = New MenuItem
        item.Text = "-"
        mStatusMenu.MenuItems.Add(item)

        'Add Exit
        item = New MenuItem("Exit", AddressOf ExitClick)
        mStatusMenu.MenuItems.Add(item)

    End Sub
#End Region

#Region " Status Click Event "
    Private Sub StatusClick(ByVal sender As Object, ByVal e As EventArgs)
        Try
            Cursor.Current = Cursors.WaitCursor
            Dim item As StatusMenuItem = CType(sender, StatusMenuItem)
            SelectedItem = item
            mBoard.SetStatus(item.Status.InOutStatusID)
            mTrayIcon.Text = Environment.UserName & ": " & item.Status.Status
            My.Computer.Audio.Play(My.Resources.StatusChange, AudioPlayMode.Background)
        Catch ex As System.Net.WebException
            MessageBox.Show("Error connecting to In/Out web service: " & vbCrLf & ex.ToString, "Connection Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            mIsOnline = False
            InitMenu()
        Finally
            Cursor.Current = Cursors.Default
        End Try
    End Sub

#End Region

#Region " Exit Click Event "
    Private Sub ExitClick(ByVal sender As Object, ByVal e As EventArgs)
        Try
            mBoard.Schedule.Dispose()
        Catch
        End Try
        Application.Exit()
    End Sub
#End Region

#Region " Auto-Schedule Methods "
    Private Sub ToggleSchedule(ByVal sender As Object, ByVal e As EventArgs)
        mBoard.Schedule.IsEnabled = Not mBoard.Schedule.IsEnabled
        Dim item As MenuItem = CType(sender, MenuItem)
        item.Checked = mBoard.Schedule.IsEnabled
    End Sub

    Private Sub ShowSchedule(ByVal sender As Object, ByVal e As EventArgs)
        Dim frm As New ScheduleForm
        frm.ShowDialog()
    End Sub

    Private Sub mSchedule_StatusChanged(ByVal sender As Object, ByVal e As Schedule.StatusChangedEventArgs) Handles mSchedule.StatusChanged
        If False Then 'InvokeRequired Then
            'Dim del As New UpdateStatusDelegate(AddressOf UpdateStatus)
            'Dim args(0) As Object
            'args(0) = e.NewStatusId
            'Me.BeginInvoke(del, args)
        Else
            UpdateStatus(e.NewStatusId)
        End If
    End Sub

    Private Sub UpdateStatus(ByVal statusId As Integer)
        SelectStatusMenuItem(statusId)
        mTrayIcon.Text = Environment.UserName & ": " & mBoard.GetStatusLabel(statusId)
        Dim message As String = String.Format("Your In/Out Status has changed to ""{0}""", SelectedItem.Text)
        mTrayIcon.ShowBalloonTip(5000, "In/Out Status Change", message, ToolTipIcon.Info)
    End Sub

    Private Sub SelectStatusMenuItem(ByVal statusId As Integer)
        Dim item As MenuItem
        For Each item In mStatusMenu.MenuItems
            If GetType(StatusMenuItem).IsInstanceOfType(item) Then
                If DirectCast(item, StatusMenuItem).Status.InOutStatusID = statusId Then
                    SelectedItem = DirectCast(item, StatusMenuItem)
                    Exit For
                End If

            End If
        Next
    End Sub

#End Region

#Region " Easter Egg Code "
    Private mAllowEasterEgg As Boolean = False
    Private WithEvents mEasterEggTimer As New Timer
    Private Sub mTrayIcon_MouseDown(ByVal sender As Object, ByVal e As System.Windows.Forms.MouseEventArgs) Handles mTrayIcon.MouseDown
        If e.Button = MouseButtons.Left Then
            mEasterEggTimer.Interval = 5000
            mEasterEggTimer.Start()
        ElseIf e.Button = MouseButtons.Right AndAlso mAllowEasterEgg Then
            My.Computer.Audio.Play(My.Resources.EasterEgg, AudioPlayMode.Background)
            mAutoScheduleItem.Enabled = True
            mEditScheduleItem.Enabled = True
        End If
    End Sub

    Private Sub mTrayIcon_MouseUp(ByVal sender As Object, ByVal e As System.Windows.Forms.MouseEventArgs) Handles mTrayIcon.MouseUp
        mAllowEasterEgg = False
        If e.Button = MouseButtons.Left Then
            mEasterEggTimer.Stop()
        End If
    End Sub

    Private Sub mEasterEggTimer_Tick(ByVal sender As Object, ByVal e As System.EventArgs) Handles mEasterEggTimer.Tick
        mAllowEasterEgg = True
        My.Computer.Audio.PlaySystemSound(Media.SystemSounds.Beep)
        mEasterEggTimer.Stop()
    End Sub
#End Region

    Private Sub mOnlineCheckTimer_Tick(ByVal sender As Object, ByVal e As System.EventArgs) Handles mOnlineCheckTimer.Tick
        mOnlineCheckTimer.Stop()
        InitMessageBoard()
        InitMenu()
        If mIsOnline Then
            My.Computer.Audio.PlaySystemSound(Media.SystemSounds.Beep)
        Else
            mOnlineCheckTimer.Start()
        End If
    End Sub
End Module
