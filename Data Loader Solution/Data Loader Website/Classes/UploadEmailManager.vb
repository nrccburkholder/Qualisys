Imports System.Net.Mail
Imports NRC.DataLoader.Library
Imports NRC.NRCAuthLib
Imports NRC.Framework.BusinessLogic.Configuration

''' <summary>
''' This Class Sends notification emails about file upload success or failure to the teams.
''' It has only one public shared method which takes the UploadFile object and Upload status and
''' sends one email per package+file combination.
''' </summary>
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
Public Class UploadEmailManager
#Region "Email"
    ''' <summary>
    ''' Creates Infos collection using passed parameters. Infos collection gets all the required info for the current email.
    ''' </summary>
    ''' <param name="UploadedFile">UploadFile object</param>
    ''' <param name="eMailType">Enum: can have UploadFailed or UploadSuccessful values.</param>
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
    Public Shared Sub NotifyTeam(ByVal UploadedFile As UploadFile, ByVal eMailType As UploadNotificationMailType)
        Dim Infos As New EmailInfoCollection(UploadedFile, eMailType, UploadFileTypeAction.AvailableActions.Packages)
        'eMailInfo is a container class that has all the information for one email

        For Each Info As eMailInfo In Infos
            Try
                SendEmail(Info)
            Catch

                'uploadedfile.UploadFileState = 'new status
                UploadedFile.Save()
            
            End Try

        Next
    End Sub
    ''' <summary>Takes an Info object that has all of the information to insert into the body of the email.</summary>
    ''' <param name="Info"></param>
    ''' <CreateBy>Arman Mnatsakanyan</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Shared Sub SendEmail(ByVal Info As eMailInfo)
        Dim eMailTo As String
        Dim mail As New MailMessage
        Dim body As String

        eMailTo = Info.OwnerEmail

        body = ToHtml(Info, eMailTo)
        If Config.EnvironmentType = EnvironmentTypes.Production Then
            mail.To.Add(eMailTo)
        Else
            mail.To.Add(Config.LoadingTeamTestEmailAddress)
        End If

        mail.From = New MailAddress(Config.ClientSupportEmailAddress)
        Dim SB As New StringBuilder
        If Info.EMailType = UploadNotificationMailType.UploadFailed Then
            SB.Append("File Upload Failed (")
        Else
            SB.Append("New File Receipt (")
        End If
        SB.Append(Info.ClientName)
        SB.Append(")")
        mail.Subject = SB.ToString()

        If Not Config.EnvironmentType = EnvironmentTypes.Production Then
            mail.Subject &= " (" & Config.EnvironmentName & ")"
        End If

        mail.Body = body
        mail.IsBodyHtml = True

        'Add some error handling in case email can't be sent.
        'Give better error message.
        Try
            Dim SmtpServer As New SmtpClient(Config.SmtpServer)
            SmtpServer.Send(mail)
        Catch ex As Exception
            Dim msg As String
            msg = "Notification/Mail Failure: " & vbCrLf
            If Not mail Is Nothing Then
                msg &= "To: " & mail.To.ToString & vbCrLf
                msg &= "From: " & mail.From.ToString & vbCrLf
                msg &= "Subject: " & mail.Subject & vbCrLf
                msg &= ex.Message
            End If

            Throw New ApplicationException(msg, ex)

        End Try

    End Sub
    ''' <summary>Builds the HTML body for the email</summary>
    ''' <param name="Info">Info object that has the necessary properties to insert into the html body.</param>
    ''' <param name="emailto">the mail recepient(s)</param>
    ''' <returns>eMail body</returns>
    ''' <CreateBy>Arman Mnatsakanyan</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Shared Function ToHtml(ByVal Info As eMailInfo, ByVal emailto As String) As String
        Dim body As New Text.StringBuilder
        Dim tableStyle As String = "{background-color: #660099; font-family: Tahoma, Verdana, Arial; font-size:X-Small;}"
        Dim headerStyle As String = "{Text-Align: Center; Color: #FFFFFF; font-weight:Bold;font-size:medium;padding: 3px;filter:progid:DXImageTransform.Microsoft.gradient(enabled='true', startColorstr=#cc66ff, endColorstr=#663399);progid:DXImageTransform.Microsoft.Blur(pixelradius=1)}"
        Dim labelStyle As String = "{background-color: #CC99FF;White-space: nowrap; padding: 5px; font-weight: bold}"
        Dim dataStyle As String = "{background-color: #ccccff;Width: 100%; padding: 5px; White-space: nowrap}"
        Dim infostyle As String = "{background-color: #FFFFFF; padding: 5px}"
        Dim message As String = String.Empty

        If Info.EMailType = UploadNotificationMailType.UploadFailed Then
            message = _
            "File " & Info.OriginalFileName & " has failed to upload. <BR><BR>For more information, please contact the <a href=""mailto:" & Config.ClientSupportEmailAddress & """>Client Support Group</a>."
        ElseIf Info.EMailType = UploadNotificationMailType.UploadSuccessful Then
            message = "File " & Info.OriginalFileName & " has uploaded successfully and saved as " & Info.UploadedFile.FileName & " <BR><BR>For more information, please contact the <a href=""mailto:" & Config.ClientSupportEmailAddress & """>Client Support Group</a>."
        End If

        body.Append("<HTML>")
        body.Append("<HEAD>")
        body.Append("<STYLE>")
        body.AppendFormat(".NotifyTable{0}", tableStyle)
        body.AppendFormat(".HeaderRow{0}", headerStyle)
        body.AppendFormat(".LabelCell{0}", labelStyle)
        body.AppendFormat(".DataCell{0}", dataStyle)
        body.AppendFormat(".InfoCell{0}", infostyle)
        body.Append("</STYLE>")
        body.Append("</HEAD>")

        body.Append("<BODY>")
        body.Append("<TABLE Class=""NotifyTable"" Width=""100%"" cellpadding=""0"" cellspacing=""1"">")
        body.Append("<TR><TD Class=""HeaderRow"" Colspan=""2"">Upload File Notification</TD></TR>")
        body.AppendFormat("<TR><TD Class=""LabelCell"">To:</TD><TD Class=""DataCell"">{0}</TD></TR>", emailto)
        body.AppendFormat("<TR><TD Class=""LabelCell"">Client Name:</TD><TD Class=""DataCell"">{0} ({1})</TD></TR>", _
            Info.ClientName, Info.Study.ClientID)
        body.AppendFormat("<TR><TD Class=""LabelCell"">User Name:</TD><TD Class=""DataCell"">{0}</TD></TR>", Info.UserName)
        body.AppendFormat("<TR><TD Class=""LabelCell"">Study Name:</TD><TD Class=""DataCell"">{0} ({1})</TD></TR>", _
            Info.StudyName, Info.Study.StudyID)
        body.AppendFormat("<TR><TD Class=""LabelCell"">Upload Date:</TD><TD Class=""DataCell"">{0}</TD></TR>", Info.UploadDate)

        'File list table
        body.Append("<TR><TD Class=""LabelCell"" valign=""Top"">Uploaded File: </TD><TD Class=""InfoCell"" Colspan=""1"">")
        body.Append("<TABLE Class=""NotifyTable"" cellpadding=""0"" cellspacing=""1"">")
        body.Append("<TR><TD Class=""LabelCell"">Package</TD><TD Class=""LabelCell"">File Name</TD><TD Class=""LabelCell"">Saved As</TD></TR>")

        body.AppendFormat("<TR><TD Class=""DataCell"">{0} ({1})</TD><TD Class=""DataCell"">{2} </TD><TD Class=""DataCell"">{3}</TD></TR>", _
        Info.PackageName, Info.UsedDTSPackage.PackageID, Info.OriginalFileName, Info.UploadedFile.FileName)

        body.Append("</TABLE></TD></TR>")
        'End File list table

        body.AppendFormat("<TR><TD Class=""InfoCell"" Colspan=""2"">{0}</TD></TR>", message)
        body.Append("</TABLE>")

        body.Append("</BODY>")
        body.Append("</HTML>")

        Return body.ToString

    End Function

#End Region

End Class
