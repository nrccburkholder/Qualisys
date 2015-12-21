namespace CEM.FileMakerUI
{
    partial class Form1
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
            this.cmbxSurveyType = new System.Windows.Forms.ComboBox();
            this.label1 = new System.Windows.Forms.Label();
            this.dgTemplates = new System.Windows.Forms.DataGridView();
            this.label2 = new System.Windows.Forms.Label();
            this.dgQueueFiles = new System.Windows.Forms.DataGridView();
            this.label3 = new System.Windows.Forms.Label();
            this.dgQueues = new System.Windows.Forms.DataGridView();
            this.label4 = new System.Windows.Forms.Label();
            this.btnRun = new System.Windows.Forms.Button();
            this.backgroundWorker1 = new System.ComponentModel.BackgroundWorker();
            this.pictureBox1 = new System.Windows.Forms.PictureBox();
            this.menuStrip1 = new System.Windows.Forms.MenuStrip();
            this.fileToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.runAllToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.exitToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.statusStrip1 = new System.Windows.Forms.StatusStrip();
            this.richTextBox1 = new System.Windows.Forms.RichTextBox();
            ((System.ComponentModel.ISupportInitialize)(this.dgTemplates)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.dgQueueFiles)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.dgQueues)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.pictureBox1)).BeginInit();
            this.menuStrip1.SuspendLayout();
            this.SuspendLayout();
            // 
            // cmbxSurveyType
            // 
            this.cmbxSurveyType.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.cmbxSurveyType.FormattingEnabled = true;
            this.cmbxSurveyType.Location = new System.Drawing.Point(85, 51);
            this.cmbxSurveyType.Name = "cmbxSurveyType";
            this.cmbxSurveyType.Size = new System.Drawing.Size(121, 21);
            this.cmbxSurveyType.TabIndex = 0;
            this.cmbxSurveyType.SelectedIndexChanged += new System.EventHandler(this.cmbxSurveyType_SelectedIndexChanged);
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(12, 54);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(67, 13);
            this.label1.TabIndex = 1;
            this.label1.Text = "Survey Type";
            // 
            // dgTemplates
            // 
            this.dgTemplates.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dgTemplates.Location = new System.Drawing.Point(15, 102);
            this.dgTemplates.MultiSelect = false;
            this.dgTemplates.Name = "dgTemplates";
            this.dgTemplates.Size = new System.Drawing.Size(837, 150);
            this.dgTemplates.TabIndex = 2;
            this.dgTemplates.RowHeaderMouseClick += new System.Windows.Forms.DataGridViewCellMouseEventHandler(this.dgTemplates_RowHeaderMouseClick);
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(15, 83);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(56, 13);
            this.label2.TabIndex = 3;
            this.label2.Text = "Templates";
            // 
            // dgQueueFiles
            // 
            this.dgQueueFiles.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dgQueueFiles.Location = new System.Drawing.Point(116, 463);
            this.dgQueueFiles.MultiSelect = false;
            this.dgQueueFiles.Name = "dgQueueFiles";
            this.dgQueueFiles.RowHeadersVisible = false;
            this.dgQueueFiles.ShowEditingIcon = false;
            this.dgQueueFiles.Size = new System.Drawing.Size(736, 150);
            this.dgQueueFiles.TabIndex = 4;
            this.dgQueueFiles.CellMouseUp += new System.Windows.Forms.DataGridViewCellMouseEventHandler(this.dgQueueFiles_CellMouseUp);
            this.dgQueueFiles.CellValueChanged += new System.Windows.Forms.DataGridViewCellEventHandler(this.dgQueueFiles_CellValueChanged);
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Location = new System.Drawing.Point(116, 444);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(63, 13);
            this.label3.TabIndex = 5;
            this.label3.Text = "Queue Files";
            // 
            // dgQueues
            // 
            this.dgQueues.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dgQueues.Location = new System.Drawing.Point(66, 281);
            this.dgQueues.MultiSelect = false;
            this.dgQueues.Name = "dgQueues";
            this.dgQueues.Size = new System.Drawing.Size(786, 150);
            this.dgQueues.TabIndex = 6;
            this.dgQueues.RowHeaderMouseClick += new System.Windows.Forms.DataGridViewCellMouseEventHandler(this.dgQueues_RowHeaderMouseClick);
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Location = new System.Drawing.Point(66, 262);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(44, 13);
            this.label4.TabIndex = 7;
            this.label4.Text = "Queues";
            // 
            // btnRun
            // 
            this.btnRun.Location = new System.Drawing.Point(18, 463);
            this.btnRun.Name = "btnRun";
            this.btnRun.Size = new System.Drawing.Size(92, 51);
            this.btnRun.TabIndex = 8;
            this.btnRun.Text = "Make File(s)";
            this.btnRun.UseVisualStyleBackColor = true;
            this.btnRun.Click += new System.EventHandler(this.btnRun_Click);
            // 
            // backgroundWorker1
            // 
            this.backgroundWorker1.DoWork += new System.ComponentModel.DoWorkEventHandler(this.backgroundWorker1_DoWork);
            this.backgroundWorker1.RunWorkerCompleted += new System.ComponentModel.RunWorkerCompletedEventHandler(this.backgroundWorker1_RunWorkerCompleted);
            // 
            // pictureBox1
            // 
            this.pictureBox1.Location = new System.Drawing.Point(33, 520);
            this.pictureBox1.Name = "pictureBox1";
            this.pictureBox1.Size = new System.Drawing.Size(61, 61);
            this.pictureBox1.TabIndex = 10;
            this.pictureBox1.TabStop = false;
            // 
            // menuStrip1
            // 
            this.menuStrip1.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.fileToolStripMenuItem});
            this.menuStrip1.Location = new System.Drawing.Point(0, 0);
            this.menuStrip1.Name = "menuStrip1";
            this.menuStrip1.Size = new System.Drawing.Size(877, 24);
            this.menuStrip1.TabIndex = 12;
            this.menuStrip1.Text = "menuStrip1";
            // 
            // fileToolStripMenuItem
            // 
            this.fileToolStripMenuItem.DropDownItems.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.runAllToolStripMenuItem,
            this.exitToolStripMenuItem});
            this.fileToolStripMenuItem.Name = "fileToolStripMenuItem";
            this.fileToolStripMenuItem.Size = new System.Drawing.Size(37, 20);
            this.fileToolStripMenuItem.Text = "File";
            // 
            // runAllToolStripMenuItem
            // 
            this.runAllToolStripMenuItem.Name = "runAllToolStripMenuItem";
            this.runAllToolStripMenuItem.Size = new System.Drawing.Size(112, 22);
            this.runAllToolStripMenuItem.Text = "Run All";
            this.runAllToolStripMenuItem.Click += new System.EventHandler(this.runAllToolStripMenuItem_Click);
            // 
            // exitToolStripMenuItem
            // 
            this.exitToolStripMenuItem.Name = "exitToolStripMenuItem";
            this.exitToolStripMenuItem.Size = new System.Drawing.Size(112, 22);
            this.exitToolStripMenuItem.Text = "Exit";
            this.exitToolStripMenuItem.Click += new System.EventHandler(this.exitToolStripMenuItem_Click);
            // 
            // statusStrip1
            // 
            this.statusStrip1.Location = new System.Drawing.Point(0, 772);
            this.statusStrip1.Name = "statusStrip1";
            this.statusStrip1.Size = new System.Drawing.Size(877, 22);
            this.statusStrip1.TabIndex = 13;
            this.statusStrip1.Text = "statusStrip1";
            // 
            // richTextBox1
            // 
            this.richTextBox1.DetectUrls = false;
            this.richTextBox1.Dock = System.Windows.Forms.DockStyle.Bottom;
            this.richTextBox1.Location = new System.Drawing.Point(0, 638);
            this.richTextBox1.Name = "richTextBox1";
            this.richTextBox1.Size = new System.Drawing.Size(877, 134);
            this.richTextBox1.TabIndex = 14;
            this.richTextBox1.Text = "";
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.White;
            this.ClientSize = new System.Drawing.Size(877, 794);
            this.Controls.Add(this.richTextBox1);
            this.Controls.Add(this.statusStrip1);
            this.Controls.Add(this.pictureBox1);
            this.Controls.Add(this.btnRun);
            this.Controls.Add(this.label4);
            this.Controls.Add(this.dgQueues);
            this.Controls.Add(this.label3);
            this.Controls.Add(this.dgQueueFiles);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.dgTemplates);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.cmbxSurveyType);
            this.Controls.Add(this.menuStrip1);
            this.MainMenuStrip = this.menuStrip1;
            this.Name = "Form1";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "CEM File Maker ";
            this.Load += new System.EventHandler(this.Form1_Load);
            ((System.ComponentModel.ISupportInitialize)(this.dgTemplates)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.dgQueueFiles)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.dgQueues)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.pictureBox1)).EndInit();
            this.menuStrip1.ResumeLayout(false);
            this.menuStrip1.PerformLayout();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.ComboBox cmbxSurveyType;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.DataGridView dgTemplates;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.DataGridView dgQueueFiles;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.DataGridView dgQueues;
        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.Button btnRun;
        private System.Windows.Forms.PictureBox pictureBox1;
        private System.ComponentModel.BackgroundWorker backgroundWorker1;
        private System.Windows.Forms.MenuStrip menuStrip1;
        private System.Windows.Forms.RichTextBox richTextBox1;
        private System.Windows.Forms.StatusStrip statusStrip1;
        private System.Windows.Forms.ToolStripMenuItem fileToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem runAllToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem exitToolStripMenuItem;
    }
}

