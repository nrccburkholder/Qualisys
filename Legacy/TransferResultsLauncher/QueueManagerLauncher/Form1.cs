using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using System.Diagnostics;
using System.Security.Principal;

namespace QueueManagerLauncher
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        private void Form1_Load(object sender, EventArgs e)
        {
/*            if (!System.IO.Directory.Exists(@"c:\program files\qualisys"))
                System.IO.Directory.CreateDirectory(@"c:\program files\qualisys");
            if (System.IO.File.Exists(@"c:\program files\qualisys\QueueManDLL.dll"))
            {
                if (FileVersionInfo.GetVersionInfo(@"c:\program files\qualisys\QueueManDLL.dll").FileMinorPart < 4)
                {
                    ReregisterExistingQueueManDll();
                    CopyAndRegisterQueueManDLL();
                }
            }
            else
            {
                ReregisterExistingQueueManDll();
                CopyAndRegisterQueueManDLL();
            }
*/
            Process.Start("QueueManager.exe");
        }

        //private void ReregisterExistingQueueManDll()
        //{
        //    if ((System.Environment.OSVersion.Version.Major >= 6) && System.IO.File.Exists(@"c:\program files (x86)\qualisys\QueueManDLL.dll"))
        //    {
        //        try
        //        {
        //            //                    MessageBox.Show("Copy", "QueueManDLL.dll");

        //            string arg_fileinfo = "/s + /u" + " " + @"""c:\program files (x86)\qualisys\QueueManDLL.dll"""; /* +" " + @"/i:""delete " + @"""c:\program files (x86)\qualisys\QueueManDLL.dll""";*/
        //            Process reg = new Process();
        //            //                    MessageBox.Show(reg.StartInfo.Domain, reg.StartInfo.UserName);
        //            reg.StartInfo.FileName = "regsvr32.exe";
        //            reg.StartInfo.WorkingDirectory = @"c:\windows\system32";
        //            reg.StartInfo.Arguments = arg_fileinfo;
        //            reg.StartInfo.UseShellExecute = true;
        //            reg.StartInfo.WindowStyle = ProcessWindowStyle.Normal;
        //            reg.StartInfo.Verb = "runas";
        //            reg.Start();
        //            reg.WaitForExit();
        //            reg.Close();
        //        }
        //        //                    MessageBox.Show("Process", "Close");
        //        catch (Exception exc)
        //        {
        //            MessageBox.Show(exc.StackTrace, exc.Message);
        //        }
        //    }
        //}

        //private static void CopyAndRegisterQueueManDLL()
        //{
        //    //            MessageBox.Show("Enter","QueueManagerLauncher");
        //    try
        //    {
        //        System.IO.File.Copy("QueueManDLL.dll", @"c:\program files\qualisys\QueueManDLL.dll", true);

        //        //                    MessageBox.Show("Copy", "QueueManDLL.dll");

        //        string domain = WindowsIdentity.GetCurrent().Name.ToString();
        //        //                    MessageBox.Show("domain", domain);

        //        string arg_fileinfo = "/s" + " " + @"""c:\program files\qualisys\QueueManDLL.dll""";
        //        Process reg = new Process();
        //        //                    MessageBox.Show(reg.StartInfo.Domain, reg.StartInfo.UserName);
        //        reg.StartInfo.FileName = "regsvr32.exe";
        //        reg.StartInfo.WorkingDirectory = @"c:\windows\system32";
        //        reg.StartInfo.Arguments = arg_fileinfo;
        //        if (System.Environment.OSVersion.Version.Major >= 6)
        //        {
        //            reg.StartInfo.UseShellExecute = true;
        //            reg.StartInfo.WindowStyle = ProcessWindowStyle.Normal;
        //            reg.StartInfo.Verb = "runas";
        //        }
        //        else
        //        {
        //            reg.StartInfo.Password = new System.Security.SecureString();
        //            //This file registers .dll files as command components in the registry.
        //            if (domain.ToLower().Contains("testnrcus"))
        //            {
        //                reg.StartInfo.Domain = "testnrcus";
        //                reg.StartInfo.UserName = "alfred";
        //                foreach (char c in "alfredadmin") { reg.StartInfo.Password.AppendChar(c); }
        //            }
        //            else if (domain.ToLower().Contains("stagenrcus"))
        //            {
        //                reg.StartInfo.Domain = "stagenrcus";
        //                reg.StartInfo.UserName = "alfred";
        //                foreach (char c in "alfredadmin") { reg.StartInfo.Password.AppendChar(c); }
        //            }
        //            else
        //            {
        //                reg.StartInfo.Domain = "nrc";
        //                reg.StartInfo.UserName = "#AppDeploy";
        //                foreach (char c in "?cS5T>4c?B6bGt3)") { reg.StartInfo.Password.AppendChar(c); }
        //            }
        //            reg.StartInfo.UseShellExecute = false;
        //        }
        //        reg.Start();
        //        reg.WaitForExit();
        //        reg.Close();

        //        //                    MessageBox.Show("Process", "Close");
        //    }
        //    catch (Exception exc)
        //    {
        //        MessageBox.Show(exc.StackTrace, exc.Message);
        //    }
        //}

        private void Form1_Activated(object sender, EventArgs e)
        {
            this.Close();
        }
    }
}
