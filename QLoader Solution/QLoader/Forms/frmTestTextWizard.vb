Option Explicit On 
Option Strict On

Public Class frmTestTextWizard
    Inherits System.Windows.Forms.Form

    'Private m_dtsTextData As DTSTextData
    Private m_templateFile As DataFile

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
    Friend WithEvents btnTextWizard As System.Windows.Forms.Button
    Friend WithEvents Label1 As System.Windows.Forms.Label
    Friend WithEvents Label3 As System.Windows.Forms.Label
    Friend WithEvents lblDelimiter As System.Windows.Forms.Label
    Friend WithEvents Label5 As System.Windows.Forms.Label
    Friend WithEvents lblQualifier As System.Windows.Forms.Label
    Friend WithEvents Label7 As System.Windows.Forms.Label
    Friend WithEvents lblHasHeader As System.Windows.Forms.Label
    Friend WithEvents lstColumns As System.Windows.Forms.ListBox
    Friend WithEvents Label9 As System.Windows.Forms.Label
    Friend WithEvents lblIsDelimited As System.Windows.Forms.Label
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.btnTextWizard = New System.Windows.Forms.Button
        Me.Label1 = New System.Windows.Forms.Label
        Me.lblIsDelimited = New System.Windows.Forms.Label
        Me.Label3 = New System.Windows.Forms.Label
        Me.lblDelimiter = New System.Windows.Forms.Label
        Me.Label5 = New System.Windows.Forms.Label
        Me.lblQualifier = New System.Windows.Forms.Label
        Me.Label7 = New System.Windows.Forms.Label
        Me.lblHasHeader = New System.Windows.Forms.Label
        Me.lstColumns = New System.Windows.Forms.ListBox
        Me.Label9 = New System.Windows.Forms.Label
        Me.SuspendLayout()
        '
        'btnTextWizard
        '
        Me.btnTextWizard.Location = New System.Drawing.Point(16, 8)
        Me.btnTextWizard.Name = "btnTextWizard"
        Me.btnTextWizard.TabIndex = 0
        Me.btnTextWizard.Text = "Text Wizard"
        '
        'Label1
        '
        Me.Label1.Location = New System.Drawing.Point(136, 8)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(80, 16)
        Me.Label1.TabIndex = 1
        Me.Label1.Text = "Is Delimited:"
        '
        'lblIsDelimited
        '
        Me.lblIsDelimited.Location = New System.Drawing.Point(224, 8)
        Me.lblIsDelimited.Name = "lblIsDelimited"
        Me.lblIsDelimited.Size = New System.Drawing.Size(64, 16)
        Me.lblIsDelimited.TabIndex = 2
        '
        'Label3
        '
        Me.Label3.Location = New System.Drawing.Point(136, 32)
        Me.Label3.Name = "Label3"
        Me.Label3.Size = New System.Drawing.Size(80, 16)
        Me.Label3.TabIndex = 3
        Me.Label3.Text = "Delimiter:"
        '
        'lblDelimiter
        '
        Me.lblDelimiter.Location = New System.Drawing.Point(224, 32)
        Me.lblDelimiter.Name = "lblDelimiter"
        Me.lblDelimiter.Size = New System.Drawing.Size(64, 16)
        Me.lblDelimiter.TabIndex = 4
        '
        'Label5
        '
        Me.Label5.Location = New System.Drawing.Point(136, 56)
        Me.Label5.Name = "Label5"
        Me.Label5.Size = New System.Drawing.Size(80, 16)
        Me.Label5.TabIndex = 5
        Me.Label5.Text = "Text Qualifier:"
        '
        'lblQualifier
        '
        Me.lblQualifier.Location = New System.Drawing.Point(224, 56)
        Me.lblQualifier.Name = "lblQualifier"
        Me.lblQualifier.Size = New System.Drawing.Size(64, 16)
        Me.lblQualifier.TabIndex = 6
        '
        'Label7
        '
        Me.Label7.Location = New System.Drawing.Point(136, 80)
        Me.Label7.Name = "Label7"
        Me.Label7.Size = New System.Drawing.Size(80, 16)
        Me.Label7.TabIndex = 7
        Me.Label7.Text = "Has Header:"
        '
        'lblHasHeader
        '
        Me.lblHasHeader.Location = New System.Drawing.Point(224, 80)
        Me.lblHasHeader.Name = "lblHasHeader"
        Me.lblHasHeader.Size = New System.Drawing.Size(64, 16)
        Me.lblHasHeader.TabIndex = 8
        '
        'lstColumns
        '
        Me.lstColumns.Location = New System.Drawing.Point(136, 120)
        Me.lstColumns.Name = "lstColumns"
        Me.lstColumns.Size = New System.Drawing.Size(256, 134)
        Me.lstColumns.TabIndex = 9
        '
        'Label9
        '
        Me.Label9.Location = New System.Drawing.Point(136, 104)
        Me.Label9.Name = "Label9"
        Me.Label9.Size = New System.Drawing.Size(80, 16)
        Me.Label9.TabIndex = 10
        Me.Label9.Text = "Columns:"
        '
        'TestTextWizard
        '
        Me.AutoScaleBaseSize = New System.Drawing.Size(5, 13)
        Me.ClientSize = New System.Drawing.Size(464, 277)
        Me.Controls.Add(Me.Label9)
        Me.Controls.Add(Me.lstColumns)
        Me.Controls.Add(Me.lblHasHeader)
        Me.Controls.Add(Me.Label7)
        Me.Controls.Add(Me.lblQualifier)
        Me.Controls.Add(Me.Label5)
        Me.Controls.Add(Me.lblDelimiter)
        Me.Controls.Add(Me.Label3)
        Me.Controls.Add(Me.lblIsDelimited)
        Me.Controls.Add(Me.Label1)
        Me.Controls.Add(Me.btnTextWizard)
        Me.Name = "TestTextWizard"
        Me.Text = "Test Text Wizard"
        Me.ResumeLayout(False)

    End Sub

#End Region

    Private Sub BeginForm_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        'MockDtsPackage()
        MockTemplateFile()
    End Sub

    'Private Sub MockDtsPackage()
    '    m_dtsTextData = New DTSTextData
    'End Sub

    Private Sub MockTemplateFile()
        m_templateFile = New DataFile

        With m_templateFile
            .FileName = "FixedWidthSample.txt"
            '.FileName = "DelimitedSample.txt"
            '.FileName = "Delimited_1line.txt"
            .FileName = "Adventist_IPOPER_Test.txt"
            .Folder = "C:\Qualisys\Loading\wk\Loading\SampleData\Text\"
        End With
    End Sub

    Private Sub btnTextWizard_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnTextWizard.Click
        Dim textDataCtrl As New TextDataCtrl(m_templateFile.Path)
        Dim frmTextWizard As New frmTextWizard
        frmTextWizard.TextDataCtrl = textDataCtrl

        If (frmTextWizard.ShowDialog() = Windows.Forms.DialogResult.OK) Then
            'MessageBox.Show("Complete import text file wizard successfully!", "Import")

            With textDataCtrl.DataSet
                lblIsDelimited.Text = .IsDelimited.ToString
                lblDelimiter.Text = "{" + .Delimiter + "}"
                lblQualifier.Text = "{" + .TextQualifier + "}"
                lblHasHeader.Text = .HasHeader.ToString
                lstColumns.Items.Clear()
                Dim col As SourceColumn
                For Each col In .Columns
                    lstColumns.Items.Add(col.ColumnName + ", " & col.Length)
                Next

            End With

        Else
            'MessageBox.Show("Abort import text file wizard!", "Import")
        End If

    End Sub

End Class
