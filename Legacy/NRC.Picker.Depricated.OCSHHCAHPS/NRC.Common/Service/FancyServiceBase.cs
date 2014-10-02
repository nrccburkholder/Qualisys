using System;
using System.Collections.Generic;
using System.Linq;
using System.ServiceProcess;
using System.Text;
using System.Threading;

using NRC.Common.Configuration;

namespace NRC.Common.Service
{
    /// <summary>
    /// If you are writing a service, inherit from this class and call FancyServiceRunner.ServiceMain from the main method of your service. See <see cref="FancyServiceRunner"/>
    /// for more details.
    /// </summary>
    [System.ComponentModel.DesignerCategory("Code")] // disable design view
    public abstract class FancyServiceBase: ServiceBase
    {
        private static Logger _logger = Logger.GetLogger();
        
        private const int SHUTDOWN_CHECK_INTERVAL_MILLIS = 250;

        protected Thread _thread = null;
        private object _lock = new object();
        protected bool _stop = false;

        public FancyServiceBase()
        {
            this.CanShutdown = true;
        }

        protected override void OnStart(string[] args)
        {
            _thread = new Thread(() => {
                try
                {
                    Run();
                }
                catch (Exception ex)                    
                {
                    _logger.Error(String.Format("An exception was caught at the top level of the service (should have been caught lower down): {0}", ex.Message), ex);
                }
            });
            _stop = false;
            _thread.Start();
        }

        protected override void OnStop()
        {
            _logger.Info("Stop request received, attempting to stop service.");

            _stop = true;
            _thread.Interrupt();
            StopRequested();

            DateTime start = DateTime.Now;
            do
            {
                try
                {
                    Thread.Sleep(SHUTDOWN_CHECK_INTERVAL_MILLIS);
                }
                catch (ThreadInterruptedException) { }
            }
            while ((int)(DateTime.Now - start).TotalSeconds <= this.GracefulStopSeconds && _thread != null);

            if (_thread != null)
            {
                _logger.Error("Service did not stop on demand, sending abort.");
                try
                {
                    _thread.Abort();
                }
                catch (Exception ex)
                {
                    _logger.Error(String.Format("An error was received attempting to abort the service thread: {0}", ex.Message), ex);
                }
            }
        }

        // Some posts (eg, http://blogs.msdn.com/b/bclteam/archive/2007/11/01/change-in-system-serviceprocess-shutdown-is-coming-in-3-5-rtm-inbar-gazit.aspx)
        // claim that OnShutdown should call Stop by default in 3.5, but other posts seem to disagree, and it seems like it can't hurt.
        protected override void OnShutdown()
        {
            this.Stop();
        }

        /// <summary>
        /// Child classes may want to override this to make RunOnce() be called on a timer, or in response to events. If you do override it:  
        /// 1) Check _stop occasionally to see if someone is trying to shut down the service, and exit if so
        /// 2) At the end of the method, set _thread to null to show that the method has exited
        /// </summary>
        protected virtual void Run()
        {
            RunOnce();
            _thread = null;
        }

        /// <summary>
        /// Override this method to define the work the service actually does on a single run; if the single run takes more than a second or so, it should
        /// check _stop at intervals to decide when to stop
        /// </summary>
        abstract protected internal void RunOnce();

        /// <summary>
        /// Override this method to provide special handling when someone has requested the service stop
        /// </summary>
        virtual public void StopRequested() { }

        /// <summary>
        /// Override this method to return the internal name of the service (used for checking if it's running, etc; should be unique)
        /// </summary>
        abstract public string InternalName { get; }

        /// <summary>
        /// Override this method to change the friendly name for the service (defaults to ServiceName)
        /// </summary>
        virtual public string DisplayName { get { return ServiceName; } }

        /// <summary>
        /// Override this method to specify how many seconds to wait after the service is told to stop before doing a non-graceful abort
        /// </summary>
        virtual protected int GracefulStopSeconds { get { return 20; } }
    }

    public class FancyServiceBaseConfiguration : ConfigSection
    {
        [ConfigUse("id")]
        public string ServiceName { get; set; }

        [ConfigUse("display-name")]
        public string DisplayName { get; set; }

        [ConfigUse("stop-secs", IsOptional = true, Default = "20")]
        public int StopSecs { get; set; }
    }
}
