Imports System.Data
Imports System.Data.SqlClient
Imports System.Data.Odbc
Imports System.IO

Public Class frmMain
    Inherits System.Windows.Forms.Form

#Region " Windows Form Designer generated code "

    Public Sub New()
        MyBase.New()

        'This call is required by the Windows Form Designer.
        InitializeComponent()

        'Add any initialization after the InitializeComponent() call

    End Sub

    'Form overrides dispose to clean up the component list.
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
    Friend WithEvents GroupBox1 As System.Windows.Forms.GroupBox
    Friend WithEvents btnAbout As System.Windows.Forms.Button
    Friend WithEvents btnFinish As System.Windows.Forms.Button
    Friend WithEvents btnNext As System.Windows.Forms.Button
    Friend WithEvents btnBack As System.Windows.Forms.Button
    Friend WithEvents btnCancel As System.Windows.Forms.Button
    Friend WithEvents picMain As System.Windows.Forms.PictureBox
    Friend WithEvents lblVersion As System.Windows.Forms.Label
    Friend WithEvents Label1 As System.Windows.Forms.Label
    Friend WithEvents Label2 As System.Windows.Forms.Label
    Friend WithEvents Label3 As System.Windows.Forms.Label
    Friend WithEvents Label4 As System.Windows.Forms.Label
    Friend WithEvents Label5 As System.Windows.Forms.Label
    Friend WithEvents Label6 As System.Windows.Forms.Label
    Friend WithEvents ofdMain As System.Windows.Forms.OpenFileDialog
    Friend WithEvents pnlFinish As System.Windows.Forms.Panel
    Friend WithEvents Label7 As System.Windows.Forms.Label
    Friend WithEvents Label8 As System.Windows.Forms.Label
    Friend WithEvents btnGetDataFileName As System.Windows.Forms.Button
    Friend WithEvents cboDataFileFormat As System.Windows.Forms.ComboBox
    Friend WithEvents txtDataFileName As System.Windows.Forms.TextBox
    Friend WithEvents pnlIntro As System.Windows.Forms.Panel
    Friend WithEvents Label9 As System.Windows.Forms.Label
    Friend WithEvents Label10 As System.Windows.Forms.Label
    Friend WithEvents pnlStep1 As System.Windows.Forms.Panel
    Friend WithEvents pnlStep2 As System.Windows.Forms.Panel
    Friend WithEvents Label11 As System.Windows.Forms.Label
    Friend WithEvents cboLithoCodeField As System.Windows.Forms.ComboBox
    Friend WithEvents Label12 As System.Windows.Forms.Label
    Friend WithEvents cboReturnDateField As System.Windows.Forms.ComboBox
    Friend WithEvents Label13 As System.Windows.Forms.Label
    Friend WithEvents chkOverwrite As System.Windows.Forms.CheckBox
    Friend WithEvents Label14 As System.Windows.Forms.Label
    Friend WithEvents fraProgress As System.Windows.Forms.GroupBox
    Friend WithEvents pbrMain As System.Windows.Forms.ProgressBar
    Friend WithEvents Label15 As System.Windows.Forms.Label
    Friend WithEvents lblCurRec As System.Windows.Forms.Label
    Friend WithEvents Label17 As System.Windows.Forms.Label
    Friend WithEvents lblTotRec As System.Windows.Forms.Label
    Friend WithEvents pnlStep3 As System.Windows.Forms.Panel
    Friend WithEvents Label18 As System.Windows.Forms.Label
    Friend WithEvents cboTOCLField As System.Windows.Forms.ComboBox
    Friend WithEvents Label19 As System.Windows.Forms.Label
    Friend WithEvents Label20 As System.Windows.Forms.Label
    Friend WithEvents Label21 As System.Windows.Forms.Label
    Friend WithEvents txtTOCLValues As System.Windows.Forms.TextBox
    Friend WithEvents Label16 As System.Windows.Forms.Label
    Friend WithEvents pnlStep4 As System.Windows.Forms.Panel
    Friend WithEvents Label25 As System.Windows.Forms.Label
    Friend WithEvents Label26 As System.Windows.Forms.Label
    Friend WithEvents cboBackgroundPop As System.Windows.Forms.ComboBox
    Friend WithEvents cboBackgroundSource As System.Windows.Forms.ComboBox
    Friend WithEvents btnBackgroundAdd As System.Windows.Forms.Button
    Friend WithEvents btnBackgroundRemove As System.Windows.Forms.Button
    Friend WithEvents chdSource As System.Windows.Forms.ColumnHeader
    Friend WithEvents chdPopulation As System.Windows.Forms.ColumnHeader
    Friend WithEvents lvwBackgroundMappings As System.Windows.Forms.ListView
    Friend WithEvents Label24 As System.Windows.Forms.Label
    Friend WithEvents lblUserName As System.Windows.Forms.Label
    Friend WithEvents Label28 As System.Windows.Forms.Label
    Friend WithEvents lblEnvironment As System.Windows.Forms.Label
    Friend WithEvents lblBackgroundMapNA As System.Windows.Forms.Label
    Friend WithEvents lblBackgroundPop As System.Windows.Forms.Label
    Friend WithEvents lblBackgroundSource As System.Windows.Forms.Label
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Dim resources As System.Resources.ResourceManager = New System.Resources.ResourceManager(GetType(frmMain))
        Me.picMain = New System.Windows.Forms.PictureBox
        Me.pnlIntro = New System.Windows.Forms.Panel
        Me.Label28 = New System.Windows.Forms.Label
        Me.lblEnvironment = New System.Windows.Forms.Label
        Me.Label24 = New System.Windows.Forms.Label
        Me.lblUserName = New System.Windows.Forms.Label
        Me.Label2 = New System.Windows.Forms.Label
        Me.Label1 = New System.Windows.Forms.Label
        Me.GroupBox1 = New System.Windows.Forms.GroupBox
        Me.btnAbout = New System.Windows.Forms.Button
        Me.btnFinish = New System.Windows.Forms.Button
        Me.btnNext = New System.Windows.Forms.Button
        Me.btnBack = New System.Windows.Forms.Button
        Me.btnCancel = New System.Windows.Forms.Button
        Me.lblVersion = New System.Windows.Forms.Label
        Me.Label3 = New System.Windows.Forms.Label
        Me.pnlStep1 = New System.Windows.Forms.Panel
        Me.Label12 = New System.Windows.Forms.Label
        Me.btnGetDataFileName = New System.Windows.Forms.Button
        Me.cboDataFileFormat = New System.Windows.Forms.ComboBox
        Me.txtDataFileName = New System.Windows.Forms.TextBox
        Me.Label6 = New System.Windows.Forms.Label
        Me.Label4 = New System.Windows.Forms.Label
        Me.Label5 = New System.Windows.Forms.Label
        Me.ofdMain = New System.Windows.Forms.OpenFileDialog
        Me.pnlFinish = New System.Windows.Forms.Panel
        Me.fraProgress = New System.Windows.Forms.GroupBox
        Me.lblTotRec = New System.Windows.Forms.Label
        Me.Label17 = New System.Windows.Forms.Label
        Me.lblCurRec = New System.Windows.Forms.Label
        Me.Label15 = New System.Windows.Forms.Label
        Me.pbrMain = New System.Windows.Forms.ProgressBar
        Me.Label7 = New System.Windows.Forms.Label
        Me.Label8 = New System.Windows.Forms.Label
        Me.pnlStep2 = New System.Windows.Forms.Panel
        Me.Label14 = New System.Windows.Forms.Label
        Me.chkOverwrite = New System.Windows.Forms.CheckBox
        Me.cboReturnDateField = New System.Windows.Forms.ComboBox
        Me.Label13 = New System.Windows.Forms.Label
        Me.cboLithoCodeField = New System.Windows.Forms.ComboBox
        Me.Label11 = New System.Windows.Forms.Label
        Me.Label9 = New System.Windows.Forms.Label
        Me.Label10 = New System.Windows.Forms.Label
        Me.pnlStep3 = New System.Windows.Forms.Panel
        Me.Label16 = New System.Windows.Forms.Label
        Me.txtTOCLValues = New System.Windows.Forms.TextBox
        Me.Label18 = New System.Windows.Forms.Label
        Me.cboTOCLField = New System.Windows.Forms.ComboBox
        Me.Label19 = New System.Windows.Forms.Label
        Me.Label20 = New System.Windows.Forms.Label
        Me.Label21 = New System.Windows.Forms.Label
        Me.pnlStep4 = New System.Windows.Forms.Panel
        Me.lblBackgroundMapNA = New System.Windows.Forms.Label
        Me.btnBackgroundRemove = New System.Windows.Forms.Button
        Me.btnBackgroundAdd = New System.Windows.Forms.Button
        Me.lvwBackgroundMappings = New System.Windows.Forms.ListView
        Me.chdSource = New System.Windows.Forms.ColumnHeader
        Me.chdPopulation = New System.Windows.Forms.ColumnHeader
        Me.cboBackgroundPop = New System.Windows.Forms.ComboBox
        Me.lblBackgroundPop = New System.Windows.Forms.Label
        Me.cboBackgroundSource = New System.Windows.Forms.ComboBox
        Me.lblBackgroundSource = New System.Windows.Forms.Label
        Me.Label25 = New System.Windows.Forms.Label
        Me.Label26 = New System.Windows.Forms.Label
        Me.pnlIntro.SuspendLayout()
        Me.pnlStep1.SuspendLayout()
        Me.pnlFinish.SuspendLayout()
        Me.fraProgress.SuspendLayout()
        Me.pnlStep2.SuspendLayout()
        Me.pnlStep3.SuspendLayout()
        Me.pnlStep4.SuspendLayout()
        Me.SuspendLayout()
        '
        'picMain
        '
        Me.picMain.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D
        Me.picMain.Image = CType(resources.GetObject("picMain.Image"), System.Drawing.Image)
        Me.picMain.Location = New System.Drawing.Point(12, 12)
        Me.picMain.Name = "picMain"
        Me.picMain.Size = New System.Drawing.Size(140, 260)
        Me.picMain.TabIndex = 0
        Me.picMain.TabStop = False
        '
        'pnlIntro
        '
        Me.pnlIntro.Controls.Add(Me.Label28)
        Me.pnlIntro.Controls.Add(Me.lblEnvironment)
        Me.pnlIntro.Controls.Add(Me.Label24)
        Me.pnlIntro.Controls.Add(Me.lblUserName)
        Me.pnlIntro.Controls.Add(Me.Label2)
        Me.pnlIntro.Controls.Add(Me.Label1)
        Me.pnlIntro.Location = New System.Drawing.Point(160, 8)
        Me.pnlIntro.Name = "pnlIntro"
        Me.pnlIntro.Size = New System.Drawing.Size(388, 272)
        Me.pnlIntro.TabIndex = 0
        Me.pnlIntro.Tag = "Introduction"
        '
        'Label28
        '
        Me.Label28.Location = New System.Drawing.Point(8, 172)
        Me.Label28.Name = "Label28"
        Me.Label28.Size = New System.Drawing.Size(108, 16)
        Me.Label28.TabIndex = 15
        Me.Label28.Text = "Environment:"
        Me.Label28.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'lblEnvironment
        '
        Me.lblEnvironment.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lblEnvironment.Location = New System.Drawing.Point(24, 188)
        Me.lblEnvironment.Name = "lblEnvironment"
        Me.lblEnvironment.Size = New System.Drawing.Size(108, 16)
        Me.lblEnvironment.TabIndex = 16
        Me.lblEnvironment.Text = "Environment"
        Me.lblEnvironment.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'Label24
        '
        Me.Label24.Location = New System.Drawing.Point(8, 124)
        Me.Label24.Name = "Label24"
        Me.Label24.Size = New System.Drawing.Size(108, 16)
        Me.Label24.TabIndex = 13
        Me.Label24.Text = "User Name:"
        Me.Label24.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'lblUserName
        '
        Me.lblUserName.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lblUserName.Location = New System.Drawing.Point(24, 140)
        Me.lblUserName.Name = "lblUserName"
        Me.lblUserName.Size = New System.Drawing.Size(108, 16)
        Me.lblUserName.TabIndex = 14
        Me.lblUserName.Text = "UserName"
        Me.lblUserName.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'Label2
        '
        Me.Label2.Location = New System.Drawing.Point(8, 72)
        Me.Label2.Name = "Label2"
        Me.Label2.Size = New System.Drawing.Size(376, 23)
        Me.Label2.TabIndex = 1
        Me.Label2.Text = "To begin press Next."
        '
        'Label1
        '
        Me.Label1.Location = New System.Drawing.Point(8, 8)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(376, 36)
        Me.Label1.TabIndex = 0
        Me.Label1.Text = "The Offline Transfer Results Wizard will help you import data of various data for" & _
        "mats into the QualiSys system."
        '
        'GroupBox1
        '
        Me.GroupBox1.Location = New System.Drawing.Point(12, 280)
        Me.GroupBox1.Name = "GroupBox1"
        Me.GroupBox1.Size = New System.Drawing.Size(532, 8)
        Me.GroupBox1.TabIndex = 2
        Me.GroupBox1.TabStop = False
        '
        'btnAbout
        '
        Me.btnAbout.Location = New System.Drawing.Point(12, 296)
        Me.btnAbout.Name = "btnAbout"
        Me.btnAbout.Size = New System.Drawing.Size(76, 24)
        Me.btnAbout.TabIndex = 6
        Me.btnAbout.Text = "About"
        '
        'btnFinish
        '
        Me.btnFinish.Location = New System.Drawing.Point(468, 296)
        Me.btnFinish.Name = "btnFinish"
        Me.btnFinish.Size = New System.Drawing.Size(76, 24)
        Me.btnFinish.TabIndex = 10
        Me.btnFinish.Text = "Finish"
        '
        'btnNext
        '
        Me.btnNext.Location = New System.Drawing.Point(376, 296)
        Me.btnNext.Name = "btnNext"
        Me.btnNext.Size = New System.Drawing.Size(76, 24)
        Me.btnNext.TabIndex = 9
        Me.btnNext.Text = "Next >"
        '
        'btnBack
        '
        Me.btnBack.Location = New System.Drawing.Point(296, 296)
        Me.btnBack.Name = "btnBack"
        Me.btnBack.Size = New System.Drawing.Size(76, 24)
        Me.btnBack.TabIndex = 8
        Me.btnBack.Text = "< Back"
        '
        'btnCancel
        '
        Me.btnCancel.Location = New System.Drawing.Point(204, 296)
        Me.btnCancel.Name = "btnCancel"
        Me.btnCancel.Size = New System.Drawing.Size(76, 24)
        Me.btnCancel.TabIndex = 7
        Me.btnCancel.Text = "Cancel"
        '
        'lblVersion
        '
        Me.lblVersion.Location = New System.Drawing.Point(92, 308)
        Me.lblVersion.Name = "lblVersion"
        Me.lblVersion.Size = New System.Drawing.Size(108, 16)
        Me.lblVersion.TabIndex = 12
        Me.lblVersion.Text = "Version Number"
        Me.lblVersion.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
        '
        'Label3
        '
        Me.Label3.Location = New System.Drawing.Point(92, 292)
        Me.Label3.Name = "Label3"
        Me.Label3.Size = New System.Drawing.Size(108, 16)
        Me.Label3.TabIndex = 11
        Me.Label3.Text = "Version:"
        Me.Label3.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
        '
        'pnlStep1
        '
        Me.pnlStep1.Controls.Add(Me.Label12)
        Me.pnlStep1.Controls.Add(Me.btnGetDataFileName)
        Me.pnlStep1.Controls.Add(Me.cboDataFileFormat)
        Me.pnlStep1.Controls.Add(Me.txtDataFileName)
        Me.pnlStep1.Controls.Add(Me.Label6)
        Me.pnlStep1.Controls.Add(Me.Label4)
        Me.pnlStep1.Controls.Add(Me.Label5)
        Me.pnlStep1.Location = New System.Drawing.Point(160, 8)
        Me.pnlStep1.Name = "pnlStep1"
        Me.pnlStep1.Size = New System.Drawing.Size(388, 272)
        Me.pnlStep1.TabIndex = 1
        Me.pnlStep1.Tag = "Select Data File"
        '
        'Label12
        '
        Me.Label12.Location = New System.Drawing.Point(8, 248)
        Me.Label12.Name = "Label12"
        Me.Label12.Size = New System.Drawing.Size(372, 16)
        Me.Label12.TabIndex = 6
        Me.Label12.Text = "To continue press Next.  To return to the previous step press Back."
        '
        'btnGetDataFileName
        '
        Me.btnGetDataFileName.Location = New System.Drawing.Point(352, 144)
        Me.btnGetDataFileName.Name = "btnGetDataFileName"
        Me.btnGetDataFileName.Size = New System.Drawing.Size(28, 23)
        Me.btnGetDataFileName.TabIndex = 3
        Me.btnGetDataFileName.Text = "..."
        '
        'cboDataFileFormat
        '
        Me.cboDataFileFormat.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.cboDataFileFormat.Items.AddRange(New Object() {"DBF File"})
        Me.cboDataFileFormat.Location = New System.Drawing.Point(8, 200)
        Me.cboDataFileFormat.Name = "cboDataFileFormat"
        Me.cboDataFileFormat.Size = New System.Drawing.Size(372, 21)
        Me.cboDataFileFormat.TabIndex = 5
        '
        'txtDataFileName
        '
        Me.txtDataFileName.Location = New System.Drawing.Point(8, 144)
        Me.txtDataFileName.Name = "txtDataFileName"
        Me.txtDataFileName.ReadOnly = True
        Me.txtDataFileName.Size = New System.Drawing.Size(340, 21)
        Me.txtDataFileName.TabIndex = 2
        Me.txtDataFileName.Text = ""
        '
        'Label6
        '
        Me.Label6.Location = New System.Drawing.Point(8, 184)
        Me.Label6.Name = "Label6"
        Me.Label6.Size = New System.Drawing.Size(372, 16)
        Me.Label6.TabIndex = 4
        Me.Label6.Text = "Offline Data File Format:"
        '
        'Label4
        '
        Me.Label4.Location = New System.Drawing.Point(8, 128)
        Me.Label4.Name = "Label4"
        Me.Label4.Size = New System.Drawing.Size(372, 16)
        Me.Label4.TabIndex = 1
        Me.Label4.Text = "Offline Data File:"
        '
        'Label5
        '
        Me.Label5.Location = New System.Drawing.Point(8, 8)
        Me.Label5.Name = "Label5"
        Me.Label5.Size = New System.Drawing.Size(372, 36)
        Me.Label5.TabIndex = 0
        Me.Label5.Text = "Select the offline data file to be imported into the QualiSys system and the data" & _
        " format of the specified file."
        '
        'ofdMain
        '
        Me.ofdMain.Filter = "DBF Files|*.dbf|Access Database|*.mdb|Delimited Text Files|*.csv,*.txt|Fixed Widt" & _
        "h Text Files|*.txt|All Files|*.*"
        Me.ofdMain.Title = "Offline Data File"
        '
        'pnlFinish
        '
        Me.pnlFinish.Controls.Add(Me.fraProgress)
        Me.pnlFinish.Controls.Add(Me.Label7)
        Me.pnlFinish.Controls.Add(Me.Label8)
        Me.pnlFinish.Location = New System.Drawing.Point(160, 8)
        Me.pnlFinish.Name = "pnlFinish"
        Me.pnlFinish.Size = New System.Drawing.Size(388, 272)
        Me.pnlFinish.TabIndex = 5
        Me.pnlFinish.Tag = "Finished!"
        '
        'fraProgress
        '
        Me.fraProgress.Controls.Add(Me.lblTotRec)
        Me.fraProgress.Controls.Add(Me.Label17)
        Me.fraProgress.Controls.Add(Me.lblCurRec)
        Me.fraProgress.Controls.Add(Me.Label15)
        Me.fraProgress.Controls.Add(Me.pbrMain)
        Me.fraProgress.Location = New System.Drawing.Point(12, 160)
        Me.fraProgress.Name = "fraProgress"
        Me.fraProgress.Size = New System.Drawing.Size(364, 68)
        Me.fraProgress.TabIndex = 2
        Me.fraProgress.TabStop = False
        '
        'lblTotRec
        '
        Me.lblTotRec.Location = New System.Drawing.Point(200, 48)
        Me.lblTotRec.Name = "lblTotRec"
        Me.lblTotRec.Size = New System.Drawing.Size(76, 16)
        Me.lblTotRec.TabIndex = 4
        Me.lblTotRec.Text = "0"
        '
        'Label17
        '
        Me.Label17.Location = New System.Drawing.Point(168, 48)
        Me.Label17.Name = "Label17"
        Me.Label17.Size = New System.Drawing.Size(24, 16)
        Me.Label17.TabIndex = 3
        Me.Label17.Text = "of"
        Me.Label17.TextAlign = System.Drawing.ContentAlignment.TopCenter
        '
        'lblCurRec
        '
        Me.lblCurRec.Location = New System.Drawing.Point(84, 48)
        Me.lblCurRec.Name = "lblCurRec"
        Me.lblCurRec.Size = New System.Drawing.Size(76, 16)
        Me.lblCurRec.TabIndex = 2
        Me.lblCurRec.Text = "0"
        Me.lblCurRec.TextAlign = System.Drawing.ContentAlignment.TopRight
        '
        'Label15
        '
        Me.Label15.Location = New System.Drawing.Point(12, 12)
        Me.Label15.Name = "Label15"
        Me.Label15.Size = New System.Drawing.Size(340, 16)
        Me.Label15.TabIndex = 1
        Me.Label15.Text = "Importing Data..."
        '
        'pbrMain
        '
        Me.pbrMain.Location = New System.Drawing.Point(12, 32)
        Me.pbrMain.Name = "pbrMain"
        Me.pbrMain.Size = New System.Drawing.Size(340, 12)
        Me.pbrMain.TabIndex = 0
        '
        'Label7
        '
        Me.Label7.Location = New System.Drawing.Point(8, 72)
        Me.Label7.Name = "Label7"
        Me.Label7.Size = New System.Drawing.Size(372, 23)
        Me.Label7.TabIndex = 1
        Me.Label7.Text = "To import your data press Finish."
        '
        'Label8
        '
        Me.Label8.Location = New System.Drawing.Point(8, 8)
        Me.Label8.Name = "Label8"
        Me.Label8.Size = New System.Drawing.Size(372, 36)
        Me.Label8.TabIndex = 0
        Me.Label8.Text = "The Offline Transfer Results Wizard is finished collecting information and is rea" & _
        "dy to import."
        '
        'pnlStep2
        '
        Me.pnlStep2.Controls.Add(Me.Label14)
        Me.pnlStep2.Controls.Add(Me.chkOverwrite)
        Me.pnlStep2.Controls.Add(Me.cboReturnDateField)
        Me.pnlStep2.Controls.Add(Me.Label13)
        Me.pnlStep2.Controls.Add(Me.cboLithoCodeField)
        Me.pnlStep2.Controls.Add(Me.Label11)
        Me.pnlStep2.Controls.Add(Me.Label9)
        Me.pnlStep2.Controls.Add(Me.Label10)
        Me.pnlStep2.Location = New System.Drawing.Point(160, 8)
        Me.pnlStep2.Name = "pnlStep2"
        Me.pnlStep2.Size = New System.Drawing.Size(388, 272)
        Me.pnlStep2.TabIndex = 2
        Me.pnlStep2.Tag = "General Configuration"
        '
        'Label14
        '
        Me.Label14.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label14.Location = New System.Drawing.Point(28, 204)
        Me.Label14.Name = "Label14"
        Me.Label14.Size = New System.Drawing.Size(288, 28)
        Me.Label14.TabIndex = 7
        Me.Label14.Text = "Note:  This is only allowed for records that were imported today."
        '
        'chkOverwrite
        '
        Me.chkOverwrite.Location = New System.Drawing.Point(8, 184)
        Me.chkOverwrite.Name = "chkOverwrite"
        Me.chkOverwrite.Size = New System.Drawing.Size(372, 16)
        Me.chkOverwrite.TabIndex = 5
        Me.chkOverwrite.Text = "Overwrite data if this return has already been imported."
        '
        'cboReturnDateField
        '
        Me.cboReturnDateField.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.cboReturnDateField.Location = New System.Drawing.Point(200, 144)
        Me.cboReturnDateField.Name = "cboReturnDateField"
        Me.cboReturnDateField.Size = New System.Drawing.Size(180, 21)
        Me.cboReturnDateField.TabIndex = 4
        '
        'Label13
        '
        Me.Label13.Location = New System.Drawing.Point(200, 128)
        Me.Label13.Name = "Label13"
        Me.Label13.Size = New System.Drawing.Size(180, 16)
        Me.Label13.TabIndex = 3
        Me.Label13.Text = "Return Date Field:"
        '
        'cboLithoCodeField
        '
        Me.cboLithoCodeField.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.cboLithoCodeField.Location = New System.Drawing.Point(8, 144)
        Me.cboLithoCodeField.Name = "cboLithoCodeField"
        Me.cboLithoCodeField.Size = New System.Drawing.Size(180, 21)
        Me.cboLithoCodeField.TabIndex = 2
        '
        'Label11
        '
        Me.Label11.Location = New System.Drawing.Point(8, 128)
        Me.Label11.Name = "Label11"
        Me.Label11.Size = New System.Drawing.Size(180, 16)
        Me.Label11.TabIndex = 1
        Me.Label11.Text = "LithoCode Field:"
        '
        'Label9
        '
        Me.Label9.Location = New System.Drawing.Point(8, 248)
        Me.Label9.Name = "Label9"
        Me.Label9.Size = New System.Drawing.Size(372, 16)
        Me.Label9.TabIndex = 6
        Me.Label9.Text = "To continue press Next.  To return to the previous step press Back."
        '
        'Label10
        '
        Me.Label10.Location = New System.Drawing.Point(8, 8)
        Me.Label10.Name = "Label10"
        Me.Label10.Size = New System.Drawing.Size(372, 36)
        Me.Label10.TabIndex = 0
        Me.Label10.Text = "This step allows you to specify the data field to be used for the LithoCode as we" & _
        "ll as specify other import parameters."
        '
        'pnlStep3
        '
        Me.pnlStep3.Controls.Add(Me.Label16)
        Me.pnlStep3.Controls.Add(Me.txtTOCLValues)
        Me.pnlStep3.Controls.Add(Me.Label18)
        Me.pnlStep3.Controls.Add(Me.cboTOCLField)
        Me.pnlStep3.Controls.Add(Me.Label19)
        Me.pnlStep3.Controls.Add(Me.Label20)
        Me.pnlStep3.Controls.Add(Me.Label21)
        Me.pnlStep3.Location = New System.Drawing.Point(160, 8)
        Me.pnlStep3.Name = "pnlStep3"
        Me.pnlStep3.Size = New System.Drawing.Size(388, 272)
        Me.pnlStep3.TabIndex = 3
        Me.pnlStep3.Tag = "TOCL Configuration"
        '
        'Label16
        '
        Me.Label16.Location = New System.Drawing.Point(8, 216)
        Me.Label16.Name = "Label16"
        Me.Label16.Size = New System.Drawing.Size(372, 16)
        Me.Label16.TabIndex = 5
        Me.Label16.Text = "(Comma delimited list of values to identify records to be added to TOCL)"
        '
        'txtTOCLValues
        '
        Me.txtTOCLValues.Location = New System.Drawing.Point(8, 192)
        Me.txtTOCLValues.Name = "txtTOCLValues"
        Me.txtTOCLValues.Size = New System.Drawing.Size(372, 21)
        Me.txtTOCLValues.TabIndex = 4
        Me.txtTOCLValues.Text = ""
        '
        'Label18
        '
        Me.Label18.Location = New System.Drawing.Point(8, 176)
        Me.Label18.Name = "Label18"
        Me.Label18.Size = New System.Drawing.Size(372, 16)
        Me.Label18.TabIndex = 3
        Me.Label18.Text = "TOCL Disposition Values:"
        '
        'cboTOCLField
        '
        Me.cboTOCLField.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.cboTOCLField.Location = New System.Drawing.Point(8, 144)
        Me.cboTOCLField.Name = "cboTOCLField"
        Me.cboTOCLField.Size = New System.Drawing.Size(372, 21)
        Me.cboTOCLField.TabIndex = 2
        '
        'Label19
        '
        Me.Label19.Location = New System.Drawing.Point(8, 128)
        Me.Label19.Name = "Label19"
        Me.Label19.Size = New System.Drawing.Size(372, 16)
        Me.Label19.TabIndex = 1
        Me.Label19.Text = "TOCL Disposition Field:"
        '
        'Label20
        '
        Me.Label20.Location = New System.Drawing.Point(8, 248)
        Me.Label20.Name = "Label20"
        Me.Label20.Size = New System.Drawing.Size(372, 16)
        Me.Label20.TabIndex = 6
        Me.Label20.Text = "To continue press Next.  To return to the previous step press Back."
        '
        'Label21
        '
        Me.Label21.Location = New System.Drawing.Point(8, 8)
        Me.Label21.Name = "Label21"
        Me.Label21.Size = New System.Drawing.Size(372, 44)
        Me.Label21.TabIndex = 0
        Me.Label21.Text = "This step allows you to specify the data field to be used for the TOCL Dispositio" & _
        "n and to identify what disposition values will cause an addition to the TOCL."
        '
        'pnlStep4
        '
        Me.pnlStep4.Controls.Add(Me.lblBackgroundMapNA)
        Me.pnlStep4.Controls.Add(Me.btnBackgroundRemove)
        Me.pnlStep4.Controls.Add(Me.btnBackgroundAdd)
        Me.pnlStep4.Controls.Add(Me.lvwBackgroundMappings)
        Me.pnlStep4.Controls.Add(Me.cboBackgroundPop)
        Me.pnlStep4.Controls.Add(Me.lblBackgroundPop)
        Me.pnlStep4.Controls.Add(Me.cboBackgroundSource)
        Me.pnlStep4.Controls.Add(Me.lblBackgroundSource)
        Me.pnlStep4.Controls.Add(Me.Label25)
        Me.pnlStep4.Controls.Add(Me.Label26)
        Me.pnlStep4.Location = New System.Drawing.Point(160, 8)
        Me.pnlStep4.Name = "pnlStep4"
        Me.pnlStep4.Size = New System.Drawing.Size(388, 272)
        Me.pnlStep4.TabIndex = 4
        Me.pnlStep4.Tag = "Background Data Configuration"
        '
        'lblBackgroundMapNA
        '
        Me.lblBackgroundMapNA.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle
        Me.lblBackgroundMapNA.Font = New System.Drawing.Font("Tahoma", 10.0!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lblBackgroundMapNA.ForeColor = System.Drawing.Color.Blue
        Me.lblBackgroundMapNA.Location = New System.Drawing.Point(28, 136)
        Me.lblBackgroundMapNA.Name = "lblBackgroundMapNA"
        Me.lblBackgroundMapNA.Size = New System.Drawing.Size(332, 56)
        Me.lblBackgroundMapNA.TabIndex = 14
        Me.lblBackgroundMapNA.Text = "There are results for more than one StudyID in the specified file so mapping is n" & _
        "ot available!"
        Me.lblBackgroundMapNA.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
        '
        'btnBackgroundRemove
        '
        Me.btnBackgroundRemove.Location = New System.Drawing.Point(328, 220)
        Me.btnBackgroundRemove.Name = "btnBackgroundRemove"
        Me.btnBackgroundRemove.Size = New System.Drawing.Size(52, 20)
        Me.btnBackgroundRemove.TabIndex = 13
        Me.btnBackgroundRemove.Text = "Remove"
        '
        'btnBackgroundAdd
        '
        Me.btnBackgroundAdd.Location = New System.Drawing.Point(328, 68)
        Me.btnBackgroundAdd.Name = "btnBackgroundAdd"
        Me.btnBackgroundAdd.Size = New System.Drawing.Size(52, 20)
        Me.btnBackgroundAdd.TabIndex = 12
        Me.btnBackgroundAdd.Text = "Add"
        '
        'lvwBackgroundMappings
        '
        Me.lvwBackgroundMappings.Columns.AddRange(New System.Windows.Forms.ColumnHeader() {Me.chdSource, Me.chdPopulation})
        Me.lvwBackgroundMappings.FullRowSelect = True
        Me.lvwBackgroundMappings.Location = New System.Drawing.Point(8, 100)
        Me.lvwBackgroundMappings.Name = "lvwBackgroundMappings"
        Me.lvwBackgroundMappings.Size = New System.Drawing.Size(372, 112)
        Me.lvwBackgroundMappings.TabIndex = 11
        Me.lvwBackgroundMappings.View = System.Windows.Forms.View.Details
        '
        'chdSource
        '
        Me.chdSource.Text = "Source Field"
        Me.chdSource.Width = 170
        '
        'chdPopulation
        '
        Me.chdPopulation.Text = "Population Field"
        Me.chdPopulation.Width = 170
        '
        'cboBackgroundPop
        '
        Me.cboBackgroundPop.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.cboBackgroundPop.Location = New System.Drawing.Point(168, 68)
        Me.cboBackgroundPop.Name = "cboBackgroundPop"
        Me.cboBackgroundPop.Size = New System.Drawing.Size(148, 21)
        Me.cboBackgroundPop.TabIndex = 10
        '
        'lblBackgroundPop
        '
        Me.lblBackgroundPop.Location = New System.Drawing.Point(168, 52)
        Me.lblBackgroundPop.Name = "lblBackgroundPop"
        Me.lblBackgroundPop.Size = New System.Drawing.Size(148, 16)
        Me.lblBackgroundPop.TabIndex = 9
        Me.lblBackgroundPop.Text = "Population Field:"
        '
        'cboBackgroundSource
        '
        Me.cboBackgroundSource.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.cboBackgroundSource.Location = New System.Drawing.Point(8, 68)
        Me.cboBackgroundSource.Name = "cboBackgroundSource"
        Me.cboBackgroundSource.Size = New System.Drawing.Size(148, 21)
        Me.cboBackgroundSource.TabIndex = 8
        '
        'lblBackgroundSource
        '
        Me.lblBackgroundSource.Location = New System.Drawing.Point(8, 52)
        Me.lblBackgroundSource.Name = "lblBackgroundSource"
        Me.lblBackgroundSource.Size = New System.Drawing.Size(148, 16)
        Me.lblBackgroundSource.TabIndex = 7
        Me.lblBackgroundSource.Text = "Source Field:"
        '
        'Label25
        '
        Me.Label25.Location = New System.Drawing.Point(8, 248)
        Me.Label25.Name = "Label25"
        Me.Label25.Size = New System.Drawing.Size(372, 16)
        Me.Label25.TabIndex = 6
        Me.Label25.Text = "To continue press Next.  To return to the previous step press Back."
        '
        'Label26
        '
        Me.Label26.Location = New System.Drawing.Point(8, 8)
        Me.Label26.Name = "Label26"
        Me.Label26.Size = New System.Drawing.Size(372, 36)
        Me.Label26.TabIndex = 0
        Me.Label26.Text = "This step allows you to map data fields from the source file into fields in the P" & _
        "opulation table."
        '
        'frmMain
        '
        Me.AutoScaleBaseSize = New System.Drawing.Size(5, 14)
        Me.ClientSize = New System.Drawing.Size(554, 331)
        Me.Controls.Add(Me.Label3)
        Me.Controls.Add(Me.lblVersion)
        Me.Controls.Add(Me.btnCancel)
        Me.Controls.Add(Me.btnBack)
        Me.Controls.Add(Me.btnNext)
        Me.Controls.Add(Me.btnFinish)
        Me.Controls.Add(Me.btnAbout)
        Me.Controls.Add(Me.GroupBox1)
        Me.Controls.Add(Me.picMain)
        Me.Controls.Add(Me.pnlStep4)
        Me.Controls.Add(Me.pnlFinish)
        Me.Controls.Add(Me.pnlIntro)
        Me.Controls.Add(Me.pnlStep1)
        Me.Controls.Add(Me.pnlStep2)
        Me.Controls.Add(Me.pnlStep3)
        Me.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedSingle
        Me.Icon = CType(resources.GetObject("$this.Icon"), System.Drawing.Icon)
        Me.MaximizeBox = False
        Me.Name = "frmMain"
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen
        Me.Tag = "Offline Transfer Results Wizard"
        Me.Text = "Offline Transfer Results Wizard"
        Me.pnlIntro.ResumeLayout(False)
        Me.pnlStep1.ResumeLayout(False)
        Me.pnlFinish.ResumeLayout(False)
        Me.fraProgress.ResumeLayout(False)
        Me.pnlStep2.ResumeLayout(False)
        Me.pnlStep3.ResumeLayout(False)
        Me.pnlStep4.ResumeLayout(False)
        Me.ResumeLayout(False)

    End Sub

#End Region

#Region "Module Level Variable Declarations"
    Private mbolActivated As Boolean = False

    Private Enum enuWizardStepContants
        enuWSCNone = -1
        enuWSCIntro = 0
        enuWSCStep1 = 1
        enuWSCStep2 = 2
        enuWSCStep3 = 3
        enuWSCStep4 = 4
        enuWSCFinish = 5
    End Enum
    Private maobjStepPanels() As Panel
    Private menuCurrentStep As enuWizardStepContants = enuWizardStepContants.enuWSCNone

    Private mobjDataFileFormats As New ArrayList
    Private mobjDataSet As DataSet
    Private mobjQuestionnaires As New ArrayList

    Private mintImported As Integer
    Private mintIgnored As Integer
    Private mintErrors As Integer
    Private mintReplaced As Integer
    Private mintTOCL As Integer
    Private mstrErrorFileName As String = ""

    ''Updater
    'Private WithEvents mUpdater As Microsoft.Samples.AppUpdater.AppUpdater = modMain.Updater

#End Region

#Region " Updater Events "

    ''When an update has been downloaded, display a message to the user
    'Private Sub Updater_OnUpdateComplete(ByVal sender As System.Object, ByVal e As Microsoft.Samples.AppUpdater.UpdateCompleteEventArgs) Handles mUpdater.OnUpdateComplete
    '    'if the download was successfull then ask if the user wants to restart now
    '    If e.UpdateSucceeded Then
    '        If MessageBox.Show("A new version of " & AppName & " is available.  Would you like to restart " & AppName & " and use the new version now?", "Update Detected", MessageBoxButtons.YesNo, MessageBoxIcon.Question) = DialogResult.Yes Then
    '            'Restart the app and close this one
    '            Updater.RestartApp()
    '            Me.Close()
    '        End If
    '    Else
    '        'Display error message
    '        Dim ex As New Exception(e.ErrorMessage, e.FailureException)
    '        ReportException(ex, "Auto Update Error")
    '    End If
    'End Sub

#End Region

#Region "Form Events"
    Private Sub frmMain_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load

        'Set the version number
        lblVersion.Text = Application.ProductVersion
        lblUserName.Text = CurrentUser.UserName
        lblEnvironment.Text = Config.EnvironmentName

        'Hide the Progress Panel
        fraProgress.Visible = False

        'Load the data file formats
        mobjDataFileFormats.Add(New clsDataFileFormat(enuFormatID:=clsDataFileFormat.enuDataFileFormatConstants.enuDFCDBF, strFormatName:="DBF File"))
        With cboDataFileFormat
            .Items.Clear()
            .DataSource = mobjDataFileFormats
            .DisplayMember = "FormatName"
            .ValueMember = "FormatID"
        End With

        'Load the step panels into the array
        ReDim maobjStepPanels(enuWizardStepContants.enuWSCFinish)
        maobjStepPanels(enuWizardStepContants.enuWSCIntro) = pnlIntro
        maobjStepPanels(enuWizardStepContants.enuWSCStep1) = pnlStep1
        maobjStepPanels(enuWizardStepContants.enuWSCStep2) = pnlStep2
        maobjStepPanels(enuWizardStepContants.enuWSCStep3) = pnlStep3
        maobjStepPanels(enuWizardStepContants.enuWSCStep4) = pnlStep4
        maobjStepPanels(enuWizardStepContants.enuWSCFinish) = pnlFinish

        'Setup the panels
        SetStep(enuNewStep:=enuWizardStepContants.enuWSCIntro)

    End Sub

    Private Sub frmMain_Activated(ByVal sender As Object, ByVal e As System.EventArgs) Handles MyBase.Activated

        If mbolActivated Then Exit Sub

        'Set the flag so we don't do this more than once
        mbolActivated = True


    End Sub
#End Region

#Region "Button Handlers"
    Private Sub btnGetDataFileName_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnGetDataFileName.Click

        'Show the file open dialog
        ofdMain.ShowDialog(Me)
        txtDataFileName.Text = ofdMain.FileName

    End Sub

    Private Sub btnAbout_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnAbout.Click

        'Display the About Dialog

    End Sub

    Private Sub btnCancel_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnCancel.Click

        'Set the message to be displayed
        Dim strMsg As String = "Are you sure you want to exit the" & vbCrLf & _
                               "Offline Transfer Results Wizard?"

        If MessageBox.Show(strMsg, Globals.gkstrMsgBoxTitle, MessageBoxButtons.YesNo, MessageBoxIcon.Question, MessageBoxDefaultButton.Button2) = DialogResult.Yes Then
            'We are going to exit the application
            Me.Close()
        End If

    End Sub

    Private Sub btnBack_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnBack.Click

        'Move to the next step
        SetStep(enuNewStep:=menuCurrentStep - 1)

    End Sub

    Private Sub btnNext_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnNext.Click

        'Validate the current step
        If Not IsDataValid(enuStep:=menuCurrentStep) Then
            'Something is invalid so we cannot go to the next step
            Exit Sub
        End If

        'Move to the next step
        SetStep(enuNewStep:=menuCurrentStep + 1)

    End Sub

    Private Sub btnFinish_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnFinish.Click

        'Set the mouse pointer
        Windows.Forms.Cursor.Current = System.Windows.Forms.Cursors.WaitCursor

        'Lock down the form
        btnAbout.Enabled = False
        btnCancel.Enabled = False
        btnBack.Enabled = False
        btnNext.Enabled = False
        btnFinish.Enabled = False

        'Process the specified file
        ProcessQuestionnaires()

        'Write the log file
        OutputLog()

        'Build notification string
        Dim strMsg As String = ""
        If mintErrors > 0 Then
            strMsg = "Errors were encountered while processing the Import file!" & vbCrLf & vbCrLf & _
                     "Please refer to the following error file for additional" & vbCrLf & _
                     "information:" & vbCrLf & vbCrLf & mstrErrorFileName
        Else
            strMsg = "The Offline Transfer Results completed Successfully!"
        End If

        'Display the message
        MessageBox.Show(strMsg, Globals.gkstrMsgBoxTitle, MessageBoxButtons.OK, MessageBoxIcon.Information)

        'Set the mouse pointer
        Cursor.Current = System.Windows.Forms.Cursors.Default

        'End the program
        Me.Close()

    End Sub

    Private Sub btnBackgroundAdd_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnBackgroundAdd.Click

        Dim strMsg As String = ""
        Dim objItem As ListViewItem

        'Validate that both a source and pop field have been selected
        If cboBackgroundSource.Text.Trim.Length = 0 Then
            strMsg = "You must select a source field!"
            cboBackgroundSource.Focus()
        ElseIf cboBackgroundPop.Text.Trim.Length = 0 Then
            strMsg = "You must select a population field!"
            cboBackgroundPop.Focus()
        Else
            For Each objItem In lvwBackgroundMappings.Items
                If objItem.SubItems(0).Text.Trim = cboBackgroundSource.Text.Trim Then
                    strMsg = "You have already mapped the '" & cboBackgroundSource.Text & "' source field!"
                    cboBackgroundSource.Focus()
                    Exit For
                ElseIf objItem.SubItems(1).Text.Trim = cboBackgroundPop.Text.Trim Then
                    strMsg = "You have already mapped the '" & cboBackgroundPop.Text & "' population field!"
                    cboBackgroundPop.Focus()
                    Exit For
                End If
            Next
        End If

        'Add this entry to the background mappings
        If strMsg.Length > 0 Then
            'Display the message
            MessageBox.Show(strMsg, Globals.gkstrMsgBoxTitle, MessageBoxButtons.OK, MessageBoxIcon.Error)
        Else
            'Add the entry
            lvwBackgroundMappings.Items.Add(New ListViewItem(New String() {cboBackgroundSource.Text, cboBackgroundPop.Text}))
        End If

    End Sub

    Private Sub btnBackgroundRemove_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnBackgroundRemove.Click

        Dim objItem As ListViewItem

        If lvwBackgroundMappings.SelectedItems.Count > 0 Then
            For Each objItem In lvwBackgroundMappings.SelectedItems
                objItem.Remove()
            Next
        End If

    End Sub

#End Region

#Region "Wizard Handlers"
    Private Sub SetStep(ByVal enuNewStep As enuWizardStepContants)

        Dim intCnt As Integer

        'Turn all panels off
        For intCnt = 0 To maobjStepPanels.GetUpperBound(0)
            With maobjStepPanels(intCnt)
                .Visible = False
                .Enabled = False
            End With
        Next

        'Turn on the specified panel
        With maobjStepPanels(enuNewStep)
            .Visible = True
            .Enabled = True
            .BringToFront()
        End With

        'Set the caption
        Me.Text = Me.Tag & " - " & maobjStepPanels(enuNewStep).Tag

        'Setup the form and buttons
        Select Case enuNewStep
            Case enuWizardStepContants.enuWSCIntro
                btnBack.Enabled = False
                btnNext.Enabled = True
                btnFinish.Enabled = False
                btnNext.Focus()

            Case enuWizardStepContants.enuWSCStep1
                btnBack.Enabled = False
                btnNext.Enabled = True
                btnFinish.Enabled = False
                btnGetDataFileName.Focus()

                'Default the file type to DBF
                If enuNewStep > menuCurrentStep Then cboDataFileFormat.SelectedIndex = 0

            Case enuWizardStepContants.enuWSCStep2
                btnBack.Enabled = True
                btnNext.Enabled = True
                btnFinish.Enabled = False
                cboLithoCodeField.Focus()

            Case enuWizardStepContants.enuWSCStep3
                btnBack.Enabled = True
                btnNext.Enabled = True
                btnFinish.Enabled = False
                cboTOCLField.Focus()

            Case enuWizardStepContants.enuWSCStep4
                btnBack.Enabled = True
                btnNext.Enabled = True
                btnFinish.Enabled = False
                If cboBackgroundPop.Items.Count = 0 Then
                    'There are more than one StudyID so this step is not available
                    lblBackgroundMapNA.Visible = True
                    lblBackgroundSource.Enabled = False
                    cboBackgroundSource.Enabled = False
                    lblBackgroundPop.Enabled = False
                    cboBackgroundPop.Enabled = False
                    btnBackgroundAdd.Enabled = False
                    btnBackgroundRemove.Enabled = False
                    lvwBackgroundMappings.Enabled = False
                    btnNext.Focus()
                Else
                    'Step is available
                    lblBackgroundMapNA.Visible = False
                    lblBackgroundSource.Enabled = True
                    cboBackgroundSource.Enabled = True
                    lblBackgroundPop.Enabled = True
                    cboBackgroundPop.Enabled = True
                    btnBackgroundAdd.Enabled = True
                    btnBackgroundRemove.Enabled = True
                    lvwBackgroundMappings.Enabled = True
                    cboBackgroundSource.Focus()
                End If

            Case enuWizardStepContants.enuWSCFinish
                btnBack.Enabled = True
                btnNext.Enabled = False
                btnFinish.Enabled = True
                btnFinish.Focus()

        End Select

        'Store the new step number
        menuCurrentStep = enuNewStep

    End Sub

    Private Function IsDataValid(ByVal enuStep As enuWizardStepContants) As Boolean

        Dim strMsg As String = ""

        'Check the data fields for validity
        Select Case enuStep
            Case enuWizardStepContants.enuWSCStep1
                If txtDataFileName.Text.Trim.Length = 0 Then
                    strMsg = "You must select a file to be imported!"
                    btnGetDataFileName.Focus()
                ElseIf cboDataFileFormat.Text.Trim.Length = 0 Then
                    strMsg = "You must select a file format for the specified data file!"
                    cboDataFileFormat.Focus()
                Else
                    Dim objFileInfo As New FileInfo(txtDataFileName.Text)
                    If Not objFileInfo.Exists Then
                        'Selected datfile does not exist.
                        strMsg = "The specified data file does not exist!"
                        btnGetDataFileName.Focus()
                    Else
                        'Datafile exists so we need to open it up.
                        If txtDataFileName.Text <> txtDataFileName.Tag Then
                            'Store the current datafile name
                            txtDataFileName.Tag = txtDataFileName.Text

                            'Read in the data
                            PopDataSetFromFile(strFileName:=txtDataFileName.Text, enuDataFileFormat:=cboDataFileFormat.SelectedValue)
                        End If
                    End If
                End If

            Case enuWizardStepContants.enuWSCStep2
                If cboLithoCodeField.Text.Trim.Length = 0 Then
                    strMsg = "You must specify the LithoCode field!"
                    cboLithoCodeField.Focus()
                ElseIf cboReturnDateField.Text.Trim.Length = 0 Then
                    strMsg = "You must specify the Return Date field or select <none>!"
                    cboReturnDateField.Focus()
                Else
                    'Everything checked out so let's populate the background field list
                    If cboLithoCodeField.Text <> cboLithoCodeField.Tag Then
                        'Store the current LithoCode field name
                        cboLithoCodeField.Tag = cboLithoCodeField.Text

                        'Populate the list
                        PopPopulationFieldList()
                    End If
                End If

            Case enuWizardStepContants.enuWSCStep3
                If cboTOCLField.Text.Trim.Length = 0 Then
                    strMsg = "You must specify the TOCL field or select <none>!"
                    cboTOCLField.Focus()
                ElseIf cboTOCLField.Text.Trim.ToUpper <> "<NONE>" And txtTOCLValues.Text.Trim.Length = 0 Then
                    strMsg = "You must specify the values to" & vbCrLf & "identify records to be added to TOCL!"
                    txtTOCLValues.Focus()
                End If

        End Select

        'Determine the return value
        If strMsg.Length > 0 Then
            MessageBox.Show(strMsg, Globals.gkstrMsgBoxTitle, MessageBoxButtons.OK, MessageBoxIcon.Error)
            Return False
        Else
            Return True
        End If

    End Function

    Private Sub PopDataSetFromFile(ByVal strFileName As String, ByVal enuDataFileFormat As clsDataFileFormat.enuDataFileFormatConstants)

        Select Case enuDataFileFormat
            Case clsDataFileFormat.enuDataFileFormatConstants.enuDFCDBF
                PopDataSetFromDBF(strFileName:=strFileName)

        End Select

        'Populate the field combo boxes with field names
        PopFieldLists()

    End Sub

    Private Sub PopDataSetFromDBF(ByVal strFileName As String)

        'Get the information on the file to be loaded
        Dim objFileInfo As New FileInfo(strFileName)
        Dim strDirectory As String = objFileInfo.DirectoryName
        Dim strTableName As String = objFileInfo.Name

        'Build the select string
        Dim strSQL As String = "SELECT * FROM " & strTableName

        'Build the connection string
        Dim strConn As String = "Driver={Microsoft dBase Driver (*.dbf)};DBQ=" & strDirectory

        'Open the connection
        Dim objConnection As OdbcConnection = New OdbcConnection(strConn)
        Dim objDataAdapter As OdbcDataAdapter = New OdbcDataAdapter
        Dim objCommand As OdbcCommand

        'Build the command
        objCommand = New OdbcCommand(strSQL, objConnection)

        'Populate the dataset
        objDataAdapter.SelectCommand = objCommand
        mobjDataSet = New DataSet
        objDataAdapter.Fill(mobjDataSet, strTableName)

    End Sub

    Private Sub PopFieldLists()

        Dim intCnt As Integer
        'Dim intRowCnt As Integer
        Dim intLithoMatch As Integer = -1
        Dim intReturnDateMatch As Integer = 0
        Dim intTOCLMatch As Integer = 0

        'Clear the current contents of the lists
        cboLithoCodeField.Items.Clear()
        cboReturnDateField.Items.Clear()
        cboTOCLField.Items.Clear()
        cboBackgroundSource.Items.Clear()
        'cboBackgroundPop.Items.Clear()
        lvwBackgroundMappings.Items.Clear()

        'Add the required none options
        cboReturnDateField.Items.Add("<None>")
        cboTOCLField.Items.Add("<None>")

        'Loop through all of the columns and add the column names
        With mobjDataSet.Tables(0)
            For intCnt = 0 To .Columns.Count - 1
                'Add this column name to the list
                cboLithoCodeField.Items.Add(.Columns(intCnt).ColumnName)
                cboReturnDateField.Items.Add(.Columns(intCnt).ColumnName)
                cboTOCLField.Items.Add(.Columns(intCnt).ColumnName)
                cboBackgroundSource.Items.Add(.Columns(intCnt).ColumnName)

                'If this appears to be the litho column then save it's index
                If .Columns(intCnt).ColumnName.ToUpper.IndexOf("LITHO") > -1 Then
                    intLithoMatch = intCnt
                End If

                'If this appears to be the return date column then save it's index
                If .Columns(intCnt).ColumnName.ToUpper.IndexOf("DATE") > -1 Then
                    intReturnDateMatch = intCnt + 1
                End If

                'If this appears to be the TOCL column then save it's index
                If .Columns(intCnt).ColumnName.ToUpper.IndexOf("TOCL") > -1 Then
                    intTOCLMatch = intCnt + 1
                End If
            Next
        End With

        'Select our best bet if we found one for the litho column
        If intLithoMatch > -1 Then
            cboLithoCodeField.SelectedIndex = intLithoMatch
        End If
        cboLithoCodeField.Tag = ""

        'Select our best bet if we found one for the return date column otherwise select '<None>'
        cboReturnDateField.SelectedIndex = intReturnDateMatch

        'Select our best bet if we found one for the TOCL column otherwise select '<None>'
        cboTOCLField.SelectedIndex = intTOCLMatch
        txtTOCLValues.Text = ""

    End Sub

    Private Sub PopPopulationFieldList()

        Dim strSQL As String = ""
        Dim strLithoList As String = ""
        Dim intRowCnt As Integer

        'Clear the current contents of the list
        'cboBackgroundPop.Items.Clear()

        'Get the connection string
        'Dim strConn As String = GetSQLConnectString(strApplication:="OfflineTransferResults")
        Dim strConn As String = Config.QP_ProdConnection

        'Open the connection
        Dim objConnection As SqlConnection = New SqlConnection(strConn)
        objConnection.Open()

        'Build the lithocode list
        With mobjDataSet.Tables(0)
            For intRowCnt = 0 To .Rows.Count - 1
                'Check to see if the LithoCode field is blank
                If Not IsDBNull(.Rows(intRowCnt).Item(cboLithoCodeField.Text)) Then
                    'Add this lithocode to the list
                    strLithoList &= IIf(strLithoList.Length > 0, ",'", "'") & CStr(.Rows(intRowCnt).Item(cboLithoCodeField.Text)).Trim & "'"
                End If
            Next
        End With

        'Build the query
        strSQL = "CREATE TABLE #StudyIDs (Study_id int) " & vbCrLf & _
                 "CREATE TABLE #Fields (strField_Nm varchar(20), intFieldLength int) " & vbCrLf & _
                 vbCrLf & _
                 "INSERT INTO #StudyIDs (Study_id) " & vbCrLf & _
                 "SELECT DISTINCT sd.Study_id " & vbCrLf & _
                 "FROM SentMailing sm, QuestionForm qf, Survey_Def sd " & vbCrLf & _
                 "WHERE sm.SentMail_id = qf.SentMail_id " & vbCrLf & _
                 "  AND qf.Survey_id = sd.Survey_id " & vbCrLf & _
                 "  AND sm.strLithoCode in (" & strLithoList & ") " & vbCrLf & _
                 vbCrLf & _
                 "IF (@@ROWCOUNT = 1) " & vbCrLf & _
                 "BEGIN " & vbCrLf & _
                 "    INSERT INTO #Fields (strField_Nm, intFieldLength) " & vbCrLf & _
                 "    SELECT mf.strField_Nm, mf.intFieldLength " & vbCrLf & _
                 "    FROM MetaTable mt, MetaStructure ms, MetaField mf, #StudyIDs st " & vbCrLf & _
                 "    WHERE mt.Table_id = ms.Table_id " & vbCrLf & _
                 "      AND ms.Field_id = mf.Field_id " & vbCrLf & _
                 "      AND mt.Study_id = st.Study_id " & vbCrLf & _
                 "      AND mt.strTable_Nm like 'pop%' " & vbCrLf & _
                 "      AND ms.bitPostedField_Flg = 1 " & vbCrLf & _
                 "      AND ms.bitKeyField_Flg = 0 " & vbCrLf & _
                 "      AND ms.bitMatchField_Flg = 0 " & vbCrLf & _
                 "      AND mf.strFieldDataType = 'S' " & vbCrLf & _
                 "END " & vbCrLf & _
                 vbCrLf & _
                 "SELECT * FROM #Fields " & vbCrLf & _
                 vbCrLf & _
                 "DROP TABLE #StudyIDs " & vbCrLf & _
                 "DROP TABLE #Fields"

        'Build the select command
        Dim objCommand As SqlCommand = New SqlCommand(strSQL, objConnection)
        With objCommand
            .CommandTimeout = 0
            .CommandType = CommandType.Text
        End With

        'Populate the data reader
        Dim objReader As SqlDataReader = objCommand.ExecuteReader

        'Populate the meta field collection
        Globals.gobjMetaFields = New Collection
        While objReader.Read()
            'Create the new field object
            Dim objMetaField As clsMetaField = New clsMetaField(strFieldName:=CStr(objReader.Item("strField_Nm")), _
                                                                intFieldLength:=Val(objReader.Item("intFieldLength")))

            'Add this field to the collection
            Globals.gobjMetaFields.Add(objMetaField, objMetaField.FieldName)
        End While

        'Populate the combo box
        cboBackgroundPop.DataSource = Globals.gobjMetaFields
        cboBackgroundPop.DisplayMember = "FieldName"

        'Cleanup
        objReader.Close()
        objConnection.Close()

    End Sub

    Private Sub ProcessQuestionnaires()

        Dim intCnt As Integer
        Dim intRowCnt As Integer
        Dim intColCnt As Integer
        Dim objQuestionnaire As clsQuestionnaire
        Dim datDateReturned As Date
        Dim bolTOCL As Boolean
        Dim strTOCLValues As String = ""
        Dim objItem As ListViewItem
        Dim objPopMap As clsPopMap
        Dim strErrMsg As String = ""

        'Setup the progress panel
        lblTotRec.Text = mobjDataSet.Tables(0).Rows.Count.ToString
        pbrMain.Maximum = mobjDataSet.Tables(0).Rows.Count
        fraProgress.Visible = True
        fraProgress.Refresh()

        'Initialize the variables
        mintImported = 0
        mintIgnored = 0
        mintErrors = 0
        mintReplaced = 0
        mintTOCL = 0
        strTOCLValues = "," & txtTOCLValues.Text.Trim.ToUpper.Replace(" ", "") & ","

        'Get the connection string
        'Dim strConn As String = GetSQLConnectString(strApplication:="OfflineTransferResults")
        Dim strConn As String = Config.QP_ProdConnection

        'Open the connection
        Dim objConnection As SqlConnection = New SqlConnection(strConn)
        objConnection.Open()

        'Build the QuestionForm update command
        Dim objQFUpdateCommand As SqlCommand = New SqlCommand("sp_OffTR_QuestionFormUpdate", objConnection)
        With objQFUpdateCommand
            .CommandTimeout = 600
            .CommandType = CommandType.StoredProcedure
            .Parameters.Add("@intQuestionFormID", SqlDbType.Int)
            .Parameters.Add("@datDateReturned", SqlDbType.DateTime)
        End With

        'Build the QuestionResult insert command
        Dim objQRInsertCommand As SqlCommand = New SqlCommand("sp_OffTR_QuestionResultInsert", objConnection)
        With objQRInsertCommand
            .CommandTimeout = 600
            .CommandType = CommandType.StoredProcedure
            .Parameters.Add("@intQuestionFormID", SqlDbType.Int)
            .Parameters.Add("@intSampleUnitID", SqlDbType.Int)
            .Parameters.Add("@intQstnCore", SqlDbType.Int)
            .Parameters.Add("@intResponseVal", SqlDbType.Int)
        End With

        'Build the Send Thank You command
        Dim objSendThankYouCommand As SqlCommand = New SqlCommand("sp_OffTR_SendThankYous", objConnection)
        With objSendThankYouCommand
            .CommandTimeout = 600
            .CommandType = CommandType.StoredProcedure
            .Parameters.Add("@strLithoCode", SqlDbType.VarChar, 10)
            .Parameters.Add("@intSamplePopID", SqlDbType.Int)
        End With

        'Build the command
        Dim objPopUpdateCommand As SqlCommand = New SqlCommand("sp_BDUS_UpdateBackgroundInfo", objConnection)
        With objPopUpdateCommand
            .CommandTimeout = 600
            .CommandType = CommandType.StoredProcedure
            .Parameters.Add("@intStudyID", SqlDbType.Int)
            .Parameters.Add("@intPopID", SqlDbType.Int)
            .Parameters.Add("@intSamplePopID", SqlDbType.Int)
            .Parameters.Add("@intQuestionFormID", SqlDbType.Int)
            .Parameters.Add("@strSetClause", SqlDbType.VarChar, 7800)
            .Parameters.Add("@strFieldList", SqlDbType.VarChar, 5000)
            .Parameters.Add("@intProgram", SqlDbType.Int)
        End With

        'Collect all population mappings
        For Each objItem In lvwBackgroundMappings.Items
            If objItem.SubItems(0).Text.Trim.Length > 0 And objItem.SubItems(1).Text.Trim.Length > 0 Then
                objPopMap = New clsPopMap(strSourceField:=objItem.SubItems(0).Text.Trim, _
                                          strPopField:=objItem.SubItems(1).Text.Trim)
                Globals.gobjPopMaps.Add(objPopMap)
            End If
        Next

        'Process all questionnaires
        With mobjDataSet.Tables(0)
            For intRowCnt = 0 To .Rows.Count - 1
                'Update the status bar
                lblCurRec.Text = (intRowCnt + 1).ToString
                pbrMain.Value = intRowCnt + 1

                'Cause the screen to repaint
                Application.DoEvents()

                'Reset the mouse pointer as DoEvents sets it back to Default
                Cursor.Current = System.Windows.Forms.Cursors.WaitCursor

                'Check to see if the LithoCode field is blank
                If Not IsDBNull(.Rows(intRowCnt).Item(cboLithoCodeField.Text)) Then
                    'We have a record to process
                    'Determine the return date
                    If cboReturnDateField.SelectedIndex = 0 Then
                        datDateReturned = Date.Now.AddHours(-1)
                    Else
                        Try
                            datDateReturned = .Rows(intRowCnt).Item(cboReturnDateField.Text)
                        Catch
                            datDateReturned = Date.Now.AddHours(-1)
                        End Try
                    End If

                    'Create the questionnaire object
                    objQuestionnaire = New clsQuestionnaire(strLithoCode:=.Rows(intRowCnt).Item(cboLithoCodeField.Text), _
                                                            datDateReturned:=datDateReturned)

                    'Add the questions to the questionnaire
                    If objQuestionnaire.QuestionFormID > 0 Then
                        'Add all of the questions
                        For intColCnt = 0 To .Columns.Count - 1
                            'Determine the value to be used

                            objQuestionnaire.AddQuestion(strColumnName:=.Columns(intColCnt).ColumnName, _
                                                         objValue:=.Rows(intRowCnt).Item(intColCnt))
                        Next
                    End If

                    'Determine if we are going to take this respondant off of the call list
                    If cboTOCLField.SelectedIndex = 0 Then
                        bolTOCL = False
                    Else
                        Try
                            If strTOCLValues.IndexOf("," & CStr(.Rows(intRowCnt).Item(cboTOCLField.Text)).Trim & ",") > -1 Then
                                bolTOCL = True
                            Else
                                bolTOCL = False
                            End If
                        Catch
                            bolTOCL = False
                        End Try
                    End If

                    'Process this questionnaire
                    If objQuestionnaire.SentMailID < 0 Then
                        'The SentMail_id is invalid
                        objQuestionnaire.ErrorString = "frmMain.ProcessQuestionnaires - Error: No SentMailing Record Exists for this LithoCode"
                        OutputError(objQuestionnaire:=objQuestionnaire)
                        mintErrors += 1

                    ElseIf objQuestionnaire.QuestionFormID < 0 Then
                        'The QuestionForm_id is invalid
                        objQuestionnaire.ErrorString = "frmMain.ProcessQuestionnaires - Error: No QuestionForm Record Exists for this LithoCode"
                        OutputError(objQuestionnaire:=objQuestionnaire)
                        mintErrors += 1

                    ElseIf objQuestionnaire.StudyID < 0 Then
                        'The Study_id is invalid
                        objQuestionnaire.ErrorString = "frmMain.ProcessQuestionnaires - Error: No SamplePop Record Exists for this LithoCode"
                        OutputError(objQuestionnaire:=objQuestionnaire)
                        mintErrors += 1

                        'ElseIf objQuestionnaire.InvalidSampleUnitsExist Then    '** Modified 01-06-05 JJF
                    ElseIf objQuestionnaire.InvalidSampleUnitsExist(strErrMsg) Then
                        'At least one question has an invalid SampleUnit_id
                        '** Modified 01-06-05 JJF
                        'objQuestionnaire.ErrorString = "frmMain.ProcessQuestionnaires - Error: This LithoCode has missing or multiple SampleUnits for one or more questions"
                        objQuestionnaire.ErrorString = "frmMain.ProcessQuestionnaires - Error: " & strErrMsg
                        '** End of modification 01-06-05 JJF
                        OutputError(objQuestionnaire:=objQuestionnaire)
                        mintErrors += 1

                    ElseIf objQuestionnaire.OtherStepImported Then
                        'A previous mailing step has already been returned
                        mintIgnored += 1

                    ElseIf objQuestionnaire.AlreadyExists And Not chkOverwrite.Checked Then
                        'This litho has already been imported and the user selected not to overwrite
                        mintIgnored += 1

                    ElseIf objQuestionnaire.AlreadyExists And Not objQuestionnaire.ImportedSameDay Then
                        'This litho has already been imported and the user wants to overwrite it
                        '  but the import date is not today so we can't allow it.
                        mintIgnored += 1

                    Else
                        'If we are here then we need to process this litho
                        'Start the trasaction
                        Dim objTransaction As SqlTransaction
                        objTransaction = objConnection.BeginTransaction()

                        'Start the error trap
                        Try
                            'If this return already exists then reset the database so it can be reimported
                            If objQuestionnaire.AlreadyExists Then
                                objQuestionnaire.ResetForImport(objConnection:=objConnection, objTransaction:=objTransaction)
                            End If

                            'Insert these responses into the database
                            Dim objQuestion As clsQuestion
                            For Each objQuestion In objQuestionnaire.Questions
                                For intCnt = 0 To objQuestion.Values.Count - 1
                                    objQRInsertCommand.Transaction = objTransaction
                                    objQRInsertCommand.Parameters.Item("@intQuestionFormID").Value = objQuestionnaire.QuestionFormID
                                    objQRInsertCommand.Parameters.Item("@intSampleUnitID").Value = objQuestion.SampleUnitID
                                    objQRInsertCommand.Parameters.Item("@intQstnCore").Value = objQuestion.QstnCore
                                    objQRInsertCommand.Parameters.Item("@intResponseVal").Value = objQuestion.Values.Item(intCnt)
                                    objQRInsertCommand.ExecuteNonQuery()
                                Next
                            Next

                            'Update the QuestionForm table
                            objQFUpdateCommand.Transaction = objTransaction
                            objQFUpdateCommand.Parameters.Item("@intQuestionFormID").Value = objQuestionnaire.QuestionFormID
                            objQFUpdateCommand.Parameters.Item("@datDateReturned").Value = objQuestionnaire.DateReturned
                            objQFUpdateCommand.ExecuteNonQuery()

                            'Update the population table
                            Dim objPopValue As clsPopValue
                            For Each objPopValue In objQuestionnaire.PopValues
                                'Display the truncate dialog if required
                                Select Case objPopValue.DisplayTruncateDialog(strLithoCode:=objQuestionnaire.LithoCode)
                                    Case clsPopValue.enuTruncateDialogOptions.enuTDOStopProcessing
                                        'The user has selected to stop processing so clean things up and we are out of here
                                        objQuestionnaire.ErrorString = "frmMain.ProcessQuestionnaires - User canceled processing of this file at this LithoCode due to Hand Entry response that was to long for the target MetaField!"
                                        OutputError(objQuestionnaire:=objQuestionnaire)
                                        objConnection.Close()
                                        Exit Sub

                                    Case Else
                                        objPopUpdateCommand.Transaction = objTransaction
                                        objPopUpdateCommand.Parameters.Item("@intStudyID").Value = objQuestionnaire.StudyID
                                        objPopUpdateCommand.Parameters.Item("@intPopID").Value = objQuestionnaire.PopID
                                        objPopUpdateCommand.Parameters.Item("@intSamplePopID").Value = objQuestionnaire.SamplePopID
                                        objPopUpdateCommand.Parameters.Item("@intQuestionFormID").Value = objQuestionnaire.QuestionFormID
                                        objPopUpdateCommand.Parameters.Item("@strSetClause").Value = objPopValue.SetClause
                                        objPopUpdateCommand.Parameters.Item("@strFieldList").Value = objPopValue.PopField
                                        objPopUpdateCommand.Parameters.Item("@intProgram").Value = 3
                                        objPopUpdateCommand.ExecuteNonQuery()

                                End Select
                            Next

                            'Send any required Thank Yous
                            objSendThankYouCommand.Transaction = objTransaction
                            objSendThankYouCommand.Parameters.Item("@strLithoCode").Value = objQuestionnaire.LithoCode
                            objSendThankYouCommand.Parameters.Item("@intSamplePopID").Value = objQuestionnaire.SamplePopID
                            objSendThankYouCommand.ExecuteNonQuery()

                            'Determine if we are to add this respondant to the TOCL
                            If bolTOCL Then
                                objQuestionnaire.AddToTOCL(objConnection:=objConnection, objTransaction:=objTransaction)
                            End If

                            'If all was okey dokey then commit
                            objTransaction.Commit()

                            mintImported += 1
                            If objQuestionnaire.AlreadyExists Then mintReplaced += 1

                        Catch ex As Exception
                            'An error was encountered while updating the database
                            objQuestionnaire.ErrorString = "frmMain.ProcessQuestionnaires - Error: " & ex.Source & " - " & ex.Message
                            OutputError(objQuestionnaire:=objQuestionnaire)
                            mintErrors += 1

                            'Rollback the transaction
                            objTransaction.Rollback()

                        End Try

                    End If
                Else
                    'The lithocode field is null so ignore this record
                    mintIgnored += 1

                End If
            Next
        End With

        'Cleanup
        objConnection.Close()

    End Sub

    Private Sub OutputLog()

        Dim strLogFile As String
        Dim objFileInfo1 As FileInfo
        Dim objFileInfo2 As FileInfo
        Dim objFile As TextWriter

        'Get the file name
        strLogFile = Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData) & "\" & Format(Date.Now, "yyyy-MM-dd") & ".Log"

        'Create the file system objext
        objFileInfo1 = New FileInfo(strLogFile)
        objFileInfo2 = New FileInfo(txtDataFileName.Text.Trim)

        'Check to see if the log file exists
        If Not objFileInfo1.Exists Then
            'The file does not exist so create it and write out the header
            objFile = objFileInfo1.CreateText
            objFile.WriteLine("Import File                             Qty Records  Imported  Replaced   Ignored     Error      TOCL  Date/Time            ComputerName/UserName                             ")
            objFile.WriteLine("--------------------------------------  -----------  --------  --------  --------  --------  --------  -------------------  --------------------------------------------------")
            objFile.Flush()
            objFile.Close()
        End If

        'Open the file
        objFile = objFileInfo1.AppendText

        'Write the values for this batch
        objFile.WriteLine(objFileInfo2.Name.PadRight(40) & _
                          mobjDataSet.Tables(0).Rows.Count.ToString.PadLeft(11) & _
                          mintImported.ToString.PadLeft(10) & _
                          mintReplaced.ToString.PadLeft(10) & _
                          mintIgnored.ToString.PadLeft(10) & _
                          mintErrors.ToString.PadLeft(10) & _
                          mintTOCL.ToString.PadLeft(10) & "  " & _
                          Format(Date.Now, "MM/dd/yyyy hh:mm:ss").PadRight(21) & _
                          (Environment.MachineName & "/" & Environment.UserName).PadRight(50))

        'Close the output file and cleanup
        objFile.Flush()
        objFile.Close()

    End Sub

    Private Sub OutputError(ByRef objQuestionnaire As clsQuestionnaire)

        Dim objFileInfo As FileInfo
        Dim objFile As TextWriter

        'Get the file name
        If mstrErrorFileName.Length = 0 Then
            mstrErrorFileName = txtDataFileName.Text.Trim & ".Err"
        End If

        'Create the file system objext
        objFileInfo = New FileInfo(mstrErrorFileName)

        'Check to see if the log file exists
        If Not objFileInfo.Exists Then
            'The file does not exist so create it and write out the header
            objFile = objFileInfo.CreateText
            objFile.WriteLine("Litho Code   SentMail_id  QuestionForm_id  SamplePop_id  SampleSet_id      Study_id     Survey_id        Pop_id  BatchNumber  LineNumber  Error String")
            objFile.WriteLine("----------  ------------  ---------------  ------------  ------------  ------------  ------------  ------------  -----------  ----------  ------------")
            objFile.Flush()
            objFile.Close()
        End If

        'Open the file
        objFile = objFileInfo.AppendText

        'Write the values for this questionnaire
        With objQuestionnaire
            If Len(Trim(.ErrorString)) > 0 Then
                objFile.WriteLine(.LithoCode.PadRight(12) & _
                                  .SentMailID.ToString.PadLeft(12) & _
                                  .QuestionFormID.ToString.PadLeft(17) & _
                                  .SamplePopID.ToString.PadLeft(14) & _
                                  .SampleSetID.ToString.PadLeft(14) & _
                                  .StudyID.ToString.PadLeft(14) & _
                                  .SurveyID.ToString.PadLeft(14) & _
                                  .PopID.ToString.PadLeft(14) & "  " & _
                                  .ErrorString)
            End If
        End With

        'Close the output file and cleanup
        objFile.Flush()
        objFile.Close()

    End Sub
#End Region

End Class
