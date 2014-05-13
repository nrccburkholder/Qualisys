Public Class frmDupChecks
    Inherits NRC.Framework.WinForms.DialogForm

#Region " ListBoxItem "
    ' To store both name and id in the list box.
    Public Class ListBoxItem
        Public ID As Integer
        Public value As String

        Public Sub New(ByVal myID As Integer, ByVal myValue As String)
            ID = myID
            value = myValue
        End Sub

        Public Overrides Function ToString() As String
            Return value
        End Function
    End Class
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
    Friend WithEvents btnClose As System.Windows.Forms.Button
    Friend WithEvents Panel3 As System.Windows.Forms.Panel
    Friend WithEvents lbxSelectedFields As System.Windows.Forms.ListBox
    Friend WithEvents lbxAvailableFields As System.Windows.Forms.ListBox
    Friend WithEvents btnDeSelectAll As System.Windows.Forms.Button
    Friend WithEvents btnSelectAll As System.Windows.Forms.Button
    Friend WithEvents btnSelect As System.Windows.Forms.Button
    Friend WithEvents btnDeSelect As System.Windows.Forms.Button
    Friend WithEvents lblAvailableFields As System.Windows.Forms.Label
    Friend WithEvents lblCheckFields As System.Windows.Forms.Label
    Friend WithEvents Panel2 As System.Windows.Forms.Panel
    Friend WithEvents lbxMatchedFields As System.Windows.Forms.ListBox
    Friend WithEvents lblKeyFields As System.Windows.Forms.Label
    Friend WithEvents cboTableName As System.Windows.Forms.ComboBox
    Friend WithEvents lblTableName As System.Windows.Forms.Label
    Friend WithEvents SectionHeader1 As SectionHeader
    Friend WithEvents lblSubCaption As System.Windows.Forms.Label
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Dim resources As System.Resources.ResourceManager = New System.Resources.ResourceManager(GetType(frmDupChecks))
        Me.btnClose = New System.Windows.Forms.Button
        Me.Panel3 = New System.Windows.Forms.Panel
        Me.lbxSelectedFields = New System.Windows.Forms.ListBox
        Me.lbxAvailableFields = New System.Windows.Forms.ListBox
        Me.btnDeSelectAll = New System.Windows.Forms.Button
        Me.btnSelectAll = New System.Windows.Forms.Button
        Me.btnSelect = New System.Windows.Forms.Button
        Me.btnDeSelect = New System.Windows.Forms.Button
        Me.lblAvailableFields = New System.Windows.Forms.Label
        Me.lblCheckFields = New System.Windows.Forms.Label
        Me.Panel2 = New System.Windows.Forms.Panel
        Me.lbxMatchedFields = New System.Windows.Forms.ListBox
        Me.lblKeyFields = New System.Windows.Forms.Label
        Me.cboTableName = New System.Windows.Forms.ComboBox
        Me.lblTableName = New System.Windows.Forms.Label
        Me.SectionHeader1 = New SectionHeader
        Me.lblSubCaption = New System.Windows.Forms.Label
        Me.Panel3.SuspendLayout()
        Me.Panel2.SuspendLayout()
        Me.SectionHeader1.SuspendLayout()
        Me.SuspendLayout()
        '
        'mPaneCaption
        '
        Me.mPaneCaption.Caption = "Match Field Validation"
        Me.mPaneCaption.Name = "mPaneCaption"
        Me.mPaneCaption.Size = New System.Drawing.Size(448, 26)
        '
        'btnClose
        '
        Me.btnClose.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.btnClose.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.btnClose.Location = New System.Drawing.Point(344, 408)
        Me.btnClose.Name = "btnClose"
        Me.btnClose.TabIndex = 42
        Me.btnClose.Text = "Close"
        '
        'Panel3
        '
        Me.Panel3.Anchor = CType(((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.Panel3.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D
        Me.Panel3.Controls.Add(Me.lbxSelectedFields)
        Me.Panel3.Controls.Add(Me.lbxAvailableFields)
        Me.Panel3.Controls.Add(Me.btnDeSelectAll)
        Me.Panel3.Controls.Add(Me.btnSelectAll)
        Me.Panel3.Controls.Add(Me.btnSelect)
        Me.Panel3.Controls.Add(Me.btnDeSelect)
        Me.Panel3.Controls.Add(Me.lblAvailableFields)
        Me.Panel3.Controls.Add(Me.lblCheckFields)
        Me.Panel3.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Panel3.Location = New System.Drawing.Point(8, 173)
        Me.Panel3.Name = "Panel3"
        Me.Panel3.Size = New System.Drawing.Size(416, 216)
        Me.Panel3.TabIndex = 41
        '
        'lbxSelectedFields
        '
        Me.lbxSelectedFields.Location = New System.Drawing.Point(232, 24)
        Me.lbxSelectedFields.Name = "lbxSelectedFields"
        Me.lbxSelectedFields.SelectionMode = System.Windows.Forms.SelectionMode.MultiExtended
        Me.lbxSelectedFields.Size = New System.Drawing.Size(168, 173)
        Me.lbxSelectedFields.Sorted = True
        Me.lbxSelectedFields.TabIndex = 23
        '
        'lbxAvailableFields
        '
        Me.lbxAvailableFields.Location = New System.Drawing.Point(8, 24)
        Me.lbxAvailableFields.Name = "lbxAvailableFields"
        Me.lbxAvailableFields.SelectionMode = System.Windows.Forms.SelectionMode.MultiExtended
        Me.lbxAvailableFields.Size = New System.Drawing.Size(168, 173)
        Me.lbxAvailableFields.Sorted = True
        Me.lbxAvailableFields.TabIndex = 22
        '
        'btnDeSelectAll
        '
        Me.btnDeSelectAll.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.btnDeSelectAll.Location = New System.Drawing.Point(184, 144)
        Me.btnDeSelectAll.Name = "btnDeSelectAll"
        Me.btnDeSelectAll.Size = New System.Drawing.Size(40, 24)
        Me.btnDeSelectAll.TabIndex = 21
        Me.btnDeSelectAll.Text = "<<"
        '
        'btnSelectAll
        '
        Me.btnSelectAll.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.btnSelectAll.Location = New System.Drawing.Point(184, 48)
        Me.btnSelectAll.Name = "btnSelectAll"
        Me.btnSelectAll.Size = New System.Drawing.Size(40, 24)
        Me.btnSelectAll.TabIndex = 20
        Me.btnSelectAll.Text = ">>"
        '
        'btnSelect
        '
        Me.btnSelect.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.btnSelect.Location = New System.Drawing.Point(184, 80)
        Me.btnSelect.Name = "btnSelect"
        Me.btnSelect.Size = New System.Drawing.Size(40, 24)
        Me.btnSelect.TabIndex = 4
        Me.btnSelect.Text = ">"
        '
        'btnDeSelect
        '
        Me.btnDeSelect.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.btnDeSelect.Location = New System.Drawing.Point(184, 112)
        Me.btnDeSelect.Name = "btnDeSelect"
        Me.btnDeSelect.Size = New System.Drawing.Size(40, 24)
        Me.btnDeSelect.TabIndex = 7
        Me.btnDeSelect.Text = "<"
        '
        'lblAvailableFields
        '
        Me.lblAvailableFields.Location = New System.Drawing.Point(8, 8)
        Me.lblAvailableFields.Name = "lblAvailableFields"
        Me.lblAvailableFields.Size = New System.Drawing.Size(100, 16)
        Me.lblAvailableFields.TabIndex = 19
        Me.lblAvailableFields.Text = "Available Fields:"
        '
        'lblCheckFields
        '
        Me.lblCheckFields.Location = New System.Drawing.Point(232, 8)
        Me.lblCheckFields.Name = "lblCheckFields"
        Me.lblCheckFields.Size = New System.Drawing.Size(104, 16)
        Me.lblCheckFields.TabIndex = 17
        Me.lblCheckFields.Text = "Selected Fields:"
        '
        'Panel2
        '
        Me.Panel2.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.Panel2.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D
        Me.Panel2.Controls.Add(Me.lbxMatchedFields)
        Me.Panel2.Controls.Add(Me.lblKeyFields)
        Me.Panel2.Controls.Add(Me.cboTableName)
        Me.Panel2.Controls.Add(Me.lblTableName)
        Me.Panel2.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Panel2.Location = New System.Drawing.Point(8, 56)
        Me.Panel2.Name = "Panel2"
        Me.Panel2.Size = New System.Drawing.Size(416, 104)
        Me.Panel2.TabIndex = 40
        '
        'lbxMatchedFields
        '
        Me.lbxMatchedFields.Items.AddRange(New Object() {"Addr", "DOB", "FName", "LName", "MRN"})
        Me.lbxMatchedFields.Location = New System.Drawing.Point(232, 24)
        Me.lbxMatchedFields.Name = "lbxMatchedFields"
        Me.lbxMatchedFields.SelectionMode = System.Windows.Forms.SelectionMode.None
        Me.lbxMatchedFields.Size = New System.Drawing.Size(168, 69)
        Me.lbxMatchedFields.Sorted = True
        Me.lbxMatchedFields.TabIndex = 25
        '
        'lblKeyFields
        '
        Me.lblKeyFields.Location = New System.Drawing.Point(232, 8)
        Me.lblKeyFields.Name = "lblKeyFields"
        Me.lblKeyFields.Size = New System.Drawing.Size(112, 48)
        Me.lblKeyFields.TabIndex = 24
        Me.lblKeyFields.Text = "Matched Fields:"
        '
        'cboTableName
        '
        Me.cboTableName.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.cboTableName.Items.AddRange(New Object() {"Population", "Encounter", "Provider"})
        Me.cboTableName.Location = New System.Drawing.Point(8, 24)
        Me.cboTableName.Name = "cboTableName"
        Me.cboTableName.Size = New System.Drawing.Size(216, 21)
        Me.cboTableName.TabIndex = 23
        '
        'lblTableName
        '
        Me.lblTableName.Location = New System.Drawing.Point(8, 8)
        Me.lblTableName.Name = "lblTableName"
        Me.lblTableName.Size = New System.Drawing.Size(80, 32)
        Me.lblTableName.TabIndex = 22
        Me.lblTableName.Text = "Study Tables:"
        '
        'SectionHeader1
        '
        Me.SectionHeader1.Controls.Add(Me.lblSubCaption)
        Me.SectionHeader1.Dock = System.Windows.Forms.DockStyle.Top
        Me.SectionHeader1.Location = New System.Drawing.Point(1, 27)
        Me.SectionHeader1.Name = "SectionHeader1"
        Me.SectionHeader1.Size = New System.Drawing.Size(448, 21)
        Me.SectionHeader1.TabIndex = 43
        '
        'lblSubCaption
        '
        Me.lblSubCaption.BackColor = System.Drawing.Color.Transparent
        Me.lblSubCaption.Dock = System.Windows.Forms.DockStyle.Fill
        Me.lblSubCaption.Font = New System.Drawing.Font("Tahoma", 9.75!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lblSubCaption.Location = New System.Drawing.Point(0, 0)
        Me.lblSubCaption.Name = "lblSubCaption"
        Me.lblSubCaption.Size = New System.Drawing.Size(448, 21)
        Me.lblSubCaption.TabIndex = 0
        Me.lblSubCaption.Text = " Study (1234)"
        '
        'frmDupChecks
        '
        Me.AutoScaleBaseSize = New System.Drawing.Size(8, 20)
        Me.Caption = "Match Field Validation"
        Me.ClientSize = New System.Drawing.Size(450, 448)
        Me.Controls.Add(Me.SectionHeader1)
        Me.Controls.Add(Me.btnClose)
        Me.Controls.Add(Me.Panel3)
        Me.Controls.Add(Me.Panel2)
        Me.DockPadding.All = 1
        Me.Font = New System.Drawing.Font("Tahoma", 12.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Icon = CType(resources.GetObject("$this.Icon"), System.Drawing.Icon)
        Me.MaximumSize = New System.Drawing.Size(450, 450)
        Me.MinimumSize = New System.Drawing.Size(420, 400)
        Me.Name = "frmDupChecks"
        Me.Text = "Select available fields for Match Field Validation"
        Me.Controls.SetChildIndex(Me.mPaneCaption, 0)
        Me.Controls.SetChildIndex(Me.Panel2, 0)
        Me.Controls.SetChildIndex(Me.Panel3, 0)
        Me.Controls.SetChildIndex(Me.btnClose, 0)
        Me.Controls.SetChildIndex(Me.SectionHeader1, 0)
        Me.Panel3.ResumeLayout(False)
        Me.Panel2.ResumeLayout(False)
        Me.SectionHeader1.ResumeLayout(False)
        Me.ResumeLayout(False)

    End Sub

#End Region

    Structure fieldProperties
        Dim ID As Integer
        Dim name As String
        Dim MF As Boolean
        Dim MFV As Boolean
    End Structure

    Structure studyTable
        Dim ID As Integer
        Dim Name As String
        Dim field As fieldProperties()
    End Structure

    Private mTable As studyTable() ' Store locally the study tables
    Private selectedTable As Integer ' local var for selected table
    Private fieldList As String = "" ' local storage for the list of the fields
    Private dupCheckModified As Boolean = False
    Public mStudy As New Study   ' study ID can be passed here if package is open.

    Private Sub frmDupChecks_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        ' The user can define match field validation through
        ' the client navigation at the study level only so there
        ' is no need to pop up the study selector for the user.
        Me.cboTableName.Items.Clear() ' Clear study tables.
        Me.lbxMatchedFields.Items.Clear()
        Me.lbxSelectedFields.Items.Clear()
        Me.lbxAvailableFields.Items.Clear()

        With mStudy
            Me.lblSubCaption.Text = " Study - " & Trim(.StudyName) & " (" & .StudyID.ToString & ")"
        End With

        If GetStudyTables() Then
            PopulateStudyTableCombo() ' Populate Study Table combobox
            PopulateFieldListBox()    ' Populate match, available, and selected fields list box
        End If
    End Sub

    Private Function GetStudyTables() As Boolean
        ' GetMatchFields will be called once and all information
        ' will be stored in mTable array list.
        ' Table returns all tables with all fields:
        ' Table_id, strTable_nm, Field_id, strField_nm, bitMatchField_flg, bitMFV
        Dim DT As DataTable = _
            Study.GetMatchFields(mStudy.StudyID)

        If DT.Rows.Count = 0 Then
            GetStudyTables = False
            Exit Function
        End If

        Dim i As Integer = -1 ' table counter
        Dim j As Integer      ' field counter

        Dim tableID As Integer
        Dim tableName As String
        Dim fieldID As Integer
        Dim fieldName As String
        Dim MF As Boolean  ' Match field
        Dim MFV As Boolean ' Match field validation

        Dim ID As Integer = -1
        Dim row As DataRow

        For Each row In DT.Rows
            tableID = CType(row.Item("Table_id"), Integer)
            tableName = Trim(row.Item("strTable_nm").ToString)
            fieldID = CType(row.Item("Field_id"), Integer)
            fieldName = Trim(row.Item("strField_nm").ToString)
            MF = CType(row.Item("bitMatchField_flg"), Boolean)
            MFV = CType(row.Item("bitMFV"), Boolean)

            If ID <> tableID Then
                i += 1 ' Increment the table counter
                j = 0  ' Reset the field counter to 0 for a new table
                ReDim Preserve mTable(i)
                With mTable(i)
                    .ID = tableID
                    .Name = tableName
                End With
                ID = tableID
            End If
            ReDim Preserve mTable(i).field(j)
            With mTable(i).field(j)
                .ID = fieldID
                .name = fieldName
                .MF = MF
                .MFV = MFV
            End With
            j += 1 ' Increment the field counter for a table
        Next
        GetStudyTables = True
    End Function

    Private Sub PopulateStudyTableCombo()
        Me.cboTableName.Items.Clear() ' Clear study tables.

        Dim i As Integer

        ' Populate the study tables.
        For i = 0 To mTable.Length - 1
            Me.cboTableName.Items.Add(New ListBoxItem(mTable(i).ID, mTable(i).Name))
        Next
        Me.cboTableName.SelectedIndex = 0 ' Default selected table
    End Sub

    Private Sub PopulateFieldListBox()
        ' Clear Matched, Available, and Selected fields.
        Me.lbxMatchedFields.Items.Clear()
        Me.lbxAvailableFields.Items.Clear()
        Me.lbxSelectedFields.Items.Clear()
        selectedTable = CType(Me.cboTableName.SelectedItem, ListBoxItem).ID

        Dim i As Integer
        Dim fieldName As String
        Dim fieldID As Integer

        ' Populate Matched, Available, and Selected list boxes for
        ' selected study table.
        For i = 0 To mTable(Me.cboTableName.SelectedIndex).field.Length - 1
            With mTable(Me.cboTableName.SelectedIndex).field(i)
                fieldName = .name
                fieldID = .ID
                If .MF Then ' match field
                    ' This fields in this list box are predefined.
                    Me.lbxMatchedFields.Items.Add(New ListBoxItem(fieldID, fieldName))
                Else
                    If .MFV Then ' match field validation
                        Me.lbxSelectedFields.Items.Add(New ListBoxItem(fieldID, fieldName))
                    Else
                        Me.lbxAvailableFields.Items.Add(New ListBoxItem(fieldID, fieldName))
                    End If
                End If
            End With
        Next
    End Sub

    Private Sub MoveFields(ByVal field As Integer)
        ' Select the match field validation for the study.
        Dim item As Integer

        Select Case field
            Case 1 ' Select all fields (>>)
                For item = 0 To Me.lbxAvailableFields.Items.Count - 1
                    Me.lbxSelectedFields.Items.Add(Me.lbxAvailableFields.Items(item))
                Next
                Me.lbxAvailableFields.Items.Clear()
            Case 2 ' Select one or more fields (>)
                While Me.lbxAvailableFields.SelectedIndices.Count > 0
                    Me.lbxSelectedFields.Items.Add(Me.lbxAvailableFields.SelectedItems(0))
                    Me.lbxAvailableFields.Items.RemoveAt(Me.lbxAvailableFields.SelectedIndices(0))
                End While
            Case 3 ' Deselect one or more fields (<)
                While Me.lbxSelectedFields.SelectedIndices.Count > 0
                    Me.lbxAvailableFields.Items.Add(Me.lbxSelectedFields.SelectedItems(0))
                    Me.lbxSelectedFields.Items.RemoveAt(Me.lbxSelectedFields.SelectedIndices(0))
                End While
            Case 4 ' Deselect all fields (<<)
                For item = 0 To Me.lbxSelectedFields.Items.Count - 1
                    Me.lbxAvailableFields.Items.Add(Me.lbxSelectedFields.Items(item))
                Next
                Me.lbxSelectedFields.Items.Clear() ' Clear the match field validation listbox
        End Select

        GetSelectedFields()
        dupCheckModified = True
    End Sub

    Private Sub GetSelectedFields()
        Dim count As Integer = Me.lbxSelectedFields.Items.Count
        Dim item As Integer

        fieldList = ""
        If count > 0 Then
            ' Match field validation items are selected.  Store
            ' all the selected items into the field list separated
            ' by comma.
            For item = 0 To count - 2
                fieldList = fieldList & _
                            CType(Me.lbxSelectedFields.Items(item), ListBoxItem).ID.ToString & ","
            Next
            fieldList = fieldList & _
                        CType(Me.lbxSelectedFields.Items(count - 1), ListBoxItem).ID.ToString
        Else
            ' The user deselects all the match field validation for
            ' the study.  However Field list can't be empty because 
            ' of the store procedure LD_MatchFieldValidation.
            ' If no fields are selected, assign -1 to the fieldlist.
            fieldList = "-1"
        End If
    End Sub

    Private Sub SaveSelectedFields()
        ' SaveMatchFields saves one study table at a time so the user will be
        ' forced to save the changes before switching to another table.
        Study.SaveMatchFields(mStudy.StudyID, selectedTable, fieldList)
    End Sub

    Private Sub cboTableName_SelectionChangeCommitted(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cboTableName.SelectionChangeCommitted
        ' If the user modifies the match field validation for any study table,
        ' he/she will be forced to save the changes before switching to another
        ' table.
        If dupCheckModified Then
            If MsgBox("Save changes before switching the tables", _
                MsgBoxStyle.YesNo, "Match Field Validation") = MsgBoxResult.Yes _
                Then SaveSelectedFields()
        End If
        PopulateFieldListBox()
        dupCheckModified = False
    End Sub

    Private Sub btnSelectAll_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnSelectAll.Click
        MoveFields(1) ' (>>)
    End Sub

    Private Sub btnSelect_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnSelect.Click
        MoveFields(2) ' (>)
    End Sub

    Private Sub btnDeSelect_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnDeSelect.Click
        MoveFields(3) ' (<)
    End Sub

    Private Sub btnDeSelectAll_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnDeSelectAll.Click
        MoveFields(4) ' (<<)
    End Sub

    Private Sub btnClose_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnClose.Click
        Me.Close()
    End Sub

    Private Sub frmDupChecks_Closing(ByVal sender As Object, ByVal e As System.ComponentModel.CancelEventArgs) Handles MyBase.Closing
        If dupCheckModified Then
            Dim result As DialogResult = MessageBox.Show("Save changes before closing?", "Match Field Validation", MessageBoxButtons.YesNoCancel)

            Select Case result
                Case Windows.Forms.DialogResult.Cancel
                    e.Cancel = True
                Case Windows.Forms.DialogResult.No
                    ' Do nothing
                Case Windows.Forms.DialogResult.Yes
                    SaveSelectedFields()
            End Select
        End If
    End Sub

End Class
