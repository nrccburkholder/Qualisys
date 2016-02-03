Imports Nrc.Framework.BusinessLogic.Validation
Public Class ValidationErrorsDialog
#Region " Fields "
    Private mErrorList As BrokenRulesCollection
#End Region
#Region " Constructors "
    ''' <summary>Default constructor.</summary>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Sub New()

        ' This call is required by the Windows Form Designer.
        InitializeComponent()

        ' Add any initialization after the InitializeComponent() call.

    End Sub
    ''' <summary>This constructor required for showing validation errors.</summary>
    ''' <param name="errors"></param>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Sub New(ByVal errors As BrokenRulesCollection)
        ' This call is required by the Windows Form Designer.
        InitializeComponent()

        ' Add any initialization after the InitializeComponent() call.
        Me.mErrorList = errors       
    End Sub
#End Region
#Region " Event Handlers "
    ''' <summary>Close the dialog</summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub cmdClose_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdClose.Click
        Me.Close()
    End Sub
    ''' <summary>Bind the validation errors to the grid.</summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub ValidationErrorsDialog_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        bsBrokenRules.DataSource = mErrorList
    End Sub
#End Region
End Class
