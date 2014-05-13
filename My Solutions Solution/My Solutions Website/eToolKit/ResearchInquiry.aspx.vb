Imports Nrc.DataMart.MySolutions.Library
Imports System.Net.Mail

Partial Public Class eToolKit_ResearchInquiry
    Inherits ToolKitPage

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            'PopulateTopics()
            PopulateQuestions()
        End If
    End Sub

    Private Sub PopulateQuestions()

        Dim sr As New System.IO.StreamReader(Server.MapPath("HCAHPS_Questions.txt"))

        Dim LineIn As String

        Me.ddlQuestionReferenced.Items.Clear()

        Do Until sr.EndOfStream
            LineIn = sr.ReadLine
            ddlQuestionReferenced.Items.Add(LineIn)
        Loop

    End Sub

    'Private Sub PopulateTopics()
    '    ddlQuestionReferenced.Items.Clear()
    '    Dim rdr As IDataReader = Legacy.ToolkitServer.GetDimensions(4)
    '    ddlQuestionReferenced.DataSource = rdr
    '    ddlQuestionReferenced.DataTextField = "strTKDimension_nm"
    '    ddlQuestionReferenced.DataValueField = "TKDimension_id"
    '    ddlQuestionReferenced.DataBind()

    '    ddlQuestionReferenced.Items.Add(New ListItem("Other", "0"))
    'End Sub


    Protected Sub SubmitButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SubmitButton.Click
        If Page.IsValid Then
            SendMail()
        End If
    End Sub

    Private Sub SendMail()
        Dim body As New System.Text.StringBuilder
        Dim msg As New MailMessage

        body.Append("<table>")
        body.AppendFormat("<tr><td>User:</td><td>{0}</td></tr>", User.Identity.Name)
        body.AppendFormat("<tr><td>Client:</td><td>{0}</td></tr>", CurrentUser.SelectedGroup.Name)
        body.AppendFormat("<tr><td>Name:</td><td>{0} {1}</td></tr>", txtFName.Text, txtLName.Text)
        body.AppendFormat("<tr><td>Title:</td><td>{0}</td></tr>", txtTitle.Text)
        body.AppendFormat("<tr><td>Organization:</td><td>{0}</td></tr>", txtOrganization.Text)
        body.AppendFormat("<tr><td>Phone:</td><td>{0}</td></tr>", txtPhone.Text)
        body.AppendFormat("<tr><td>Email:</td><td>{0}</td></tr>", txtEmail.Text)
        body.AppendFormat("<tr><td>Preferred Method of Contact:</td><td>{0}</td></tr>", Me.rdbContactMethod.SelectedItem.Text)
        body.AppendFormat("<tr><td>Question Referenced:</td><td>{0}</td></tr>", ddlQuestionReferenced.SelectedItem.Text)
        body.AppendFormat("<tr><td valign='top'>Problem Statement:</td><td valign='top'>{0}</td></tr>", txtProblemStatement.Text)
        body.AppendFormat("<tr><td valign='top'>Background:</td><td valign='top'>{0}</td></tr>", txtBackground.Text)
        body.Append("</table>")

        msg.To.Add(Config.ResearchInquiryEmail)
        msg.From = New MailAddress("eToolKit@NationalResearch.com")
        msg.Subject = "Research Inquiry Submission"

        'If testing or development, add environment name in subject line of email
        Select Case Config.EnvironmentName
            Case "Development"
                msg.Subject += " (Development)"
            Case "Testing"
                msg.Subject += " (Testing)"
        End Select

        msg.IsBodyHtml = True
        msg.Body = body.ToString
        msg.Priority = MailPriority.High

        Dim smtp As New SmtpClient(Config.SmtpServer)
        smtp.Send(msg)

        Me.ResearchInquiryDiv.Visible = False
        Me.ConfirmationDiv.Visible = True

        If Request.QueryString("ReturnPath") Is Nothing Then
            btnReturn.NavigateUrl = "~/eToolKit/Default.aspx"
        Else
            btnReturn.NavigateUrl = Request.QueryString("ReturnPath")
        End If
    End Sub

    Private Sub ddlQuestionReferenced_PreRender(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlQuestionReferenced.PreRender

        Me.ddlQuestionReferenced.ToolTip = Me.ddlQuestionReferenced.Text
        Me.ddlQuestionReferenced.Attributes.Add("onChange", Me.divFullQuestionDisplay.ClientID & ".style.display='block';" & Me.divFullQuestionDisplay.ClientID & ".innerText=this.value;this.title=this.value;")

    End Sub

End Class