Public Class frmGetQueryInfo
    Inherits NRC.WinForms.DialogForm
    Private mOKSelected As Boolean

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
    Friend WithEvents Label1 As System.Windows.Forms.Label
    Friend WithEvents Label2 As System.Windows.Forms.Label
    Friend WithEvents btnOK As System.Windows.Forms.Button
    Friend WithEvents btnCancel As System.Windows.Forms.Button
    Friend WithEvents txtQueryName As System.Windows.Forms.TextBox
    Friend WithEvents txtQueryDescription As System.Windows.Forms.TextBox
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.txtQueryName = New System.Windows.Forms.TextBox
        Me.txtQueryDescription = New System.Windows.Forms.TextBox
        Me.Label1 = New System.Windows.Forms.Label
        Me.Label2 = New System.Windows.Forms.Label
        Me.btnOK = New System.Windows.Forms.Button
        Me.btnCancel = New System.Windows.Forms.Button
        Me.SuspendLayout()
        '
        'mPaneCaption
        '
        Me.mPaneCaption.Caption = "Query Properties"
        Me.mPaneCaption.Name = "mPaneCaption"
        Me.mPaneCaption.Size = New System.Drawing.Size(654, 26)
        '
        'txtQueryName
        '
        Me.txtQueryName.Location = New System.Drawing.Point(24, 72)
        Me.txtQueryName.Name = "txtQueryName"
        Me.txtQueryName.Size = New System.Drawing.Size(584, 20)
        Me.txtQueryName.TabIndex = 1
        Me.txtQueryName.Text = ""
        '
        'txtQueryDescription
        '
        Me.txtQueryDescription.Location = New System.Drawing.Point(24, 144)
        Me.txtQueryDescription.Name = "txtQueryDescription"
        Me.txtQueryDescription.Size = New System.Drawing.Size(584, 20)
        Me.txtQueryDescription.TabIndex = 2
        Me.txtQueryDescription.Text = ""
        '
        'Label1
        '
        Me.Label1.Location = New System.Drawing.Point(24, 48)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(216, 23)
        Me.Label1.TabIndex = 3
        Me.Label1.Text = "Query Name"
        '
        'Label2
        '
        Me.Label2.Location = New System.Drawing.Point(24, 120)
        Me.Label2.Name = "Label2"
        Me.Label2.Size = New System.Drawing.Size(216, 23)
        Me.Label2.TabIndex = 4
        Me.Label2.Text = "Query Description"
        '
        'btnOK
        '
        Me.btnOK.Location = New System.Drawing.Point(235, 176)
        Me.btnOK.Name = "btnOK"
        Me.btnOK.TabIndex = 5
        Me.btnOK.Text = "OK"
        '
        'btnCancel
        '
        Me.btnCancel.Location = New System.Drawing.Point(347, 176)
        Me.btnCancel.Name = "btnCancel"
        Me.btnCancel.TabIndex = 6
        Me.btnCancel.Text = "Cancel"
        '
        'frmGetQueryInfo
        '
        Me.AutoScaleBaseSize = New System.Drawing.Size(5, 13)
        Me.Caption = "Query Properties"
        Me.ClientSize = New System.Drawing.Size(656, 208)
        Me.Controls.Add(Me.btnCancel)
        Me.Controls.Add(Me.btnOK)
        Me.Controls.Add(Me.Label2)
        Me.Controls.Add(Me.Label1)
        Me.Controls.Add(Me.txtQueryDescription)
        Me.Controls.Add(Me.txtQueryName)
        Me.DockPadding.All = 1
        Me.Name = "frmGetQueryInfo"
        Me.Text = "me"
        Me.Controls.SetChildIndex(Me.txtQueryName, 0)
        Me.Controls.SetChildIndex(Me.txtQueryDescription, 0)
        Me.Controls.SetChildIndex(Me.Label1, 0)
        Me.Controls.SetChildIndex(Me.mPaneCaption, 0)
        Me.Controls.SetChildIndex(Me.Label2, 0)
        Me.Controls.SetChildIndex(Me.btnOK, 0)
        Me.Controls.SetChildIndex(Me.btnCancel, 0)
        Me.ResumeLayout(False)

    End Sub

#End Region

    Public Sub New(ByVal pQueryName As String, ByVal pQueryDescription As String)
        MyBase.New()

        'This call is required by the Windows Form Designer.
        InitializeComponent()

        txtQueryName.Text = pQueryName
        txtQueryDescription.Text = pQueryDescription
    End Sub

    Public Property QueryName() As String
        Get
            Return txtQueryName.Text()
        End Get
        Set(ByVal Value As String)
            txtQueryName.Text() = Value
        End Set
    End Property

    Public Property QueryDescription() As String
        Get
            Return txtQueryDescription.Text()
        End Get
        Set(ByVal Value As String)
            txtQueryDescription.Text() = Value
        End Set
    End Property

    Public ReadOnly Property OKSelected() As Boolean
        Get
            Return mOKSelected
        End Get
    End Property

    Private Sub btnOK_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnOK.Click
        If txtQueryName.Text = "" Or txtQueryDescription.Text = "" Then
            MsgBox("You must specify a name and a description.")
            Return
        End If
        mOKSelected = True
        Me.Close()
    End Sub

    Private Sub btnCancel_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnCancel.Click
        mOKSelected = False
        Me.Close()
    End Sub
End Class
