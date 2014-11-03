Imports Nrc.QualiSys.Library
Imports Nrc.Framework.Data

Public Class CancelMailingsPanel
    Inherits ActionPanel

#Region " Windows Form Designer generated code "

    Public Sub New()
        MyBase.New()

        'This call is required by the Windows Form Designer.
        InitializeComponent()

        'Add any initialization after the InitializeComponent() call

    End Sub

    'UserControl overrides dispose to clean up the component list.
    Protected Overloads Overrides Sub Dispose(ByVal disposing As Boolean)
        If disposing Then
            If Not (components Is Nothing) Then
                components.Dispose()
            End If
        End If
        MyBase.Dispose(disposing)
    End Sub

    'Required by the Windows Form Designer
    Private components As System.ComponentModel.IContainer

    'NOTE: The following procedure is required by the Windows Form Designer
    'It can be modified using the Windows Form Designer.  
    'Do not modify it using the code editor.
    Friend WithEvents MailingsLabel As System.Windows.Forms.Label
    Friend WithEvents MailingList As System.Windows.Forms.ListView
    Friend WithEvents ColumnHeader10 As System.Windows.Forms.ColumnHeader
    Friend WithEvents ColumnHeader1 As System.Windows.Forms.ColumnHeader
    Friend WithEvents ColumnHeader2 As System.Windows.Forms.ColumnHeader
    Friend WithEvents ColumnHeader3 As System.Windows.Forms.ColumnHeader
    Friend WithEvents ColumnHeader4 As System.Windows.Forms.ColumnHeader
    Friend WithEvents ColumnHeader5 As System.Windows.Forms.ColumnHeader
    Friend WithEvents ColumnHeader6 As System.Windows.Forms.ColumnHeader
    Friend WithEvents ColumnHeader7 As System.Windows.Forms.ColumnHeader
    Friend WithEvents ColumnHeader8 As System.Windows.Forms.ColumnHeader
    Friend WithEvents ColumnHeader9 As System.Windows.Forms.ColumnHeader
    Friend WithEvents MailingImages As System.Windows.Forms.ImageList
    Friend WithEvents ActionLabel As System.Windows.Forms.Label
    Friend WithEvents CancelMailingsButton As System.Windows.Forms.Button
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.components = New System.ComponentModel.Container
        Dim resources As System.Resources.ResourceManager = New System.Resources.ResourceManager(GetType(CancelMailingsPanel))
        Me.ActionLabel = New System.Windows.Forms.Label
        Me.CancelMailingsButton = New System.Windows.Forms.Button
        Me.MailingsLabel = New System.Windows.Forms.Label
        Me.MailingList = New System.Windows.Forms.ListView
        Me.ColumnHeader10 = New System.Windows.Forms.ColumnHeader
        Me.ColumnHeader1 = New System.Windows.Forms.ColumnHeader
        Me.ColumnHeader2 = New System.Windows.Forms.ColumnHeader
        Me.ColumnHeader3 = New System.Windows.Forms.ColumnHeader
        Me.ColumnHeader4 = New System.Windows.Forms.ColumnHeader
        Me.ColumnHeader5 = New System.Windows.Forms.ColumnHeader
        Me.ColumnHeader6 = New System.Windows.Forms.ColumnHeader
        Me.ColumnHeader7 = New System.Windows.Forms.ColumnHeader
        Me.ColumnHeader8 = New System.Windows.Forms.ColumnHeader
        Me.ColumnHeader9 = New System.Windows.Forms.ColumnHeader
        Me.MailingImages = New System.Windows.Forms.ImageList(Me.components)
        Me.SuspendLayout()
        '
        'ActionLabel
        '
        Me.ActionLabel.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.ActionLabel.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.ActionLabel.Location = New System.Drawing.Point(8, 8)
        Me.ActionLabel.Name = "ActionLabel"
        Me.ActionLabel.Size = New System.Drawing.Size(784, 40)
        Me.ActionLabel.TabIndex = 1
        Me.ActionLabel.Text = "All future mailings currently scheduled for this respondent will be cancelled."
        '
        'CancelMailingsButton
        '
        Me.CancelMailingsButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.CancelMailingsButton.FlatStyle = System.Windows.Forms.FlatStyle.System
        Me.CancelMailingsButton.Location = New System.Drawing.Point(696, 248)
        Me.CancelMailingsButton.Name = "CancelMailingsButton"
        Me.CancelMailingsButton.Size = New System.Drawing.Size(88, 23)
        Me.CancelMailingsButton.TabIndex = 2
        Me.CancelMailingsButton.Text = "Cancel Mailings"
        '
        'MailingsLabel
        '
        Me.MailingsLabel.Font = New System.Drawing.Font("Tahoma", 8.25!)
        Me.MailingsLabel.Location = New System.Drawing.Point(8, 48)
        Me.MailingsLabel.Name = "MailingsLabel"
        Me.MailingsLabel.Size = New System.Drawing.Size(152, 23)
        Me.MailingsLabel.TabIndex = 16
        Me.MailingsLabel.Text = "All Mailings:"
        Me.MailingsLabel.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'MailingList
        '
        Me.MailingList.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.MailingList.Columns.AddRange(New System.Windows.Forms.ColumnHeader() {Me.ColumnHeader10, Me.ColumnHeader1, Me.ColumnHeader2, Me.ColumnHeader3, Me.ColumnHeader4, Me.ColumnHeader5, Me.ColumnHeader6, Me.ColumnHeader7, Me.ColumnHeader8, Me.ColumnHeader9})
        Me.MailingList.FullRowSelect = True
        Me.MailingList.GridLines = True
        Me.MailingList.Location = New System.Drawing.Point(8, 72)
        Me.MailingList.Name = "MailingList"
        Me.MailingList.Size = New System.Drawing.Size(776, 136)
        Me.MailingList.SmallImageList = Me.MailingImages
        Me.MailingList.TabIndex = 17
        Me.MailingList.View = System.Windows.Forms.View.Details
        '
        'ColumnHeader10
        '
        Me.ColumnHeader10.Text = ""
        Me.ColumnHeader10.Width = 23
        '
        'ColumnHeader1
        '
        Me.ColumnHeader1.Text = "SentMailId"
        Me.ColumnHeader1.Width = 65
        '
        'ColumnHeader2
        '
        Me.ColumnHeader2.Text = "Litho Code"
        Me.ColumnHeader2.Width = 93
        '
        'ColumnHeader3
        '
        Me.ColumnHeader3.Text = "Mailing Step"
        Me.ColumnHeader3.Width = 121
        '
        'ColumnHeader4
        '
        Me.ColumnHeader4.Text = "StudyId"
        '
        'ColumnHeader5
        '
        Me.ColumnHeader5.Text = "PopId"
        '
        'ColumnHeader6
        '
        Me.ColumnHeader6.Text = "Scheduled Date"
        Me.ColumnHeader6.Width = 94
        '
        'ColumnHeader7
        '
        Me.ColumnHeader7.Text = "Generation Date"
        Me.ColumnHeader7.Width = 95
        '
        'ColumnHeader8
        '
        Me.ColumnHeader8.Text = "Print Date"
        Me.ColumnHeader8.Width = 94
        '
        'ColumnHeader9
        '
        Me.ColumnHeader9.Text = "Mail Date"
        Me.ColumnHeader9.Width = 96
        '
        'MailingImages
        '
        Me.MailingImages.ImageSize = New System.Drawing.Size(16, 16)
        Me.MailingImages.ImageStream = CType(resources.GetObject("MailingImages.ImageStream"), System.Windows.Forms.ImageListStreamer)
        Me.MailingImages.TransparentColor = System.Drawing.Color.Transparent
        '
        'CancelMailingsPanel
        '
        Me.Controls.Add(Me.MailingList)
        Me.Controls.Add(Me.MailingsLabel)
        Me.Controls.Add(Me.CancelMailingsButton)
        Me.Controls.Add(Me.ActionLabel)
        Me.Name = "CancelMailingsPanel"
        Me.Size = New System.Drawing.Size(800, 288)
        Me.ResumeLayout(False)

    End Sub

#End Region

    Public Overrides Sub LoadPanel(ByVal mail As Mailing, ByVal dispo As QDisposition, ByVal receiptMethod As ReceiptType)
        MyBase.LoadPanel(mail, dispo, receiptMethod)
        PopulateMailingsList(Nrc.QualiSys.Library.Mailing.GetMailingsByPopId(mail.PopId, mail.StudyId))
        Me.Enabled = True
    End Sub

    Private Sub PopulateMailingsList(ByVal mailings As System.Collections.ObjectModel.Collection(Of Mailing))
        Me.MailingList.Items.Clear()
        For Each mail As Mailing In mailings
            Dim items(9) As String
            Dim item As New ListViewItem
            If mail.SentMailId = 0 Then
                item.ImageIndex = 1
                items(1) = ""
            Else
                item.ImageIndex = 0
                items(1) = mail.SentMailId.ToString
            End If
            items(2) = mail.LithoCode
            items(3) = mail.MethodologyStepName
            items(4) = mail.StudyId.ToString
            items(5) = mail.PopId.ToString
            items(6) = mail.ScheduledGenerationDate.ToString
            items(7) = IIf(SafeDataReader.IsNull(mail.GenerationDate), "", mail.GenerationDate).ToString
            items(8) = IIf(SafeDataReader.IsNull(mail.PrintDate), "", mail.PrintDate).ToString
            items(9) = IIf(SafeDataReader.IsNull(mail.MailDate), "", mail.MailDate).ToString

            item.SubItems.AddRange(items)
            Me.MailingList.Items.Add(item)
        Next
    End Sub

    Private Sub CancelMailingsButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles CancelMailingsButton.Click
        Me.Mailing.CancelFutureMailings(Me.Disposition.Id, Me.ReceiptType.Id, CurrentUser.UserName)
        Me.OnActionTaken(New ActionTakenEventArgs("All future mailings have been cancelled."))
        Me.Enabled = False
    End Sub
End Class
