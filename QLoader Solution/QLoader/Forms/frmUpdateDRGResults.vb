Public Class frmUpdateDRGResults
    Inherits NRC.Framework.WinForms.DialogForm

#Region " Windows Form Designer generated code "

    
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
    Friend WithEvents txtUpdateDRGResults As System.Windows.Forms.TextBox
    Friend WithEvents btnCopyToClipboard As System.Windows.Forms.Button

    'NOTE: The following procedure is required by the Windows Form Designer
    'It can be modified using the Windows Form Designer.  
    'Do not modify it using the code editor.
    Friend WithEvents btnClose As System.Windows.Forms.Button
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.btnClose = New System.Windows.Forms.Button
        Me.txtUpdateDRGResults = New System.Windows.Forms.TextBox
        Me.btnCopyToClipboard = New System.Windows.Forms.Button
        Me.SuspendLayout()
        '
        'mPaneCaption
        '
        Me.mPaneCaption.Caption = "UpdateDRG Results"
        Me.mPaneCaption.Size = New System.Drawing.Size(321, 26)
        Me.mPaneCaption.Text = "UpdateDRG Results"
        '
        'btnClose
        '
        Me.btnClose.Anchor = CType(((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.btnClose.DialogResult = System.Windows.Forms.DialogResult.Cancel
        Me.btnClose.FlatStyle = System.Windows.Forms.FlatStyle.System
        Me.btnClose.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.btnClose.Location = New System.Drawing.Point(236, 290)
        Me.btnClose.Name = "btnClose"
        Me.btnClose.Size = New System.Drawing.Size(71, 23)
        Me.btnClose.TabIndex = 7
        Me.btnClose.Text = "Close"
        '
        'txtUpdateDRGResults
        '
        Me.txtUpdateDRGResults.BackColor = System.Drawing.Color.White
        Me.txtUpdateDRGResults.Location = New System.Drawing.Point(7, 33)
        Me.txtUpdateDRGResults.Multiline = True
        Me.txtUpdateDRGResults.Name = "txtUpdateDRGResults"
        Me.txtUpdateDRGResults.ReadOnly = True
        Me.txtUpdateDRGResults.ScrollBars = System.Windows.Forms.ScrollBars.Vertical
        Me.txtUpdateDRGResults.Size = New System.Drawing.Size(309, 240)
        Me.txtUpdateDRGResults.TabIndex = 9
        '
        'btnCopyToClipboard
        '
        Me.btnCopyToClipboard.Location = New System.Drawing.Point(7, 290)
        Me.btnCopyToClipboard.Name = "btnCopyToClipboard"
        Me.btnCopyToClipboard.Size = New System.Drawing.Size(150, 23)
        Me.btnCopyToClipboard.TabIndex = 10
        Me.btnCopyToClipboard.Text = "Copy To Clipboard"
        Me.btnCopyToClipboard.UseVisualStyleBackColor = True
        '
        'frmUpdateDRGResults
        '
        Me.AutoScaleBaseSize = New System.Drawing.Size(5, 14)
        Me.Caption = "UpdateDRG Results"
        Me.ClientSize = New System.Drawing.Size(323, 329)
        Me.Controls.Add(Me.btnClose)
        Me.Controls.Add(Me.btnCopyToClipboard)
        Me.Controls.Add(Me.txtUpdateDRGResults)
        Me.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Name = "frmUpdateDRGResults"
        Me.Text = "Function Library"
        Me.Controls.SetChildIndex(Me.txtUpdateDRGResults, 0)
        Me.Controls.SetChildIndex(Me.btnCopyToClipboard, 0)
        Me.Controls.SetChildIndex(Me.btnClose, 0)
        Me.Controls.SetChildIndex(Me.mPaneCaption, 0)
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub

#End Region

    Private mUpdateDRGResults As DataTable

    Public Sub New(ByVal UpdateDRGResults As DataTable)
        MyBase.New()

        'This call is required by the Windows Form Designer.
        InitializeComponent()

        'Add any initialization after the InitializeComponent() call
        mUpdateDRGResults = UpdateDRGResults
        PopulateTextBoxWithResults()

    End Sub

    Private Sub btnClose_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnClose.Click
        Me.Close()
    End Sub

    Private Sub PopulateTextBoxWithResults()

        For Each row As DataRow In mUpdateDRGResults.Rows
            txtUpdateDRGResults.Text += row("RecordType").ToString & ": " & row("RecordCount").ToString & ControlChars.NewLine
        Next

    End Sub

    Private Sub btnCopyToClipboard_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnCopyToClipboard.Click

        'Show highlight on selected text
        txtUpdateDRGResults.HideSelection = False

        'Highlight the text
        txtUpdateDRGResults.SelectAll()

        'Copy To Clipboard
        My.Computer.Clipboard.SetText(txtUpdateDRGResults.Text)

    End Sub

    Private Sub frmUpdateDRGResults_Activated(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Activated

        'Automatically highlight the text incase the user immediatley hits CTRL+C.
        'The highlight will not visible however, because .HideSelection is set to true.
        txtUpdateDRGResults.SelectAll()

    End Sub
End Class
