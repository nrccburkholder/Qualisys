namespace CEM.FileMaker
{
    partial class ProjectInstaller
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary> 
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Component Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.FileMakerServiceProcessInstaller = new System.ServiceProcess.ServiceProcessInstaller();
            this.FileMakerServiceInstaller = new System.ServiceProcess.ServiceInstaller();
            // 
            // FileMakerServiceProcessInstaller
            // 
            this.FileMakerServiceProcessInstaller.Account = System.ServiceProcess.ServiceAccount.LocalSystem;
            this.FileMakerServiceProcessInstaller.Password = null;
            this.FileMakerServiceProcessInstaller.Username = null;
            // 
            // FileMakerServiceInstaller
            // 
            this.FileMakerServiceInstaller.ServiceName = "CEM.Filemaker";
            // 
            // ProjectInstaller
            // 
            this.Installers.AddRange(new System.Configuration.Install.Installer[] {
            this.FileMakerServiceProcessInstaller,
            this.FileMakerServiceInstaller});

        }

        #endregion

        private System.ServiceProcess.ServiceProcessInstaller FileMakerServiceProcessInstaller;
        private System.ServiceProcess.ServiceInstaller FileMakerServiceInstaller;
    }
}