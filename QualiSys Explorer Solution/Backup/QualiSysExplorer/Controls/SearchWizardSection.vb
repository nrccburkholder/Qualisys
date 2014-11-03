Imports Nrc.QualiSys.Library

Public Class SearchWizardSection
    'Inherits System.Windows.Forms.UserControl
    Inherits ContentControlBase


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
    Friend WithEvents pnlMain As Nrc.Framework.WinForms.SectionPanel
    Friend WithEvents OperatorList As System.Windows.Forms.ListBox
    Friend WithEvents FieldLabel As System.Windows.Forms.Label
    Friend WithEvents OperatorsLabel As System.Windows.Forms.Label
    Friend WithEvents ValueLabel As System.Windows.Forms.Label
    Friend WithEvents AddCriteriaButton As System.Windows.Forms.Button
    Friend WithEvents CriteriaValue As System.Windows.Forms.TextBox
    Friend WithEvents FieldList As System.Windows.Forms.ListBox
    Friend WithEvents WhereClause As System.Windows.Forms.TextBox
    Friend WithEvents ExecuteButton As System.Windows.Forms.Button
    Friend WithEvents QueryStatusLabel As System.Windows.Forms.Label
    Friend WithEvents DataListView As System.Windows.Forms.ListView
    Friend WithEvents MailingList As System.Windows.Forms.ListView
    Friend WithEvents ColumnHeader1 As System.Windows.Forms.ColumnHeader
    Friend WithEvents ColumnHeader2 As System.Windows.Forms.ColumnHeader
    Friend WithEvents ColumnHeader3 As System.Windows.Forms.ColumnHeader
    Friend WithEvents ColumnHeader4 As System.Windows.Forms.ColumnHeader
    Friend WithEvents ColumnHeader5 As System.Windows.Forms.ColumnHeader
    Friend WithEvents ColumnHeader6 As System.Windows.Forms.ColumnHeader
    Friend WithEvents ColumnHeader7 As System.Windows.Forms.ColumnHeader
    Friend WithEvents ColumnHeader8 As System.Windows.Forms.ColumnHeader
    Friend WithEvents ColumnHeader9 As System.Windows.Forms.ColumnHeader
    Friend WithEvents MailingsLabel As System.Windows.Forms.Label
    Friend WithEvents Label1 As System.Windows.Forms.Label
    Friend WithEvents Label2 As System.Windows.Forms.Label
    Friend WithEvents MailingImages As System.Windows.Forms.ImageList
    Friend WithEvents ColumnHeader10 As System.Windows.Forms.ColumnHeader
    Friend WithEvents MailingMenu As System.Windows.Forms.ContextMenu
    Friend WithEvents SetDispositionItem As System.Windows.Forms.MenuItem
    Friend WithEvents TableList As System.Windows.Forms.ComboBox
    Friend WithEvents TableLabel As System.Windows.Forms.Label
    Friend WithEvents ClearCriteriaButton As System.Windows.Forms.Button
    Friend WithEvents ColumnHeader11 As System.Windows.Forms.ColumnHeader
    Friend WithEvents ColumnHeader12 As System.Windows.Forms.ColumnHeader
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.components = New System.ComponentModel.Container
        Dim resources As System.Resources.ResourceManager = New System.Resources.ResourceManager(GetType(SearchWizardSection))
        Me.pnlMain = New Nrc.Framework.WinForms.SectionPanel
        Me.TableList = New System.Windows.Forms.ComboBox
        Me.MailingList = New System.Windows.Forms.ListView
        Me.ColumnHeader10 = New System.Windows.Forms.ColumnHeader
        Me.ColumnHeader1 = New System.Windows.Forms.ColumnHeader
        Me.ColumnHeader2 = New System.Windows.Forms.ColumnHeader
        Me.ColumnHeader3 = New System.Windows.Forms.ColumnHeader
        Me.ColumnHeader4 = New System.Windows.Forms.ColumnHeader
        Me.ColumnHeader5 = New System.Windows.Forms.ColumnHeader
        Me.ColumnHeader6 = New System.Windows.Forms.ColumnHeader
        Me.ColumnHeader7 = New System.Windows.Forms.ColumnHeader
        Me.ColumnHeader8 = New System.Windows.Forms.ColumnHeader
        Me.ColumnHeader9 = New System.Windows.Forms.ColumnHeader
        Me.ColumnHeader11 = New System.Windows.Forms.ColumnHeader
        Me.ColumnHeader12 = New System.Windows.Forms.ColumnHeader
        Me.MailingMenu = New System.Windows.Forms.ContextMenu
        Me.SetDispositionItem = New System.Windows.Forms.MenuItem
        Me.MailingImages = New System.Windows.Forms.ImageList(Me.components)
        Me.DataListView = New System.Windows.Forms.ListView
        Me.ExecuteButton = New System.Windows.Forms.Button
        Me.WhereClause = New System.Windows.Forms.TextBox
        Me.AddCriteriaButton = New System.Windows.Forms.Button
        Me.CriteriaValue = New System.Windows.Forms.TextBox
        Me.FieldLabel = New System.Windows.Forms.Label
        Me.FieldList = New System.Windows.Forms.ListBox
        Me.OperatorList = New System.Windows.Forms.ListBox
        Me.OperatorsLabel = New System.Windows.Forms.Label
        Me.ValueLabel = New System.Windows.Forms.Label
        Me.QueryStatusLabel = New System.Windows.Forms.Label
        Me.MailingsLabel = New System.Windows.Forms.Label
        Me.Label1 = New System.Windows.Forms.Label
        Me.Label2 = New System.Windows.Forms.Label
        Me.TableLabel = New System.Windows.Forms.Label
        Me.ClearCriteriaButton = New System.Windows.Forms.Button
        Me.pnlMain.SuspendLayout()
        Me.SuspendLayout()
        '
        'pnlMain
        '
        Me.pnlMain.BorderColor = System.Drawing.Color.FromArgb(CType(0, Byte), CType(45, Byte), CType(150, Byte))
        Me.pnlMain.Caption = "Search Wizard"
        Me.pnlMain.Controls.Add(Me.TableList)
        Me.pnlMain.Controls.Add(Me.MailingList)
        Me.pnlMain.Controls.Add(Me.DataListView)
        Me.pnlMain.Controls.Add(Me.ExecuteButton)
        Me.pnlMain.Controls.Add(Me.WhereClause)
        Me.pnlMain.Controls.Add(Me.AddCriteriaButton)
        Me.pnlMain.Controls.Add(Me.CriteriaValue)
        Me.pnlMain.Controls.Add(Me.FieldLabel)
        Me.pnlMain.Controls.Add(Me.FieldList)
        Me.pnlMain.Controls.Add(Me.OperatorList)
        Me.pnlMain.Controls.Add(Me.OperatorsLabel)
        Me.pnlMain.Controls.Add(Me.ValueLabel)
        Me.pnlMain.Controls.Add(Me.QueryStatusLabel)
        Me.pnlMain.Controls.Add(Me.MailingsLabel)
        Me.pnlMain.Controls.Add(Me.Label1)
        Me.pnlMain.Controls.Add(Me.Label2)
        Me.pnlMain.Controls.Add(Me.TableLabel)
        Me.pnlMain.Controls.Add(Me.ClearCriteriaButton)
        Me.pnlMain.Dock = System.Windows.Forms.DockStyle.Fill
        Me.pnlMain.DockPadding.All = 1
        Me.pnlMain.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.pnlMain.Location = New System.Drawing.Point(0, 0)
        Me.pnlMain.Name = "pnlMain"
        Me.pnlMain.ShowCaption = True
        Me.pnlMain.Size = New System.Drawing.Size(832, 640)
        Me.pnlMain.TabIndex = 0
        '
        'TableList
        '
        Me.TableList.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.TableList.Location = New System.Drawing.Point(16, 64)
        Me.TableList.Name = "TableList"
        Me.TableList.Size = New System.Drawing.Size(144, 21)
        Me.TableList.TabIndex = 17
        '
        'MailingList
        '
        Me.MailingList.Anchor = CType(((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.MailingList.Columns.AddRange(New System.Windows.Forms.ColumnHeader() {Me.ColumnHeader10, Me.ColumnHeader1, Me.ColumnHeader2, Me.ColumnHeader3, Me.ColumnHeader4, Me.ColumnHeader5, Me.ColumnHeader6, Me.ColumnHeader7, Me.ColumnHeader8, Me.ColumnHeader9, Me.ColumnHeader11, Me.ColumnHeader12})
        Me.MailingList.ContextMenu = Me.MailingMenu
        Me.MailingList.FullRowSelect = True
        Me.MailingList.GridLines = True
        Me.MailingList.Location = New System.Drawing.Point(16, 504)
        Me.MailingList.Name = "MailingList"
        Me.MailingList.Size = New System.Drawing.Size(800, 120)
        Me.MailingList.SmallImageList = Me.MailingImages
        Me.MailingList.TabIndex = 15
        Me.MailingList.View = System.Windows.Forms.View.Details
        '
        'ColumnHeader10
        '
        Me.ColumnHeader10.Text = ""
        Me.ColumnHeader10.Width = 23
        '
        'ColumnHeader1
        '
        Me.ColumnHeader1.Text = "SentMailId"
        Me.ColumnHeader1.Width = 65
        '
        'ColumnHeader2
        '
        Me.ColumnHeader2.Text = "Litho Code"
        Me.ColumnHeader2.Width = 93
        '
        'ColumnHeader3
        '
        Me.ColumnHeader3.Text = "Mailing Step"
        Me.ColumnHeader3.Width = 121
        '
        'ColumnHeader4
        '
        Me.ColumnHeader4.Text = "StudyId"
        '
        'ColumnHeader5
        '
        Me.ColumnHeader5.Text = "PopId"
        '
        'ColumnHeader6
        '
        Me.ColumnHeader6.Text = "Scheduled Date"
        Me.ColumnHeader6.Width = 94
        '
        'ColumnHeader7
        '
        Me.ColumnHeader7.Text = "Generation Date"
        Me.ColumnHeader7.Width = 95
        '
        'ColumnHeader8
        '
        Me.ColumnHeader8.Text = "Print Date"
        Me.ColumnHeader8.Width = 94
        '
        'ColumnHeader9
        '
        Me.ColumnHeader9.Text = "Mail Date"
        Me.ColumnHeader9.Width = 96
        '
        'ColumnHeader11
        '
        Me.ColumnHeader11.Text = "Non-Delivery Date"
        Me.ColumnHeader11.Width = 106
        '
        'ColumnHeader12
        '
        Me.ColumnHeader12.Text = "Return Date"
        Me.ColumnHeader12.Width = 75
        '
        'MailingMenu
        '
        Me.MailingMenu.MenuItems.AddRange(New System.Windows.Forms.MenuItem() {Me.SetDispositionItem})
        '
        'SetDispositionItem
        '
        Me.SetDispositionItem.Index = 0
        Me.SetDispositionItem.Text = "Set Disposition"
        '
        'MailingImages
        '
        Me.MailingImages.ImageSize = New System.Drawing.Size(16, 16)
        Me.MailingImages.ImageStream = CType(resources.GetObject("MailingImages.ImageStream"), System.Windows.Forms.ImageListStreamer)
        Me.MailingImages.TransparentColor = System.Drawing.Color.Transparent
        '
        'DataListView
        '
        Me.DataListView.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.DataListView.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.DataListView.FullRowSelect = True
        Me.DataListView.GridLines = True
        Me.DataListView.HideSelection = False
        Me.DataListView.Location = New System.Drawing.Point(16, 360)
        Me.DataListView.MultiSelect = False
        Me.DataListView.Name = "DataListView"
        Me.DataListView.Size = New System.Drawing.Size(800, 112)
        Me.DataListView.TabIndex = 13
        Me.DataListView.View = System.Windows.Forms.View.Details
        '
        'ExecuteButton
        '
        Me.ExecuteButton.FlatStyle = System.Windows.Forms.FlatStyle.System
        Me.ExecuteButton.Location = New System.Drawing.Point(16, 304)
        Me.ExecuteButton.Name = "ExecuteButton"
        Me.ExecuteButton.TabIndex = 11
        Me.ExecuteButton.Text = "Execute"
        '
        'WhereClause
        '
        Me.WhereClause.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.WhereClause.Location = New System.Drawing.Point(16, 192)
        Me.WhereClause.Multiline = True
        Me.WhereClause.Name = "WhereClause"
        Me.WhereClause.Size = New System.Drawing.Size(800, 104)
        Me.WhereClause.TabIndex = 9
        Me.WhereClause.Text = ""
        '
        'AddCriteriaButton
        '
        Me.AddCriteriaButton.FlatStyle = System.Windows.Forms.FlatStyle.System
        Me.AddCriteriaButton.Location = New System.Drawing.Point(512, 104)
        Me.AddCriteriaButton.Name = "AddCriteriaButton"
        Me.AddCriteriaButton.Size = New System.Drawing.Size(96, 23)
        Me.AddCriteriaButton.TabIndex = 7
        Me.AddCriteriaButton.Text = "Add Criteria"
        '
        'CriteriaValue
        '
        Me.CriteriaValue.Location = New System.Drawing.Point(512, 64)
        Me.CriteriaValue.Name = "CriteriaValue"
        Me.CriteriaValue.Size = New System.Drawing.Size(136, 21)
        Me.CriteriaValue.TabIndex = 5
        Me.CriteriaValue.Text = ""
        '
        'FieldLabel
        '
        Me.FieldLabel.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.FieldLabel.Location = New System.Drawing.Point(176, 40)
        Me.FieldLabel.Name = "FieldLabel"
        Me.FieldLabel.Size = New System.Drawing.Size(152, 23)
        Me.FieldLabel.TabIndex = 3
        Me.FieldLabel.Text = "Fields:"
        Me.FieldLabel.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'FieldList
        '
        Me.FieldList.Items.AddRange(New Object() {"Pop_id", "MRN", "FName", "LName", "Middle", "Addr"})
        Me.FieldList.Location = New System.Drawing.Point(176, 64)
        Me.FieldList.Name = "FieldList"
        Me.FieldList.Size = New System.Drawing.Size(152, 95)
        Me.FieldList.TabIndex = 2
        '
        'OperatorList
        '
        Me.OperatorList.Location = New System.Drawing.Point(344, 64)
        Me.OperatorList.Name = "OperatorList"
        Me.OperatorList.Size = New System.Drawing.Size(152, 95)
        Me.OperatorList.TabIndex = 2
        '
        'OperatorsLabel
        '
        Me.OperatorsLabel.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.OperatorsLabel.Location = New System.Drawing.Point(344, 40)
        Me.OperatorsLabel.Name = "OperatorsLabel"
        Me.OperatorsLabel.Size = New System.Drawing.Size(152, 23)
        Me.OperatorsLabel.TabIndex = 3
        Me.OperatorsLabel.Text = "Operators:"
        Me.OperatorsLabel.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'ValueLabel
        '
        Me.ValueLabel.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.ValueLabel.Location = New System.Drawing.Point(512, 40)
        Me.ValueLabel.Name = "ValueLabel"
        Me.ValueLabel.Size = New System.Drawing.Size(136, 23)
        Me.ValueLabel.TabIndex = 3
        Me.ValueLabel.Text = "Value:"
        Me.ValueLabel.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'QueryStatusLabel
        '
        Me.QueryStatusLabel.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.QueryStatusLabel.Font = New System.Drawing.Font("Tahoma", 8.25!)
        Me.QueryStatusLabel.Location = New System.Drawing.Point(104, 304)
        Me.QueryStatusLabel.Name = "QueryStatusLabel"
        Me.QueryStatusLabel.Size = New System.Drawing.Size(712, 23)
        Me.QueryStatusLabel.TabIndex = 3
        Me.QueryStatusLabel.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'MailingsLabel
        '
        Me.MailingsLabel.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
        Me.MailingsLabel.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.MailingsLabel.Location = New System.Drawing.Point(16, 480)
        Me.MailingsLabel.Name = "MailingsLabel"
        Me.MailingsLabel.Size = New System.Drawing.Size(152, 23)
        Me.MailingsLabel.TabIndex = 3
        Me.MailingsLabel.Text = "Mailings:"
        Me.MailingsLabel.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'Label1
        '
        Me.Label1.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label1.Location = New System.Drawing.Point(16, 168)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(152, 23)
        Me.Label1.TabIndex = 3
        Me.Label1.Text = "Criteria Statement:"
        Me.Label1.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'Label2
        '
        Me.Label2.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label2.Location = New System.Drawing.Point(16, 336)
        Me.Label2.Name = "Label2"
        Me.Label2.Size = New System.Drawing.Size(152, 23)
        Me.Label2.TabIndex = 3
        Me.Label2.Text = "Matching Records:"
        Me.Label2.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'TableLabel
        '
        Me.TableLabel.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.TableLabel.Location = New System.Drawing.Point(16, 40)
        Me.TableLabel.Name = "TableLabel"
        Me.TableLabel.Size = New System.Drawing.Size(144, 23)
        Me.TableLabel.TabIndex = 3
        Me.TableLabel.Text = "Table:"
        Me.TableLabel.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'ClearCriteriaButton
        '
        Me.ClearCriteriaButton.FlatStyle = System.Windows.Forms.FlatStyle.System
        Me.ClearCriteriaButton.Location = New System.Drawing.Point(512, 136)
        Me.ClearCriteriaButton.Name = "ClearCriteriaButton"
        Me.ClearCriteriaButton.Size = New System.Drawing.Size(96, 23)
        Me.ClearCriteriaButton.TabIndex = 7
        Me.ClearCriteriaButton.Text = "Clear Criteria"
        '
        'SearchWizardSection
        '
        Me.Controls.Add(Me.pnlMain)
        Me.Name = "SearchWizardSection"
        Me.Size = New System.Drawing.Size(832, 640)
        Me.pnlMain.ResumeLayout(False)
        Me.ResumeLayout(False)

    End Sub

#End Region

#Region " Mailing Selected Event "
    Public Class MailingSelectedEventArgs
        Inherits EventArgs

        Private mMailing As Mailing
        Public ReadOnly Property Mailing() As Mailing
            Get
                Return mMailing
            End Get
        End Property
        Sub New(ByVal mail As Mailing)
            mMailing = mail
        End Sub
    End Class
    Public Delegate Sub MailingSelectedEventHandler(ByVal sender As Object, ByVal e As MailingSelectedEventArgs)
    Public Event MailingSelected As MailingSelectedEventHandler

#End Region

    Private WithEvents StudyNav As StudyNavigator
    Private Const MAX_RECORDS As Integer = 200

    Private Sub SearchWizardSection_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles MyBase.Load
        PopulateOperatorList()
        Me.Enabled = False
    End Sub

    Public Overrides Function AllowUnload() As Boolean
        Return True
    End Function

    Public Overrides Sub RegisterNavControl(ByVal navControl As System.Windows.Forms.Control)
        If TypeOf navControl Is StudyNavigator Then
            StudyNav = DirectCast(navControl, StudyNavigator)
        Else
            Throw New ArgumentException("SearchWizardSection expects a navigation control of type StudyNavigator", "navControl")
        End If
    End Sub

    Private Sub PopulateTableList(ByVal selectedStudy As Study)
        Me.TableList.DataSource = Nothing
        Me.TableList.Items.Clear()
        If Not selectedStudy Is Nothing Then
            Me.TableList.DisplayMember = "Name"
            Me.TableList.DataSource = selectedStudy.GetStudyTables
        End If
    End Sub


    Private Sub PopulateFieldList(ByVal tbl As StudyTable)
        Me.FieldList.Items.Clear()
        If Not tbl Is Nothing Then
            For Each col As StudyTableColumn In tbl.Columns
                Me.FieldList.Items.Add(col)
            Next
            'we can't select an item if there're none
            If Me.FieldList.Items.Count > 0 Then
                Me.FieldList.SelectedIndex = 0
            End If
        End If
    End Sub

    Private Sub PopulateOperatorList()

        For Each op As [Operator] In [Operator].AllOperators
            Me.OperatorList.Items.Add(op)
        Next
        Me.OperatorList.SelectedIndex = 0
    End Sub

    Private Function QuotedString(ByVal inputString As String) As String
        Try
            Dim int As Integer = Integer.Parse(inputString)
        Catch ex As Exception
            If Not inputString.StartsWith("'") Then inputString = "'" & inputString
            If Not inputString.EndsWith("'") Then inputString = inputString & "'"
        End Try

        Return inputString
    End Function
    Private Function ParenthesizedString(ByVal inputString As String) As String
        If Not inputString.StartsWith("(") Then inputString = "(" & inputString
        If Not inputString.EndsWith(")") Then inputString = inputString & ")"
        Return inputString
    End Function

    Private Sub AddCriteriaButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles AddCriteriaButton.Click
        'Verify that a field and operator has been selected and that something has been entered for a value
        If FieldList.SelectedIndex <> -1 AndAlso OperatorList.SelectedIndex <> 1 Then 'AndAlso CriteriaValue.Text <> "" Then
            'Get value and operator
            Dim valueText As String = CriteriaValue.Text
            Dim op As [Operator] = DirectCast(OperatorList.SelectedItem, [Operator])

            'If it is like then add quotes and add a % to the end if there isn't one
            If op.Equals([Operator].Like) OrElse op.Equals([Operator].NotLike) Then
                If valueText.IndexOf("%") = -1 Then
                    If valueText.EndsWith("'") Then
                        valueText = valueText.Insert(valueText.Length - 1, "%")
                    Else
                        valueText = valueText & "%"
                    End If
                End If
                valueText = QuotedString(valueText)
            ElseIf op.Equals([Operator].In) OrElse op.Equals([Operator].NotIn) Then
                'If it is IN then add quotes to each value and make sure there are parenthesis
                Dim vals() As String = valueText.Split(Convert.ToChar(","))
                For i As Integer = 0 To vals.Length - 1
                    vals(i) = QuotedString(vals(i).Trim)
                Next
                valueText = String.Join(",", vals)
                valueText = ParenthesizedString(valueText)
            Else
                'For any thing else, just add quotes if needed
                valueText = QuotedString(valueText)
            End If

            'Build the criteria statment, if there is already text then make it an AND otherwise start with WHERE
            Dim criteria As String = FieldList.SelectedItem.ToString & " " & CType(OperatorList.SelectedItem, [Operator]).Value
            If Not op.Equals([Operator].IsNull) AndAlso Not op.Equals([Operator].IsNotNull) Then
                criteria &= " " & valueText
            End If
            If Me.WhereClause.Text.Trim = "" Then
                Me.WhereClause.Text = "WHERE " & criteria
            Else
                Me.WhereClause.Text &= vbCrLf & "AND " & criteria
            End If
        End If
    End Sub

    Private Sub ExecuteButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ExecuteButton.Click
        Try
            Me.Cursor = Cursors.WaitCursor
            Me.ExecuteButton.Enabled = False
            Me.QueryStatusLabel.Text = "Executing Query..."
            Me.QueryStatusLabel.Refresh()
            Me.DataListView.Items.Clear()
            Me.DataListView.Columns.Clear()
            Me.MailingList.Items.Clear()

            If Not Me.StudyNav.SelectedStudy Is Nothing Then
                Dim studyTbl As StudyTable = DirectCast(TableList.SelectedItem, StudyTable)
                Dim tbl As DataTable = studyTbl.Query(Me.WhereClause.Text, MAX_RECORDS)
                Me.PopulateDataListView(tbl)

                If tbl.Rows.Count = MAX_RECORDS Then
                    Me.QueryStatusLabel.Text = "At least " & tbl.Rows.Count & " records matched your query.  Additional records may exist."
                Else
                    Me.QueryStatusLabel.Text = tbl.Rows.Count & " record(s) matched your query."
                End If
            Else
                Me.QueryStatusLabel.Text = ""
            End If
        Finally
            Me.Cursor = Cursors.Default
            Me.ExecuteButton.Enabled = True
        End Try
    End Sub

    Private Sub PopulateDataListView(ByVal tbl As DataTable)
        Me.DataListView.Items.Clear()
        Me.DataListView.Columns.Clear()

        For Each col As DataColumn In tbl.Columns
            Me.DataListView.Columns.Add(col.ColumnName, 75, HorizontalAlignment.Left)
        Next

        For Each row As DataRow In tbl.Rows
            Dim items(tbl.Columns.Count - 1) As String
            For i As Integer = 0 To tbl.Columns.Count - 1
                items(i) = row(i).ToString()
            Next
            Me.DataListView.Items.Add(New ListViewItem(items))
        Next
        If tbl.Rows.Count > 0 Then
            Me.DataListView.Items(0).Selected = True
        End If

        AutoSizeListViewColumns(Me.DataListView)
    End Sub

    Private Sub AutoSizeListViewColumns(ByVal list As ListView)
        Dim g As Graphics = list.CreateGraphics
        For Each col As ColumnHeader In list.Columns
            Dim stringSize As SizeF = g.MeasureString(col.Text, list.Font)
            col.Width = CInt(stringSize.Width) + 20
        Next
        g.Dispose()
    End Sub


    Private Sub StudyNav_StudyChanged(ByVal sender As Object, ByVal e As StudyNavigator.StudyChangedEventArgs) Handles StudyNav.StudyChanged
        Me.Enabled = True
        Me.PopulateTableList(e.NewStudy)
        Me.WhereClause.Text = ""
        Me.DataListView.Items.Clear()
        Me.DataListView.Columns.Clear()
        Me.MailingList.Items.Clear()
    End Sub

    Private Sub DataListView_SelectedIndexChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles DataListView.SelectedIndexChanged
        If Me.DataListView.SelectedItems.Count > 0 Then
            Dim popId As Integer
            Dim studyId As Integer = Me.StudyNav.SelectedStudy.Id
            Dim popColumn As Integer = GetPopIdColumnIndex()

            If popColumn >= 0 Then
                popId = CType(Me.DataListView.SelectedItems(0).SubItems(popColumn).Text, Integer)
                Me.PopulateMailingsList(Mailing.GetMailingsByPopId(popId, studyId))
                Me.MailingList.Enabled = True
            Else
                Me.MailingList.Enabled = False
            End If
        End If
    End Sub

    Private Sub PopulateMailingsList(ByVal mailings As System.Collections.ObjectModel.Collection(Of Mailing))
        Me.MailingList.Items.Clear()
        For Each mail As Mailing In mailings
            Dim items(11) As String
            Dim item As New ListViewItem
            If mail.SentMailId = 0 Then
                item.ImageIndex = 1
                items(1) = ""
            Else
                item.ImageIndex = 0
                items(1) = mail.SentMailId.ToString
            End If
            items(2) = mail.LithoCode
            items(3) = mail.MethodologyStepName
            items(4) = mail.StudyId.ToString
            items(5) = mail.PopId.ToString
            items(6) = mail.ScheduledGenerationDate.ToString
            items(7) = IIf(mail.IsGenerated, mail.GenerationDate, "").ToString
            items(8) = IIf(mail.IsPrinted, mail.PrintDate, "").ToString
            items(9) = IIf(mail.IsMailed, mail.MailDate, "").ToString
            items(10) = IIf(mail.IsNonDeliverable, mail.NonDeliveryDate, "").ToString
            items(11) = IIf(mail.IsReturned, mail.ReturnDate, "").ToString

            item.SubItems.AddRange(items)
            item.Tag = mail
            Me.MailingList.Items.Add(item)
        Next
    End Sub

    Private Function GetPopIdColumnIndex() As Integer
        For Each col As ColumnHeader In Me.DataListView.Columns
            If col.Text.ToUpper = "POP_ID" OrElse col.Text.ToUpper = "POPULATIONPOP_ID" Then
                Return col.Index
            End If
        Next

        Return -1
    End Function

    Private Sub SetDispositionItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SetDispositionItem.Click
        If Me.MailingList.SelectedItems.Count > 0 Then
            Dim mail As Mailing = DirectCast(Me.MailingList.SelectedItems(0).Tag, Mailing)
            If Not mail.SentMailId = 0 Then
                RaiseEvent MailingSelected(Me, New MailingSelectedEventArgs(mail))
            End If
        End If
    End Sub
    Private Sub MailingList_DoubleClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles MailingList.DoubleClick
        If Me.MailingList.SelectedItems.Count > 0 Then
            Dim mail As Mailing = DirectCast(Me.MailingList.SelectedItems(0).Tag, Mailing)
            If Not mail.SentMailId = 0 Then
                RaiseEvent MailingSelected(Me, New MailingSelectedEventArgs(mail))
            End If
        End If
    End Sub

    Private Sub MailingMenu_Popup(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MailingMenu.Popup
        Dim pt As Point = Me.MailingList.PointToClient(System.Windows.Forms.Cursor.Position)
        Dim item As ListViewItem = Me.MailingList.GetItemAt(pt.X, pt.Y)
        If Not item Is Nothing AndAlso Not DirectCast(item.Tag, Mailing).SentMailId = 0 Then
            Me.SetDispositionItem.Visible = True
        Else
            Me.SetDispositionItem.Visible = False
        End If
    End Sub

    Private Sub TableList_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles TableList.SelectedIndexChanged
        If TableList.SelectedIndex >= 0 Then
            Dim tbl As StudyTable = DirectCast(TableList.SelectedItem, StudyTable)
            Me.PopulateFieldList(tbl)
        End If
    End Sub

    Private Sub ClearCriteriaButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ClearCriteriaButton.Click
        Me.WhereClause.Text = ""
    End Sub
End Class

Public Class [Operator]

    Private Enum Operation As Short
        Equals
        Not_Equals
        [Like]
        Not_Like
        [In]
        Not_In
        Is_Null
        Is_Not_Null
        Greater_Than
        Less_Than
        Greater_Than_Equal_To
        Less_Than_Equal_To
    End Enum
    Private mOperation As Operation

    Private Sub New(ByVal op As Operation)
        mOperation = op
    End Sub

    Public Shared ReadOnly Property AllOperators() As [Operator]()
        Get
            Dim opNames As String() = System.Enum.GetNames(GetType(Operation))
            Dim ops(opNames.Length - 1) As [Operator]
            For i As Integer = 0 To opNames.Length - 1
                ops(i) = New [Operator](CType(System.Enum.Parse(GetType(Operation), opNames(i)), Operation))
            Next
            Return ops
        End Get
    End Property

    Public Shared ReadOnly Property EqualTo() As [Operator]
        Get
            Return New [Operator](Operation.Equals)
        End Get
    End Property
    Public Shared ReadOnly Property NotEqualTo() As [Operator]
        Get
            Return New [Operator](Operation.Not_Equals)
        End Get
    End Property
    Public Shared ReadOnly Property [Like]() As [Operator]
        Get
            Return New [Operator](Operation.Like)
        End Get
    End Property
    Public Shared ReadOnly Property NotLike() As [Operator]
        Get
            Return New [Operator](Operation.Not_Like)
        End Get
    End Property
    Public Shared ReadOnly Property [In]() As [Operator]
        Get
            Return New [Operator](Operation.In)
        End Get
    End Property
    Public Shared ReadOnly Property NotIn() As [Operator]
        Get
            Return New [Operator](Operation.Not_In)
        End Get
    End Property
    Public Shared ReadOnly Property IsNull() As [Operator]
        Get
            Return New [Operator](Operation.Is_Null)
        End Get
    End Property
    Public Shared ReadOnly Property IsNotNull() As [Operator]
        Get
            Return New [Operator](Operation.Is_Not_Null)
        End Get
    End Property

    Public Overloads Overrides Function Equals(ByVal obj As Object) As Boolean
        ' Check for null values and compare run-time types.
        If obj Is Nothing Or Not Me.GetType() Is obj.GetType() Then
            Return False
        Else
            Return (mOperation = DirectCast(obj, [Operator]).mOperation)
        End If

    End Function
    Public Overrides Function GetHashCode() As Integer
        Return mOperation
    End Function

    Public Overrides Function ToString() As String
        Select Case mOperation
            Case Operation.Equals
                Return "= (Equals)"
            Case Operation.Not_Equals
                Return "<> (Not Equals)"
            Case Operation.Like
                Return "Like"
            Case Operation.Not_Like
                Return "Not Like"
            Case Operation.In
                Return "In"
            Case Operation.Not_In
                Return "Not In"
            Case Operation.Is_Null
                Return "Is NULL"
            Case Operation.Is_Not_Null
                Return "Is Not NULL"
            Case Operation.Greater_Than
                Return "> (Greater Than)"
            Case Operation.Less_Than
                Return "< (Less Than)"
            Case Operation.Greater_Than_Equal_To
                Return ">= (Greater Than or Equal To)"
            Case Operation.Less_Than_Equal_To
                Return "<= (Less Than or Equal To)"
            Case Else
                Return System.Enum.GetName(mOperation.GetType, mOperation)
        End Select
    End Function

    Public ReadOnly Property Value() As String
        Get
            Select Case mOperation
                Case Operation.Equals
                    Return "="
                Case Operation.Not_Equals
                    Return "<>"
                Case Operation.Like
                    Return "LIKE"
                Case Operation.Not_Like
                    Return "NOT LIKE"
                Case Operation.In
                    Return "IN"
                Case Operation.Not_In
                    Return "NOT IN"
                Case Operation.Is_Null
                    Return "IS NULL"
                Case Operation.Is_Not_Null
                    Return "IS NOT NULL"
                Case Operation.Greater_Than
                    Return ">"
                Case Operation.Less_Than
                    Return "<"
                Case Operation.Greater_Than_Equal_To
                    Return ">="
                Case Operation.Less_Than_Equal_To
                    Return "<="
                Case Else
                    Return System.Enum.GetName(mOperation.GetType, mOperation)
            End Select
        End Get
    End Property

End Class