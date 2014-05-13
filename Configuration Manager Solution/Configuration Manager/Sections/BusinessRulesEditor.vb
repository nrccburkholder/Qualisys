Imports Nrc.Qualisys.Library

Public Class BusinessRulesEditor

#Region " Private Constant "
    Private Const Provider As String = "Use provider name on encounter record when:"
    Private Const MinorExclusion As String = "Consider a person under 18 not a minor when:"
    Private Const NewBorn As String = "Disqualify as a new-born where:"
    Private Const BadAddress As String = "Do not mail if:"
    Private Const BadPhone As String = "Do not call if:"
#End Region

#Region " Private Fields "
    Private mModule As BusinessRulesModule
    Private mEndConfigCallBack As EndConfigCallBackMethod
#End Region

#Region " Constructors "
    Public Sub New(ByVal surveyModule As BusinessRulesModule, ByVal endConfigCallBack As EndConfigCallBackMethod)
        ' This call is required by the Windows Form Designer.
        InitializeComponent()

        ' Add any initialization after the InitializeComponent() call.
        mModule = surveyModule
        Me.mEndConfigCallBack = endConfigCallBack
    End Sub
#End Region

#Region " Event Handlers "

    Private Sub BusinessRulesEditor_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        DisplayData()
    End Sub

    ' Householding events
    Private Sub NoHouseholdingToolStripButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles NoHouseholdingToolStripButton.Click

        'Uncheck the other buttons
        NoHouseholdingToolStripButton.Checked = True
        AllHouseholdingToolStripButton.Checked = False
        MinorsOnlyHouseholdingToolStripButton.Checked = False

        'Set Available fields to nothing
        HouseholdingTableLayoutPanel.Enabled = False
        AvailableFieldsListBox.Items.Clear()
        SelectedFieldsListBox.Items.Clear()

    End Sub

    Private Sub AllHouseholdingToolStripButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles AllHouseholdingToolStripButton.Click

        'Uncheck the other buttons
        NoHouseholdingToolStripButton.Checked = False
        AllHouseholdingToolStripButton.Checked = True
        MinorsOnlyHouseholdingToolStripButton.Checked = False

        'Reload all the householding fields.
        HouseholdingTableLayoutPanel.Enabled = True
        RefreshHouseholdingFields()

    End Sub

    Private Sub MinorsOnlyHouseholdingToolStripButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MinorsOnlyHouseholdingToolStripButton.Click

        'Uncheck the other buttons
        NoHouseholdingToolStripButton.Checked = False
        AllHouseholdingToolStripButton.Checked = False
        MinorsOnlyHouseholdingToolStripButton.Checked = True

        'Reload all the householding fields.
        HouseholdingTableLayoutPanel.Enabled = True
        RefreshHouseholdingFields()

    End Sub


    ' Householding fields
    Private Sub AddButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles AddButton.Click

        AddToSelectedFields()

    End Sub

    Private Sub RemoveButton_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles RemoveButton.Click

        Me.RemoveFromSelectedFields()
        If SelectedFieldsListBox.Items.Count = 0 Then NoHouseholdingToolStripButton_Click(Me, Nothing)

    End Sub

    Private Sub OKButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles OKButton.Click

        If Not Me.mEndConfigCallBack Is Nothing Then
            'Save all the input data.
            If Not ValidRules() Then Exit Sub

            Me.SaveBusinessRules()
            Me.mEndConfigCallBack(ConfigResultActions.SurveyRefresh, Nothing)
            Me.mEndConfigCallBack = Nothing
        End If

    End Sub

    Private Sub CancelButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles CancelButton.Click

        Me.mEndConfigCallBack(ConfigResultActions.None, Nothing)
        Me.mEndConfigCallBack = Nothing

    End Sub

#End Region

#Region " Context Menu Events "
    ' DQ Rules
    Private Sub DQRulesContextMenuStrip_Opening(ByVal sender As System.Object, ByVal e As System.ComponentModel.CancelEventArgs) Handles DQRulesContextMenuStrip.Opening

        Dim item As ToolStripMenuItem

        ' Hide all the items
        For Each item In Me.DQRulesContextMenuStrip.Items
            item.Visible = False
        Next

        ' If DQ item is not selected or none, can only create a new item.
        Me.NewExceptionToolStripMenuItem.Visible = True

        If Me.DQRulesListView.SelectedItems.Count = 1 Then Me.EditExceptionToolStripMenuItem.Visible = True
        If Me.DQRulesListView.SelectedItems.Count > 0 Then Me.RemoveExceptionToolStripMenuItem.Visible = True

    End Sub

    Private Sub NewExceptionToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles NewExceptionToolStripMenuItem.Click

        ' Create new DQ rule
        Dim criter As New Criteria(mModule.Survey.StudyId)
        Dim DQRule As New BusinessRule(mModule.Survey, criter)

        'Set the rule type
        DQRule.RuleType = BusinessRule.BusinessRuleType.DQ

        ' Launch Criteria Editor
        If ShowCriteriaEditorDialog(DQRule.Criteria, True, True) = DialogResult.OK Then
            'Add this rule to the collection
            mModule.Survey.BusinessRules.Add(DQRule)

            'Refresh the list
            RefreshDQRulesListView()
        End If

    End Sub

    Private Sub EditExceptionToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles EditExceptionToolStripMenuItem.Click

        ' Update DQ Rule
        Dim DQRule As BusinessRule = DirectCast(Me.DQRulesListView.SelectedItems(0).Tag, BusinessRule)

        ' Launch Criteria Editor
        If ShowCriteriaEditorDialog(DQRule.Criteria, True, True) = DialogResult.OK Then
            DQRule.NeedsDeleted = False
            RefreshDQRulesListView()
        End If

    End Sub

    Private Sub RemoveExceptionToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles RemoveExceptionToolStripMenuItem.Click

        ' Delete DQ Rule.
        If Me.DQRulesListView.SelectedItems.Count = 1 Then
            Dim DQ As BusinessRule = DirectCast(Me.DQRulesListView.SelectedItems(0).Tag, BusinessRule)

            If (MessageBox.Show("Do you want to permanently remove " & DQ.Name & "?", "DQ Rules Warning", MessageBoxButtons.YesNo, MessageBoxIcon.Information)) = DialogResult.Yes Then
                DQ.NeedsDeleted = True
            End If
        Else
            If (MessageBox.Show("Do you want to permanently remove the selected DQ Rules?", "DQ Rules Warning", MessageBoxButtons.YesNo, MessageBoxIcon.Information)) = DialogResult.No Then
                Return
            End If

            For Each item As ListViewItem In Me.DQRulesListView.SelectedItems
                Dim DQ As BusinessRule = DirectCast(item.Tag, BusinessRule)
                DQ.NeedsDeleted = True
            Next
        End If

        RefreshDQRulesListView()

    End Sub

    ' Misc Rules
    Private Sub MiscRulesContextMenuStrip_Opening(ByVal sender As System.Object, ByVal e As System.ComponentModel.CancelEventArgs) Handles MiscRulesContextMenuStrip.Opening

        Dim item As ToolStripMenuItem

        ' Hide all the items
        For Each item In Me.MiscRulesContextMenuStrip.Items
            item.Visible = False
        Next

        ' The list for misc rules are fixed.
        ' If the rule query is blank, user can add a new query.
        If Me.MiscRulesListView.SelectedItems.Count > 0 Then
            If Me.MiscRulesListView.SelectedItems(0).SubItems(1).Text.Trim.Length = 0 Then
                Me.AddRuleToolStripMenuItem.Visible = True
            Else
                Me.EditRuleToolStripMenuItem.Visible = True
                Me.RemoveRuleToolStripMenuItem.Visible = True
            End If
        End If

    End Sub

    Private Sub AddRuleToolStripMenuItem_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles AddRuleToolStripMenuItem.Click

        ' Add new Misc Rule.
        ' Create new criteria object
        Dim criter As Criteria
        Dim miscRule As BusinessRule

        'Set the rule type
        criter = New Criteria(mModule.Survey.StudyId)
        miscRule = New BusinessRule(mModule.Survey, criter)
        Select Case Me.MiscRulesListView.SelectedItems(0).Text
            Case BadAddress
                miscRule.RuleType = BusinessRule.BusinessRuleType.BadAddress

            Case BadPhone
                miscRule.RuleType = BusinessRule.BusinessRuleType.BadPhone

            Case NewBorn
                miscRule.RuleType = BusinessRule.BusinessRuleType.Newborn

            Case MinorExclusion
                miscRule.RuleType = BusinessRule.BusinessRuleType.MinorExclusion

            Case Provider
                miscRule.RuleType = BusinessRule.BusinessRuleType.Provider

        End Select

        ' Launch the criteria editor, pass new criteria object
        If ShowCriteriaEditorDialog(miscRule.Criteria, False, True) = DialogResult.OK Then
            'Add the rule to the collection
            mModule.Survey.BusinessRules.Add(miscRule)

            'Update the screen
            With Me.MiscRulesListView.SelectedItems(0)
                .Tag = miscRule
                .SubItems(1).Text = miscRule.Criteria.CriteriaStatementDisplay(True, False)
            End With
        End If

    End Sub

    Private Sub EditRuleToolStripMenuItem_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles EditRuleToolStripMenuItem.Click

        ' Update Misc Rule
        Dim miscRule As BusinessRule = DirectCast(Me.MiscRulesListView.SelectedItems(0).Tag, BusinessRule)

        ' Launch the criteria editor, pass existing criteria object
        If ShowCriteriaEditorDialog(miscRule.Criteria, False, True) = DialogResult.OK Then
            miscRule.NeedsDeleted = False
            MiscRulesListView.SelectedItems(0).SubItems(1).Text = miscRule.Criteria.CriteriaStatementDisplay(True, False)
        End If

    End Sub

    Private Sub RemoveRuleToolStripMenuItem_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles RemoveRuleToolStripMenuItem.Click

        ' Reset the Misc Rule to blank.
        Dim miscRule As BusinessRule = DirectCast(Me.MiscRulesListView.SelectedItems(0).Tag, BusinessRule)

        If (MessageBox.Show("Are you sure you want to remove this rule?", "Misc Rules Warning", MessageBoxButtons.YesNo, MessageBoxIcon.Information)) = DialogResult.Yes Then
            miscRule.NeedsDeleted = True
            Me.MiscRulesListView.SelectedItems(0).SubItems(1).Text = ""
        End If

    End Sub
#End Region

#Region " Private Methods "

    Private Sub DisplayData()

        ' Information bar
        Me.InformationBar.Information = mModule.Information

        Initialize()

        LoadBusinessRules()
        Householding()

        'Disable all the fields when viewing properties
        Me.BodyPanel.Enabled = Me.mModule.IsEditable
        Me.OKButton.Enabled = Me.mModule.IsEditable

    End Sub

    Private Sub Initialize()

        Me.DQRulesListView.Items.Clear()
        Me.LoadMiscRulesRulename()

        ' Default is no householding
        NoHouseholdingToolStripButton_Click(Me, Nothing)

    End Sub

    Private Sub LoadBusinessRules()

        Me.DQRulesListView.Items.Clear()

        For Each rule As BusinessRule In mModule.Survey.BusinessRules
            Select Case rule.RuleType
                ' DQ Rules - use the rule name
                ' Misc Rules - use the constant
                Case BusinessRule.BusinessRuleType.DQ
                    LoadDQRules(rule)

                Case BusinessRule.BusinessRuleType.BadAddress
                    LoadMiscRules(rule, BadAddress)

                Case BusinessRule.BusinessRuleType.BadPhone
                    LoadMiscRules(rule, BadPhone)

                Case BusinessRule.BusinessRuleType.MinorExclusion
                    LoadMiscRules(rule, MinorExclusion)

                Case BusinessRule.BusinessRuleType.Newborn
                    LoadMiscRules(rule, NewBorn)

                Case BusinessRule.BusinessRuleType.Provider
                    LoadMiscRules(rule, Provider)

            End Select
        Next

    End Sub

    Private Function ShowCriteriaEditorDialog(ByVal criter As Criteria, ByVal showRuleName As Boolean, ByVal showCriteriaStatement As Boolean) As System.Windows.Forms.DialogResult

        Dim criteriaEditorDialog As New CriteriaEditorDialog

        With criteriaEditorDialog
            .ShowRuleName = showRuleName
            .ShowCriteriaStatement = showCriteriaStatement
            .Criteria = criter
            Return .ShowDialog()
        End With

    End Function

#Region " DQ Rules "
    Private Sub LoadDQRules(ByVal rule As BusinessRule)
        Dim item As New ListViewItem

        With item
            .Tag = rule
            .Text = rule.Name
            .SubItems.Add(rule.Criteria.CriteriaStatementDisplay(True, False))
        End With
        Me.DQRulesListView.Items.Add(item)
    End Sub

    Private Sub RefreshDQRulesListView()
        Me.DQRulesListView.Items.Clear()

        For Each rule As BusinessRule In mModule.Survey.BusinessRules
            With rule
                If .RuleType = BusinessRule.BusinessRuleType.DQ AndAlso Not .NeedsDeleted Then _
                    LoadDQRules(rule)
            End With
        Next
    End Sub

#End Region

#Region " Misc Rules "
    Private Sub LoadMiscRulesRulename()
        ' 5 Misc rules are fixed at this point.

        Me.MiscRulesListView.Items.Clear()

        Dim item As New ListViewItem
        With item
            .Text = Provider
            .SubItems.Add("")
        End With
        Me.MiscRulesListView.Items.Add(item)

        item = New ListViewItem
        With item
            .Text = MinorExclusion
            .SubItems.Add("")
        End With
        Me.MiscRulesListView.Items.Add(item)

        item = New ListViewItem
        With item
            .Text = NewBorn
            .SubItems.Add("")
        End With
        Me.MiscRulesListView.Items.Add(item)

        item = New ListViewItem
        With item
            .Text = BadAddress
            .SubItems.Add("")
        End With
        Me.MiscRulesListView.Items.Add(item)

        item = New ListViewItem
        With item
            .Text = BadPhone
            .SubItems.Add("")
        End With
        Me.MiscRulesListView.Items.Add(item)
    End Sub

    Private Sub LoadMiscRules(ByVal rule As BusinessRule, ByVal name As String)
        Dim item As New ListViewItem
        Dim i As Integer = 0

        For i = 0 To Me.MiscRulesListView.Items.Count - 1
            With Me.MiscRulesListView.Items(i)
                If .Text = name Then
                    .Tag = rule
                    .SubItems(1).Text = rule.Criteria.CriteriaStatementDisplay(True, False)
                    Exit Sub
                End If
            End With
        Next
    End Sub

#End Region

#Region " Householding "
    Private Sub Householding()

        'Get the radio button checked
        Select Case mModule.Survey.HouseHoldingType
            Case HouseHoldingType.All
                AllHouseholdingToolStripButton_Click(Me, Nothing)

            Case HouseHoldingType.Minor
                MinorsOnlyHouseholdingToolStripButton_Click(Me, Nothing)

            Case HouseHoldingType.None
                NoHouseholdingToolStripButton_Click(Me, Nothing)

        End Select

        If Me.NoHouseholdingToolStripButton.Checked Then Exit Sub
        Me.LoadHouseholdingFields()

    End Sub

    Private Sub LoadHouseholdingFields()
        Me.AvailableFieldsListBox.Items.Clear()
        Me.SelectedFieldsListBox.Items.Clear()

        ' Get all tables for this study
        For Each table As StudyTable In StudyTable.GetAllStudyTables(mModule.Survey.StudyId)
            ' Use population table for householding rule.
            If UCase(table.Name) = "POPULATION" Then
                ' all columns in Population table for this survey.
                For Each column As StudyTableColumn In table.Columns
                    If IsHouseholdingField(column) Then
                        Me.SelectedFieldsListBox.Items.Add(New ListBoxItem(table, column)).ToString()
                    Else
                        Me.AvailableFieldsListBox.Items.Add(New ListBoxItem(table, column)).ToString()
                    End If
                Next
            End If
        Next
    End Sub

    Private Function IsHouseholdingField(ByVal column As StudyTableColumn) As Boolean
        Dim householding As Boolean = False

        For Each householdingColumn As StudyTableColumn In mModule.Survey.HouseHoldingFields
            If householdingColumn.Id = column.Id Then
                householding = True
                Exit For
            End If
        Next
        Return householding
    End Function

    Private Sub RefreshHouseholdingFields()
        Me.AvailableFieldsListBox.Items.Clear()
        Me.SelectedFieldsListBox.Items.Clear()

        ' Get all tables for this study
        For Each table As StudyTable In StudyTable.GetAllStudyTables(mModule.Survey.StudyId)
            ' Use population table for householding rule.
            If UCase(table.Name) = "POPULATION" Then
                ' all columns in Population table for this survey.
                For Each column As StudyTableColumn In table.Columns
                    Me.AvailableFieldsListBox.Items.Add(New ListBoxItem(table, column)).ToString()
                Next
            End If
        Next
    End Sub

    Private Sub AddToSelectedFields()

        While Me.AvailableFieldsListBox.SelectedIndices.Count > 0
            Me.SelectedFieldsListBox.Items.Add(Me.AvailableFieldsListBox.SelectedItems(0))
            Me.AvailableFieldsListBox.Items.RemoveAt(Me.AvailableFieldsListBox.SelectedIndices(0))
        End While

    End Sub

    Private Sub RemoveFromSelectedFields()

        While Me.SelectedFieldsListBox.SelectedIndices.Count > 0
            Me.AvailableFieldsListBox.Items.Add(Me.SelectedFieldsListBox.SelectedItems(0))
            Me.SelectedFieldsListBox.Items.RemoveAt(Me.SelectedFieldsListBox.SelectedIndices(0))
        End While

    End Sub
#End Region

    Private Function ValidRules() As Boolean

        ' Check if HouseHolding is checked but no selected fields
        If Not Me.NoHouseholdingToolStripButton.Checked AndAlso Me.SelectedFieldsListBox.Items.Count = 0 Then
            MessageBox.Show("You must select at least one field for householding!", "Householding Warning", MessageBoxButtons.OK, MessageBoxIcon.Information)
            Return False
        End If

        If Me.NoHouseholdingToolStripButton.Checked AndAlso Me.SelectedFieldsListBox.Items.Count > 0 Then
            MessageBox.Show("You must remove the householding field(s) or deselect no householding!", "Householding Warning", MessageBoxButtons.OK, MessageBoxIcon.Information)
            Return False
        End If

        Return True

    End Function

    Private Sub SaveBusinessRules()

        With mModule.Survey
            'Clear up the Householding fields assuming it exists.
            .HouseHoldingFields.Clear()

            'Get the householding type
            If Me.NoHouseholdingToolStripButton.Checked Then
                'If no householding then set the type and we are done
                .HouseHoldingType = HouseHoldingType.None
            Else
                If Me.AllHouseholdingToolStripButton.Checked Then
                    .HouseHoldingType = HouseHoldingType.All
                Else
                    .HouseHoldingType = HouseHoldingType.Minor
                End If

                'Add all the items in selected listbox to Householding fields.
                For Each item As ListBoxItem In Me.SelectedFieldsListBox.Items
                    .HouseHoldingFields.Add(item.Column)
                Next
            End If
        End With

    End Sub
#End Region

#Region " Subclass "
    ' To store both study tables and columns of selected survey in the list box.
    Private Class ListBoxItem
        Private mTable As StudyTable
        Private mColumn As StudyTableColumn

        Public Sub New(ByVal table As StudyTable, ByVal column As StudyTableColumn)
            mTable = table
            mColumn = column
        End Sub

        Public Property Column() As StudyTableColumn
            Get
                Return mColumn
            End Get
            Set(ByVal value As StudyTableColumn)
                mColumn = value
            End Set
        End Property

        Public Overrides Function ToString() As String
            Return mTable.Name.Trim & "." & mColumn.Name.Trim
        End Function
    End Class
#End Region
End Class

