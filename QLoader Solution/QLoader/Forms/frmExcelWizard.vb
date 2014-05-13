Option Explicit On 
Option Strict On

Public Class frmExcelWizard
    Inherits NRC.Framework.WinForms.DialogForm

#Region " Private Members "

    'Private mHasHeader As Boolean
    'Private mColumns As ColumnCollection
    'Private mFields()() As String
    Private mExcelDataCtrl As ExcelDataCtrl

#End Region

#Region " Public Properties "

    Public Property ExcelDataCtrl() As ExcelDataCtrl
        Get
            Return mExcelDataCtrl
        End Get
        Set(ByVal Value As ExcelDataCtrl)
            mExcelDataCtrl = Value
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
    Friend WithEvents GroupBox4 As System.Windows.Forms.GroupBox
    Friend WithEvents Label8 As System.Windows.Forms.Label
    Friend WithEvents btnOK As System.Windows.Forms.Button
    Friend WithEvents btnCancel As System.Windows.Forms.Button
    Friend WithEvents ctlColumn As TextColumn
    Friend WithEvents Label7 As System.Windows.Forms.Label
    Friend WithEvents chkHasHeader As System.Windows.Forms.CheckBox
    Friend WithEvents txtColumnName As MyTextBox
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.ctlColumn = New TextColumn
        Me.GroupBox4 = New System.Windows.Forms.GroupBox
        Me.txtColumnName = New MyTextBox
        Me.Label8 = New System.Windows.Forms.Label
        Me.btnOK = New System.Windows.Forms.Button
        Me.btnCancel = New System.Windows.Forms.Button
        Me.chkHasHeader = New System.Windows.Forms.CheckBox
        Me.Label7 = New System.Windows.Forms.Label
        Me.GroupBox4.SuspendLayout()
        Me.SuspendLayout()
        '
        'mPaneCaption
        '
        Me.mPaneCaption.Caption = "Import Excel Wizard"
        Me.mPaneCaption.Name = "mPaneCaption"
        Me.mPaneCaption.Size = New System.Drawing.Size(686, 26)
        '
        'ctlColumn
        '
        Me.ctlColumn.CanSelectColumn = False
        Me.ctlColumn.Columns = Nothing
        Me.ctlColumn.DrawColumnBorder = True
        Me.ctlColumn.Font = New System.Drawing.Font("Courier New", 9.75!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.ctlColumn.Location = New System.Drawing.Point(40, 200)
        Me.ctlColumn.Name = "ctlColumn"
        Me.ctlColumn.SelectedColumn = -1
        Me.ctlColumn.SelectedColumnName = ""
        Me.ctlColumn.ShowHeader = False
        Me.ctlColumn.Size = New System.Drawing.Size(608, 184)
        Me.ctlColumn.TabIndex = 3
        '
        'GroupBox4
        '
        Me.GroupBox4.Controls.Add(Me.txtColumnName)
        Me.GroupBox4.Controls.Add(Me.Label8)
        Me.GroupBox4.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.GroupBox4.Location = New System.Drawing.Point(40, 104)
        Me.GroupBox4.Name = "GroupBox4"
        Me.GroupBox4.Size = New System.Drawing.Size(608, 56)
        Me.GroupBox4.TabIndex = 1
        Me.GroupBox4.TabStop = False
        Me.GroupBox4.Text = "Field Options"
        '
        'txtColumnName
        '
        Me.txtColumnName.Location = New System.Drawing.Point(88, 24)
        Me.txtColumnName.MaxLength = 128
        Me.txtColumnName.Name = "txtColumnName"
        Me.txtColumnName.Size = New System.Drawing.Size(504, 21)
        Me.txtColumnName.TabIndex = 1
        Me.txtColumnName.Text = ""
        '
        'Label8
        '
        Me.Label8.Location = New System.Drawing.Point(8, 24)
        Me.Label8.Name = "Label8"
        Me.Label8.Size = New System.Drawing.Size(72, 20)
        Me.Label8.TabIndex = 0
        Me.Label8.Text = "Field Na&me:"
        Me.Label8.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'btnOK
        '
        Me.btnOK.FlatStyle = System.Windows.Forms.FlatStyle.System
        Me.btnOK.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.btnOK.Location = New System.Drawing.Point(496, 408)
        Me.btnOK.Name = "btnOK"
        Me.btnOK.TabIndex = 4
        Me.btnOK.Text = "OK"
        '
        'btnCancel
        '
        Me.btnCancel.DialogResult = System.Windows.Forms.DialogResult.Cancel
        Me.btnCancel.FlatStyle = System.Windows.Forms.FlatStyle.System
        Me.btnCancel.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.btnCancel.Location = New System.Drawing.Point(576, 408)
        Me.btnCancel.Name = "btnCancel"
        Me.btnCancel.TabIndex = 5
        Me.btnCancel.Text = "Cancel"
        '
        'chkHasHeader
        '
        Me.chkHasHeader.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.chkHasHeader.Location = New System.Drawing.Point(40, 160)
        Me.chkHasHeader.Name = "chkHasHeader"
        Me.chkHasHeader.Size = New System.Drawing.Size(200, 24)
        Me.chkHasHeader.TabIndex = 2
        Me.chkHasHeader.Text = "First &Row Contains Field Names"
        '
        'Label7
        '
        Me.Label7.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label7.Location = New System.Drawing.Point(40, 48)
        Me.Label7.Name = "Label7"
        Me.Label7.Size = New System.Drawing.Size(608, 48)
        Me.Label7.TabIndex = 0
        Me.Label7.Text = "You can specify information about each of the fields you are importing. Select fi" & _
        "elds in the area below. You can then modify field information in the 'Field Opti" & _
        "ons' area.  Pressing the TAB key selects the next column forward. SHIFT-TAB sele" & _
        "cts the previous column backward."
        '
        'frmExcelWizard
        '
        Me.AcceptButton = Me.btnOK
        Me.AutoScaleBaseSize = New System.Drawing.Size(5, 13)
        Me.CancelButton = Me.btnCancel
        Me.Caption = "Import Excel Wizard"
        Me.ClientSize = New System.Drawing.Size(688, 464)
        Me.Controls.Add(Me.Label7)
        Me.Controls.Add(Me.chkHasHeader)
        Me.Controls.Add(Me.btnCancel)
        Me.Controls.Add(Me.btnOK)
        Me.Controls.Add(Me.GroupBox4)
        Me.Controls.Add(Me.ctlColumn)
        Me.DockPadding.All = 1
        Me.MaximizeBox = False
        Me.MinimizeBox = False
        Me.Name = "frmExcelWizard"
        Me.Text = "frmExcelWizard"
        Me.Controls.SetChildIndex(Me.ctlColumn, 0)
        Me.Controls.SetChildIndex(Me.GroupBox4, 0)
        Me.Controls.SetChildIndex(Me.btnOK, 0)
        Me.Controls.SetChildIndex(Me.btnCancel, 0)
        Me.Controls.SetChildIndex(Me.chkHasHeader, 0)
        Me.Controls.SetChildIndex(Me.Label7, 0)
        Me.Controls.SetChildIndex(Me.mPaneCaption, 0)
        Me.GroupBox4.ResumeLayout(False)
        Me.ResumeLayout(False)

    End Sub

#End Region

#Region " Event Handlers "

    Private Sub frmExcelWizard_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        chkHasHeader.Checked = mExcelDataCtrl.HasHeader
        With ctlColumn
            .ShowHeader = True
            .Columns = mExcelDataCtrl.Columns
            .Fields = mExcelDataCtrl.Fields
            .CanSelectColumn = True
            .DrawColumnBorder = True
            .ResetPosition()
            .SelectedColumn = 0
        End With
    End Sub


    Private Sub chkHasHeader_CheckedChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles chkHasHeader.CheckedChanged
        If (mExcelDataCtrl.HasHeader = chkHasHeader.Checked) Then Return

        mExcelDataCtrl.HasHeader = chkHasHeader.Checked
        With ctlColumn
            .Columns = mExcelDataCtrl.Columns
            .Fields = mExcelDataCtrl.Fields
            .ResetPosition()
            .SelectedColumn = 0
        End With

    End Sub


    Private Sub ctlColumn_ColumnSelected(ByVal columnName As String, ByVal columnLength As Integer) Handles ctlColumn.ColumnSelected
        txtColumnName.Text = ctlColumn.SelectedColumnName
    End Sub

    Private Sub txtColumnName_TextChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles txtColumnName.TextChanged
        ctlColumn.SelectedColumnName = Trim(txtColumnName.Text)
    End Sub

    Private Sub txtColumnName_Moving(ByVal direction As MoveDirections) Handles txtColumnName.Moving
        ctlColumn.Moving(direction)
    End Sub

    Private Sub ctlColumn_Enter(ByVal sender As Object, ByVal e As System.EventArgs) Handles ctlColumn.Enter
        txtColumnName.Focus()
    End Sub

    Private Sub btnOK_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnOK.Click
        If (Not ValidateFieldNameTab()) Then Return
        DialogResult = Windows.Forms.DialogResult.OK
    End Sub

    Private Sub btnCancel_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnCancel.Click
        DialogResult = Windows.Forms.DialogResult.Cancel
    End Sub

    Private Sub frmTextWizard_Paint(ByVal sender As Object, ByVal e As System.Windows.Forms.PaintEventArgs) Handles MyBase.Paint
        Dim penBorder As New Pen(Color.FromArgb(0, 45, 150))
        Dim g As Graphics = e.Graphics

        'Top Border
        g.DrawLine(penBorder, 0, 0, Me.Width - 1, 0)
        'Bottom Border
        g.DrawLine(penBorder, 0, Me.Height - 1, Me.Width - 1, Me.Height - 1)
        'Left Border
        g.DrawLine(penBorder, 0, 0, 0, Me.Height - 1)
        'Right Border
        g.DrawLine(penBorder, Me.Width - 1, 0, Me.Width - 1, Me.Height - 1)

    End Sub

#End Region

#Region " Private Methods "

    Private Function ValidateFieldNameTab() As Boolean
        Dim errColumn As Integer
        Dim errMsg As String = ""

        If (Not mExcelDataCtrl.ValidateColumnName(errColumn, errMsg)) Then
            ctlColumn.SelectedColumn = errColumn
            ctlColumn.VisibleColumn(errColumn)
            errMsg = "Column name error." + vbCrLf + vbCrLf + errMsg
            MessageBox.Show(errMsg, "Excel Import Wizard", MessageBoxButtons.OK, MessageBoxIcon.Error)
            Return (False)
        Else
            Return (True)
        End If

    End Function

#End Region

End Class
