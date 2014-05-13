Imports System.IO
Imports Nrc.LaunchPad.Library

Public Class MainForm

#Region " Private Members "
    Private mSelectedView As ViewStyle = ViewStyle.Tiles
    Private mSelectedCategory As String
    Private mApplications As ApplicationCollection
    Private mIsFirstMinimize As Boolean = True
    Private mMinimizeOnLaunch As Boolean = False
    Private mStartMinimized As Boolean = False
    Private mRefreshTimer As System.Threading.Timer
    Private Const mTimerInterval As Integer = 1000 * 60 * 10
    Private Delegate Sub RefreshApplicationListDelegate(ByVal state As Object)
#End Region

#Region " Private Properties "
    Private Property SelectedView() As ViewStyle
        Get
            Return Me.mSelectedView
        End Get
        Set(ByVal value As ViewStyle)
            Me.mSelectedView = value
            Me.ListToolStripMenuItem.Checked = (Me.mSelectedView = ViewStyle.List)
            Me.TileToolStripMenuItem.Checked = (Me.mSelectedView = ViewStyle.Tiles)
        End Set
    End Property

    Private Property MinimizeOnLaunch() As Boolean
        Get
            Return Me.mMinimizeOnLaunch
        End Get
        Set(ByVal value As Boolean)
            Me.mMinimizeOnLaunch = value
            Me.MinimizeOnLaunchToolStripMenuItem.Checked = Me.mMinimizeOnLaunch
        End Set
    End Property
    Private Property StartMinimized() As Boolean
        Get
            Return Me.mStartMinimized
        End Get
        Set(ByVal value As Boolean)
            Me.mStartMinimized = value
            Me.StartMinimizedToolStripMenuItem.Checked = value
        End Set
    End Property
    Private ReadOnly Property RunOnStartup() As Boolean
        Get
            Dim runKey As Microsoft.Win32.RegistryKey = My.Computer.Registry.CurrentUser.OpenSubKey("Software\Microsoft\Windows\CurrentVersion\Run", True)
            Return runKey.GetValue("LaunchPad") IsNot Nothing
        End Get
    End Property
#End Region

#Region " Constructors "
    Sub New()
        ' This call is required by the Windows Form Designer.
        InitializeComponent()

        ' Add any initialization after the InitializeComponent() call.

        'Load the user settings
        Me.LoadSettings()

        'Get the list of applications from all providers
        Me.GetApplicationList()

        'Load the launch buttons
        Me.LoadLaunchButtons()

        'Load any admin menu items
        Me.LoadAdminItems()

        'Set rendering colors
        If Windows.Forms.Application.RenderWithVisualStyles Then
            Me.BackColor = ProfessionalColors.MenuStripGradientBegin
            'Me.TitleBar.BackColorLeft = ProfessionalColors.MenuStripGradientBegin
            'Me.TitleBar.BackColorRight = ProfessionalColors.MenuStripGradientEnd
        Else
            Me.BackColor = Color.FromArgb(158, 190, 245)
            'Me.TitleBar.BackColorLeft = Color.FromArgb(158, 190, 245)
            'Me.TitleBar.BackColorRight = Color.FromArgb(196, 218, 250)

            Dim renderer As New BluesRenderer
            Me.MenuStrip1.Renderer = renderer
            Me.StatusStrip1.Renderer = renderer
        End If

        'Setup refresh timer
        Dim refreshCallback As New System.Threading.TimerCallback(AddressOf RefreshApplicationList)
        mRefreshTimer = New System.Threading.Timer(refreshCallback, Nothing, mTimerInterval, mTimerInterval)
    End Sub
#End Region

#Region " Control Event Handlers "
    Private Sub MainForm_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load        
        SetStatusStrip()
        If Me.StartMinimized Then
            Me.HideToTray()
        End If
    End Sub

    Private Sub MainForm_FormClosing(ByVal sender As Object, ByVal e As System.Windows.Forms.FormClosingEventArgs) Handles Me.FormClosing
        Me.SaveSettings()
    End Sub

    Private Sub TitleBar_CloseButtonClicked(ByVal sender As System.Object, ByVal e As System.EventArgs)
        Me.Close()
    End Sub

    Private Sub TitleBar_MinimizeButtonClicked(ByVal sender As Object, ByVal e As System.EventArgs)
        Me.HideToTray()
    End Sub

    Private Sub CategoryTabs_TabChanged(ByVal sender As Object, ByVal e As TabPanel.TabChangedEventArgs) Handles CategoryTabs.TabChanged
        Me.mSelectedCategory = e.NewTab.Text
        Me.LoadLaunchButtons()
    End Sub

    Private Sub LaunchButtonMouseEnter(ByVal sender As Object, ByVal e As EventArgs)
        'When the mouse is over a button, set the description text in status bar
        Dim btn As LaunchButton = TryCast(sender, LaunchButton)
        If btn IsNot Nothing Then
            Me.DescriptionLabel.Text = btn.Application.Description
        End If
    End Sub

    Private Sub LaunchButtonMouseLeave(ByVal sender As Object, ByVal e As EventArgs)
        'Clear description text from status bar since mouse not over button
        Me.DescriptionLabel.Text = ""
    End Sub

    Private Sub LaunchButtonMouseClick(ByVal sender As Object, ByVal e As MouseEventArgs)
        'If this is a left-click then get Application object from button
        If e.Button = Windows.Forms.MouseButtons.Left Then
            Dim btn As LaunchButton = TryCast(sender, LaunchButton)
            If btn IsNot Nothing Then
                If btn.Application IsNot Nothing AndAlso Not String.IsNullOrEmpty(btn.Application.Path) Then
                    'Launch the application
                    Me.LaunchApplication(btn.Application)
                End If

            End If
        End If
    End Sub

    Private Sub TrayLaunchClick(ByVal sender As Object, ByVal e As EventArgs)
        'Get the menu item that was clicked
        Dim menuItem As ToolStripMenuItem = TryCast(sender, ToolStripMenuItem)
        If menuItem IsNot Nothing Then
            'Get the application object
            Dim app As Application = TryCast(menuItem.Tag, Application)
            If app IsNot Nothing AndAlso Not String.IsNullOrEmpty(app.Path) Then
                'Launch the application
                Me.LaunchApplication(app)
            End If
        End If
    End Sub

    Private Sub TileToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles TileToolStripMenuItem.Click
        'Switch from "List View" to "Tile View"
        Me.TileToolStripMenuItem.Checked = True
        Me.ListToolStripMenuItem.Checked = False
        Me.mSelectedView = ViewStyle.Tiles

        'Reload the buttons
        Me.LoadLaunchButtons()
    End Sub

    Private Sub ListToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ListToolStripMenuItem.Click
        'Switch from "Tile View" to "List View"
        Me.TileToolStripMenuItem.Checked = False
        Me.ListToolStripMenuItem.Checked = True
        Me.mSelectedView = ViewStyle.List

        'Reload the buttons now
        Me.LoadLaunchButtons()
    End Sub

    Private Sub ExitLaunchPadToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ExitLaunchPadToolStripMenuItem.Click
        'Close the form
        Me.TrayIcon.Visible = False
        Me.Close()
    End Sub

    Private Sub ExitMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ExitMenuItem.Click
        Me.Close()
    End Sub

    Private Sub ShowLaunchPadToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ShowLaunchPadToolStripMenuItem.Click
        'Unhide the form
        Me.UnhideFromTray()
    End Sub

    Private Sub TrayIcon_MouseClick(ByVal sender As Object, ByVal e As System.Windows.Forms.MouseEventArgs) Handles TrayIcon.MouseClick
        'If use left-clicks the tray icon then unhide form
        If e.Button = Windows.Forms.MouseButtons.Left Then
            Me.UnhideFromTray()
        End If
    End Sub

    Private Sub MinimizeOnLaunchToolStripMenuItem_CheckedChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles MinimizeOnLaunchToolStripMenuItem.CheckedChanged
        'Toggle the "Minimize On Launch" setting
        Me.mMinimizeOnLaunch = Me.MinimizeOnLaunchToolStripMenuItem.Checked
    End Sub

    Private Sub CategoryTabs_DragDrop(ByVal sender As Object, ByVal e As System.Windows.Forms.DragEventArgs) Handles CategoryTabs.DragDrop
        'If this is a file drop...
        If e.Data.GetDataPresent(DataFormats.FileDrop) Then
            Dim myFiles() As String
            Dim file As FileInfo
            Dim i As Integer
            Dim app As Application

            ' Assign the files to an array.
            myFiles = CType(e.Data.GetData(DataFormats.FileDrop), String())
            ' Loop through the array and add the files to the list.
            For i = 0 To myFiles.Length - 1
                file = New FileInfo(myFiles(i))
                app = New Application
                app.CategoryName = Me.mSelectedCategory
                app.DeploymentType = DeploymentType.LocalInstall
                If file.Extension = ".url" Then
                    app.Path = ExtractURL(file.FullName)
                    app.DeploymentType = DeploymentType.WebApplication
                Else
                    app.Path = file.FullName
                    'app.Path = ExtractTarget(file.FullName)
                    app.DeploymentType = DeploymentType.LocalInstall
                End If
                app.Name = file.Name.Replace(file.Extension, "")
                app.Description = ApplicationDescriptionDialog(app.Name)
                mApplications.Add(app)
                app.Image = Drawing.Icon.ExtractAssociatedIcon(file.FullName).ToBitmap
                ApplicationProvider.DefaultProvider.AddApplication(app)
            Next
            Me.LoadLaunchButtons()
        End If
    End Sub

    Private Sub CategoryTabs_DragEnter(ByVal sender As Object, ByVal e As System.Windows.Forms.DragEventArgs) Handles CategoryTabs.DragEnter
        'Allow only file drops
        If e.Data.GetDataPresent(DataFormats.FileDrop) Then
            e.Effect = DragDropEffects.All
        End If
    End Sub

    Private Sub StartMinimizedToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles StartMinimizedToolStripMenuItem.Click
        Me.mStartMinimized = Me.StartMinimizedToolStripMenuItem.Checked
    End Sub

    Private Sub RunOnStartupToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles RunOnStartupToolStripMenuItem.Click
        Dim runKey As Microsoft.Win32.RegistryKey = My.Computer.Registry.CurrentUser.OpenSubKey("Software\Microsoft\Windows\CurrentVersion\Run", True)
        If Me.RunOnStartupToolStripMenuItem.Checked Then
            If runKey IsNot Nothing Then
                Dim appPath As String
                If My.Application.IsNetworkDeployed Then
                    appPath = Uri.EscapeUriString(My.Application.Deployment.UpdateLocation.ToString)
                Else
                    appPath = System.Reflection.Assembly.GetExecutingAssembly.Location
                End If
                runKey.SetValue("LaunchPad", appPath)
            End If
        Else
            If runKey IsNot Nothing Then
                runKey.DeleteValue("LaunchPad", False)
            End If
        End If
    End Sub
#End Region

#Region " Form Overrides "

    Protected Overrides Sub OnPaintBackground(ByVal e As System.Windows.Forms.PaintEventArgs)
        MyBase.OnPaintBackground(e)

        'Draw form border
        Dim rect As New Rectangle(0, 0, Me.Width - 1, Me.Height - 1)
        e.Graphics.DrawRectangle(Pens.DimGray, rect)
    End Sub

#End Region

#Region " Private Methods "

    'TP 20080620  This method was implmeneted to show a status strip similar to other NRC applications
    Private Sub SetStatusStrip()
        Me.DescriptionLabel.Text = ""
        Me.lblUserName.Text = Environment.UserName
        Me.lblVersion.Text = "v" & My.Application.Info.Version.ToString
    End Sub
    Private Sub SaveSettings()
        'Save the user settings
        My.Settings.CurrentView = Me.SelectedView
        My.Settings.MinimizeOnLaunch = Me.MinimizeOnLaunch
        My.Settings.StartMinimized = Me.StartMinimized
        My.Settings.Save()
    End Sub

    Private Sub LoadSettings()
        'Load up the user settings
        Me.SelectedView = CType(My.Settings.CurrentView, ViewStyle)
        Me.MinimizeOnLaunch = My.Settings.MinimizeOnLaunch
        Me.StartMinimized = My.Settings.StartMinimized
        Me.mIsFirstMinimize = Not My.Settings.StartMinimized
        Me.RunOnStartupToolStripMenuItem.Checked = Me.RunOnStartup
    End Sub

    Private Sub GetApplicationList()
        Dim currentCategory As String = Me.mSelectedCategory

        'Get all the applications from all providers
        Me.mApplications = ApplicationProvider.GetUserApplications()

        'Clear out the category tabs
        Me.CategoryTabs.Tabs.Clear()

        'Clear out all items from the tray context menu
        Me.TrayMenu.Items.Clear()

        'Add the "Show Pad" and Separator items back into the context menu
        Me.TrayMenu.Items.Add(Me.ShowLaunchPadToolStripMenuItem)
        Me.TrayMenu.Items.Add(Me.ToolStripSeparator1)

        'Now for each category in the app list...
        For Each categoryName As String In Me.mApplications.GetCategories
            'Create a new tab
            Dim t As New Tab
            t.Text = categoryName
            Me.CategoryTabs.Tabs.Add(t)

            'Create a new menu item for the tray context menu
            Dim item As ToolStripMenuItem = DirectCast(Me.TrayMenu.Items.Add(categoryName), ToolStripMenuItem)

            'Now for each application in this category...
            For Each app As Application In Me.mApplications
                If app.CategoryName = categoryName Then
                    'Add the tray menu item
                    Dim appItem As ToolStripItem = item.DropDownItems.Add(app.Name, app.Image, AddressOf TrayLaunchClick)
                    appItem.Tag = app
                End If
            Next

            'Check to see if this tab is the currently "selected" tab and if so, select it
            If Not String.IsNullOrEmpty(currentCategory) AndAlso categoryName = currentCategory Then
                Me.CategoryTabs.SelectTab(t)
            End If
        Next

        'Now finish the tray context menu with another separator and the exit item
        Me.TrayMenu.Items.Add(Me.ToolStripSeparator2)
        Me.TrayMenu.Items.Add(Me.ExitLaunchPadToolStripMenuItem)
    End Sub

    Private Sub LoadAdminItems()
        'Check each provider and see if the user has admin access
        For Each providerName As String In ApplicationProvider.ProviderList
            Dim provider As ApplicationProvider = ApplicationProvider.Provider(providerName)

            If provider.CanAdministerApplications() Then
                'If they have admin access then add it to the aministration menu
                Dim item As ToolStripMenuItem = DirectCast(Me.AdministrationMenuItem.DropDownItems.Add("Manage " & providerName & " Applications"), ToolStripMenuItem)
                AddHandler item.Click, AddressOf AdminItemClick
                item.Tag = provider
            End If
        Next
    End Sub

    Private Sub AdminItemClick(ByVal sender As Object, ByVal e As EventArgs)
        'When a user clicks on a "Manage ... Applications" item
        'Get the menu item clicked
        Dim item As ToolStripMenuItem = TryCast(sender, ToolStripMenuItem)
        If item IsNot Nothing Then
            'Get the provider associated with the item clicked
            Dim provider As ApplicationProvider = TryCast(item.Tag, ApplicationProvider)
            If provider IsNot Nothing Then
                'Show the Applicaiton Manager form
                Dim frm As New ApplicationManagerForm(provider)

                If frm.ShowDialog(Me) = Windows.Forms.DialogResult.OK Then
                    'If they changed something then reload all the applications
                    Me.GetApplicationList()
                    'And also reaload the launch buttons for the selected tab
                    Me.LoadLaunchButtons()
                End If

            End If
        End If
    End Sub

    Private Sub LoadLaunchButtons()
        Dim pnl As FlowLayoutPanel = Me.CategoryTabs.Panel

        'Unattach the event handlers
        For Each btn As LaunchButton In pnl.Controls
            If btn.Application IsNot Nothing Then
                RemoveHandler btn.MouseEnter, AddressOf LaunchButtonMouseEnter
                RemoveHandler btn.MouseLeave, AddressOf LaunchButtonMouseLeave
                RemoveHandler btn.MouseClick, AddressOf LaunchButtonMouseClick
            End If
        Next

        'Clear the panel
        pnl.Controls.Clear()

        'Set the panel flow based on the selected view
        Select Case Me.mSelectedView
            Case ViewStyle.Tiles
                pnl.FlowDirection = FlowDirection.LeftToRight
            Case ViewStyle.List
                pnl.FlowDirection = FlowDirection.TopDown
            Case Else
                pnl.FlowDirection = FlowDirection.LeftToRight
        End Select

        'Get a list of all applications for the current tab
        Dim apps As List(Of Application)
        Dim match As New Predicate(Of Application)(AddressOf IsApplicationInSelectedCategory)
        apps = mApplications.FindAll(match)

        'Now for each application in the selected tab
        For Each app As Application In apps
            'Create the button
            Dim btn As LaunchButton = LaunchButton.GetNewLaunchButton(Me.mSelectedView)
            btn.Application = app
            pnl.Controls.Add(btn)

            'Attach the event handlers
            AddHandler btn.MouseEnter, AddressOf LaunchButtonMouseEnter
            AddHandler btn.MouseLeave, AddressOf LaunchButtonMouseLeave
            AddHandler btn.MouseClick, AddressOf LaunchButtonMouseClick

            'Set the button tooltip
            Me.ToolTip.SetToolTip(btn, app.Name)
        Next
    End Sub

    'This is a helper function to determine if two application is in the current tab
    Private Function IsApplicationInSelectedCategory(ByVal app As Application) As Boolean
        If app.CategoryName = Me.mSelectedCategory Then
            Return True
        Else
            Return False
        End If
    End Function

    Private Sub LaunchApplication(ByVal app As Application)
        'Check the deployment type to decide how to launch the application

        Select Case app.DeploymentType
            Case DeploymentType.ClickOnce
                'Activate a Click-Once app
                Me.ActivateClickOnceApplication(app.Path)
            Case DeploymentType.WebApplication
                'Start web apps with 'IExplore.exe'
                System.Diagnostics.Process.Start(app.Path)
            Case DeploymentType.LocalInstall
                If Not IO.File.Exists(app.Path) Then
                    MessageBox.Show("The path '" & app.Path & "' is not valid.", "Invalid Application Path", MessageBoxButtons.OK, MessageBoxIcon.Error)
                    Exit Sub
                End If
                'Just ask the OS to run the path
                System.Diagnostics.Process.Start(app.Path)
            Case DeploymentType.NoTouch
                'Just ask the OS to run the path
                System.Diagnostics.Process.Start("iexplore.exe", app.Path)
        End Select

        'If the user wants to minimize the app after every launch...
        If Me.mMinimizeOnLaunch Then
            'Hide in the system tray
            Me.HideToTray()
        End If

    End Sub

    Private Sub ActivateClickOnceApplication(ByVal url As String)
        'Framework does not expose methods to activate a click-once application
        'One can just ask the OS to run the click-once path but this results in 
        'IE being temporarily displayed (just a flash but we are picky)
        'We can cheat however and discover the correct methods with reflection
        'and activate the app

        'Get an instance of the framework's private class 'ApplicationActivator'
        Dim appActivator As Object
        Dim appActivatorType As Type = Type.GetType("System.Deployment.Application.ApplicationActivator, System.Deployment, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a", True, True)
        appActivator = Activator.CreateInstance(appActivatorType)


        'Get the parameters, the URL to the click once app, Flag indicating if the path is to a "offline available local shortcut"
        Dim params As Object() = New Object() {url, False}

        'Get an instance of the method "ActivateDeploymentWorker"
        Dim activateMethod As System.Reflection.MethodInfo = appActivatorType.GetMethod("ActivateDeploymentWorker", Reflection.BindingFlags.NonPublic Or Reflection.BindingFlags.Instance)

        'TP 20080620  Some machines (I believe those with 3.5 framework) are erroring out when 
        'invoking the ActivateDeploymentWorker method.  The System.Deployment.Application namespace has had changes with the new framework.
        'Since we are late binding, the ActivateDeploymentWorker method requirement a new set of parameters and we
        'haven't been able to find what those are.  So, We'll try this methodology, then it there is a target invocation error,
        'we'll run the click once app through IE.
        Try
            'Call the method with the parameters            
            activateMethod.Invoke(appActivator, New Object() {params})
        Catch ex As System.Reflection.TargetInvocationException
            'reflected method wouldn't invoke, so invoke through IE.
            System.Diagnostics.Process.Start("iexplore.exe", url)
        End Try
    End Sub

    ''' <summary>
    ''' Hides the form and puts an icon for it in the system tray
    ''' </summary>
    Private Sub HideToTray()
        'Hide the form
        Me.Hide()

        'Make the tray icon visible
        Me.TrayIcon.Visible = True

        'Remove from taskbar
        Me.ShowInTaskbar = False

        'If this is the first time it has been minimzied then show a balloon so user knows where we went
        If Me.mIsFirstMinimize Then
            Me.TrayIcon.ShowBalloonTip(1000, "Launch Pad Minimized", "Launch Pad is still running in your tray.", ToolTipIcon.Info)
            Me.mIsFirstMinimize = False
        End If
    End Sub

    ''' <summary>
    ''' Unhides the form and takes it out of the system tray
    ''' </summary>
    Private Sub UnhideFromTray()
        'Show the form
        Me.Show()

        'Remove the tray icon
        Me.TrayIcon.Visible = False

        'Put form back in taskbar
        Me.ShowInTaskbar = True
    End Sub

    ''' <summary>
    ''' Returns the url path that is stored in a .url shortcut
    ''' </summary>
    ''' <param name="shortCutPath"></param>
    Private Function ExtractURL(ByVal shortCutPath As String) As String
        Dim content As String

        ' exit if not a .URL file
        If Not shortCutPath.EndsWith(".url") Then Return ""

        Using sr As New StreamReader(shortCutPath)
            ' read the file's content
            content = sr.ReadToEnd()
        End Using

        If content.Length = 0 Then Return ""

        ' extract the URL value
        Dim startIndex As Integer = content.IndexOf("URL=")
        If startIndex = -1 Then Return ""
        startIndex += 4
        Dim endIndex As Integer = content.IndexOf(Environment.NewLine, startIndex + 1)

        'Return the url
        Return content.Substring(startIndex, endIndex - startIndex)
    End Function

    Private Function ApplicationDescriptionDialog(ByVal defaultName As String) As String
        Dim inputDialog As New InputTextDialog

        'inputDialog.Text = "Specify Description"
        inputDialog.Prompt = "Please specify a description for this Application."

        inputDialog.userSpecifiedInput = defaultName
        If inputDialog.ShowDialog(Me) = Windows.Forms.DialogResult.OK Then
            Return inputDialog.userSpecifiedInput
        Else
            Return ""
        End If

    End Function

    Private Sub RefreshApplicationList(ByVal state As Object)
        If Me.InvokeRequired Then
            Me.BeginInvoke(New RefreshApplicationListDelegate(AddressOf RefreshApplicationList), state)
        Else
            'Refresh the providers
            ApplicationProvider.RefreshApplications()

            'In case something changed, reload all the applications
            Me.GetApplicationList()

            'And also reaload the launch buttons for the selected tab
            Me.LoadLaunchButtons()
        End If
    End Sub
#End Region

End Class
