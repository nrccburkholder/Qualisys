Option Explicit On 
Option Strict On

Imports system.Data
Imports system.Data.OleDb

Public Class frmListBox
    Inherits System.Windows.Forms.Form

#Region " Private Members "

    Private mCaption As String
    Private mTitle As String
    Private mDisplayMember As String
    Private mValueMember As String
    Private mDataSource As Object
    Private mSelectedIndex As Integer = -1
    Private mSelectedItem As Object
    Private mSelectedValue As Object

#End Region

#Region " Public Properties "

    Public Property Caption() As String
        Get
            Return mCaption
        End Get
        Set(ByVal Value As String)
            mCaption = Value
        End Set
    End Property

    Public Property Title() As String
        Get
            Return mTitle
        End Get
        Set(ByVal Value As String)
            mTitle = Value
        End Set
    End Property

    Public Property DisplayMember() As String
        Get
            Return mDisplayMember
        End Get
        Set(ByVal Value As String)
            mDisplayMember = Value
        End Set
    End Property

    Public Property ValueMember() As String
        Get
            Return mValueMember
        End Get
        Set(ByVal Value As String)
            mValueMember = Value
        End Set
    End Property

    Public Property DataSource() As Object
        Get
            Return mDataSource
        End Get
        Set(ByVal Value As Object)
            mDataSource = Value
        End Set
    End Property

    Public Property SelectedIndex() As Integer
        Get
            Return mSelectedIndex
        End Get
        Set(ByVal Value As Integer)
            mSelectedIndex = Value
        End Set
    End Property

    Public Property SelectedItem() As Object
        Get
            Return mSelectedItem
        End Get
        Set(ByVal Value As Object)
            mSelectedItem = Value
        End Set
    End Property

    Public Property SelectedValue() As Object
        Get
            Return mSelectedValue
        End Get
        Set(ByVal Value As Object)
            mSelectedValue = Value
        End Set
    End Property

#End Region

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
    Friend WithEvents btnCancel As System.Windows.Forms.Button
    Friend WithEvents btnOK As System.Windows.Forms.Button
    Friend WithEvents lblTitle As System.Windows.Forms.Label
    Friend WithEvents lstList As System.Windows.Forms.ListBox
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Dim resources As System.Resources.ResourceManager = New System.Resources.ResourceManager(GetType(frmListBox))
        Me.lstList = New System.Windows.Forms.ListBox
        Me.btnCancel = New System.Windows.Forms.Button
        Me.btnOK = New System.Windows.Forms.Button
        Me.lblTitle = New System.Windows.Forms.Label
        Me.SuspendLayout()
        '
        'lstList
        '
        Me.lstList.Location = New System.Drawing.Point(32, 48)
        Me.lstList.Name = "lstList"
        Me.lstList.Size = New System.Drawing.Size(160, 134)
        Me.lstList.TabIndex = 0
        '
        'btnCancel
        '
        Me.btnCancel.DialogResult = System.Windows.Forms.DialogResult.Cancel
        Me.btnCancel.FlatStyle = System.Windows.Forms.FlatStyle.System
        Me.btnCancel.Location = New System.Drawing.Point(112, 192)
        Me.btnCancel.Name = "btnCancel"
        Me.btnCancel.TabIndex = 1
        Me.btnCancel.Text = "&Cancel"
        '
        'btnOK
        '
        Me.btnOK.FlatStyle = System.Windows.Forms.FlatStyle.System
        Me.btnOK.Location = New System.Drawing.Point(32, 192)
        Me.btnOK.Name = "btnOK"
        Me.btnOK.TabIndex = 2
        Me.btnOK.Text = "&OK"
        '
        'lblTitle
        '
        Me.lblTitle.FlatStyle = System.Windows.Forms.FlatStyle.System
        Me.lblTitle.Location = New System.Drawing.Point(32, 24)
        Me.lblTitle.Name = "lblTitle"
        Me.lblTitle.Size = New System.Drawing.Size(160, 16)
        Me.lblTitle.TabIndex = 3
        '
        'frmListBox
        '
        Me.AcceptButton = Me.btnOK
        Me.AutoScaleBaseSize = New System.Drawing.Size(5, 13)
        Me.CancelButton = Me.btnCancel
        Me.ClientSize = New System.Drawing.Size(232, 245)
        Me.Controls.Add(Me.lblTitle)
        Me.Controls.Add(Me.btnOK)
        Me.Controls.Add(Me.btnCancel)
        Me.Controls.Add(Me.lstList)
        Me.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedToolWindow
        Me.Icon = CType(resources.GetObject("$this.Icon"), System.Drawing.Icon)
        Me.MaximizeBox = False
        Me.MinimizeBox = False
        Me.Name = "frmListBox"
        Me.ShowInTaskbar = False
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent
        Me.Text = "Table Selection"
        Me.ResumeLayout(False)

    End Sub

#End Region

#Region " Private Methods "


#End Region

    Private Sub frmListBox_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        Me.Text = Me.mCaption
        Me.lblTitle.Text = Me.mTitle
        Me.lstList.DisplayMember = Me.mDisplayMember
        Me.lstList.ValueMember = Me.ValueMember
        Me.lstList.DataSource = Me.mDataSource
        If (Me.mSelectedIndex >= 0) Then
            Me.lstList.SelectedIndex = Me.mSelectedIndex
        ElseIf (Not Me.mSelectedValue Is Nothing) Then
            Me.lstList.SelectedValue = Me.mSelectedValue
        End If
    End Sub

    Private Sub OK_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnOK.Click
        'Check if any entry is selected
        If (lstList.SelectedIndex < 0) Then
            MessageBox.Show("Select an entry to continue", Me.mCaption, MessageBoxButtons.OK, MessageBoxIcon.Information)
            Return
        End If

        'Get selected entry
        Me.SelectedIndex = lstList.SelectedIndex
        Me.SelectedItem = lstList.SelectedItem
        Me.SelectedValue = lstList.SelectedValue

        DialogResult = Windows.Forms.DialogResult.OK
    End Sub

    Private Sub Cancel_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnCancel.Click
        DialogResult = Windows.Forms.DialogResult.Cancel
    End Sub

    Private Sub List_DoubleClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles lstList.DoubleClick
        OK_Click(Nothing, Nothing)
    End Sub
End Class
