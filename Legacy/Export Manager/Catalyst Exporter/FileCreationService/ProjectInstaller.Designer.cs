namespace FileCreationService
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
            this.fileCreationServiceProcessInstaller = new System.ServiceProcess.ServiceProcessInstaller();
            this.CatalystExporter_FileCreationServiceInstaller = new System.ServiceProcess.ServiceInstaller();
            // 
            // fileCreationServiceProcessInstaller
            // 
            this.fileCreationServiceProcessInstaller.Password = null;
            this.fileCreationServiceProcessInstaller.Username = null;
            // 
            // CatalystExporter_FileCreationServiceInstaller
            // 
            this.CatalystExporter_FileCreationServiceInstaller.Description = "File Creation Service for Catalyst Data Exports.";
            this.CatalystExporter_FileCreationServiceInstaller.DisplayName = "Catalyst Exporter File Creation Service";
            this.CatalystExporter_FileCreationServiceInstaller.ServiceName = "CatalystExport_FileCreationService";
            this.CatalystExporter_FileCreationServiceInstaller.StartType = System.ServiceProcess.ServiceStartMode.Automatic;
            // 
            // ProjectInstaller
            // 
            this.Installers.AddRange(new System.Configuration.Install.Installer[] {
            this.fileCreationServiceProcessInstaller,
            this.CatalystExporter_FileCreationServiceInstaller});

        }

        #endregion

        private System.ServiceProcess.ServiceProcessInstaller fileCreationServiceProcessInstaller;
        private System.ServiceProcess.ServiceInstaller CatalystExporter_FileCreationServiceInstaller;
    }
}