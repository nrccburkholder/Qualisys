using System;
using System.Diagnostics;
using System.Messaging;
using System.ServiceProcess;
using Nrc.CatalystExporter.FileCreationEngine;
using Nrc.CatalystExporter.Logging;

namespace FileCreationService
{
    public partial class FileCreationService : ServiceBase
    {
        private FileCreationHelper _engine = new FileCreationHelper();

        public FileCreationService()
        {
            InitializeComponent();
        }

        public void DebugRun()
        {
            Run();
        }

        protected override void OnStart(string[] args)
        {
            Run();
        }

        protected override void OnStop()
        {
        }

        private void Run()
        {
            try
            {
                string queueName = System.Configuration.ConfigurationManager.AppSettings["Queue"];

                if (string.IsNullOrEmpty(queueName))
                    throw new ArgumentNullException("Queue");

                if (MessageQueue.Exists(queueName))
                {
                    MessageQueue queue = new MessageQueue(queueName);

                    queue.Formatter = new System.Messaging.XmlMessageFormatter(new Type[1] { typeof(long) });

                    queue.ReceiveCompleted += new ReceiveCompletedEventHandler(queue_ReceiveCompleted);

                    queue.BeginReceive();
                }
            }
            catch (Exception ex)
            {
                Logger.Log(ex, new UserContext("FileCreationService"));
            }
        }

        void queue_ReceiveCompleted(object sender, ReceiveCompletedEventArgs e)
        {
            try
            {
                long id = (long)e.Message.Body;
                var user = new UserContext("FileCreationService");

                _engine.CreateFileForExportLog(id, user);

                //Listen for next message
                Run();
            }
            catch (Exception ex)
            {
                Logger.Log(ex, new UserContext("FileCreationService"));
            }

        }
    }
}
