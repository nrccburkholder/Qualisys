Imports Nrc.QualiSys.Library

Public Class DispositionNavigator
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
    Friend WithEvents LithoLabel As System.Windows.Forms.Label
    Friend WithEvents GroupBox1 As System.Windows.Forms.GroupBox
    Friend WithEvents SearchButton As System.Windows.Forms.Button
    Friend WithEvents LithoOption As System.Windows.Forms.RadioButton
    Friend WithEvents BarcodeOption As System.Windows.Forms.RadioButton
    Friend WithEvents WebAccessCodeOption As System.Windows.Forms.RadioButton
    Friend WithEvents SearchInput As System.Windows.Forms.TextBox
    Friend WithEvents SearchResultLabel As System.Windows.Forms.Label
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.LithoLabel = New System.Windows.Forms.Label
        Me.SearchInput = New System.Windows.Forms.TextBox
        Me.SearchButton = New System.Windows.Forms.Button
        Me.LithoOption = New System.Windows.Forms.RadioButton
        Me.BarcodeOption = New System.Windows.Forms.RadioButton
        Me.WebAccessCodeOption = New System.Windows.Forms.RadioButton
        Me.GroupBox1 = New System.Windows.Forms.GroupBox
        Me.SearchResultLabel = New System.Windows.Forms.Label
        Me.GroupBox1.SuspendLayout()
        Me.SuspendLayout()
        '
        'LithoLabel
        '
        Me.LithoLabel.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.LithoLabel.Location = New System.Drawing.Point(8, 128)
        Me.LithoLabel.Name = "LithoLabel"
        Me.LithoLabel.Size = New System.Drawing.Size(144, 23)
        Me.LithoLabel.TabIndex = 0
        Me.LithoLabel.Text = "Enter a value to search for:"
        Me.LithoLabel.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'SearchInput
        '
        Me.SearchInput.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.SearchInput.Location = New System.Drawing.Point(8, 152)
        Me.SearchInput.Name = "SearchInput"
        Me.SearchInput.Size = New System.Drawing.Size(144, 21)
        Me.SearchInput.TabIndex = 1
        Me.SearchInput.Text = ""
        '
        'SearchButton
        '
        Me.SearchButton.FlatStyle = System.Windows.Forms.FlatStyle.System
        Me.SearchButton.Location = New System.Drawing.Point(8, 184)
        Me.SearchButton.Name = "SearchButton"
        Me.SearchButton.TabIndex = 2
        Me.SearchButton.Text = "Search"
        '
        'LithoOption
        '
        Me.LithoOption.Checked = True
        Me.LithoOption.Location = New System.Drawing.Point(8, 16)
        Me.LithoOption.Name = "LithoOption"
        Me.LithoOption.TabIndex = 0
        Me.LithoOption.TabStop = True
        Me.LithoOption.Text = "Litho"
        '
        'BarcodeOption
        '
        Me.BarcodeOption.Location = New System.Drawing.Point(8, 40)
        Me.BarcodeOption.Name = "BarcodeOption"
        Me.BarcodeOption.TabIndex = 0
        Me.BarcodeOption.Text = "Barcode"
        '
        'WebAccessCodeOption
        '
        Me.WebAccessCodeOption.Location = New System.Drawing.Point(8, 64)
        Me.WebAccessCodeOption.Name = "WebAccessCodeOption"
        Me.WebAccessCodeOption.Size = New System.Drawing.Size(120, 24)
        Me.WebAccessCodeOption.TabIndex = 0
        Me.WebAccessCodeOption.Text = "Web Access Code"
        '
        'GroupBox1
        '
        Me.GroupBox1.Controls.Add(Me.LithoOption)
        Me.GroupBox1.Controls.Add(Me.BarcodeOption)
        Me.GroupBox1.Controls.Add(Me.WebAccessCodeOption)
        Me.GroupBox1.Location = New System.Drawing.Point(8, 8)
        Me.GroupBox1.Name = "GroupBox1"
        Me.GroupBox1.Size = New System.Drawing.Size(152, 96)
        Me.GroupBox1.TabIndex = 4
        Me.GroupBox1.TabStop = False
        Me.GroupBox1.Text = "Search By"
        '
        'SearchResultLabel
        '
        Me.SearchResultLabel.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.SearchResultLabel.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.SearchResultLabel.ForeColor = System.Drawing.Color.Red
        Me.SearchResultLabel.Location = New System.Drawing.Point(8, 216)
        Me.SearchResultLabel.Name = "SearchResultLabel"
        Me.SearchResultLabel.Size = New System.Drawing.Size(144, 23)
        Me.SearchResultLabel.TabIndex = 0
        Me.SearchResultLabel.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'DispositionNavigator
        '
        Me.BackColor = System.Drawing.SystemColors.Control
        Me.Controls.Add(Me.GroupBox1)
        Me.Controls.Add(Me.SearchButton)
        Me.Controls.Add(Me.SearchInput)
        Me.Controls.Add(Me.LithoLabel)
        Me.Controls.Add(Me.SearchResultLabel)
        Me.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Name = "DispositionNavigator"
        Me.Size = New System.Drawing.Size(168, 560)
        Me.GroupBox1.ResumeLayout(False)
        Me.ResumeLayout(False)

    End Sub

#End Region

#Region " MailingSelected Event "
    Public Class MailingSelectedEventArgs
        Inherits EventArgs

        Private mMailing As Mailing

        Public ReadOnly Property Mailing() As Mailing
            Get
                Return mMailing
            End Get
        End Property

        Public Sub New(ByVal selectedMailing As Mailing)
            mMailing = selectedMailing
        End Sub
    End Class
    Public Delegate Sub MailingSelectedEventHandler(ByVal sender As Object, ByVal e As MailingSelectedEventArgs)
    Public Event MailingSelected As MailingSelectedEventHandler
#End Region

    Private Enum SearchType
        Litho
        Barcode
        WAC
    End Enum

    Private Property SelectedSearchType() As SearchType
        Get
            If LithoOption.Checked Then
                Return SearchType.Litho
            ElseIf BarcodeOption.Checked Then
                Return SearchType.Barcode
            ElseIf WebAccessCodeOption.Checked Then
                Return SearchType.WAC
            Else
                Throw New Exception("Invalid search type.")
            End If
        End Get
        Set(ByVal Value As SearchType)
            Select Case Value
                Case SearchType.Barcode
                    BarcodeOption.Checked = True
                Case SearchType.Litho
                    LithoOption.Checked = True
                Case SearchType.WAC
                    WebAccessCodeOption.Checked = True
            End Select
        End Set
    End Property

    Private Sub SearchButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SearchButton.Click
        Dim mail As Mailing = Nothing
        Me.SearchResultLabel.Text = ""
        Me.SearchResultLabel.Refresh()
        Me.Cursor = Cursors.WaitCursor

        Try
            Select Case SelectedSearchType
                Case SearchType.Litho
                    mail = Mailing.GetMailingByLitho(SearchInput.Text)
                Case SearchType.Barcode
                    mail = Mailing.GetMailingByBarcode(SearchInput.Text)
                Case SearchType.WAC
                    mail = Mailing.GetMailingByWac(SearchInput.Text)
            End Select

            If mail Is Nothing Then
                Me.SearchResultLabel.Text = "No mailings match your search criteria."
            Else
                RaiseEvent MailingSelected(Me, New MailingSelectedEventArgs(mail))
            End If
        Finally
            Me.Cursor = Cursors.Default
        End Try
    End Sub

    Public Sub LoadMailing(ByVal mail As Mailing)
        SelectedSearchType = SearchType.Litho
        SearchInput.Text = mail.LithoCode
        SearchButton_Click(Me, Nothing)
    End Sub
End Class

