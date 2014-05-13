Option Explicit On 
Option Strict On

Imports System.Data.SqlClient
Imports NRC.Data

Public Class TableColumnDialog
    Inherits NRC.WinForms.DialogForm

#Region " Private Fields"

    Private mNormSetting As New CanadaNormSetting

#End Region

#Region " Public Properties"
    Public Property NormSetting() As CanadaNormSetting
        Get
            Return mNormSetting
        End Get
        Set(ByVal Value As CanadaNormSetting)
            mNormSetting = Value
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
    Friend WithEvents ColumnHeader1 As System.Windows.Forms.ColumnHeader
    Friend WithEvents ColumnHeader2 As System.Windows.Forms.ColumnHeader
    Friend WithEvents ColumnHeader3 As System.Windows.Forms.ColumnHeader
    Friend WithEvents lvwList As System.Windows.Forms.ListView
    Friend WithEvents btnClose As System.Windows.Forms.Button
    Friend WithEvents ColumnHeader4 As System.Windows.Forms.ColumnHeader
    Friend WithEvents Label1 As System.Windows.Forms.Label
    Friend WithEvents txtSample As System.Windows.Forms.TextBox
    Friend WithEvents Label2 As System.Windows.Forms.Label
    Friend WithEvents ColumnHeader5 As System.Windows.Forms.ColumnHeader
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Dim resources As System.Resources.ResourceManager = New System.Resources.ResourceManager(GetType(TableColumnDialog))
        Me.lvwList = New System.Windows.Forms.ListView
        Me.ColumnHeader1 = New System.Windows.Forms.ColumnHeader
        Me.ColumnHeader2 = New System.Windows.Forms.ColumnHeader
        Me.ColumnHeader3 = New System.Windows.Forms.ColumnHeader
        Me.ColumnHeader4 = New System.Windows.Forms.ColumnHeader
        Me.ColumnHeader5 = New System.Windows.Forms.ColumnHeader
        Me.btnClose = New System.Windows.Forms.Button
        Me.txtSample = New System.Windows.Forms.TextBox
        Me.Label1 = New System.Windows.Forms.Label
        Me.Label2 = New System.Windows.Forms.Label
        Me.SuspendLayout()
        '
        'mPaneCaption
        '
        Me.mPaneCaption.Caption = "Help on Creating Criteria Statement"
        Me.mPaneCaption.Name = "mPaneCaption"
        Me.mPaneCaption.Size = New System.Drawing.Size(694, 26)
        Me.mPaneCaption.Text = "Help on Creating Criteria Statement"
        '
        'lvwList
        '
        Me.lvwList.AllowColumnReorder = True
        Me.lvwList.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.lvwList.Columns.AddRange(New System.Windows.Forms.ColumnHeader() {Me.ColumnHeader1, Me.ColumnHeader2, Me.ColumnHeader3, Me.ColumnHeader4, Me.ColumnHeader5})
        Me.lvwList.GridLines = True
        Me.lvwList.Location = New System.Drawing.Point(24, 56)
        Me.lvwList.Name = "lvwList"
        Me.lvwList.Size = New System.Drawing.Size(648, 336)
        Me.lvwList.TabIndex = 1
        Me.lvwList.View = System.Windows.Forms.View.Details
        '
        'ColumnHeader1
        '
        Me.ColumnHeader1.Text = "Table"
        Me.ColumnHeader1.Width = 156
        '
        'ColumnHeader2
        '
        Me.ColumnHeader2.Text = "Abbr."
        Me.ColumnHeader2.Width = 41
        '
        'ColumnHeader3
        '
        Me.ColumnHeader3.Text = "Column"
        Me.ColumnHeader3.Width = 181
        '
        'ColumnHeader4
        '
        Me.ColumnHeader4.Text = "Date Type"
        Me.ColumnHeader4.Width = 68
        '
        'ColumnHeader5
        '
        Me.ColumnHeader5.Text = "Description"
        Me.ColumnHeader5.Width = 177
        '
        'btnClose
        '
        Me.btnClose.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.btnClose.DialogResult = System.Windows.Forms.DialogResult.Cancel
        Me.btnClose.Location = New System.Drawing.Point(597, 480)
        Me.btnClose.Name = "btnClose"
        Me.btnClose.TabIndex = 4
        Me.btnClose.Text = "Close"
        '
        'txtSample
        '
        Me.txtSample.Anchor = CType(((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.txtSample.Font = New System.Drawing.Font("Courier New", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtSample.Location = New System.Drawing.Point(24, 424)
        Me.txtSample.Multiline = True
        Me.txtSample.Name = "txtSample"
        Me.txtSample.ReadOnly = True
        Me.txtSample.Size = New System.Drawing.Size(648, 48)
        Me.txtSample.TabIndex = 3
        Me.txtSample.Text = "    sr.datReportDate >= '4/1/2005'"
        '
        'Label1
        '
        Me.Label1.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label1.Location = New System.Drawing.Point(24, 40)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(200, 16)
        Me.Label1.TabIndex = 0
        Me.Label1.Text = "Applicable Tables and Columns:"
        '
        'Label2
        '
        Me.Label2.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
        Me.Label2.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label2.Location = New System.Drawing.Point(24, 408)
        Me.Label2.Name = "Label2"
        Me.Label2.Size = New System.Drawing.Size(200, 16)
        Me.Label2.TabIndex = 2
        Me.Label2.Text = "Criteria Statement Sample:"
        '
        'TableColumnDialog
        '
        Me.AcceptButton = Me.btnClose
        Me.AutoScaleBaseSize = New System.Drawing.Size(5, 13)
        Me.CancelButton = Me.btnClose
        Me.Caption = "Help on Creating Criteria Statement"
        Me.ClientSize = New System.Drawing.Size(696, 520)
        Me.Controls.Add(Me.Label2)
        Me.Controls.Add(Me.Label1)
        Me.Controls.Add(Me.txtSample)
        Me.Controls.Add(Me.btnClose)
        Me.Controls.Add(Me.lvwList)
        Me.DockPadding.All = 1
        Me.Icon = CType(resources.GetObject("$this.Icon"), System.Drawing.Icon)
        Me.Name = "TableColumnDialog"
        Me.Text = "ListDialog"
        Me.Controls.SetChildIndex(Me.lvwList, 0)
        Me.Controls.SetChildIndex(Me.btnClose, 0)
        Me.Controls.SetChildIndex(Me.txtSample, 0)
        Me.Controls.SetChildIndex(Me.Label1, 0)
        Me.Controls.SetChildIndex(Me.mPaneCaption, 0)
        Me.Controls.SetChildIndex(Me.Label2, 0)
        Me.ResumeLayout(False)

    End Sub

#End Region

#Region " Event Handler"

    Private Sub TableColumnDialog_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        EnableThemes(Me)
        DisplaySample()
        DisplayList()
    End Sub

    Private Sub btnClose_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnClose.Click
        Me.Close()
    End Sub

#End Region

#Region " Private Methods"

    Private Sub DisplaySample()
        Dim sample As String = _
                 "    sr.datReportDate >= '4/1/2005'" + vbCrLf + _
                 "AND bt.Age BETWEEN 20 AND 60" + vbCrLf + _
                 "AND us.bitIPMed = 1"

        txtSample.Text = sample
    End Sub

    Private Sub DisplayList()
        Dim rdr As SafeDataReader = Nothing
        Dim item As ListViewItem
        Dim preTableName As String = ""
        Dim tableName As String
        Dim abbr As String
        Dim columnName As String
        Dim dataType As String
        Dim description As String

        Try
            rdr = Me.mNormSetting.SelectTableColumn

            lvwList.BeginUpdate()
            lvwList.Items.Clear()

            Do While rdr.Read
                tableName = rdr.GetString("TableName")
                abbr = rdr.GetString("Abbr")
                columnName = rdr.GetString("ColumnName")
                dataType = rdr.GetString("DataType")
                description = rdr.GetString("Description")

                If (preTableName <> tableName) Then
                    preTableName = tableName
                    item = New ListViewItem(tableName)
                    item.SubItems.Add(abbr)
                Else
                    item = New ListViewItem("")
                    item.SubItems.Add("")
                End If
                item.SubItems.Add(columnName)
                item.SubItems.Add(dataType)
                item.SubItems.Add(description)

                lvwList.Items.Add(item)
            Loop

        Catch ex As Exception
            ReportException(ex)
        Finally
            If (Not rdr Is Nothing) Then rdr.Close()
            lvwList.EndUpdate()
        End Try

    End Sub

#End Region

End Class
