using System;
using System.Collections.Generic;
using System.Configuration.Install;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Security.Principal;
using System.ServiceProcess;
using System.Text;
using System.Threading;
using RunInstaller = System.ComponentModel.RunInstallerAttribute;

namespace NRC.Common.Service
{
    /// <summary>
    /// If you are writing a service, call ServiceMain() from the main method of the service. For ease of development, you may want it to look like:
    ///   static void Main(string[] args)
    ///   {
    ///   #if DEBUG
    ///       if (args.Length == 0)
    ///       {
    ///           args = new string[]{ "/once" };
    ///       }
    ///   #endif
    ///       FancyServiceRunner.ServiceMain(new ThisService(), args);
    ///   }
    /// </summary>
    public abstract class FancyServiceRunner
    {
        private static Logger _logger = Logger.GetLogger();

        private const string USAGE = @"
Usage:  If not an interactive shell, runs as a service, once installed. Else:
    /admin: As the first argument, indicates this is an admin shell
    /once: Runs the service body once, then exits; for debug/dev only
    /install [username [password]]: Install this executable as a service
    /uninstall: Uninstalls this executable as a service
    /start: Start the service (must be installed first)
    /stop: Stop the service (must be installed first)
    /restart: Stop then start the service (must be installed first)
";

        private const int MAX_WAIT_SECS = 30;

        public static void ServiceMain(FancyServiceBase serviceObject, string[] args)
        {
            if (System.Environment.UserInteractive)
            {
                Dictionary<string, Action<FancyServiceBase, string[]>> userActions = new Dictionary<string, Action<FancyServiceBase, string[]>>();
                userActions["/once"] = (s, a) => RunOnce(s, a);

                Dictionary<string, Action<FancyServiceBase, string[]>> adminActions = new Dictionary<string, Action<FancyServiceBase, string[]>>();
                adminActions["/install"] = (s, a) => Install(s, a);
                adminActions["/uninstall"] = (s, a) => Uninstall(s, a);
                adminActions["/start"] = (s, a) => Start(s, a);
                adminActions["/stop"] = (s, a) => Stop(s, a);
                adminActions["/restart"] = (s, a) => Restart(s, a);

                if (args.Length > 0 && userActions.ContainsKey(args[0]))
                {
                    RunAction(serviceObject, args.Skip(1).ToArray(), userActions[args[0]], false, false);
                }
                else if (args.Length > 0 && adminActions.ContainsKey(args[0]))
                {
                    if (IsAdministrator())
                    {
                        RunAction(serviceObject, args.Skip(1).ToArray(), adminActions[args[0]], true, false);
                    }
                    else
                    {
                        SpawnElevatedProcess(serviceObject, args);
                    }
                }
                else if (args.Length > 1 && args[0].Equals("/admin") && adminActions.ContainsKey(args[1]))
                {
                    RunAction(serviceObject, args.Skip(2).ToArray(), adminActions[args[1]], true, true);
                }
                else
                {
                    Console.WriteLine(USAGE);
                }
            }
            else
            {
                RunService(serviceObject);
            }
        }

        private static void RunService(FancyServiceBase serviceObject)
        {
            ServiceBase.Run(new ServiceBase[] { serviceObject });
        }

        private static void RunOnce(FancyServiceBase serviceObject, string[] args)
        {
            try
            {
                serviceObject.RunOnce();
                serviceObject.StopRequested();
            }
            catch (Exception ex)
            {
                Console.WriteLine(String.Format("An exception was thrown: {0}", ex.Message), ex);
            }
        }

        private static void SpawnElevatedProcess(FancyServiceBase serviceObject, string[] args)
        {
            try
            {
                Process proc = new Process();
                proc.StartInfo.FileName = Assembly.GetEntryAssembly().Location;
                proc.StartInfo.Arguments = "/admin " + String.Join(" ", args);
                proc.StartInfo.Verb = "runas"; // actually request the elevation
                // useShellExecute must be true, or the UAC doesn't work; which means we can't redirect I/O from the process
                proc.Start();
                proc.WaitForExit();
            }
            catch (Exception ex)
            {
                Console.WriteLine(String.Format("There was an error starting the elevated process: {0}", ex.Message), ex);
            }
        }

        private static void RunAction(FancyServiceBase serviceObject, string[] args, Action<FancyServiceBase, string[]> action, bool requireAdmin, bool isSubproc)
        {
            if (!requireAdmin || IsAdministrator())
            {
                try
                {
                    action(serviceObject, args.ToArray());
                }
                catch (Exception ex)
                {
                    Console.WriteLine(String.Format("Something went wrong: {0} {1}", ex.Message, ex.StackTrace));
                }

                if (isSubproc)
                {
                    Console.WriteLine("Hit any key to exit.");
                    Console.ReadKey();
                }
            }
            else
            {
                Console.WriteLine("Did not start as administrator properly. If this is surprising,\n" +
                    "maybe try running in an administrator cmd window?");
            }
        }

        // http://blogs.microsoft.co.il/blogs/kim/archive/2009/01/04/self-installing-windows-service.aspx
        private static void Install(FancyServiceBase serviceObject, string[] args)
        {
            string username = args.Length > 0 ? args[0] : null;
            string password = args.Length > 1 ? args[1] : null;

            if (FindService(serviceObject.InternalName) != null)
            {
                Console.WriteLine("The service is already installed.");
                return;
            }

            ServiceAccount accountType = ServiceAccount.User;

            if (username != null && username.ToLower().Equals("localsystem"))
            {
                accountType = ServiceAccount.LocalSystem;
            }
            else if (username != null && username.ToLower().Equals("localservice"))
            {
                accountType = ServiceAccount.LocalService;
            }
            else
            {
                accountType = ServiceAccount.User;
                
                if (username == null)
                {
                    Console.Write(@"Username (jsmith or domain\jsmith): ");
                    username = Console.ReadLine();
                    if (username.Length == 0)
                    {
                        return;
                    }
                }

                if (password == null)
                {
                    Console.Write(@"Password: ");
                    password = ReadPassword();
                    if (password.Length == 0)
                    {
                        return;
                    }
                }
            }

            try
            {
                AssemblyInstaller installer = CreateAssemblyInstaller(serviceObject.InternalName, serviceObject.DisplayName, accountType, username, password);
                System.Collections.IDictionary installerState = new System.Collections.Hashtable();
                try
                {
                    installer.Install(installerState);
                    installer.Commit(installerState);
                    File.Delete(installer.Assembly.Location.Replace(".exe", ".InstallState"));
                    File.Delete(installer.Assembly.Location.Replace(".exe", ".InstallLog"));
                    Console.WriteLine("Install successful; installstate files have been cleaned up.");
                    _logger.Info("Service installed successfully.");
                }
                catch (Exception)
                {
                    installer.Rollback(installerState);
                    throw;
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine(String.Format("An error occurred trying to install the service: {0} {1}", ex.Message, ex.StackTrace));
            }
        }

        private static string ReadPassword()
        {
            StringBuilder ret = new StringBuilder();
            while (true)
            {
                ConsoleKeyInfo key = Console.ReadKey(true);
                if (key.Key == ConsoleKey.Enter)
                {
                    return ret.ToString();
                }
                else if (key.Key == ConsoleKey.Backspace)
                {
                    if (ret.Length > 0)
                    {
                        ret.Remove(ret.Length - 1, 1);
                    }
                }
                else if (key.KeyChar >= 0x20 && key.KeyChar < 0x7f)
                {
                    ret.Append(key.KeyChar);
                }
                else if (key.Key == ConsoleKey.Escape || (key.Modifiers == ConsoleModifiers.Control && (key.Key == ConsoleKey.C || key.Key == ConsoleKey.Z)))
                {
                    return "";
                }
            }
        }

        private static AssemblyInstaller CreateAssemblyInstaller(string serviceName)
        {
            return CreateAssemblyInstaller(serviceName, null, ServiceAccount.User, null, null);
        }

        private static AssemblyInstaller CreateAssemblyInstaller(string serviceName, string displayName, ServiceAccount accountType, string username, string password)
        {
            AssemblyInstaller installer = new AssemblyInstaller(Assembly.GetEntryAssembly(), new string[] { });
            installer.UseNewContext = true;

            ServiceInstaller serviceInstaller = new ServiceInstaller();

            if (username != null)
            {
                ServiceProcessInstaller processInstaller = new ServiceProcessInstaller();

                processInstaller.Account = accountType;
                if (accountType == ServiceAccount.User)
                {
                    processInstaller.Username = username;
                    processInstaller.Password = password;
                }
                installer.Installers.Add(processInstaller);
            }

            serviceInstaller.StartType = ServiceStartMode.Automatic;
            serviceInstaller.DisplayName = displayName;
            serviceInstaller.ServiceName = serviceName;

            installer.Installers.Add(serviceInstaller);

            return installer;
        }

        private static void Uninstall(FancyServiceBase serviceObject, string[] args)
        {
            if (!ControlService(serviceObject, "stop", "stopped", (s => s != ServiceControllerStatus.Running), (s => s.Stop()), ServiceControllerStatus.Stopped))
            {
                return;
            }

            try
            {
                AssemblyInstaller installer = CreateAssemblyInstaller(serviceObject.InternalName);
                installer.Uninstall(null);
                _logger.Info("Service uninstalled successfully.");
            }
            catch (Exception ex)
            {
                Console.WriteLine(String.Format("An error occurred trying to uninstall the service: {0} {1}", ex.Message, ex.StackTrace));
            }
        }

        private static void Start(FancyServiceBase serviceObject, string[] args)
        {
            ControlService(serviceObject, "start", "started", (s => s == ServiceControllerStatus.Running), (s => s.Start()), ServiceControllerStatus.Running);
        }

        private static void Stop(FancyServiceBase serviceObject, string[] args)
        {
            ControlService(serviceObject, "stop", "stopped", (s => s != ServiceControllerStatus.Running), (s => s.Stop()), ServiceControllerStatus.Stopped);
        }

        private static void Restart(FancyServiceBase serviceObject, string[] args)
        {
            if (ControlService(serviceObject, "stop", "stopped", (s => s != ServiceControllerStatus.Running), (s => s.Stop()), ServiceControllerStatus.Stopped))
            {
                ControlService(serviceObject, "start", "started", (s => s == ServiceControllerStatus.Running), (s => s.Start()), ServiceControllerStatus.Running);
            }
        }

        private static bool ControlService(FancyServiceBase serviceObject, string verb, string verbed, Func<ServiceControllerStatus, bool> alreadyRightFunc, 
            Action<ServiceController> controlFunc, ServiceControllerStatus desiredStatus)
        {
            ServiceController serviceController = FindService(serviceObject.InternalName);
            if (serviceController == null)
            {
                Console.WriteLine("The service is not installed.");
                return false;
            }

            if (alreadyRightFunc(serviceController.Status))
            {
                Console.WriteLine(String.Format("The service is already {0}.", verbed));
                return true;
            }

            Console.WriteLine(String.Format("Attempting to {0} service ...", verb));
            controlFunc(serviceController);
            if (WaitForStatusChange(serviceController, desiredStatus))
            {
                Console.WriteLine(String.Format("The service has been {0}.", verbed));
                _logger.Info(String.Format("Service {0} successfully.", verbed));
                return true;
            }
            else
            {
                serviceController.Refresh();
                Console.WriteLine(String.Format("The service failed to {0} properly (current status: {1})", verb, serviceController.Status.ToString()));
                return false;
            }
        }

        private static ServiceController FindService(string name)
        {
            foreach (ServiceController sc in ServiceController.GetServices())
            {
                if (sc.ServiceName.Equals(name))
                {
                    return sc;
                }
            }

            return null;
        }

        private static bool WaitForStatusChange(ServiceController serviceController, ServiceControllerStatus newStatus)
        {
            for (int i = 0; serviceController.Status != newStatus && i < MAX_WAIT_SECS; i++)
            {
                Thread.Sleep(1000);
                serviceController.Refresh();
            }

            return (serviceController.Status == newStatus);
        }

        // http://en.csharp-online.net/Check_if_principal_is_Administrator
        private static bool IsAdministrator()
        {
            WindowsIdentity identity = WindowsIdentity.GetCurrent();
            WindowsPrincipal principal = new WindowsPrincipal(identity);
            return principal.IsInRole(WindowsBuiltInRole.Administrator);
        }
    }
}
