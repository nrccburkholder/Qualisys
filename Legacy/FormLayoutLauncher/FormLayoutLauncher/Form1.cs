using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using System.Diagnostics;

namespace FormLayoutLauncher
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            System.IO.File.Copy("FormLayout.exe", "c:\\program files\\qualisys\\FormLayout.exe", true);
            Process.Start("FormLayout.exe");
        }

        private void Form1_Activated(object sender, EventArgs e)
        {
            this.Close();
        }
    }
}
