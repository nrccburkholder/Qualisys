Imports Nrc.SurveyPoint.Library
Imports Nrc.Framework.BusinessLogic.Validation

Public Class FileTemplateSection
#Region " Fields "
    Friend WithEvents mNavigator As FileTemplateNavigator
    Private mFileTemplate As Nrc.SurveyPoint.Library.SPTI_FileTemplate
    Private mEncodingTypes As Nrc.SurveyPoint.Library.SPTI_EncodingTypeCollection
    Private mDataTypes As Nrc.SurveyPoint.Library.SPTI_DataTypeCollection
    Private mFormatingRules As Nrc.SurveyPoint.Library.SPTI_FormattingRuleCollection
    Private mDelimeters As Nrc.SurveyPoint.Library.SPTI_DelimeterCollection
#End Region
#Region " Overrides "
    Public Overrides Sub RegisterNavControl(ByVal navCtrl As Navigator)
        Me.mNavigator = DirectCast(navCtrl, FileTemplateNavigator)
    End Sub
#End Region
#Region " Constructors "
    ''' <summary>Form constructor.</summary>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Sub New()

        ' This call is required by the Windows Form Designer.
        InitializeComponent()

        ' Add any initialization after the InitializeComponent() call.
        mEncodingTypes = Nrc.SurveyPoint.Library.SPTI_EncodingType.GetAll
        mFormatingRules = Nrc.SurveyPoint.Library.SPTI_FormattingRule.GetAll
        Me.mDataTypes = SPTI_DataType.GetAll
        Me.cboDataTypes.DataSource = Me.mDataTypes
        Me.cboDataTypes.DisplayMember = "Name"
        Me.cboFormatingRules.DataSource = Me.mFormatingRules
        Me.cboFormatingRules.DisplayMember = "Name"
        Me.cboEncodingType.DataSource = Me.mEncodingTypes
        Me.cboEncodingType.DisplayMember = "Name"
        Me.mDelimeters = SPTI_Delimeter.GetAll
        Me.cboDelimeterType.DataSource = Me.mDelimeters
        Me.cboDelimeterType.DisplayMember = "Name"
    End Sub
#End Region
#Region " Event Handlers "

    ''' <summary>Handles the event when user selects a file template in the navigator.</summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub mNavigator_FileTemplateSelected(ByVal sender As Object, ByVal e As FileTemplateSelectedEventArgs) Handles mNavigator.FileTemplateUserAction
        Dim fileTemplateID As Integer = e.FileTemplateID

        If e.FileTemplateAction = FileTemplateActions.Selected Then
            If fileTemplateID = 0 Then 'New
                Me.mFileTemplate = Nrc.SurveyPoint.Library.SPTI_FileTemplate.NewSPTI_FileTemplate
            Else
                Me.mFileTemplate = Nrc.SurveyPoint.Library.SPTI_FileTemplate.Get(fileTemplateID)
            End If
            LoadScreen()
        End If
    End Sub

    ''' <summary>Edits the selected columns.</summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub cmdEditColumn_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdEditColumn.Click
        'Dim colDef As SPTI_ColumnDefinition = SPTI_ColumnDefinition.NewSPTI_ColumnDefinition(Me.txtColumnName.Text, DirectCast(Me.cboDataTypes.SelectedItem, SPTI_DataType).DateTypeID)
        Dim oldCol As SPTI_ColumnDefinition
        Dim rowHandle As Integer = 0
        For Each i As Integer In Me.grdColumnsView.GetSelectedRows
            rowHandle = i
        Next
        oldCol = TryCast(Me.grdColumns.DefaultView.GetRow(rowHandle), SPTI_ColumnDefinition)
        oldCol.Name = Me.txtColumnName.Text
        oldCol.DateTypeID = DirectCast(Me.cboDataTypes.SelectedItem, SPTI_DataType).DateTypeID
        oldCol.FormatingRuleID = DirectCast(Me.cboFormatingRules.SelectedItem, SPTI_FormattingRule).FormatingRuleID
        oldCol.FixedStringLength = Val(Me.txtFixedLengthStringLength.Text)
        'oldCol = TryCast(Me.bsColumnDefinitions.Current, SPTI_FileTemplateCols)
        'If Not oldCol Is Nothing AndAlso colDef.IsValid Then
        '    colDef.Save()
        '    oldCol.ColumnDef.Delete()
        '    oldCol.ColumnDef = colDef
        'Else
        '    Dim dlg As ValidationErrorsDialog = New ValidationErrorsDialog(colDef.BrokenRulesCollection)
        '    dlg.Show()
        'End If
        Me.grdColumns.DataSource = bsColumnDefinitions
        Me.grdColumnsView.RefreshData()
        Me.grdColumnsView.SelectRow(rowHandle)
        Me.txtColumnName.SelectAll()
    End Sub
    ''' <summary>Removes the selected column from the file template column collection.</summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub cmdRemoveColumn_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdRemoveColumn.Click
        Dim oldCol As SPTI_ColumnDefinition
        Dim rowHandle As Integer = 0
        For Each i As Integer In Me.grdColumnsView.GetSelectedRows
            rowHandle = i
        Next
        oldCol = TryCast(Me.grdColumns.DefaultView.GetRow(rowHandle), SPTI_ColumnDefinition)
        If Not oldCol Is Nothing Then
            'oldCol.Delete()
            Me.mFileTemplate.ColumnDefinitions.RemoveColumnDef(oldCol)
            Me.mFileTemplate.ColumnDefinitions.SynchronizeOrdinals()
            'oldCol.ColumnDef.Delete()
            'Me.mFileTemplate.FileTemplateCols.Remove(oldCol)
            Me.grdColumns.DataSource = bsColumnDefinitions
            Me.grdColumnsView.RefreshData()
        End If
        Me.txtColumnName.SelectAll()
    End Sub
    ''' <summary>Adds a new column to the file template col collection by copying the selected column.</summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub cmdCopyColumn_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdCopyColumn.Click
        Dim oldCol As SPTI_ColumnDefinition
        Dim rowHandle As Integer = 0
        For Each i As Integer In Me.grdColumnsView.GetSelectedRows
            rowHandle = i
        Next
        oldCol = TryCast(Me.grdColumns.DefaultView.GetRow(rowHandle), SPTI_ColumnDefinition)
        If Not oldCol Is Nothing Then
            'Dim newcol As SPTI_ColumnDefinition = SPTI_ColumnDefinition.NewSPTI_ColumnDefinition(oldCol.ColumnDefName, oldCol.ColumnDef.DateTypeID)
            'newcol.Save()
            Dim newCol As SPTI_ColumnDefinition = SPTI_ColumnDefinition.NewSPTI_ColumnDefinition(oldCol.FileTemplateID, oldCol.Name, Me.grdColumnsView.RowCount + 1, oldCol.FixedStringLength, oldCol.DateTypeID, DirectCast(Me.cboFormatingRules.SelectedItem, SPTI_FormattingRule).FormatingRuleID)
            '.NewSPTI_FileTemplateCols(Me.mFileTemplate.FileTemplateID, newCol.ColumnDefID, Me.grdColumnsView.RowCount + 1)
            Me.mFileTemplate.ColumnDefinitions.Add(newCol)
            Me.grdColumns.DataSource = bsColumnDefinitions
        End If
    End Sub
    ''' <summary>Adds a column to the file template col collection.</summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub cmdAddColumn_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdAddColumn.Click
        Dim colDef As SPTI_ColumnDefinition = SPTI_ColumnDefinition.NewSPTI_ColumnDefinition(Me.mFileTemplate.FileTemplateID, Me.txtColumnName.Text, Me.grdColumns.DefaultView.RowCount + 1, Val(Me.txtFixedLengthStringLength.Text), DirectCast(Me.cboDataTypes.SelectedItem, SPTI_DataType).DateTypeID, DirectCast(Me.cboFormatingRules.SelectedItem, SPTI_FormattingRule).FormatingRuleID)
        Me.mFileTemplate.ColumnDefinitions.Add(colDef)
        Me.bsColumnDefinitions.DataSource = Me.mFileTemplate.ColumnDefinitions        
        Me.txtColumnName.SelectAll()
    End Sub
    ''' <summary>refreshes the data grids when you switch between tabs.</summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub tabColumnDefinitions_Enter(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles tabColumnDefinitions.Enter
        Me.bsColumnDefinitions.DataSource = Me.mFileTemplate.ColumnDefinitions
    End Sub
    ''' <summary>On load events binds serveral controls to business objects.</summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub FileTemplateSection_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        
    End Sub
    ''' <summary>Takes the selected col in the grid and ties it to the update controls.</summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub bsColumnDefinitions_CurrentChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles bsColumnDefinitions.CurrentChanged
        Dim col As SPTI_ColumnDefinition
        Dim bindSource As System.Windows.Forms.BindingSource
        bindSource = TryCast(sender, System.Windows.Forms.BindingSource)
        col = TryCast(bindSource.Current, SPTI_ColumnDefinition)
        If Not col Is Nothing Then
            SetColInputs(col)
        End If
    End Sub
    ''' <summary>Changes a columns orindal, moving it up in the grid.</summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub cmdMoveUp_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdMoveUp.Click
        Dim oldCol As SPTI_ColumnDefinition
        Dim rowHandle As Integer = 0
        For Each i As Integer In Me.grdColumnsView.GetSelectedRows
            rowHandle = i
        Next
        oldCol = TryCast(Me.grdColumns.DefaultView.GetRow(rowHandle), SPTI_ColumnDefinition)
        'Dim bsIndex As Integer = Me.bsColumnDefinitions.Position
        'Me.grdColumnsView.SelectRow(rowHandle)
        If Not oldCol Is Nothing Then
            Me.mFileTemplate.ColumnDefinitions.ChangeOrdinal(oldCol.Ordinal, OrdinalDirection.MoveUp)
            Me.grdColumns.DataSource = bsColumnDefinitions
            Me.grdColumnsView.SelectRow(Me.grdColumnsView.GetRowHandle(bsColumnDefinitions.IndexOf(oldCol)))
        End If

        'Me.grdColumnsView.RefreshData()
        'Me.grdColumnsView.SelectRow(rowHandle)
        'Me.grdColumnsView.Columns.View.BeginSort()
        'Me.grdColumnsView.Columns.View.EndSort()
        'Dim newRowHandle As Integer = Me.grdColumnsView.GetRowHandle(bsIndex)
        'Me.grdColumnsView.SelectRow(newRowHandle)
    End Sub
    ''' <summary>Changes a columns ordinal, moving it down in the grid.</summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub cmdMoveDown_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdMoveDown.Click
        Dim oldCol As SPTI_ColumnDefinition
        Dim rowHandle As Integer = 0
        For Each i As Integer In Me.grdColumnsView.GetSelectedRows
            rowHandle = i
        Next
        oldCol = TryCast(Me.grdColumns.DefaultView.GetRow(rowHandle), SPTI_ColumnDefinition)
        If Not oldCol Is Nothing Then
            Me.mFileTemplate.ColumnDefinitions.ChangeOrdinal(oldCol.Ordinal, OrdinalDirection.MoveDown)
            Me.grdColumns.DataSource = bsColumnDefinitions
            Me.grdColumnsView.SelectRow(Me.grdColumnsView.GetRowHandle(bsColumnDefinitions.IndexOf(oldCol)))
        End If
    End Sub
    ''' <summary>Clears any input values and gets file template data from the data store.</summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub cmdCancel_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdCancel.Click
        If MessageBox.Show("Are you sure you with to cancel and lose any changes?", "Warning", MessageBoxButtons.OKCancel, MessageBoxIcon.Warning) = DialogResult.OK Then
            Me.mFileTemplate = Nrc.SurveyPoint.Library.SPTI_FileTemplate.Get(Me.mFileTemplate.FileTemplateID)
            LoadScreen()
            Me.bsColumnDefinitions.DataSource = Me.mFileTemplate.ColumnDefinitions
        End If
    End Sub
    ''' <summary>Validates and saves file template object to the data store.</summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub cmdOK_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdOK.Click
        LoadFromScreen()
        Dim brokenRules As BrokenRulesCollection = Me.mFileTemplate.ValidateAll
        If Not brokenRules Is Nothing Then
            Dim dlg As New ValidationErrorsDialog(brokenRules)
            dlg.ShowDialog()
        Else
            Me.mFileTemplate.Save()
            MessageBox.Show("Changed have been saved.", "File Temlate Save", MessageBoxButtons.OK, MessageBoxIcon.Information)
        End If
    End Sub
#End Region
#Region " Private Methods "
    ''' <summary>Sets unbound controls to the current file template BO.</summary>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub LoadScreen()
        Me.lblTemplateID.Text = CStr(Me.mFileTemplate.FileTemplateID)
        Me.txtTemplateName.Text = Me.mFileTemplate.Name
        If Me.mFileTemplate.IsFixedLength Then
            Me.chkFixedLength.Checked = True
        Else
            Me.chkFixedLength.Checked = False
        End If
        If Me.mFileTemplate.ImportAsString Then
            Me.chkImportAsString.Checked = True
        Else
            Me.chkImportAsString.Checked = False
        End If
        If Me.mFileTemplate.TrimStrings Then
            Me.chkTrimStrings.Checked = True
        Else
            Me.chkTrimStrings.Checked = False
        End If
        Me.txtDescription.Text = Me.mFileTemplate.Description
        If Me.mFileTemplate.UseQuotedIdentifier Then
            Me.chkUseQuotedIdentifier.Checked = True
        Else
            Me.chkUseQuotedIdentifier.Checked = False
        End If
        'Load the encoding types.
        If Me.mFileTemplate.EncodingType = 0 Then
            Me.cboEncodingType.SelectedIndex = 0
        Else
            For i As Integer = 0 To Me.cboEncodingType.Items.Count - 1
                If CType(Me.cboEncodingType.Items(i), SPTI_EncodingType).EncodingTypeID = Me.mFileTemplate.EncodingType Then
                    Me.cboEncodingType.SelectedIndex = i
                    Exit For
                End If
            Next
        End If
        If Me.mFileTemplate.DelimeterID = 0 Then
            Me.cboDelimeterType.SelectedIndex = 0
        Else
            For i As Integer = 0 To Me.cboDelimeterType.Items.Count - 1
                If CType(Me.cboDelimeterType.Items(i), SPTI_Delimeter).DelimeterID = Me.mFileTemplate.DelimeterID Then
                    Me.cboDelimeterType.SelectedIndex = i
                    Exit For
                End If
            Next
        End If
        Me.bsColumnDefinitions.DataSource = Me.mFileTemplate.ColumnDefinitions
    End Sub
    ''' <summary>Sets the unbound file template BO from screen controls.</summary>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub LoadFromScreen()
        Me.mFileTemplate.Name = Me.txtTemplateName.Text
        If Me.chkFixedLength.Checked Then
            Me.mFileTemplate.IsFixedLength = True
        Else
            Me.mFileTemplate.IsFixedLength = False
        End If
        If Me.chkImportAsString.Checked Then
            Me.mFileTemplate.ImportAsString = True
        Else
            Me.mFileTemplate.ImportAsString = False
        End If
        If Me.chkTrimStrings.Checked Then
            Me.mFileTemplate.TrimStrings = True
        Else
            Me.mFileTemplate.TrimStrings = False
        End If
        If Me.chkUseQuotedIdentifier.Checked Then
            Me.mFileTemplate.UseQuotedIdentifier = True
        Else
            Me.mFileTemplate.UseQuotedIdentifier = False
        End If
        Me.mFileTemplate.Description = Me.txtDescription.Text
        Me.mFileTemplate.EncodingType = CType(Me.cboEncodingType.SelectedItem, SPTI_EncodingType).EncodingTypeID
        Me.mFileTemplate.DelimeterID = CType(Me.cboDelimeterType.SelectedItem, SPTI_Delimeter).DelimeterID
    End Sub
    ''' <summary>Sets column update controls from the select column in the data grid.</summary>
    ''' <param name="col"></param>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub SetColInputs(ByVal col As SPTI_ColumnDefinition)
        Me.txtColumnName.Text = col.Name
        Me.cboDataTypes.SelectedItem = col.DataType
        Me.cboFormatingRules.SelectedItem = col.FormatingRule
    End Sub
#End Region
    
End Class
