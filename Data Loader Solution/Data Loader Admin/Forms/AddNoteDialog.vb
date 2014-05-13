Imports Nrc.DataLoader.Library
''' <summary>This form is designed for saving notes for the selected UploadFilePackage records.</summary>
''' <CreateBy>Arman Mnatsakanyan</CreateBy>
''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
Public Class AddNoteDialog
    Dim mUploadFilePackages As List(Of UploadFilePackageDisplay)
    Private mNoteViewMode As Boolean

    Public Sub New(ByVal pUploadFilePackages As List(Of UploadFilePackageDisplay))

        ' This call is required by the Windows Form Designer.
        InitializeComponent()

        ' Add any initialization after the InitializeComponent() call.
        mUploadFilePackages = pUploadFilePackages
        mNoteViewMode = False
    End Sub
    Public Sub New(ByVal noteText As String)
        ' This call is required by the Windows Form Designer.
        InitializeComponent()
        
        ' Add any initialization after the InitializeComponent() call.
        mNoteViewMode = True
        Me.txtNewNote.Text = noteText
        Me.txtNewNote.ReadOnly = True
        Me.txtNewNote.BackColor = Color.White
        Me.btnSave.Text = "Close"
        Me.btnCancel.Visible = False
        Me.Text = "View Note"


    End Sub

    ''' <summary>Handles btnSave.Click event. Saves the note to UploadFilePackageNotes
    ''' table for each  UploadFilePackage_id in mUploadFilePackages.</summary>
    ''' <remarks>Sets the DialogResult to OK when the note is saved.</remarks>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <CreateBy>Arman Mnatsakanyan</CreateBy>
    ''' <RevisionList><list type="table">
    ''' <listheader>
    ''' <term>Date Modified - Modified By</term>
    ''' <description>Description</description></listheader>
    ''' <item>
    ''' <term>	</term>
    ''' <description>
    ''' <para></para></description></item>
    ''' <item>
    ''' <term>	</term>
    ''' <description>
    ''' <para></para></description></item></list></RevisionList>
    Private Sub btnSave_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnSave.Click
        If mNoteViewMode Then

            'Close The Note
            Me.DialogResult = Windows.Forms.DialogResult.OK
            Me.Close()

        Else

            'Save the note
            If String.IsNullOrEmpty(Me.txtNewNote.Text) Then
                MsgBox("Please, enter your note before saving.", MsgBoxStyle.OkOnly, "Did you forget to enter your note?")
            Else
                For Each FilePackage As UploadFilePackageDisplay In mUploadFilePackages
                    Dim note As UploadFilePackageNote = UploadFilePackageNote.NewUploadFilePackageNote()
                    note.UploadFilePackageId = FilePackage.UploadFilePackageID
                    note.Note = Me.txtNewNote.Text
                    note.Username = CurrentUser.UserName
                    note.DateCreated = Now()
                    note.Save()
                    Me.DialogResult = Windows.Forms.DialogResult.OK
                    Me.Close()
                Next
            End If

        End If
    End Sub

    Private Sub AddNoteDialog_Shown(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Shown
        Me.txtNewNote.SelectionLength = 0
    End Sub
End Class
