Imports Nrc.SurveyPoint.Library
Public Class ExportDefQMSDeDupRule
    Public Event DedupRuleChanged As EventHandler(Of DeDupRuleSelectedEventArgs)
#Region " Private Fields "
    Dim mClients As ExportClientAvailableCollection = Nothing
    Dim med As SPTI_ExportDefinition = Nothing
    Dim mexportFile As SPTI_ExportDefintionFile = Nothing
    Dim mDeDupRule As SPTI_DeDupRule = Nothing

    Private Const RespFields As String = "RespondentID,SurveyInstanceID,FirstName,MiddleInitial,LastName,Address1,Address2,City,State,PostalCode,TelephoneDay,TelephoneEvening,Email,DOB,Gender,ClientRespondentID,SSN,BatchID,MailingSeedFlag,CallsMade,Final,NextContact,PostalCodeExt,RespondentKey"
#End Region
#Region " Constructors "
    Public Sub New(ByVal ed As SPTI_ExportDefinition, ByVal ef As SPTI_ExportDefintionFile)

        ' This call is required by the Windows Form Designer.
        InitializeComponent()

        ' Add any initialization after the InitializeComponent() call.
        Me.med = ed
        Me.mexportFile = ef
        Me.mClients = ExportClientAvailable.GetAllClientList()
        LoadScreen()

    End Sub
#End Region
#Region " Private Methods "
    Private Sub LoadScreen()
        Me.lstClients.DataSource = Me.mClients
        Me.lstClients.DisplayMember = "Name"
        Me.cboTemplateColumns.DataSource = med.SourceFileTemplate.ColumnDefinitions
        Me.cboTemplateColumns.DisplayMember = "Name"
        Dim respArray As String() = RespFields.Split(","c)
        For Each item As String In respArray
            Me.cboQMSColumn.Items.Add(item)
        Next
        'Me.cboQMSColumn.SelectedIndex = 0
        Me.mDeDupRule = SPTI_DeDupRule.NewSPTI_DeDupRule()        
        Me.chkActiveSIOnly.Checked = True
        Me.mDeDupRule = SPTI_DeDupRule.NewSPTI_DeDupRule()
        Me.bsColMap.DataSource = Me.mDeDupRule.DeDupRuleColumnMaps
    End Sub
    Private Sub LoadFromScreen()
        Me.mDeDupRule.Name = Me.txtRuleName.Text
        If chkActiveSIOnly.Checked Then
            Me.mDeDupRule.ActiveSI = True
        Else
            Me.mDeDupRule.ActiveSI = False
        End If        
        For Each obj As Object In Me.lstClients.SelectedItems
            Dim client As ExportClientAvailable = DirectCast(obj, ExportClientAvailable)
            Me.mDeDupRule.DeDupRuleClientIDs.Add(SPTI_DeDupRuleClientID.NewSPTI_DeDupRuleClientID(client.ClientID))
        Next
    End Sub
#End Region
#Region " Event Handlers "
    Private Sub cmdOK_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdOK.Click
        LoadFromScreen()
        Dim rules As Nrc.Framework.BusinessLogic.Validation.BrokenRulesCollection
        rules = Me.mDeDupRule.ValidateAll
        If rules Is Nothing Then
            Me.mexportFile.DBDeDupRule = Me.mDeDupRule
            RaiseEvent DedupRuleChanged(Me, New DeDupRuleSelectedEventArgs(True))
            Me.Close()
        Else
            Dim dlg As New ValidationErrorsDialog(rules)
            dlg.ShowDialog()
        End If
    End Sub

    Private Sub cmdCancel_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdCancel.Click
        RaiseEvent DedupRuleChanged(Me, New DeDupRuleSelectedEventArgs(True))
        Me.Close()
    End Sub
    Private Sub cmdAddMapping_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdAddMapping.Click
        Dim respCol As String = DirectCast(Me.cboQMSColumn.SelectedItem, System.String)
        Dim templateCol As String = DirectCast(Me.cboTemplateColumns.SelectedItem, SPTI_ColumnDefinition).Name
        Me.mDeDupRule.DeDupRuleColumnMaps.Add(SPTI_DeDupRuleColumnMap.NewSPTI_DeDupRuleColumnMap(templateCol, respCol))
        Me.bsColMap.DataSource = Me.mDeDupRule.DeDupRuleColumnMaps
    End Sub
    Private Sub cmdRemoveMapping_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdRemoveMapping.Click
        Dim colMap As SPTI_DeDupRuleColumnMap = Nothing
        Dim rowHandle As Integer = 0
        For Each i As Integer In Me.grdColMapsView.GetSelectedRows
            rowHandle = i
        Next
        colMap = TryCast(Me.grdColumnMaps.DefaultView.GetRow(rowHandle), SPTI_DeDupRuleColumnMap)
        If Not colMap Is Nothing Then
            Me.mDeDupRule.DeDupRuleColumnMaps.Remove(colMap)
        End If
    End Sub
#End Region
End Class
