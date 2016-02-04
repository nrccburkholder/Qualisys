Imports Nrc.SurveyPoint.Library
Imports System.Xml

Public Class FileTemplateAdd
#Region " Fields "
    Private mOldFileTemplateID As Integer = 0
    Private mOldFileTemplateName As String = ""
#End Region
#Region " Constructors "
    ''' <summary>Constructor to use when create a new template.</summary>
    ''' <param name="oldFileTemplateID"></param>
    ''' <param name="oldFileTemplateName"></param>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Sub New(ByVal oldFileTemplateID As Integer, ByVal oldFileTemplateName As String)
        InitializeComponent()
        Me.mOldFileTemplateID = oldFileTemplateID
        Me.mOldFileTemplateName = oldFileTemplateName
    End Sub
#End Region
#Region " Event Handlers "
    ''' <summary>Dont create new template and close form.</summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub cmdCancel_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdCancel.Click
        Me.DialogResult = Windows.Forms.DialogResult.Cancel
        Me.Close()
    End Sub
    ''' <summary>Validate and create new template then close form.</summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub cmdOK_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdOK.Click
        If Me.txtFileTemplateName.Text = "" Then
            Me.ErrorProvider1.SetError(Me.txtFileTemplateName, "File Template Name must have a value.")
        ElseIf Nrc.SurveyPoint.Library.SPTI_FileTemplate.CheckFileTemplateExistsByName(0, txtFileTemplateName.Text) Then
            Me.ErrorProvider1.SetError(Me.txtFileTemplateName, "File Template Name cannot equal a name already assigned.")
        Else
            If Me.mOldFileTemplateID = 0 Then 'New
                Dim ft As SPTI_FileTemplate = SPTI_FileTemplate.NewSPTI_FileTemplate(txtFileTemplateName.Text, txtFileTemplateName.Text)                
                ft.Save()
            Else 'Copy
                Dim id As Integer = SPTI_FileTemplate.CopyFileTemplate(Me.mOldFileTemplateID, txtFileTemplateName.Text)                
            End If
            Me.DialogResult = Windows.Forms.DialogResult.OK
            Me.Close()
        End If
    End Sub
#End Region
#Region " Private Methods "
    ''' <summary>Load unbound screen controls.</summary>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub LoadScreen()
        Me.txtFileTemplateName.Text = Me.mOldFileTemplateName
    End Sub
#End Region
End Class
