Imports Nrc.Qualisys.Library

Public Class CriteriaEditor

#Region "Private Fields"

    Private mShowStatement As Boolean = True
    Private mShowRuleName As Boolean = True
    Private mCriteriaStmt As Criteria

    Private mCurrentPhrase As Integer
    Private mIsClearing As Boolean
    Private mIsAdding As Boolean
    Private mStudyColumns As New Dictionary(Of String, StudyTableColumn)
    Private mOperators As New Dictionary(Of String, CriteriaClause.Operators)

#End Region


#Region "Public Properties"

    Public Property ShowCriteriaStatement() As Boolean
        Get
            Return mShowStatement
        End Get
        Set(ByVal value As Boolean)

            mShowStatement = value

            ShowCriteriaSection(mShowStatement)

        End Set
    End Property


    Public Property ShowRuleName() As Boolean
        Get
            Return mShowRuleName
        End Get
        Set(ByVal value As Boolean)

            mShowRuleName = value

            ShowRuleNameSection(mShowRuleName)

        End Set
    End Property


    Public Property CriteriaStmt() As Criteria
        Get
            Return mCriteriaStmt
        End Get
        Set(ByVal value As Criteria)

            'Save the reference
            mCriteriaStmt = value

            'Clear the control
            ClearCriteria()

            'Populate the combobox lists bases on the current study_id
            InitializeLists()

            'If the criteria object is not nothing then populate the control
            If mCriteriaStmt IsNot Nothing Then
                'Populate the rule name
                If mShowRuleName Then
                    RuleNameTextbox.Text = mCriteriaStmt.Name.Trim
                    IsRuleNameValid()
                Else
                    RuleNameTextbox.Text = ""
                    mCriteriaStmt.Name = ""
                End If

                'Populate the phrases and clauses
                InitializeCriteria()

                'If the are no phrases in this criteria object then let's add a new one
                If mCriteriaStmt.Phrases.Count = 0 Then
                    AddPhrase()
                End If
            End If

            'Set the focus to the first control
            If mShowRuleName Then
                RuleNameTextbox.Focus()
            Else
                PhrasesListView.Focus()
            End If


        End Set
    End Property


    Public Function IsValid() As Boolean

        'Validate entire control
        Return (IsRuleNameValid() And ArePhrasesValid())

    End Function

#End Region


#Region "Event Handlers"

    Private Sub RuleNameTextbox_TextChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles RuleNameTextbox.TextChanged

        If mCriteriaStmt IsNot Nothing AndAlso Not mIsClearing Then
            mCriteriaStmt.Name = RuleNameTextbox.Text.Trim
            IsRuleNameValid()
        End If

    End Sub


    Private Sub PhrasesAddButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles PhrasesAddButton.Click

        AddPhrase()

    End Sub


    Private Sub PhrasesDeleteButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles PhrasesDeleteButton.Click

        DeletePhrase(True)

    End Sub


    Private Sub ClausesAddButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ClausesAddButton.Click

        If PhrasesListView.Items.Count = 0 Then
            AddPhrase()
        Else
            AddClause(mCurrentPhrase)
        End If

    End Sub


    Private Sub ClausesDeleteButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ClausesDeleteButton.Click

        DeleteClause(mCurrentPhrase)

    End Sub


    Private Sub PhrasesListView_ItemSelectionChanged(ByVal sender As Object, ByVal e As System.Windows.Forms.ListViewItemSelectionChangedEventArgs) Handles PhrasesListView.ItemSelectionChanged

        If mIsAdding OrElse mCurrentPhrase = e.ItemIndex Then Exit Sub

        LoadClauses(e.ItemIndex)
        mCurrentPhrase = e.ItemIndex

    End Sub


    Private Sub ClausesDataGrid_CellValidating(ByVal sender As Object, ByVal e As System.Windows.Forms.DataGridViewCellValidatingEventArgs) Handles ClausesDataGrid.CellValidating

        If mIsClearing Then Exit Sub

        Dim cell As DataGridViewCell = ClausesDataGrid.Rows(e.RowIndex).Cells(e.ColumnIndex)

        Select Case e.ColumnIndex
            Case FieldColumn.Index
                IsFieldColumnValid(mCurrentPhrase, cell)

            Case OperatorColumn.Index
                IsOperatorColumnValid(mCurrentPhrase, cell)

            Case ParameterColumn.Index
                IsParameterColumnValid(mCurrentPhrase, cell)

        End Select

    End Sub


    Private Sub ClausesDataGrid_RowValidating(ByVal sender As Object, ByVal e As System.Windows.Forms.DataGridViewCellCancelEventArgs) Handles ClausesDataGrid.RowValidating

        If Not mIsClearing Then IsClauseValid(mCurrentPhrase, e.RowIndex)

    End Sub


    Private Sub ClausesDataGrid_EditingControlShowing(ByVal sender As Object, ByVal e As System.Windows.Forms.DataGridViewEditingControlShowingEventArgs) Handles ClausesDataGrid.EditingControlShowing

        If e.Control.GetType.Name = "DataGridViewComboBoxEditingControl" Then
            Dim cboBox As ComboBox = TryCast(e.Control, ComboBox)
            If cboBox IsNot Nothing Then
                RemoveHandler cboBox.SelectionChangeCommitted, AddressOf DataGridViewComboBox_SelectedIndexChanged
                AddHandler cboBox.SelectionChangeCommitted, AddressOf DataGridViewComboBox_SelectedIndexChanged
            End If
        ElseIf e.Control.GetType.Name = "DataGridViewTextBoxEditingControl" Then
            Dim txtBox As TextBox = TryCast(e.Control, TextBox)
            If txtBox IsNot Nothing Then
                RemoveHandler txtBox.TextChanged, AddressOf DataGridViewTextBox_TextChanged
                AddHandler txtBox.TextChanged, AddressOf DataGridViewTextBox_TextChanged
            End If
        End If

    End Sub


    Private Sub DataGridViewComboBox_SelectedIndexChanged(ByVal sender As Object, ByVal e As EventArgs)

        'Get a reference to the combobox
        Dim cboBox As ComboBox = CType(sender, ComboBox)

        'Get a reference to the current grid cell
        Dim currentCell As DataGridViewCell = ClausesDataGrid.CurrentCell

        'Set the cell value based on the combobox selection
        currentCell.Value = cboBox.SelectedItem.ToString

        'Take care of other column specific tasks
        Select Case currentCell.ColumnIndex
            Case FieldColumn.Index
                'Update the criteria clause
                UpdateClauseField(mCurrentPhrase, currentCell.RowIndex)

                'Unlock the operator column so the user can pick one
                ClausesDataGrid.CurrentRow.Cells(OperatorColumn.Index).ReadOnly = False

            Case OperatorColumn.Index
                'Update the criteria object
                UpdateClauseOperator(mCurrentPhrase, currentCell.RowIndex)

                'If the selected operator is IS or IS NOT then set the Parameter to NULL
                Dim oper As CriteriaClause.Operators = mOperators(currentCell.Value.ToString)
                If oper = CriteriaClause.Operators.[Is] OrElse oper = CriteriaClause.Operators.[IsNot] Then
                    'Set the grid cell to NULL and lock it
                    ClausesDataGrid.CurrentRow.Cells(ParameterColumn.Index).Value = "NULL"
                    ClausesDataGrid.CurrentRow.Cells(ParameterColumn.Index).ReadOnly = True

                    'Update the criteria object
                    UpdateClauseParameter(mCurrentPhrase, currentCell.RowIndex)
                Else
                    'Unlock the parameter column so the user can enter data
                    ClausesDataGrid.CurrentRow.Cells(ParameterColumn.Index).ReadOnly = False

                    'Re-parse the parameter column into the new operator format
                    UpdateClauseParameter(mCurrentPhrase, currentCell.RowIndex)
                End If

        End Select

        'Recalculate and display the Criteria string
        CriteriaStringTextBox.Text = CriteriaString()

    End Sub


    Private Sub DataGridViewTextBox_TextChanged(ByVal sender As Object, ByVal e As System.EventArgs)

        'Get a reference to the textbox
        Dim txtBox As TextBox = CType(sender, TextBox)

        'Get a reference to the current grid cell
        Dim currentCell As DataGridViewCell = ClausesDataGrid.CurrentCell

        'Set the cell value based on the textbox value
        currentCell.Value = txtBox.Text

        'Update the criteria object
        UpdateClauseParameter(mCurrentPhrase, currentCell.RowIndex)

        'Recalculate and display the Criteria string
        CriteriaStringTextBox.Text = CriteriaString()

    End Sub

#End Region


#Region "Private Methods"

#Region "Property Helper Methods"

    Private Sub ShowCriteriaSection(ByVal showSection As Boolean)

        SplitMain.Panel2Collapsed = Not (showSection)

    End Sub


    Private Sub ShowRuleNameSection(ByVal showSection As Boolean)

        Dim phraseLoc As System.Drawing.Point
        Dim phraseSize As System.Drawing.Size

        'Set the visibility of the rule name controls
        RuleNameLabel.Visible = showSection
        RuleNameTextbox.Visible = showSection

        If showSection Then
            'Determine the location of the PhraseListView
            phraseLoc = New System.Drawing.Point(PhrasesListView.Location.X, RuleNameTextbox.Location.Y + RuleNameTextbox.Size.Height + 6)

            'Populate the rule name
            Try
                RuleNameTextbox.Text = mCriteriaStmt.Name.Trim
            Catch
                RuleNameTextbox.Text = ""
            End Try
        Else
            'Determine the location of the PhraseListView
            phraseLoc = New System.Drawing.Point(PhrasesListView.Location.X, RuleNameLabel.Location.Y)

            'Populate the rule name
            RuleNameTextbox.Text = ""
            If mCriteriaStmt IsNot Nothing Then mCriteriaStmt.Name = ""
        End If

        'Determine the size of the PhraseListView
        phraseSize = New System.Drawing.Size(PhrasesListView.Size.Width, PhrasesAddButton.Location.Y - phraseLoc.Y - 6)

        'Setup the PhraseListView control
        With PhrasesListView
            .Location = phraseLoc
            .Size = phraseSize
        End With

    End Sub

#End Region

#Region "Criteria Methods"

    Private Sub ClearCriteria()

        'Clear the entire control
        mIsClearing = True
        mCurrentPhrase = -1
        RuleNameTextbox.Text = ""
        PhrasesListView.Items.Clear()
        ClausesDataGrid.Rows.Clear()
        CriteriaStringTextBox.Text = ""
        mIsClearing = False

    End Sub


    Private Sub InitializeCriteria()

        'Load the phrases
        LoadPhrases()

        'Populate the string
        CriteriaStringTextBox.Text = CriteriaString()

    End Sub


    Private Sub LoadCriteria()

        'Clear the entire control
        ClearCriteria()

        'Load the new criteria
        InitializeCriteria()

    End Sub

#End Region

#Region "Phrase Methods"

    Private Sub AddPhrase()

        'Add the new phrase to the criteria object
        mCriteriaStmt.Phrases.Add(New CriteriaPhrase())

        'Add the new phrase to the listview and select it
        Dim phraseCnt As Integer = PhrasesListView.Items.Add(GetPhraseName(PhrasesListView.Items.Count)).Index
        mIsAdding = True
        PhrasesListView.Items(phraseCnt).Selected = True
        mIsAdding = False

        'Load the clauses (this sets the statement name and clears the ClausesGridView)
        LoadClauses(phraseCnt)

        'Save the index of the new current phrase
        mCurrentPhrase = phraseCnt

        'Add a new clause
        AddClause(mCurrentPhrase)

    End Sub


    Private Sub DeletePhrase(ByVal promptUser As Boolean)

        'if there is no selected phrase then we are out of here
        If mCurrentPhrase < 0 Then Exit Sub

        'Ask the user if this is what they want to do
        Dim doDelete As System.Windows.Forms.DialogResult = DialogResult.OK
        If promptUser Then
            doDelete = MessageBox.Show("Are you sure you want to delete the selected Phrase?", "Criteria Phrase Delete", _
                                       MessageBoxButtons.OKCancel, MessageBoxIcon.Question, MessageBoxDefaultButton.Button2)
        End If

        'Do the deed if required
        If doDelete = DialogResult.OK Then
            'They said to delete it so let's zap the sucker
            mCriteriaStmt.Phrases.RemoveAt(mCurrentPhrase)

            'Refresh the screen
            LoadCriteria()
        End If

    End Sub


    Private Sub LoadPhrases()

        'Populate the listview with all of the existing phrases
        With PhrasesListView
            'Loop through all of the phrases
            For phraseCnt As Integer = 0 To mCriteriaStmt.Phrases.Count - 1
                'Add the phrase to the listview
                .Items.Add(GetPhraseName(phraseCnt))

                'We need to load the clauses in the ClausesDataGrid so we can set all of the validation stuff
                'NOTE: We don't need to do this for the first phrase because that one will get done below
                If phraseCnt > 0 Then LoadClauses(phraseCnt)
            Next

            'Determine what else needs to be done
            If mCriteriaStmt.Phrases.Count > 0 Then
                'Since at least one phrase exists, select the first one
                mCurrentPhrase = 0
                mIsAdding = True
                .Items(mCurrentPhrase).Selected = True
                mIsAdding = False
                LoadClauses(mCurrentPhrase)
            Else
                'No phrases exist
                mCurrentPhrase = -1
                PhraseNameLabel.Text = ""
            End If
        End With

    End Sub

#End Region

#Region "Clause Methods"

    Private Sub AddClause(ByVal phraseCnt As Integer)

        'Add the new clause to the ClausesGridView
        Dim clauseCnt As Integer = ClausesDataGrid.Rows.Add()

        'Add the new clause to the criteria object
        mCriteriaStmt.Phrases(phraseCnt).Clauses.Add(New CriteriaClause)

        'Set the validation for the new clause
        IsClauseValid(phraseCnt, clauseCnt)

        'Set the properties on the new clause row
        With ClausesDataGrid.Rows(clauseCnt)
            'Determine what the name for the row header is
            If clauseCnt = 0 Then
                'First row does not get a name
                .HeaderCell.Value = ""
            Else
                'All other rows do
                .HeaderCell.Value = "AND"
            End If

            'Make the Field column the selected one
            .Cells(FieldColumn.Index).Selected = True

            'Lock the remaining columns so they cannot be accessed until a field is selected
            .Cells(OperatorColumn.Index).ReadOnly = True
            .Cells(ParameterColumn.Index).ReadOnly = True
        End With

    End Sub


    Private Sub DeleteClause(ByVal phraseCnt As Integer)

        'If there is no selected clause then we are out of here
        If ClausesDataGrid.SelectedCells.Count = 0 Then Exit Sub

        'Ask the user if this is what they want to do
        If MessageBox.Show("Are you sure you want to delete the selected Clause?", "Criteria Clause Delete", _
                           MessageBoxButtons.OKCancel, MessageBoxIcon.Question, MessageBoxDefaultButton.Button2) = DialogResult.OK Then
            'They said to delete it so let's get the index of the clause to be deleted
            Dim clauseCnt As Integer = ClausesDataGrid.SelectedCells.Item(0).RowIndex

            'Delete the clause from the criteria object
            mCriteriaStmt.Phrases(phraseCnt).Clauses.RemoveAt(clauseCnt)

            'Delete the clause from the ClausesDataGrid
            ClausesDataGrid.Rows.RemoveAt(clauseCnt)

            'Determine what else needs to be done
            If mCriteriaStmt.Phrases(phraseCnt).Clauses.Count = 0 Then
                'This was the last clause in this phrase so delete the phrase too
                DeletePhrase(False)
            Else
                'There are clauses remaining so make sure the first on does not have anything in the RowHeaderCell
                ClausesDataGrid.Rows(0).HeaderCell.Value = ""
            End If
        End If

    End Sub


    Private Sub LoadClauses(ByVal phraseCnt As Integer)

        'Show the phrase name
        PhraseNameLabel.Text = PhrasesListView.Items(phraseCnt).Text

        'Clear the existing clauses
        mIsClearing = True
        ClausesDataGrid.Rows.Clear()
        mIsClearing = False

        'Populate the clauses
        With mCriteriaStmt.Phrases(phraseCnt)
            For clauseCnt As Integer = 0 To .Clauses.Count - 1
                With .Clauses(clauseCnt)
                    'Add this clause to the grid
                    ClausesDataGrid.Rows.Add(.AliasedColumnName, .OperatorName, .DisplayValue)

                    'Set the text on the header cell
                    If clauseCnt = 0 Then
                        ClausesDataGrid.Rows(clauseCnt).HeaderCell.Value = ""
                    Else
                        ClausesDataGrid.Rows(clauseCnt).HeaderCell.Value = "AND"
                    End If

                    'Determine what cells if any need to be set to readonly
                    If .AliasedColumnName = String.Empty Then
                        'No field has been selected yet so lock everything else down
                        ClausesDataGrid.Rows(clauseCnt).Cells(OperatorColumn.Index).ReadOnly = True
                        ClausesDataGrid.Rows(clauseCnt).Cells(ParameterColumn.Index).ReadOnly = True
                    ElseIf .OperatorName = String.Empty Then
                        'No operator has been selected yet so lock the parameter column
                        ClausesDataGrid.Rows(clauseCnt).Cells(ParameterColumn.Index).ReadOnly = True
                    ElseIf mOperators(.OperatorName) = CriteriaClause.Operators.[Is] OrElse mOperators(.OperatorName) = CriteriaClause.Operators.[IsNot] Then
                        'The operator is IS or IS NOT so make the parameter cell readonly
                        ClausesDataGrid.Rows(clauseCnt).Cells(ParameterColumn.Index).ReadOnly = True
                    Else
                        'The parameter cell for all other operators needs to have the cell editable
                        ClausesDataGrid.Rows(clauseCnt).Cells(ParameterColumn.Index).ReadOnly = False
                    End If
                End With

                'Validate this clause
                IsClauseValid(phraseCnt, clauseCnt)
            Next
        End With

    End Sub


    Private Sub UpdateClauseField(ByVal phraseCnt As Integer, ByVal clauseCnt As Integer)

        'Get a reference to the field cell
        Dim cell As DataGridViewCell = ClausesDataGrid.Rows(clauseCnt).Cells(FieldColumn.Index)

        'Update the field information in the criteria object
        With mCriteriaStmt.Phrases(phraseCnt).Clauses(clauseCnt)
            .StudyTableColumn = mStudyColumns(cell.Value.ToString)
            .StudyTable = StudyTable.Get(.StudyTableColumn.TableId)
        End With

        'Check the field cell validation
        IsFieldColumnValid(phraseCnt, cell)

    End Sub


    Private Sub UpdateClauseOperator(ByVal phraseCnt As Integer, ByVal clauseCnt As Integer)

        'Get a reference to the operator cell
        Dim cell As DataGridViewCell = ClausesDataGrid.Rows(clauseCnt).Cells(OperatorColumn.Index)

        'Update the operator information in the criteria object
        mCriteriaStmt.Phrases(phraseCnt).Clauses(clauseCnt).Operator = mOperators(cell.Value.ToString)

        'Check the operator cell validation
        IsOperatorColumnValid(phraseCnt, cell)

    End Sub


    Private Sub UpdateClauseParameter(ByVal phraseCnt As Integer, ByVal clauseCnt As Integer)

        'Get a reference to the parameter cell
        Dim cell As DataGridViewCell = ClausesDataGrid.Rows(clauseCnt).Cells(ParameterColumn.Index)

        'Get a reference to the criteria clause object
        Dim clause As CriteriaClause = mCriteriaStmt.Phrases(phraseCnt).Clauses(clauseCnt)

        'If the operator is not set on the criteria clause object then we are out of here
        If clause.OperatorName = String.Empty Then Exit Sub

        'Clear any existing parameter values
        clause.LowValue = ""
        clause.HighValue = ""
        If clause.ValueList IsNot Nothing Then clause.ValueList.Clear()

        'Populate the parameter data
        Dim parameter As String = cell.FormattedValue.ToString
        Dim parameters() As String
        Select Case clause.Operator
            Case CriteriaClause.Operators.In, CriteriaClause.Operators.NotIn
                'This is an InList so split it up
                parameters = parameter.Split(","c)

                'Add all of the parameters to the criteria clause object
                For Each inValue As String In parameters
                    clause.ValueList.Add(New CriteriaInValue(inValue.Trim))
                Next

            Case CriteriaClause.Operators.Between
                'This is a Between statement so split it up
                parameters = parameter.Split(","c)

                'Set the criteria clause object's LowValue
                clause.LowValue = parameters(0).Trim

                'Set the criteria clause object's HighValue if it is available
                Try
                    clause.HighValue = parameters(1).Trim
                Catch
                    clause.HighValue = ""
                End Try

            Case CriteriaClause.Operators.Is, CriteriaClause.Operators.IsNot
                'This is an IS or IS NOT so the parameter must be NULL
                clause.LowValue = parameter.Trim

            Case Else
                'All remaining operators require only a single parameter
                clause.LowValue = parameter.Trim

        End Select

        'Check the parameter cell validation
        IsParameterColumnValid(phraseCnt, cell)

    End Sub

#End Region

#Region "Validation Methods"

    Private Function IsRuleNameValid() As Boolean

        'Clear any current errors
        ErrorControl.Clear()

        'Validate the rule name
        If mShowRuleName AndAlso RuleNameTextbox.Text.Trim.Length = 0 Then
            'An error was encountered so we are out of here
            With ErrorControl
                .SetIconPadding(RuleNameTextbox, -18)
                .SetError(RuleNameTextbox, "You must enter a Rule Name!")
            End With
            Return False
        End If

        'If we made it to here then all is well
        Return True

    End Function


    Private Function ArePhrasesValid() As Boolean

        'Check all of the phrases
        For currentPhrase As Integer = 0 To PhrasesListView.Items.Count - 1
            If Not IsPhraseValid(currentPhrase) Then
                'If this phrase is not valid then we are out of here
                Return False
            End If
        Next

        'If we made it to here then all is well
        Return True

    End Function


    Private Function IsPhraseValid(ByVal phraseCnt As Integer) As Boolean

        'If the ImageKey is "Error" then this phrase has an error
        Return (PhrasesListView.Items(phraseCnt).ImageKey <> "Error")

    End Function


    Private Function IsClauseValid(ByVal phraseCnt As Integer, ByVal clauseCnt As Integer) As Boolean

        'Get a reference to the row for the specified clause
        Dim currentRow As DataGridViewRow = ClausesDataGrid.Rows(clauseCnt)

        'Get a reference to each of the cells in the specified row
        Dim fieldCell As DataGridViewCell = currentRow.Cells(FieldColumn.Index)
        Dim operatorCell As DataGridViewCell = currentRow.Cells(OperatorColumn.Index)
        Dim parameterCell As DataGridViewCell = currentRow.Cells(ParameterColumn.Index)

        'Validate all of the cells
        Return (IsFieldColumnValid(phraseCnt, fieldCell) And IsOperatorColumnValid(phraseCnt, operatorCell) And IsParameterColumnValid(phraseCnt, parameterCell))

    End Function


    Private Function IsFieldColumnValid(ByVal phraseCnt As Integer, ByRef cell As DataGridViewCell) As Boolean

        'Validate the cell
        If cell.Value Is Nothing OrElse cell.Value.ToString.Length = 0 Then
            'An error was encountered so set it and head out of dodge
            SetError(phraseCnt, cell, "You must select a Field!")
            Return False
        End If

        'If we made it here then all is well
        SetError(phraseCnt, cell, "")
        Return True

    End Function


    Private Function IsOperatorColumnValid(ByVal phraseCnt As Integer, ByRef cell As DataGridViewCell) As Boolean

        'Validate the cell
        If cell.Value Is Nothing OrElse cell.Value.ToString.Length = 0 Then
            'An error was encountered so set it and head out of dodge
            SetError(phraseCnt, cell, "You must select an Operator!")
            Return False
        End If

        'If we made it here then all is well
        SetError(phraseCnt, cell, "")
        Return True

    End Function


    Private Function IsParameterColumnValid(ByVal phraseCnt As Integer, ByRef cell As DataGridViewCell) As Boolean

        Dim parameters() As String

        'Get a reference to the field cell
        Dim fieldCell As DataGridViewCell = ClausesDataGrid.Rows(cell.RowIndex).Cells(FieldColumn.Index)

        'Get a reference to the operator cell
        Dim operatorCell As DataGridViewCell = ClausesDataGrid.Rows(cell.RowIndex).Cells(OperatorColumn.Index)

        'If the Field or Operator are not populated then we are out of here
        If Not IsFieldColumnValid(phraseCnt, fieldCell) Or Not IsOperatorColumnValid(phraseCnt, operatorCell) Then
            SetError(phraseCnt, cell, "You must select a Field and Operator first!")
            Return False
        End If

        'Get a reference to the Field object
        Dim clauseColumn As StudyTableColumn = mStudyColumns(fieldCell.Value.ToString)

        'Get a reference to the Operator object
        Dim clauseOperator As CriteriaClause.Operators = mOperators(operatorCell.Value.ToString)

        'Get the parameter text
        Dim parameter As String = ""
        If cell.Value IsNot Nothing Then parameter = cell.Value.ToString

        'Validate the parameter based on the operator type
        Select Case clauseOperator
            Case CriteriaClause.Operators.[In], CriteriaClause.Operators.NotIn
                'This is an InList so split it up
                parameters = parameter.Split(","c)

                'Validate all of the parameters in the list
                For cnt As Integer = parameters.GetLowerBound(0) To parameters.GetUpperBound(0)
                    If Not IsParameterValueValid(phraseCnt, cell, parameters(cnt), clauseColumn.DataType) Then
                        'An error was encountered so we are out of here
                        Return False
                    End If
                Next

            Case CriteriaClause.Operators.Between
                'This is a Between statement so split it up
                parameters = parameter.Split(","c)

                'Validate the parameters
                If parameters.GetUpperBound(0) <> 1 Then
                    'There must be exactly 2 parameters provided so we are out of here
                    SetError(phraseCnt, cell, "You must enter 2 parameters seperated by a comma!")
                    Return False
                Else
                    'Validate both parameters
                    For cnt As Integer = parameters.GetLowerBound(0) To parameters.GetUpperBound(0)
                        If Not IsParameterValueValid(phraseCnt, cell, parameters(cnt), clauseColumn.DataType) Then
                            'An error was encountered so we are out of here
                            Return False
                        End If
                    Next
                End If

            Case CriteriaClause.Operators.Is, CriteriaClause.Operators.IsNot
                'This is an IS or IS NOT so the parameter must be NULL
                If parameter.ToUpper.Trim <> "NULL" Then
                    'We are out of here
                    SetError(phraseCnt, cell, "The parameter must be set to NULL!")
                    Return False
                End If

            Case Else
                'This requires only a single parameter
                If Not IsParameterValueValid(phraseCnt, cell, parameter, clauseColumn.DataType) Then
                    'The parameter is invalid so we are out of here
                    Return False
                End If

        End Select

        'If we made it to here then all is well
        SetError(phraseCnt, cell, "")
        Return True

    End Function


    Private Function IsParameterValueValid(ByVal phraseCnt As Integer, ByRef cell As DataGridViewCell, ByVal value As String, ByVal dataType As StudyTableColumnDataTypes) As Boolean

        'Validate based on the datatype
        Select Case dataType
            Case StudyTableColumnDataTypes.DateTime
                If value.Trim.IndexOf(","c) > -1 Then
                    SetError(phraseCnt, cell, "You cannot have a comma(,) in the parameter!")
                    Return False
                ElseIf Not IsDate(value.Trim) Then
                    SetError(phraseCnt, cell, String.Format("Invalid Date format in parameter ({0})!", value.Trim))
                    Return False
                End If

            Case StudyTableColumnDataTypes.Integer
                If value.Trim.IndexOf(","c) > -1 Then
                    SetError(phraseCnt, cell, "You cannot have a comma(,) in the parameter!")
                    Return False
                ElseIf Not IsNumeric(value.Trim) Then
                    SetError(phraseCnt, cell, String.Format("Invalid Numeric format in parameter ({0})!", value.Trim))
                    Return False
                End If

            Case StudyTableColumnDataTypes.String
                If value.Trim.IndexOf(","c) > -1 Then
                    SetError(phraseCnt, cell, "You cannot have a comma(,) in the parameter!")
                    Return False
                ElseIf value.Trim.Length = 0 Then
                    SetError(phraseCnt, cell, "Empty string values not allowed in parameter!")
                    Return False
                End If

        End Select

        'If we made it here then all is well
        SetError(phraseCnt, cell, "")
        Return True

    End Function

#End Region

#Region "General Helper Methods"

    Private Sub InitializeLists()

        'Clear the field lists
        FieldColumn.Items.Clear()
        mStudyColumns.Clear()

        'Clear the operator lists
        OperatorColumn.Items.Clear()
        mOperators.Clear()

        If mCriteriaStmt IsNot Nothing Then
            'Get all of the study tables
            Dim studyTables As Collection(Of StudyTable) = StudyTable.GetAllStudyTables(mCriteriaStmt.StudyId)

            'Populate the columns
            For Each stdyTable As StudyTable In studyTables
                If Not stdyTable.IsView Then
                    For Each stdyColumn As StudyTableColumn In stdyTable.Columns
                        AddStudyColumn(stdyTable.Name, stdyColumn.Name, stdyColumn)
                    Next
                End If
            Next

            'Populate the operators
            AddOperator("=", CriteriaClause.Operators.Equals)
            AddOperator("<>", CriteriaClause.Operators.NotEqual)
            AddOperator(">", CriteriaClause.Operators.GreaterThan)
            AddOperator(">=", CriteriaClause.Operators.GreaterThanOrEqual)
            AddOperator("<", CriteriaClause.Operators.LessThan)
            AddOperator("<=", CriteriaClause.Operators.LessThanOrEqual)
            AddOperator("IN", CriteriaClause.Operators.[In])
            AddOperator("NOT IN", CriteriaClause.Operators.NotIn)
            AddOperator("BETWEEN", CriteriaClause.Operators.Between)
            AddOperator("IS", CriteriaClause.Operators.[Is])
            AddOperator("IS NOT", CriteriaClause.Operators.[IsNot])
        End If

    End Sub


    Private Sub AddOperator(ByVal key As String, ByVal clauseOperator As CriteriaClause.Operators)

        'Add this operator to the combobox column
        OperatorColumn.Items.Add(key)

        'Add this operator to the dictionary
        mOperators.Add(key, clauseOperator)

    End Sub


    Private Sub AddStudyColumn(ByVal tableName As String, ByVal columnName As String, ByVal column As StudyTableColumn)

        'Format the column name
        Dim key As String = String.Format("{0}.{1}", tableName, columnName)

        'Add this column to the combobox column
        FieldColumn.Items.Add(key)

        'Add this column to the dictionary
        mStudyColumns.Add(key, column)

    End Sub


    Private Function CriteriaString() As String

        If mCriteriaStmt IsNot Nothing Then
            'The criteria object is valid so get the criteria string
            Return mCriteriaStmt.CriteriaStatementDisplay(True, True)
        Else
            'The criteria object is nothing so return and empty string
            Return String.Empty
        End If

    End Function


    Private Function GetPhraseName(ByVal phraseCnt As Integer) As String

        If phraseCnt = 0 Then
            'This is the first phrase so we will use WHERE
            Return "Where"
        Else
            'All other phrases are named OR(n)
            Return String.Format("OR({0})", phraseCnt.ToString)
        End If

    End Function


    Private Sub SetError(ByVal phraseCnt As Integer, ByRef cell As DataGridViewCell, ByVal cellError As String)

        Dim phraseError As String = String.Empty
        Dim phraseImage As String = String.Empty
        Dim clauseError As New System.Text.StringBuilder(String.Empty)

        'Set this cell's error
        cell.ErrorText = cellError

        'Set the row's error
        For Each currentCell As DataGridViewCell In cell.OwningRow.Cells
            If currentCell.ErrorText IsNot Nothing AndAlso currentCell.ErrorText.Length > 0 Then
                'Add puctuation if there is already something in the string
                If clauseError.Length > 0 Then clauseError.Append(", ")

                'Add this cell's error
                clauseError.AppendFormat("{0}: {1}", currentCell.OwningColumn.Name, currentCell.ErrorText)
            End If
        Next
        cell.OwningRow.ErrorText = clauseError.ToString

        'Check for a Phrase error
        For Each currentRow As DataGridViewRow In cell.DataGridView.Rows
            If currentRow.ErrorText IsNot Nothing AndAlso currentRow.ErrorText.Length > 0 Then
                'One of the rows has an error so set the Phrase error
                phraseError = "One or more Clauses contain errors!"
                phraseImage = "Error"
                Exit For
            End If
        Next

        'Set the phrase error
        With PhrasesListView.Items(phraseCnt)
            .ImageKey = phraseImage
            .ToolTipText = phraseError
        End With

    End Sub

#End Region

#End Region
End Class
