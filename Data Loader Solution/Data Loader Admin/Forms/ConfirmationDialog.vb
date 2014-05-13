''' <summary>A simple confirmation dialog window class that accepts the confirmation message
'''  as a constructor parameter </summary>
''' <CreateBy>Arman Mnatsakanyan</CreateBy>
''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
Public Class ConfirmationDialog
    Public Sub New(ByVal pTitle As String, ByVal pInfo As String)

        ' This call is required by the Windows Form Designer.
        InitializeComponent()

        ' Add any initialization after the InitializeComponent() call.
        Info = pInfo
        Me.lblInfoTitle.Text = pTitle
        Me.lblInfoTitle.Visible = Not String.IsNullOrEmpty(pTitle)
    End Sub
    Private Sub btnOK_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnOK.Click
        Me.DialogResult = Windows.Forms.DialogResult.OK
        Me.Close()
    End Sub

    ''' <summary>This is the message to display on the dialog. The value must be passed in the form's constructor.</summary>
    ''' <value></value>
    ''' <CreateBy>Arman Mnatsakanyan</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property Info() As String
        Get
            Return Me.rtxtInfo.Text
        End Get
        Set(ByVal value As String)
            Me.rtxtInfo.Text = value
        End Set
    End Property
End Class