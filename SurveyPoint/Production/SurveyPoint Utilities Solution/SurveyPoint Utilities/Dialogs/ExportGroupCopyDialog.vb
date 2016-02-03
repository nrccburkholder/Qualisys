Imports Nrc.SurveyPoint.Library

''' <summary>This class is a dialog that allows the user to select a new name for copying an existing export group</summary>
''' <CreatedBy>Tony Piccoli</CreatedBy>
''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
Public Class ExportGroupCopyDialog
#Region " Private Properties "
    Private mOldExportName As String = String.Empty
    Private mNewExportName As String = String.Empty
#End Region
#Region " Public Properies "
    ''' <summary>The original export group name.</summary>
    ''' <value>string</value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public ReadOnly Property OldExportName() As String
        Get
            Return mOldExportName
        End Get
    End Property
    ''' <summary>The new export name that the user is going to enter</summary>
    ''' <value>String</value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public ReadOnly Property NewExportName() As String
        Get
            Return mNewExportName
        End Get
    End Property
#End Region
#Region " Constructors "
    Public Sub New()

        ' This call is required by the Windows Form Designer.
        InitializeComponent()

        ' Add any initialization after the InitializeComponent() call.

    End Sub
    Public Sub New(ByVal pstrOldGroupName As String)

        ' This call is required by the Windows Form Designer.
        InitializeComponent()

        ' Add any initialization after the InitializeComponent() call.
        Me.mOldExportName = pstrOldGroupName
        NewExportGroupNameTextBox.Text = pstrOldGroupName
        NewExportGroupNameTextBox.Focus()
    End Sub
#End Region
#Region " Events "
    ''' <summary>OK Button Event handler.  Calls Validation Routine.</summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub cmdOK_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdOK.Click
        ValidateName()
    End Sub

    ''' <summary>This button allows the user to  exit out of the dialog.</summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub cmdCancel_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdCancel.Click
        Me.DialogResult = Windows.Forms.DialogResult.Cancel
        Me.Close()
    End Sub
#End Region
#Region " Private Methods "
    ''' <summary>Calls method to validate the new export name.  If Valid, records the name and closes the dialog. Else, sets the error provider.</summary>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub ValidateName()
        Dim retMsg As String = String.Empty
        If ValidateText(NewExportGroupNameTextBox.Text, retMsg) Then
            mNewExportName = NewExportGroupNameTextBox.Text
            Me.DialogResult = Windows.Forms.DialogResult.OK
            Me.Close()
        Else            
            Me.EPNewExportGroupNameTextBox.SetError(Me.NewExportGroupNameTextBox, retMsg)
        End If
    End Sub
    ''' <summary>Validates the new export name for length and to make sure it doesn't exist in the data store already.</summary>
    ''' <param name="pstrNewExportName"></param>
    ''' <param name="retMsg"></param>
    ''' <returns></returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Function ValidateText(ByVal pstrNewExportName As String, ByRef retMsg As String) As Boolean
        Dim retVal As Boolean = False

        If pstrNewExportName.Length = 0 OrElse Trim(pstrNewExportName) = "" Then
            retMsg = "You must enter of value for the export group name."
        ElseIf pstrNewExportName.Length > 100 Then
            retMsg = "Export group name can not be greater than 100 characters."
        ElseIf pstrNewExportName.ToLower = Me.OldExportName.ToLower Then
            retMsg = "Export group can not be the same name as the current export group."
            'ElseIf ExportGroup.CheckExportGroupByName(pstrNewExportName) = True Then
            '    retMsg = "The name you have selected already exists."
        Else
            Return True
        End If
    End Function
#End Region

    ''' <summary>Load event handler for dialog</summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub ExportGroupCopyDialog_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        Me.NewExportGroupNameTextBox.Focus()
    End Sub
End Class
