Public Class frmPopError
    Inherits System.Windows.Forms.Form

    Private mintFieldLength As Integer
    Dim menuTruncateType As clsPopValue.enuTruncateDialogOptions

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
    Friend WithEvents Label3 As System.Windows.Forms.Label
    Friend WithEvents lblFieldName As System.Windows.Forms.Label
    Friend WithEvents lblFieldLength As System.Windows.Forms.Label
    Friend WithEvents Label4 As System.Windows.Forms.Label
    Friend WithEvents txtFieldValue As System.Windows.Forms.TextBox
    Friend WithEvents lblLithoCode As System.Windows.Forms.Label
    Friend WithEvents Label6 As System.Windows.Forms.Label
    Friend WithEvents btnStop As System.Windows.Forms.Button
    Friend WithEvents btnOK As System.Windows.Forms.Button
    Friend WithEvents optLithoOnlyFieldOnly As System.Windows.Forms.RadioButton
    Friend WithEvents optLithoAllFieldOnly As System.Windows.Forms.RadioButton
    Friend WithEvents optLithoAllFieldAll As System.Windows.Forms.RadioButton
    Friend WithEvents optEdit As System.Windows.Forms.RadioButton
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.txtFieldValue = New System.Windows.Forms.TextBox
        Me.Label1 = New System.Windows.Forms.Label
        Me.Label2 = New System.Windows.Forms.Label
        Me.Label3 = New System.Windows.Forms.Label
        Me.lblFieldName = New System.Windows.Forms.Label
        Me.lblFieldLength = New System.Windows.Forms.Label
        Me.Label4 = New System.Windows.Forms.Label
        Me.optLithoOnlyFieldOnly = New System.Windows.Forms.RadioButton
        Me.optLithoAllFieldOnly = New System.Windows.Forms.RadioButton
        Me.optEdit = New System.Windows.Forms.RadioButton
        Me.lblLithoCode = New System.Windows.Forms.Label
        Me.Label6 = New System.Windows.Forms.Label
        Me.optLithoAllFieldAll = New System.Windows.Forms.RadioButton
        Me.btnStop = New System.Windows.Forms.Button
        Me.btnOK = New System.Windows.Forms.Button
        Me.SuspendLayout()
        '
        'txtFieldValue
        '
        Me.txtFieldValue.Location = New System.Drawing.Point(52, 216)
        Me.txtFieldValue.Multiline = True
        Me.txtFieldValue.Name = "txtFieldValue"
        Me.txtFieldValue.ScrollBars = System.Windows.Forms.ScrollBars.Vertical
        Me.txtFieldValue.Size = New System.Drawing.Size(344, 60)
        Me.txtFieldValue.TabIndex = 0
        Me.txtFieldValue.Text = ""
        '
        'Label1
        '
        Me.Label1.Location = New System.Drawing.Point(16, 12)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(392, 28)
        Me.Label1.TabIndex = 1
        Me.Label1.Text = "The value being saved to the specified Population metafield for this LithoCode ex" & _
        "ceeds the size of the field."
        '
        'Label2
        '
        Me.Label2.Location = New System.Drawing.Point(36, 72)
        Me.Label2.Name = "Label2"
        Me.Label2.Size = New System.Drawing.Size(60, 16)
        Me.Label2.TabIndex = 2
        Me.Label2.Text = "Metafield:"
        '
        'Label3
        '
        Me.Label3.Location = New System.Drawing.Point(236, 72)
        Me.Label3.Name = "Label3"
        Me.Label3.Size = New System.Drawing.Size(48, 16)
        Me.Label3.TabIndex = 3
        Me.Label3.Text = "Length:"
        '
        'lblFieldName
        '
        Me.lblFieldName.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lblFieldName.Location = New System.Drawing.Point(96, 72)
        Me.lblFieldName.Name = "lblFieldName"
        Me.lblFieldName.Size = New System.Drawing.Size(124, 16)
        Me.lblFieldName.TabIndex = 4
        '
        'lblFieldLength
        '
        Me.lblFieldLength.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lblFieldLength.Location = New System.Drawing.Point(284, 72)
        Me.lblFieldLength.Name = "lblFieldLength"
        Me.lblFieldLength.Size = New System.Drawing.Size(28, 16)
        Me.lblFieldLength.TabIndex = 5
        Me.lblFieldLength.TextAlign = System.Drawing.ContentAlignment.TopRight
        '
        'Label4
        '
        Me.Label4.Location = New System.Drawing.Point(16, 96)
        Me.Label4.Name = "Label4"
        Me.Label4.Size = New System.Drawing.Size(308, 16)
        Me.Label4.TabIndex = 6
        Me.Label4.Text = "How do you wish to proceed?"
        '
        'optLithoOnlyFieldOnly
        '
        Me.optLithoOnlyFieldOnly.Checked = True
        Me.optLithoOnlyFieldOnly.Location = New System.Drawing.Point(36, 120)
        Me.optLithoOnlyFieldOnly.Name = "optLithoOnlyFieldOnly"
        Me.optLithoOnlyFieldOnly.Size = New System.Drawing.Size(372, 16)
        Me.optLithoOnlyFieldOnly.TabIndex = 7
        Me.optLithoOnlyFieldOnly.TabStop = True
        Me.optLithoOnlyFieldOnly.Text = "Truncate the value to fit (THIS LithoCode and MetaField ONLY)"
        '
        'optLithoAllFieldOnly
        '
        Me.optLithoAllFieldOnly.Location = New System.Drawing.Point(36, 144)
        Me.optLithoAllFieldOnly.Name = "optLithoAllFieldOnly"
        Me.optLithoAllFieldOnly.Size = New System.Drawing.Size(372, 16)
        Me.optLithoAllFieldOnly.TabIndex = 8
        Me.optLithoAllFieldOnly.Text = "Truncate the value to fit (ALL LithoCodes and THIS MetaFields ONLY)"
        '
        'optEdit
        '
        Me.optEdit.Location = New System.Drawing.Point(36, 192)
        Me.optEdit.Name = "optEdit"
        Me.optEdit.Size = New System.Drawing.Size(372, 16)
        Me.optEdit.TabIndex = 9
        Me.optEdit.Text = "Edit the value to fit"
        '
        'lblLithoCode
        '
        Me.lblLithoCode.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lblLithoCode.Location = New System.Drawing.Point(96, 48)
        Me.lblLithoCode.Name = "lblLithoCode"
        Me.lblLithoCode.Size = New System.Drawing.Size(124, 16)
        Me.lblLithoCode.TabIndex = 11
        '
        'Label6
        '
        Me.Label6.Location = New System.Drawing.Point(36, 48)
        Me.Label6.Name = "Label6"
        Me.Label6.Size = New System.Drawing.Size(60, 16)
        Me.Label6.TabIndex = 10
        Me.Label6.Text = "LithoCode:"
        '
        'optLithoAllFieldAll
        '
        Me.optLithoAllFieldAll.Location = New System.Drawing.Point(36, 168)
        Me.optLithoAllFieldAll.Name = "optLithoAllFieldAll"
        Me.optLithoAllFieldAll.Size = New System.Drawing.Size(372, 16)
        Me.optLithoAllFieldAll.TabIndex = 12
        Me.optLithoAllFieldAll.Text = "Truncate the value to fit (ALL LithoCodes and ALL MetaFields)"
        '
        'btnStop
        '
        Me.btnStop.Location = New System.Drawing.Point(280, 288)
        Me.btnStop.Name = "btnStop"
        Me.btnStop.Size = New System.Drawing.Size(116, 28)
        Me.btnStop.TabIndex = 13
        Me.btnStop.Text = "STOP Processing File"
        '
        'btnOK
        '
        Me.btnOK.Location = New System.Drawing.Point(156, 288)
        Me.btnOK.Name = "btnOK"
        Me.btnOK.Size = New System.Drawing.Size(116, 28)
        Me.btnOK.TabIndex = 14
        Me.btnOK.Text = "OK"
        '
        'frmPopError
        '
        Me.AutoScaleBaseSize = New System.Drawing.Size(5, 14)
        Me.ClientSize = New System.Drawing.Size(412, 333)
        Me.ControlBox = False
        Me.Controls.Add(Me.btnOK)
        Me.Controls.Add(Me.btnStop)
        Me.Controls.Add(Me.optLithoAllFieldAll)
        Me.Controls.Add(Me.lblLithoCode)
        Me.Controls.Add(Me.Label6)
        Me.Controls.Add(Me.optEdit)
        Me.Controls.Add(Me.optLithoAllFieldOnly)
        Me.Controls.Add(Me.optLithoOnlyFieldOnly)
        Me.Controls.Add(Me.Label4)
        Me.Controls.Add(Me.lblFieldLength)
        Me.Controls.Add(Me.lblFieldName)
        Me.Controls.Add(Me.Label3)
        Me.Controls.Add(Me.Label2)
        Me.Controls.Add(Me.Label1)
        Me.Controls.Add(Me.txtFieldValue)
        Me.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog
        Me.MaximizeBox = False
        Me.MinimizeBox = False
        Me.Name = "frmPopError"
        Me.ShowInTaskbar = False
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen
        Me.Text = "Population Metafield Length Exception"
        Me.ResumeLayout(False)

    End Sub

#End Region

    Public Sub New(ByVal strLithoCode As String, ByVal strFieldName As String, _
                   ByVal intFieldLength As Integer, ByVal strFieldValue As String)

        MyBase.New()

        'This call is required by the Windows Form Designer.
        InitializeComponent()

        'Setup the screen
        lblLithoCode.Text = strLithoCode
        lblFieldName.Text = strFieldName
        lblFieldLength.Text = intFieldLength.ToString
        mintFieldLength = intFieldLength
        txtFieldValue.Text = strFieldValue

    End Sub

    Private Sub btnOK_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnOK.Click

        Dim strMsg As String

        'There are cases when we need to prompt the user for confirmation
        If optLithoOnlyFieldOnly.Checked Then
            'User wants to truncate this field for this litho only
            menuTruncateType = clsPopValue.enuTruncateDialogOptions.enuTDOTruncateLithoOnlyFieldOnly
            DialogResult = DialogResult.OK
        ElseIf optLithoAllFieldOnly.Checked Then
            'User wants to truncate this field for all lithos
            strMsg = "You have selected to truncate the '" & lblFieldName.Text & "' metafield" & vbCrLf & _
                     "to a length of " & lblFieldLength.Text & " characters for ALL LithoCodes!"
            If MessageBox.Show(strMsg, Application.ProductName, MessageBoxButtons.OKCancel, MessageBoxIcon.Warning, MessageBoxDefaultButton.Button2) = DialogResult.OK Then
                menuTruncateType = clsPopValue.enuTruncateDialogOptions.enuTDOTruncateLithoAllFieldOnly
                DialogResult = DialogResult.OK
            End If
        ElseIf optLithoAllFieldAll.Checked Then
            'User wants to truncate all fields for all lithos
            strMsg = "You have selected to truncate ALL metafields to the maximum" & vbCrLf & _
                     "length for each field for ALL LithoCodes!"
            If MessageBox.Show(strMsg, Application.ProductName, MessageBoxButtons.OKCancel, MessageBoxIcon.Warning, MessageBoxDefaultButton.Button2) = DialogResult.OK Then
                menuTruncateType = clsPopValue.enuTruncateDialogOptions.enuTDOTruncateLithoAllFieldAll
                DialogResult = DialogResult.OK
            End If
        ElseIf optEdit.Checked Then
            'The user wants to edit the string
            If txtFieldValue.Text.Length > mintFieldLength Then
                'The string is still to long
                strMsg = "The maximum length of the value is " & lblFieldLength.Text & " characters!" & vbCrLf & vbCrLf & _
                         "The current value is " & txtFieldValue.Text.Length.ToString & " characters." & vbCrLf & vbCrLf & _
                         "Please shorten the value."
                MessageBox.Show(strMsg, Application.ProductName, MessageBoxButtons.OK, MessageBoxIcon.Error, MessageBoxDefaultButton.Button1)
            Else
                'The string is good to go
                menuTruncateType = clsPopValue.enuTruncateDialogOptions.enuTDOEdited
                DialogResult = DialogResult.OK
            End If
        End If

    End Sub

    Private Sub btnStop_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnStop.Click

        'Let's make sure this is what the user wants to do
        Dim strMsg As String = "You have selected to stop processing this file!" & vbCrLf & vbCrLf & _
                               "All records processed prior to this one have already" & vbCrLf & _
                               "been saved to the database and will not be rolled back." & vbCrLf & vbCrLf & _
                               "Do you wish to stop processing this file?"
        If MessageBox.Show(strMsg, Application.ProductName, MessageBoxButtons.YesNo, MessageBoxIcon.Warning, MessageBoxDefaultButton.Button2) = DialogResult.Yes Then
            'The user really wants to stop processing
            DialogResult = DialogResult.Abort
        End If

    End Sub

    Public ReadOnly Property TruncateType() As clsPopValue.enuTruncateDialogOptions
        Get
            Return menuTruncateType
        End Get
    End Property

    Public ReadOnly Property FieldValue() As String
        Get
            Return txtFieldValue.Text.Trim
        End Get
    End Property

End Class
