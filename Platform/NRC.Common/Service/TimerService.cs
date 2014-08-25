using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;

using NRC.Common.Configuration;

namespace NRC.Common.Service
{
    /// <summary>
    /// Inherit from this class to create a service that calls its RunOnce() method at specified intervals. See <see cref="FancyServiceBase"/> for more information on 
    /// writing services.
    /// </summary>
    abstract public class TimerService: FancyServiceBase
    {
        protected abstract int IntervalSecs { get; }

        /// <summary>
        /// See the comments on <see cref="FancyServiceBase.Run()"/> if you want to override this.
        /// </summary>
        protected override void Run()
        {
            while (!_stop)
            {
                RunOnce();

                DateTime wakeTime = DateTime.Now.AddSeconds(this.IntervalSecs);

                while (!_stop)
                {
                    int sleepMillis = (int)(wakeTime - DateTime.Now).TotalMilliseconds;
                    if (sleepMillis <= 0)
                    {
                        break;
                    }

                    try
                    {
                        Thread.Sleep(sleepMillis);
                    }
                    catch (ThreadInterruptedException) { } // expected exception -- somebody called stop
                }
            }

            _thread = null;
        }
    }

    public class TimerServiceConfiguration : FancyServiceBaseConfiguration
    {
        [ConfigUse("interval-mins")]
        public int IntervalMins { get; set; }
    }
}
