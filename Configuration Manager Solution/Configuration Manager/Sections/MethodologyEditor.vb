Imports Nrc.Qualisys.Library
Imports Nrc.Framework.BusinessLogic.Configuration
Public Class MethodologyEditor

#Region " Private Fields "

    Private mEndConfigCallback As EndConfigCallBackMethod
    Private mSurvey As Survey

    Private mMethStepTypeCollection As Collection(Of MethodologyStepType)
    Private mCoverLetterCollection As Collection(Of CoverLetter)
    Private mNoCoverLetterCollection As Collection(Of CoverLetter)

    Private mIsDeleting As Boolean

#End Region

#Region " Constructors "

    Public Sub New(ByVal endConfigCallback As EndConfigCallBackMethod, ByVal srvy As Survey)

        Me.New(endConfigCallback, srvy, "", False)

    End Sub

    Public Sub New(ByVal endConfigCallback As EndConfigCallBackMethod, ByVal srvy As Survey, ByVal warningMessage As String, ByVal isReadOnly As Boolean)

        'This call is required by the Windows Form Designer.
        InitializeComponent()

        'Add any initialization after the InitializeComponent() call.
        mEndConfigCallback = endConfigCallback
        mSurvey = srvy

        If String.IsNullOrEmpty(warningMessage) Then
            InformationBar.Visible = False
            OKButton.Enabled = True
        Else
            InformationBar.Visible = True
            InformationBar.Information = warningMessage
            OKButton.Enabled = False
        End If

        SplitContainer.Panel1.Enabled = (Not isReadOnly)
        SplitContainer.Panel2.Enabled = (Not isReadOnly)
        SplitContainer.Enabled = (Not isReadOnly)

    End Sub

#End Region

#Region " Private Methods "

#Region " Private Methods - Helper "

    Private Sub Initialize()

        Try
            'Initialize the screen state
            SplitContainer.Panel1.Enabled = True
            SplitContainer.Panel2.Enabled = False

            'Get the collection of methodologies to be worked with
            Dim methCollection As Collection(Of Methodology)
            methCollection = Methodology.GetBySurveyId(mSurvey.Id)

            'Build the methodology types combo box collection
            Dim methTypeCollection As Collection(Of StandardMethodology) = StandardMethodology.GetBySurveyType(mSurvey.SurveyType, mSurvey.SurveySubTypes)
            With MethTypeColumn
                .DataSource = methTypeCollection
                .DisplayMember = "Name"
                .ValueMember = "ID"
            End With

            'Build the methodology step type collection
            mMethStepTypeCollection = MethodologyStepType.GetAll()
            With MethStepTypeComboBoxColumn
                .DataSource = mMethStepTypeCollection
                .DisplayMember = "Name"
                .ValueMember = "Name"
            End With

            'Build the cover letter collections
            mCoverLetterCollection = mSurvey.GetCoverLetters()
            mNoCoverLetterCollection = New Collection(Of CoverLetter)
            mNoCoverLetterCollection.Add(New CoverLetter(0, "N/A"))

            'Build the languages combo box collection
            Dim surveyLangCollection As Collection(Of Language) = mSurvey.GetSurveyLanguages()
            Dim lang As Language = New Language()
            lang.Name = "Use Lang ID"
            surveyLangCollection.Insert(0, lang)
            With MethStepLanguageColumn
                .DataSource = surveyLangCollection
                .DisplayMember = "Name"
                .ValueMember = "ID"
            End With

            'Build the previous step collection
            Dim prevStepCollection As New Collection(Of Nrc.Qualisys.Library.ListItem(Of Integer))
            prevStepCollection.Add(New Nrc.Qualisys.Library.ListItem(Of Integer)("Yes", -1))
            prevStepCollection.Add(New Nrc.Qualisys.Library.ListItem(Of Integer)("No", 0))
            With MethStepIncludeWithPrevColumn
                .DataSource = prevStepCollection
                .DisplayMember = "Label"
                .ValueMember = "Value"
            End With

            'Populate the screen with the available methodologies
            MethDataGrid.Rows.Clear()
            If methCollection.Count > 0 Then
                For Each meth As Methodology In methCollection
                    'See if this methodology exists in the list
                    Dim found As Boolean = False
                    For Each stdMeth As StandardMethodology In methTypeCollection
                        If stdMeth.Id = meth.StandardMethodologyId Then
                            found = True
                            Exit For
                        End If
                    Next

                    'Validate the methodology types
                    If Not found Then
                        'Notify the user that an invalid methodology type was encountered
                        Dim message As String = String.Format("The Methodology Type for Methodology '{0}' is '{1}'.{2}This Methodology Type is not valid for the current Survey Type!{2}{2}The Methodology Type will be changed to 'Custom'.  All Methodology{2}Steps will remain setup as they were originally.", meth.Name, meth.StandardMethodology.Name, vbCrLf)
                        MessageBox.Show(message, "Invalid Methodology Type Encountered", MessageBoxButtons.OK, MessageBoxIcon.Warning)

                        'Set the methodology type to 'Custom'
                        meth.ResetMethodologyTypeToCustom(mSurvey.SurveyType, mSurvey.SurveySubTypes)
                    End If

                    'Add this methodology to the screen
                    AddMethRow(meth, meth.IsActive)
                Next
            Else
                SetupMethToolbar(Nothing)
            End If

        Catch ex As Exception
            Globals.ReportException(ex)

        End Try

    End Sub


    Private Sub SetError(ByRef cell As DataGridViewCell, ByVal cellError As String)

        Dim rowError As New System.Text.StringBuilder(String.Empty)
        Dim columnName As String = String.Empty

        'Set this cell's error
        cell.ErrorText = cellError

        'Set the row's error
        For Each currentCell As DataGridViewCell In cell.OwningRow.Cells
            If currentCell.ErrorText IsNot Nothing AndAlso currentCell.ErrorText.Length > 0 Then
                'Add puctuation if there is already something in the string
                If rowError.Length > 0 Then rowError.Append(", ")

                'Get the column name
                Select Case currentCell.OwningColumn.Name
                    Case "MethCreatedColumn"
                        columnName = "Steps"

                    Case Else
                        columnName = currentCell.OwningColumn.HeaderText

                End Select

                'Add this cell's error
                rowError.AppendFormat("{0}: {1}", columnName, currentCell.ErrorText)
            End If
        Next
        cell.OwningRow.ErrorText = rowError.ToString

    End Sub


    Private Sub UndoChanges(ByVal undoStepsOnly As Boolean)

        'Get a reference to the current methodology
        Dim methRow As DataGridViewRow = MethDataGrid.SelectedRows(0)
        Dim meth As Methodology = DirectCast(methRow.Tag, Methodology)

        'If we are undoing everything then undo the methodology
        If undoStepsOnly Then
            'Refresh the methodology steps for this methodology
            meth.RefreshSteps()

            'All is good so setup the screen
            With SplitContainer
                .Panel1.Enabled = True
                .Panel2.Enabled = False
                OKButton.Enabled = True
            End With

            'Repopulate the methodology steps grid
            PopulateMethSteps(meth)

            'Validate the steps
            AreMethStepRowsValid(methRow)
        Else
            'Refresh the entire methodology
            meth.Refresh()

            'Update the row in the data grid
            With methRow
                .Cells(MethActiveColumn.Index).Value = GetMethActiveBitmap(meth.IsActive)
                .Cells(MethNameColumn.Index).Value = meth.Name
                .Cells(MethTypeColumn.Index).Value = meth.StandardMethodologyId
                .Cells(MethCreatedColumn.Index).Value = meth.DateCreated.ToString
            End With

            'Repopulate the methodology steps grid
            PopulateMethSteps(meth)

            'Validate the row
            IsMethRowValid(methRow)

            'Reset the methodology toolbar
            SetupMethToolbar(meth)
        End If

    End Sub


    Private Function GetMethActiveBitmap(ByVal isActive As Boolean) As Bitmap

        If isActive Then
            Return New Bitmap(My.Resources.Validation16, 16, 16)
        Else
            Return New Bitmap(My.Resources.cross, 16, 16)
        End If

    End Function

#End Region

#Region " Private Methods - Methodology "

    Private Sub NewMethodology()

        'Get a name for the new methodology
        Dim methName As String = String.Empty



        'Get the default standard methodology for the new methodology
        Dim stdMeth As StandardMethodology = StandardMethodology.GetBySurveyType(mSurvey.SurveyType, mSurvey.SurveySubTypes).Item(0)

        'Create the new methodology
        Dim meth As Methodology = Methodology.CreateFromStandard(mSurvey.Id, methName, stdMeth)

        'Add the new methodology to the grid
        Dim newRow As Integer = AddMethRow(meth, True)

        'Select the name column
        With MethDataGrid
            .Rows(newRow).Cells(MethNameColumn.Index).Selected = True
            .BeginEdit(True)
        End With

    End Sub


    Private Sub DeleteMethodology()

        'Get the current methodology
        Dim meth As Methodology = DirectCast(MethDataGrid.SelectedRows(0).Tag, Methodology)

        'Prompt the user
        If MessageBox.Show(String.Format("You have chosen to delete the selected methodology!{0}{0}Methodology Name: {1}{0}{0}Do you wish to proceed?", vbCrLf, meth.Name), "Delete Methodology", _
                           MessageBoxButtons.YesNo, MessageBoxIcon.Warning, MessageBoxDefaultButton.Button2) = DialogResult.No Then Exit Sub

        'Remove the methodology from the data grid
        mIsDeleting = True
        Dim rowCnt As Integer = MethDataGrid.SelectedRows(0).Index
        MethDataGrid.Rows.Remove(MethDataGrid.SelectedRows(0))
        mIsDeleting = False

        'Delete this methodology
        If Not meth.IsNew Then Methodology.Delete(meth.Id)

        'Select the next methodology
        If rowCnt > MethDataGrid.Rows.Count - 1 Then rowCnt = MethDataGrid.Rows.Count - 1
        SelectMethRow(rowCnt)

    End Sub


    Private Sub EditMethodology()

        'Setup the screen
        With SplitContainer
            .Panel1.Enabled = False
            .Panel2.Enabled = True
            OKButton.Enabled = False
        End With

    End Sub


    Private Sub ActivateMethodology()

        Try
            'Get the selected methodology
            Dim meth As Methodology
            Dim currentRowIndex As Integer = MethDataGrid.SelectedRows(0).Index

            'Set active property for everything in the grid
            For Each row As DataGridViewRow In MethDataGrid.Rows
                meth = DirectCast(row.Tag, Methodology)
                meth.IsActive = (row.Index = currentRowIndex)
                row.Cells(MethActiveColumn.Index).Value = GetMethActiveBitmap(meth.IsActive)
            Next

            'Disable the button
            SetupMethToolbar(DirectCast(MethDataGrid.Rows(currentRowIndex).Tag, Methodology))

        Catch ex As Exception
            Globals.ReportException(ex)

        End Try

    End Sub


    Private Function AddMethRow(ByVal meth As Methodology, ByVal selectMethodology As Boolean) As Integer

        Dim newRow As Integer = -1

        Try
            'Add the row to the data grid
            newRow = MethDataGrid.Rows.Add(GetMethActiveBitmap(meth.IsActive), meth.Name, meth.StandardMethodologyId, meth.DateCreated.ToString)
            MethDataGrid.Rows(newRow).Tag = meth

            'Setup the row
            SetupMethRow(MethDataGrid.Rows(newRow), (Not meth.AllowEdit))

            'Select the methodology in the list if requested
            If selectMethodology Then SelectMethRow(newRow)

            'Validate the row
            IsMethRowValid(MethDataGrid.Rows(newRow))

            'Return the index of the new row
            Return newRow

        Catch ex As Exception
            Globals.ReportException(ex)
            If newRow > -1 Then
                MethDataGrid.Rows.RemoveAt(newRow)
            End If
            Return -1

        End Try

    End Function


    Private Sub SelectMethRow(ByVal rowCnt As Integer)

        Dim meth As Methodology

        If rowCnt < 0 Then
            meth = Nothing
        Else
            'Get a reference to the methodology
            meth = DirectCast(MethDataGrid.Rows(rowCnt).Tag, Methodology)

            'Select the row in the data grid
            MethDataGrid.Rows(rowCnt).Selected = True
            MethDataGrid.CurrentCell = MethDataGrid.Rows(rowCnt).Cells(MethNameColumn.Index)
        End If

        'Populate the methodology steps for the selected methodology
        PopulateMethSteps(meth)

        'Setup the methodology toolbar
        SetupMethToolbar(meth)

    End Sub


    Private Sub SetupMethRow(ByVal row As DataGridViewRow, ByVal isReadOnly As Boolean)

        With row
            .ReadOnly = isReadOnly
            If isReadOnly Then
                '.DefaultCellStyle.BackColor = SystemColors.ButtonFace
                .DefaultCellStyle.ForeColor = SystemColors.GrayText
            Else
                '.DefaultCellStyle.BackColor = SystemColors.Window
                .DefaultCellStyle.ForeColor = SystemColors.WindowText
            End If
        End With

    End Sub


    Private Sub SetupMethToolbar(ByVal meth As Methodology)

        If meth Is Nothing Then
            MethActivateTSButton.Enabled = False
            MethDeleteTSButton.Enabled = False
            MethEditTSButton.Enabled = False
            MethUndoTSButton.Enabled = False
        Else
            MethActivateTSButton.Enabled = (Not meth.IsActive)
            MethDeleteTSButton.Enabled = (meth.AllowEdit And meth.AllowDelete)
            MethEditTSButton.Enabled = meth.AllowEdit
            MethUndoTSButton.Enabled = (meth.AllowEdit And meth.IsDirty And Not meth.IsNew)
        End If

    End Sub

#End Region

#Region " Private Methods - Methodology Validation "

    Private Function AreMethRowsValid() As Boolean

        Dim foundInvalid As Boolean = False
        Dim activeCount As Integer

        'Validate all rows
        For Each row As DataGridViewRow In MethDataGrid.Rows
            'Check to see if there are any errors on this row
            If row.ErrorText.Trim.Length > 0 Then
                foundInvalid = True
            End If

            'Check to see if this row is valid
            If DirectCast(row.Tag, Methodology).IsActive Then
                activeCount += 1
            End If
        Next

        If foundInvalid Then
            MessageBox.Show(String.Format("One or more errors exist!{0}{0}Please correct the errors and try again.", vbCrLf), "Methodology Validation Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            Return False
        ElseIf activeCount < 1 Then
            MessageBox.Show(String.Format("There must be an active methodology!{0}{0}Please correct this and try again.", vbCrLf), "Methodology Validation Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            Return False
        ElseIf activeCount > 1 Then
            MessageBox.Show(String.Format("There can be only one active methodology!{0}{0}Please correct this and try again.", vbCrLf), "Methodology Validation Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            Return False
        Else
            Return True
        End If

    End Function


    Private Function IsMethRowValid(ByVal row As DataGridViewRow) As Boolean

        'Get a reference to the cells to be validated
        Dim methNameCell As DataGridViewCell = row.Cells(MethNameColumn.Index)
        Dim methTypeCell As DataGridViewCell = row.Cells(MethTypeColumn.Index)

        'Validate all of the cells
        Return (IsMethNameValid(methNameCell) And IsMethTypeValid(methTypeCell) And DoMethStepsExist(row))

    End Function


    Private Function IsMethNameValid(ByVal cell As DataGridViewCell) As Boolean

        'Do the validation
        If cell.Value Is Nothing OrElse cell.Value.ToString.Length = 0 Then
            'The Name must be filled in
            SetError(cell, "You must provide a Name!")
            Return False
        Else
            'Make sure name is unique
            For Each row As DataGridViewRow In cell.DataGridView.Rows
                If row.Index <> cell.OwningRow.Index AndAlso _
                   row.Cells(MethNameColumn.Index).Value.ToString.Trim.ToUpper = cell.Value.ToString.Trim.ToUpper Then
                    'We found another methodology with the same name
                    SetError(cell, "The Name must be unique!")
                    Return False
                End If
            Next
        End If

        'If we made it here then all is well
        SetError(cell, "")
        Return True

    End Function


    Private Function IsMethTypeValid(ByVal cell As DataGridViewCell) As Boolean

        'Do the validation
        If cell.Value Is Nothing OrElse cell.Value.ToString.Length = 0 Then
            'The Type must be selected
            SetError(cell, "You must select a Type!")
            Return False
        End If

        'If we made it here then all is well
        SetError(cell, "")
        Return True

    End Function


    Private Function DoMethStepsExist(ByVal row As DataGridViewRow) As Boolean

        'Get a reference to the Methodology object
        Dim meth As Methodology = DirectCast(row.Tag, Methodology)

        'Get a reference to the cell used to report step errors
        Dim cell As DataGridViewCell = row.Cells(MethCreatedColumn.Index)

        'Check to make sure there is at least one step
        If meth.MethodologySteps.Count = 0 Then
            'You must have at least one step
            SetError(cell, "You must have at least one Step!")
            Return False
        End If

        'If we made it here then all is well
        SetError(cell, "")
        Return True

    End Function

#End Region

#Region " Private Methods - Methodology Step "

    Private Sub NewMethodologyStep()

        'Get a reference to the current methodology
        Dim meth As Methodology = DirectCast(MethDataGrid.SelectedRows(0).Tag, Methodology)

        'Add the new methodology step
        Dim methStep As MethodologyStep = meth.AddNewMethodologyStep(mMethStepTypeCollection(0))

        'Set the defaults
        With methStep
            '.ExpirationDays = 84
            .ExpireFromStep = methStep
            .LinkedStep = methStep
        End With

        'Add the new methodology step to the data grid
        Dim newRow As Integer = AddMethStepRow(meth, methStep, True)

        'Select the name column
        With MethStepDataGrid
            .Rows(newRow).Cells(MethStepTypeComboBoxColumn.Index).Selected = True
            .BeginEdit(True)
        End With

    End Sub


    Private Sub DeleteMethodologyStep()

        'Get the current methodology step
        Dim row As DataGridViewRow = MethStepDataGrid.SelectedRows(0)
        Dim methStep As MethodologyStep = DirectCast(row.Tag, MethodologyStep)

        'Prompt the user
        If MessageBox.Show(String.Format("You have chosen to delete the selected methodology step!{0}{0}Methodology Step Type: {1}{0}{0}Do you wish to proceed?", vbCrLf, methStep.Name), "Delete Methodology Step", _
                           MessageBoxButtons.YesNo, MessageBoxIcon.Warning, MessageBoxDefaultButton.Button2) = DialogResult.No Then Exit Sub

        'Remove the methodology step from the data grid
        mIsDeleting = True
        Dim rowCnt As Integer = row.Index
        MethStepDataGrid.Rows.Remove(row)
        mIsDeleting = False

        'Delete this methodology step
        methStep.ParentCollection.Remove(methStep)

        'Select the next methodology step
        If rowCnt > MethStepDataGrid.Rows.Count - 1 Then rowCnt = MethStepDataGrid.Rows.Count - 1
        SelectMethStepRow(rowCnt)
        AreMethStepRowsValid(MethDataGrid.SelectedRows(0))

    End Sub


    Private Sub MoveMethodologyStepUp()

        'Get a reference to the methodology and methodology step
        Dim meth As Methodology = DirectCast(MethDataGrid.SelectedRows(0).Tag, Methodology)
        Dim methStep As MethodologyStep = DirectCast(MethStepDataGrid.SelectedRows(0).Tag, MethodologyStep)

        'Check to see if we can move this step up
        If methStep.CanDecreaseSequence Then
            'We can move it so do the deed
            methStep.DecreaseSequence()

            'Check the expire from step
            If methStep.SequenceNumber < methStep.ExpireFromStep.SequenceNumber Then
                'We have moved this step above the step it was previously set to expire from
                '  so reset it to expire from itself
                methStep.ExpireFromStep = methStep
            End If

            'Repopulate the steps grid
            PopulateMethSteps(meth)

            'Select the step that was being moved and make the step type the active cell
            SelectMethStepRow(methStep.SequenceNumber - 1)
            'With MethStepDataGrid
            '    .Rows(methStep.SequenceNumber - 1).Cells(MethStepTypeComboBoxColumn.Index).Selected = True
            '    .BeginEdit(True)
            'End With
        Else
            'This step cannot be moved
            MessageBox.Show("The selected step cannot be moved up!", "Methodology Step Move Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End If

    End Sub


    Private Sub MoveMethodologyStepDown()

        'Get a reference to the methodology and methodology step
        Dim meth As Methodology = DirectCast(MethDataGrid.SelectedRows(0).Tag, Methodology)
        Dim methStep As MethodologyStep = DirectCast(MethStepDataGrid.SelectedRows(0).Tag, MethodologyStep)

        'Check to see if we can move this step up
        If methStep.CanIncreaseSequence Then
            'We can move it so do the deed
            methStep.IncreaseSequence()

            'Check the expire from step of the step that is now above this one
            Dim tempStep As MethodologyStep = methStep.ParentCollection(methStep.SequenceNumber - 2)
            If tempStep.SequenceNumber < tempStep.ExpireFromStep.SequenceNumber Then
                'We have moved this step above the step it was previously set to expire from
                '  so reset it to expire from itself
                tempStep.ExpireFromStep = tempStep
            End If

            'Repopulate the steps grid
            PopulateMethSteps(meth)

            'Select the step that was being moved and make the step type the active cell
            SelectMethStepRow(methStep.SequenceNumber - 1)
            'With MethStepDataGrid
            '    .Rows(methStep.SequenceNumber - 1).Cells(MethStepTypeComboBoxColumn.Index).Selected = True
            '    .BeginEdit(True)
            'End With
        Else
            'This step cannot be moved
            MessageBox.Show("The selected step cannot be moved down!", "Methodology Step Move Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End If

    End Sub


    Private Sub ApplyMethodologyStepChanges()

        'Validate all steps as a unit
        Dim methRow As DataGridViewRow = MethDataGrid.SelectedRows(0)
        If Not AreMethStepRowsValid(methRow) Then
            MessageBox.Show(String.Format("One or more errors exist!{0}{0}Please correct the errors and try again.", vbCrLf), "Methodology Step Validation Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            Exit Sub
        End If

        'All is good so setup the screen
        With SplitContainer
            .Panel1.Enabled = True
            .Panel2.Enabled = False
            OKButton.Enabled = True
        End With

        'Reset the methodology toolbar
        SetupMethToolbar(DirectCast(methRow.Tag, Methodology))

    End Sub


    Private Sub PopulateMethSteps(ByVal meth As Methodology)

        'Setup the methodology steps grid for this methodology
        MethStepDataGrid.Rows.Clear()

        'Reset the methodology steps toolbar
        SetupMethStepToolbar(Nothing)

        'If the methodology is not set then we are out of here
        If meth Is Nothing Then Exit Sub

        'Show the appropriate columns
        If meth.AllowEdit Then
            'If the Methodology is editable then we will show the combo box for the Step Type
            MethStepTypeTextBoxColumn.Visible = False
            MethStepTypeComboBoxColumn.Visible = True

            'The cover letter column will always be editable
            SetupMethStepColumn(MethStepCoverLetterColumn, False)

            'Determine if we are customizable
            SetupMethStepColumn(MethStepTypeTextBoxColumn, (Not meth.IsCustomizable))
            SetupMethStepColumn(MethStepTypeComboBoxColumn, (Not meth.IsCustomizable))
            SetupMethStepColumn(MethStepDaysSincePrevColumn, (Not meth.IsCustomizable))
            SetupMethStepColumn(MethStepLanguageColumn, (Not meth.IsCustomizable))
            SetupMethStepColumn(MethStepIncludeWithPrevColumn, (Not meth.IsCustomizable))
            SetupMethStepColumn(MethStepExpirationDaysColumn, (Not meth.IsCustomizable))
            SetupMethStepColumn(MethStepExpireFromStepColumn, (Not meth.IsCustomizable))
        Else
            'The methodology is not editable so show the textbox for the Step Type
            MethStepTypeTextBoxColumn.Visible = True
            MethStepTypeComboBoxColumn.Visible = False

            'Lock all columns
            SetupMethStepColumn(MethStepTypeTextBoxColumn, True)
            SetupMethStepColumn(MethStepTypeComboBoxColumn, True)
            SetupMethStepColumn(MethStepDaysSincePrevColumn, True)
            SetupMethStepColumn(MethStepCoverLetterColumn, True)
            SetupMethStepColumn(MethStepLanguageColumn, True)
            SetupMethStepColumn(MethStepIncludeWithPrevColumn, True)
            SetupMethStepColumn(MethStepExpirationDaysColumn, True)
            SetupMethStepColumn(MethStepExpireFromStepColumn, True)
        End If

        'Populate the methodology steps
        For Each methStep As MethodologyStep In meth.MethodologySteps
            AddMethStepRow(meth, methStep, (MethStepDataGrid.Rows.Count = 0))
        Next

    End Sub


    Private Sub SetupMethStepToolbar(ByVal methStep As MethodologyStep)

        Dim isCustomizable As Boolean

        'Get a reference to the methodology object
        If MethDataGrid.SelectedRows.Count = 0 Then
            isCustomizable = False
        Else
            isCustomizable = DirectCast(MethDataGrid.SelectedRows(0).Tag, Methodology).IsCustomizable
        End If

        If methStep Is Nothing Then
            MethStepNewTSButton.Enabled = isCustomizable
            MethStepDeleteTSButton.Enabled = False
            MethStepMoveUpTSButton.Enabled = False
            MethStepMoveDownTSButton.Enabled = False
            MethStepApplyTSButton.Enabled = True
            MethStepUndoTSButton.Enabled = False
        Else
            MethStepNewTSButton.Enabled = isCustomizable
            MethStepDeleteTSButton.Enabled = isCustomizable
            MethStepMoveUpTSButton.Enabled = (methStep.CanDecreaseSequence AndAlso isCustomizable)
            MethStepMoveDownTSButton.Enabled = (methStep.CanIncreaseSequence AndAlso isCustomizable)
            MethStepApplyTSButton.Enabled = True
            MethStepUndoTSButton.Enabled = True
        End If

    End Sub


    Private Sub SetupMethStepColumn(ByVal column As DataGridViewColumn, ByVal isReadOnly As Boolean)

        With column
            .ReadOnly = isReadOnly
            If isReadOnly Then
                '.DefaultCellStyle.BackColor = SystemColors.ButtonFace
                .DefaultCellStyle.ForeColor = SystemColors.GrayText
            Else
                '.DefaultCellStyle.BackColor = SystemColors.Window
                .DefaultCellStyle.ForeColor = SystemColors.WindowText
            End If
        End With

    End Sub


    Private Sub UpdateExpireFromStepLists(ByVal rowIndex As Integer)

        For rowCnt1 As Integer = rowIndex + 1 To MethStepDataGrid.Rows.Count - 1
            'Get the combobox cell
            Dim comboBoxCell As DataGridViewComboBoxCell = DirectCast(MethStepDataGrid.Rows(rowCnt1).Cells(MethStepExpireFromStepColumn.Index), DataGridViewComboBoxCell)

            'Get the currently selected step
            Dim selectedStep As MethodologyStep = DirectCast(comboBoxCell.Value, MethodologyStep)

            'Build the expire from step collection
            Dim expireFromCollection As New Collection(Of Nrc.Qualisys.Library.ListItem(Of MethodologyStep))

            'Add the current step
            expireFromCollection.Add(New Nrc.Qualisys.Library.ListItem(Of MethodologyStep)("This Step", DirectCast(MethStepDataGrid.Rows(rowCnt1).Tag, MethodologyStep)))

            'Add the steps for all of the rows above the current row
            For rowCnt2 As Integer = 0 To rowCnt1 - 1
                'Get the methodology step object for this row
                Dim tempStep As MethodologyStep = DirectCast(MethStepDataGrid.Rows(rowCnt2).Tag, MethodologyStep)

                'Add this step to the collection
                expireFromCollection.Add(New Nrc.Qualisys.Library.ListItem(Of MethodologyStep)(tempStep.Name, tempStep))
            Next

            'Reset the datasource
            comboBoxCell.DataSource = expireFromCollection
            comboBoxCell.DisplayMember = "Label"
            comboBoxCell.ValueMember = "Value"

            'Reselect the previously selected step
            comboBoxCell.Value = selectedStep

            'Validate
            IsMethStepExpireFromStepValid(comboBoxCell)
        Next

    End Sub


    Private Sub UpdateCoverLetterList(ByVal rowIndex As Integer, ByVal methStep As MethodologyStep)

        'Build the cover letters combo box collection
        Dim coverLetterCollection As Collection(Of CoverLetter)
        If IsCoverLetterRequired(methStep.Name) Then
            coverLetterCollection = mCoverLetterCollection
        Else
            coverLetterCollection = mNoCoverLetterCollection
        End If

        'Get the combobox cell
        Dim comboBoxCell As DataGridViewComboBoxCell = DirectCast(MethStepDataGrid.Rows(rowIndex).Cells(MethStepCoverLetterColumn.Index), DataGridViewComboBoxCell)

        'Determine if we are changing the list
        If DirectCast(comboBoxCell.DataSource, Collection(Of CoverLetter)) Is coverLetterCollection Then
            'We are not changing the list so we are out of here
            Exit Sub
        End If

        'Clear the current selection
        comboBoxCell.Value = Nothing

        'Populate the cover letter combo for this row
        comboBoxCell.DataSource = coverLetterCollection
        comboBoxCell.DisplayMember = "Name"
        comboBoxCell.ValueMember = "ID"

        'If this step type does not require a coverletter then select N/A
        If Not IsCoverLetterRequired(methStep.Name) Then
            comboBoxCell.Value = 0
            If methStep.CoverLetterId <> 0 Then methStep.CoverLetterId = 0
        End If

        'Validate
        IsMethStepCoverLetterValid(comboBoxCell)

    End Sub


    Private Function AddMethStepRow(ByVal meth As Methodology, ByVal methStep As MethodologyStep, ByVal selectMethodologyStep As Boolean) As Integer

        Dim newRow As Integer = -1

        Try
            'Build the expire from step collection
            Dim expireFromCollection As New Collection(Of Nrc.Qualisys.Library.ListItem(Of MethodologyStep))

            'Add the current step
            expireFromCollection.Add(New Nrc.Qualisys.Library.ListItem(Of MethodologyStep)("This Step", methStep))

            For rowCnt As Integer = 0 To MethStepDataGrid.Rows.Count - 1
                'Get the methodology step object for this row
                Dim tempStep As MethodologyStep = DirectCast(MethStepDataGrid.Rows(rowCnt).Tag, MethodologyStep)

                'Add this step to the collection
                expireFromCollection.Add(New Nrc.Qualisys.Library.ListItem(Of MethodologyStep)(tempStep.Name, tempStep))
            Next

            'Add the new row to the grid
            newRow = MethStepDataGrid.Rows.Add()

            With MethStepDataGrid.Rows(newRow)
                'Populate the cover letter combo for this row
                UpdateCoverLetterList(newRow, methStep)

                'Populate the expire from step combo for this row
                Dim comboBoxCell As DataGridViewComboBoxCell = DirectCast(.Cells(MethStepExpireFromStepColumn.Index), DataGridViewComboBoxCell)
                comboBoxCell.DataSource = expireFromCollection
                comboBoxCell.DisplayMember = "Label"
                comboBoxCell.ValueMember = "Value"

                'Setup the step type column
                If meth.AllowEdit Then
                    .Cells(MethStepTypeComboBoxColumn.Index).Value = methStep.Name
                Else
                    .Cells(MethStepTypeTextBoxColumn.Index).Value = methStep.Name
                End If

                'Setup the cover letter column
                If IsCoverLetterRequired(methStep.Name) Then
                    'A cover letter selection is required
                    If methStep.CoverLetterId > 0 Then
                        'This step has a valid selection so pick it
                        .Cells(MethStepCoverLetterColumn.Index).Value = methStep.CoverLetterId
                    End If
                End If

                'Setup the common columns
                .Cells(MethStepDaysSincePrevColumn.Index).Value = methStep.DaysSincePreviousStep
                .Cells(MethStepLanguageColumn.Index).Value = IIf(methStep.OverrideLanguageId.HasValue, methStep.OverrideLanguageId, 0)
                .Cells(MethStepIncludeWithPrevColumn.Index).Value = IIf(methStep Is methStep.LinkedStep, 0, -1)
                .Cells(MethStepExpirationDaysColumn.Index).Value = methStep.ExpirationDays
                .Cells(MethStepExpireFromStepColumn.Index).Value = methStep.ExpireFromStep

                'Save the MethodologyStep object
                .Tag = methStep

            End With

            'Select the step if required
            If selectMethodologyStep Then SelectMethStepRow(newRow)

            'Validate the row
            AreMethStepRowsValid(MethDataGrid.SelectedRows(0))

            'Return the index of the new row
            Return newRow

        Catch ex As Exception
            Globals.ReportException(ex)
            If newRow > -1 Then
                MethStepDataGrid.Rows.RemoveAt(newRow)
            End If
            Return -1

        End Try

    End Function


    Private Sub SelectMethStepRow(ByVal rowCnt As Integer)

        Dim methStep As MethodologyStep

        If rowCnt < 0 Then
            methStep = Nothing
        Else
            'Get a reference to the methodology step
            methStep = DirectCast(MethStepDataGrid.Rows(rowCnt).Tag, MethodologyStep)

            'Select the row in the data grid
            MethStepDataGrid.Rows(rowCnt).Selected = True
            MethStepDataGrid.CurrentCell = MethStepDataGrid.Rows(rowCnt).Cells(MethStepCoverLetterColumn.Index)

            DisplayMethStepProps(methStep)
        End If

        'Setup the methodology step toolbar
        SetupMethStepToolbar(methStep)

    End Sub


    Private Function IsCoverLetterRequired(ByVal methStepName As String) As Boolean

        Dim isRequired As Boolean = True

        For Each methStepType As MethodologyStepType In mMethStepTypeCollection
            If methStepType.Name.ToUpper = methStepName.ToUpper Then
                isRequired = methStepType.IsCoverLetterRequired
                Exit For
            End If
        Next

        Return isRequired

    End Function


    Private Function GetMethStepType(ByVal methStepName As String) As MethodologyStepType

        For Each methStepType As MethodologyStepType In mMethStepTypeCollection
            If methStepType.Name.ToUpper = methStepName.ToUpper Then
                Return methStepType
            End If
        Next

        'If we made it to here then return nothing
        Return Nothing

    End Function

#End Region

#Region " Private Methods - Methodology Step Validation "

    Private Function AreMethStepRowsValid(ByVal methRow As DataGridViewRow) As Boolean

        'Clear any step errors reported on the methodology row
        Dim methStepErrorCell As DataGridViewCell = methRow.Cells(MethCreatedColumn.Index)
        SetError(methStepErrorCell, "")

        'Check to make sure there is at least one step
        If MethStepDataGrid.Rows.Count = 0 Then
            'You must have at least one step
            SetError(methStepErrorCell, "You must have at least one Step!")
            Return False
        End If

        'Validate all steps
        Dim foundInvalid As Boolean = False
        For Each stepRow As DataGridViewRow In MethStepDataGrid.Rows
            If Not IsMethStepRowValid(stepRow) Then
                'This row is invalid
                foundInvalid = True
            End If
        Next

        'Validate the language and Include with Previous combinations
        For rowCnt As Integer = 1 To MethStepDataGrid.Rows.Count - 1
            'Get this row's Include with Previous value
            Dim includeWithPrev As Boolean = CType(MethStepDataGrid.Rows(rowCnt).Cells(MethStepIncludeWithPrevColumn.Index).Value, Boolean)

            'Get a reference to the previous row's Language cell
            Dim langCell As DataGridViewCell = MethStepDataGrid.Rows(rowCnt - 1).Cells(MethStepLanguageColumn.Index)

            'Validate
            If includeWithPrev AndAlso CType(langCell.Value, Integer) = 0 Then
                SetError(langCell, "Language cannot be 'Use Lang ID' if the next step is Include with Previous Step!")
                foundInvalid = True
            End If
        Next

        'If we found any invalid steps then we are out of here
        If foundInvalid Then
            SetError(methStepErrorCell, "One or more errors exist in the Steps!")
            Return False
        End If

        'We have passed all validation so let's update the linked steps
        For Each methStepRow As DataGridViewRow In MethStepDataGrid.Rows
            'Get a reference to the methodology step object
            Dim methStep As MethodologyStep = DirectCast(methStepRow.Tag, MethodologyStep)

            If CType(methStepRow.Cells(MethStepIncludeWithPrevColumn.Index).Value, Boolean) Then
                'We are linking with the previous step so set the LinkedStep equal to the previous step's LinkedStep
                Dim linkedStep As MethodologyStep = DirectCast(MethStepDataGrid.Rows(methStepRow.Index - 1).Tag, MethodologyStep).LinkedStep
                If Not (methStep.LinkedStep Is linkedStep) Then
                    methStep.LinkedStep = DirectCast(MethStepDataGrid.Rows(methStepRow.Index - 1).Tag, MethodologyStep).LinkedStep
                End If
            Else
                'We are not linking to the previous step so set the LinkedStep equal to this step
                If Not (methStep.LinkedStep Is methStep) Then
                    methStep.LinkedStep = methStep
                End If
            End If
        Next

        'If we made it here then all is well
        Return True

    End Function


    Private Function IsMethStepRowValid(ByVal row As DataGridViewRow) As Boolean

        'Get a reference to the cells to be validated
        Dim methStepTypeTextBoxCell As DataGridViewCell = row.Cells(MethStepTypeTextBoxColumn.Index)
        Dim methStepTypeComboBoxCell As DataGridViewCell = row.Cells(MethStepTypeComboBoxColumn.Index)
        Dim methStepDaysSincePrevCell As DataGridViewCell = row.Cells(MethStepDaysSincePrevColumn.Index)
        Dim methStepCoverLetterCell As DataGridViewCell = row.Cells(MethStepCoverLetterColumn.Index)
        Dim methStepLanguageCell As DataGridViewCell = row.Cells(MethStepLanguageColumn.Index)
        Dim methStepIncludeWithPrevCell As DataGridViewCell = row.Cells(MethStepIncludeWithPrevColumn.Index)
        Dim methStepExpirationDaysCell As DataGridViewCell = row.Cells(MethStepExpirationDaysColumn.Index)
        Dim methStepExpireFromStepCell As DataGridViewCell = row.Cells(MethStepExpireFromStepColumn.Index)

        'Validate all of the cells
        Return (IsMethStepTypeValid(methStepTypeTextBoxCell, methStepTypeComboBoxCell) And _
                IsMethStepDaysSincePrevValid(methStepDaysSincePrevCell) And _
                IsMethStepCoverLetterValid(methStepCoverLetterCell) And _
                IsMethStepLanguageValid(methStepLanguageCell) And _
                IsMethStepIncludeWithPrevValid(methStepIncludeWithPrevCell) And _
                IsMethStepExpirationDaysValid(methStepExpirationDaysCell) And _
                IsMethStepExpireFromStepValid(methStepExpireFromStepCell) And _
                IsMethStepPropertiesValid(row))

    End Function


    Private Function IsMethStepTypeValid(ByVal textBoxCell As DataGridViewCell, ByVal comboBoxCell As DataGridViewCell) As Boolean

        Dim cell As DataGridViewCell
        Dim columnIndex As Integer

        'Get a reference to the current methodology
        Dim meth As Methodology = DirectCast(MethDataGrid.SelectedRows(0).Tag, Methodology)

        'Determine which cell to validate
        If meth.AllowEdit Then
            cell = comboBoxCell
            columnIndex = MethStepTypeComboBoxColumn.Index
        Else
            cell = textBoxCell
            columnIndex = MethStepTypeTextBoxColumn.Index
        End If

        'Do the validation
        If cell.Value Is Nothing OrElse cell.Value.ToString.Length = 0 Then
            'The Step Type must be filled in
            SetError(cell, "You must select a Step Type!")
            Return False
        Else
            'Make sure step type is unique
            For Each row As DataGridViewRow In cell.DataGridView.Rows
                If row.Index <> cell.OwningRow.Index AndAlso _
                   row.Cells(columnIndex).Value.ToString.Trim.ToUpper = cell.Value.ToString.Trim.ToUpper Then
                    'We found another methodology with the same name
                    SetError(cell, "The Step Type must be unique!")
                    Return False
                End If
            Next
        End If

        'If we made it here then all is well
        SetError(cell, "")
        Return True

    End Function


    Private Function IsMethStepDaysSincePrevValid(ByVal cell As DataGridViewCell) As Boolean

        'Do the validation
        If cell.Value Is Nothing OrElse cell.Value.ToString.Length = 0 Then
            'The days since previous step must be filled in
            SetError(cell, "You must provide the Days Since Previous Step!")
            Return False
        ElseIf Not IsNumeric(cell.Value.ToString) Then
            'This must be numeric
            SetError(cell, "The Days Since Previous Step must be numeric!")
            Return False
        ElseIf cell.OwningRow.Index = 0 AndAlso CType(cell.Value, Integer) <> 0 Then
            'The first step must be 0
            SetError(cell, "The Days Since Previous Step for the first step must be 0!")
            Return False
        ElseIf cell.OwningRow.Index > 0 AndAlso CType(cell.OwningRow.Cells(MethStepIncludeWithPrevColumn.Index).Value, Boolean) AndAlso CType(cell.Value, Integer) <> 0 Then
            'This is not the first step and it is included with the previous so this must be 0
            SetError(cell, "The Days Since Previous Step for an included step must be 0!")
            Return False
        ElseIf cell.OwningRow.Index > 0 AndAlso Not CType(cell.OwningRow.Cells(MethStepIncludeWithPrevColumn.Index).Value, Boolean) AndAlso CType(cell.Value, Integer) <= 0 Then
            'This is not the first step and it is not included with the previous so this must be greater than 0
            SetError(cell, "The Days Since Previous Step for this step must be greater than 0!")
            Return False
        End If

        'If we made it here then all is well
        SetError(cell, "")
        Return True

    End Function


    Private Function IsMethStepCoverLetterValid(ByVal cell As DataGridViewCell) As Boolean

        'Do the validation
        If cell.Value Is Nothing OrElse cell.Value.ToString.Length = 0 Then
            'The Cover Letter must be selected
            SetError(cell, "You must select a Cover Letter!")
            Return False
        End If

        'If we made it here then all is well
        SetError(cell, "")
        Return True

    End Function


    Private Function IsMethStepLanguageValid(ByVal cell As DataGridViewCell) As Boolean

        'Do the validation
        If cell.Value Is Nothing OrElse cell.Value.ToString.Length = 0 Then
            'The Language must be selected
            SetError(cell, "You must select a Language!")
            Return False
        ElseIf CType(cell.OwningRow.Cells(MethStepIncludeWithPrevColumn.Index).Value, Boolean) AndAlso CType(cell.Value, Integer) = 0 Then
            'The Language can't be "Use Lang ID" if the Include with Previous option is selected
            SetError(cell, "Language cannot be 'Use Lang ID' if you Include with Previous Step!")
            Return False
        End If

        'If we made it here then all is well
        SetError(cell, "")
        Return True

    End Function


    Private Function IsMethStepIncludeWithPrevValid(ByVal cell As DataGridViewCell) As Boolean

        'Do the validation
        If cell.Value Is Nothing OrElse cell.Value.ToString.Length = 0 Then
            'The Include With Previous must be selected
            SetError(cell, "You must select an option for Include With Previous Step!")
            Return False
        ElseIf cell.OwningRow.Index = 0 AndAlso CType(cell.Value, Boolean) Then
            'The first step must be No
            SetError(cell, "The Include With Previous Step for the first step must be No!")
            Return False
        End If

        'If we made it here then all is well
        SetError(cell, "")
        Return True

    End Function


    Private Function IsMethStepExpirationDaysValid(ByVal cell As DataGridViewCell) As Boolean
        Dim DaysToExpire As Integer = AppConfig.Params("DaysToExpire").IntegerValue
        'Do the validation
        If cell.Value Is Nothing OrElse cell.Value.ToString.Length = 0 Then
            'The expiration days must be filled in
            SetError(cell, "You must provide the Days Until Expiration!")
            Return False
        ElseIf Not IsNumeric(cell.Value.ToString) Then
            'This must be numeric
            SetError(cell, "The Days Until Expiration must be numeric!")
            Return False
        ElseIf CType(cell.Value.ToString, Integer) <= 0 Then
            'This must be greater than 0
            SetError(cell, "The Days Until Expiration must be greater than 0!")
            Return False
        ElseIf CType(cell.Value.ToString, Integer) > DaysToExpire Then
            'This must be less than or equal to 84
            'RV: removing the 84 hardcode. Using daystoexpire parameter.
            SetError(cell, String.Format("The Days Until Expiration must be less than or equal to {0}!", DaysToExpire))
            Return False
        End If

        'If we made it here then all is well
        SetError(cell, "")
        Return True

    End Function


    Private Function IsMethStepExpireFromStepValid(ByVal cell As DataGridViewCell) As Boolean

        'Do the validation
        If cell.Value Is Nothing OrElse cell.Value.ToString.Length = 0 Then
            'The Expire From Step must be selected
            SetError(cell, "You must select a Expire From Step!")
            Return False
        End If

        'If we made it here then all is well
        SetError(cell, "")
        Return True

    End Function

    Private Function IsMethStepPropertiesValid(ByVal row As DataGridViewRow) As Boolean

        Dim methstep As MethodologyStep = TryCast(MethStepDataGrid.Rows(row.Index).Tag, MethodologyStep)
        If methstep Is Nothing Then Return True

        Dim webBlastValid As Boolean
        If WebBlastErrorProvider.GetError(WebEmailBlastCheckBox) <> String.Empty Then
            webBlastValid = False
        Else
            webBlastValid = True
        End If

        Return methstep.IsValid And methstep.EmailBlastList.IsValid And webBlastValid

    End Function

#End Region

#Region "Private Methods - Methodology Step Properties"

    Private Sub DisplayMethStepProps(ByVal methStep As MethodologyStep)

        MethodologyPropsPhonePanel.Visible = False
        MethodologyPropsWebPanel.Visible = False
        MethodologyPropsIVRPanel.Visible = False

        Select Case methStep.StepMethodId
            Case MailingStepMethodCodes.Phone
                SplitContainer1.Panel2.Enabled = True
                MethodologyPropsPhonePanel.Visible = True
                PopulateMethProps(methStep)

            Case MailingStepMethodCodes.Web, MailingStepMethodCodes.MailWeb, MailingStepMethodCodes.LetterWeb
                SplitContainer1.Panel2.Enabled = True
                MethodologyPropsWebPanel.Visible = True
                PopulateEmailBlastOptions()
                PopulateMethProps(methStep)
                PopulateEmailBlast(methStep)

            Case MailingStepMethodCodes.IVR
                SplitContainer1.Panel2.Enabled = True
                MethodologyPropsIVRPanel.Visible = True
                PopulateMethProps(methStep)

            Case Else
                PopulateMethProps(methStep)

        End Select

    End Sub

    Private Sub PopulateEmailBlastOptions()

        Dim blastopts As EmailBlastOptionCollection = EmailBlastOption.GetAll
        EmailBlastOptionBindingSource.DataSource = blastopts

    End Sub

    Private Sub PopulateEmailBlast(ByVal methStep As MethodologyStep)

        EmailBlastBindingSource.DataSource = methStep.EmailBlastList

    End Sub

    Private Sub ClearMethPropsBindings()

        'Clear the Methodology Properties bindings

        'Phone
        With PhoneDaysInFieldTextBox
            .DataBindings.Clear()
            .Text = ""
        End With
        With PhoneNumberOfAttemptsTextBox
            .DataBindings.Clear()
            .Text = ""
        End With
        With PhoneQuotasStopReturnsTextBox
            .DataBindings.Clear()
            .Text = ""
        End With
        With PhoneDayMFCheckBox
            .DataBindings.Clear()
            .Checked = False
        End With
        With PhoneDaySatCheckBox
            .DataBindings.Clear()
            .Checked = False
        End With
        With PhoneDaySunCheckBox
            .DataBindings.Clear()
            .Checked = False
        End With
        With PhoneEveningMFCheckBox
            .DataBindings.Clear()
            .Checked = False
        End With
        With PhoneEveningSatCheckBox
            .DataBindings.Clear()
            .Checked = False
        End With
        With PhoneEveningSunCheckBox
            .DataBindings.Clear()
            .Checked = False
        End With
        With PhoneLangCallbackCheckBox
            .DataBindings.Clear()
            .Checked = False
        End With
        With PhoneTTYCallbackCheckBox
            .DataBindings.Clear()
            .Checked = False
        End With
        With PhoneQuotasAllReturnsRadioButton
            .DataBindings.Clear()
            .Checked = False
        End With
        With PhoneQuotasStopReturnsRadioButton
            .DataBindings.Clear()
            .Checked = False
        End With

        'IVR
        With IVRDaysInFieldTextBox
            .DataBindings.Clear()
            .Text = ""
        End With
        With IVRAcceptPartialCheckBox
            .DataBindings.Clear()
            .Checked = False
        End With

        'Web
        With WebDaysInFieldTextBox
            .DataBindings.Clear()
            .Text = ""
        End With
        With WebAcceptPartialCheckBox
            .DataBindings.Clear()
            .Checked = False
        End With
        With WebQuotasStopReturnsTextBox
            .DataBindings.Clear()
            .Text = ""
        End With
        With WebEmailBlastCheckBox
            .DataBindings.Clear()
            .Checked = False
        End With
        With WebQuotasAllReturnsRadioButton
            .DataBindings.Clear()
            .Checked = False
        End With
        With WebQuotasStopReturnsRadioButton
            .DataBindings.Clear()
            .Checked = False
        End With

        MethPropsErrorProvider.DataSource = Nothing
        MethPropsErrorProvider.Clear()

    End Sub

    Private Sub ClearOldMethPropsValues(ByVal methStep As MethodologyStep)

        'Clear all non new step type properties
        Select Case methStep.StepMethodId
            Case MailingStepMethodCodes.Phone
                With methStep
                    If .IsAcceptPartial Then .IsAcceptPartial = False
                    If .IsEmailBlast Then .IsEmailBlast = False
                    If .EmailBlastList.Count > 0 Then .EmailBlastList = New EmailBlastCollection
                    If Not .QuotaID.HasValue Then .QuotaID = 1 'Default to return all
                End With

            Case MailingStepMethodCodes.Web, MailingStepMethodCodes.MailWeb, MailingStepMethodCodes.LetterWeb
                With methStep
                    If .NumberOfAttempts > 0 Then .NumberOfAttempts = 0
                    If .IsWeekDayDayCall Then .IsWeekDayDayCall = False
                    If .IsWeekDayEveCall Then .IsWeekDayEveCall = False
                    If .IsSaturdayDayCall Then .IsSaturdayDayCall = False
                    If .IsSaturdayEveCall Then .IsSaturdayEveCall = False
                    If .IsSundayDayCall Then .IsSundayDayCall = False
                    If .IsSundayEveCall Then .IsSundayEveCall = False
                    If .IsCallBackOtherLang Then .IsCallBackOtherLang = False
                    If .IsCallBackUsingTTY Then .IsCallBackUsingTTY = False
                    If Not .QuotaID.HasValue Then .QuotaID = 1 'Default to return all
                End With

            Case MailingStepMethodCodes.IVR
                With methStep
                    If .NumberOfAttempts > 0 Then .NumberOfAttempts = 0
                    If .IsWeekDayDayCall Then .IsWeekDayDayCall = False
                    If .IsWeekDayEveCall Then .IsWeekDayEveCall = False
                    If .IsSaturdayDayCall Then .IsSaturdayDayCall = False
                    If .IsSaturdayEveCall Then .IsSaturdayEveCall = False
                    If .IsSundayDayCall Then .IsSundayDayCall = False
                    If .IsSundayEveCall Then .IsSundayEveCall = False
                    If .IsCallBackOtherLang Then .IsCallBackOtherLang = False
                    If .IsCallBackUsingTTY Then .IsCallBackUsingTTY = False
                    If .IsEmailBlast Then .IsEmailBlast = False
                    If .EmailBlastList.Count > 0 Then .EmailBlastList = New EmailBlastCollection
                    If .QuotaID.HasValue Then .QuotaID = Nothing
                    If .QuotaStopCollectionAt > 0 Then .QuotaStopCollectionAt = 0
                End With

        End Select

    End Sub

    Private Sub PopulateMethProps(ByVal methStep As MethodologyStep)

        'Clear the methodology properties of all bindings
        ClearMethPropsBindings()

        'Populate the methodology properties section

        'Phone
        PhoneDaysInFieldTextBox.DataBindings.Add("Text", methStep, "DaysInField", False, DataSourceUpdateMode.OnPropertyChanged)
        PhoneNumberOfAttemptsTextBox.DataBindings.Add("Text", methStep, "NumberOfAttempts", False, DataSourceUpdateMode.OnPropertyChanged)
        PhoneQuotasStopReturnsTextBox.DataBindings.Add("Text", methStep, "QuotaStopCollectionAt", False, DataSourceUpdateMode.OnPropertyChanged)
        PhoneDayMFCheckBox.DataBindings.Add("Checked", methStep, "IsWeekDayDayCall", False, DataSourceUpdateMode.OnPropertyChanged)
        PhoneDaySatCheckBox.DataBindings.Add("Checked", methStep, "IsSaturdayDayCall", False, DataSourceUpdateMode.OnPropertyChanged)
        PhoneDaySunCheckBox.DataBindings.Add("Checked", methStep, "IsSundayDayCall", False, DataSourceUpdateMode.OnPropertyChanged)
        PhoneEveningMFCheckBox.DataBindings.Add("Checked", methStep, "IsWeekDayEveCall", False, DataSourceUpdateMode.OnPropertyChanged)
        PhoneEveningSatCheckBox.DataBindings.Add("Checked", methStep, "IsSaturdayEveCall", False, DataSourceUpdateMode.OnPropertyChanged)
        PhoneEveningSunCheckBox.DataBindings.Add("Checked", methStep, "IsSundayEveCall", False, DataSourceUpdateMode.OnPropertyChanged)
        PhoneLangCallbackCheckBox.DataBindings.Add("Checked", methStep, "IsCallBackOtherLang", False, DataSourceUpdateMode.OnPropertyChanged)
        PhoneTTYCallbackCheckBox.DataBindings.Add("Checked", methStep, "IsCallBackUsingTTY", False, DataSourceUpdateMode.OnPropertyChanged)
        PhoneQuotasAllReturnsRadioButton.DataBindings.Add("Checked", methStep, "QuotaIDAllReturns", False, DataSourceUpdateMode.OnValidation)
        PhoneQuotasStopReturnsRadioButton.DataBindings.Add("Checked", methStep, "QuotaIDStopReturns", False, DataSourceUpdateMode.OnValidation)

        'IVR
        IVRDaysInFieldTextBox.DataBindings.Add("Text", methStep, "DaysInField", False, DataSourceUpdateMode.OnPropertyChanged)
        IVRAcceptPartialCheckBox.DataBindings.Add("Checked", methStep, "IsAcceptPartial", False, DataSourceUpdateMode.OnPropertyChanged)

        'Web
        WebDaysInFieldTextBox.DataBindings.Add("Text", methStep, "DaysInField", False, DataSourceUpdateMode.OnPropertyChanged)
        WebQuotasStopReturnsTextBox.DataBindings.Add("Text", methStep, "QuotaStopCollectionAt", False, DataSourceUpdateMode.OnPropertyChanged)
        WebAcceptPartialCheckBox.DataBindings.Add("Checked", methStep, "IsAcceptPartial", False, DataSourceUpdateMode.OnPropertyChanged)
        WebEmailBlastCheckBox.DataBindings.Add("Checked", methStep, "IsEmailBlast", False, DataSourceUpdateMode.OnPropertyChanged)
        WebQuotasAllReturnsRadioButton.DataBindings.Add("Checked", methStep, "QuotaIDAllReturns", False, DataSourceUpdateMode.OnValidation)
        WebQuotasStopReturnsRadioButton.DataBindings.Add("Checked", methStep, "QuotaIDStopReturns", False, DataSourceUpdateMode.OnValidation)

        'Set error provider
        MethPropsErrorProvider.DataSource = methStep

        'Initialize stop at text box
        PhoneQuotasStopReturnsTextBox.Enabled = PhoneQuotasStopReturnsRadioButton.Checked
        WebQuotasStopReturnsTextBox.Enabled = WebQuotasStopReturnsRadioButton.Checked

    End Sub

#End Region

#End Region

#Region " Control Events "

#Region " Control Events - Form Stuff "

    Private Sub MethodologyEditor_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load

        Initialize()

    End Sub


    Private Sub OKButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles OKButton.Click

        'Validate all methodologies
        If Not AreMethRowsValid() Then Exit Sub

        'All is good so we can save and hit the road
        For Each row As DataGridViewRow In MethDataGrid.Rows
            'Get a reference to the Methodology object
            Dim meth As Methodology = DirectCast(row.Tag, Methodology)

            'If this Methodology is dirty then save it
            If meth.IsDirty Or meth.IsNew Then meth.Update()
        Next

        'Do whatever this line of code does :)
        mEndConfigCallback(ConfigResultActions.SurveyRefresh, Nothing)

    End Sub


    Private Sub CancelButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles CancelButton.Click

        'Do whatever this line of code does :)
        mEndConfigCallback(ConfigResultActions.None, Nothing)

    End Sub


    Private Sub SplitContainerPanel1_EnabledChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles SplitContainer.Panel1.EnabledChanged

        If SplitContainer.Panel1.Enabled Then
            'MethDataGrid.ForeColor = SystemColors.ControlText
            MethDataGrid.DefaultCellStyle.BackColor = SystemColors.Window
        Else
            'MethDataGrid.ForeColor = SystemColors.GrayText
            MethDataGrid.DefaultCellStyle.BackColor = SystemColors.ButtonFace
        End If

    End Sub


    Private Sub SplitContainerPanel2_EnabledChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles SplitContainer.Panel2.EnabledChanged

        If SplitContainer.Panel2.Enabled Then
            'MethStepDataGrid.ForeColor = SystemColors.ControlText
            MethStepDataGrid.DefaultCellStyle.BackColor = SystemColors.Window
        Else
            'MethStepDataGrid.ForeColor = SystemColors.GrayText
            MethStepDataGrid.DefaultCellStyle.BackColor = SystemColors.ButtonFace
        End If

    End Sub

#End Region

#Region " Control Events - MethToolStrip "

    Private Sub MethNewTSButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MethNewTSButton.Click

        NewMethodology()

    End Sub


    Private Sub MethDeleteTSButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MethDeleteTSButton.Click

        DeleteMethodology()

    End Sub


    Private Sub MethEditTSButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MethEditTSButton.Click

        EditMethodology()

    End Sub


    Private Sub MethActivateTSButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MethActivateTSButton.Click

        ActivateMethodology()

    End Sub


    Private Sub MethUndoTSButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MethUndoTSButton.Click

        UndoChanges(False)

    End Sub

#End Region

#Region " Control Events - MethStepToolStrip "

    Private Sub MethStepNewTSButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MethStepNewTSButton.Click

        NewMethodologyStep()

    End Sub


    Private Sub MethStepDeleteTSButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MethStepDeleteTSButton.Click

        DeleteMethodologyStep()

    End Sub


    Private Sub MethStepMoveUpTSButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MethStepMoveUpTSButton.Click

        MoveMethodologyStepUp()

    End Sub


    Private Sub MethStepMoveDownTSButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MethStepMoveDownTSButton.Click

        MoveMethodologyStepDown()

    End Sub


    Private Sub MethStepApplyTSButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MethStepApplyTSButton.Click

        ApplyMethodologyStepChanges()

    End Sub


    Private Sub MethStepUndoTSButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MethStepUndoTSButton.Click

        UndoChanges(True)

    End Sub

#End Region

#Region " Control Events - MethMenuStrip "

    Private Sub MethNewMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MethNewMenuItem.Click

        NewMethodology()

    End Sub


    Private Sub MethDeleteMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MethDeleteMenuItem.Click

        DeleteMethodology()

    End Sub


    Private Sub MethEditMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MethEditMenuItem.Click

        EditMethodology()

    End Sub


    Private Sub MethActivateMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MethActivateMenuItem.Click

        ActivateMethodology()

    End Sub


    Private Sub MethUndoMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MethUndoMenuItem.Click

        UndoChanges(False)

    End Sub

#End Region

#Region " Control Events - MethStepMenuStrip "

    Private Sub MethStepNewMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MethStepNewMenuItem.Click

        NewMethodologyStep()

    End Sub


    Private Sub MethStepDeleteMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MethStepDeleteMenuItem.Click

        DeleteMethodologyStep()

    End Sub


    Private Sub MethStepMoveUpMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MethStepMoveUpMenuItem.Click

        MoveMethodologyStepUp()

    End Sub


    Private Sub MethStepMoveDownMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MethStepMoveDownMenuItem.Click

        MoveMethodologyStepDown()

    End Sub


    Private Sub MethStepApplyMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MethStepApplyMenuItem.Click

        ApplyMethodologyStepChanges()

    End Sub


    Private Sub MethStepUndoMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MethStepUndoMenuItem.Click

        UndoChanges(True)

    End Sub

#End Region

#Region " Control Events - MethDataGrid "

    Private Sub MethDataGrid_MouseDown(ByVal sender As Object, ByVal e As System.Windows.Forms.MouseEventArgs) Handles MethDataGrid.MouseDown

        'If this is not the right mouse button then we are out of here
        If e.Button <> Windows.Forms.MouseButtons.Right Then Exit Sub

        'Determine where we are in the grid
        Dim hitTest As DataGridView.HitTestInfo = MethDataGrid.HitTest(e.X, e.Y)

        Select Case hitTest.Type
            Case DataGridViewHitTestType.Cell, DataGridViewHitTestType.RowHeader
                'Make sure the row that was clicked on is selected
                If hitTest.RowIndex <> MethDataGrid.SelectedRows(0).Index Then
                    SelectMethRow(hitTest.RowIndex)
                End If

                'Setup the menu item availability
                MethNewMenuItem.Enabled = MethNewTSButton.Enabled
                MethDeleteMenuItem.Enabled = MethDeleteTSButton.Enabled
                MethEditMenuItem.Enabled = MethEditTSButton.Enabled
                MethActivateMenuItem.Enabled = MethActivateTSButton.Enabled
                MethUndoMenuItem.Enabled = MethUndoTSButton.Enabled

            Case Else
                'Setup the menu item availability
                MethNewMenuItem.Enabled = MethNewTSButton.Enabled
                MethDeleteMenuItem.Enabled = False
                MethEditMenuItem.Enabled = False
                MethActivateMenuItem.Enabled = False
                MethUndoMenuItem.Enabled = False

        End Select

    End Sub


    Private Sub MethDataGrid_RowStateChanged(ByVal sender As Object, ByVal e As System.Windows.Forms.DataGridViewRowStateChangedEventArgs) Handles MethDataGrid.RowStateChanged

        If mIsDeleting Then Exit Sub

        Select Case e.StateChanged
            Case DataGridViewElementStates.Selected
                'This event fires both when the old row is not selected anymore and when the new is is selected
                'Skip when the old row is not selected anymore
                If e.Row.Selected Then
                    'The user has selected a new Methodology in the grid so we need to display the steps

                    'Get the selected methodology
                    Dim meth As Methodology = TryCast(e.Row.Tag, Methodology)
                    If meth Is Nothing Then Exit Sub

                    'If we are still here then we need to populate the Methodology Steps for the selected Methodology
                    PopulateMethSteps(meth)

                    'Setup the methodology toolbar
                    SetupMethToolbar(meth)
                End If

        End Select

    End Sub


    Private Sub MethDataGrid_EditingControlShowing(ByVal sender As Object, ByVal e As System.Windows.Forms.DataGridViewEditingControlShowingEventArgs) Handles MethDataGrid.EditingControlShowing

        If e.Control.GetType.Name = "DataGridViewComboBoxEditingControl" Then
            Dim cboBox As ComboBox = TryCast(e.Control, ComboBox)
            If cboBox IsNot Nothing Then
                RemoveHandler cboBox.SelectionChangeCommitted, AddressOf MethDataGridComboBox_SelectedIndexChanged
                AddHandler cboBox.SelectionChangeCommitted, AddressOf MethDataGridComboBox_SelectedIndexChanged
            End If
        ElseIf e.Control.GetType.Name = "DataGridViewTextBoxEditingControl" Then
            Dim txtBox As TextBox = TryCast(e.Control, TextBox)
            If txtBox IsNot Nothing Then
                RemoveHandler txtBox.TextChanged, AddressOf MethDataGridTextBox_TextChanged
                AddHandler txtBox.TextChanged, AddressOf MethDataGridTextBox_TextChanged
            End If
        End If

    End Sub


    Private Sub MethDataGridComboBox_SelectedIndexChanged(ByVal sender As Object, ByVal e As EventArgs)

        If mIsDeleting Then Exit Sub

        'Get a reference to the methodology
        Dim meth As Methodology = DirectCast(MethDataGrid.SelectedRows(0).Tag, Methodology)

        'Get a reference to the combobox
        Dim cboBox As ComboBox = CType(sender, ComboBox)

        'Get a reference to the current grid cell
        Dim currentCell As DataGridViewCell = MethDataGrid.CurrentCell

        'Set the cell value based on the combobox selection
        currentCell.Value = cboBox.SelectedValue

        'Take care of other column specific tasks
        Select Case currentCell.ColumnIndex
            Case MethTypeColumn.Index
                'Update the methodology object
                Dim stdMeth As StandardMethodology = StandardMethodology.Get(CType(currentCell.Value, Integer))
                If Not (meth.StandardMethodology Is stdMeth) Then
                    meth.StandardMethodology = stdMeth

                    'Repopulate the methodology steps
                    PopulateMethSteps(meth)

                    'Validate the new type
                    IsMethTypeValid(currentCell)
                    AreMethStepRowsValid(currentCell.OwningRow)
                End If

        End Select

        'Reset the methodology toolbar
        SetupMethToolbar(meth)

    End Sub


    Private Sub MethDataGridTextBox_TextChanged(ByVal sender As Object, ByVal e As System.EventArgs)

        If mIsDeleting Then Exit Sub

        'Get a reference to the methodology
        Dim meth As Methodology = DirectCast(MethDataGrid.SelectedRows(0).Tag, Methodology)

        'Get a reference to the textbox
        Dim txtBox As TextBox = CType(sender, TextBox)

        'Get a reference to the current grid cell
        Dim currentCell As DataGridViewCell = MethDataGrid.CurrentCell

        'Set the cell value based on the textbox value
        currentCell.Value = txtBox.Text

        'Take care of other column specific tasks
        Select Case currentCell.ColumnIndex
            Case MethNameColumn.Index
                'Update the methodology object
                If meth.Name <> txtBox.Text Then
                    meth.Name = txtBox.Text

                    'Validate the new type
                    IsMethNameValid(currentCell)
                End If

        End Select

        'Reset the methodology toolbar
        SetupMethToolbar(meth)

    End Sub

#End Region

#Region " Control Events - MethStepDataGrid "

    Private Sub MethStepDataGrid_MouseDown(ByVal sender As Object, ByVal e As System.Windows.Forms.MouseEventArgs) Handles MethStepDataGrid.MouseDown

        'If this is not the right mouse button then we are out of here
        If e.Button <> Windows.Forms.MouseButtons.Right Then Exit Sub

        'Determine where we are in the grid
        Dim hitTest As DataGridView.HitTestInfo = MethStepDataGrid.HitTest(e.X, e.Y)

        Select Case hitTest.Type
            Case DataGridViewHitTestType.Cell, DataGridViewHitTestType.RowHeader
                'Make sure the row that was clicked on is selected
                If hitTest.RowIndex <> MethStepDataGrid.SelectedRows(0).Index Then
                    SelectMethStepRow(hitTest.RowIndex)
                End If

                'Setup the menu item availability
                MethStepNewMenuItem.Enabled = MethStepNewTSButton.Enabled
                MethStepDeleteMenuItem.Enabled = MethStepDeleteTSButton.Enabled
                MethStepMoveUpMenuItem.Enabled = MethStepMoveUpTSButton.Enabled
                MethStepMoveDownMenuItem.Enabled = MethStepMoveDownTSButton.Enabled
                MethStepApplyMenuItem.Enabled = MethStepApplyTSButton.Enabled
                MethStepUndoMenuItem.Enabled = MethStepUndoTSButton.Enabled

            Case Else
                'Setup the menu item availability
                MethStepNewMenuItem.Enabled = MethStepNewTSButton.Enabled
                MethStepDeleteMenuItem.Enabled = False
                MethStepMoveUpMenuItem.Enabled = False
                MethStepMoveDownMenuItem.Enabled = False
                MethStepApplyMenuItem.Enabled = MethStepApplyTSButton.Enabled
                MethStepUndoMenuItem.Enabled = MethStepUndoTSButton.Enabled

        End Select

    End Sub

    Private Sub MethStepDataGrid_RowStateChanged(ByVal sender As Object, ByVal e As System.Windows.Forms.DataGridViewRowStateChangedEventArgs) Handles MethStepDataGrid.RowStateChanged

        If mIsDeleting Then Exit Sub

        Select Case e.StateChanged
            Case DataGridViewElementStates.Selected
                'This event fires both when the old row is not selected anymore and when the new is is selected
                'Skip when the old row is not selected anymore
                If e.Row.Selected Then
                    'The user has selected a new Methodology Step in the grid so we need to update the buttons

                    'Get the selected methodology step
                    Dim methStep As MethodologyStep = TryCast(e.Row.Tag, MethodologyStep)
                    If methStep Is Nothing Then Exit Sub

                    'If we are still here then we need to update the toolbar for this Methodology Step
                    SetupMethStepToolbar(methStep)

                    'Refresh the property panel to selected methodology
                    DisplayMethStepProps(methStep)

                Else
                    'Handling the previous selected row save of web email blast grid
                    If MethodologyPropsWebPanel.Visible Then
                        Dim methStep As MethodologyStep = TryCast(e.Row.Tag, MethodologyStep)
                        If methStep Is Nothing Then Exit Sub

                        If WebEmailBlastGridView.IsEditing Then
                            If WebEmailBlastGridView.ValidateEditor Then
                                WebEmailBlastGridView.CloseEditor()
                            End If
                        End If

                        methStep.EmailBlastList = DirectCast(EmailBlastBindingSource.DataSource, EmailBlastCollection)
                    End If

                    'Hide all meth property panels
                    MethodologyPropsPhonePanel.Visible = False
                    MethodologyPropsWebPanel.Visible = False
                    MethodologyPropsIVRPanel.Visible = False
                End If
        End Select

    End Sub


    Private Sub MethStepDataGrid_EditingControlShowing(ByVal sender As Object, ByVal e As System.Windows.Forms.DataGridViewEditingControlShowingEventArgs) Handles MethStepDataGrid.EditingControlShowing

        If e.Control.GetType.Name = "DataGridViewComboBoxEditingControl" Then
            Dim cboBox As ComboBox = TryCast(e.Control, ComboBox)
            If cboBox IsNot Nothing Then
                RemoveHandler cboBox.SelectionChangeCommitted, AddressOf MethStepDataGridComboBox_SelectedIndexChanged
                AddHandler cboBox.SelectionChangeCommitted, AddressOf MethStepDataGridComboBox_SelectedIndexChanged
            End If
        ElseIf e.Control.GetType.Name = "DataGridViewTextBoxEditingControl" Then
            Dim txtBox As TextBox = TryCast(e.Control, TextBox)
            If txtBox IsNot Nothing Then
                RemoveHandler txtBox.TextChanged, AddressOf MethStepDataGridTextBox_TextChanged
                AddHandler txtBox.TextChanged, AddressOf MethStepDataGridTextBox_TextChanged
            End If
        End If

    End Sub


    Private Sub MethStepDataGridComboBox_SelectedIndexChanged(ByVal sender As Object, ByVal e As EventArgs)

        If mIsDeleting Then Exit Sub

        'Get a reference to the methodology step
        Dim methStep As MethodologyStep = DirectCast(MethStepDataGrid.SelectedRows(0).Tag, MethodologyStep)

        'Get a reference to the combobox
        Dim cboBox As ComboBox = DirectCast(sender, ComboBox)

        'Get a reference to the current grid cell
        Dim currentCell As DataGridViewCell = MethStepDataGrid.CurrentCell

        'Set the cell value based on the combobox selection
        currentCell.Value = cboBox.SelectedValue

        'Take care of other column specific tasks
        Select Case currentCell.ColumnIndex
            Case MethStepTypeComboBoxColumn.Index
                'Update the methodology step object
                Dim methStepType As MethodologyStepType = GetMethStepType(CType(currentCell.Value, String))
                If methStep.Name <> methStepType.Name Then
                    'Do this to set the dirty flag properly
                    methStep.Name = methStepType.Name

                    'Now set the step type
                    methStep.CopyStepTypeProperties(methStepType)

                    'Validate the step type (we validate all rows as this will check for duplicate step types)
                    AreMethStepRowsValid(MethDataGrid.SelectedRows(0))

                    'Update the expire from step lists
                    UpdateExpireFromStepLists(currentCell.RowIndex)

                    'Update the coverletter list
                    UpdateCoverLetterList(currentCell.RowIndex, methStep)

                    'Display methodology step properties
                    ClearOldMethPropsValues(methStep)
                    DisplayMethStepProps(methStep)
                End If

            Case MethStepCoverLetterColumn.Index
                'Update the methodology step object
                Dim coverLetterId As Integer = CType(currentCell.Value, Integer)
                If methStep.CoverLetterId <> coverLetterId Then
                    methStep.CoverLetterId = coverLetterId

                    'Validate the cover letter
                    IsMethStepCoverLetterValid(currentCell)
                End If

            Case MethStepLanguageColumn.Index
                'Update the methodology step object
                Dim langId As System.Nullable(Of Integer) = CType(currentCell.Value, Integer)
                If CType(currentCell.Value, Integer) = 0 Then
                    langId = Nothing
                Else
                    langId = CType(currentCell.Value, Integer)
                End If

                If (methStep.OverrideLanguageId.HasValue And Not langId.HasValue) OrElse (Not methStep.OverrideLanguageId.HasValue And langId.HasValue) OrElse _
                   ((methStep.OverrideLanguageId.HasValue And langId.HasValue) AndAlso (methStep.OverrideLanguageId.Value <> langId.Value)) Then
                    'The values are different so let's set it
                    methStep.OverrideLanguageId = langId

                    'Validate the language
                    IsMethStepLanguageValid(currentCell)
                End If

            Case MethStepIncludeWithPrevColumn.Index
                'Update the methodology step object
                Dim linkedStep As MethodologyStep
                If CType(currentCell.Value, Boolean) AndAlso currentCell.RowIndex = 0 Then
                    'The user selected YES, but this is the first row and only NO is valid
                    cboBox.SelectedValue = 0
                    currentCell.Value = cboBox.SelectedValue
                    linkedStep = methStep
                ElseIf CType(currentCell.Value, Boolean) Then
                    'The user selected YES so set the linked step to the linked step from the previous row
                    linkedStep = DirectCast(currentCell.DataGridView.Rows(currentCell.RowIndex - 1).Tag, MethodologyStep).LinkedStep
                Else
                    'The user selected NO so the linked step is set to it's self
                    linkedStep = methStep
                End If

                If Not (methStep.LinkedStep Is linkedStep) Then
                    methStep.LinkedStep = linkedStep

                    'Validate the linked step
                    IsMethStepIncludeWithPrevValid(currentCell)

                    'Revalidate the days since previous
                    IsMethStepDaysSincePrevValid(currentCell.OwningRow.Cells(MethStepDaysSincePrevColumn.Index))
                End If

            Case MethStepExpireFromStepColumn.Index
                'Update the methodology step object
                Dim expireFromStep As MethodologyStep = DirectCast(currentCell.Value, MethodologyStep)
                If Not (methStep.ExpireFromStep Is expireFromStep) Then
                    methStep.ExpireFromStep = expireFromStep

                    'Validate the expire from step
                    IsMethStepExpireFromStepValid(currentCell)
                    MethPropsErrorProvider.UpdateBinding()
                End If

        End Select

        'Reset the methodology steps toolbar
        SetupMethStepToolbar(methStep)

    End Sub


    Private Sub MethStepDataGridTextBox_TextChanged(ByVal sender As Object, ByVal e As System.EventArgs)

        If mIsDeleting Then Exit Sub

        'Get a reference to the methodology step
        Dim methStep As MethodologyStep = DirectCast(MethStepDataGrid.SelectedRows(0).Tag, MethodologyStep)

        'Get a reference to the textbox
        Dim txtBox As TextBox = CType(sender, TextBox)

        'Get a reference to the current grid cell
        Dim currentCell As DataGridViewCell = MethStepDataGrid.CurrentCell

        'Set the cell value based on the textbox value
        currentCell.Value = txtBox.Text

        'Take care of other column specific tasks
        Select Case currentCell.ColumnIndex
            Case MethStepTypeTextBoxColumn.Index
                'If the text box is being used the user is not able to modify the record

            Case MethStepDaysSincePrevColumn.Index
                'Update the methodology step object
                If IsMethStepDaysSincePrevValid(currentCell) Then
                    Dim daysSincePreviousStep As Integer = CType(currentCell.Value, Integer)
                    If methStep.DaysSincePreviousStep <> daysSincePreviousStep Then
                        methStep.DaysSincePreviousStep = daysSincePreviousStep
                    End If
                End If

            Case MethStepExpirationDaysColumn.Index
                'Update the methodology step object
                If IsMethStepExpirationDaysValid(currentCell) Then
                    Dim expirationDays As Integer = CType(currentCell.Value, Integer)
                    If methStep.ExpirationDays <> expirationDays Then
                        methStep.ExpirationDays = expirationDays
                    End If
                End If

        End Select

        'Reset the methodology steps toolbar
        SetupMethStepToolbar(methStep)

    End Sub

#End Region

#Region "Control Events - Methodology Properties Section"

    Private Sub WebQuotasAllReturnsRadioButton_CheckedChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles WebQuotasAllReturnsRadioButton.CheckedChanged

        If MethodologyPropsWebPanel.Visible Then
            'Using send keys to refresh the validation
            SendKeys.Send("{TAB}")
            SendKeys.Send("+{TAB}")
        End If

    End Sub

    Private Sub WebQuotasStopReturnsRadioButton_CheckedChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles WebQuotasStopReturnsRadioButton.CheckedChanged

        If MethodologyPropsWebPanel.Visible Then
            If WebQuotasStopReturnsRadioButton.Checked Then
                WebQuotasStopReturnsTextBox.Enabled = True
            Else
                WebQuotasStopReturnsTextBox.Enabled = False
            End If
            'Using send keys to get a quick refresh of WebQuotasStopReturnsTextBox back to 0
            SendKeys.Send("{TAB}")
            SendKeys.Send("+{TAB}")
        End If

    End Sub

    Private Sub PhoneQuotasAllReturnsRadioButton_CheckedChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles PhoneQuotasAllReturnsRadioButton.CheckedChanged

        If MethodologyPropsPhonePanel.Visible Then
            'Using send keys to refresh the validation
            SendKeys.Send("{TAB}")
            SendKeys.Send("+{TAB}")
        End If

    End Sub

    Private Sub PhoneQuotasStopReturnsRadioButton_CheckedChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles PhoneQuotasStopReturnsRadioButton.CheckedChanged

        If MethodologyPropsPhonePanel.Visible Then
            If PhoneQuotasStopReturnsRadioButton.Checked Then
                PhoneQuotasStopReturnsTextBox.Enabled = True
            Else
                PhoneQuotasStopReturnsTextBox.Enabled = False
            End If
            'Using send keys to get a quick refresh of PhoneQuotasStopReturnsTextBox back to 0
            SendKeys.Send("{TAB}")
            SendKeys.Send("+{TAB}")
        End If

    End Sub

    Private Sub WebEmailBlastCheckBox_CheckedChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles WebEmailBlastCheckBox.CheckedChanged

        Dim methStep As MethodologyStep = TryCast(MethStepDataGrid.SelectedRows(0).Tag, MethodologyStep)
        If methStep Is Nothing Then Exit Sub

        If WebEmailBlastCheckBox.Checked Then
            WebEmailBlastGridControl.Enabled = True
            If methStep.EmailBlastList.Count < 1 Then
                WebBlastErrorProvider.SetError(WebEmailBlastCheckBox, "You must defined at least 1 email blast step!")
            Else
                WebBlastErrorProvider.Clear()
            End If
        Else
            WebEmailBlastGridControl.Enabled = False
            WebBlastErrorProvider.Clear()
        End If

    End Sub

    Private Sub EmailBlastBindingSource_AddingNew(ByVal sender As Object, ByVal e As System.ComponentModel.AddingNewEventArgs) Handles EmailBlastBindingSource.AddingNew

        Dim methStep As MethodologyStep = DirectCast(MethStepDataGrid.SelectedRows(0).Tag, MethodologyStep)

        Dim myblast As EmailBlast = EmailBlast.NewEmailBlast
        myblast.MAILINGSTEPId = methStep.Id
        e.NewObject = myblast

    End Sub

    Private Sub WebEmailBlastGridView_RowCountChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles WebEmailBlastGridView.RowCountChanged

        If EmailBlastBindingSource.Count < 1 AndAlso WebEmailBlastCheckBox.Checked Then
            WebBlastErrorProvider.Clear()
            WebBlastErrorProvider.SetError(WebEmailBlastCheckBox, "You must defined at least 1 email blast step!")
        Else
            WebBlastErrorProvider.Clear()
        End If

    End Sub
#End Region

#End Region

End Class


