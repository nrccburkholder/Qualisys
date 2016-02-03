Imports Nrc.SurveyPoint.Library
Imports Nrc.Framework.BusinessLogic.Validation
''' <summary>This enumerator tells the load what its doing based on values set in overloaded constructor.</summary>
''' <CreatedBy>Tony Piccoli</CreatedBy>
''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
Public Enum FormExportTypes
    ExportFile = 1
    ExportFromReRun = 2
    ValidateConfig = 3    
End Enum
''' <summary>Dialog the can run and or validate an export.</summary>
''' <CreatedBy>Tony Piccoli</CreatedBy>
''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
Public Class ExportGroupRunLog
#Region " Private Fields "
    Dim WithEvents mExportMedicareFile As ExportMedicareFile
    'TP 20080516
    Dim WithEvents mExportMedicaidFile As ExportMedicaidFile
    'TP 20080818
    Dim WithEvents mExportWPMedicareFile As ExportWPMedicareFile
    'TP 20111205
    Dim WithEvents mExportMedicare2012File As ExportMedicare2012File

    Dim mExportGroup As ExportGroup
    Dim mObjectMessages As ExportObjectMessageCollection = New ExportObjectMessageCollection
    Dim formExportType As FormExportTypes
    Dim mMarkSubmitted As Boolean
    Dim mLogFileID As Integer
    Dim mRespCountOnly As Boolean
    Dim mActiveOnly As Boolean = False
#End Region
#Region " Constructors "    
    ''' <summary>This constructor is used to show validation errors on an export group.</summary>
    ''' <param name="exportGroup"></param>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Sub New(ByVal exportGroup As ExportGroup)
        ' This call is required by the Windows Form Designer.
        InitializeComponent()
        Try
            Me.mExportGroup = exportGroup
            formExportType = FormExportTypes.ValidateConfig
        Catch ex As Exception
            cmdClose.Enabled = True
        End Try
    End Sub
    ''' <summary>This constructor is used when exporting a re-run</summary>
    ''' <param name="exportGroup"></param>
    ''' <param name="markSubmitted"></param>
    ''' <param name="logFileID"></param>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Sub New(ByVal exportGroup As ExportGroup, ByVal markSubmitted As Boolean, ByVal logFileID As Integer, ByVal RespCountOnly As Boolean, ByVal ActiveOnly As Boolean)
        ' This call is required by the Windows Form Designer.
        InitializeComponent()
        Try
            Me.mExportGroup = exportGroup
            Me.mMarkSubmitted = markSubmitted
            Me.mLogFileID = logFileID
            Me.mRespCountOnly = RespCountOnly
            Me.mActiveOnly = ActiveOnly
            formExportType = FormExportTypes.ExportFromReRun
        Catch ex As Exception
            cmdClose.Enabled = True
        End Try
    End Sub
    ''' <summary>This is the constructor to use if you are running an export from the config screen.</summary>
    ''' <param name="exportGroup"></param>
    ''' <param name="markSubmitted"></param>    
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Sub New(ByVal exportGroup As ExportGroup, ByVal markSubmitted As Boolean, ByVal RespCountOnly As Boolean, ByVal ActiveOnly As Boolean)

        ' This call is required by the Windows Form Designer.
        InitializeComponent()
        Try

            ' Add any initialization after the InitializeComponent() call.  
            mExportGroup = exportGroup
            Me.mMarkSubmitted = markSubmitted
            formExportType = FormExportTypes.ExportFile
            Me.mRespCountOnly = RespCountOnly
            Me.mActiveOnly = ActiveOnly
        Catch ex As Exception
            cmdClose.Enabled = True
        End Try
    End Sub
#End Region
#Region " Event Handlers "
    ''' <summary>The shown event is used rather than the load so that the dialog will display while it is processing the export.</summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub ExportGroupRunLog_Shown(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Shown
        Select Case Me.formExportType
            Case FormExportTypes.ExportFile
                RunExport()
            Case FormExportTypes.ExportFromReRun
                RunExport()
            Case FormExportTypes.ValidateConfig
                DisplayExportValidationErrors()
                SetControlsForClose()
        End Select
    End Sub
    ''' <summary>Close the dialog.</summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub cmdClose_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdClose.Click
        Me.Close()
    End Sub
    ''' <summary>Recieves events from the export File object to update the status of an export visually.</summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub HandleMessages(ByVal sender As System.Object, ByVal e As ExportMessageArgs) Handles mExportMedicareFile.NewMessage, mExportMedicaidFile.NewMessage, mExportWPMedicareFile.NewMessage, mExportMedicare2012File.NewMessage
        UpdateMessages(e.ExportObjectMessage)
    End Sub
    ''' <summary>Recieves events from the expor file object to update the propgress bar and label visually.</summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub HandleProgress(ByVal sender As System.Object, ByVal e As ExportFileProgress) Handles mExportMedicareFile.ExportProgress, mExportMedicaidFile.ExportProgress, mExportWPMedicareFile.ExportProgress, mExportMedicare2012File.ExportProgress
        UpdateProgressBar(e.ProgressMessage, e.PercentComplete, e.Abort)
    End Sub
#End Region
#Region " Helper Methods "
    ''' <summary>Called from the shown event when exporting files from the config
    ''' screen.</summary>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table">
    ''' <listheader>
    ''' <term>Date Modified - Modified By</term>
    ''' <description>Description</description></listheader>
    ''' <item>
    ''' <term>20080416 - Tony Piccoli</term>
    ''' <description>Added in logic for rern export</description></item>
    ''' <item>
    ''' <term>20080505 - Tony Piccoli</term>
    ''' <description>Changed if logic to get validation to check the file
    ''' paths.</description></item>
    ''' <item>
    ''' <term>20080516 - Tony Piccoli</term>
    ''' <description>Moved export run logic specific to file type into its own
    ''' routine</description></item></list></RevisionList>
    Private Sub RunExport()
        Me.mObjectMessages = New ExportObjectMessageCollection
        Me.ObjectMessageBindingSource.DataSource = Me.mObjectMessages
        Try
            Dim valid As Boolean = mExportGroup.ValidateAll()
            If Not valid Then
                DisplayExportValidationErrors()
            End If
            Dim validationString As String = String.Empty
            Dim scriptValid As Boolean = False
            scriptValid = mExportGroup.ExportSelectedSurvey.VaildateClientsAndScripts(validationString, False)
            If valid AndAlso scriptValid Then
                If Me.mRespCountOnly Then
                    GetRespCountByLayout()
                Else
                    Me.mExportGroup.Save()
                    'TP 20080516
                    ExportByFileLayout()
                End If
            Else
                If Not scriptValid Then
                    DisplayExportValidationErrors(validationString)
                End If
            End If
            SetControlsForClose()
        Catch ex As Exception
            Dim obj As ExportObjectMessage = ExportObjectMessage.NewExportObjectMessage(ExportObjectMessageType.ExportError, ex.Message, 0, Environment.StackTrace, "An unexpected error has occurred.")
            Me.mObjectMessages.Add(obj)
            Me.ObjectMessageBindingSource.DataSource = Me.mObjectMessages
            SetControlsForClose()
        End Try
    End Sub
#Region " Export By File Type Helpers "
    ''' <summary>This validation is specific to which file type (file controller class) we are using.</summary>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub DisplayExportValidationByFileLayout()
        'TODO:  Move to BO
        If Me.mExportGroup.ExportFileLayout.FileLayoutID = 1 Then 'Coventry Medicare
            If Not Me.mExportMedicareFile Is Nothing Then
                If Not Me.mExportMedicareFile.IsValid AndAlso Me.mExportMedicareFile.BrokenRulesCollection.Count > 0 Then
                    For Each rule As BrokenRule In Me.mExportMedicareFile.BrokenRulesCollection
                        Dim objMsg As ExportObjectMessage = ExportObjectMessage.NewExportObjectMessage(ExportObjectMessageType.ExportValidation, rule.Description, Nothing, "", "Export Group Validation")
                        UpdateMessages(objMsg)
                    Next
                End If
            End If
        ElseIf Me.mExportGroup.ExportFileLayout.FileLayoutID = 2 Then 'Coventry Medicaid
            If Not Me.mExportMedicaidFile Is Nothing Then
                If Not Me.mExportMedicaidFile.IsValid AndAlso Me.mExportMedicaidFile.BrokenRulesCollection.Count > 0 Then
                    For Each rule As BrokenRule In Me.mExportMedicaidFile.BrokenRulesCollection
                        Dim objMsg As ExportObjectMessage = ExportObjectMessage.NewExportObjectMessage(ExportObjectMessageType.ExportValidation, rule.Description, Nothing, "", "Export Group Validation")
                        UpdateMessages(objMsg)
                    Next
                End If
            End If
        ElseIf Me.mExportGroup.ExportFileLayout.FileLayoutID = 3 Then 'Wellpoint Medicare
            If Not Me.mExportWPMedicareFile Is Nothing Then
                If Not Me.mExportWPMedicareFile.IsValid AndAlso Me.mExportWPMedicareFile.BrokenRulesCollection.Count > 0 Then
                    For Each rule As BrokenRule In Me.mExportWPMedicareFile.BrokenRulesCollection
                        Dim objMsg As ExportObjectMessage = ExportObjectMessage.NewExportObjectMessage(ExportObjectMessageType.ExportValidation, rule.Description, Nothing, "", "Export Group Validation")
                        UpdateMessages(objMsg)
                    Next
                End If
            End If
        ElseIf Me.mExportGroup.ExportFileLayout.FileLayoutID = 4 Then 'Coventry Medicare 2012
            If Not Me.mExportMedicare2012File Is Nothing Then
                If Not Me.mExportMedicare2012File.IsValid AndAlso Me.mExportMedicare2012File.BrokenRulesCollection.Count > 0 Then
                    For Each rule As BrokenRule In Me.mExportMedicare2012File.BrokenRulesCollection
                        Dim objMsg As ExportObjectMessage = ExportObjectMessage.NewExportObjectMessage(ExportObjectMessageType.ExportValidation, rule.Description, Nothing, "", "Export Group Validation")
                        UpdateMessages(objMsg)
                    Next
                End If
            End If
        End If
    End Sub
    Private Sub GetRespCountByLayout()
        Dim respondentCount As Long = 0
        Dim maxRespondentCount As Long = Config.MaxNumberOfRespondentsPerExport
        Try
            Dim objMsg As ExportObjectMessage = ExportObjectMessage.NewExportObjectMessage(ExportObjectMessageType.ExportValidation, "Retrieving respondent information", Nothing, "", "Export Group Max Respondent Count")
            UpdateMessages(objMsg)
            UpdateProgressBar("Retrieving respondent count", 10, False)
            If Me.mExportGroup.ExportFileLayout.FileLayoutID = 1 Then 'Conventry Medicare
                If Me.formExportType = FormExportTypes.ExportFile Then
                    respondentCount = ExportMedicareRFileController.GetNumberOfRespondentsByExportGroup(Me.mExportGroup.ExportGroupID, 0, 0, Me.mMarkSubmitted, False, Me.mExportGroup.RerunCodeStartDate, Me.mExportGroup.RerunCodeEndDate, Me.mActiveOnly)
                ElseIf Me.formExportType = FormExportTypes.ExportFromReRun Then
                    respondentCount = ExportMedicareRFileController.GetNumberOfRespondentsByExportGroup(Me.mExportGroup.ExportGroupID, 0, Me.mLogFileID, Me.mMarkSubmitted, True, Me.mExportGroup.RerunCodeStartDate, Me.mExportGroup.RerunCodeEndDate, Me.mActiveOnly)
                End If
            ElseIf Me.mExportGroup.ExportFileLayout.FileLayoutID = 2 Then 'Coventry Medicaid
                If Me.formExportType = FormExportTypes.ExportFile Then
                    respondentCount = ExportMedicaidRFileController.GetNumberOfRespondentsByExportGroup(Me.mExportGroup.ExportGroupID, 0, 0, Me.mMarkSubmitted, False, Me.mExportGroup.RerunCodeStartDate, Me.mExportGroup.RerunCodeEndDate, Me.mActiveOnly)
                ElseIf Me.formExportType = FormExportTypes.ExportFromReRun Then
                    respondentCount = ExportMedicaidRFileController.GetNumberOfRespondentsByExportGroup(Me.mExportGroup.ExportGroupID, 0, Me.mLogFileID, Me.mMarkSubmitted, True, Me.mExportGroup.RerunCodeStartDate, Me.mExportGroup.RerunCodeEndDate, Me.mActiveOnly)
                End If
            ElseIf Me.mExportGroup.ExportFileLayout.FileLayoutID = 3 Then 'Wellpoint Medicare
                If Me.formExportType = FormExportTypes.ExportFile Then
                    respondentCount = ExportWPMedicareRFileController.GetNumberOfRespondentsByExportGroup(Me.mExportGroup.ExportGroupID, 0, 0, Me.mMarkSubmitted, False, Me.mExportGroup.RerunCodeStartDate, Me.mExportGroup.RerunCodeEndDate, Me.mActiveOnly)
                ElseIf Me.formExportType = FormExportTypes.ExportFromReRun Then
                    respondentCount = ExportWPMedicareRFileController.GetNumberOfRespondentsByExportGroup(Me.mExportGroup.ExportGroupID, 0, Me.mLogFileID, Me.mMarkSubmitted, True, Me.mExportGroup.RerunCodeStartDate, Me.mExportGroup.RerunCodeEndDate, Me.mActiveOnly)
                End If
            ElseIf Me.mExportGroup.ExportFileLayout.FileLayoutID = 4 Then 'Coventry Medicare 2012
                If Me.formExportType = FormExportTypes.ExportFile Then
                    respondentCount = ExportMedicare2012RFileController.GetNumberOfRespondentsByExportGroup(Me.mExportGroup.ExportGroupID, 0, 0, Me.mMarkSubmitted, False, Me.mExportGroup.RerunCodeStartDate, Me.mExportGroup.RerunCodeEndDate, Me.mActiveOnly)
                ElseIf Me.formExportType = FormExportTypes.ExportFromReRun Then
                    respondentCount = ExportMedicare2012RFileController.GetNumberOfRespondentsByExportGroup(Me.mExportGroup.ExportGroupID, 0, Me.mLogFileID, Me.mMarkSubmitted, True, Me.mExportGroup.RerunCodeStartDate, Me.mExportGroup.RerunCodeEndDate, Me.mActiveOnly)
                End If
            End If
            objMsg = ExportObjectMessage.NewExportObjectMessage(ExportObjectMessageType.ExportValidation, "Maximum respondents allowed per export is: " & maxRespondentCount.ToString, Nothing, "", "Export Group Max Respondent Count")
            UpdateMessages(objMsg)
            objMsg = ExportObjectMessage.NewExportObjectMessage(ExportObjectMessageType.ExportValidation, "Number of respondents for this export is: " & respondentCount.ToString, Nothing, "", "Export Group Respondent Count")
            UpdateMessages(objMsg)
        Catch ex As Exception
            Dim objMsg As ExportObjectMessage = ExportObjectMessage.NewExportObjectMessage(ExportObjectMessageType.ExportError, ex.Message, Nothing, "", "Export Group Max Respondent Count Error")
            UpdateMessages(objMsg)
        Finally
            UpdateProgressBar("Retrieved respondent count", 100, True)
            SetControlsForClose()
        End Try
    End Sub
    ''' <summary>Runs the export based on the file layout.</summary>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub ExportByFileLayout()
        'TODO:  Move to BO
        If Me.mExportGroup.ExportFileLayout.FileLayoutID = 1 Then 'Conventry Medicare
            If Me.formExportType = FormExportTypes.ExportFile Then
                mExportMedicareFile = ExportMedicareFile.NewExportMedicareFile(mExportGroup, 1, Environment.UserName, Me.mMarkSubmitted, Me.mActiveOnly)
            ElseIf Me.formExportType = FormExportTypes.ExportFromReRun Then
                mExportMedicareFile = ExportMedicareFile.NewExportMedicareFileFromRerun(Me.mLogFileID, 1, Environment.UserName, Me.mMarkSubmitted, Me.mExportGroup.RerunCodeStartDate, Me.mExportGroup.RerunCodeEndDate, Me.mActiveOnly)
            End If
            mExportMedicareFile.ExportFiles()
        ElseIf Me.mExportGroup.ExportFileLayout.FileLayoutID = 2 Then 'Coventry Medicaid
            If Me.formExportType = FormExportTypes.ExportFile Then
                mExportMedicaidFile = ExportMedicaidFile.NewExportMedicaidFile(mExportGroup, 1, Environment.UserName, Me.mMarkSubmitted, Me.mActiveOnly)
            ElseIf Me.formExportType = FormExportTypes.ExportFromReRun Then
                mExportMedicaidFile = ExportMedicaidFile.NewExportMedicaidFileFromRerun(Me.mLogFileID, 1, Environment.UserName, Me.mMarkSubmitted, Me.mExportGroup.RerunCodeStartDate, Me.mExportGroup.RerunCodeEndDate, Me.mActiveOnly)
            End If
            mExportMedicaidFile.ExportFiles()
        ElseIf Me.mExportGroup.ExportFileLayout.FileLayoutID = 3 Then 'Wellpoint Medicare
            If Me.formExportType = FormExportTypes.ExportFile Then
                mExportWPMedicareFile = ExportWPMedicareFile.NewExportWPMedicareFile(mExportGroup, 1, Environment.UserName, Me.mMarkSubmitted, Me.mActiveOnly)
            ElseIf Me.formExportType = FormExportTypes.ExportFromReRun Then
                mExportWPMedicareFile = ExportWPMedicareFile.NewExportWPMedicareFileFromRerun(Me.mLogFileID, 1, Environment.UserName, Me.mMarkSubmitted, Me.mExportGroup.RerunCodeStartDate, Me.mExportGroup.RerunCodeEndDate, Me.mActiveOnly)
            End If
            mExportWPMedicareFile.ExportFiles()
        ElseIf Me.mExportGroup.ExportFileLayout.FileLayoutID = 4 Then 'Conventry Medicare 2012
            If Me.formExportType = FormExportTypes.ExportFile Then
                mExportMedicare2012File = ExportMedicare2012File.NewExportMedicare2012File(mExportGroup, 1, Environment.UserName, Me.mMarkSubmitted, Me.mActiveOnly)
            ElseIf Me.formExportType = FormExportTypes.ExportFromReRun Then
                mExportMedicare2012File = ExportMedicare2012File.NewExportMedicare2012FileFromRerun(Me.mLogFileID, 1, Environment.UserName, Me.mMarkSubmitted, Me.mExportGroup.RerunCodeStartDate, Me.mExportGroup.RerunCodeEndDate, Me.mActiveOnly)
            End If
            mExportMedicare2012File.ExportFiles()
        Else
            Throw New NotImplementedException("NRC Standard file type has not been implemented.")
        End If
    End Sub
#End Region
#Region " Display Helpers "
    ''' <summary>Helper to hide progress bar and enable the OK button.</summary>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub SetControlsForClose()
        Me.ToolStripProgressBar1.Value = 0
        Me.ToolStripProgressBar1.Visible = False
        Me.ToolStripStatusLabel1.Text = ""
        Me.ToolStripStatusLabel1.Visible = False
        Me.cmdClose.Enabled = True
    End Sub
    ''' <summary>Updates the status display grid and rebinds.</summary>
    ''' <param name="exportObjectMessage"></param>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub UpdateMessages(ByVal exportObjectMessage As ExportObjectMessage)
        Me.mObjectMessages.Add(exportObjectMessage)
        Me.ObjectMessageBindingSource.DataSource = Me.mObjectMessages
        Application.DoEvents()
    End Sub
    ''' <summary>Updates the progress bar.</summary>
    ''' <param name="message"></param>
    ''' <param name="percentComplete"></param>
    ''' <param name="abort"></param>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub UpdateProgressBar(ByVal message As String, ByVal percentComplete As Integer, ByVal abort As Boolean)
        If abort Then
            Me.ToolStripProgressBar1.Visible = False
            Me.ToolStripStatusLabel1.Text = ""
        Else
            Me.ToolStripProgressBar1.Visible = True
            ToolStripStatusLabel1.Text = message
            ToolStripProgressBar1.Value = percentComplete
        End If
        Application.DoEvents()
    End Sub
    ''' <summary>This method loops through the broken rules collections of the export
    ''' object and displays them in the data grid.</summary>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table">
    ''' <listheader>
    ''' <term>Date Modified - Modified By</term>
    ''' <description>Description</description></listheader>
    ''' <item>
    ''' <term>20080516 - Tony Piccoli</term>
    ''' <description>Moved FileLayout validation to its own
    ''' routine.</description></item>
    ''' <item>
    ''' <term>	</term>
    ''' <description>
    ''' <para></para></description></item></list></RevisionList>
    Private Sub DisplayExportValidationErrors()
        DisplayExportValidationByFileLayout()
        If Not Me.mExportGroup Is Nothing AndAlso Not Me.mExportGroup.IsValid Then
            If Me.mExportGroup.BrokenRulesCollection.Count > 0 Then
                For Each rule As BrokenRule In Me.mExportGroup.BrokenRulesCollection
                    Dim objMsg As ExportObjectMessage = ExportObjectMessage.NewExportObjectMessage(ExportObjectMessageType.ExportValidation, rule.Description, Nothing, "", "Export Group Validation")
                    UpdateMessages(objMsg)
                Next
                If Not Me.mExportGroup.ExportSelectedSurvey Is Nothing AndAlso Not Me.mExportGroup.ExportSelectedSurvey.IsValid Then
                    For Each surveyRule As BrokenRule In Me.mExportGroup.ExportSelectedSurvey.BrokenRulesCollection
                        Dim objMsg As ExportObjectMessage = ExportObjectMessage.NewExportObjectMessage(ExportObjectMessageType.ExportValidation, surveyRule.Description, Nothing, "", "Survey Validation")
                        UpdateMessages(objMsg)
                    Next
                End If
            End If
        ElseIf Not Me.mExportGroup Is Nothing AndAlso Not Me.mExportGroup.ExportSelectedSurvey Is Nothing AndAlso Not Me.mExportGroup.ExportSelectedSurvey.IsValid Then
            For Each surveyRule As BrokenRule In Me.mExportGroup.ExportSelectedSurvey.BrokenRulesCollection
                Dim objMsg As ExportObjectMessage = ExportObjectMessage.NewExportObjectMessage(ExportObjectMessageType.ExportValidation, surveyRule.Description, Nothing, "", "Survey Validation")
                UpdateMessages(objMsg)
            Next
        End If
    End Sub
    ''' <summary>Export Groups ValidateClientAndScripts method retuns a vbcrlf delimited string of validation errors.  This method parses through them and displays them in the data grid.</summary>
    ''' <param name="retMsg"></param>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub DisplayExportValidationErrors(ByVal retMsg As String)
        Dim msgArray As String() = retMsg.Split(vbCrLf.ToCharArray)
        For Each msg As String In msgArray
            UpdateMessages(ExportObjectMessage.NewExportObjectMessage(ExportObjectMessageType.ExportValidation, msg, Nothing, "", "Client and Script Validation."))
        Next
    End Sub
#End Region

#End Region
End Class
