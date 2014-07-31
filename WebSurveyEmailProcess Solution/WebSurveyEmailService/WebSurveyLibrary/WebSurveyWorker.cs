using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Microsoft.Exchange.WebServices.Data;
using System.Net;
using System.Net.Mail;
using Nrc.Framework.BusinessLogic.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Diagnostics;
using WebSurveyLibrary.Common;
using System.IO;
using Nrc.Framework.Notification;
using NLog;
using System.Text.RegularExpressions;
using WebSurveyLibrary.Extensions;


namespace WebSurveyLibrary
{

    public enum ResultType
    {
        None,
        Success,
        InvalidEmail,
        MissingWAC,
        NoMatchingWAC,
        Other
    }


    public static class WebSurveyWorker
    {

        private static string mailboxAddress = string.Empty;
        private static ExchangeService service;
        private static string exSvcUrl = string.Empty;
        private static List<WebSurveyError> errorList = new List<WebSurveyError>();
        private static string smtpUserName = string.Empty;
        private static string smtpPassword = string.Empty;
        private static int emailPort = 25;
        private static string emailHost = string.Empty;
        private static NetworkCredential smtpCredential;
        private static SmtpClient smtpClient;


        private static bool InitializeExchangeService()
        {
            try
            {
                // initialize Exchange server
                mailboxAddress = AppConfig.Params["WebSurveyMailBox"].StringValue;
                service = new ExchangeService();
                string password = AppConfig.Params["WebSurveyMailBoxPassword"].StringValue;
                service.Credentials = new WebCredentials(mailboxAddress, password); 
                exSvcUrl = AppConfig.Params["WebSurveyExchangeURL"].StringValue; 
                service.Url = new Uri(exSvcUrl);
                return true;
            }
            catch
            {
                return false;
            }
        }

        public static void DoWork()
        {
            Stopwatch stopwatch = new Stopwatch();
            stopwatch.Start();

            errorList.Clear();
            int messageCount = 0;
            try
            {
                //SMTP relay server - outgoing
                smtpUserName = AppConfig.Params["WebSurveySmtpUserName"] == null ? "" : AppConfig.Params["WebSurveySmtpUserName"].StringValue;
                smtpPassword = AppConfig.Params["WebSurveySmtpPassword"] == null ? "" : AppConfig.Params["WebSurveySmtpPassword"].StringValue; 
                emailPort = AppConfig.Params["WebSurveySmtpPort"].IntegerValue;
                emailHost = AppConfig.Params["WebSurveySmtpHostName"].StringValue;
          
                smtpClient = new SmtpClient(emailHost);
                smtpClient.UseDefaultCredentials = false;

                // if username/password parameters exist, we assume authentication is required, so add credentials.
                if (smtpUserName != string.Empty)
                {
                    smtpCredential = new NetworkCredential(smtpUserName, smtpPassword);
                    
                    smtpClient.Credentials = smtpCredential;
                }

                if (InitializeExchangeService())
                {
                    int messageThrottle = AppConfig.Params["WebSurveyMessageThrottleCount"].IntegerValue;

                    SearchFilter searchFilter = new SearchFilter.IsEqualTo(EmailMessageSchema.IsRead, false);
                    ItemView iv = new ItemView(messageThrottle);

                    foreach (Item item in service.FindItems(WellKnownFolderName.Inbox, searchFilter,iv).Where(x => x is EmailMessage))
                    {
                        EmailMessage message = item as EmailMessage;
                        messageCount += 1;
                        message = EmailMessage.Bind(service, item.Id, new PropertySet(BasePropertySet.IdOnly, ItemSchema.Attachments));

                        // Get the images in the email
                        Dictionary<string, string> imageAttachments = new Dictionary<string, string>();
                        foreach (Microsoft.Exchange.WebServices.Data.Attachment attachment in message.Attachments)
                        {
                            if (attachment is FileAttachment)
                            {
                                FileAttachment fileAttachment = attachment as FileAttachment;
                                if (fileAttachment.IsInline && fileAttachment.ContentType.Contains("image"))
                                {
                                    string fileContentId = fileAttachment.ContentId;
                                    string fileAttachmentName = fileContentId + "_" + fileAttachment.Name;
                                    string file = String.Format(@"c:\temp\{0}", fileAttachmentName);
                                    fileAttachment.Load(file);
                                    imageAttachments.Add(fileContentId, file);
                                }
                            }
                        }

                        message.Load();
                            
                        MessageBody Body = message.Body;
                        string from = message.From.Address;
                        string subject = message.Subject;
                        string strBody = Body.ToString();

                        ResultType result = SendEmail(smtpClient, imageAttachments, from, subject, strBody);

                        // mark original message as read 
                        message.IsRead = true;
                        message.Update(ConflictResolutionMode.AlwaysOverwrite);

                        //message.Move(WellKnownFolderName.DeletedItems);  // move the message to the deleted items folder

                        //to use a folder OTHER than a WellKnowFolderName, you have to do get the folderid of the folder to which you want it moved.
                        string foldername = string.Empty;

                        switch (result)
                        {
                            case ResultType.Success:
                                foldername = "Processed";
                                break;
                            default:
                                foldername = "Failures";
                                break;
                        }

                        FolderId fid = GetFolderId(service, foldername);
                        try
                        {
                            message.Move(fid);
                        }
                        catch
                        {
                            errorList.Add(new WebSurveyError(-1, -1, "", "Unable to move message to " + foldername));
                            Logs.Info("Unable to move message to " + foldername);

                        }

                    }

                    if (errorList.Count > 0)
                    {
                        throw new WebSurveyEmailException(String.Format("Process error(s) occurred, ({0}) messages out of ({1}) did not process.", errorList.Count.ToString(), messageCount.ToString()), errorList);
                    }
                    smtpClient.Dispose();
                }
                else
                {
                    //Console.WriteLine("Unable to initialize Exchange Server. Environment: " + AppConfig.EnvironmentName);
                    Logs.Info("Unable to initialize Exchange Server. Environment: " + AppConfig.EnvironmentName);
                }
            }
            catch (Exception ex)
            {
                Logs.Info("WebSurvey Exception Encountered While Attempting to Process Emails! " + ex.Message);
                SendErrorNotification("WebSurveyEmailService", "Exception Encountered While Attempting to Process Emails!", ex);
            }
            finally
            {
                stopwatch.Stop();
                Logs.Info("WebSurvey Messages processed: " + messageCount.ToString());
                Logs.Info("WebSurvey Message Processing Elapsed Time: " + (stopwatch.ElapsedMilliseconds / 1000).ToString() + " seconds");
            }
        }

        private static ResultType SendEmail(SmtpClient smtpClient,  Dictionary<string, string> imageAttachments, string from, string subject, string strBody)
        {
            int VendorWebFile_Data_ID = -1;
            int Survey_ID = -1;
            string litho = "N/A";
            ResultType result = ResultType.Other;
            try
            {
                string WAC = GetWAC(strBody);

                if (WAC.Length > 0)
                {
                    //Based on Lithocode or WAC retrieve email_address, fname, lname info from QP_PROD.VendorWebFile_Data
                    DataSet ds = QualisysDataProvider.SelectDataByWAC(WAC);

                    if (ds.Tables.Count > 0)
                    {
                        if (ds.Tables[0].Rows.Count > 0)
                        {
                            VendorWebFile_Data_ID = Convert.ToInt32(ds.Tables[0].Rows[0]["VendorWebFile_Data_ID"]);
                            Survey_ID = Convert.ToInt32(ds.Tables[0].Rows[0]["Survey_ID"]);
                            string firstName = ds.Tables[0].Rows[0]["FName"].ToString();
                            string lastName = ds.Tables[0].Rows[0]["LName"].ToString();
                            litho = ds.Tables[0].Rows[0]["Litho"].ToString();

                            // Find/Replace fname, lname tags in message.Body
                            strBody = StringExtensions.Replace(strBody, "[%fname%]", firstName, StringComparison.OrdinalIgnoreCase);
                            strBody = StringExtensions.Replace(strBody, "[%lname%]", lastName, StringComparison.OrdinalIgnoreCase);

                            string mailTo = ds.Tables[0].Rows[0]["Email_Address"].ToString();

                            if (IsValidEmail(mailTo))
                            { 
                                MailMessage mailMessage = new MailMessage();

                                mailMessage.From = new MailAddress(from);
                                mailMessage.To.Add(mailTo);
                                mailMessage.Subject = subject;
                                mailMessage.Body = new MessageBody(BodyType.HTML, strBody);
                                mailMessage.IsBodyHtml = true;

                                foreach (string ContentID in imageAttachments.Keys)
                                {
                                    string file = imageAttachments[ContentID];
                                    System.Net.Mail.Attachment attachment = new System.Net.Mail.Attachment(file);
                                    attachment.ContentDisposition.Inline = true;
                                    attachment.ContentDisposition.DispositionType = System.Net.Mime.DispositionTypeNames.Inline;
                                    attachment.ContentId = ContentID;
                                    attachment.ContentType.MediaType = "image/jpg";
                                    attachment.ContentType.Name = Path.GetFileName(file);
                                    mailMessage.Attachments.Add(attachment);
                                }

                                mailMessage.Headers.Add("X-xsMailingId", "WebSurveyEmailProcess");
                                mailMessage.Headers.Add("X-xsMessageId", Guid.NewGuid().ToString());

                                smtpClient.Send(mailMessage);
                                mailMessage.Dispose();
                                result = ResultType.Success;
                                Logs.Info("Web Survey Successfully sent --> litho: " + litho);
                            }
                            else
                            {
                                errorList.Add(new WebSurveyError(VendorWebFile_Data_ID, Survey_ID, litho, "Invalid Email Address Format."));
                                Logs.Info("Invalid Email Address Format --> litho: " + litho);
                                result = ResultType.InvalidEmail;
                            }
                        }
                        else
                        {
                            errorList.Add(new WebSurveyError(VendorWebFile_Data_ID, Survey_ID, WAC, "No matching Web Access Code."));
                            Logs.Info("No matching Web Access Code --> WAC: " + WAC);
                            result = ResultType.NoMatchingWAC;
                        }
                    }
                    else
                    {
                        errorList.Add(new WebSurveyError(VendorWebFile_Data_ID, Survey_ID, WAC, "No matching Web Access Code."));
                        Logs.Info("No matching Web Access Code --> WAC: " + WAC);
                        result = ResultType.NoMatchingWAC;
                    }
                }
                else
                {
                    errorList.Add(new WebSurveyError(VendorWebFile_Data_ID, Survey_ID, litho, "Web Access Code not found."));
                    Logs.Info("Web Access Code not found in email.");
                    result = ResultType.MissingWAC;
                }
            }
            catch (Exception ex)
            {
                errorList.Add(new WebSurveyError(VendorWebFile_Data_ID, Survey_ID, litho, ex.Message));
                Logs.LogException("Unhandled Exception --> litho:" + litho, ex);
                result = ResultType.Other;
            }
            return result;
        }
     
        /// <summary>
        /// parses the email message to retrieve the WAC
        /// </summary>
        /// <param name="body"></param>
        /// <returns></returns>
        /// 
        private static string GetWAC(string body)
        {
            string wac = string.Empty;

            string startTag = AppConfig.Params["WebSurveyWAC_ElementTag"].StringValue;

            if (body.Contains(startTag))
            {
                int divLeftStart = body.IndexOf(startTag);
                int divLeftEnd = body.IndexOf(">", divLeftStart);
                int divRightStart = body.IndexOf("</", divLeftEnd);

                int wacIndexStart = divLeftEnd + 1;
                int wacLength = divRightStart - wacIndexStart;
                wac = body.Substring(wacIndexStart, wacLength);
            }
            return wac;
        }

        private static FolderId GetFolderId(ExchangeService service, string foldername)
        {
            Folder rootfolder = Folder.Bind(service, WellKnownFolderName.MsgFolderRoot);
            rootfolder.Load();

            FolderId fid = null;

            foreach (Folder folder in rootfolder.FindFolders(new FolderView(100)))
            {
                // This IF limits what folder the program will seek
                if (folder.DisplayName == foldername)
                {
                    // Trust me, the ID is a pain if you want to manually copy and paste it. This stores it in a variable
                    fid = folder.Id;
                }
            }
            return fid;
        }

        private static bool IsValidEmail(string email)
        {

            if (email != string.Empty)
            {
                bool isEmail = Regex.IsMatch(email, @"\A(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?)\Z", RegexOptions.IgnoreCase);

                return isEmail;
            }
            else return false;
        }

        public static void DoCleanup()
        {
            Stopwatch stopwatch = new Stopwatch();
            stopwatch.Start();

            try
            {

                if (InitializeExchangeService())
                {
                    CleanupEmails("Processed");
                    CleanupEmails("Failures");
                }
                else
                {
                    //Console.WriteLine("Unable to initialize Exchange Server. Environment: " + AppConfig.EnvironmentName);
                    Logs.Info("Unable to initialize Exchange Server. Environment: " + AppConfig.EnvironmentName);
                }
            }
            catch (Exception ex)
            {
                Logs.Info("WebSurvey Exception Encountered While Attempting to Cleanup Emails! " + ex.Message);
            }
            finally
            {
                stopwatch.Stop();
                Logs.Info("WebSurvey Message Cleanup Elapsed Time: " + (stopwatch.ElapsedMilliseconds / 1000).ToString() + " seconds");
            }


            
        }

        private static void CleanupEmails(string foldername)
        {
            string paramName = "WebSurveyService" + foldername + "CleanupDays";

            FolderId fid = GetFolderId(service, foldername);

            int DaysToCleanup = AppConfig.Params[paramName].IntegerValue;

            DateTime searchDate = DateTime.Now.AddDays(DaysToCleanup * -1);

            SearchFilter searchFilter = new SearchFilter.IsLessThan(ItemSchema.DateTimeReceived, searchDate);
            ItemView iv = new ItemView(int.MaxValue);

            foreach (Item item in service.FindItems(fid, searchFilter,iv).Where(x => x is EmailMessage))
            {
                EmailMessage message = item as EmailMessage;
                message.Delete(DeleteMode.HardDelete);
            }
        }

        private static void SendErrorNotification(string serviceName, string errorMessage, Exception ex)
        {
            List<string> toList = new List<string>();
            List<string> ccList = new List<string>();
            List<string> bccList = new List<string>();
            string recipientNoteText = string.Empty;
            string recipientNoteHtml = string.Empty;
            string environmentName = string.Empty;
            string sqlCommand = string.Empty;
            string exceptionText = string.Empty;
            string exceptionHtml = string.Empty;
            string stackHtml = string.Empty;
            string stackText = string.Empty;
            string innerStackHtml = string.Empty;
            string innerStackText = string.Empty;
            string bodyText = string.Empty;
            string fileName = string.Empty;

            try
            {

                string sendTo = AppConfig.Params["WebSurveySendErrorNotificationTo"].StringValue;
                string sendBcc = AppConfig.Params["WebSurveySendErrorNotificationBcc"].StringValue;

                toList.Add(sendTo);
                bccList.Add(sendBcc);

                if (AppConfig.EnvironmentType != EnvironmentTypes.Production)
                {
                    // not in production
                    recipientNoteText = String.Format("{0}{0}Production To:{0}", System.Environment.NewLine);
                    foreach (string email in toList)
                    {
                        recipientNoteText += email;
                    }

                    recipientNoteText += String.Format("{0}Production CC:{0}", System.Environment.NewLine);
                    foreach (string email in ccList)
                    {
                        recipientNoteText += email;
                    }

                    recipientNoteText += String.Format("{0}Production BCC:{0}", System.Environment.NewLine);
                    foreach (string email in bccList)
                    {
                        recipientNoteText += email;
                    }
                    recipientNoteHtml = recipientNoteText.Replace(System.Environment.NewLine, "<BR>");

                    toList.Clear();
                    ccList.Clear();
                    bccList.Clear();

                    toList.Add(sendBcc);
                    environmentName = String.Format("({0})", AppConfig.EnvironmentName);
                }


                if (ex.GetType() == typeof(WebSurveyEmailException))
                {
                    WebSurveyEmailException webEx = (WebSurveyEmailException)ex;
                    exceptionText = webEx.Message + WebSurveyError.GetErrorTableText(webEx.ErrorList);
                    exceptionHtml = webEx.Message.Replace(System.Environment.NewLine, "<BR>") + WebSurveyError.GetErrorTableHtml(webEx.ErrorList);
                }
                else
                {
                    exceptionText = ex.Message;
                    exceptionHtml = ex.Message.Replace(System.Environment.NewLine, "<BR>");
                }

                if (ex.StackTrace != null)
                {
                    stackText = ex.StackTrace;

                    stackHtml = ex.StackTrace.Replace("   at", "<BR>&nbsp;&nbsp;at");
                    if (stackHtml.StartsWith("<BR>&nbsp;&nbsp;at"))
                    {
                        stackHtml = stackHtml.Substring("<BR>".Length);
                    }
                }
                else
                {
                    stackText = "N/A";
                    stackHtml = "N/A";
                }

                if (ex.InnerException != null)
                {
                    Exception innerEx = ex.InnerException;
                    while (innerEx != null)
                    {
                        if (innerStackText.Length > 0)
                        {
                            innerStackText += System.Environment.NewLine;
                            innerStackHtml += "<BR>";
                        }

                        if (innerEx.Message != null || innerEx.StackTrace != null)
                        {
                            innerStackText += "--------Inner Exception--------" + System.Environment.NewLine;
                            innerStackHtml += "--------Inner Exception--------<BR>";

                            if (innerEx.Message != null)
                            {
                                innerStackText += innerEx.Message + System.Environment.NewLine;
                                innerStackHtml += innerEx.Message.Replace(System.Environment.NewLine, "<BR>") + "<BR>";
                            }

                            if (innerEx.StackTrace != null)
                            {
                                innerStackText += innerEx.StackTrace + System.Environment.NewLine;
                                innerStackHtml += innerEx.StackTrace.Replace("   at", "<BR>&nbsp;&nbsp;at") + "<BR>";
                            }
                        }

                        innerEx = innerEx.InnerException;
                    }
                }
                else
                {
                    innerStackText = "N/A";
                    innerStackHtml = "--------Inner Exception--------<BR>N/A<BR>-------------------------------";
                }

                string smtpServer = AppConfig.SMTPServer;
                //Message mailMessage = new Message("WebSurveyEmailServiceException", AppConfig.SMTPServer);
                Message mailMessage = new Message("TransferResultsServiceException", AppConfig.SMTPServer);


                foreach (string email in toList)
                {
                    mailMessage.To.Add(email);
                }

                foreach (string email in ccList)
                {
                    mailMessage.Cc.Add(email);
                }

                foreach (string email in bccList)
                {
                    mailMessage.Bcc.Add(email);
                }

                mailMessage.ReplacementValues.Add("ServiceName", serviceName);
                mailMessage.ReplacementValues.Add("Environment", environmentName);
                mailMessage.ReplacementValues.Add("Message", errorMessage);
                mailMessage.ReplacementValues.Add("DateOccurred", DateTime.Now.ToString());
                mailMessage.ReplacementValues.Add("MachineName", Environment.MachineName);
                mailMessage.ReplacementValues.Add("ExceptionText", exceptionText);
                mailMessage.ReplacementValues.Add("ExceptionHtml", exceptionHtml);
                mailMessage.ReplacementValues.Add("Source", ex.Source);
                mailMessage.ReplacementValues.Add("SQLCommand", sqlCommand);
                mailMessage.ReplacementValues.Add("StackTraceHtml", stackHtml);
                mailMessage.ReplacementValues.Add("StackTraceText", stackText);
                mailMessage.ReplacementValues.Add("InnerExceptionHtml", innerStackHtml + recipientNoteHtml);
                mailMessage.ReplacementValues.Add("InnerExceptionText", innerStackText + recipientNoteText);
                mailMessage.ReplacementValues.Add("FileName", fileName);

                //Merge the template
                mailMessage.MergeTemplate();

                bodyText = mailMessage.BodyText;

                mailMessage.Send();
            }
            catch (Exception ex1)
            {
                throw ex1;
                //return String.Format("Exception encountered while attempting to send Exception Email!{0}{0}{1}{0}{0}Source: {2}{0}{0}Stack Trace:{0}{3}{0}{0}Original Exception{0}{0}{4}{0}{0}Source: {5}{0}{0}Stack Trace:{0}{6}{0}{0}Email Exception{0}{0}{7}", System.Environment.NewLine, ex1.Message, ex1.Source, ex1.StackTrace, ex.Message, ex.Source, ex.StackTrace, bodyText);
            }
        }

    }
}
