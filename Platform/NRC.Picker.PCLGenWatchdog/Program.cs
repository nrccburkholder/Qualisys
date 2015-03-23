using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Configuration;
using System.Threading;
using System.ServiceModel;
using System.Drawing;
using System.Windows.Forms;
using System.Drawing.Imaging;
using System.ServiceModel.Description;

/*
 * 
PCL Generation Version 2.4 (Build 11) - TfrmPCLGeneration - 3936
PCLGen - TApplication - 3936
PCLGen - #32770 - 16760
PCL Generation Version 2.4 (Build 11) - TfrmPCLGeneration - 16760
PCLGen - TApplication - 16760
PCLGen - #32770 - 19000
PCL Generation Version 2.4 (Build 11) - TfrmPCLGeneration - 19000
PCLGen - TApplication - 19000
PCLGen - #32770 - 10152
PCL Generation Version 2.4 (Build 11) - TfrmPCLGeneration - 10152
PCLGen - TApplication - 10152
PCLGen - CabinetWClass - 7916
 * */


namespace NRC.Picker.PCLGenWatchdog
{
    public class ErrorInfo
    {
        public bool HasErrors { get; set; }
        public bool HasWarnings { get; set; }
        public string Error { get; set; }
    }

    public enum PrintQueueStatus
    {
        UNKNOWN=0,
        IDLE=1,
        SPOOLING,
        PRINTING,
        MORE_THAN_ONE_JOB_FOUND,
        SPOOLING_SEEMS_DEAD,
        PRINTING_SEEMS_DEAD,
        NOT_SPOOLING_OR_PRINTING
    }

    class Program
    {
        static string pclGenPath ;
        static string pclGenArguments;
        static string smtpServer;
        static string emailFrom;
        static string emailTo;
        static string pclgenWorkingDirectory;

        static DateTime lastRestart = DateTime.MinValue;
        static DateTime lastSuccessfulRestart = DateTime.MinValue;
        static DateTime lastAttemptedRestart = DateTime.MinValue;
        static Dictionary<string, int> emailThrottle = new Dictionary<string, int>();

        static TimeSpan timeSpan1Hour = new TimeSpan(1, 0, 0);
        static TimeSpan timeSpan5Minutes = new TimeSpan(0, 5, 0);
        static TimeSpan timeSpan5Seconds = new TimeSpan(0, 0, 5);
        static TimeSpan timeSpan30Seconds = new TimeSpan(0, 0, 30);

        static void UpdateStatus(RemoteMonitoringService.Status status)
        {
            try
            {
                PCLGenStatusService.PCLGenStatusServiceClient c = new PCLGenStatusService.PCLGenStatusServiceClient();
                c.SetStatus(status);
            }
            catch (Exception ex)
            {
                Log(ex.Message);
            }
        }

        static void Main(string[] args)
        {
            try
            {
                Log("Starting status monitoring endpoint");

                using (ServiceHost host = new ServiceHost(typeof(RemoteMonitoringService.PCLGenStatusService)))
                {
                    host.AddServiceEndpoint(typeof(RemoteMonitoringService.IPCLGenStatusService), new WebHttpBinding(), "").Behaviors.Add(new WebHttpBehavior());
                    host.Open();

                    System.Configuration.AppSettingsReader ar = new AppSettingsReader();
                        pclGenPath = (string)(ar.GetValue("pclgen", typeof(string)));
                        pclGenArguments = (string)(ar.GetValue("pclgenarguments", typeof(string)));
                        smtpServer = (string)(ar.GetValue("smtpserver", typeof(string)));
                        emailFrom = (string)(ar.GetValue("emailfrom", typeof(string)));
                        emailTo = (string)(ar.GetValue("emailto", typeof(string)));
                        pclgenWorkingDirectory = (string)(ar.GetValue("pclgenworkingdirectory", typeof(string)));

                    if (!System.IO.File.Exists(pclGenPath))
                    {
                        throw new Exception(string.Format("Invalid PCLGen.exe location: {0}", pclGenPath));
                    }

                    Log(string.Format("PCLGen.exe location: {0}", pclGenPath));


                    Log("starting PCLGen WatchDog");

                    SendMail(string.Format("PCLGenWatchdog started on {0}", Environment.MachineName), string.Format("PCLGenWatchdog started on {0}", Environment.MachineName));

                    DoWork();

                    SendMail(string.Format("PCLGenWatchdog stopped on {0}", Environment.MachineName), string.Format("PCLGenWatchdog stopped on {0}", Environment.MachineName));
                }
            }
            catch (Exception ex)
            {
                Log(ex.Message);
                SendMail(string.Format("PCLGenWatchdog stopped on {0}", Environment.MachineName), string.Format("PCLGenWatchdog stopped on {0}. {1}", Environment.MachineName, ex.Message));
            }
        }

        static void DoWork()
        {
            bool errorsAfterRestart = false;
            string logWindowText = string.Empty;

            RemoteMonitoringService.Status status = new RemoteMonitoringService.Status();
            status.LastRestartOfPCLGen = DateTime.MinValue;
            status.IsPCLGenRunning = false;
            status.UnhandledErrorReason = string.Empty;
            status.ErrorsDetected = false;

            Log("Monitoring PCLGen for errors...");

            while (true)
            {
                ErrorInfo errorInfo = null;
                logWindowText = string.Empty;

                PrintQueueStatus printQueueStatus = PrintQueueStatus.UNKNOWN;

                try
                {
                    // SaveScreenShot("pclgenscreenshot.jpg");

                    status.LastStatusCheck = DateTime.Now;
                    status.PrinterStatus = printQueueStatus.ToString();
                    status.IsPCLGenRunning = false;
                    status.UnhandledErrorReason = string.Empty;
                    status.ErrorsDetected = false;
                    status.LogWindowText = string.Empty;

                    if (!WndSearcher.TfrmPCLGenerationWindowExists())
                    {
                        Log(string.Format("PCLGen not found on {0}", Environment.MachineName));
                        Log(string.Format("Automatically starting PCLGen on {0}", Environment.MachineName));

                        StartPCLGen();
                        status.LastRestartOfPCLGen = DateTime.Now;
                        status.LastRestartReason = "PCLGen not found.  Automatically started.";

                        UpdateStatus(status);                        

                        Log(string.Format("Automatically started PCLGen on {0}", Environment.MachineName));

                        SendMail(
                            string.Format("PCLGen automatically started on {0}", Environment.MachineName),
                            string.Format("PCLGen was not runnning on {0}.  It was automatically started by the watchdog.", Environment.MachineName));

                        System.Threading.Thread.Sleep(timeSpan30Seconds);

                        continue;
                    }

                    printQueueStatus = GetPrintQueueStatus();
                    status.PrinterStatus = printQueueStatus.ToString();
                    status.IsPCLGenRunning = GetPCLGenProcesses().Count() > 0 ? true : false;

                    logWindowText = GetLogWindowText();

                    if (!string.IsNullOrEmpty(logWindowText))
                    {
                        if (logWindowText.Length > 256)
                        {
                            status.LogWindowText = logWindowText.Substring(logWindowText.Length - 256);
                        }
                        else
                        {
                            status.LogWindowText = logWindowText;
                        }
                    }

                    errorInfo = CheckForErrors(logWindowText);

                    if (errorInfo.HasErrors)
                    {
                        status.ErrorsDetected = true;
                        status.LastRestartReason = errorInfo.Error;

                        status.LastRestartOfPCLGen = DateTime.Now;
                        RestartPCLGen(ref errorsAfterRestart, ref logWindowText);

                        Log("Monitoring PCLGen for errors...");
                    }
                    else if (errorInfo.HasWarnings)
                    {
                        status.ErrorsDetected = true;
                        status.UnhandledErrorReason = errorInfo.Error;
                    }

                }
                catch (LogWindowTimeoutException ex)
                {
                    Log(ex.Message);

                    status.ErrorsDetected = true;
                    status.LogWindowText = string.Empty;

                    if (printQueueStatus != PrintQueueStatus.SPOOLING &&
                        printQueueStatus != PrintQueueStatus.PRINTING)
                    {
                        status.LastRestartOfPCLGen = DateTime.Now;
                        status.LastRestartReason = ex.Message;

                        SendMail(
                                string.Format("PCLGen Exception on {0}", Environment.MachineName),
                                ex.Message);

                        try
                        {
                            RestartPCLGen(ref errorsAfterRestart, ref logWindowText);
                        }
                        catch (Exception ex2)
                        {
                        }
                    }
                    else
                    {
                        status.UnhandledErrorReason = ex.Message;
                    }
                }
                catch (Exception ex)
                {
                    status.ErrorsDetected = true;
                    status.UnhandledErrorReason = ex.Message;

                    SendMail(
                            string.Format("PCLGen Exception on {0}", Environment.MachineName),
                            ex.Message);
                }
                finally
                {
                    UpdateStatus(status);
                }

                System.Threading.Thread.Sleep(timeSpan5Minutes);
            }
        }

        // List<System.Diagnostics.Process>
        private static bool RestartPCLGen(ref bool errorsAfterRestart, ref string logWindowText)
        {
            List<System.Diagnostics.Process> pclGenProcesses;
            pclGenProcesses = GetPCLGenProcesses();

            int loopCount = 0;
            while (pclGenProcesses.Count() > 0)
            {
                if (loopCount++ > 1000)
                {
                    throw new Exception("too many loops while trying to kill all the processes.");
                }

                foreach (var proc in pclGenProcesses)
                {
                    Log(string.Format("killing {0} [{1}]", proc.ProcessName, proc.Id));
                    try
                    {
                        proc.Kill();
                    }
                    catch (Exception ex)
                    {
                        Log(ex.Message);
                    }
                    System.Threading.Thread.Sleep(100);
                }

                pclGenProcesses = GetPCLGenProcesses();
            }

            lastAttemptedRestart = DateTime.Now;

            // start new PCLGen.exe
            Log("starting new instance of PCLGen");
            StartPCLGen();

            // loop, waiting for PCLGen to start.
            int cnt = 0;
            do
            {
                System.Threading.Thread.Sleep(timeSpan5Seconds);

                if (cnt++ > 1000)
                {
                    throw new Exception("too many loops while waiting for PCLGen to start.");
                }

                pclGenProcesses = GetPCLGenProcesses();

            } while (pclGenProcesses.Count().Equals(0));

            pclGenProcesses = GetPCLGenProcesses();

            // if we have an instance of pclGen then it was restarted successfully.
            if (pclGenProcesses.Count().Equals(1))
            {
                lastRestart = DateTime.Now;

                Log("Giving the new intance of PCLGen some time to start first work attempt.");
                System.Threading.Thread.Sleep(timeSpan30Seconds);

                string restartLogwindowText = GetLogWindowText();
                ErrorInfo restartErrorInfo = CheckForErrors(restartLogwindowText);

                // now did we get an error again after restarting?
                if (!restartErrorInfo.HasErrors)
                {
                    lastSuccessfulRestart = DateTime.Now;

                    // no errors after restarting
                    errorsAfterRestart = false;

                    SendMail(
                            string.Format("PCLGen restarted on {0}", Environment.MachineName),
                            string.Format("PCLGen restarted on {0}\r\n\r\n{1}",
                            Environment.MachineName,
                            logWindowText));

                    Log(string.Format("PCLGen restarted on {0}", Environment.MachineName));
                }
                else
                {
                    // the orignial logWindowText + the log window text after the restart
                    logWindowText = string.Format("{0}\r\n---------------\r\n{1}", logWindowText, restartLogwindowText);

                    // yes there we errors after restarting
                    // if this is the first time, then send and e-mail stating errors after restart
                    // only report this once...
                    if (!errorsAfterRestart)
                    {
                        errorsAfterRestart = true;

                        SendMail(
                                string.Format("PCLGen errors after restart on {0}", Environment.MachineName),
                                string.Format("PCLGen errors after restart on {0}\r\n\r\n{1}",
                                Environment.MachineName,
                                logWindowText));
                    }
                }
            }
            else
            {
                if (pclGenProcesses.Count().Equals(0))
                {
                    SendMail(
                            string.Format("PCLGen restarted failed on {0}", Environment.MachineName),
                            string.Format("PCLGen restarted failed on {0}.  Could not start new instance of PCLGen", Environment.MachineName));
                }
                else
                {
                    SendMail(
                            string.Format("PCLGen restarted failed on {0}", Environment.MachineName),
                            string.Format("PCLGen restarted failed on {0}.  More than one instance of PCLGen found after restart of PCLGen.", Environment.MachineName));
                }
            }
            return pclGenProcesses.Count().Equals(1)?true:false;
        }

        private static void StartPCLGen()
        {
            System.Diagnostics.ProcessStartInfo psi = new System.Diagnostics.ProcessStartInfo();
            psi.WorkingDirectory = pclgenWorkingDirectory;
            psi.FileName = pclGenPath;
            psi.Arguments = pclGenArguments;
            System.Diagnostics.Process.Start(psi);//pclGenPath, pclGenArguments);
        }

        private static List<System.Diagnostics.Process> GetPCLGenProcesses()
        {
            return System.Diagnostics.Process.GetProcessesByName("PCLGen").ToList<System.Diagnostics.Process>();
        }

        private static string GetLogWindowText()
        {
            //string tMemoText = WndSearcher.GetTMemoText().ToLower();
            //return tMemoText;

            LogWindowTextReader logWindowTextReader = new LogWindowTextReader();

            Thread oThread = new Thread(new ThreadStart(logWindowTextReader.ReadLogWindow));

            // Start the thread
            oThread.Start();

            oThread.Join(timeSpan5Minutes); // wait upto 5 minutes for PCLGen to respond to a WM_GETWINDOWTEXT

            if (logWindowTextReader.tMemoText.Equals("[nothing]"))
            {
                throw new LogWindowTimeoutException("timeout reading from log window");
            }

            return logWindowTextReader.tMemoText;
        }

        private static bool CheckForErrorsInLogWindow(string tMemoText)
        {
            if ( tMemoText.Contains("error! (40)") ||
                 tMemoText.Contains("error! (24)"))
            {
                return false;
            }

            if ( tMemoText.Contains("error!") || 
                 tMemoText.Contains(" error "))
            {
                return true;
            }

            return false;
        }

        private static bool CheckForWarningsInLogWindow(string tMemoText)
        {
            if (tMemoText.Contains("error! (40)") || tMemoText.Contains(" error "))
            {
                return true;
            }

            return false;
        }

        private static ErrorInfo CheckForErrors(string logWindowText)
        {
            ErrorInfo errorInfo = new ErrorInfo();
            errorInfo.HasErrors = false;
            errorInfo.Error = String.Empty;

            List<System.Diagnostics.Process> pclGenProcesses;

            if (CheckForErrorsInLogWindow(logWindowText))
            {
                errorInfo.HasErrors = true;
                errorInfo.Error = "Found error text in log window";

                Log(errorInfo.Error);
            }
            else
            {
                if (CheckForWarningsInLogWindow(logWindowText))
                {
                    errorInfo.HasWarnings = true;
                    // AA total hack.  
                    errorInfo.Error = "error! (40)";
                }

                // look for the error dialog boxes
                List<FoundWindow> foundWindows = EnumDesktopWindows.GetDesktopWindowsCaptions();
                int numErrorDialogs = foundWindows.Where(t => t.Classname.Equals("#32770") && t.Title.Equals("PCLGen")).Count();

                pclGenProcesses = GetPCLGenProcesses();

                if (numErrorDialogs > 0)
                {
                    if (pclGenProcesses.Count() > 1)
                    {
                        errorInfo.HasErrors = true;
                        errorInfo.Error = string.Format("Found {0} instance of PCLGen and {1} dialog boxe{2} open.", 
                            pclGenProcesses.Count(), 
                            numErrorDialogs,
                            numErrorDialogs==1?"":"s");
                        Log(errorInfo.Error);
                    }
                    else
                    {
                        // I'm not sure if this is an error condition.  This would happen when there is only one instance of pclgen but there are error dialogs
                        // my research found that each error dialog results in another instance of the pclgen processes.
                        // so, if this happens it would mean the main window is gone but the error dialog is still open.
                        errorInfo.HasErrors = true;
                        errorInfo.Error = string.Format("Found {0} instance of PCLGen and {1} dialog boxe{2} open.",
                            pclGenProcesses.Count(),
                            numErrorDialogs,
                            numErrorDialogs > 1 ? "s" : "");
                        Log(errorInfo.Error);
                    }
                }
            }
            return errorInfo;
        }

        private static PrintQueueStatus GetPrintQueueStatus()
        {
            System.Printing.LocalPrintServer lps = new System.Printing.LocalPrintServer();

            System.Printing.PrintQueue pq = null;
            try
            {
                pq = lps.GetPrintQueue("DQCalcPrinter");
            }
            catch (Exception ex)
            {
                throw new Exception("could not find printqueue 'DQCalcPrinter", ex);
            }

            if (pq.NumberOfJobs == 0) return PrintQueueStatus.IDLE;
            if (pq.NumberOfJobs > 1) return PrintQueueStatus.MORE_THAN_ONE_JOB_FOUND;

            var jobsInQueue = pq.GetPrintJobInfoCollection();

            if (jobsInQueue.Count() == 0) return PrintQueueStatus.IDLE;
            if (jobsInQueue.Count() > 1) return PrintQueueStatus.MORE_THAN_ONE_JOB_FOUND;

            var job = jobsInQueue.First();

            if (job.IsPrinting) 
                Log("Print job is printing");
            if (job.IsSpooling)
                Log("Print job is spooling");

            if (job.IsSpooling)
            {
                // job.IsSpooling;
                // job.TimeJobSubmitted;
                if (job.TimeSinceStartedPrinting > 14400000) // 4 hours
                {
                    return PrintQueueStatus.SPOOLING_SEEMS_DEAD;
                }

                return PrintQueueStatus.SPOOLING;
            }
            else if (job.IsPrinting)
            {
                // job.TimeJobSubmitted;
                if (job.TimeSinceStartedPrinting > 14400000) // 4 hours
                {
                    return PrintQueueStatus.PRINTING_SEEMS_DEAD;
                }

                return PrintQueueStatus.PRINTING;
            }

            return PrintQueueStatus.NOT_SPOOLING_OR_PRINTING; // there is a print job but it is not spooling or printing.
        }

        public static void Log(string message)
        {
            Console.WriteLine(string.Format("{0} - {1}", DateTime.Now, message));
        }

        public static void SendMail(string subject, string message)
        {
            try
            {

                Log(message);

                string datekey = DateTime.Now.ToString("yyyyMMdd");
                string prevDatekey = DateTime.Now.AddDays(-1).ToString("yyyyMMdd");

                if (emailThrottle.Keys.Contains(prevDatekey))
                {
                    emailThrottle.Remove(prevDatekey);
                }

                if (!emailThrottle.Keys.Contains(datekey))
                {
                    emailThrottle.Add(datekey, 0);
                }

                emailThrottle[datekey]++;

                if (emailThrottle[datekey] < 10)
                {

                    try
                    {
                        System.Net.Mail.SmtpClient smptclient = new System.Net.Mail.SmtpClient(smtpServer);
                        smptclient.Send(
                            emailFrom,
                            emailTo,
                            subject,
                            message);
                    }
                    catch (Exception ex)
                    {
                        Log(ex.Message);
                    }
                }
                else
                {
                    Log("email limit has been reached for the day. no more mail will be sent until tomorrow");
                }
            }
            catch { }
        }

        /// <summary>
        /// thought it would be nice to be able to look at the screen shot
        /// problem is, getting the screen shot is not easy/possible when the computer is locked.
        /// </summary>
        /// <param name="filename"></param>
        public static void SaveScreenShot(string filename)
        {

            try
            {
                if (System.IO.File.Exists(filename))
                {
                    System.IO.File.Delete(filename);
                }

                using (Bitmap bmpSS = new Bitmap(
                                Screen.PrimaryScreen.Bounds.Width,
                                Screen.PrimaryScreen.Bounds.Height,
                                PixelFormat.Format32bppArgb))
                {

                    using (Graphics gfxSS = Graphics.FromImage(bmpSS))
                    {

                        gfxSS.CopyFromScreen(
                            Screen.PrimaryScreen.Bounds.X,
                            Screen.PrimaryScreen.Bounds.Y,
                            0,
                            0,
                            Screen.PrimaryScreen.Bounds.Size,
                            CopyPixelOperation.SourceCopy);

                        using (Font f = new Font("Arial", 32))
                        {
                            using( SolidBrush b = new SolidBrush(Color.Black) )
                            {
                                gfxSS.DrawString(
                                        string.Format("{0} - {1}", Environment.MachineName, DateTime.Now.ToString()),
                                        f,
                                        b, 25.0f, 25.0f, StringFormat.GenericDefault);


                                bmpSS.Save(filename, ImageFormat.Jpeg);

                                //gfxSS.ReleaseHdc();
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                Log(ex.Message);
                Log(ex.StackTrace);
            }

        }
    }
}
