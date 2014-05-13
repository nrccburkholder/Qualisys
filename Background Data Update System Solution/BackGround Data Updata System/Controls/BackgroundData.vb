Public Class BackgroundData
    Inherits System.Windows.Forms.UserControl

    Public Enum enuDataTypeConstants
        enuDTCText = 0
        enuDTCTextList = 1
        enuDTCNumeric = 2
        enuDTCNumericList = 3
        enuDTCDate = 4
        enuDTCDateList = 5
    End Enum

    Private menuDataType As enuDataTypeConstants = enuDataTypeConstants.enuDTCText
    Private mintMaxLength As Integer = 42
    Private mstrValidValues As String
    Private mbolRequired As Boolean



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
    Friend WithEvents lblBGData As System.Windows.Forms.Label
    Friend WithEvents txtBGData As System.Windows.Forms.TextBox
    Friend WithEvents nudBGData As System.Windows.Forms.NumericUpDown
    Friend WithEvents dtpBGData As System.Windows.Forms.DateTimePicker
    Friend WithEvents cboBGData As System.Windows.Forms.ComboBox
    Friend WithEvents chkDateBlank As System.Windows.Forms.CheckBox
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.lblBGData = New System.Windows.Forms.Label
        Me.txtBGData = New System.Windows.Forms.TextBox
        Me.nudBGData = New System.Windows.Forms.NumericUpDown
        Me.dtpBGData = New System.Windows.Forms.DateTimePicker
        Me.cboBGData = New System.Windows.Forms.ComboBox
        Me.chkDateBlank = New System.Windows.Forms.CheckBox
        CType(Me.nudBGData, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SuspendLayout()
        '
        'lblBGData
        '
        Me.lblBGData.Location = New System.Drawing.Point(4, 8)
        Me.lblBGData.Name = "lblBGData"
        Me.lblBGData.Size = New System.Drawing.Size(116, 16)
        Me.lblBGData.TabIndex = 0
        '
        'txtBGData
        '
        Me.txtBGData.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.txtBGData.Location = New System.Drawing.Point(120, 4)
        Me.txtBGData.Name = "txtBGData"
        Me.txtBGData.Size = New System.Drawing.Size(172, 20)
        Me.txtBGData.TabIndex = 1
        '
        'nudBGData
        '
        Me.nudBGData.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.nudBGData.Location = New System.Drawing.Point(120, 4)
        Me.nudBGData.Maximum = New Decimal(New Integer() {2147483647, 0, 0, 0})
        Me.nudBGData.Name = "nudBGData"
        Me.nudBGData.Size = New System.Drawing.Size(172, 20)
        Me.nudBGData.TabIndex = 2
        '
        'dtpBGData
        '
        Me.dtpBGData.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.dtpBGData.CustomFormat = "MM/dd/yyyy"
        Me.dtpBGData.Format = System.Windows.Forms.DateTimePickerFormat.Custom
        Me.dtpBGData.Location = New System.Drawing.Point(184, 4)
        Me.dtpBGData.Name = "dtpBGData"
        Me.dtpBGData.Size = New System.Drawing.Size(108, 20)
        Me.dtpBGData.TabIndex = 3
        '
        'cboBGData
        '
        Me.cboBGData.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.cboBGData.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.cboBGData.Location = New System.Drawing.Point(120, 4)
        Me.cboBGData.Name = "cboBGData"
        Me.cboBGData.Size = New System.Drawing.Size(172, 21)
        Me.cboBGData.TabIndex = 4
        '
        'chkDateBlank
        '
        Me.chkDateBlank.Location = New System.Drawing.Point(120, 4)
        Me.chkDateBlank.Name = "chkDateBlank"
        Me.chkDateBlank.Size = New System.Drawing.Size(64, 20)
        Me.chkDateBlank.TabIndex = 5
        Me.chkDateBlank.Text = "Blank"
        '
        'BackgroundData
        '
        Me.Controls.Add(Me.chkDateBlank)
        Me.Controls.Add(Me.dtpBGData)
        Me.Controls.Add(Me.cboBGData)
        Me.Controls.Add(Me.nudBGData)
        Me.Controls.Add(Me.txtBGData)
        Me.Controls.Add(Me.lblBGData)
        Me.Name = "BackgroundData"
        Me.Size = New System.Drawing.Size(300, 28)
        CType(Me.nudBGData, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub

#End Region

    Public Sub New(ByVal strFieldName As String, ByVal strDataType As String, ByVal intMaxLength As Integer, _
                   ByVal strValidValues As String, ByVal bolRequired As Boolean)

        'Execute the base class New
        MyBase.New()

        'This call is required by the Windows Form Designer.
        InitializeComponent()

        'Setup the control
        FieldName = strFieldName
        ValidValues = strValidValues.Trim
        Required = bolRequired
        If strValidValues.Length = 0 Then
            Select Case strDataType
                Case "S"    'String
                    DataType = enuDataTypeConstants.enuDTCText
                    MaxLength = intMaxLength
                Case "I"    'Numeric
                    DataType = enuDataTypeConstants.enuDTCNumeric
                Case "D"    'Date
                    DataType = enuDataTypeConstants.enuDTCDate
            End Select
        Else
            Select Case strDataType
                Case "S"    'String
                    DataType = enuDataTypeConstants.enuDTCTextList
                    MaxLength = intMaxLength
                Case "I"    'Numeric
                    DataType = enuDataTypeConstants.enuDTCNumericList
                Case "D"    'Date
                    DataType = enuDataTypeConstants.enuDTCDateList
            End Select
        End If

    End Sub


    Public Property FieldName() As String
        Get
            Return lblBGData.Text
        End Get
        Set(ByVal Value As String)
            lblBGData.Text = Value
        End Set
    End Property


    Public Property Data() As Object
        Get
            Select Case menuDataType
                Case enuDataTypeConstants.enuDTCText
                    Return txtBGData.Text

                Case enuDataTypeConstants.enuDTCTextList
                    Return cboBGData.Text

                Case enuDataTypeConstants.enuDTCNumeric
                    Return nudBGData.Value

                Case enuDataTypeConstants.enuDTCNumericList
                    Return Val(cboBGData.Text)

                Case enuDataTypeConstants.enuDTCDate
                    Return dtpBGData.Value

                Case enuDataTypeConstants.enuDTCDateList
                    Try
                        Return CType(cboBGData.Text, Date)
                    Catch
                        Return Globals.gdatMinDate
                    End Try
                Case Else
                    Throw New ApplicationException( _
                        String.Format("No case statement for {0} enum type.", _
                        System.Enum.GetName(GetType(enuDataTypeConstants), menuDataType)))
            End Select
        End Get
        Set(ByVal Value As Object)
            Select Case menuDataType
                Case enuDataTypeConstants.enuDTCText
                    txtBGData.Text = Value

                Case enuDataTypeConstants.enuDTCTextList
                    cboBGData.Text = Value

                Case enuDataTypeConstants.enuDTCNumeric
                    nudBGData.Value = Value

                Case enuDataTypeConstants.enuDTCNumericList
                    cboBGData.Text = Value.ToString

                Case enuDataTypeConstants.enuDTCDate
                    If Value = Globals.gdatMinDate Then
                        chkDateBlank.Checked = True
                    Else
                        chkDateBlank.Checked = False
                    End If
                    dtpBGData.Value = Value

                Case enuDataTypeConstants.enuDTCDateList
                    cboBGData.Text = Format(CType(Value, Date), "MM/dd/yyyy")

            End Select
        End Set
    End Property


    Public Property DataType() As enuDataTypeConstants
        Get
            Return menuDataType
        End Get
        Set(ByVal Value As enuDataTypeConstants)
            menuDataType = Value

            txtBGData.Visible = False
            nudBGData.Visible = False
            dtpBGData.Visible = False
            cboBGData.Visible = False
            chkDateBlank.Visible = False
            Select Case menuDataType
                Case enuDataTypeConstants.enuDTCText
                    txtBGData.Visible = True

                Case enuDataTypeConstants.enuDTCNumeric
                    nudBGData.Visible = True

                Case enuDataTypeConstants.enuDTCDate
                    dtpBGData.Visible = True
                    dtpBGData.Enabled = False
                    chkDateBlank.Visible = True
                    chkDateBlank.Checked = True

                Case enuDataTypeConstants.enuDTCTextList, enuDataTypeConstants.enuDTCNumericList, enuDataTypeConstants.enuDTCDateList
                    cboBGData.Visible = True

            End Select
        End Set
    End Property


    Public Property MaxLength() As Integer
        Get
            Return mintMaxLength
        End Get
        Set(ByVal Value As Integer)
            mintMaxLength = Value
            txtBGData.MaxLength = mintMaxLength
        End Set
    End Property


    Public Property Required() As Boolean
        Get
            Return mbolRequired
        End Get
        Set(ByVal Value As Boolean)
            mbolRequired = Value
        End Set
    End Property


    Public Property ValidValues() As String
        Get
            Return mstrValidValues
        End Get
        Set(ByVal Value As String)
            'Save the value
            mstrValidValues = Value.Trim

            'Populate the dropdown list
            If mstrValidValues.Length > 0 Then cboBGData.Items.AddRange(mstrValidValues.Split(","))
        End Set
    End Property


    Public Function IsDataValid(ByRef strMsg As String) As Boolean

        Dim intCnt As Integer
        Dim bolFound As Boolean

        Select Case menuDataType
            Case enuDataTypeConstants.enuDTCText
                If txtBGData.Text.Trim.Length = 0 And mbolRequired Then
                    strMsg = FieldName & " cannot be blank!"
                    Me.Focus()
                ElseIf txtBGData.Text.Trim.Length > mintMaxLength Then
                    strMsg = FieldName & " is limited to " & mintMaxLength.ToString & " characters!"
                    Me.Focus()
                End If

            Case enuDataTypeConstants.enuDTCTextList
                If cboBGData.Text.Trim.Length = 0 And mbolRequired Then
                    strMsg = "Please select value for " & FieldName & "!"
                    Me.Focus()
                ElseIf cboBGData.Text.Trim.Length > 0 Then
                    bolFound = False
                    For intCnt = 0 To cboBGData.Items.Count - 1
                        If cboBGData.Text = cboBGData.Items(intCnt) Then
                            bolFound = True
                            Exit For
                        End If
                    Next
                    If Not bolFound Then
                        strMsg = "Please select a value for " & FieldName & " from the list!"
                        Me.Focus()
                    End If
                End If

            Case enuDataTypeConstants.enuDTCNumeric
                If nudBGData.Text.Length = 0 And mbolRequired Then
                    strMsg = FieldName & " cannot be blank!"
                    Me.Focus()
                End If

            Case enuDataTypeConstants.enuDTCNumericList
                If cboBGData.Text.Trim.Length = 0 And mbolRequired Then
                    strMsg = "Please select value for " & FieldName & "!"
                    Me.Focus()
                ElseIf cboBGData.Text.Trim.Length > 0 Then
                    bolFound = False
                    For intCnt = 0 To cboBGData.Items.Count - 1
                        If cboBGData.Text = cboBGData.Items(intCnt) Then
                            bolFound = True
                            Exit For
                        End If
                    Next
                    If Not bolFound Then
                        strMsg = "Please select a value for " & FieldName & " from the list!"
                        Me.Focus()
                    End If
                End If

            Case enuDataTypeConstants.enuDTCDate
                If dtpBGData.Value = Globals.gdatMinDate And mbolRequired Then
                    strMsg = "Please enter a date for " & FieldName & "!"
                    Me.Focus()
                End If

            Case enuDataTypeConstants.enuDTCDateList
                If cboBGData.Text.Trim.Length = 0 And mbolRequired Then
                    strMsg = "Please select value for " & FieldName & "!"
                    Me.Focus()
                ElseIf cboBGData.Text.Trim.Length > 0 Then
                    bolFound = False
                    For intCnt = 0 To cboBGData.Items.Count - 1
                        If cboBGData.Text = cboBGData.Items(intCnt) Then
                            bolFound = True
                            Exit For
                        End If
                    Next
                    If Not bolFound Then
                        strMsg = "Please select a value for " & FieldName & " from the list!"
                        Me.Focus()
                    End If
                End If

        End Select

        'Determine the return value
        If strMsg.Length > 0 Then
            Return False
        Else
            Return True
        End If

    End Function


    Public ReadOnly Property SetClause() As String
        Get
            Select Case menuDataType
                Case enuDataTypeConstants.enuDTCText
                    Return FieldName & " = " & IIf(txtBGData.Text.Trim.Length = 0, "NULL", "'" & Globals.ReplaceQuotes(txtBGData.Text.Trim) & "'")

                Case enuDataTypeConstants.enuDTCTextList
                    Return FieldName & " = " & IIf(cboBGData.Text.Trim.Length = 0, "NULL", "'" & Globals.ReplaceQuotes(cboBGData.Text.Trim) & "'")

                Case enuDataTypeConstants.enuDTCNumeric
                    Return FieldName & " = " & IIf(nudBGData.Text.Trim.Length = 0, "NULL", nudBGData.Value.ToString)

                Case enuDataTypeConstants.enuDTCNumericList
                    Return FieldName & " = " & IIf(cboBGData.Text.Trim.Length = 0, "NULL", Val(cboBGData.Text).ToString)

                Case enuDataTypeConstants.enuDTCDate
                    Return FieldName & " = " & IIf(dtpBGData.Value = Globals.gdatMinDate, "NULL", "'" & Format(dtpBGData.Value, "MM/dd/yyyy") & "'")

                Case enuDataTypeConstants.enuDTCDateList
                    Return FieldName & " = " & IIf(cboBGData.Text.Trim.Length = 0, "NULL", "'" & Format(CDate(cboBGData.Text), "MM/dd/yyyy") & "'")

                Case Else
                    Throw New ApplicationException( _
                        String.Format("No case statement for {0} enum type.", _
                        System.Enum.GetName(GetType(enuDataTypeConstants), menuDataType)))
            End Select
        End Get
    End Property

    Private Sub nudBGData_Enter(ByVal sender As Object, ByVal e As System.EventArgs) Handles nudBGData.Enter

        'Select all text in the edit portion
        If nudBGData.Text.Length > 0 Then
            nudBGData.Select(0, nudBGData.Text.Length)
        End If

    End Sub

    Private Sub txtBGData_Enter(ByVal sender As Object, ByVal e As System.EventArgs) Handles txtBGData.Enter

        'Select all text in the edit portion
        If txtBGData.Text.Length > 0 Then
            txtBGData.Select(0, txtBGData.Text.Length)
        End If

    End Sub

    Private Sub chkDateBlank_CheckedChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles chkDateBlank.CheckedChanged

        If chkDateBlank.Checked Then
            dtpBGData.Enabled = False
            dtpBGData.Value = Globals.gdatMinDate
        Else
            dtpBGData.Enabled = True
            dtpBGData.Value = Date.Now
        End If

    End Sub
End Class
