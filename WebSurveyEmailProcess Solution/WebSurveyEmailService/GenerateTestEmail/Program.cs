using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Net;
using System.Net.Mail;
using WebSurveyLibrary;
using System.Data;
using System.Data.Common;
using System.Data.SqlClient;
using Microsoft.Exchange.WebServices.Data;


namespace GenerateTestEmail
{
    class Program
    {

        private static string mailboxAddress = "CASurveyTest@nrcpicker.com";
        private static string exSvcUrl = string.Empty;
        private static string smtpUserName = "server10161";
        private static string smtpPassword = "Wn3z8YSx56Ccg7AQs";
        private static int emailPort = 25;
        private static string emailHost = "smtp.socketlabs.com";
        private static NetworkCredential smtpCredential;
        private static SmtpClient smtpClient;
        private static string strBody = "<html>\r\n<head>\r\n<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">\r\n<meta name=\"Generator\" content=\"Microsoft Word 15 (filtered medium)\">\r\n<style><!--\r\n/* Font Definitions */\r\n@font-face\r\n\t{font-family:\"Cambria Math\";\r\n\tpanose-1:2 4 5 3 5 4 6 3 2 4;}\r\n@font-face\r\n\t{font-family:Calibri;\r\n\tpanose-1:2 15 5 2 2 2 4 3 2 4;}\r\n/* Style Definitions */\r\np.MsoNormal, li.MsoNormal, div.MsoNormal\r\n\t{margin:0in;\r\n\tmargin-bottom:.0001pt;\r\n\tfont-size:11.0pt;\r\n\tfont-family:\"Calibri\",sans-serif;}\r\na:link, span.MsoHyperlink\r\n\t{mso-style-priority:99;\r\n\tcolor:#0563C1;\r\n\ttext-decoration:underline;}\r\na:visited, span.MsoHyperlinkFollowed\r\n\t{mso-style-priority:99;\r\n\tcolor:#954F72;\r\n\ttext-decoration:underline;}\r\nspan.EmailStyle17\r\n\t{mso-style-type:personal-compose;\r\n\tfont-family:\"Calibri\",sans-serif;\r\n\tcolor:windowtext;}\r\n.MsoChpDefault\r\n\t{mso-style-type:export-only;\r\n\tfont-family:\"Calibri\",sans-serif;}\r\n@page WordSection1\r\n\t{size:8.5in 11.0in;\r\n\tmargin:1.0in 1.0in 1.0in 1.0in;}\r\ndiv.WordSection1\r\n\t{page:WordSection1;}\r\n--></style><!--[if gte mso 9]><xml>\r\n<o:shapedefaults v:ext=\"edit\" spidmax=\"1026\" />\r\n</xml><![endif]--><!--[if gte mso 9]><xml>\r\n<o:shapelayout v:ext=\"edit\">\r\n<o:idmap v:ext=\"edit\" data=\"1\" />\r\n</o:shapelayout></xml><![endif]-->\r\n</head>\r\n<body lang=\"EN-US\" link=\"#0563C1\" vlink=\"#954F72\">\r\n<div class=\"WordSection1\">\r\n<p class=\"MsoNormal\"><meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\"><span style=\"font-size: 12px; font-family: arial;\"></span><p style=\"margin: 0cm 0cm 0.0001pt 36pt;\"><span style=\"padding: 0cm; font-size: 10pt; border: 1pt none windowtext;\r\n font-family: Arial, sans-serif;\">Welcome to the 2015 Employee Engagement Survey. As a valued employee, we would like your feedback.</span></p><p style=\"margin: 0cm 0cm 0.0001pt 36pt;\"><span style=\"padding: 0cm; font-size: 10pt; border: 1pt none windowtext;\r\n font-family: Arial, sans-serif;\">&nbsp;</span></p><p style=\"margin: 0cm 0cm 0.0001pt 36pt;\"><span style=\"padding: 0cm; font-size: 10pt; border: 1pt none windowtext; font-family: Arial, sans-serif;\">We hope that you will take the opportunity to add your voice\r\n to your colleagues?so that we can create a better, stronger healthcare organization and a more positive work environment. Data from this survey will provide the foundation for discussions about SickKids?strengths and opportunities for improvement.&nbsp; Leaders\r\n will work with their staff to identify priorities and develop/implement action plans designed to enhance the work experience for people at SickKids. &nbsp;&nbsp;</span></p><p style=\"margin: 0cm 0cm 0.0001pt 36pt;\"><span style=\"padding: 0cm; font-size: 10pt;\r\n border: 1pt none windowtext; font-family: Arial, sans-serif;\">&nbsp;</span></p><p style=\"margin: 0cm 0cm 0.0001pt 36pt;\"><span style=\"padding: 0cm; font-size: 10pt; border: 1pt none windowtext; font-family: Arial, sans-serif;\">To ensure confidentiality and\r\n anonymity, we have partnered with National Research Corporation Canada (NRCC), a leader in healthcare analytics, patient satisfaction measurement, and organizational improvement, to distribute the survey and analyze SickKids?employee engagement survey results.</span></p><p\r\n style=\"margin: 0cm 0cm 0.0001pt 36pt;\"><span style=\"padding: 0cm; font-size: 10pt; border: 1pt none windowtext; font-family: Arial, sans-serif;\">&nbsp;</span></p><p style=\"margin: 0cm 0cm 0.0001pt 36pt;\"><span style=\"padding: 0cm; font-size: 10pt; border:\r\n 1pt none windowtext; font-family: Arial, sans-serif;\">The survey should take approximately 15 minutes and will be available from September 14 to October 4, 2015 (survey closes at 11:59 p.m.). All responses will remain confidential and anonymous and will only\r\n be reported where a group has at least 5 responses.</span></p><p style=\"margin: 0cm 0cm 0.0001pt 36pt;\"><span style=\"padding: 0cm; font-size: 10pt; border: 1pt none windowtext; font-family: Arial, sans-serif;\">&nbsp;</span></p><p style=\"margin: 0cm 0cm 0.0001pt\r\n 36pt;\"><span style=\"padding: 0cm; font-size: 10pt; border: 1pt none windowtext; font-family: Arial, sans-serif;\">To begin the survey, please click on the link below:<strong><span style=\"color: #0070c0;\">&nbsp;<a href=\"https://www.nrcsurveyor.net/se.ashx?s=2511374564297B8F\">Employee\r\n Engagement Survey</a></span></strong></span></p><p style=\"margin: 0cm 0cm 0.0001pt 36pt;\"><span style=\"padding: 0cm; font-size: 10pt; border: 1pt none windowtext; font-family: Arial, sans-serif;\">Your personal web access code is:<strong><span style=\"color:\r\n #00b050;\">{0}</span></strong></span></p><p style=\"margin: 0cm 0cm 0.0001pt 36pt;\"><span style=\"padding: 0cm; font-size: 10pt; border: 1pt none windowtext; font-family: Arial, sans-serif;\">&nbsp;</span></p><p style=\"margin: 0cm 0cm 0.0001pt 36pt;\"><span\r\n style=\"padding: 0cm; font-size: 10pt; border: 1pt none windowtext; font-family: Arial, sans-serif;\">If you need assistance in completing the survey or have questions, please talk to your leader or send a note to&nbsp;<a href=\"mailto:employee.engagement@sickkids.ca\"><span\r\n style=\"color: #0070c0;\">employee.engagement@sickkids.ca</span></a><span style=\"color: #0070c0;\">.</span></span></p><p style=\"margin-bottom: 0.0001pt;\"><span style=\"padding: 0cm; font-size: 9pt; border: 1pt none windowtext; font-family: Arial, sans-serif; color:\r\n #1f497d;\">&nbsp;</span></p><p style=\"margin: 0cm 0cm 0.0001pt 36pt;\"><span style=\"padding: 0cm; font-size: 10pt; border: 1pt none windowtext; font-family: Arial, sans-serif;\">Thank you for taking the time to share your feedback and for all you do for our organization\r\n each and every day.</span></p><p style=\"margin: 0cm 0cm 0.0001pt 36pt;\"><span style=\"padding: 0cm; font-size: 10pt; border: 1pt none windowtext; font-family: Arial, sans-serif;\">&nbsp;</span></p><p style=\"margin: 0cm 0cm 0.0001pt 36pt;\"><span style=\"padding:\r\n 0cm; font-size: 10pt; border: 1pt none windowtext; font-family: Arial, sans-serif;\">&nbsp;</span></p><p style=\"margin: 0cm 0cm 0.0001pt 36pt;\"><span style=\"padding: 0cm; font-size: 10pt; border: 1pt none windowtext; font-family: Arial, sans-serif;\">Sincerely,</span></p><p\r\n style=\"margin: 0cm 0cm 0.0001pt 36pt;\"><span style=\"padding: 0cm; font-size: 10pt; border: 1pt none windowtext; font-family: Arial, sans-serif;\">SickKids Engagement Team</span></p><div class=\"qualisyswac\" style=\"display: none; visibility: hidden;\">{1}</div><o:p></o:p></p>\r\n</div>\r\n</body>\r\n</html>\r\n";
        private static List<string> wacList;
        private static int loopCnt = 3;


        static void Main(string[] args)
        {

            Console.WriteLine("Exchange Web Services : Generate Test Messages");
            Console.WriteLine();
            Console.WriteLine("Press ENTER to begin.");
            Console.ReadLine();
            Start();
            Console.WriteLine("End of Processing");
            Console.WriteLine("Press ENTER to exit.");
            Console.ReadLine();
            Console.WriteLine("Exiting application...");

        }


        private static void Start()
        {
            smtpClient = new SmtpClient(emailHost);
            smtpClient.UseDefaultCredentials = false;

            // if username/password parameters exist, we assume authentication is required, so add credentials.
            if (smtpUserName != string.Empty)
            {
                smtpCredential = new NetworkCredential(smtpUserName, smtpPassword);

                smtpClient.Credentials = smtpCredential;
            }

            CreateWACList();

            foreach (string wac in wacList)
            {
                for (int i = 0; i < loopCnt; i++)
			    {
                    SendEmail(wac);
			    }          
            }

        }

        public static void SendEmail(string wac)
        {


            MailMessage mailMessage = new MailMessage();

            mailMessage.From = new MailAddress("NRCC@reportsystem.nationalresearch.com");
            mailMessage.To.Add(mailboxAddress);
            mailMessage.Subject = "CA WebSurvey Testing";

            string newBody = SetWAC(strBody, wac);

            mailMessage.Body = new MessageBody(BodyType.HTML, newBody);
            mailMessage.IsBodyHtml = true;

            mailMessage.Headers.Add("X-xsMailingId", "WebSurveyEmailProcess");
            mailMessage.Headers.Add("X-xsMessageId", Guid.NewGuid().ToString());

            smtpClient.Send(mailMessage);
            mailMessage.Dispose();


  
        }

        private static string SetWAC(string body, string wac)
        {

            return string.Format("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\"><span style=\"font-size: 12px; font-family: arial;\"></span><p style=\"margin: 0cm 0cm 0.0001pt 36pt;\"><span style=\"padding: 0cm; font-size: 10pt; border: 1pt none windowtext; font-family: Arial, sans-serif;\">Welcome to the 2015 Employee Engagement Survey. As a valued employee, we would like your feedback.</span></p><p style=\"margin: 0cm 0cm 0.0001pt 36pt;\"><span style=\"padding: 0cm; font-size: 10pt; border: 1pt none windowtext; font-family: Arial, sans-serif;\">&nbsp;</span></p><p style=\"margin: 0cm 0cm 0.0001pt 36pt;\"><span style=\"padding: 0cm; font-size: 10pt; border: 1pt none windowtext; font-family: Arial, sans-serif;\">We hope that you will take the opportunity to add your voice to your colleaguesҠso that we can create a better, stronger healthcare organization and a more positive work environment. Data from this survey will provide the foundation for discussions about SickKidsҠstrengths and opportunities for improvement.&nbsp; Leaders will work with their staff to identify priorities and develop/implement action plans designed to enhance the work experience for people at SickKids. &nbsp;&nbsp;</span></p><p style=\"margin: 0cm 0cm 0.0001pt 36pt;\"><span style=\"padding: 0cm; font-size: 10pt; border: 1pt none windowtext; font-family: Arial, sans-serif;\">&nbsp;</span></p><p style=\"margin: 0cm 0cm 0.0001pt 36pt;\"><span style=\"padding: 0cm; font-size: 10pt; border: 1pt none windowtext; font-family: Arial, sans-serif;\">To ensure confidentiality and anonymity, we have partnered with National Research Corporation Canada (NRCC), a leader in healthcare analytics, patient satisfaction measurement, and organizational improvement, to distribute the survey and analyze SickKidsҠemployee engagement survey results.</span></p><p style=\"margin: 0cm 0cm 0.0001pt 36pt;\"><span style=\"padding: 0cm; font-size: 10pt; border: 1pt none windowtext; font-family: Arial, sans-serif;\">&nbsp;</span></p><p style=\"margin: 0cm 0cm 0.0001pt 36pt;\"><span style=\"padding: 0cm; font-size: 10pt; border: 1pt none windowtext; font-family: Arial, sans-serif;\">The survey should take approximately 15 minutes and will be available from September 14 to October 4, 2015 (survey closes at 11:59 p.m.). All responses will remain confidential and anonymous and will only be reported where a group has at least 5 responses.</span></p><p style=\"margin: 0cm 0cm 0.0001pt 36pt;\"><span style=\"padding: 0cm; font-size: 10pt; border: 1pt none windowtext; font-family: Arial, sans-serif;\">&nbsp;</span></p><p style=\"margin: 0cm 0cm 0.0001pt 36pt;\"><span style=\"padding: 0cm; font-size: 10pt; border: 1pt none windowtext; font-family: Arial, sans-serif;\">To begin the survey, please click on the link below:<strong><span style=\"color: #0070c0;\">&nbsp;<a href=\"https://www.nrcsurveyor.net/se.ashx?s=2511374564297B8F\">Employee Engagement Survey</a></span></strong></span></p><p style=\"margin: 0cm 0cm 0.0001pt 36pt;\"><span style=\"padding: 0cm; font-size: 10pt; border: 1pt none windowtext; font-family: Arial, sans-serif;\">Your personal web access code is:<strong><span style=\"color: #00b050;\">{0}</span></strong></span></p><p style=\"margin: 0cm 0cm 0.0001pt 36pt;\"><span style=\"padding: 0cm; font-size: 10pt; border: 1pt none windowtext; font-family: Arial, sans-serif;\">&nbsp;</span></p><p style=\"margin: 0cm 0cm 0.0001pt 36pt;\"><span style=\"padding: 0cm; font-size: 10pt; border: 1pt none windowtext; font-family: Arial, sans-serif;\">If you need assistance in completing the survey or have questions, please talk to your leader or send a note to&nbsp;<a href=\"mailto:employee.engagement@sickkids.ca\"><span style=\"color: #0070c0;\">employee.engagement@sickkids.ca</span></a><span style=\"color: #0070c0;\">.</span></span></p><p style=\"margin-bottom: 0.0001pt;\"><span style=\"padding: 0cm; font-size: 9pt; border: 1pt none windowtext; font-family: Arial, sans-serif; color: #1f497d;\">&nbsp;</span></p><p style=\"margin: 0cm 0cm 0.0001pt 36pt;\"><span style=\"padding: 0cm; font-size: 10pt; border: 1pt none windowtext; font-family: Arial, sans-serif;\">Thank you for taking the time to share your feedback and for all you do for our organization each and every day.</span></p><p style=\"margin: 0cm 0cm 0.0001pt 36pt;\"><span style=\"padding: 0cm; font-size: 10pt; border: 1pt none windowtext; font-family: Arial, sans-serif;\">&nbsp;</span></p><p style=\"margin: 0cm 0cm 0.0001pt 36pt;\"><span style=\"padding: 0cm; font-size: 10pt; border: 1pt none windowtext; font-family: Arial, sans-serif;\">&nbsp;</span></p><p style=\"margin: 0cm 0cm 0.0001pt 36pt;\"><span style=\"padding: 0cm; font-size: 10pt; border: 1pt none windowtext; font-family: Arial, sans-serif;\">Sincerely,</span></p><p style=\"margin: 0cm 0cm 0.0001pt 36pt;\"><span style=\"padding: 0cm; font-size: 10pt; border: 1pt none windowtext; font-family: Arial, sans-serif;\">SickKids Engagement Team</span></p><div class=\"qualisyswac\" style=\"display: none; visibility: hidden;\">{1}</div>", wac, wac);

        }


        private static void CreateWACList()
        {

            wacList = new List<string>();

           // wacList.Add("CAC-VXLW-LRQ");
            wacList.Add("CAC-VXLW-JRJ");
            wacList.Add("CAC-VXLW-AQJ");
            wacList.Add("CAC-VXLW-KRM");
            //wacList.Add("CAC-VXLW-GRC");
            //wacList.Add("CAC-VXLW-EQU");
            //wacList.Add("CAC-VXLW-FQX");
            //wacList.Add("CAC-VXLW-HRF");
            //wacList.Add("CAC-VXLW-CQM");
            //wacList.Add("CAC-VXLW-DQQ");

        }



    }
}
