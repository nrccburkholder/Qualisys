Imports System.IO
Public Class frmShowLogs
    Inherits System.Windows.Forms.Form
    Friend strFile As StreamReader
    Friend WithEvents TableLayoutPanel1 As System.Windows.Forms.TableLayoutPanel
    Friend WithEvents gbLogs As System.Windows.Forms.GroupBox
    Friend WithEvents txtFile As System.Windows.Forms.RichTextBox
    Friend WithEvents btnClose As System.Windows.Forms.Button
    Friend sKindofFile As String
    Private _tSeparatedThread As System.Threading.Thread
    Delegate Sub SetTextCallback()
    Private _bStopThread As Boolean

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
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(frmShowLogs))
        Me.TableLayoutPanel1 = New System.Windows.Forms.TableLayoutPanel()
        Me.btnClose = New System.Windows.Forms.Button()
        Me.gbLogs = New System.Windows.Forms.GroupBox()
        Me.txtFile = New System.Windows.Forms.RichTextBox()
        Me.TableLayoutPanel1.SuspendLayout()
        Me.gbLogs.SuspendLayout()
        Me.SuspendLayout()
        '
        'TableLayoutPanel1
        '
        Me.TableLayoutPanel1.AutoSizeMode = System.Windows.Forms.AutoSizeMode.GrowAndShrink
        Me.TableLayoutPanel1.ColumnCount = 1
        Me.TableLayoutPanel1.ColumnStyles.Add(New System.Windows.Forms.ColumnStyle())
        Me.TableLayoutPanel1.Controls.Add(Me.btnClose, 0, 1)
        Me.TableLayoutPanel1.Controls.Add(Me.gbLogs, 0, 0)
        Me.TableLayoutPanel1.Dock = System.Windows.Forms.DockStyle.Fill
        Me.TableLayoutPanel1.Location = New System.Drawing.Point(0, 0)
        Me.TableLayoutPanel1.Margin = New System.Windows.Forms.Padding(2)
        Me.TableLayoutPanel1.Name = "TableLayoutPanel1"
        Me.TableLayoutPanel1.Padding = New System.Windows.Forms.Padding(2)
        Me.TableLayoutPanel1.RowCount = 2
        Me.TableLayoutPanel1.RowStyles.Add(New System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 100.0!))
        Me.TableLayoutPanel1.RowStyles.Add(New System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Absolute, 39.0!))
        Me.TableLayoutPanel1.Size = New System.Drawing.Size(661, 530)
        Me.TableLayoutPanel1.TabIndex = 2
        '
        'btnClose
        '
        Me.btnClose.Dock = System.Windows.Forms.DockStyle.Bottom
        Me.btnClose.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.btnClose.Font = New System.Drawing.Font("Verdana", 9.0!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.btnClose.Location = New System.Drawing.Point(5, 497)
        Me.btnClose.Name = "btnClose"
        Me.btnClose.Size = New System.Drawing.Size(781, 28)
        Me.btnClose.TabIndex = 4
        Me.btnClose.Text = "Close"
        '
        'gbLogs
        '
        Me.gbLogs.Controls.Add(Me.txtFile)
        Me.gbLogs.Dock = System.Windows.Forms.DockStyle.Fill
        Me.gbLogs.Font = New System.Drawing.Font("Century Gothic", 9.0!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.gbLogs.Location = New System.Drawing.Point(7, 7)
        Me.gbLogs.Margin = New System.Windows.Forms.Padding(5)
        Me.gbLogs.Name = "gbLogs"
        Me.gbLogs.Padding = New System.Windows.Forms.Padding(5)
        Me.gbLogs.Size = New System.Drawing.Size(777, 477)
        Me.gbLogs.TabIndex = 3
        Me.gbLogs.TabStop = False
        '
        'txtFile
        '
        Me.txtFile.Dock = System.Windows.Forms.DockStyle.Fill
        Me.txtFile.Font = New System.Drawing.Font("Verdana", 9.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtFile.Location = New System.Drawing.Point(5, 24)
        Me.txtFile.Name = "txtFile"
        Me.txtFile.ReadOnly = True
        Me.txtFile.Size = New System.Drawing.Size(767, 448)
        Me.txtFile.TabIndex = 0
        Me.txtFile.Text = ""
        '
        'frmShowLogs
        '
        Me.AccessibleRole = System.Windows.Forms.AccessibleRole.Dialog
        Me.AutoScaleBaseSize = New System.Drawing.Size(6, 15)
        Me.ClientSize = New System.Drawing.Size(661, 530)
        Me.Controls.Add(Me.TableLayoutPanel1)
        Me.Icon = CType(resources.GetObject("$this.Icon"), System.Drawing.Icon)
        Me.Name = "frmShowLogs"
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen
        Me.Text = "File Logs"
        Me.TableLayoutPanel1.ResumeLayout(False)
        Me.gbLogs.ResumeLayout(False)
        Me.ResumeLayout(False)

    End Sub

#End Region
    Private Sub frmShowLogs_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        Me.gbLogs.Text = sKindofFile

        'Starting thread to read the file
        _tSeparatedThread = New System.Threading.Thread(AddressOf ReadLogFileThreadSafe)
        _tSeparatedThread.Start()
    End Sub

    'Thread Safe Access to txtFile control
    Private Sub ReadLogFileThreadSafe()
        txtFile.Invoke(New SetTextCallback(AddressOf ReadLogFile))
    End Sub


    'This method will be executed in a different thread to make the form more responsive to the user
    Private Sub ReadLogFile()
        Dim sLine As String
        Dim iCounter As Integer = 0
        Dim sFormTitle As String
        Dim sTextBlock As String = ""

        _bStopThread = False

        sFormTitle = Me.Text

        Me.Text &= " - Loading"

        Do
            sLine = strFile.ReadLine()

            sTextBlock &= sLine & vbCrLf
            iCounter += 1
            If iCounter > 30 Then
                iCounter = 0
                txtFile.Text &= sTextBlock
                sTextBlock = ""
                My.Application.DoEvents()
            End If
        Loop Until strFile.EndOfStream Or _bStopThread

        txtFile.Text &= sTextBlock

        Me.Text = sFormTitle
    End Sub

    Private Sub btnClose_Click_1(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnClose.Click
        'If Thread is still reading the file then stop the thread
        If _tSeparatedThread.ThreadState = Threading.ThreadState.Running Then
            _bStopThread = True
            _tSeparatedThread.Join(3000)
        End If

        Me.Close()
    End Sub
End Class
