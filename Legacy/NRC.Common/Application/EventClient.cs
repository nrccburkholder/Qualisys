using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
 
using Newtonsoft.Json;

using RESTClient = NRC.Common.Web.RESTClient;

namespace NRC.Common.Application
{
    /// <summary>
    /// This is a helper class for NRC.Common.Logger. Generally speaking you'll want to use that class to log events in your application 
    /// rather than using this class directly.
    /// </summary>
    public class EventClient: RESTClient
    {
        private const int SLEEP_TIME_MILLIS = 5000;
        private const int SHUTDOWN_INTERVAL_MILLIS = 250;
        private const int SHUTDOWN_TOTAL_MILLIS = 3000;

        private List<Event> _queuedEvents = new List<Event>();
        private Thread _thread = null;
        private bool _stop = false;
        private Action<string> _logTrace = null;
        private Action<string, Exception> _logError = null;

        // protected internal to discourage people from using this class directly
        protected internal EventClient(string baseUrl, Action<string> logTrace, Action<string, Exception> logError) : base(baseUrl) 
        {
            _logTrace = logTrace;
            _logError = logError;
            Start();
        }

        public bool AddEvent(string id, string type, object intDataObj, object stringDataObj)
        {
            Dictionary<string, int> intData = new Dictionary<string, int>();
            foreach (var property in intDataObj.GetType().GetProperties())
            {
                intData[property.Name] = (int)property.GetValue(intDataObj, null);
            }

            Dictionary<string, string> stringData = new Dictionary<string, string>();
            foreach (var property in stringDataObj.GetType().GetProperties())
            {
                stringData[property.Name] = (string)property.GetValue(stringDataObj, null);
            }

            _logTrace(String.Format("Logging event with id={0} type={1} intData={2} stringData={3}", id, type,
                String.Join(",", intData.Select(a => a.Key + ":" + a.Value).ToArray()),
                String.Join(",", stringData.Select(a => a.Key + ":" + a.Value).ToArray())));

            Event e = new Event();
            e.ID = id;
            e.Type = type;
            e.IntData = JsonConvert.SerializeObject(intData);
            e.StringData = JsonConvert.SerializeObject(stringData);
            e.Time = DateTime.Now;

            lock (_lock)
            {
                _queuedEvents.Add(e);
            }

            return true;
        }

        public void Start()
        {
            _stop = false;
            _thread = new Thread(() => {
                try
                {
                    this.Run();
                }
                catch (ThreadAbortException) {}
                catch (Exception ex)
                {
                    _logError(String.Format("Thread halting due to unexpected exception: {0}", ex.Message), ex);
                }

                lock (_lock)
                {
                    _thread = null;
                }
            });
            _thread.IsBackground = true;
            _thread.Start();
        }

        public void Stop()
        {
            lock (_lock)
            {
                _stop = true;
                this.Abort();
                _thread.Interrupt();
            }

            DateTime start = DateTime.Now;
            do
            {
                try
                {
                    Thread.Sleep(SHUTDOWN_INTERVAL_MILLIS);
                }
                catch (ThreadInterruptedException) { }
            }
            while ((int)(DateTime.Now - start).TotalMilliseconds < SHUTDOWN_TOTAL_MILLIS * 10 && _thread != null);

            lock (_lock)
            {
                if (_thread != null)
                {
                    _logError("Event client thread did not halt on its own, aborting it.", null);
                    _thread.Abort();
                }
            }
        }

        private void Run()
        {
            while (!_stop)
            {
                try
                {
                    lock (_lock)
                    {
                        try
                        {
                            while (_queuedEvents.Count > 0)
                            {
                                Event e = _queuedEvents[0];
                                _queuedEvents.RemoveAt(0); // ok if we miss an event sometimes, so remove this early in the process to avoid potential of getting stuck

                                Dictionary<string, string> args = new Dictionary<string, string>();
                                args["id"] = e.ID;
                                args["eventType"] = e.Type;
                                args["source"] = Environment.MachineName;
                                args["intData"] = e.IntData;
                                args["stringData"] = e.StringData;
                                args["time"] = e.Time.ToUniversalTime().ToString("r");
                                CallService<bool>("AddEvent", "POST", args);
                            }
                        }
                        catch (ThreadAbortException) { } // we're supposed to stop; swallow exception and continue
                        catch (Exception ex)
                        {
                            _logError(ex.Message, ex);
                        }
                    }

                    if (_stop)
                    {
                        return;
                    }

                    Thread.Sleep(SLEEP_TIME_MILLIS);
                }
                catch (ThreadInterruptedException) { }
            }
        }

        private class Event
        {
            public string ID { get; set; }
            public string Type { get; set; }
            public string IntData { get; set; }
            public string StringData { get; set; }
            public DateTime Time { get; set; }
        }
    }
}
