Imports Nrc.SurveyPoint.Library
Public Class ExportDefintionDialog
#Region " Fields "
    Private mOldExportDefID As Integer = 0
    Private mOldExportDefName As String = ""
#End Region
#Region " Constructors "

    Public Sub New(ByVal oldExportDefID As Integer, ByVal oldExportDefName As String)
        InitializeComponent()
        Me.mOldExportDefID = oldExportDefID
        Me.mOldExportDefName = oldExportDefName
    End Sub
#End Region
#Region " Event Handlers "
    Private Sub cmdCancel_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdCancel.Click
        Me.DialogResult = Windows.Forms.DialogResult.Cancel
        Me.Close()
    End Sub

    Private Sub cmdOK_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdOK.Click
        If Me.txtName.Text = "" Then
            Me.ErrorProvider1.SetError(Me.txtName, "Import Export Defintion Name must have a value.")
        ElseIf Nrc.SurveyPoint.Library.SPTI_ExportDefinition.CheckExportDefExistsByName(0, Me.txtName.Text) Then
            Me.ErrorProvider1.SetError(Me.txtName, "Import Export Defintion Name cannot equal a name already assigned.")
        Else 'Copy
            If Me.mOldExportDefID = 0 Then ' new
                Dim def As SPTI_ExportDefinition = SPTI_ExportDefinition.NewSPTI_ExportDefinition(txtName.Text)                
                def.Save()
            Else
                Dim id As Integer = SPTI_ExportDefinition.CopyExportDefinition(Me.mOldExportDefID, txtName.Text)
            End If
            Me.DialogResult = Windows.Forms.DialogResult.OK
            Me.Close()
        End If
    End Sub    
#End Region
#Region " Private Methods "
    Private Sub LoadScreen()
        Me.txtName.Text = Me.mOldExportDefName
    End Sub
#End Region
End Class
