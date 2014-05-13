Imports System.Windows.Forms
Imports Nrc.DataMart.MySolutions.Library
Imports System.Collections.ObjectModel

Public Class AddCalculatedColumnDialog

    Public Sub New(ByVal studyId As Integer)
        InitializeComponent()
        mStudyId = studyId
    End Sub

    Private mStudyId As Integer

    Private mNewColumn As StudyTableColumn
    Public Property NewColumn() As StudyTableColumn
        Get
            Return mNewColumn
        End Get
        Set(ByVal value As StudyTableColumn)
            mNewColumn = value
        End Set
    End Property

    Public Property StudyId() As Integer
        Get
            Return mStudyId
        End Get
        Set(ByVal value As Integer)
            mStudyId = value
        End Set
    End Property

    Private Sub OK_Button_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles OK_Button.Click
        Dim messages As String = Nothing
        Me.Cursor = Cursors.WaitCursor
        Try
            If ValidateInputs(messages) Then
                mNewColumn = StudyTableColumn.InsertCalculatedStudyTableColumn(StudyId, Me.NameTextBox.Text, Me.DescriptionTextBox.Text, Me.DisplayNameTextBox.Text, Me.FormulaTextBox.Text, messages)
                If messages.Length > 0 Then MessageBox.Show(messages, "Warnings", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Else
                MessageBox.Show(messages, "Invalid inputs", MessageBoxButtons.OK, MessageBoxIcon.Error)
                Return
            End If
        Catch ex As Exception
            Throw
        Finally
            Me.Cursor = Cursors.Default
        End Try

        Me.DialogResult = System.Windows.Forms.DialogResult.OK
        Me.Close()
    End Sub

    Private Sub Cancel_Button_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Cancel_Button.Click
        Me.DialogResult = System.Windows.Forms.DialogResult.Cancel
        Me.Close()
    End Sub

    Private Function ValidateInputs(ByRef messages As String) As Boolean
        Dim isValid As Boolean = True
        Dim messageBuilder As New System.Text.StringBuilder
        Dim tableCollection As Collection(Of StudyTable) = Nothing

        If NameTextBox.Text.Length > Globals.maxColumnNameLength Then
            messageBuilder.AppendLine("Name is too long.  Please shorten to less than " & Globals.maxColumnNameLength.ToString & ".")
            isValid = False
        ElseIf NameTextBox.Text.Length = 0 Then
            messageBuilder.AppendLine("Name cannot be blank.")
            isValid = False
        Else
            'Verify that the name is not already in use
            tableCollection = StudyTable.GetAllStudyTables(StudyId)
            For Each stdyTable As StudyTable In tableCollection
                For Each column As StudyTableColumn In stdyTable.Columns
                    If column.Name.ToUpper = NameTextBox.Text.ToUpper Then
                        If column.IsCalculated Then
                            messageBuilder.AppendLine("A calculated column already exists with that name.  Please specify another name or modify the existing column.")
                        Else
                            messageBuilder.AppendLine("Name is already in use by a non-calculated column.  Please specify another name.")
                        End If
                        isValid = False
                        Exit For
                    End If

                    If column.DisplayName.ToUpper = NameTextBox.Text.ToUpper Then
                        messageBuilder.AppendLine("Name is already in use as a display name.  Please specify another name.")
                        isValid = False
                        Exit For
                    End If
                Next
                If isValid = False Then Exit For
            Next
        End If

        If DisplayNameTextBox.Text.Length > Globals.maxDisplayNameLength Then
            messageBuilder.AppendLine("Display name is too long.  Please shorten to less than " & Globals.maxDisplayNameLength.ToString & ".")
            isValid = False
        End If

        'Verify that the display name is not already in use
        If Not String.IsNullOrEmpty(DisplayNameTextBox.Text) Then
            If tableCollection Is Nothing Then tableCollection = StudyTable.GetAllStudyTables(StudyId)

            For Each stdyTable As StudyTable In tableCollection
                For Each column As StudyTableColumn In stdyTable.Columns
                    If column.DisplayName.ToUpper = DisplayNameTextBox.Text.ToUpper Then
                        messageBuilder.AppendLine("Display name is already in use.  Please specify another display name.")
                        isValid = False
                        Exit For
                    End If

                    If column.IsAvailableOnEReports AndAlso column.Name.ToUpper = DisplayNameTextBox.Text.ToUpper Then
                        messageBuilder.AppendLine("Display name matches an existing name.  Please specify another display name.")
                        isValid = False
                        Exit For
                    End If
                Next
                If isValid = False Then Exit For
            Next
        End If

        If DescriptionTextBox.Text.Length > Globals.maxColumnDescriptionLength Then
            messageBuilder.AppendLine("Description is too long.  Please shorten to less than " & Globals.maxColumnDescriptionLength.ToString & ".")
            isValid = False
        ElseIf DescriptionTextBox.Text.Length = 0 Then
            messageBuilder.AppendLine("Description cannot be blank.")
            isValid = False
        End If

        If FormulaTextBox.Text.Length > Globals.maxFormulaLength Then
            messageBuilder.AppendLine("Formula is too long.  Please shorten to less than " & Globals.maxFormulaLength.ToString & ".")
            isValid = False
        ElseIf FormulaTextBox.Text.Length = 0 Then
            messageBuilder.AppendLine("Formula cannot be blank.")
            isValid = False
        Else
            'Verify that the formula is not already in use
            If tableCollection Is Nothing Then tableCollection = StudyTable.GetAllStudyTables(StudyId)
            For Each stdyTable As StudyTable In tableCollection
                For Each column As StudyTableColumn In stdyTable.Columns
                    If column.Formula IsNot Nothing AndAlso column.Formula.ToUpper.Replace(" ", "") = FormulaTextBox.Text.ToUpper.Replace(" ", "") Then
                        messageBuilder.AppendLine("Formula is already in use on column '" & column.Name & "'.  Please cancel and edit the existing column.")
                        isValid = False
                        Exit For
                    End If
                Next
                If isValid = False Then Exit For
            Next
        End If

        'Only check the syntax if all text values are valid
        If isValid = True Then
            Dim errorMessage As String = Nothing
            If StudyTableColumn.ValidateStudyTableColumnFormula(StudyId, FormulaTextBox.Text, errorMessage) = False Then
                messageBuilder.AppendLine(errorMessage)
                isValid = False
            End If
        End If
        messages = messageBuilder.ToString

        Return isValid
    End Function
End Class
