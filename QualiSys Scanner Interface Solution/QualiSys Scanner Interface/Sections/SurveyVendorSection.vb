Imports Nrc.QualiSys.Library
Imports Nrc.QualiSys.Scanning.Library
Imports DevExpress.XtraGrid.Views.Grid
Imports Nrc.Framework.BusinessLogic.Configuration

Public Class SurveyVendorSection

#Region " Private Members "

    Private mSelectedClient As Navigation.ClientNavNode
    Private mSelectedStudy As Navigation.StudyNavNode
    Private mSelectedSurvey As Navigation.SurveyNavNode
    Private mLoading As Boolean

    Private WithEvents mNavControl As SurveyVendorNavigator

#End Region

#Region " Public Properties "

    Public ReadOnly Property SelectedClient() As Navigation.ClientNavNode
        Get
            Return mSelectedClient
        End Get
    End Property

    Public ReadOnly Property SelectedStudy() As Navigation.StudyNavNode
        Get
            Return mSelectedStudy
        End Get
    End Property

    Public ReadOnly Property SelectedSurvey() As Navigation.SurveyNavNode
        Get
            Return mSelectedSurvey
        End Get
    End Property

#End Region

#Region " Base Class Overrides"

    Public Overrides Sub RegisterNavControl(ByVal navCtrl As Navigator)

        mNavControl = DirectCast(navCtrl, SurveyVendorNavigator)

    End Sub

    Public Overrides Function AllowInactivate() As Boolean

        Dim dirtyMeths As String = String.Empty

        For cnt As Integer = 0 To MethBindingSource.Count - 1
            Dim meth As Methodology = TryCast(MethBindingSource.Item(cnt), Methodology)
            If meth Is Nothing Then Return True

            If meth.IsDirty Then
                If dirtyMeths = String.Empty Then
                    dirtyMeths = meth.Name
                Else
                    dirtyMeths = String.Concat(dirtyMeths, ", ", meth.Name)
                End If
            End If
        Next

        If dirtyMeths <> String.Empty Then
            MessageBox.Show(String.Format("Methodology ( {0} ) have been modified.  Please apply or cancel changes.", dirtyMeths), "Methodology Modified", MessageBoxButtons.OK, MessageBoxIcon.Error)
            Return False
        End If

        Return True

    End Function

#End Region

#Region " Navigator Events "

    Private Sub mNavControl_SelectedNodeChanged(ByVal sender As Object, ByVal e As SelectedNodeChangedEventArgs) Handles mNavControl.SelectedNodeChanged

        Windows.Forms.Cursor.Current = Cursors.WaitCursor

        mLoading = True

        Dim node As Navigation.NavigationNode = DirectCast(e.Node.Tag, Navigation.NavigationNode)

        Select Case node.NodeType
            'Case Navigation.NavigationNodeType.Client
            '    Me.mSelectedClient = DirectCast(node, Navigation.Client)
            '    Me.mSelectedStudy = Nothing
            '    Me.mSelectedSurvey = Nothing

            'Case Navigation.NavigationNodeType.Study
            '    Me.mSelectedStudy = DirectCast(node, Navigation.Study)
            '    Me.mSelectedClient = mSelectedStudy.Client
            '    Me.mSelectedSurvey = Nothing

            Case Navigation.NavigationNodeType.Survey
                mSelectedSurvey = DirectCast(node, Navigation.SurveyNavNode)
                mSelectedStudy = mSelectedSurvey.Study
                mSelectedClient = mSelectedStudy.Client

        End Select

        MethSectionPanel.Caption = String.Format("Survey Methodologies - {0} ({1}): {2} ({3}): {4} ({5})", mSelectedClient.Name, mSelectedClient.Id, mSelectedStudy.Name, mSelectedStudy.Id, SelectedSurvey.Name, SelectedSurvey.Id)
        PopulateMethType()
        PopulateCoverLetter()
        PopulateLanguage()
        PopulateVendors()
        PopulateEmailBlastOptions()
        If VendorSurveyBindingSource.List.Count <= 0 Then
            PopulateVoviciSurveyList()
        End If
        PopulateMethology()
        SetMethToolbar()
        Windows.Forms.Cursor.Current = Cursors.Default

    End Sub

    Private Sub mNavControl_SelectedNodeChanging(ByVal sender As Object, ByVal e As SelectedNodeChangingEventArgs) Handles mNavControl.SelectedNodeChanging

        e.Cancel = Not AllowInactivate()

    End Sub

#End Region

#Region "Private Methods"

#Region "Private Methods - Methodology"

    Private Sub PopulateMethology()

        'Populate the methology grid
        mLoading = True
        Dim meths As System.Collections.ObjectModel.Collection(Of Methodology) = Methodology.GetBySurveyId(SelectedSurvey.Id)
        MethBindingSource.DataSource = meths
        mLoading = False

        MethGridView.MoveLast()
        MethGridView.MakeRowVisible(MethGridView.FocusedRowHandle, False)
        PopulateMethSteps()
        SetMethToolbar()

    End Sub

    Private Sub SetMethToolbar()

        Dim missingVendor As Boolean = False
        SplitContainer1.Panel1.Enabled = True
        SplitContainer1.Panel2.Enabled = False
        SplitContainer2.Panel1.Enabled = False
        SplitContainer2.Panel2.Enabled = False

        Dim meth As Methodology = TryCast(MethBindingSource.Current, Methodology)
        If meth Is Nothing Then
            MethEditTSButton.Enabled = False
            ApplyButton.Enabled = False
            CancelButton.Enabled = False
        Else
            If meth.MethodologySteps.Count > 0 Then
                For Each methStep As MethodologyStep In meth.MethodologySteps
                    'if non-mailstep with no vendor value, enable buttons
                    If methStep.StepMethodId <> 0 AndAlso Not methStep.OrgVendorID.HasValue Then
                        missingVendor = True
                        Exit For
                    End If
                Next

                MethEditTSButton.Enabled = (meth.AllowEdit OrElse missingVendor)
                ApplyButton.Enabled = (meth.AllowEdit OrElse missingVendor)
                CancelButton.Enabled = (meth.AllowEdit OrElse missingVendor)
            Else
                MethEditTSButton.Enabled = False
                ApplyButton.Enabled = False
                CancelButton.Enabled = False
            End If
        End If

    End Sub

#End Region

#Region "Private Methods - Methodology Steps"

    Private Sub PopulateMethSteps()

        'Populate the methology steps
        If MethGridView.RowCount > 0 Then
            Dim meth As Methodology = DirectCast(MethBindingSource.Current, Methodology)
            MethStepBindingSource.DataSource = meth.MethodologySteps
            MethStepGridView.MoveFirst()
        Else
            MethStepBindingSource.DataSource = Nothing
            MethStepGridView.RefreshData()
        End If

        Dim methStep As MethodologyStep = TryCast(MethStepBindingSource.Current, MethodologyStep)
        DisplayMethStepProps(methStep)

    End Sub

    Private Sub PopulateMethType()

        'Populate the standard methology types
        Dim meths As System.Collections.ObjectModel.Collection(Of StandardMethodology) = StandardMethodology.GetBySurveyType(SelectedSurvey.SurveyType, SelectedSurvey.SurveySubTypes)
        StandardMethBindingSource.DataSource = meths

    End Sub

    Private Sub PopulateCoverLetter()

        Dim letters As System.Collections.ObjectModel.Collection(Of CoverLetter) = CoverLetter.GetBySurveyId(SelectedSurvey.Id)
        CoverLetterBindingSource.DataSource = letters

    End Sub

    Private Sub PopulateLanguage()

        Dim languages As System.Collections.ObjectModel.Collection(Of Language) = Language.GetLanguagesAvailableForSurvey(SelectedSurvey.Id)
        LanguageBindingSource.DataSource = languages

    End Sub

    Private Sub PopulateVendors()

        Dim vendors As VendorCollection = Vendor.GetAll
        VendorBindingSource.DataSource = vendors

    End Sub

    Private Sub PopulateVoviciSurveyList()

        Dim projectData As New VoviciProjectData
        'TODO: Login based on vendorId: 3->US; 7->CA(nada)
        projectData.Login()
        Dim pattern As String = AppConfig.Params("QSIVoviciSurveyPattern").StringValue
        VendorSurveyBindingSource.DataSource = projectData.GetSurveyList(String.Format("Name Like '{0}'", pattern))

    End Sub

    ''' <summary>
    ''' Validating the methodology step.  Checking to see if only the Vendor properties are valid.
    ''' Not the entire object because only the vendor properties are being edited on this screen.
    ''' </summary>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Private Function ValidMethSteps() As Boolean

        For x As Integer = 0 To MethStepGridView.RowCount - 1
            Dim methStep As MethodologyStep = TryCast(MethStepBindingSource.Item(x), MethodologyStep)
            If methStep IsNot Nothing Then
                If Not methStep.IsValid Then
                    For Each rule As Framework.BusinessLogic.Validation.BrokenRule In methStep.BrokenRulesCollection
                        If rule.Property = "VendorID" OrElse rule.Property = "VendorSurveyID" Then
                            Return False
                        End If
                    Next
                End If
            End If
        Next

        Return True

    End Function

#End Region
 
#Region "Private Methods - Methodology Step Properties"

    Private Sub DisplayMethStepProps(ByVal methStep As MethodologyStep)

        MethodologyPropsPhonePanel.Visible = False
        MethodologyPropsWebPanel.Visible = False
        MethodologyPropsIVRPanel.Visible = False
        If methStep Is Nothing Then Exit Sub

        Select Case methStep.StepMethodId
            Case MailingStepMethodCodes.Phone
                SplitContainer1.Panel2.Enabled = True
                MethodologyPropsPhonePanel.Visible = True
                PopulateMethProps(methStep)

            Case MailingStepMethodCodes.Web, MailingStepMethodCodes.MailWeb, MailingStepMethodCodes.LetterWeb
                SplitContainer1.Panel2.Enabled = True
                MethodologyPropsWebPanel.Visible = True
                PopulateMethProps(methStep)
                PopulateEmailBlast(methStep)

            Case MailingStepMethodCodes.IVR
                SplitContainer1.Panel2.Enabled = True
                MethodologyPropsIVRPanel.Visible = True
                PopulateMethProps(methStep)

        End Select

    End Sub

    Private Sub PopulateEmailBlast(ByVal methStep As MethodologyStep)

        EmailBlastBindingSource.DataSource = methStep.EmailBlastList

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

        'Initialize stop at text box
        PhoneQuotasStopReturnsTextBox.Enabled = PhoneQuotasStopReturnsRadioButton.Checked
        WebQuotasStopReturnsTextBox.Enabled = WebQuotasStopReturnsRadioButton.Checked

    End Sub

    Private Sub PopulateEmailBlastOptions()

        Dim blastopts As EmailBlastOptionCollection = EmailBlastOption.GetAll
        EmailBlastOptionBindingSource.DataSource = blastopts

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

    End Sub

#End Region

#End Region

#Region "Grid Events"

#Region "Methodology Grid Events"

    Private Sub MethGridView_FocusedRowChanged(ByVal sender As Object, ByVal e As DevExpress.XtraGrid.Views.Base.FocusedRowChangedEventArgs) Handles MethGridView.FocusedRowChanged

        If Not mLoading Then
            PopulateMethSteps()
            SetMethToolbar()
        End If

    End Sub

#End Region

#Region "Methodology Step Grid Events"

    Private Sub MethStepGridView_CellValueChanged(ByVal sender As Object, ByVal e As DevExpress.XtraGrid.Views.Base.CellValueChangedEventArgs) Handles MethStepGridView.CellValueChanged

        Dim view As GridView = TryCast(sender, GridView)
        If view.FocusedColumn.FieldName = "VendorID" Then
            'if not vovici and survery name has a value, clear the value in the survey name
            If CType(view.GetRowCellValue(view.FocusedRowHandle, colVendorID), Integer) <> AppConfig.Params("QSIVerint-US-VendorID").IntegerValue AndAlso _
               CType(view.GetRowCellValue(view.FocusedRowHandle, colVendorID), Integer) <> AppConfig.Params("QSIVerint-CA-VendorID").IntegerValue AndAlso _
               CType(view.GetRowCellValue(view.FocusedRowHandle, colVendorSurveyID), Integer) > 0 Then
                view.SetRowCellValue(view.FocusedRowHandle, colVendorSurveyID, -1)
            End If
        ElseIf view.FocusedColumn.FieldName = "VendorSurveyID" Then
            If CType(view.GetRowCellValue(view.FocusedRowHandle, colVendorSurveyID), Integer) > 0 Then
                Dim methStep As MethodologyStep = DirectCast(MethStepBindingSource.Current, MethodologyStep)
                methStep.VendorVoviciDetail.VoviciSurveyName = view.GetRowCellDisplayText(view.FocusedRowHandle, colVendorSurveyID)
            End If
        End If

    End Sub

    Private Sub MethStepGridView_FocusedRowChanged(ByVal sender As Object, ByVal e As DevExpress.XtraGrid.Views.Base.FocusedRowChangedEventArgs) Handles MethStepGridView.FocusedRowChanged

        If Not mLoading Then
            If MethStepGridView.SelectedRowsCount > 0 Then
                Dim methStep As MethodologyStep = DirectCast(MethStepBindingSource.Current, MethodologyStep)
                DisplayMethStepProps(methStep)
            Else
                MethodologyPropsPhonePanel.Visible = False
                MethodologyPropsWebPanel.Visible = False
                MethodologyPropsIVRPanel.Visible = False
                ClearMethPropsBindings()
            End If
        End If

    End Sub

    Private Sub MethStepGridView_ShownEditor(ByVal sender As Object, ByVal e As System.EventArgs) Handles MethStepGridView.ShownEditor

        Dim view As GridView = TryCast(sender, GridView)

        'if non-mail step, enable vendor selection
        If CType(view.GetRowCellValue(view.FocusedRowHandle, colStepMethodId), Integer) <> 0 AndAlso view.FocusedColumn.FieldName = "VendorID" Then
            view.ActiveEditor.Properties.ReadOnly = False
        End If

        'if vovici, allow them to enter a survey id
        If (CType(view.GetRowCellValue(view.FocusedRowHandle, colVendorID), Integer) = AppConfig.Params("QSIVerint-US-VendorID").IntegerValue) Or _
           (CType(view.GetRowCellValue(view.FocusedRowHandle, colVendorID), Integer) = AppConfig.Params("QSIVerint-CA-VendorID").IntegerValue) AndAlso _
           view.FocusedColumn.FieldName = "VendorSurveyID" Then
            view.ActiveEditor.Properties.ReadOnly = False
        End If

    End Sub

    Private Sub VendorGridLookUpEdit_Closed(ByVal sender As Object, ByVal e As DevExpress.XtraEditors.Controls.ClosedEventArgs) Handles VendorGridLookUpEdit.Closed

        'Using send keys to get a quick refresh of the column
        SendKeys.Send("{TAB}")
        SendKeys.Send("+{TAB}")

    End Sub

    Private Sub VendorSurveyLookUpEdit_Closed(ByVal sender As Object, ByVal e As DevExpress.XtraEditors.Controls.ClosedEventArgs) Handles VendorSurveyLookUpEdit.Closed

        'Using send keys to get a quick refresh of the column
        SendKeys.Send("{TAB}")
        SendKeys.Send("+{TAB}")

    End Sub

#End Region

#End Region

#Region "Private Events"

#Region "Private Events - Methodology"

    Private Sub MethEditTSButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MethEditTSButton.Click

        SplitContainer1.Panel1.Enabled = False
        SplitContainer1.Panel2.Enabled = True
        SplitContainer2.Panel1.Enabled = True
        SplitContainer2.Panel2.Enabled = True
        ApplyButton.Enabled = False
        CancelButton.Enabled = False

        For x As Integer = 0 To MethStepGridView.RowCount - 1
            Dim methStep As MethodologyStep = DirectCast(MethStepBindingSource.Item(x), MethodologyStep)
            methStep.AddVendorValidation()
        Next
        MethStepGridView.RefreshData()

    End Sub

#End Region

#Region "Private Events - Methodology Steps"

    Private Sub MethStepApplyTSButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MethStepApplyTSButton.Click

        'Commit any uncommitted changes
        If MethStepGridView.IsEditing Then
            If MethStepGridView.ValidateEditor Then
                MethStepGridView.CloseEditor()
            End If
        End If

        If Not ValidMethSteps() Then
            MessageBox.Show(String.Format("One or more errors exist!{0}{0}Please correct the errors and try again.", vbCrLf), "Methodology Step Validation Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            Exit Sub
        End If

        SetMethToolbar()

    End Sub

    Private Sub MethStepUndoTSButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MethStepUndoTSButton.Click

        'Commit any uncommitted changes
        If MethStepGridView.IsEditing Then
            If MethStepGridView.ValidateEditor Then
                MethStepGridView.CloseEditor()
            End If
        End If

        Dim meth As Methodology = DirectCast(MethBindingSource.Current, Methodology)
        meth.RefreshSteps()
        PopulateMethSteps()
        SetMethToolbar()

    End Sub

#End Region

#Region "Private Events - Main"

    Private Sub ApplyButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ApplyButton.Click

        Windows.Forms.Cursor.Current = Cursors.WaitCursor

        For x As Integer = 0 To MethGridView.RowCount - 1
            Dim meth As Methodology = DirectCast(MethBindingSource.Item(x), Methodology)
            'If this Methodology is dirty then save it
            If meth.IsDirty Or meth.IsNew Then meth.UpdateVendor()
        Next

        PopulateMethology()

        Windows.Forms.Cursor.Current = Cursors.Default

    End Sub

    Private Sub CancelButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles CancelButton.Click

        Windows.Forms.Cursor.Current = Cursors.WaitCursor
        PopulateMethology()
        Windows.Forms.Cursor.Current = Cursors.Default

    End Sub

#End Region

#End Region

End Class
