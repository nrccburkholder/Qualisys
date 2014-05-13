Imports NRC.DataMart.WebDocumentManager.Library
Public Class AddNewDocument
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
    Friend WithEvents btnCancel As System.Windows.Forms.Button
    Friend WithEvents btnOK As System.Windows.Forms.Button
    Friend WithEvents Label2 As System.Windows.Forms.Label
    Friend WithEvents txtDocumentName As System.Windows.Forms.TextBox
    Friend WithEvents lbTreeGroups As System.Windows.Forms.ListBox
    Friend WithEvents lblDocumentName As System.Windows.Forms.Label
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Dim resources As System.Resources.ResourceManager = New System.Resources.ResourceManager(GetType(AddNewDocument))
        Me.lblDocumentName = New System.Windows.Forms.Label
        Me.btnOK = New System.Windows.Forms.Button
        Me.btnCancel = New System.Windows.Forms.Button
        Me.txtDocumentName = New System.Windows.Forms.TextBox
        Me.lbTreeGroups = New System.Windows.Forms.ListBox
        Me.Label2 = New System.Windows.Forms.Label
        Me.SuspendLayout()
        '
        'lblDocumentName
        '
        Me.lblDocumentName.FlatStyle = System.Windows.Forms.FlatStyle.System
        Me.lblDocumentName.Location = New System.Drawing.Point(16, 24)
        Me.lblDocumentName.Name = "lblDocumentName"
        Me.lblDocumentName.Size = New System.Drawing.Size(360, 24)
        Me.lblDocumentName.TabIndex = 0
        Me.lblDocumentName.Text = "Document Name"
        '
        'btnOK
        '
        Me.btnOK.FlatStyle = System.Windows.Forms.FlatStyle.System
        Me.btnOK.Location = New System.Drawing.Point(100, 200)
        Me.btnOK.Name = "btnOK"
        Me.btnOK.Size = New System.Drawing.Size(80, 23)
        Me.btnOK.TabIndex = 1
        Me.btnOK.Text = "OK"
        '
        'btnCancel
        '
        Me.btnCancel.DialogResult = System.Windows.Forms.DialogResult.Cancel
        Me.btnCancel.FlatStyle = System.Windows.Forms.FlatStyle.System
        Me.btnCancel.Location = New System.Drawing.Point(220, 200)
        Me.btnCancel.Name = "btnCancel"
        Me.btnCancel.Size = New System.Drawing.Size(80, 23)
        Me.btnCancel.TabIndex = 3
        Me.btnCancel.Text = "Cancel"
        '
        'txtDocumentName
        '
        Me.txtDocumentName.Location = New System.Drawing.Point(14, 44)
        Me.txtDocumentName.Name = "txtDocumentName"
        Me.txtDocumentName.Size = New System.Drawing.Size(360, 20)
        Me.txtDocumentName.TabIndex = 4
        Me.txtDocumentName.Text = "TextBox1"
        '
        'lbTreeGroups
        '
        Me.lbTreeGroups.Location = New System.Drawing.Point(128, 115)
        Me.lbTreeGroups.Name = "lbTreeGroups"
        Me.lbTreeGroups.Size = New System.Drawing.Size(144, 56)
        Me.lbTreeGroups.TabIndex = 5
        '
        'Label2
        '
        Me.Label2.FlatStyle = System.Windows.Forms.FlatStyle.System
        Me.Label2.Location = New System.Drawing.Point(128, 96)
        Me.Label2.Name = "Label2"
        Me.Label2.Size = New System.Drawing.Size(144, 16)
        Me.Label2.TabIndex = 6
        Me.Label2.Text = "Select Tree Grouping Type"
        '
        'AddNewDocument
        '
        Me.AcceptButton = Me.btnOK
        Me.AutoScaleBaseSize = New System.Drawing.Size(5, 13)
        Me.BackColor = System.Drawing.SystemColors.Control
        Me.CancelButton = Me.btnCancel
        Me.ClientSize = New System.Drawing.Size(400, 238)
        Me.Controls.Add(Me.Label2)
        Me.Controls.Add(Me.lbTreeGroups)
        Me.Controls.Add(Me.txtDocumentName)
        Me.Controls.Add(Me.btnCancel)
        Me.Controls.Add(Me.btnOK)
        Me.Controls.Add(Me.lblDocumentName)
        Me.Icon = CType(resources.GetObject("$this.Icon"), System.Drawing.Icon)
        Me.MaximizeBox = False
        Me.MinimizeBox = False
        Me.Name = "AddNewDocument"
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen
        Me.Text = "New Document Properties"
        Me.ResumeLayout(False)

    End Sub

#End Region

#Region "Public Properties"
    Public Property DocumentName() As String
        Get
            Return txtDocumentName.Text
        End Get
        Set(ByVal Value As String)
            txtDocumentName.Text = Value
        End Set
    End Property

    Public WriteOnly Property Prompt() As String
        Set(ByVal Value As String)
            lblDocumentName.Text = Value
        End Set
    End Property

    Public ReadOnly Property TreeGroupingType() As String
        Get
            Return CStr(lbTreeGroups.SelectedItem)
        End Get
    End Property
#End Region

#Region "Private Methods"
    Private Sub AddNewDocument_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        Dim mTreeGroups As TreeGroupCollection = TreeGroupCollection.GetTreeGroups
        lbTreeGroups.Items.Clear()
        For Each tmpTreeGroup As TreeGroup In mTreeGroups
            lbTreeGroups.Items.Add(tmpTreeGroup.Name)
        Next
    End Sub

    Private Sub btnOK_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnOK.Click
        If txtDocumentName.Text = "" Or lbTreeGroups.SelectedIndex < 0 Then
            MessageBox.Show("You must fill in all information.", "Incomplete", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Return
        End If
        Me.DialogResult = DialogResult.OK
        Me.Close()
    End Sub

    Private Sub btnCancel_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnCancel.Click
        Me.DialogResult = DialogResult.Cancel
        Me.Close()
    End Sub
#End Region


End Class
