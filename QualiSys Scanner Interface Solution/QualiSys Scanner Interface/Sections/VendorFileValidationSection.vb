Imports Microsoft.Reporting.WinForms
Imports Nrc.Framework.BusinessLogic.Configuration
Imports Nrc.QualiSys.Scanning.Library

Public Class VendorFileValidationSection

#Region " Private Members "

    Private mCurrentFileNode As VendorFileFileNode

    Private WithEvents mNavControl As VendorFileValidationNavigator

#End Region

#Region " Base Class Overrides "

    Public Overrides Sub ActivateSection()

        mNavControl.PopulateTree(True)

    End Sub

    Public Overrides Function AllowInactivate() As Boolean

        Return True

    End Function

    Public Overrides Sub InactivateSection()

    End Sub

    Public Overrides Sub RegisterNavControl(ByVal navCtrl As Navigator)

        mNavControl = DirectCast(navCtrl, VendorFileValidationNavigator)

    End Sub

#End Region

#Region " Constructors "

    Public Sub New()

        ' This call is required by the Windows Form Designer.
        InitializeComponent()

        ' Add any initialization after the InitializeComponent() call.

    End Sub

#End Region

#Region " Navigator Events "

    Private Sub mNavControl_SelectedNodeChanging(ByVal sender As Object, ByVal e As SelectedNodeChangingEventArgs) Handles mNavControl.SelectedNodeChanging

        e.Cancel = Not AllowInactivate()

    End Sub

    Private Sub mNavControl_SelectedNodeChanged(ByVal sender As Object, ByVal e As SelectedNodeChangedEventArgs) Handles mNavControl.SelectedNodeChanged

        'Determine whether or not to show the control
        If TypeOf e.Node Is VendorFileFileNode Then
            System.Windows.Forms.Cursor.Current = Cursors.WaitCursor

            'Get the node
            mCurrentFileNode = DirectCast(e.Node, VendorFileFileNode)

            'Setup the buttons
            SetupButtons()

            'Make the validation panel visible
            VendorFilePanel.Visible = True
            Application.DoEvents()

            'Run the report
            RunReport()

            'Load the file preview
            LoadPreview()

            System.Windows.Forms.Cursor.Current = Cursors.Default

            If Not String.IsNullOrEmpty(mCurrentFileNode.Source.ErrorDesc) Then
                MessageBox.Show(mCurrentFileNode.Source.ErrorDesc, "File Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End If
        Else
            'Hide the report viewer
            VendorFilePanel.Visible = False
            mCurrentFileNode = Nothing
        End If

    End Sub

#End Region

#Region " Section Events "

    Private Sub VendorFileApproveButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles VendorFileApproveButton.Click

        Dim vend As Vendor = Nothing

        'Check for valid vendor before allowing approval.
        If mCurrentFileNode.Source.VendorID.HasValue Then
            vend = Vendor.Get(CInt(mCurrentFileNode.Source.VendorID))
        End If

        If vend Is Nothing Then
            MessageBox.Show("No or invalid vendor set. Please select a valid vendor for the methodology step.", "Invalid vendor", MessageBoxButtons.OK, MessageBoxIcon.Error)
            Exit Sub
        End If

        'Set the status to APPROVED and save it
        mCurrentFileNode.Approve()

        'Reset the buttons
        SetupButtons()

    End Sub

    Private Sub VendorFileRemakeButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles VendorFileRemakeButton.Click

        'Let's make sure this is what the user wants to do
        Dim msg As String = String.Format("You are about to Reject and Remake {0}!{1}{1}This will mark the file as Pending and repopulate the file{1}with current information from QualiSys.{1}{1}Do you wish to continue?", mCurrentFileNode.DisplayName, vbCrLf)
        If MessageBox.Show(msg, "Vendor File Reject and Remake", MessageBoxButtons.OKCancel, MessageBoxIcon.Exclamation, MessageBoxDefaultButton.Button2) = DialogResult.OK Then
            'The user has chosen to perform the remake
            mCurrentFileNode.Remake()

            'Repopulate the tree
            mNavControl.PopulateTree(True)
        End If

    End Sub

    Private Sub VendorFileRollbackButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles VendorFileRollbackButton.Click

        'Let's make sure this is what the user wants to do
        Dim msg As String = String.Format("You are about to Rollback {0}!{1}{1}This will mark the file as Pending.  Please contact the appropriate{1}vendor to roll this file back in their system.{1}{1}Do you wish to continue?", mCurrentFileNode.DisplayName, vbCrLf)
        If MessageBox.Show(msg, "Vendor File Rollback", MessageBoxButtons.OKCancel, MessageBoxIcon.Exclamation, MessageBoxDefaultButton.Button2) = DialogResult.OK Then
            'The user has chosen to perform the rollback
            mCurrentFileNode.Rollback()

            'Reset the buttons
            SetupButtons()
        End If

    End Sub

    Private Sub ResendToTelematchButton_Click(sender As Object, e As EventArgs) Handles ResendToTelematchButton.Click

        'Let's make sure this is what the user wants to do
        Dim msg As String = String.Format("You are about to Resend to Telematch {0}!{1}{1}This will mark the file as Approved.{1}{1}Do you wish to continue?", mCurrentFileNode.DisplayName, vbCrLf)
        If MessageBox.Show(msg, "Vendor File Resend to Telematch", MessageBoxButtons.OKCancel, MessageBoxIcon.Exclamation, MessageBoxDefaultButton.Button2) = DialogResult.OK Then
            'The user has chosen to perform the rollback
            mCurrentFileNode.ResendToTelematch()

            'Reset the buttons
            SetupButtons()
        End If

    End Sub


#End Region

#Region " Private Methods "

    Private Sub RunReport()

        'Build the parameter list
        Dim params As New Generic.List(Of ReportParameter)
        params.Add(New ReportParameter("VendorFile_ID", mCurrentFileNode.Source.VendorFileID.ToString, False))

        'Run the report
        With VendorFileValidationReportViewer
            With .ServerReport
                .ReportServerUrl = New System.Uri(AppConfig.Params("QSIReportServerURL").StringValue)
                .ReportPath = AppConfig.Params("QSIVendorFileValidationReportPath").StringValue
                .SetParameters(params)
            End With

            .RefreshReport()
        End With

    End Sub

    Private Sub LoadPreview()

        'Populate the datagrid
        With VendorFileDataGridControl
            .DataSource = Nothing
            .DataSource = VendorFileCreationQueue.GetVendorFileData(mCurrentFileNode.Source.VendorFileID)
            .DefaultView.PopulateColumns()
            .DefaultView.RefreshData()
        End With

    End Sub

    Private Sub SetupButtons()

        ResendToTelematchButton.Enabled = False

        'Setup the buttons
        Select Case mCurrentFileNode.Source.VendorFileStatusID
            Case VendorFileStatusCodes.Processing
                VendorFileApproveButton.Enabled = False
                VendorFileRemakeButton.Enabled = False
                VendorFileRollbackButton.Enabled = False

            Case VendorFileStatusCodes.ProcessingFailed
                VendorFileApproveButton.Enabled = False
                VendorFileRemakeButton.Enabled = True
                VendorFileRollbackButton.Enabled = False

            Case VendorFileStatusCodes.Pending
                VendorFileApproveButton.Enabled = True
                VendorFileRemakeButton.Enabled = True
                VendorFileRollbackButton.Enabled = False

            Case VendorFileStatusCodes.Approved
                VendorFileApproveButton.Enabled = False
                VendorFileRemakeButton.Enabled = True
                VendorFileRollbackButton.Enabled = False

            Case VendorFileStatusCodes.Telematching
                VendorFileApproveButton.Enabled = False
                VendorFileRemakeButton.Enabled = False
                VendorFileRollbackButton.Enabled = False
                ResendToTelematchButton.Enabled = mCurrentFileNode.IsStuckInTelematch

            Case VendorFileStatusCodes.Sent
                VendorFileApproveButton.Enabled = False
                VendorFileRemakeButton.Enabled = False
                VendorFileRollbackButton.Enabled = True

        End Select

        If mCurrentFileNode.DateFileCreated.HasValue Then
            DateFileCreatedDateTimePicker.Value = mCurrentFileNode.DateFileCreated.Value
        Else
            DateFileCreatedDateTimePicker.Value = Today
        End If

    End Sub

#End Region

    Private Sub DateFileCreatedDateTimePicker_ValueChanged(sender As System.Object, e As System.EventArgs) Handles DateFileCreatedDateTimePicker.ValueChanged

        mCurrentFileNode.SetDateFileCreated(DateFileCreatedDateTimePicker.Value)

        mCurrentFileNode.DateFileCreated = DateFileCreatedDateTimePicker.Value

    End Sub
End Class
