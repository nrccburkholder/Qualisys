Imports System.Windows.Forms
Imports NRC.DataMart.WebDocumentManager.Library

Public Class CreateBatch

    Private mMemberId As Integer
    Private mBatch As DocumentBatch
    Public Property Batch() As DocumentBatch
        Get
            Return mBatch
        End Get
        Set(ByVal value As DocumentBatch)
            mBatch = value
        End Set
    End Property

    Private Sub New()

        ' This call is required by the Windows Form Designer.
        InitializeComponent()

        ' Add any initialization after the InitializeComponent() call.

    End Sub

    Public Sub New(ByVal memberId As Integer)

        ' This call is required by the Windows Form Designer.
        InitializeComponent()

        ' Add any initialization after the InitializeComponent() call.
        mMemberId = memberId
    End Sub

    Private Sub OK_Button_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles OK_Button.Click
        If DocumentBatch.IsBatchNameUsed(Me.Batch.Name) Then
            MessageBox.Show("The batch name specified has already been used.  Please specify a different name", "Duplicate Name", MessageBoxButtons.OK, MessageBoxIcon.Information)
        Else
            Me.DialogResult = System.Windows.Forms.DialogResult.OK
            Me.Close()
        End If
    End Sub

    Private Sub Cancel_Button_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Cancel_Button.Click
        Me.DialogResult = System.Windows.Forms.DialogResult.Cancel
        Me.Close()
    End Sub

    Private Sub CreateBatch_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        mBatch = DocumentBatch.NewDocumentBatch(mMemberId)
        Me.DocumentBatchBindingSource.DataSource = mBatch
    End Sub

    Private Sub BatchNameTextBox_TextChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles BatchNameTextBox.TextChanged
        Me.Batch.Name = BatchNameTextBox.Text
        If Me.Batch.IsValid Then
            Me.OK_Button.Enabled = True
        Else
            Me.OK_Button.Enabled = False
        End If
    End Sub
End Class
