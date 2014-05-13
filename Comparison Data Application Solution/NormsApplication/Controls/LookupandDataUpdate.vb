Imports NormsApplicationBusinessObjectsLibrary
Public Class LookupandDataUpdate
    Inherits System.Windows.Forms.UserControl

#Region " Windows Form Designer generated code "

    Public Sub New()
        MyBase.New()

        'This call is required by the Windows Form Designer.
        InitializeComponent()

        'Add any initialization after the InitializeComponent() call

    End Sub

    'UserControl overrides dispose to clean up the component list.
    Protected Overloads Overrides Sub Dispose(ByVal disposing As Boolean)
        If disposing Then
            If Not (components Is Nothing) Then
                components.Dispose()
            End If
        End If
        MyBase.Dispose(disposing)
    End Sub

    'Required by the Windows Form Designer
    Private components As System.ComponentModel.IContainer

    'NOTE: The following procedure is required by the Windows Form Designer
    'It can be modified using the Windows Form Designer.  
    'Do not modify it using the code editor.
    Friend WithEvents SectionPanel1 As NRC.WinForms.SectionPanel
    Friend WithEvents Date_Chooser1 As NormsApplication.Date_Chooser
    Friend WithEvents btnLookups As System.Windows.Forms.Button
    Friend WithEvents btnUpdateAll As System.Windows.Forms.Button
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.SectionPanel1 = New NRC.WinForms.SectionPanel
        Me.btnUpdateAll = New System.Windows.Forms.Button
        Me.btnLookups = New System.Windows.Forms.Button
        Me.Date_Chooser1 = New NormsApplication.Date_Chooser
        Me.SectionPanel1.SuspendLayout()
        Me.SuspendLayout()
        '
        'SectionPanel1
        '
        Me.SectionPanel1.BorderColor = System.Drawing.Color.FromArgb(CType(0, Byte), CType(45, Byte), CType(150, Byte))
        Me.SectionPanel1.Caption = "Update Lookup Tables and And Data"
        Me.SectionPanel1.Controls.Add(Me.btnUpdateAll)
        Me.SectionPanel1.Controls.Add(Me.btnLookups)
        Me.SectionPanel1.Controls.Add(Me.Date_Chooser1)
        Me.SectionPanel1.Dock = System.Windows.Forms.DockStyle.Fill
        Me.SectionPanel1.DockPadding.All = 1
        Me.SectionPanel1.Location = New System.Drawing.Point(0, 0)
        Me.SectionPanel1.Name = "SectionPanel1"
        Me.SectionPanel1.ShowCaption = True
        Me.SectionPanel1.Size = New System.Drawing.Size(608, 232)
        Me.SectionPanel1.TabIndex = 0
        '
        'btnUpdateAll
        '
        Me.btnUpdateAll.Location = New System.Drawing.Point(328, 184)
        Me.btnUpdateAll.Name = "btnUpdateAll"
        Me.btnUpdateAll.Size = New System.Drawing.Size(168, 23)
        Me.btnUpdateAll.TabIndex = 4
        Me.btnUpdateAll.Text = "Update Lookups and Data"
        '
        'btnLookups
        '
        Me.btnLookups.Location = New System.Drawing.Point(112, 184)
        Me.btnLookups.Name = "btnLookups"
        Me.btnLookups.Size = New System.Drawing.Size(168, 23)
        Me.btnLookups.TabIndex = 3
        Me.btnLookups.Text = "Update Lookups Only"
        '
        'Date_Chooser1
        '
        Me.Date_Chooser1.Location = New System.Drawing.Point(68, 48)
        Me.Date_Chooser1.Maxdate = New Date(2005, 5, 20, 11, 43, 52, 6)
        Me.Date_Chooser1.Mindate = New Date(2005, 5, 20, 11, 43, 52, 6)
        Me.Date_Chooser1.Name = "Date_Chooser1"
        Me.Date_Chooser1.Size = New System.Drawing.Size(472, 104)
        Me.Date_Chooser1.TabIndex = 1
        '
        'LookupandDataUpdate
        '
        Me.AutoScroll = True
        Me.Controls.Add(Me.SectionPanel1)
        Me.Name = "LookupandDataUpdate"
        Me.Size = New System.Drawing.Size(608, 232)
        Me.SectionPanel1.ResumeLayout(False)
        Me.ResumeLayout(False)

    End Sub

#End Region

    Private Sub btnLookups_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnLookups.Click
        Cursor = Cursors.WaitCursor
        Try
            DataAccess.UpdateAllLookupTables()
            MessageBox.Show("Update of lookup tables is complete.", "Update Lookup Tables", MessageBoxButtons.OK, MessageBoxIcon.Information)
        Catch ex As Exception
            MessageBox.Show(ex.Message, "Error Updating Lookups", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
        Cursor = Cursors.Default
    End Sub

    Private Sub btnUpdateAll_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnUpdateAll.Click
        Cursor = Cursors.WaitCursor
        Dim minQuarter As Integer
        Dim maxQuarter As Integer
        Dim minMonth As Integer = Date_Chooser1.dtpMindate.Value.Month
        Dim minDay As Integer = Date_Chooser1.dtpMindate.Value.Day
        Dim maxMonth As Integer = Date_Chooser1.dtpMaxdate.Value.Month
        Dim maxDay As Integer = Date_Chooser1.dtpMaxdate.Value.Day
        Dim yearQuarter As String

        If minDay <> 1 Then
            MessageBox.Show("You must pick a date that is the first day of a quarter for the Minimum Date", "Bad Date", MessageBoxButtons.OK, MessageBoxIcon.Error)
            Cursor = Cursors.Default
            Return
        End If

        If Date_Chooser1.dtpMaxdate.Value.AddDays(1).Day <> 1 Then
            MessageBox.Show("You must pick a date that is the last day of a quarter for the Maximum Date", "Bad Date", MessageBoxButtons.OK, MessageBoxIcon.Error)
            Cursor = Cursors.Default
            Return
        End If

        Select Case minMonth
            Case 1
                minQuarter = 1
            Case 4
                minQuarter = 2
            Case 7
                minQuarter = 3
            Case 10
                minQuarter = 4
            Case Else
                MessageBox.Show("You must pick a date that is the first day of a quarter for the Minimum Date", "Bad Date", MessageBoxButtons.OK, MessageBoxIcon.Error)
                Cursor = Cursors.Default
                Return
        End Select

        Select Case maxMonth
            Case 3
                maxQuarter = 1
            Case 6
                maxQuarter = 2
            Case 9
                maxQuarter = 3
            Case 12
                maxQuarter = 4
            Case Else
                MessageBox.Show("You must pick a date that is the last day of a quarter for the Maximum Date", "Bad Date", MessageBoxButtons.OK, MessageBoxIcon.Error)
                Cursor = Cursors.Default
                Return
        End Select

        If Date_Chooser1.dtpMindate.Value.Year <> Date_Chooser1.dtpMaxdate.Value.Year Then
            MessageBox.Show("You must pick dates that are from the same year", "Bad Date", MessageBoxButtons.OK, MessageBoxIcon.Error)
            Cursor = Cursors.Default
            Return
        ElseIf minQuarter <> maxQuarter Then
            MessageBox.Show("You must pick dates that are from the same quarter", "Bad Date", MessageBoxButtons.OK, MessageBoxIcon.Error)
            Cursor = Cursors.Default
            Return
        End If

        yearQuarter = "Q" & minQuarter & Date_Chooser1.dtpMindate.Value.Year.ToString.Substring(2)
        Try
            DataAccess.AddNewQuarterofData(yearQuarter, Date_Chooser1.dtpMindate.Value, Date_Chooser1.dtpMaxdate.Value)

            DataAccess.UpdateAllLookupTables()
            MessageBox.Show("Update of lookup tables and Data is complete.", "Update Lookup Tables", MessageBoxButtons.OK, MessageBoxIcon.Information)
        Catch ex As Exception
            MessageBox.Show(ex.Message, "Error Updating Lookups and Data", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
        Cursor = Cursors.Default
    End Sub
End Class
