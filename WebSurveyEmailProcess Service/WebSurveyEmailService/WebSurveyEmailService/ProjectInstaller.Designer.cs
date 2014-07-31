namespace WebSurveyEmailService
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
            this.WebSurveyEmailProcessInstaller = new System.ServiceProcess.ServiceProcessInstaller();
            this.WebSurveyEmailServiceInstaller = new System.ServiceProcess.ServiceInstaller();
            // 
            // WebSurveyEmailProcessInstaller
            // 
            this.WebSurveyEmailProcessInstaller.Account = System.ServiceProcess.ServiceAccount.LocalSystem;
            this.WebSurveyEmailProcessInstaller.Password = null;
            this.WebSurveyEmailProcessInstaller.Username = null;
            // 
            // WebSurveyEmailServiceInstaller
            // 
            this.WebSurveyEmailServiceInstaller.ServiceName = "WebSurveyEmailService";
            this.WebSurveyEmailServiceInstaller.StartType = System.ServiceProcess.ServiceStartMode.Automatic;
            // 
            // ProjectInstaller
            // 
            this.Installers.AddRange(new System.Configuration.Install.Installer[] {
            this.WebSurveyEmailProcessInstaller,
            this.WebSurveyEmailServiceInstaller});

        }

        #endregion

        private System.ServiceProcess.ServiceProcessInstaller WebSurveyEmailProcessInstaller;
        private System.ServiceProcess.ServiceInstaller WebSurveyEmailServiceInstaller;
    }
}