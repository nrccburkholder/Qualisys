using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using NRC = NRCFileConverterLibrary.Common;
using NRCFileConverterLibrary.Processor;
using NRCFileConverterLibrary.Common;
using NRCFileConverterLibrary.Extensions;
using System.Configuration;

namespace FileFormatConverter
{
    public partial class formNRCFileConverter : Form
    {
       
        public formNRCFileConverter()
        {
           InitializeComponent();
           btnEnd.Enabled = false;
        }

        private void btnStart_Click(object sender, EventArgs e)
        {            
            btnStart.Enabled = false;
            btnEnd.Enabled = true;
            Logs.Info("NRCFileConverter Started");

            int mseconds;
            timerFileConverter.Tick += timerFileConverter_Tick;
            if (!int.TryParse(ConfigurationManager.AppSettings["TimerInterval"], out mseconds))
            {
                mseconds = 180000;//set it to 3 minutes                
                Logs.Warn("AppSetting ' TimerInterval' is either missing or not an integer.");
            }
            timerFileConverter.Interval = mseconds;
            timerFileConverter.Start();
        }

        void timerFileConverter_Tick(object sender, EventArgs e)
        {            
            Logs.Info("NRCFileConverter Timer Started");

            var processor = new Processor();
            processor.LogTraceListeners += processor_LogTraceListeners;
            processor.Process();
        }

        void processor_LogTraceListeners(object sender, LogTraceArgs e)
        {
            AppendToTextBoxWithScrolling(e.Message);
        }

        private void AppendToTextBoxWithScrolling(string message)
        {
            int selLength = txtLogs.SelectionLength, selStart = txtLogs.SelectionStart;

            txtLogs.AppendText(message);
            txtLogs.AppendText(Environment.NewLine);

            txtLogs.Focus();

            if (chkBoxAutoScroll.Checked)
            {
                txtLogs.SelectionStart = int.MaxValue;
                txtLogs.SelectionLength = 0;
            }
            else
            {
                txtLogs.SelectionStart = selStart;
                txtLogs.SelectionLength = selLength;
            }
            txtLogs.ScrollToCaret();
        }

        private void btnEnd_Click(object sender, EventArgs e)
        {
            Logs.Info("NRCFileConverter Stopped");
            timerFileConverter.Stop();
            btnStart.Enabled = true;
            btnEnd.Enabled = false;
        }

        private void btnClearLog_Click(object sender, EventArgs e)
        {
            txtLogs.Clear();
        }
    }
}
