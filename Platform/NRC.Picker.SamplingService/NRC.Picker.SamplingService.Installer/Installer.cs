using System;
using System.Text;
using NRC.Common;
using NRC.Common.Service;
using NRC.Picker.SamplingService.Autosampler;

namespace NRC.Picker.SamplingService.Installer
{
    class Installer
    {
        static void Main(string[] args)
        {
            Logger.GetLogger("samplingserviceinstaller");

            string username;
            string password;

            Console.Write(@"Username (jsmith or domain\jsmith): ");
            username = Console.ReadLine();
            if (username.Length == 0)
            {
                Console.WriteLine("Must specify valid username!");
                return;
            }

            Console.Write(@"Password: ");
            password = ReadPassword();

            AutosamplerService autosamplerService = new AutosamplerService();
            QueueService.QueueService queueService = new QueueService.QueueService();

            FancyServiceRunner.ServiceMain(autosamplerService, new string[] { "/uninstall" });
            FancyServiceRunner.ServiceMain(autosamplerService, new string[] { "/install", username, password });
            FancyServiceRunner.ServiceMain(autosamplerService, new string[] { "/start" });

            FancyServiceRunner.ServiceMain(queueService, new string[] { "/uninstall" });
            FancyServiceRunner.ServiceMain(queueService, new string[] { "/install", username, password });
            FancyServiceRunner.ServiceMain(queueService, new string[] { "/start" });
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
                else if (key.Key == ConsoleKey.Escape ||
                         (key.Modifiers == ConsoleModifiers.Control &&
                          (key.Key == ConsoleKey.C || key.Key == ConsoleKey.Z)))
                {
                    return "";
                }
            }
        }
    }
}
