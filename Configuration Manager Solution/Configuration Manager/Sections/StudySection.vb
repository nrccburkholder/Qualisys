Imports Nrc.Qualisys.Library

Public Class StudySection

#Region " Private Fields "

    Private mModule As StudyPropertiesModule
    Private mNavigator As ClientStudySurveyNavigator
    Private mEndConfigCallBack As EndConfigCallBackMethod

    Private Const DefaultDataStructureName As String = "<Default Data Structure>"
    Private Const DefaultDataStructureID As Integer = -1

#End Region

#Region " Constructors "

    Public Sub New(ByVal studyModule As StudyPropertiesModule, ByVal endConfigCallBack As EndConfigCallBackMethod, ByVal navCtrl As ClientStudySurveyNavigator)

        ' This call is required by the Windows Form Designer.
        InitializeComponent()

        ' Add any initialization after the InitializeComponent() call.
        mModule = studyModule
        mNavigator = navCtrl
        mEndConfigCallBack = endConfigCallBack

    End Sub

#End Region

#Region " Event Handlers "

    Private Sub StudySection_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        DisplayData()
        StudyNameTextBox.Focus()

    End Sub

    Private Sub OKButton_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles OKButton.Click

        If (Not CheckValues()) Then Exit Sub

        SaveValues()

        mEndConfigCallBack(ConfigResultActions.StudyRefresh, Nothing)
        mEndConfigCallBack = Nothing

    End Sub

    Private Sub CancelButton_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles CancelButton.Click

        mEndConfigCallBack(ConfigResultActions.None, Nothing)
        mEndConfigCallBack = Nothing

    End Sub

    Private Sub AddAllButton_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles AddAllButton.Click

        For x As Integer = 0 To AvailableAssociateListBox.Items.Count - 1
            AvailableAssociateListBox.SetSelected(x, True)
        Next
        AddSelectedEmployee()

    End Sub

    Private Sub AddButton_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles AddButton.Click

        AddSelectedEmployee()

    End Sub

    Private Sub RemoveAllButton_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles RemoveAllButton.Click

        Try
            Windows.Forms.Cursor.Current = Cursors.WaitCursor
            For x As Integer = 0 To AuthorizedAssociateListBox.Items.Count - 1
                AuthorizedAssociateListBox.SetSelected(x, True)
            Next
            RemoveSelectedEmployee()

        Finally
            Windows.Forms.Cursor.Current = Cursors.Default

        End Try

    End Sub

    Private Sub RemoveButton_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles RemoveButton.Click

        RemoveSelectedEmployee()

    End Sub

    Private Sub AuthorizedAssociatesListBox_DoubleClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles AuthorizedAssociateListBox.DoubleClick

        RemoveSelectedEmployee()

    End Sub

    Private Sub NRCAssociatesListBox_DoubleClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles AvailableAssociateListBox.DoubleClick

        AddSelectedEmployee()

    End Sub

    Private Sub CopyDataStructureBrowseButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles CopyDataStructureBrowseButton.Click

        Using copyDialog As New CopyDataStructureDialog(mNavigator.ClientFilterList.SelectedIndex, mNavigator.ShowAllTSButton.Checked, mNavigator.ShowClientGroupsTSButton.Checked, CInt(CopyDataStructureTextBox.Tag))
            With copyDialog
                If .ShowDialog(Me) = DialogResult.OK Then
                    If .SelectedStudy IsNot Nothing Then
                        CopyDataStructureTextBox.Text = String.Format("{0}: {1}", .SelectedStudy.Client.DisplayLabel, .SelectedStudy.DisplayLabel)
                        CopyDataStructureTextBox.Tag = .SelectedStudy.Id
                    Else
                        CopyDataStructureTextBox.Text = DefaultDataStructureName
                        CopyDataStructureTextBox.Tag = DefaultDataStructureID
                    End If
                End If
            End With
        End Using

    End Sub

#End Region

#Region " Private Methods "

    Private Sub DisplayData()

        'Information bar
        InformationBar.Information = mModule.Information

        With mModule.Study
            DateCreatedTextBox.Text = .CreateDate.ToShortDateString
            StudyNameTextBox.Text = .Name
            StudyDescriptionTextBox.Text = .Description
            UseAddressCleaningCheckBox.Checked = .UseAddressCleaning
            UseProperCaseCheckBox.Checked = .UseProperCase
            InActivateCheckBox.Checked = Not .IsActive
            UseAutoSample.Checked = .IsAutoSample
            UseAutoSample.Enabled = (Not IsNothing(.Client.ClientGroup)) AndAlso (.Client.ClientGroup.Name.ToUpper() = "OCS")
        End With


        NRCEmployeeBindingSource.DataSource = Employee.GetAllStudyUnAuthorized(mModule.Study.Id)
        With AvailableAssociateListBox
            .DataSource = NRCEmployeeBindingSource
            .DisplayMember = "FullName"
            .ValueMember = "Id"
        End With

        StudyEmployeeBindingSource.DataSource = mModule.Study.StudyEmployees
        With AuthorizedAssociateListBox
            .DataSource = StudyEmployeeBindingSource
            .DisplayMember = "EmployeeName"
            .ValueMember = "EMPLOYEEId"
        End With

        With StudyOwnerComboBox
            .DataSource = StudyOwnerBindingSource
            .DisplayMember = "EmployeeName"
            .ValueMember = "EMPLOYEEId"
            .SelectedValue = mModule.Study.AccountDirectorEmployeeId
        End With

        With CopyDataStructureTextBox
            .Text = DefaultDataStructureName
            .Tag = DefaultDataStructureID
        End With

        With CopyDataStructureGroupBox
            If TypeOf mModule Is NewStudyModule AndAlso CurrentUser.IsCopyDataStructure Then
                .Visible = True
            Else
                .Visible = False
            End If
        End With

        'Disable all the fields when viewing properties
        WorkAreaPanel.Enabled = mModule.IsEditable
        OKButton.Enabled = mModule.IsEditable

    End Sub

    Private Sub AddSelectedEmployee()

        Try
            Windows.Forms.Cursor.Current = Cursors.WaitCursor

            Dim list As New List(Of Employee)
            For Each item As Employee In AvailableAssociateListBox.SelectedItems
                list.Add(item)
            Next

            For Each item As Employee In list
                Dim studyEmployee As STUDY_EMPLOYEE = STUDY_EMPLOYEE.NewSTUDY_EMPLOYEE
                Dim privateInterface As ISTUDY_EMPLOYEE = studyEmployee
                studyEmployee.BeginPopulate()
                privateInterface.EMPLOYEEId = item.Id
                privateInterface.STUDYId = mModule.Study.Id
                studyEmployee.EmployeeName = item.FullName
                studyEmployee.EndPopulate()
                Dim orgValue As Object = StudyOwnerComboBox.SelectedValue
                If orgValue Is Nothing Then orgValue = -1
                StudyEmployeeBindingSource.Add(studyEmployee)
                StudyOwnerComboBox.SelectedValue = orgValue

                NRCEmployeeBindingSource.Remove(item)
            Next

        Finally
            Windows.Forms.Cursor.Current = Cursors.Default

        End Try

    End Sub

    Private Sub RemoveSelectedEmployee()

        Try
            Windows.Forms.Cursor.Current = Cursors.WaitCursor

            Dim list As New List(Of STUDY_EMPLOYEE)
            For Each item As STUDY_EMPLOYEE In AuthorizedAssociateListBox.SelectedItems
                list.Add(item)
            Next

            For Each item As STUDY_EMPLOYEE In list
                Dim employee As Library.Employee = Library.Employee.NewEmployee
                Dim privateInterface As IEmployee = employee
                privateInterface.Id = item.EMPLOYEEId
                employee.FirstName = item.EmployeeName
                NRCEmployeeBindingSource.Add(employee)

                StudyEmployeeBindingSource.Remove(item)
            Next

        Finally
            Windows.Forms.Cursor.Current = Cursors.Default

        End Try

    End Sub

    Private Sub SaveValues()

        With mModule.Study
            .Name = StudyNameTextBox.Text
            .Description = StudyDescriptionTextBox.Text
            .UseAddressCleaning = UseAddressCleaningCheckBox.Checked
            .UseProperCase = UseProperCaseCheckBox.Checked
            .IsActive = Not InActivateCheckBox.Checked
            .StudyEmployees = DirectCast(StudyEmployeeBindingSource.DataSource, STUDY_EMPLOYEECollection)
            .AccountDirectorEmployeeId = CInt(StudyOwnerComboBox.SelectedValue)
            .CopyDataStructureFromStudyID = CInt(CopyDataStructureTextBox.Tag)
            .IsAutoSample = UseAutoSample.Checked
        End With

    End Sub

    Private Function CheckValues() As Boolean

        Dim message As String = String.Empty

        If StudyNameTextBox.Text.Trim = String.Empty Then
            message += String.Concat(vbTab, "Study Name is required!", vbCrLf)
        End If
        If StudyOwnerComboBox.SelectedIndex < 0 Then
            message += String.Concat(vbTab, "Study Owner is required!", vbCrLf)
        End If

        If message <> String.Empty Then
            MessageBox.Show(String.Concat("Unable to save study. Please correct the following error(s):", vbCrLf, message), "Save Study", MessageBoxButtons.OK, MessageBoxIcon.Error)
            Return False
        Else
            Return True
        End If

    End Function

#End Region

End Class
