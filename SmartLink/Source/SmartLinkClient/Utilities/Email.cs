using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Net;
using System.Net.Mail;
using NRC.SmartLink.Common;

namespace Utilities
{
    /// <summary>
    /// Common Utility Functions
    /// </summary>
    public static class Email
    {
        #region Public Enums

        /// <summary>
        /// Email Priority Level
        /// </summary>
        public enum PriorityLevel
        {
            Normal,
            Low,
            High
        }

        #endregion Public Enums

        #region Public Static Properties

        public static string SMTPHost { get; set; }

        public static string EmailFrom { get; set; }

        public static string EmailTo { get; set; }

        public static string EmailUserName { get; set; }

        public static string EmailEncryptedPassword { get; set; }

        #endregion Public Static Properties

        #region Send Mail

        /// <summary>
        /// Send email with all known email properties already set
        /// </summary>
        public static void SendMail(string body)
        {
            SendMail(body, PriorityLevel.Normal);
        }

        /// <summary>
        /// Send email with known email properties already set
        /// </summary>
        public static void SendMail(string subject, string body)
        {
            SendMail(subject, body, PriorityLevel.Normal);
        }

        /// <summary>
        /// Send an email with an Exception
        /// </summary>
        public static void SendMail(string body, Exception ex)
        {
            if (ex != null)
                SendMail(string.Format("Error: {0}", System.Reflection.Assembly.GetExecutingAssembly().GetName().Name), string.Format("{0}\n\nError:  {1}", body, ex.ToString()), PriorityLevel.High);
            else
                SendMail(string.Format("Error: {0}", System.Reflection.Assembly.GetExecutingAssembly().GetName().Name), body, PriorityLevel.High);
        }

        /// <summary>
        /// Send email with all known email properties already set
        /// </summary>
        public static void SendMail(string body, PriorityLevel priority)
        {
            SendMail(string.Format("Info: {0}", System.Reflection.Assembly.GetExecutingAssembly().GetName().Name), body, priority);
        }

        /// <summary>
        /// Send an email with an Exception
        /// </summary>
        public static void SendMail(string subject, string body, Exception ex)
        {
            SendMail(subject, string.Format("{0}\n\nError:  {1}", body, ex.ToString()));
        }

        /// <summary>
        /// Send email with priority level and with known email properties already set
        /// </summary>
        public static void SendMail(string subject, string body, PriorityLevel priority)
        {
            SendMail(SMTPHost, EmailFrom, EmailTo, EmailUserName, EmailEncryptedPassword, subject, body, false, priority, null);
        }

        /// <summary>
        /// Send out an email without attachments
        /// </summary>
        public static void SendMail(string smtpHost, string from, string to, string userName, string encryptedPassword, string subject, string body)
        {
            SendMail(smtpHost, from, to, userName, encryptedPassword, subject, body, null);
        }

        /// <summary>
        /// Send out an email without attachments but with a Priority Level
        /// </summary>
        public static void SendMail(string smtpHost, string from, string to, string userName, string encryptedPassword, string subject, string body, PriorityLevel priority)
        {
            SendMail(smtpHost, from, to, userName, encryptedPassword, subject, body, false, priority, null);
        }

        /// <summary>
        /// Send an email with attachments
        /// </summary>
        public static void SendMail(string smtpHost, string from, string to, string userName, string encryptedPassword, string subject, string body, params string[] attachmentFiles)
        {
            SendMail(smtpHost, from, to, userName, encryptedPassword, subject, body, false, PriorityLevel.Normal, attachmentFiles);
        }

        /// <summary>
        /// Send an email with attachments, As Html, or set the Priority Level
        /// </summary>
        public static void SendMail(string smtpHost, string from, string to, string userName, string encryptedPassword, string subject, string body, bool isHtmlBody, PriorityLevel priority, params string[] attachmentFiles)
        {
            try
            {
                string[] strTo = null;
                string AttachmentFileNames = string.Empty;
                string seperator = string.Empty;
                bool userNameAndPassword = !string.IsNullOrWhiteSpace(userName);

                // Check if we need to use our defaults
                if (string.IsNullOrWhiteSpace(from))
                {
                    from = EmailFrom;
                }
                
                // Do not continue if we are missing any of these paramaters
                if (string.IsNullOrWhiteSpace(from) || string.IsNullOrWhiteSpace(to))
                {
                    return;
                }

                // Check for required parameters
                if (string.IsNullOrWhiteSpace(smtpHost))
                {
                    throw new ArgumentException("SMTP Host is a required setting for sending emails.");
                }

                if (userNameAndPassword)
                {
                    if (string.IsNullOrWhiteSpace(encryptedPassword))
                    {
                        throw new ArgumentException("SMTP Host User Password is a required setting for sending emails if a Username has been defined.");
                    }
                }

                MailMessage objMessage = new MailMessage();
                try
                {
                    strTo = to.Split(",;".ToCharArray());

                    for (int x = 0; x < strTo.Count(); x++)
                    {
                        objMessage.To.Add(strTo[x]);
                    }

                    objMessage.Subject = subject;
                    objMessage.Body = body;
                    objMessage.From = new System.Net.Mail.MailAddress(from);
                    objMessage.IsBodyHtml = isHtmlBody;
                    switch (priority)
                    {
                        case PriorityLevel.Low:
                            objMessage.Priority = MailPriority.Low;
                            break;
                        case PriorityLevel.High:
                            objMessage.Priority = MailPriority.High;
                            break;
                    }

                    // Add attachment if valid file passed down
                    // TODO: Make this split on ; and parse out multiple files...or pass in an array
                    if (attachmentFiles != null)
                    {
                        for (int i = 0; i < attachmentFiles.Count(); i++)
                        {
                            if (System.IO.File.Exists(attachmentFiles[i]))
                            {
                                objMessage.Attachments.Add(new System.Net.Mail.Attachment(attachmentFiles[i]));
                                // Store the File Names
                                AttachmentFileNames += seperator + attachmentFiles[i];
                                if (string.IsNullOrEmpty(seperator)) seperator = "\n";
                            }
                        }
                    }

                    var objSMTP = new SmtpClient(smtpHost);

                    if (userNameAndPassword)
                    {
                        string password = Encryption.DecryptString(encryptedPassword, "I_Love_The_Portal_@_Outcome_Concept_Systems_!");
                        objSMTP.UseDefaultCredentials = false;
                        objSMTP.Credentials = new NetworkCredential(userName, password);
                    }

                    objSMTP.Send(objMessage);

                    Console.WriteLine("Email Sent!");

                }
                catch (Exception e)
                {
                    e.Data["Utilities.Email.SendMail()::SMTPHost"] = SMTPHost;
                    e.Data["Utilities.Email.SendMail()::To"] = to;
                    e.Data["Utilities.Email.SendMail()::Subject"] = subject;
                    e.Data["Utilities.Email.SendMail()::From"] = from;
                    e.Data["Utilities.Email.SendMail()::Body"] = body;
                    e.Data["Utilities.Email.SendMail()::AttachmentFile"] = (attachmentFiles != null) ? string.Join(", ", attachmentFiles) : "none";

                    throw;
                }
                finally 
                {
                    objMessage.Dispose();
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine("Unable to send Email.");
                // Unable to send email
                Log.WriteError(string.Format("Unable to send the following email: {0}SMTPHost: {1}{0}To: {2}{0}Subject: {3}{0}From: {4}{0}Body:{0}{7}{0}{5}{0}{7}{0}AttachmentFile: {6}{0}Error: "
                                                        , Environment.NewLine
                                                        , SMTPHost
                                                        , to
                                                        , subject
                                                        , from
                                                        , body
                                                        , (attachmentFiles != null) ? string.Join(", ", attachmentFiles) : "none"
                                                        , "================================================================================"),
                                                        ex);
            }
        }

        #endregion Send Mail
    }
}
