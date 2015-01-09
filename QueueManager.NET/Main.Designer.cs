namespace QueueManagerUI
{
    partial class Main
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

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.components = new System.ComponentModel.Container();
            this.splitContainer1 = new System.Windows.Forms.SplitContainer();
            this.panel2 = new System.Windows.Forms.Panel();
            this.lblTitle = new System.Windows.Forms.Label();
            this.rtbxProperties = new System.Windows.Forms.RichTextBox();
            this.panel1 = new System.Windows.Forms.Panel();
            this.btnPrint = new System.Windows.Forms.Button();
            this.btnClose = new System.Windows.Forms.Button();
            this.statusStrip1 = new System.Windows.Forms.StatusStrip();
            this.lblBundlingDate = new System.Windows.Forms.ToolStripStatusLabel();
            this.mnuTreeViewPopUp = new System.Windows.Forms.ContextMenuStrip(this.components);
            this.mnuRollbackGen = new System.Windows.Forms.ToolStripMenuItem();
            this.mnuPopUpPrint = new System.Windows.Forms.ToolStripMenuItem();
            this.mnuPrintSample = new System.Windows.Forms.ToolStripMenuItem();
            this.mnuPrintSampleAllPagesInOneFile = new System.Windows.Forms.ToolStripMenuItem();
            this.mnuPrintSampleOneFilePerPage = new System.Windows.Forms.ToolStripMenuItem();
            this.mnuAddToGroupedPrint = new System.Windows.Forms.ToolStripMenuItem();
            this.mnuBundlingReport = new System.Windows.Forms.ToolStripMenuItem();
            this.mnuPostOfficeReport = new System.Windows.Forms.ToolStripMenuItem();
            this.mnuPopUpDelete = new System.Windows.Forms.ToolStripMenuItem();
            this.mnuMailingDates = new System.Windows.Forms.ToolStripMenuItem();
            this.mnuPopupMarkMailing = new System.Windows.Forms.ToolStripMenuItem();
            this.mnuBundleFlats = new System.Windows.Forms.ToolStripMenuItem();
            this.mnuRemoveFromGroupedPrint = new System.Windows.Forms.ToolStripMenuItem();
            this.mnuMain = new System.Windows.Forms.MenuStrip();
            this.modifyItemsToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.mnuPrint = new System.Windows.Forms.ToolStripMenuItem();
            this.toolStripSeparator1 = new System.Windows.Forms.ToolStripSeparator();
            this.mnuBundle = new System.Windows.Forms.ToolStripMenuItem();
            this.toolStripSeparator2 = new System.Windows.Forms.ToolStripSeparator();
            this.mnuExit = new System.Windows.Forms.ToolStripMenuItem();
            this.viewToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.mnuReprint = new System.Windows.Forms.ToolStripMenuItem();
            this.toolStripSeparator3 = new System.Windows.Forms.ToolStripSeparator();
            this.mnuRefresh = new System.Windows.Forms.ToolStripMenuItem();
            this.mailRoomSupportToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.mnuCallList = new System.Windows.Forms.ToolStripMenuItem();
            this.mnuReprintList = new System.Windows.Forms.ToolStripMenuItem();
            this.helpToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.mnuAbout = new System.Windows.Forms.ToolStripMenuItem();
            this.mnuAboutBox = new System.Windows.Forms.ToolStripMenuItem();
            this.tvPrintQueues = new QueueManagerUI.Extensions.MyTreeView();
            ((System.ComponentModel.ISupportInitialize)(this.splitContainer1)).BeginInit();
            this.splitContainer1.Panel1.SuspendLayout();
            this.splitContainer1.Panel2.SuspendLayout();
            this.splitContainer1.SuspendLayout();
            this.panel2.SuspendLayout();
            this.panel1.SuspendLayout();
            this.statusStrip1.SuspendLayout();
            this.mnuTreeViewPopUp.SuspendLayout();
            this.mnuMain.SuspendLayout();
            this.SuspendLayout();
            // 
            // splitContainer1
            // 
            this.splitContainer1.Dock = System.Windows.Forms.DockStyle.Fill;
            this.splitContainer1.Location = new System.Drawing.Point(0, 24);
            this.splitContainer1.Name = "splitContainer1";
            // 
            // splitContainer1.Panel1
            // 
            this.splitContainer1.Panel1.Controls.Add(this.tvPrintQueues);
            this.splitContainer1.Panel1.Controls.Add(this.panel2);
            // 
            // splitContainer1.Panel2
            // 
            this.splitContainer1.Panel2.Controls.Add(this.rtbxProperties);
            this.splitContainer1.Panel2.Controls.Add(this.panel1);
            this.splitContainer1.Panel2.Controls.Add(this.statusStrip1);
            this.splitContainer1.Size = new System.Drawing.Size(994, 599);
            this.splitContainer1.SplitterDistance = 166;
            this.splitContainer1.TabIndex = 2;
            // 
            // panel2
            // 
            this.panel2.Controls.Add(this.lblTitle);
            this.panel2.Dock = System.Windows.Forms.DockStyle.Top;
            this.panel2.Location = new System.Drawing.Point(0, 0);
            this.panel2.Name = "panel2";
            this.panel2.Size = new System.Drawing.Size(166, 44);
            this.panel2.TabIndex = 0;
            // 
            // lblTitle
            // 
            this.lblTitle.AutoSize = true;
            this.lblTitle.Location = new System.Drawing.Point(3, 27);
            this.lblTitle.Name = "lblTitle";
            this.lblTitle.Size = new System.Drawing.Size(66, 13);
            this.lblTitle.TabIndex = 0;
            this.lblTitle.Tag = "TreeView:";
            this.lblTitle.Text = "Print Queue:";
            // 
            // rtbxProperties
            // 
            this.rtbxProperties.Dock = System.Windows.Forms.DockStyle.Fill;
            this.rtbxProperties.Location = new System.Drawing.Point(0, 44);
            this.rtbxProperties.Name = "rtbxProperties";
            this.rtbxProperties.Size = new System.Drawing.Size(824, 533);
            this.rtbxProperties.TabIndex = 2;
            this.rtbxProperties.Text = "";
            // 
            // panel1
            // 
            this.panel1.Controls.Add(this.btnPrint);
            this.panel1.Controls.Add(this.btnClose);
            this.panel1.Dock = System.Windows.Forms.DockStyle.Top;
            this.panel1.Location = new System.Drawing.Point(0, 0);
            this.panel1.Name = "panel1";
            this.panel1.Size = new System.Drawing.Size(824, 44);
            this.panel1.TabIndex = 1;
            // 
            // btnPrint
            // 
            this.btnPrint.Location = new System.Drawing.Point(665, 4);
            this.btnPrint.Name = "btnPrint";
            this.btnPrint.Size = new System.Drawing.Size(75, 36);
            this.btnPrint.TabIndex = 1;
            this.btnPrint.Text = "&Print";
            this.btnPrint.UseVisualStyleBackColor = true;
            this.btnPrint.Click += new System.EventHandler(this.btnPrint_Click);
            // 
            // btnClose
            // 
            this.btnClose.Location = new System.Drawing.Point(746, 4);
            this.btnClose.Name = "btnClose";
            this.btnClose.Size = new System.Drawing.Size(75, 36);
            this.btnClose.TabIndex = 0;
            this.btnClose.Text = "&Close";
            this.btnClose.UseVisualStyleBackColor = true;
            this.btnClose.Click += new System.EventHandler(this.btnClose_Click);
            // 
            // statusStrip1
            // 
            this.statusStrip1.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.lblBundlingDate});
            this.statusStrip1.Location = new System.Drawing.Point(0, 577);
            this.statusStrip1.Name = "statusStrip1";
            this.statusStrip1.Size = new System.Drawing.Size(824, 22);
            this.statusStrip1.TabIndex = 0;
            this.statusStrip1.Text = "statusStrip1";
            // 
            // lblBundlingDate
            // 
            this.lblBundlingDate.Name = "lblBundlingDate";
            this.lblBundlingDate.Size = new System.Drawing.Size(92, 17);
            this.lblBundlingDate.Text = "lblBundlingDate";
            // 
            // mnuTreeViewPopUp
            // 
            this.mnuTreeViewPopUp.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.mnuRollbackGen,
            this.mnuPopUpPrint,
            this.mnuPrintSample,
            this.mnuAddToGroupedPrint,
            this.mnuBundlingReport,
            this.mnuPostOfficeReport,
            this.mnuPopUpDelete,
            this.mnuMailingDates,
            this.mnuPopupMarkMailing,
            this.mnuBundleFlats,
            this.mnuRemoveFromGroupedPrint});
            this.mnuTreeViewPopUp.Name = "TreeViewPopUp";
            this.mnuTreeViewPopUp.Size = new System.Drawing.Size(224, 246);
            // 
            // mnuRollbackGen
            // 
            this.mnuRollbackGen.Name = "mnuRollbackGen";
            this.mnuRollbackGen.Size = new System.Drawing.Size(223, 22);
            this.mnuRollbackGen.Text = "&Rollback Generation";
            // 
            // mnuPopUpPrint
            // 
            this.mnuPopUpPrint.Name = "mnuPopUpPrint";
            this.mnuPopUpPrint.Size = new System.Drawing.Size(223, 22);
            this.mnuPopUpPrint.Text = "&Print";
            // 
            // mnuPrintSample
            // 
            this.mnuPrintSample.DropDownItems.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.mnuPrintSampleAllPagesInOneFile,
            this.mnuPrintSampleOneFilePerPage});
            this.mnuPrintSample.Name = "mnuPrintSample";
            this.mnuPrintSample.Size = new System.Drawing.Size(223, 22);
            this.mnuPrintSample.Text = "View S&ample";
            // 
            // mnuPrintSampleAllPagesInOneFile
            // 
            this.mnuPrintSampleAllPagesInOneFile.Name = "mnuPrintSampleAllPagesInOneFile";
            this.mnuPrintSampleAllPagesInOneFile.Size = new System.Drawing.Size(181, 22);
            this.mnuPrintSampleAllPagesInOneFile.Text = "&All Pages in One File";
            // 
            // mnuPrintSampleOneFilePerPage
            // 
            this.mnuPrintSampleOneFilePerPage.Name = "mnuPrintSampleOneFilePerPage";
            this.mnuPrintSampleOneFilePerPage.Size = new System.Drawing.Size(181, 22);
            this.mnuPrintSampleOneFilePerPage.Text = "&One File per Page";
            // 
            // mnuAddToGroupedPrint
            // 
            this.mnuAddToGroupedPrint.Name = "mnuAddToGroupedPrint";
            this.mnuAddToGroupedPrint.Size = new System.Drawing.Size(223, 22);
            this.mnuAddToGroupedPrint.Text = "&Add to Grouped Print";
            // 
            // mnuBundlingReport
            // 
            this.mnuBundlingReport.Name = "mnuBundlingReport";
            this.mnuBundlingReport.Size = new System.Drawing.Size(223, 22);
            this.mnuBundlingReport.Text = "&Bundling Report";
            // 
            // mnuPostOfficeReport
            // 
            this.mnuPostOfficeReport.Name = "mnuPostOfficeReport";
            this.mnuPostOfficeReport.Size = new System.Drawing.Size(223, 22);
            this.mnuPostOfficeReport.Text = "Post &Office Report";
            // 
            // mnuPopUpDelete
            // 
            this.mnuPopUpDelete.Name = "mnuPopUpDelete";
            this.mnuPopUpDelete.Size = new System.Drawing.Size(223, 22);
            this.mnuPopUpDelete.Text = "&Delete";
            // 
            // mnuMailingDates
            // 
            this.mnuMailingDates.Name = "mnuMailingDates";
            this.mnuMailingDates.Size = new System.Drawing.Size(223, 22);
            this.mnuMailingDates.Text = "&Set Mailing Dates";
            // 
            // mnuPopupMarkMailing
            // 
            this.mnuPopupMarkMailing.Name = "mnuPopupMarkMailing";
            this.mnuPopupMarkMailing.Size = new System.Drawing.Size(223, 22);
            this.mnuPopupMarkMailing.Text = "Mark for &Mailing";
            // 
            // mnuBundleFlats
            // 
            this.mnuBundleFlats.Name = "mnuBundleFlats";
            this.mnuBundleFlats.Size = new System.Drawing.Size(223, 22);
            this.mnuBundleFlats.Text = "Bundle for &Flats";
            // 
            // mnuRemoveFromGroupedPrint
            // 
            this.mnuRemoveFromGroupedPrint.Name = "mnuRemoveFromGroupedPrint";
            this.mnuRemoveFromGroupedPrint.Size = new System.Drawing.Size(223, 22);
            this.mnuRemoveFromGroupedPrint.Text = "Remove &from Grouped Print";
            // 
            // mnuMain
            // 
            this.mnuMain.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.modifyItemsToolStripMenuItem,
            this.viewToolStripMenuItem,
            this.mailRoomSupportToolStripMenuItem,
            this.helpToolStripMenuItem});
            this.mnuMain.Location = new System.Drawing.Point(0, 0);
            this.mnuMain.Name = "mnuMain";
            this.mnuMain.Size = new System.Drawing.Size(994, 24);
            this.mnuMain.TabIndex = 3;
            this.mnuMain.Text = "menuStrip1";
            // 
            // modifyItemsToolStripMenuItem
            // 
            this.modifyItemsToolStripMenuItem.DropDownItems.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.mnuPrint,
            this.toolStripSeparator1,
            this.mnuBundle,
            this.toolStripSeparator2,
            this.mnuExit});
            this.modifyItemsToolStripMenuItem.Name = "modifyItemsToolStripMenuItem";
            this.modifyItemsToolStripMenuItem.Size = new System.Drawing.Size(89, 20);
            this.modifyItemsToolStripMenuItem.Text = "&Modify Items";
            // 
            // mnuPrint
            // 
            this.mnuPrint.Name = "mnuPrint";
            this.mnuPrint.ShortcutKeys = ((System.Windows.Forms.Keys)((System.Windows.Forms.Keys.Control | System.Windows.Forms.Keys.P)));
            this.mnuPrint.Size = new System.Drawing.Size(152, 22);
            this.mnuPrint.Text = "Print";
            this.mnuPrint.Click += new System.EventHandler(this.mnuPrint_Click);
            // 
            // toolStripSeparator1
            // 
            this.toolStripSeparator1.Name = "toolStripSeparator1";
            this.toolStripSeparator1.Size = new System.Drawing.Size(149, 6);
            // 
            // mnuBundle
            // 
            this.mnuBundle.Name = "mnuBundle";
            this.mnuBundle.Size = new System.Drawing.Size(152, 22);
            this.mnuBundle.Text = "Bundle";
            this.mnuBundle.Click += new System.EventHandler(this.mnuBundle_Click);
            // 
            // toolStripSeparator2
            // 
            this.toolStripSeparator2.Name = "toolStripSeparator2";
            this.toolStripSeparator2.Size = new System.Drawing.Size(149, 6);
            // 
            // mnuExit
            // 
            this.mnuExit.Name = "mnuExit";
            this.mnuExit.Size = new System.Drawing.Size(152, 22);
            this.mnuExit.Text = "Exit";
            this.mnuExit.Click += new System.EventHandler(this.mnuExit_Click);
            // 
            // viewToolStripMenuItem
            // 
            this.viewToolStripMenuItem.DropDownItems.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.mnuReprint,
            this.toolStripSeparator3,
            this.mnuRefresh});
            this.viewToolStripMenuItem.Name = "viewToolStripMenuItem";
            this.viewToolStripMenuItem.Size = new System.Drawing.Size(44, 20);
            this.viewToolStripMenuItem.Text = "&View";
            // 
            // mnuReprint
            // 
            this.mnuReprint.Name = "mnuReprint";
            this.mnuReprint.ShortcutKeys = ((System.Windows.Forms.Keys)((System.Windows.Forms.Keys.Control | System.Windows.Forms.Keys.Q)));
            this.mnuReprint.Size = new System.Drawing.Size(223, 22);
            this.mnuReprint.Text = "View Mailing Queue";
            this.mnuReprint.Click += new System.EventHandler(this.mnuReprint_Click);
            // 
            // toolStripSeparator3
            // 
            this.toolStripSeparator3.Name = "toolStripSeparator3";
            this.toolStripSeparator3.Size = new System.Drawing.Size(220, 6);
            // 
            // mnuRefresh
            // 
            this.mnuRefresh.Name = "mnuRefresh";
            this.mnuRefresh.Size = new System.Drawing.Size(223, 22);
            this.mnuRefresh.Text = "Refresh";
            this.mnuRefresh.Click += new System.EventHandler(this.mnuRefresh_Click);
            // 
            // mailRoomSupportToolStripMenuItem
            // 
            this.mailRoomSupportToolStripMenuItem.DropDownItems.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.mnuCallList,
            this.mnuReprintList});
            this.mailRoomSupportToolStripMenuItem.Name = "mailRoomSupportToolStripMenuItem";
            this.mailRoomSupportToolStripMenuItem.Size = new System.Drawing.Size(122, 20);
            this.mailRoomSupportToolStripMenuItem.Text = "Mail &Room Support";
            // 
            // mnuCallList
            // 
            this.mnuCallList.Name = "mnuCallList";
            this.mnuCallList.Size = new System.Drawing.Size(152, 22);
            this.mnuCallList.Text = "Call List";
            this.mnuCallList.Click += new System.EventHandler(this.mnuCallList_Click);
            // 
            // mnuReprintList
            // 
            this.mnuReprintList.Name = "mnuReprintList";
            this.mnuReprintList.Size = new System.Drawing.Size(152, 22);
            this.mnuReprintList.Text = "Reprint List";
            this.mnuReprintList.Click += new System.EventHandler(this.mnuReprintList_Click);
            // 
            // helpToolStripMenuItem
            // 
            this.helpToolStripMenuItem.DropDownItems.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.mnuAbout,
            this.mnuAboutBox});
            this.helpToolStripMenuItem.Name = "helpToolStripMenuItem";
            this.helpToolStripMenuItem.Size = new System.Drawing.Size(44, 20);
            this.helpToolStripMenuItem.Text = "&Help";
            // 
            // mnuAbout
            // 
            this.mnuAbout.Name = "mnuAbout";
            this.mnuAbout.ShortcutKeys = System.Windows.Forms.Keys.F1;
            this.mnuAbout.Size = new System.Drawing.Size(152, 22);
            this.mnuAbout.Text = "About";
            this.mnuAbout.Click += new System.EventHandler(this.mnuAbout_Click);
            // 
            // mnuAboutBox
            // 
            this.mnuAboutBox.Name = "mnuAboutBox";
            this.mnuAboutBox.Size = new System.Drawing.Size(152, 22);
            this.mnuAboutBox.Text = "About Box";
            this.mnuAboutBox.Click += new System.EventHandler(this.mnuAboutBox_Click);
            // 
            // tvPrintQueues
            // 
            this.tvPrintQueues.Dock = System.Windows.Forms.DockStyle.Fill;
            this.tvPrintQueues.Location = new System.Drawing.Point(0, 44);
            this.tvPrintQueues.Name = "tvPrintQueues";
            this.tvPrintQueues.Size = new System.Drawing.Size(166, 555);
            this.tvPrintQueues.TabIndex = 1;
            this.tvPrintQueues.MouseUp += new System.Windows.Forms.MouseEventHandler(this.tvPrintQueues_MouseUp);
            // 
            // frmMain
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(994, 623);
            this.Controls.Add(this.splitContainer1);
            this.Controls.Add(this.mnuMain);
            this.MainMenuStrip = this.mnuMain;
            this.Name = "frmMain";
            this.Text = "Print Queue Manager";
            this.splitContainer1.Panel1.ResumeLayout(false);
            this.splitContainer1.Panel2.ResumeLayout(false);
            this.splitContainer1.Panel2.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)(this.splitContainer1)).EndInit();
            this.splitContainer1.ResumeLayout(false);
            this.panel2.ResumeLayout(false);
            this.panel2.PerformLayout();
            this.panel1.ResumeLayout(false);
            this.statusStrip1.ResumeLayout(false);
            this.statusStrip1.PerformLayout();
            this.mnuTreeViewPopUp.ResumeLayout(false);
            this.mnuMain.ResumeLayout(false);
            this.mnuMain.PerformLayout();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.SplitContainer splitContainer1;
        private System.Windows.Forms.Panel panel2;
        private System.Windows.Forms.Label lblTitle;
        private System.Windows.Forms.Panel panel1;
        private System.Windows.Forms.Button btnPrint;
        private System.Windows.Forms.Button btnClose;
        private System.Windows.Forms.StatusStrip statusStrip1;
        private System.Windows.Forms.MenuStrip mnuMain;
        private System.Windows.Forms.ToolStripMenuItem modifyItemsToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem mnuPrint;
        private System.Windows.Forms.ToolStripMenuItem mnuBundle;
        private System.Windows.Forms.ToolStripMenuItem mnuExit;
        private System.Windows.Forms.ToolStripMenuItem viewToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem mnuReprint;
        private System.Windows.Forms.ToolStripMenuItem mnuRefresh;
        private System.Windows.Forms.ToolStripMenuItem mailRoomSupportToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem mnuCallList;
        private System.Windows.Forms.ToolStripMenuItem mnuReprintList;
        private System.Windows.Forms.ToolStripMenuItem helpToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem mnuAbout;
        private System.Windows.Forms.ToolStripMenuItem mnuAboutBox;
        private System.Windows.Forms.ToolStripSeparator toolStripSeparator1;
        private System.Windows.Forms.ToolStripSeparator toolStripSeparator2;
        private System.Windows.Forms.ToolStripSeparator toolStripSeparator3;
        private System.Windows.Forms.RichTextBox rtbxProperties;
        private System.Windows.Forms.ToolStripStatusLabel lblBundlingDate;
        private System.Windows.Forms.ContextMenuStrip mnuTreeViewPopUp;
        private System.Windows.Forms.ToolStripMenuItem mnuRollbackGen;
        private System.Windows.Forms.ToolStripMenuItem mnuPopUpPrint;
        private System.Windows.Forms.ToolStripMenuItem mnuPrintSample;
        private System.Windows.Forms.ToolStripMenuItem mnuPrintSampleAllPagesInOneFile;
        private System.Windows.Forms.ToolStripMenuItem mnuPrintSampleOneFilePerPage;
        private System.Windows.Forms.ToolStripMenuItem mnuAddToGroupedPrint;
        private System.Windows.Forms.ToolStripMenuItem mnuBundlingReport;
        private System.Windows.Forms.ToolStripMenuItem mnuPostOfficeReport;
        private System.Windows.Forms.ToolStripMenuItem mnuPopUpDelete;
        private System.Windows.Forms.ToolStripMenuItem mnuMailingDates;
        private System.Windows.Forms.ToolStripMenuItem mnuPopupMarkMailing;
        private System.Windows.Forms.ToolStripMenuItem mnuBundleFlats;
        private System.Windows.Forms.ToolStripMenuItem mnuRemoveFromGroupedPrint;
        private Extensions.MyTreeView tvPrintQueues;
    }
}

