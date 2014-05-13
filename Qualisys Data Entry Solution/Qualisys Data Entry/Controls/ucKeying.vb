Imports Nrc.Qualisys.QualisysDataEntry.Library

Public Class ucKeying
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
    Friend WithEvents spnKey As Nrc.Framework.WinForms.SectionPanel
    Friend WithEvents txtKey As System.Windows.Forms.TextBox
    Friend WithEvents shdKey As SectionHeader
    Friend WithEvents btnAdvance As System.Windows.Forms.Button
    Friend WithEvents lblCurQstn As System.Windows.Forms.Label
    Friend WithEvents lblQstnCount As System.Windows.Forms.Label
    Friend WithEvents lblCurQstnCaption As System.Windows.Forms.Label
    Friend WithEvents btnFinish As System.Windows.Forms.Button
    Friend WithEvents ToolTip As System.Windows.Forms.ToolTip
    Friend WithEvents lblBatchType As System.Windows.Forms.Label
    Friend WithEvents imgBatchIcon As System.Windows.Forms.PictureBox
    Friend WithEvents lblKeyedBy As System.Windows.Forms.Label
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.components = New System.ComponentModel.Container
        Me.spnKey = New Nrc.Framework.WinForms.SectionPanel
        Me.imgBatchIcon = New System.Windows.Forms.PictureBox
        Me.btnAdvance = New System.Windows.Forms.Button
        Me.txtKey = New System.Windows.Forms.TextBox
        Me.shdKey = New SectionHeader
        Me.lblQstnCount = New System.Windows.Forms.Label
        Me.lblCurQstn = New System.Windows.Forms.Label
        Me.lblCurQstnCaption = New System.Windows.Forms.Label
        Me.btnFinish = New System.Windows.Forms.Button
        Me.lblBatchType = New System.Windows.Forms.Label
        Me.ToolTip = New System.Windows.Forms.ToolTip(Me.components)
        Me.lblKeyedBy = New System.Windows.Forms.Label
        Me.spnKey.SuspendLayout()
        Me.shdKey.SuspendLayout()
        Me.SuspendLayout()
        '
        'spnKey
        '
        Me.spnKey.BackColor = System.Drawing.SystemColors.Control
        Me.spnKey.BorderColor = System.Drawing.Color.FromArgb(CType(0, Byte), CType(45, Byte), CType(150, Byte))
        Me.spnKey.Caption = "Keying - 1441C01 - 12345678"
        Me.spnKey.Controls.Add(Me.lblKeyedBy)
        Me.spnKey.Controls.Add(Me.imgBatchIcon)
        Me.spnKey.Controls.Add(Me.btnAdvance)
        Me.spnKey.Controls.Add(Me.txtKey)
        Me.spnKey.Controls.Add(Me.shdKey)
        Me.spnKey.Controls.Add(Me.btnFinish)
        Me.spnKey.Controls.Add(Me.lblBatchType)
        Me.spnKey.Dock = System.Windows.Forms.DockStyle.Fill
        Me.spnKey.DockPadding.All = 1
        Me.spnKey.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.spnKey.Location = New System.Drawing.Point(0, 0)
        Me.spnKey.Name = "spnKey"
        Me.spnKey.ShowCaption = True
        Me.spnKey.Size = New System.Drawing.Size(584, 528)
        Me.spnKey.TabIndex = 1
        '
        'imgBatchIcon
        '
        Me.imgBatchIcon.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.imgBatchIcon.Location = New System.Drawing.Point(432, 496)
        Me.imgBatchIcon.Name = "imgBatchIcon"
        Me.imgBatchIcon.Size = New System.Drawing.Size(24, 24)
        Me.imgBatchIcon.SizeMode = System.Windows.Forms.PictureBoxSizeMode.StretchImage
        Me.imgBatchIcon.TabIndex = 7
        Me.imgBatchIcon.TabStop = False
        Me.imgBatchIcon.Visible = False
        '
        'btnAdvance
        '
        Me.btnAdvance.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
        Me.btnAdvance.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.btnAdvance.Location = New System.Drawing.Point(8, 496)
        Me.btnAdvance.Name = "btnAdvance"
        Me.btnAdvance.Size = New System.Drawing.Size(88, 24)
        Me.btnAdvance.TabIndex = 4
        Me.btnAdvance.Text = "Advance (F10)"
        '
        'txtKey
        '
        Me.txtKey.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.txtKey.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle
        Me.txtKey.Location = New System.Drawing.Point(8, 80)
        Me.txtKey.MaxLength = 12000
        Me.txtKey.Multiline = True
        Me.txtKey.Name = "txtKey"
        Me.txtKey.ScrollBars = System.Windows.Forms.ScrollBars.Both
        Me.txtKey.Size = New System.Drawing.Size(568, 408)
        Me.txtKey.TabIndex = 3
        Me.txtKey.Text = ""
        '
        'shdKey
        '
        Me.shdKey.Controls.Add(Me.lblQstnCount)
        Me.shdKey.Controls.Add(Me.lblCurQstn)
        Me.shdKey.Controls.Add(Me.lblCurQstnCaption)
        Me.shdKey.Dock = System.Windows.Forms.DockStyle.Top
        Me.shdKey.Location = New System.Drawing.Point(1, 27)
        Me.shdKey.Name = "shdKey"
        Me.shdKey.Size = New System.Drawing.Size(582, 45)
        Me.shdKey.TabIndex = 1
        '
        'lblQstnCount
        '
        Me.lblQstnCount.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.lblQstnCount.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lblQstnCount.Location = New System.Drawing.Point(520, 8)
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
        Me.lblCurQstn.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lblCurQstn.Location = New System.Drawing.Point(112, 8)
        Me.lblCurQstn.Name = "lblCurQstn"
        Me.lblCurQstn.Size = New System.Drawing.Size(392, 32)
        Me.lblCurQstn.TabIndex = 1
        Me.lblCurQstn.Text = "What would you change about your stay?"
        '
        'lblCurQstnCaption
        '
        Me.lblCurQstnCaption.BackColor = System.Drawing.Color.Transparent
        Me.lblCurQstnCaption.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lblCurQstnCaption.Location = New System.Drawing.Point(12, 8)
        Me.lblCurQstnCaption.Name = "lblCurQstnCaption"
        Me.lblCurQstnCaption.Size = New System.Drawing.Size(96, 16)
        Me.lblCurQstnCaption.TabIndex = 0
        Me.lblCurQstnCaption.Text = "Current Question:"
        '
        'btnFinish
        '
        Me.btnFinish.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
        Me.btnFinish.Enabled = False
        Me.btnFinish.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.btnFinish.Location = New System.Drawing.Point(104, 496)
        Me.btnFinish.Name = "btnFinish"
        Me.btnFinish.Size = New System.Drawing.Size(88, 24)
        Me.btnFinish.TabIndex = 4
        Me.btnFinish.Text = "Finish (F11)"
        '
        'lblBatchType
        '
        Me.lblBatchType.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.lblBatchType.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lblBatchType.Location = New System.Drawing.Point(464, 496)
        Me.lblBatchType.Name = "lblBatchType"
        Me.lblBatchType.Size = New System.Drawing.Size(104, 23)
        Me.lblBatchType.TabIndex = 6
        Me.lblBatchType.Text = "Imported from file"
        Me.lblBatchType.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        Me.lblBatchType.Visible = False
        '
        'lblKeyedBy
        '
        Me.lblKeyedBy.Anchor = CType(((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.lblKeyedBy.Location = New System.Drawing.Point(200, 496)
        Me.lblKeyedBy.Name = "lblKeyedBy"
        Me.lblKeyedBy.Size = New System.Drawing.Size(224, 23)
        Me.lblKeyedBy.TabIndex = 9
        Me.lblKeyedBy.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'ucKeying
        '
        Me.Controls.Add(Me.spnKey)
        Me.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Name = "ucKeying"
        Me.Size = New System.Drawing.Size(584, 528)
        Me.spnKey.ResumeLayout(False)
        Me.shdKey.ResumeLayout(False)
        Me.ResumeLayout(False)

    End Sub

#End Region

#Region " Private Members "
    Private mIsWorking As Boolean = False
    Private mIsVerification As Boolean = False
    Private mCurrentBatchID As Integer
    Private mCurrentTemplate As String
    Private mCurrentForm As QDEForm
    Private mCommentIndex As Integer = 0
    Private mComment As Comment
    Private mIsBackedUp As Boolean = False
    Private mPrevForm As QDEForm
    Private mReturnForm As QDEForm
#End Region

#Region " Public Properties "
    Public ReadOnly Property IsWorking() As Boolean Implements IWorkSection.IsWorking
        Get
            Return mIsWorking
        End Get
    End Property
#End Region

#Region " Exposed Events "
    Public Event WorkBegining(ByVal sender As Object, ByVal e As WorkBeginingEventArgs) Implements IWorkSection.WorkBegining
    Public Event WorkEnding(ByVal sender As Object, ByVal e As WorkEndingEventArgs) Implements IWorkSection.WorkEnding
#End Region

#Region " Control Event Handlers "

    'Control LOAD event
    Private Sub ucKeying_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles MyBase.Load
        'Initialize and disable the controls
        InitializeControls(False)

        'Bind button labels to user settings so the proper shortcut key is displayed
        btnAdvance.DataBindings.Add("Text", Settings, "AdvanceLabel")
        btnFinish.DataBindings.Add("Text", Settings, "FinishLabel")

        'Add key press event handlers
        AddKeyEventHandler(Me)
    End Sub

    'Advance button CLICK
    Private Sub btnAdvance_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnAdvance.Click
        'Verify the comment
        If VerifyComment() Then
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
        ''Verify the comment
        'If VerifyComment() Then
        '    'Finish the form then end our work session
        '    FinishForm()
        '    mIsWorking = False
        '    EndWork()
        'End If
    End Sub

    'KEY DOWN for all controls - If user presses F10 or F11 we need to advance/finish
    Private Sub KeyDownHandler(ByVal sender As Object, ByVal e As KeyEventArgs)

        'Select Case UserSettings.GetKeyEventShortCut(e)
        '    Case Settings.AdvanceKey
        '        Me.btnAdvance.PerformClick()
        '        e.Handled = True
        '    Case Settings.FinishKey
        '        Me.btnFinish.PerformClick()
        '        e.Handled = True
        '    Case Settings.MaskKey
        '        MaskSelectionCommand()
        '        e.Handled = True
        'End Select

        If e.KeyData = Settings.AdvanceKey Then
            Me.btnAdvance.PerformClick()
            e.Handled = True
        ElseIf e.KeyData = Settings.FinishKey Then
            Me.btnFinish.PerformClick()
            e.Handled = True
        ElseIf e.KeyData = Settings.MaskKey Then
            MaskSelectionCommand()
            e.Handled = True
        ElseIf e.KeyData = Settings.BackUpKey Then
            BackUpCommand()
            e.Handled = True
        ElseIf e.KeyData = Settings.ResetKey Then
            ResetCommand()
            e.Handled = True
        End If
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

        'Populate the SectionPanel caption
        spnKey.Caption = "Comment Keying - " & templateName

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

        lblCurQstn.DataBindings.Clear()
        lblCurQstn.Text = ""
        lblQstnCount.Text = "0 of 0"
        txtKey.DataBindings.Clear()
        txtKey.Text = ""
        spnKey.Caption = ""
        lblKeyedBy.Text = ""

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
            'If we are in verification mode then get the next form to be key verified
            If mIsVerification Then
                mCurrentForm = QDEForm.GetNextForm(mCurrentBatchID, mCurrentTemplate, QDEForm.WorkStage.ToBeKeyVerified, CurrentUser.LoginName)
            Else    'Otherwise get the next form to be keyed
                mCurrentForm = QDEForm.GetNextForm(mCurrentBatchID, mCurrentTemplate, QDEForm.WorkStage.ToBeKeyed, CurrentUser.LoginName)
            End If

            'If the QuestionForm object came back NULL then there is no work to do
            If mCurrentForm Is Nothing Then
                'Before we quit we need to update the bitIgnore flags for comments in this batch
                'if this is in verification mode.
                'This is because if batch was created manually we do not want to code blank comments
                If mIsVerification Then
                    Dim b As Batch = Batch.LoadFromDB(mCurrentBatchID)
                    b.UpdateBatchIgnoreFlags(Me.mCurrentTemplate, True)
                End If

                'End work and exit
                mIsWorking = False
                EndWork()
                Exit Sub
            End If
        End If

        'Add the litho to the caption
        spnKey.Caption = String.Format("Comment Keying - {0} - {1}", mCurrentTemplate, mCurrentForm.LithoCode)

        'Reinitialize the comment index and load the first one
        mCommentIndex = -1
        LoadNextComment()
    End Sub

    'Loads the next comment on the form into this control
    Private Sub LoadNextComment()
        'Increment the current comment index
        mCommentIndex += 1

        If mCurrentForm.Comments.Count = 0 Then
            Throw New ApplicationException("This form contains no comment data.")
        End If
        'store the current comment object
        mComment = mCurrentForm.Comments(mCommentIndex)

        'Mark this comment as having been keyed / key verified
        If mIsVerification Then
            mComment.DateKeyVerified = DateTime.Now
            mComment.KeyVerifiedBy = CurrentUser.LoginName

            lblKeyedBy.Text = String.Format("Keyed by {0} on {1}.", mComment.KeyedBy, mComment.DateKeyed.ToString)
        Else
            mComment.DateKeyed = DateTime.Now
            mComment.KeyedBy = CurrentUser.LoginName

            lblKeyedBy.Text = ""
        End If

        'Populate the question count '3 of 6' label
        lblQstnCount.Text = mCommentIndex + 1 & " of " & mCurrentForm.Comments.Count

        'Bind the Question Text label to the comment object
        lblCurQstn.DataBindings.Clear()
        lblCurQstn.DataBindings.Add("Text", mComment, "QuestionText")

        'Bind the Comment Text textbox to the comment object
        txtKey.DataBindings.Clear()
        txtKey.DataBindings.Add("Text", mComment, "CommentText")
        txtKey.DataBindings.Add("Font", Settings, "CommentFont")

        'If this is the last comment on the form the enable the 'Finish' button
        btnFinish.Enabled = Not (mCommentIndex + 1 < mCurrentForm.Comments.Count)

        txtKey.Focus()
        txtKey.SelectionLength = 0
    End Sub

    'Verifies that the comment matches the first version
    'If not a warning message is displayed
    Private Function VerifyComment() As Boolean
        Dim message As String

        'If we are not in verification mode then always return True
        If Not mIsVerification Then
            Return True
        End If

        'If the comment is different from the originally stored one the show message
        If mComment.HasCommentChanged Then
            Dim bmp As Bitmap = Nrc.Framework.WinForms.ScreenScraper.CaptureControl(Me)
            message = String.Format("This comment was originally keyed differently by {0} at {1}.  Do you want to Continue?", mComment.KeyedBy, mComment.DateKeyed.ToString)

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

    'Adds an event handler for the KeyDown event for all children of a control
    Private Sub AddKeyEventHandler(ByVal ctrl As Control)
        Dim child As Control
        AddHandler ctrl.KeyDown, New KeyEventHandler(AddressOf KeyDownHandler)

        For Each child In ctrl.Controls
            AddKeyEventHandler(child)
        Next
    End Sub

    Private Sub MaskSelectionCommand()
        If txtKey.SelectionLength < 1 Then Exit Sub

        While txtKey.SelectedText.StartsWith(" ")
            txtKey.SelectionStart += 1
            txtKey.SelectionLength -= 1
        End While

        While txtKey.SelectedText.EndsWith(" ")
            txtKey.SelectionLength -= 1
        End While

        Dim selStart As Integer = txtKey.SelectionStart
        Dim selLength As Integer = txtKey.SelectionLength
        Dim txt As String = txtKey.Text

        txt = txt.Insert(selStart, "[")
        txt = txt.Insert(selStart + selLength + 1, "]")
        txtKey.Text = txt

        txtKey.SelectionStart = selStart
        txtKey.SelectionLength = selLength + 2
    End Sub
    Private Sub BackUpCommand()
        'If there are previous comments on this form then just back up
        If mCommentIndex > 0 Then
            'Lose and reset focus so that databinding is updated and changes are stored
            btnAdvance.Focus()
            txtKey.Focus()
            txtKey.SelectionLength = 0

            'Reverse comment index
            mCommentIndex -= 2
            LoadNextComment()       'Load next will now actually load previous
        Else
            'If they have not already backed up a form and there is a form to back up to
            If Not mIsBackedUp AndAlso Not mPrevForm Is Nothing Then
                'lose and reset focus to update databindings
                btnAdvance.Focus()
                txtKey.Focus()
                txtKey.SelectionLength = 0

                'Set the isBackedUp flag so we don't back up more
                mIsBackedUp = True

                'Set the return form to be the current form
                mReturnForm = mCurrentForm
                'Now set current form to be the previous form
                mCurrentForm = mPrevForm

                'Add the litho to the caption
                spnKey.Caption = String.Format("Comment Keying - {0} - {1}", mCurrentTemplate, mCurrentForm.LithoCode)

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
#End Region


End Class
