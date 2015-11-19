using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;
using System.Text.RegularExpressions;

using NRC.Common.Service;
using NRC.Common.Configuration;

namespace NRC.Platform.FileCopyService
{
    class Program : NRC.Common.Service.TimerService
    {
        private static NRC.Common.Logger logger;
        Configuration settings;

        static void Main(string[] args)
        {
            Program.logger = NRC.Common.Logger.GetLogger("NRC.Platform.FileCopyService");
#if DEBUG
            if (args.Length == 0)
            {
                args = new string[] { "/once" };
            }
#endif
            FancyServiceRunner.ServiceMain(new Program(), args);
#if DEBUG
            Console.WriteLine("Press any key to continue...");
            Console.ReadKey();
#endif
        }

        public Program()
        {
            try
            {
                this.settings = ConfigManager.Load<Configuration>();
            }
            catch (Exception ex)
            {
                Log(ex);
            }
        }

        protected override void RunOnce()
        {
            foreach (var dst in settings.dirsToMove)
            {
                try
                {
                    dst.OnRunOnce();
                }
                catch (Exception ex)
                {
                    var detailEx = new FileCopyException(string.Format("Error doing {0} from {1} to {2} with backup {3}.", 
                        dst.action, dst.source?.Path, dst.destination?.Path, dst.backup?.Path), ex);
                    Log(detailEx);
                }
            }
        }

        public override string InternalName
        {
            get { return settings.serviceName; }
        }

        protected override int IntervalSecs
        {
            get { return settings.intervalSecs; }
        }

        public static void Log(Exception ex)
        {
#if DEBUG
            Console.WriteLine(ex);
#endif
            logger.Error(ex.Message, ex);
        }

        public static NRC.Common.Logger Logger()
        {
            if (logger == null)
            {
                logger = NRC.Common.Logger.GetLogger("NRC.Platform.FileCopyService");
            }
            return logger;
        }
    }
}
