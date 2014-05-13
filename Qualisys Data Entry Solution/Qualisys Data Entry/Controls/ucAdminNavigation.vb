Public Class ucAdminNavigation
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
    Friend WithEvents btnImport2 As System.Windows.Forms.Button
    Friend WithEvents btnFinalize2 As System.Windows.Forms.Button
    Friend WithEvents btnModify2 As System.Windows.Forms.Button
    Friend WithEvents btnImport As System.Windows.Forms.ToolBarButton
    Friend WithEvents btnFinalize As System.Windows.Forms.ToolBarButton
    Friend WithEvents btnModify As System.Windows.Forms.ToolBarButton
    Friend WithEvents imgButtons As System.Windows.Forms.ImageList
    Friend WithEvents tbrButtons As System.Windows.Forms.ToolBar
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.components = New System.ComponentModel.Container
        Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(ucAdminNavigation))
        Me.btnImport2 = New System.Windows.Forms.Button
        Me.btnFinalize2 = New System.Windows.Forms.Button
        Me.btnModify2 = New System.Windows.Forms.Button
        Me.imgButtons = New System.Windows.Forms.ImageList(Me.components)
        Me.tbrButtons = New System.Windows.Forms.ToolBar
        Me.btnImport = New System.Windows.Forms.ToolBarButton
        Me.btnFinalize = New System.Windows.Forms.ToolBarButton
        Me.btnModify = New System.Windows.Forms.ToolBarButton
        Me.SuspendLayout()
        '
        'btnImport2
        '
        Me.btnImport2.BackColor = System.Drawing.SystemColors.Control
        Me.btnImport2.FlatStyle = System.Windows.Forms.FlatStyle.System
        Me.btnImport2.Location = New System.Drawing.Point(24, 184)
        Me.btnImport2.Name = "btnImport2"
        Me.btnImport2.Size = New System.Drawing.Size(96, 23)
        Me.btnImport2.TabIndex = 0
        Me.btnImport2.Text = "Import Data File"
        Me.btnImport2.UseVisualStyleBackColor = False
        Me.btnImport2.Visible = False
        '
        'btnFinalize2
        '
        Me.btnFinalize2.BackColor = System.Drawing.SystemColors.Control
        Me.btnFinalize2.FlatStyle = System.Windows.Forms.FlatStyle.System
        Me.btnFinalize2.Location = New System.Drawing.Point(24, 232)
        Me.btnFinalize2.Name = "btnFinalize2"
        Me.btnFinalize2.Size = New System.Drawing.Size(96, 23)
        Me.btnFinalize2.TabIndex = 0
        Me.btnFinalize2.Text = "Finalize Data"
        Me.btnFinalize2.UseVisualStyleBackColor = False
        Me.btnFinalize2.Visible = False
        '
        'btnModify2
        '
        Me.btnModify2.BackColor = System.Drawing.SystemColors.Control
        Me.btnModify2.FlatStyle = System.Windows.Forms.FlatStyle.System
        Me.btnModify2.Location = New System.Drawing.Point(24, 280)
        Me.btnModify2.Name = "btnModify2"
        Me.btnModify2.Size = New System.Drawing.Size(96, 23)
        Me.btnModify2.TabIndex = 0
        Me.btnModify2.Text = "Modify Comment"
        Me.btnModify2.UseVisualStyleBackColor = False
        Me.btnModify2.Visible = False
        '
        'imgButtons
        '
        Me.imgButtons.ImageStream = CType(resources.GetObject("imgButtons.ImageStream"), System.Windows.Forms.ImageListStreamer)
        Me.imgButtons.TransparentColor = System.Drawing.Color.Transparent
        Me.imgButtons.Images.SetKeyName(0, "")
        Me.imgButtons.Images.SetKeyName(1, "")
        Me.imgButtons.Images.SetKeyName(2, "")
        Me.imgButtons.Images.SetKeyName(3, "")
        '
        'tbrButtons
        '
        Me.tbrButtons.Appearance = System.Windows.Forms.ToolBarAppearance.Flat
        Me.tbrButtons.AutoSize = False
        Me.tbrButtons.Buttons.AddRange(New System.Windows.Forms.ToolBarButton() {Me.btnImport, Me.btnFinalize, Me.btnModify})
        Me.tbrButtons.Divider = False
        Me.tbrButtons.Dock = System.Windows.Forms.DockStyle.None
        Me.tbrButtons.DropDownArrows = True
        Me.tbrButtons.ImageList = Me.imgButtons
        Me.tbrButtons.Location = New System.Drawing.Point(8, 16)
        Me.tbrButtons.Name = "tbrButtons"
        Me.tbrButtons.ShowToolTips = True
        Me.tbrButtons.Size = New System.Drawing.Size(136, 160)
        Me.tbrButtons.TabIndex = 2
        Me.tbrButtons.TextAlign = System.Windows.Forms.ToolBarTextAlign.Right
        '
        'btnImport
        '
        Me.btnImport.ImageIndex = 0
        Me.btnImport.Name = "btnImport"
        Me.btnImport.Text = "Import Data File"
        '
        'btnFinalize
        '
        Me.btnFinalize.ImageIndex = 2
        Me.btnFinalize.Name = "btnFinalize"
        Me.btnFinalize.Text = "Finalize Batch Data"
        '
        'btnModify
        '
        Me.btnModify.ImageIndex = 1
        Me.btnModify.Name = "btnModify"
        Me.btnModify.Text = "Modify Comment"
        '
        'ucAdminNavigation
        '
        Me.BackColor = System.Drawing.SystemColors.Control
        Me.Controls.Add(Me.tbrButtons)
        Me.Controls.Add(Me.btnImport2)
        Me.Controls.Add(Me.btnFinalize2)
        Me.Controls.Add(Me.btnModify2)
        Me.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Name = "ucAdminNavigation"
        Me.Size = New System.Drawing.Size(152, 376)
        Me.ResumeLayout(False)

    End Sub

#End Region


#Region " FunctionType Enum "
    Public Enum FunctionType
        ImportFile = 0
        Finalize
        ModifyComment
    End Enum
#End Region

#Region " FunctionSelected Event "
    Public Event FunctionSelected As FunctionSelectedEventHandler
    Public Delegate Sub FunctionSelectedEventHandler(ByVal sender As Object, ByVal e As FunctionSelectedEventArgs)
    Public Class FunctionSelectedEventArgs
        Inherits EventArgs

        Private mFunction As FunctionType

        Public ReadOnly Property FunctionSelected() As FunctionType
            Get
                Return mFunction
            End Get
        End Property
        Sub New(ByVal func As FunctionType)
            mFunction = func
        End Sub
    End Class
#End Region


    'Private Sub btnImport_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnImport2.Click
    '    RaiseEvent FunctionSelected(Me, New FunctionSelectedEventArgs(FunctionType.ImportFile))
    'End Sub
    'Private Sub btnFinalize_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnFinalize2.Click
    '    RaiseEvent FunctionSelected(Me, New FunctionSelectedEventArgs(FunctionType.Finalize))
    'End Sub
    'Private Sub btnModify_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnModify2.Click
    '    RaiseEvent FunctionSelected(Me, New FunctionSelectedEventArgs(FunctionType.ModifyComment))
    'End Sub
    'Private Sub btnUserAdmin_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnUserAdmin2.Click
    '    RaiseEvent FunctionSelected(Me, New FunctionSelectedEventArgs(FunctionType.UserAdmin))
    'End Sub

    Private Sub ucAdminNavigation_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles MyBase.Load
        'Dim y As Integer = 40
        'Dim spacer As Integer = 48

        btnImport.Visible = CurrentUser.IsFileImporter
        btnFinalize.Visible = CurrentUser.IsFinalizer
        btnModify.Visible = CurrentUser.IsCommentModifier
        
        'If CurrentUser.IsFileImporter Then
        '    btnImport.Visible = True
        '    btnImport.Top = y
        '    y += spacer
        'End If

        'If CurrentUser.IsFinalizer Then
        '    btnFinalize.Visible = True
        '    btnFinalize.Top = y
        '    y += spacer
        'End If

        'If CurrentUser.IsCommentModifier Then
        '    btnModify.Visible = True
        '    btnModify.Top = y
        '    y += spacer
        'End If

        'If CurrentUser.IsUserAdministrator Then
        '    btnUserAdmin.Visible = True
        '    btnUserAdmin.Top = y
        '    y += spacer
        'End If

    End Sub

    Private Sub tbrButtons_ButtonClick(ByVal sender As System.Object, ByVal e As System.Windows.Forms.ToolBarButtonClickEventArgs) Handles tbrButtons.ButtonClick
        If e.Button Is btnImport Then
            RaiseEvent FunctionSelected(Me, New FunctionSelectedEventArgs(FunctionType.ImportFile))
        ElseIf e.Button Is btnFinalize Then
            RaiseEvent FunctionSelected(Me, New FunctionSelectedEventArgs(FunctionType.Finalize))
        ElseIf e.Button Is btnModify Then
            RaiseEvent FunctionSelected(Me, New FunctionSelectedEventArgs(FunctionType.ModifyComment))
        End If
    End Sub
End Class
