using System;
using System.Collections;
using System.Collections.Generic;
using System.ComponentModel;
using System.Configuration.Install;
using System.IO;
using System.Linq;
using System.Reflection;

namespace NRC.SmartLink.DeploymentHelper
{
    [RunInstaller(true)]
    public partial class ConfigPathWriter : Installer
    {
        public ConfigPathWriter()
        {
            InitializeComponent();
        }

        public override void Install(IDictionary stateSaver)
        {
            base.Install(stateSaver);

            DirectoryInfo targetDir = new FileInfo(Assembly.GetExecutingAssembly().Location).Directory;
            DirectoryInfo configDir = Context.Parameters.ContainsKey("ConfigDir") ? new DirectoryInfo(Context.Parameters["ConfigDir"]) : null;

            if (configDir != null && !configDir.Parent.FullName.Equals(targetDir.FullName))
            {
                StreamWriter fout = new StreamWriter(File.OpenWrite(targetDir.FullName + Path.DirectorySeparatorChar + "SL_Paths.xml"));
                // just going to write literal text instead of xml, because I am lame (and none of the bad xml characters are legal file name characters, right?)
                fout.WriteLine("<?xml version=\"1.0\" encoding=\"utf-8\" ?>");
                fout.WriteLine("<SmartLink>");
                fout.WriteLine("  <PathSettings>");
                fout.WriteLine("    <CustomConfigRootDirPath>" + configDir.FullName + "</CustomConfigRootDirPath>");
                fout.WriteLine("</PathSettings>");
                fout.WriteLine("</SmartLink>");
                fout.Close();
            }
        }
    }
}
