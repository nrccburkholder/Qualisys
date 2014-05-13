Imports Nrc.Framework.WinForms
Imports Nrc.Framework.BusinessLogic.Configuration

Public Class MainForm

#Region " Private Members "

    Private mUIRelations As New Dictionary(Of MultiPaneTab, UIRelation)
    Private mActiveTab As MultiPaneTab

    Private mImportNavigator As ImportNavigator
    Private mImportSection As ImportSection

    Private mBarcodeSearchNavigator As BarcodeSearchNavigator
    Private WithEvents mBarcodeSearchSection As BarcodeSearchSection

    Private mTransferResultsNavigator As TransferResultsNavigator
    Private mTransferResultsSection As TransferResultsSection

    Private mVendorMaintenanceNavigator As VendorMaintenanceNavigator
    Private mVendorMaintenanceSection As VendorMaintenanceSection

    Private mSurveyVendorNavigator As SurveyVendorNavigator
    Private mSurveyVendorSection As SurveyVendorSection

    Private mVendorFileNavigator As VendorFileValidationNavigator
    Private mVendorFileSection As VendorFileValidationSection

    Private mDataEntryNavigator As DataEntryVerifyNavigator
    Private mDataEntrySection As DataEntryVerifySection

    Private mDataVerifyNavigator As DataEntryVerifyNavigator
    Private mDataVerifySection As DataEntryVerifySection

#End Region

#Region " Constructors "

    Sub New()

        ' This call is required by the Windows Form Designer.
        InitializeComponent()

        ' Add any initialization after the InitializeComponent() call.
        InitializeUI()

        ' Locate and size the form
        Location = My.Settings.MainFormLocation
        Size = My.Settings.MainFormSize
        WindowState = My.Settings.MainFormWindowState
        MainPanel.SplitterDistance = My.Settings.MainFormSplitterLocation

    End Sub

#End Region

#Region " Events "

#Region " Events - Form "

    Private Sub MainForm_FormClosing(ByVal sender As Object, ByVal e As System.Windows.Forms.FormClosingEventArgs) Handles Me.FormClosing

        'Save the window state and then set it to normal so we can get the size and location
        My.Settings.MainFormWindowState = WindowState
        WindowState = FormWindowState.Normal

        'Save the form size and location
        My.Settings.MainFormLocation = Location
        My.Settings.MainFormSize = Size

        'Save teh location of the splitter
        My.Settings.MainFormSplitterLocation = MainPanel.SplitterDistance

    End Sub

#End Region

#Region " Events - Control "

    Private Sub MultiPane_SelectedTabChanged(ByVal sender As Object, ByVal e As Framework.WinForms.SelectedTabChangedEventArgs) Handles MultiPane.SelectedTabChanged

        If mUIRelations.ContainsKey(e.NewTab) Then
            ActivateTab(e.OldTab, e.NewTab)
        Else
            MultiPane.LoadNavigationControl(Nothing)
            MainPanel.Panel2.Controls.Clear()
        End If

    End Sub

    Private Sub MultiPane_SelectedTabChanging(ByVal sender As Object, ByVal e As Framework.WinForms.SelectedTabChangingEventArgs) Handles MultiPane.SelectedTabChanging

        If e.OldTab IsNot Nothing AndAlso mUIRelations.ContainsKey(e.OldTab) Then
            Dim sectionCtrl As Section = mUIRelations(e.OldTab).SectionControl
            e.Cancel = Not sectionCtrl.AllowInactivate
        End If

    End Sub

    Private Sub OptionsToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles OptionsToolStripMenuItem.Click

        Dim settingsDialog As New UserSettingsDialog
        settingsDialog.ShowDialog(Me)

    End Sub

    Private Sub ExitToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ExitToolStripMenuItem.Click

        Close()

    End Sub

#End Region

#Region " Events - Object "

    Private Sub mBarcodeSearchSection_BarcodeFileSearchBegin(ByVal sender As Object, ByVal e As QualiSys.Scanning.Library.BarcodeFileSearchBeginEventArgs) Handles mBarcodeSearchSection.BarcodeFileSearchBegin

        StatusLabel.Text = String.Format("Searching {0}...", e.CurrentBarcodeFile)

    End Sub

    Private Sub mBarcodeSearchSection_BarcodeFileSearchComplete(ByVal sender As Object, ByVal e As QualiSys.Scanning.Library.BarcodeFileSearchCompleteEventArgs) Handles mBarcodeSearchSection.BarcodeFileSearchComplete

        StatusLabel.Text = "Ready."

    End Sub

#End Region

#End Region

#Region " Private Methods "

    Private Sub InitializeUI()

        Text = My.Application.Info.Title
        EnvironmentLabel.Text = AppConfig.EnvironmentName
        VersionLabel.Text = "v" & My.Application.Info.Version.ToString
        UserNameLabel.Text = String.Format("{0} ({1})", CurrentUser.DisplayName, My.User.Name)

        If CurrentUser.IsAccessImport Then
            mImportNavigator = New ImportNavigator
            mImportSection = New ImportSection
            mUIRelations.Add(ImportTab, New UIRelation(mImportNavigator, mImportSection))
        Else
            MultiPane.Tabs.Remove(ImportTab)
        End If

        If CurrentUser.IsAccessBarcodeSearch Then
            mBarcodeSearchNavigator = New BarcodeSearchNavigator
            mBarcodeSearchSection = New BarcodeSearchSection
            mUIRelations.Add(BarcodeTab, New UIRelation(mBarcodeSearchNavigator, mBarcodeSearchSection))
        Else
            MultiPane.Tabs.Remove(BarcodeTab)
        End If

        If CurrentUser.IsAccessTransferResults Then
            mTransferResultsNavigator = New TransferResultsNavigator
            mTransferResultsSection = New TransferResultsSection
            mUIRelations.Add(TransferResultsTab, New UIRelation(mTransferResultsNavigator, mTransferResultsSection))
        Else
            MultiPane.Tabs.Remove(TransferResultsTab)
        End If

        If CurrentUser.IsAccessVendorMaintenance Then
            mVendorMaintenanceNavigator = New VendorMaintenanceNavigator
            mVendorMaintenanceSection = New VendorMaintenanceSection
            mUIRelations.Add(VendorMaintenanceTab, New UIRelation(mVendorMaintenanceNavigator, mVendorMaintenanceSection))
        Else
            MultiPane.Tabs.Remove(VendorMaintenanceTab)
        End If

        If CurrentUser.IsAccessSurveyVendor Then
            mSurveyVendorNavigator = New SurveyVendorNavigator
            mSurveyVendorSection = New SurveyVendorSection
            mUIRelations.Add(SurveyVendorTab, New UIRelation(mSurveyVendorNavigator, mSurveyVendorSection))
        Else
            MultiPane.Tabs.Remove(SurveyVendorTab)
        End If

        If CurrentUser.IsAccessVendorFileValidation Then
            mVendorFileNavigator = New VendorFileValidationNavigator
            mVendorFileSection = New VendorFileValidationSection
            mUIRelations.Add(VendorFileTab, New UIRelation(mVendorFileNavigator, mVendorFileSection))
        Else
            MultiPane.Tabs.Remove(VendorFileTab)
        End If

        If CurrentUser.IsAccessDataEntry Then
            mDataEntryNavigator = New DataEntryVerifyNavigator(QualiSys.Scanning.Library.DataEntryModes.Entry)
            mDataEntrySection = New DataEntryVerifySection(QualiSys.Scanning.Library.DataEntryModes.Entry)
            mUIRelations.Add(DataEntryTab, New UIRelation(mDataEntryNavigator, mDataEntrySection))
        Else
            MultiPane.Tabs.Remove(DataEntryTab)
        End If

        If CurrentUser.IsAccessDataVerify Then
            mDataVerifyNavigator = New DataEntryVerifyNavigator(QualiSys.Scanning.Library.DataEntryModes.Verify)
            mDataVerifySection = New DataEntryVerifySection(QualiSys.Scanning.Library.DataEntryModes.Verify)
            mUIRelations.Add(DataVerificationTab, New UIRelation(mDataVerifyNavigator, mDataVerifySection))
        Else
            MultiPane.Tabs.Remove(DataVerificationTab)
        End If

        ActivateTab(Nothing, MultiPane.Tabs(0))

    End Sub

    Private Sub ActivateTab(ByVal oldTab As MultiPaneTab, ByVal newTab As MultiPaneTab)

        Try
            Cursor = Cursors.WaitCursor

            MainPanel.Panel2.Controls.Clear()
            Dim navCtrl As Navigator = mUIRelations(newTab).NavigationControl
            Dim sectionCtrl As Section = mUIRelations(newTab).SectionControl

            MultiPane.LoadNavigationControl(navCtrl)
            sectionCtrl.Dock = DockStyle.Fill
            MainPanel.Panel2.Controls.Add(sectionCtrl)
            mActiveTab = newTab

            If oldTab IsNot Nothing AndAlso mUIRelations(oldTab).SectionControl IsNot Nothing Then
                mUIRelations(oldTab).SectionControl.InactivateSection()
            End If
            sectionCtrl.ActivateSection()

        Finally
            Cursor = DefaultCursor

        End Try

    End Sub

#End Region

End Class

