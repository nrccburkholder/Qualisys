Public Class frmInputDialog
    Inherits NRC.Framework.WinForms.DialogForm

#Region " Windows Form Designer generated code "

    Public Sub New(ByVal inputDialogType As InputType)
        MyBase.New()

        'This call is required by the Windows Form Designer.
        InitializeComponent()

        'Add any initialization after the InitializeComponent() call
        Me.mInputType = inputDialogType
        Me.mMultiSelect = False
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
    Friend WithEvents btnCancel As System.Windows.Forms.Button
    Friend WithEvents pnlInput As System.Windows.Forms.Panel
    Friend WithEvents lblPrompt As System.Windows.Forms.Label
    Friend WithEvents btnOK As System.Windows.Forms.Button
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.btnCancel = New System.Windows.Forms.Button
        Me.pnlInput = New System.Windows.Forms.Panel
        Me.lblPrompt = New System.Windows.Forms.Label
        Me.btnOK = New System.Windows.Forms.Button
        Me.SuspendLayout()
        '
        'mPaneCaption
        '
        Me.mPaneCaption.Caption = "Input Text"
        Me.mPaneCaption.Name = "mPaneCaption"
        Me.mPaneCaption.Size = New System.Drawing.Size(302, 26)
        Me.mPaneCaption.TabIndex = 10
        Me.mPaneCaption.TabStop = False
        '
        'btnCancel
        '
        Me.btnCancel.Anchor = CType(((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.btnCancel.DialogResult = System.Windows.Forms.DialogResult.Cancel
        Me.btnCancel.FlatStyle = System.Windows.Forms.FlatStyle.System
        Me.btnCancel.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.btnCancel.Location = New System.Drawing.Point(160, 112)
        Me.btnCancel.Name = "btnCancel"
        Me.btnCancel.TabIndex = 6
        Me.btnCancel.Text = "Cancel"
        '
        'pnlInput
        '
        Me.pnlInput.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.pnlInput.Location = New System.Drawing.Point(8, 72)
        Me.pnlInput.Name = "pnlInput"
        Me.pnlInput.Size = New System.Drawing.Size(280, 24)
        Me.pnlInput.TabIndex = 4
        '
        'lblPrompt
        '
        Me.lblPrompt.FlatStyle = System.Windows.Forms.FlatStyle.System
        Me.lblPrompt.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lblPrompt.Location = New System.Drawing.Point(8, 40)
        Me.lblPrompt.Name = "lblPrompt"
        Me.lblPrompt.Size = New System.Drawing.Size(288, 32)
        Me.lblPrompt.TabIndex = 7
        Me.lblPrompt.Text = "Enter the input."
        '
        'btnOK
        '
        Me.btnOK.Anchor = CType(((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.btnOK.FlatStyle = System.Windows.Forms.FlatStyle.System
        Me.btnOK.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.btnOK.Location = New System.Drawing.Point(48, 112)
        Me.btnOK.Name = "btnOK"
        Me.btnOK.TabIndex = 5
        Me.btnOK.Text = "OK"
        '
        'frmInputDialog
        '
        Me.AcceptButton = Me.btnOK
        Me.AutoScaleBaseSize = New System.Drawing.Size(5, 13)
        Me.CancelButton = Me.btnCancel
        Me.Caption = "Input Text"
        Me.ClientSize = New System.Drawing.Size(304, 152)
        Me.Controls.Add(Me.btnCancel)
        Me.Controls.Add(Me.pnlInput)
        Me.Controls.Add(Me.lblPrompt)
        Me.Controls.Add(Me.btnOK)
        Me.DockPadding.All = 1
        Me.Name = "frmInputDialog"
        Me.Controls.SetChildIndex(Me.mPaneCaption, 0)
        Me.Controls.SetChildIndex(Me.btnOK, 0)
        Me.Controls.SetChildIndex(Me.lblPrompt, 0)
        Me.Controls.SetChildIndex(Me.pnlInput, 0)
        Me.Controls.SetChildIndex(Me.btnCancel, 0)
        Me.ResumeLayout(False)

    End Sub

#End Region

    Public Enum InputType
        None = 0
        TextBox = 1
        ListBox = 2
    End Enum

#Region " Private Instance Variables "
    Private mTitle As String = ""
    Private mPrompt As String = ""
    Private mInput As String = ""
    Private mInputType As InputType
    Private mListBox As New ListBox
    Private mTextBox As New TextBox
    Private mMultiSelect As Boolean
#End Region

#Region " Public Properties "
    Public Property Title() As String
        Get
            Return Me.mTitle
        End Get
        Set(ByVal Value As String)
            Me.mTitle = Value
        End Set
    End Property
    Public Property Prompt() As String
        Get
            Return Me.mPrompt
        End Get
        Set(ByVal Value As String)
            Me.mPrompt = Value
        End Set
    End Property
    Public Property Input() As String
        Get
            Return Me.mInput
        End Get
        Set(ByVal Value As String)
            Me.mInput = Value
        End Set
    End Property
    Public ReadOnly Property Items() As ListBox.ObjectCollection
        Get
            Return Me.mListBox.Items
        End Get
    End Property
    Public ReadOnly Property SelectedItems() As ListBox.SelectedObjectCollection
        Get
            Return Me.mListBox.SelectedItems
        End Get
    End Property

    Public Property MultiSelect() As Boolean
        Get
            Return mMultiSelect
        End Get
        Set(ByVal Value As Boolean)
            mMultiSelect = Value
        End Set
    End Property
#End Region

#Region " Private Methods "
    Private Sub InputDialog_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles MyBase.Load
        Me.Caption = Me.mTitle
        Me.lblPrompt.Text = Me.mPrompt

        Select Case Me.mInputType
            Case InputType.TextBox
                mTextBox.Text = Me.mInput
                mTextBox.Dock = DockStyle.Fill
                mTextBox.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
                Me.pnlInput.Controls.Add(mTextBox)
                mTextBox.TabStop = True
                mTextBox.TabIndex = 0
                mTextBox.Focus()
            Case InputType.ListBox
                Me.Height = 275
                mListBox.Dock = DockStyle.Fill
                mListBox.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
                If mMultiSelect Then
                    mListBox.SelectionMode = SelectionMode.MultiExtended
                Else
                    mListBox.SelectionMode = SelectionMode.One
                End If
                Me.pnlInput.Controls.Add(mListBox)
                mListBox.TabStop = True
                mListBox.TabIndex = 0
                mListBox.Focus()
        End Select
    End Sub

    Private Sub btnOK_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnOK.Click
        Select Case Me.mInputType
            Case InputType.TextBox
                Me.mInput = mTextBox.Text.Trim
            Case InputType.ListBox
                If Not Me.MultiSelect Then
                    Me.mInput = mListBox.SelectedValue.ToString
                End If
        End Select

        Me.DialogResult = Windows.Forms.DialogResult.OK
    End Sub

    Private Sub btnCancel_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnCancel.Click
        Me.DialogResult = Windows.Forms.DialogResult.Cancel
    End Sub
#End Region

End Class
