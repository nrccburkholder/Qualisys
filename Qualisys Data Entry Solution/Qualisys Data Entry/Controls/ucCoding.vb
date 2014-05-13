Imports NRC.Qualisys.QualisysDataEntry.Library
Public Class ucCoding
    Inherits System.Windows.Forms.UserControl
    Implements IWorkSection



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
    Friend WithEvents pnlBottom As Nrc.Framework.WinForms.SectionPanel
    Friend WithEvents btnAdvance As System.Windows.Forms.Button
    Friend WithEvents spnCodes As Nrc.Framework.WinForms.SectionPanel
    Friend WithEvents clbCodes As System.Windows.Forms.CheckedListBox
    Friend WithEvents shdCodesCode As SectionHeader
    Friend WithEvents cboSubHeaders As System.Windows.Forms.ComboBox
    Friend WithEvents lblCodesSubHeader As System.Windows.Forms.Label
    Friend WithEvents cboHeaders As System.Windows.Forms.ComboBox
    Friend WithEvents lblCodesHeader As System.Windows.Forms.Label
    Friend WithEvents spnType As Nrc.Framework.WinForms.SectionPanel
    Friend WithEvents btnFinish As System.Windows.Forms.Button
    Friend WithEvents spnValence As Nrc.Framework.WinForms.SectionPanel
    Friend WithEvents Splitter1 As System.Windows.Forms.Splitter
    Friend WithEvents spnCode As Nrc.Framework.WinForms.SectionPanel
    Friend WithEvents shdCode As SectionHeader
    Friend WithEvents lblQstnCount As System.Windows.Forms.Label
    Friend WithEvents lblCurQstn As System.Windows.Forms.Label
    Friend WithEvents lblCurQstnCaption As System.Windows.Forms.Label
    Friend WithEvents txtComment As System.Windows.Forms.TextBox
    Friend WithEvents imgBatchIcon As System.Windows.Forms.PictureBox
    Friend WithEvents lblBatchType As System.Windows.Forms.Label
    Friend WithEvents lblCodedBy As System.Windows.Forms.Label
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.pnlBottom = New Nrc.Framework.WinForms.SectionPanel
        Me.lblCodedBy = New System.Windows.Forms.Label
        Me.imgBatchIcon = New System.Windows.Forms.PictureBox
        Me.lblBatchType = New System.Windows.Forms.Label
        Me.btnAdvance = New System.Windows.Forms.Button
        Me.spnCodes = New Nrc.Framework.WinForms.SectionPanel
        Me.clbCodes = New System.Windows.Forms.CheckedListBox
        Me.shdCodesCode = New SectionHeader
        Me.cboSubHeaders = New System.Windows.Forms.ComboBox
        Me.lblCodesSubHeader = New System.Windows.Forms.Label
        Me.cboHeaders = New System.Windows.Forms.ComboBox
        Me.lblCodesHeader = New System.Windows.Forms.Label
        Me.spnType = New Nrc.Framework.WinForms.SectionPanel
        Me.btnFinish = New System.Windows.Forms.Button
        Me.spnValence = New Nrc.Framework.WinForms.SectionPanel
        Me.Splitter1 = New System.Windows.Forms.Splitter
        Me.spnCode = New Nrc.Framework.WinForms.SectionPanel
        Me.txtComment = New System.Windows.Forms.TextBox
        Me.shdCode = New SectionHeader
        Me.lblQstnCount = New System.Windows.Forms.Label
        Me.lblCurQstn = New System.Windows.Forms.Label
        Me.lblCurQstnCaption = New System.Windows.Forms.Label
        Me.pnlBottom.SuspendLayout()
        Me.spnCodes.SuspendLayout()
        Me.shdCodesCode.SuspendLayout()
        Me.spnCode.SuspendLayout()
        Me.shdCode.SuspendLayout()
        Me.SuspendLayout()
        '
        'pnlBottom
        '
        Me.pnlBottom.BackColor = System.Drawing.SystemColors.Control
        Me.pnlBottom.BorderColor = System.Drawing.Color.FromArgb(CType(0, Byte), CType(45, Byte), CType(150, Byte))
        Me.pnlBottom.Caption = ""
        Me.pnlBottom.Controls.Add(Me.lblCodedBy)
        Me.pnlBottom.Controls.Add(Me.imgBatchIcon)
        Me.pnlBottom.Controls.Add(Me.lblBatchType)
        Me.pnlBottom.Controls.Add(Me.btnAdvance)
        Me.pnlBottom.Controls.Add(Me.spnCodes)
        Me.pnlBottom.Controls.Add(Me.spnType)
        Me.pnlBottom.Controls.Add(Me.btnFinish)
        Me.pnlBottom.Controls.Add(Me.spnValence)
        Me.pnlBottom.Dock = System.Windows.Forms.DockStyle.Bottom
        Me.pnlBottom.DockPadding.All = 1
        Me.pnlBottom.Location = New System.Drawing.Point(0, 248)
        Me.pnlBottom.Name = "pnlBottom"
        Me.pnlBottom.ShowCaption = False
        Me.pnlBottom.Size = New System.Drawing.Size(720, 304)
        Me.pnlBottom.TabIndex = 17
        '
        'lblCodedBy
        '
        Me.lblCodedBy.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
        Me.lblCodedBy.Location = New System.Drawing.Point(216, 264)
        Me.lblCodedBy.Name = "lblCodedBy"
        Me.lblCodedBy.Size = New System.Drawing.Size(344, 23)
        Me.lblCodedBy.TabIndex = 16
        Me.lblCodedBy.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'imgBatchIcon
        '
        Me.imgBatchIcon.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.imgBatchIcon.Location = New System.Drawing.Point(576, 264)
        Me.imgBatchIcon.Name = "imgBatchIcon"
        Me.imgBatchIcon.Size = New System.Drawing.Size(24, 24)
        Me.imgBatchIcon.SizeMode = System.Windows.Forms.PictureBoxSizeMode.StretchImage
        Me.imgBatchIcon.TabIndex = 15
        Me.imgBatchIcon.TabStop = False
        Me.imgBatchIcon.Visible = False
        '
        'lblBatchType
        '
        Me.lblBatchType.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.lblBatchType.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lblBatchType.Location = New System.Drawing.Point(608, 264)
        Me.lblBatchType.Name = "lblBatchType"
        Me.lblBatchType.Size = New System.Drawing.Size(104, 23)
        Me.lblBatchType.TabIndex = 14
        Me.lblBatchType.Text = "Imported from file"
        Me.lblBatchType.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        Me.lblBatchType.Visible = False
        '
        'btnAdvance
        '
        Me.btnAdvance.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
        Me.btnAdvance.Location = New System.Drawing.Point(8, 264)
        Me.btnAdvance.Name = "btnAdvance"
        Me.btnAdvance.Size = New System.Drawing.Size(88, 24)
        Me.btnAdvance.TabIndex = 10
        Me.btnAdvance.Text = "Advance (F10)"
        '
        'spnCodes
        '
        Me.spnCodes.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.spnCodes.BorderColor = System.Drawing.Color.FromArgb(CType(0, Byte), CType(45, Byte), CType(150, Byte))
        Me.spnCodes.Caption = "Codes"
        Me.spnCodes.Controls.Add(Me.clbCodes)
        Me.spnCodes.Controls.Add(Me.shdCodesCode)
        Me.spnCodes.DockPadding.All = 1
        Me.spnCodes.Location = New System.Drawing.Point(128, 16)
        Me.spnCodes.Name = "spnCodes"
        Me.spnCodes.ShowCaption = True
        Me.spnCodes.Size = New System.Drawing.Size(584, 232)
        Me.spnCodes.TabIndex = 13
        '
        'clbCodes
        '
        Me.clbCodes.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.clbCodes.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle
        Me.clbCodes.CheckOnClick = True
        Me.clbCodes.ColumnWidth = 400
        Me.clbCodes.IntegralHeight = False
        Me.clbCodes.Location = New System.Drawing.Point(8, 64)
        Me.clbCodes.MultiColumn = True
        Me.clbCodes.Name = "clbCodes"
        Me.clbCodes.Size = New System.Drawing.Size(568, 160)
        Me.clbCodes.TabIndex = 2
        '
        'shdCodesCode
        '
        Me.shdCodesCode.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.shdCodesCode.Controls.Add(Me.cboSubHeaders)
        Me.shdCodesCode.Controls.Add(Me.lblCodesSubHeader)
        Me.shdCodesCode.Controls.Add(Me.cboHeaders)
        Me.shdCodesCode.Controls.Add(Me.lblCodesHeader)
        Me.shdCodesCode.Location = New System.Drawing.Point(1, 27)
        Me.shdCodesCode.Name = "shdCodesCode"
        Me.shdCodesCode.Size = New System.Drawing.Size(582, 28)
        Me.shdCodesCode.TabIndex = 1
        '
        'cboSubHeaders
        '
        Me.cboSubHeaders.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.cboSubHeaders.Location = New System.Drawing.Point(356, 4)
        Me.cboSubHeaders.Name = "cboSubHeaders"
        Me.cboSubHeaders.Size = New System.Drawing.Size(216, 21)
        Me.cboSubHeaders.TabIndex = 4
        '
        'lblCodesSubHeader
        '
        Me.lblCodesSubHeader.BackColor = System.Drawing.Color.Transparent
        Me.lblCodesSubHeader.Location = New System.Drawing.Point(288, 8)
        Me.lblCodesSubHeader.Name = "lblCodesSubHeader"
        Me.lblCodesSubHeader.Size = New System.Drawing.Size(72, 16)
        Me.lblCodesSubHeader.TabIndex = 3
        Me.lblCodesSubHeader.Text = "SubHeader:"
        '
        'cboHeaders
        '
        Me.cboHeaders.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.cboHeaders.Location = New System.Drawing.Point(64, 4)
        Me.cboHeaders.Name = "cboHeaders"
        Me.cboHeaders.Size = New System.Drawing.Size(212, 21)
        Me.cboHeaders.TabIndex = 2
        '
        'lblCodesHeader
        '
        Me.lblCodesHeader.BackColor = System.Drawing.Color.Transparent
        Me.lblCodesHeader.Location = New System.Drawing.Point(12, 8)
        Me.lblCodesHeader.Name = "lblCodesHeader"
        Me.lblCodesHeader.Size = New System.Drawing.Size(52, 16)
        Me.lblCodesHeader.TabIndex = 1
        Me.lblCodesHeader.Text = "Header:"
        '
        'spnType
        '
        Me.spnType.BorderColor = System.Drawing.Color.FromArgb(CType(0, Byte), CType(45, Byte), CType(150, Byte))
        Me.spnType.Caption = "Type"
        Me.spnType.DockPadding.All = 1
        Me.spnType.Location = New System.Drawing.Point(8, 16)
        Me.spnType.Name = "spnType"
        Me.spnType.ShowCaption = True
        Me.spnType.Size = New System.Drawing.Size(112, 100)
        Me.spnType.TabIndex = 11
        '
        'btnFinish
        '
        Me.btnFinish.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
        Me.btnFinish.Enabled = False
        Me.btnFinish.Location = New System.Drawing.Point(120, 264)
        Me.btnFinish.Name = "btnFinish"
        Me.btnFinish.Size = New System.Drawing.Size(88, 24)
        Me.btnFinish.TabIndex = 5
        Me.btnFinish.Text = "Finish (F22)"
        '
        'spnValence
        '
        Me.spnValence.BorderColor = System.Drawing.Color.FromArgb(CType(0, Byte), CType(45, Byte), CType(150, Byte))
        Me.spnValence.Caption = "Valence"
        Me.spnValence.DockPadding.All = 1
        Me.spnValence.Location = New System.Drawing.Point(8, 128)
        Me.spnValence.Name = "spnValence"
        Me.spnValence.ShowCaption = True
        Me.spnValence.Size = New System.Drawing.Size(112, 120)
        Me.spnValence.TabIndex = 12
        '
        'Splitter1
        '
        Me.Splitter1.BackColor = System.Drawing.SystemColors.Control
        Me.Splitter1.Dock = System.Windows.Forms.DockStyle.Bottom
        Me.Splitter1.Location = New System.Drawing.Point(0, 240)
        Me.Splitter1.Name = "Splitter1"
        Me.Splitter1.Size = New System.Drawing.Size(720, 8)
        Me.Splitter1.TabIndex = 18
        Me.Splitter1.TabStop = False
        '
        'spnCode
        '
        Me.spnCode.BackColor = System.Drawing.SystemColors.Control
        Me.spnCode.BorderColor = System.Drawing.Color.FromArgb(CType(0, Byte), CType(45, Byte), CType(150, Byte))
        Me.spnCode.Caption = "Coding - 1441C01 - 12345678"
        Me.spnCode.Controls.Add(Me.txtComment)
        Me.spnCode.Controls.Add(Me.shdCode)
        Me.spnCode.Dock = System.Windows.Forms.DockStyle.Fill
        Me.spnCode.DockPadding.All = 1
        Me.spnCode.Location = New System.Drawing.Point(0, 0)
        Me.spnCode.Name = "spnCode"
        Me.spnCode.ShowCaption = True
        Me.spnCode.Size = New System.Drawing.Size(720, 240)
        Me.spnCode.TabIndex = 19
        '
        'txtComment
        '
        Me.txtComment.BorderStyle = System.Windows.Forms.BorderStyle.None
        Me.txtComment.Dock = System.Windows.Forms.DockStyle.Fill
        Me.txtComment.Location = New System.Drawing.Point(1, 72)
        Me.txtComment.MaxLength = 12000
        Me.txtComment.Multiline = True
        Me.txtComment.Name = "txtComment"
        Me.txtComment.ReadOnly = True
        Me.txtComment.ScrollBars = System.Windows.Forms.ScrollBars.Both
        Me.txtComment.Size = New System.Drawing.Size(718, 167)
        Me.txtComment.TabIndex = 11
        Me.txtComment.Text = ""
        '
        'shdCode
        '
        Me.shdCode.Controls.Add(Me.lblQstnCount)
        Me.shdCode.Controls.Add(Me.lblCurQstn)
        Me.shdCode.Controls.Add(Me.lblCurQstnCaption)
        Me.shdCode.Dock = System.Windows.Forms.DockStyle.Top
        Me.shdCode.Location = New System.Drawing.Point(1, 27)
        Me.shdCode.Name = "shdCode"
        Me.shdCode.Size = New System.Drawing.Size(718, 45)
        Me.shdCode.TabIndex = 8
        '
        'lblQstnCount
        '
        Me.lblQstnCount.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.lblQstnCount.Location = New System.Drawing.Point(648, 8)
        Me.lblQstnCount.Name = "lblQstnCount"
        Me.lblQstnCount.Size = New System.Drawing.Size(52, 16)
        Me.lblQstnCount.TabIndex = 4
        Me.lblQstnCount.Text = "1 of 3"
        Me.lblQstnCount.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
        '
        'lblCurQstn
        '
        Me.lblCurQstn.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.lblCurQstn.Location = New System.Drawing.Point(112, 8)
        Me.lblCurQstn.Name = "lblCurQstn"
        Me.lblCurQstn.Size = New System.Drawing.Size(528, 32)
        Me.lblCurQstn.TabIndex = 1
        Me.lblCurQstn.Text = "What would you change about your stay?"
        '
        'lblCurQstnCaption
        '
        Me.lblCurQstnCaption.BackColor = System.Drawing.Color.Transparent
        Me.lblCurQstnCaption.Location = New System.Drawing.Point(12, 8)
        Me.lblCurQstnCaption.Name = "lblCurQstnCaption"
        Me.lblCurQstnCaption.Size = New System.Drawing.Size(96, 16)
        Me.lblCurQstnCaption.TabIndex = 0
        Me.lblCurQstnCaption.Text = "Current Question:"
        '
        'ucCoding
        '
        Me.Controls.Add(Me.spnCode)
        Me.Controls.Add(Me.Splitter1)
        Me.Controls.Add(Me.pnlBottom)
        Me.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Name = "ucCoding"
        Me.Size = New System.Drawing.Size(720, 552)
        Me.pnlBottom.ResumeLayout(False)
        Me.spnCodes.ResumeLayout(False)
        Me.shdCodesCode.ResumeLayout(False)
        Me.spnCode.ResumeLayout(False)
        Me.shdCode.ResumeLayout(False)
        Me.ResumeLayout(False)

    End Sub

#End Region

#Region " Private Members "
    Private mIsWorking As Boolean = False
    Private mIsVerification As Boolean = False
    Private mCurrentBatchID As Integer
    Private mCurrentTemplate As String
    Private mCurrentForm As QDEForm
    Private mPrevForm As QDEForm
    Private mReturnForm As QDEForm
    Private mCommentIndex As Integer = 0
    Private mComment As Comment
    Private mHeadersList As NRCLists.QSOpenEndList
    Private mHeaders As NRCLists.Headers

    Private mInitialized As Boolean = False
    Private mTypeButtons As RadioButton()
    Private mValenceButtons As RadioButton()

    Private mIsBackedUp As Boolean = False
#End Region

#Region " Public Properties "
    Public ReadOnly Property IsWorking() As Boolean Implements IWorkSection.IsWorking
        Get
            Return mIsWorking
        End Get
    End Property
#End Region

#Region " Private Properties "
    ''' <summary>Determines the ID of the selected Comment Type Radio Button</summary>
    Private Property SelectedType() As Integer
        Get
            Dim btn As RadioButton
            'Check each radio button, if it is checked then return it's ID
            For Each btn In mTypeButtons
                If btn.Checked Then
                    Return DirectCast(btn.Tag, Integer)
                End If
            Next

            Return -1
        End Get
        Set(ByVal Value As Integer)
            Dim btn As RadioButton
            'Check each radio button, if it's ID matches the value then check it
            For Each btn In mTypeButtons
                If DirectCast(btn.Tag, Integer) = Value Then
                    btn.Checked = True
                Else
                    btn.Checked = False
                End If
            Next
        End Set
    End Property

    ''' <summary>Determines the ID of the selected Comment Valence Radio Button</summary>
    Private Property SelectedValence() As Integer
        Get
            Dim btn As RadioButton
            'Check each radio button, if it is checked then return it's ID
            For Each btn In mValenceButtons
                If btn.Checked Then
                    Return DirectCast(btn.Tag, Integer)
                End If
            Next

            Return -1
        End Get
        Set(ByVal Value As Integer)
            Dim btn As RadioButton
            'Check each radio button, if it's ID matches the value then check it
            For Each btn In mValenceButtons
                If DirectCast(btn.Tag, Integer) = Value Then
                    btn.Checked = True
                Else
                    btn.Checked = False
                End If
            Next
        End Set
    End Property
#End Region

#Region " Exposed Events "
    Public Event WorkBegining(ByVal sender As Object, ByVal e As WorkBeginingEventArgs) Implements IWorkSection.WorkBegining
    Public Event WorkEnding(ByVal sender As Object, ByVal e As WorkEndingEventArgs) Implements IWorkSection.WorkEnding
#End Region

#Region " Control Event Handlers "

    'Control LOAD event
    Private Sub ucCoding_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles MyBase.Load
        'Initialize and disable the controls
        If Not mInitialized Then
            mInitialized = True
            mHeadersList = New NRCLists.QSOpenEndListClass
            PopulateCommentTypes()
            PopulateCommentValences()
            InitializeControls(False)
            clbCodes.DataBindings.Add("Font", Settings, "CodeFont")

            'Bind button labels to user settings so the proper shortcut key is displayed
            btnAdvance.DataBindings.Add("Text", Settings, "AdvanceLabel")
            btnFinish.DataBindings.Add("Text", Settings, "FinishLabel")

            AddKeyEventHandler(Me)
        End If
    End Sub

    'Advance button CLICK
    Private Sub btnAdvance_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnAdvance.Click
        Dim msg As String = ""
        If Not ValidateUserInput(msg) Then
            MessageBox.Show(msg, "Coding Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            Exit Sub
        End If
        UpdateCodes()

        'Verify the comment
        If VerifyCodes() Then
            'If this is NOT the last one in the list then load the next comment
            If mCommentIndex + 1 < mCurrentForm.Comments.Count Then
                LoadNextComment()
            Else
                'Last one on the form so finish the form and move on to the next one
                FinishForm()
                LoadNextForm()
            End If
        End If
    End Sub

    'Finish button CLICK
    Private Sub btnFinish_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnFinish.Click
        'Exit
        Me.EndWork()

        'TEAM WANTS FINISH TO EXIT W/O SAVING

        'Dim msg As String
        'If Not ValidateUserInput(msg) Then
        '    MessageBox.Show(msg, "Coding Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        '    Exit Sub
        'End If

        'UpdateCodes()

        ''Verify the comment
        'If VerifyCodes() Then
        '    'Finish the form then end our work session
        '    FinishForm()
        '    mIsWorking = False
        '    EndWork()
        'End If
    End Sub

    'KEY DOWN for all controls - If user presses F10 or F11 we need to advance/finish
    Private Sub KeyDownHandler(ByVal sender As Object, ByVal e As KeyEventArgs)
        If e.KeyData = Settings.AdvanceKey Then
            Me.btnAdvance.PerformClick()
            e.Handled = True
        ElseIf e.KeyData = Settings.FinishKey Then
            Me.btnFinish.PerformClick()
            e.Handled = True
        ElseIf e.KeyData = Settings.BackUpKey Then
            BackUpCommand()
            e.Handled = True
        ElseIf e.KeyData = Settings.ResetKey Then
            ResetCommand()
            e.Handled = True
        End If

    End Sub

    'Headers list SELECTION CHANGE COMMITTED - Repopulates the subheader list
    Private Sub cboHeaders_SelectionChangeCommitted(ByVal sender As System.Object, ByVal e As System.EventArgs)
        PopulateSubHeaders()
    End Sub

    'SubHeaders list SELECTION CHANGE COMMITTED - Repopulates the code list
    Private Sub cboSubHeaders_SelectionChangeCommitted(ByVal sender As System.Object, ByVal e As System.EventArgs)
        PopulateCodeList()
    End Sub

#End Region

#Region " Public Methods "

    'Begins work for a given template
    Public Sub BeginWork(ByVal batchID As Integer, ByVal templateName As String, ByVal isVerification As Boolean) Implements IWorkSection.BeginWork
        'If we are already working on another template then first end work on that one
        If mIsWorking Then
            EndWork()
        End If

        'Initialize the controls and enable them
        InitializeControls(True)

        'Initialize the code list for this template
        mHeadersList.Initialize(templateName)

        'Populate the SectionPanel caption
        spnCode.Caption = "Comment Coding - " & templateName

        'Flag that work is in progress
        mIsWorking = True

        'Store the template name and verification mode
        mCurrentBatchID = batchID
        mCurrentTemplate = templateName
        mIsVerification = isVerification

        'Set the batch type label and icon
        Dim b As Batch = Batch.LoadFromDB(batchID)
        Select Case b.BatchType
            Case Batch.BatchOriginType.LoadedFromFile
                lblBatchType.Text = "Imported From File"
                imgBatchIcon.Visible = False
            Case Batch.BatchOriginType.ManuallyAdded
                lblBatchType.Text = "Added Manually"
                imgBatchIcon.Visible = True
        End Select

        'Load the next form for this template
        LoadNextForm()

        'Notify listeners that work is begining
        RaiseEvent WorkBegining(Me, New WorkBeginingEventArgs)

        txtComment.Focus()
        txtComment.SelectionLength = 0
    End Sub

    'Ends a work session for the current template
    Public Function EndWork() As Boolean Implements IWorkSection.EndWork
        'If work is already in progress then we need to show a message to the user telling them
        'that the current form will not be saved.
        If mIsWorking Then
            If MessageBox.Show("The current form has not been saved.  Are you sure you want to continue?", "Unsaved Work Warning", MessageBoxButtons.YesNo, MessageBoxIcon.Warning, MessageBoxDefaultButton.Button2) = DialogResult.No Then
                Return False
            End If
            mIsWorking = False
            If Not mCurrentForm Is Nothing Then mCurrentForm.UnlockForm()
        End If

        'Initialize and disable the controls
        InitializeControls(False)

        'Notify listeners that work is ending
        RaiseEvent WorkEnding(Me, New WorkEndingEventArgs)

        mIsBackedUp = False
        mComment = Nothing
        mCurrentForm = Nothing
        mPrevForm = Nothing
        mReturnForm = Nothing

        Return True
    End Function

#End Region

#Region " Private Methods "
    'Initializes the controls and enables/disables them
    Private Sub InitializeControls(ByVal enable As Boolean)
        'Initialize batch icon
        If enable AndAlso imgBatchIcon.Image Is Nothing Then
            imgBatchIcon.Image = System.Drawing.Bitmap.FromHicon(SystemIcons.Warning.Handle)
        End If

        lblBatchType.Visible = enable
        imgBatchIcon.Visible = enable

        'Clear Type/Valence Radio Buttons
        SelectedType = -1
        SelectedValence = -1

        'Clear code list
        clbCodes.DataSource = Nothing
        clbCodes.Items.Clear()

        'Clear Headers/Subheaders
        cboHeaders.Items.Clear()
        cboSubHeaders.Items.Clear()

        'Clear caption
        spnCode.Caption = ""
        lblQstnCount.Text = "0 of 0"
        lblCodedBy.Text = ""

        'Clear Current Question
        lblCurQstn.DataBindings.Clear()
        lblCurQstn.Text = ""

        'Clear Comment text
        txtComment.DataBindings.Clear()
        txtComment.Text = ""

        'Enable/Disable all children
        Dim ctrl As Control
        For Each ctrl In Me.Controls
            ctrl.Enabled = enable
        Next
    End Sub

    'Loads the next form that needs work done into this control
    Private Sub LoadNextForm()
        'Store this form as the previous form
        mPrevForm = mCurrentForm

        'If we are in "Backed Up" mode then return to the current form
        If mIsBackedUp Then
            mCurrentForm = mReturnForm
            mReturnForm = Nothing
            mIsBackedUp = False
        Else
            'If we are in verification mode then get the next form to be code verified
            If mIsVerification Then
                mCurrentForm = QDEForm.GetNextForm(mCurrentBatchID, mCurrentTemplate, QDEForm.WorkStage.ToBeCodeVerified, CurrentUser.LoginName)
            Else    'Otherwise get the next form to be coded
                mCurrentForm = QDEForm.GetNextForm(mCurrentBatchID, mCurrentTemplate, QDEForm.WorkStage.ToBeCoded, CurrentUser.LoginName)
            End If

            'If the QuestionForm object came back NULL then there is no work to do
            If mCurrentForm Is Nothing Then
                'End work and exit
                mIsWorking = False
                EndWork()
                Exit Sub
            End If
        End If

        'Add the litho to the caption
        spnCode.Caption = String.Format("Comment Coding - {0} - {1}", mCurrentTemplate, mCurrentForm.LithoCode)

        'Reinitialize the comment index and load the first one
        mCommentIndex = -1
        LoadNextComment()
    End Sub

    'Loads the next comment on the form into this control
    Private Sub LoadNextComment()
        'Increment the current comment index
        mCommentIndex += 1
        'store the current comment object
        mComment = mCurrentForm.Comments(mCommentIndex)

        'Mark this comment as having been keyed / key verified
        If mIsVerification Then
            mComment.DateCodeVerified = DateTime.Now
            mComment.CodeVerifiedBy = CurrentUser.LoginName

            lblCodedBy.Text = String.Format("Coded by {0} on {1}.", mComment.CodedBy, mComment.DateCoded.ToString)
        Else
            mComment.DateCoded = DateTime.Now
            mComment.CodedBy = CurrentUser.LoginName

            lblCodedBy.Text = ""
        End If

        'Load the headers for this comment question
        PopulateCodeHeaders(mComment.QstnCore)
        PopulateSubHeaders()
        PopulateCodeList()

        'Set the Type and Valence radio buttons
        SelectedType = mComment.CommentTypeID
        SelectedValence = mComment.CommentValenceID

        'Populate the question count '3 of 6' label
        lblQstnCount.Text = mCommentIndex + 1 & " of " & mCurrentForm.Comments.Count

        'Bind the Question Text label to the comment object
        lblCurQstn.DataBindings.Clear()
        lblCurQstn.DataBindings.Add("Text", mComment, "QuestionText")

        'Bind the Comment Text textbox to the comment object
        txtComment.DataBindings.Clear()
        txtComment.DataBindings.Add("Text", mComment, "CommentText")
        txtComment.DataBindings.Add("Font", Settings, "CommentFont")

        'If this is the last comment on the form the enable the 'Finish' button
        btnFinish.Enabled = Not (mCommentIndex + 1 < mCurrentForm.Comments.Count)
    End Sub

    'Verifies that the comment codes match the first version
    'If not a warning message is displayed
    Private Function VerifyCodes() As Boolean
        Dim message As String

        'If we are not in verification mode then always return True
        If Not mIsVerification Then
            Return True
        End If

        'If the comment codes are different from the originally stored one the show message
        If mComment.HasCommentChanged Then
            Dim bmp As Bitmap = ScreenScraper.CaptureControl(Me)
            message = String.Format("This comment was originally coded differently by {0} at {1}.  Do you want to Continue?", mComment.CodedBy, mComment.DateCoded.ToString)

            Dim frmVerify As New frmCommentChanged("Verification Warning", message, bmp)

            'Return True if the user says "Yes" otherwise return False
            If frmVerify.ShowDialog = DialogResult.Yes Then
                bmp.Dispose()
                Return True
            Else
                bmp.Dispose()
                Return False
            End If
        Else  'Return True
            Return True
        End If
    End Function

    'Finishes work for this form by saving the data and unlocking the record
    Private Sub FinishForm()
        mCurrentForm.UpdateCommentRecords()
        mCurrentForm.UnlockForm()
    End Sub

    'Stores all the data from the form back into the Comment Object
    Private Sub UpdateCodes()
        Dim cd As Code

        'Clear all previous codes
        mComment.Codes.Clear()
        'Add in each code that has been checked
        For Each cd In clbCodes.CheckedItems
            mComment.Codes.Add(cd.Id, cd.Id)
        Next

        'Set the type and valence
        mComment.CommentTypeID = SelectedType
        mComment.CommentValenceID = SelectedValence
    End Sub

    'Adds a radio button for each comment type in the DB
    Private Sub PopulateCommentTypes()
        Dim row As DataRow
        Dim y As Integer = 30
        Dim button As RadioButton
        Dim buttons(Comment.CommentTypes.Rows.Count - 1) As RadioButton
        Dim i As Integer = 0

        For Each row In Comment.CommentTypes.Rows
            button = New RadioButton
            button.Text = row("strCmntType_nm").ToString
            button.Tag = row("CmntType_id")
            button.FlatStyle = FlatStyle.System
            button.Top = y
            button.Left = 6

            buttons(i) = button
            Me.spnType.Controls.Add(button)
            y += button.Height - 5
            i += 1
        Next

        mTypeButtons = buttons
    End Sub

    'Adds a radio button for each comment valence in the DB
    Private Sub PopulateCommentValences()
        Dim row As DataRow
        Dim y As Integer = 30
        Dim button As RadioButton
        Dim buttons(Comment.CommentValences.Rows.Count - 1) As RadioButton
        Dim i As Integer = 0

        For Each row In Comment.CommentValences.Rows
            button = New RadioButton
            button.Text = row("strCmntValence_nm").ToString
            button.Tag = row("CmntValence_id")
            button.FlatStyle = FlatStyle.System
            button.Top = y
            button.Left = 6

            buttons(i) = button
            Me.spnValence.Controls.Add(button)
            y += button.Height - 5
            i += 1
        Next

        mValenceButtons = buttons
    End Sub

    'Fills the Combobox of Code Headers with the values for this comment
    Private Sub PopulateCodeHeaders(ByVal qstnCore As Integer)
        Dim i As Integer
        Dim head As Header

        cboHeaders.Items.Clear()

        'Load the list of headers for this form
        mHeaders = mHeadersList.GetList(CShort(mComment.QstnCore))

        cboHeaders.DisplayMember = "Name"
        cboHeaders.ValueMember = "Id"

        For i = 1 To mHeaders.Count
            head = New Header(mHeaders(i))

            cboHeaders.Items.Add(head)
        Next

        cboHeaders.SelectedIndex = 0
    End Sub

    'Fills the Combobox of Code SubHeaders with the values for this header
    Private Sub PopulateSubHeaders()
        Dim head As Header = DirectCast(cboHeaders.SelectedItem, Header)
        Dim subHead As SubHeader
        Dim i As Integer

        cboSubHeaders.Items.Clear()

        cboSubHeaders.DisplayMember = "Name"
        cboSubHeaders.ValueMember = "Id"

        For i = 1 To head.SubHeaders.Count
            subHead = New SubHeader(head.SubHeaders(i))

            cboSubHeaders.Items.Add(subHead)
        Next

        cboSubHeaders.SelectedIndex = 0
    End Sub

    'Fills the CheckedListBox of Codes with the values for this subheader
    Private Sub PopulateCodeList()
        Dim subHead As SubHeader = DirectCast(cboSubHeaders.SelectedItem, SubHeader)
        Dim cd As Code
        Dim i As Integer
        Dim isChecked As Boolean = False
        Dim id As Integer

        Me.clbCodes.Items.Clear()

        clbCodes.DisplayMember = "Name"
        clbCodes.ValueMember = "Id"

        Dim maxWidth As Integer = Integer.MinValue
        Dim width As Integer = 0

        For i = 1 To subHead.Codes.Count
            cd = New Code(subHead.Codes(i))

            id = CInt(subHead.Codes(i).CodeID)
            isChecked = mComment.Codes.Contains(id)
            clbCodes.Items.Add(cd, isChecked)

            'Find the max width of all columns
            width = CInt(clbCodes.CreateGraphics().MeasureString(subHead.Codes(i).CodeName, Settings.CodeFont).Width)
            If width > maxWidth Then maxWidth = width
        Next
        'Add 20 for the check box
        maxWidth += 20
        'Make the column width = to the max width
        clbCodes.ColumnWidth = maxWidth
    End Sub

    'Adds an event handler for the KeyDown event for all children of a control
    Private Sub AddKeyEventHandler(ByVal ctrl As Control)
        Dim child As Control
        AddHandler ctrl.KeyDown, New KeyEventHandler(AddressOf KeyDownHandler)

        For Each child In ctrl.Controls
            AddKeyEventHandler(child)
        Next
    End Sub

    Private Function ValidateUserInput(ByRef errorMessage As String) As Boolean
        If SelectedType = -1 Then
            errorMessage = "You must select a comment type."
            Return False
        End If

        If SelectedValence = -1 Then
            errorMessage = "You must select a comment valence"
            Return False
        End If

        If Me.clbCodes.CheckedItems.Count < 1 Then
            errorMessage = "You must select at least one code."
            Return False
        End If

        Return True
    End Function

    Private Sub BackUpCommand()
        'If there are previous comments on this form then just back up
        If mCommentIndex > 0 Then
            'Store current info
            UpdateCodes()

            'Reverse comment index
            mCommentIndex -= 2
            LoadNextComment()       'Load next will now actually load previous
        Else
            'If they have not already backed up a form and there is a form to back up to
            If Not mIsBackedUp AndAlso Not mPrevForm Is Nothing Then
                'Store current info
                UpdateCodes()

                'Set the isBackedUp flag so we don't back up more
                mIsBackedUp = True

                'Set the return form to be the current form
                mReturnForm = mCurrentForm
                'Now set current form to be the previous form
                mCurrentForm = mPrevForm

                'Add the litho to the caption
                spnCode.Caption = String.Format("Comment Coding - {0} - {1}", mCurrentTemplate, mCurrentForm.LithoCode)

                'Set the comment count to be the last one on the previous form
                mCommentIndex = mCurrentForm.Comments.Count - 2
                LoadNextComment()
            End If
        End If
    End Sub

    Private Sub ResetCommand()
        mComment.ResetData()
        mCommentIndex -= 1
        LoadNextComment()
    End Sub

#Region " Code List Structures "
    Private Structure Header
        Public Id As Integer
        Public Name As String
        Public SubHeaders As NRCLists.SubHeaders

        Sub New(ByVal header As NRCLists.Header)
            Id = CInt(header.HeaderID)
            Name = header.HeaderName
            SubHeaders = header.SubHeaders
        End Sub

        Public Overrides Function ToString() As String
            Return Name
        End Function
    End Structure

    Private Structure SubHeader
        Public Id As Integer
        Public Name As String
        Public Codes As NRCLists.Codes

        Sub New(ByVal subHead As NRCLists.SubHeader)
            Id = CInt(subHead.SubHeaderID)
            Name = subHead.SubHeaderName
            Codes = subHead.Codes
        End Sub

        Public Overrides Function ToString() As String
            Return Name
        End Function
    End Structure

    Private Structure Code
        Public Id As Integer
        Public Name As String

        Sub New(ByVal code As NRCLists.Code)
            Id = CInt(code.CodeID)
            Name = code.CodeName
        End Sub

        Public Overrides Function ToString() As String
            Return Name
        End Function
    End Structure
#End Region

#End Region

End Class
