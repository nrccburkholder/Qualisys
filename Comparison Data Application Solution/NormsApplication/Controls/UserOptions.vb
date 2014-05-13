Public Class UserOptions
    Inherits System.Windows.Forms.UserControl
    Public Event btnPressed(ByVal SelectedButton As AdministrationButtons)

    Public Enum AdministrationButtons
        btnCreateDimension = 0
        btnEditDimension = 1
    End Enum


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
    Friend WithEvents Panel1 As System.Windows.Forms.Panel
    Friend WithEvents btnCreateDimension As System.Windows.Forms.Button
    Friend WithEvents btnEditDimension As System.Windows.Forms.Button
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.Panel1 = New System.Windows.Forms.Panel
        Me.btnEditDimension = New System.Windows.Forms.Button
        Me.btnCreateDimension = New System.Windows.Forms.Button
        Me.Panel1.SuspendLayout()
        Me.SuspendLayout()
        '
        'Panel1
        '
        Me.Panel1.BackColor = System.Drawing.SystemColors.Control
        Me.Panel1.Controls.Add(Me.btnEditDimension)
        Me.Panel1.Controls.Add(Me.btnCreateDimension)
        Me.Panel1.Dock = System.Windows.Forms.DockStyle.Fill
        Me.Panel1.Location = New System.Drawing.Point(0, 0)
        Me.Panel1.Name = "Panel1"
        Me.Panel1.Size = New System.Drawing.Size(152, 304)
        Me.Panel1.TabIndex = 0
        '
        'btnEditDimension
        '
        Me.btnEditDimension.Location = New System.Drawing.Point(8, 40)
        Me.btnEditDimension.Name = "btnEditDimension"
        Me.btnEditDimension.Size = New System.Drawing.Size(136, 23)
        Me.btnEditDimension.TabIndex = 5
        Me.btnEditDimension.Text = "Edit/View Dimension"
        '
        'btnCreateDimension
        '
        Me.btnCreateDimension.Location = New System.Drawing.Point(8, 88)
        Me.btnCreateDimension.Name = "btnCreateDimension"
        Me.btnCreateDimension.Size = New System.Drawing.Size(136, 23)
        Me.btnCreateDimension.TabIndex = 1
        Me.btnCreateDimension.Text = "Create Dimension"
        '
        'UserOptions
        '
        Me.Controls.Add(Me.Panel1)
        Me.Name = "UserOptions"
        Me.Size = New System.Drawing.Size(152, 304)
        Me.Panel1.ResumeLayout(False)
        Me.ResumeLayout(False)

    End Sub

#End Region

    Private Sub btnEditDimension_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnEditDimension.Click
        RaiseEvent btnPressed(AdministrationButtons.btnEditDimension)
    End Sub


    Private Sub btnCreateDimension_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnCreateDimension.Click
        RaiseEvent btnPressed(AdministrationButtons.btnCreateDimension)
    End Sub

End Class
