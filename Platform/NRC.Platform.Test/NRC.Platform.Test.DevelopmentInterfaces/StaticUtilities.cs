using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading;
using System.ServiceProcess;

using NRC.Common;

namespace NRC.Platform.Test.DevelopmentInterfaces
{
    public class StaticUtilities
    {
        /// Returns a string with 1's and 0's representing whether that character is the same or different between the given strings.
        /// Uses a 0 for the character positions that are longer than the shorter of the two strings when length is different.
        /// Intended to help testers locate where in the string the character is that is making a match fail.
        /// 
        /// 
        /// <param name="a">First string to diff</param>
        /// <param name="b">Second string to diff</param>
        /// <returns></returns>
        public static string StringDiff(string a, string b)
        {
            var s = new StringBuilder();
            for (int i = 0; i < a.Length && i < b.Length; i++)
            {

                if (a.ElementAt(i).Equals(b.ElementAt(i)))
                {
                    s.Append("1");
                }
                else
                {
                    s.Append("0");
                }

            }

            for (int i = 0; i < Math.Abs(a.Length - b.Length); i++)
            {
                s.Append("0");
            }

            return s.ToString();
        }

        public static string MostRecentFileInDirectory(string path)
        {
            return Directory.EnumerateFiles(path).
                OrderByDescending(a => new FileInfo(a).CreationTime).
                FirstOrDefault();
        }

        public static string MostRecentFileInDirectory(string path, string regex)
        {
            return Directory.EnumerateFiles(path).
                Where(a => Regex.IsMatch(Path.GetFileName(a), regex)).
                OrderByDescending(a => new FileInfo(a).CreationTime).
                FirstOrDefault();
        }

        public static string GetResourceValue(string resourceName, List<Resource> resources)
        {
            var resourcesSubset = resources.Where(c => c.ResourceName.Equals(resourceName));
            if (resourcesSubset.Count() > 0)
            {
                return resourcesSubset.FirstOrDefault().ResourceValue;
            }
            return null;

        }

        public static void LogException(Exception e, Logger logger, String prepend = "")
        {
            logger.Error(prepend + e.Message);
            logger.Error(prepend + e.StackTrace);
            if (e.InnerException != null)
            {
                prepend = prepend + "\t";
                LogException(e.InnerException, logger, prepend);
            }
        }

        #region Service Utilities (might break into its own file / static class later)

        public enum ServiceStatus { Running, NotRunning, Error, Cancelled };
        public enum ServiceCommand { Stop, Start, Restart, Status };

        //This was pulled from NRC.Platform.SmartLink.Wrapper.ServiceHelper and modified slightly to be more general
        public static ServiceStatus ControlService(ServiceCommand control, Func<bool> shouldCancel, string serviceName, string serviceMutex)
        {
            foreach (ServiceController sc in ServiceController.GetServices())
            {
                if (shouldCancel())
                {
                    return ServiceStatus.Cancelled;
                }

                if (!sc.ServiceName.Equals(serviceName))
                {
                    continue;
                }

                bool running = (sc.Status == ServiceControllerStatus.Running ||
                    sc.Status == ServiceControllerStatus.StartPending ||
                    sc.Status == ServiceControllerStatus.ContinuePending);

                if (running && (control.Equals(ServiceCommand.Stop) || control.Equals(ServiceCommand.Restart)))
                {
                    if (shouldCancel())
                    {
                        return ServiceStatus.Cancelled;
                    }

                    try
                    {
                        sc.Stop();
                        sc.WaitForStatus(ServiceControllerStatus.Stopped, new TimeSpan(0, 0, 30));
                        if (sc.Status != ServiceControllerStatus.Stopped)
                        {
                            return ServiceStatus.Error;
                        }
                    }
                    catch (Exception ex)
                    {
                        throw new Exception(String.Format("An error occurred stopping the service: {0}", ex.Message), ex);
                    }

                    running = false;
                }

                if (!running && (control.Equals(ServiceCommand.Start) || control.Equals(ServiceCommand.Restart)))
                {
                    if (shouldCancel())
                    {
                        return ServiceStatus.Cancelled;
                    }

                    try
                    {
                        sc.Start();
                        sc.WaitForStatus(ServiceControllerStatus.Running, new TimeSpan(0, 0, 30));
                        if (sc.Status != ServiceControllerStatus.Running)
                        {
                            return ServiceStatus.Error;
                        }
                    }
                    catch (Exception ex)
                    {
                        throw new Exception(String.Format("An error occurred starting the service: {0}", ex.Message), ex);
                    }

                    running = true;
                }

                return (running ? ServiceStatus.Running : ServiceStatus.NotRunning);
            }

            return ServiceStatus.Error;
        }

        public static void StopService(String serviceName, String serviceMutex)
        {
            int sleep = 0;
            if (ControlService(ServiceCommand.Status, () => false, serviceName, serviceMutex) == ServiceStatus.Running)
            {
                ControlService(ServiceCommand.Stop, () => false, serviceName, serviceMutex);

                while (ControlService(ServiceCommand.Status, () => false, serviceName, serviceMutex) != ServiceStatus.NotRunning
                    && sleep < 60000)
                {
                    sleep = sleep + 5000;
                    Thread.Sleep(5000);
                }

                if (ControlService(ServiceCommand.Status, () => false, serviceName, serviceMutex) == ServiceStatus.Running)
                {
                    throw new Exception("The service is still running 60 seconds after an attempt to stop it.");
                }

            }
        }

        public static void ChangeServiceConfigFile(String configSource, String configDestination, String serviceName, String serviceMutex)
        {
            StopService(serviceName, serviceMutex);

            File.Copy(configSource, configDestination, true);
            ControlService(ServiceCommand.Start, () => false, serviceName, serviceMutex);
            
            int sleep = 0;
            while (ControlService(ServiceCommand.Status, () => false, serviceName, serviceMutex) 
                != ServiceStatus.Running && sleep < 60000)
            {
                sleep = sleep + 5000;
                Thread.Sleep(5000);
            }


            if (ControlService(ServiceCommand.Status, () => false, serviceName, serviceMutex) != ServiceStatus.Running)
            {
                throw new Exception("The service is not running after an attempt to start it.");
            }

        }
        #endregion
    }
}
