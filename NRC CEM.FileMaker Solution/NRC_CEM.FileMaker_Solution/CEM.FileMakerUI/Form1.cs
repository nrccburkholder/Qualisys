using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using CEM.Exporting;
using System.Configuration;

namespace CEM.FileMakerUI
{
    public partial class Form1 : Form
    {

        private int currentSurveyTypeId = 0;
        private int? currentTemplateId = 0;
        private int? currentQueueId = 0;

        private List<string> Messages;
        

        public Form1()
        {
            System.Windows.Forms.Application.Idle += new EventHandler(OnIdle);
            InitializeComponent();
        }

        #region events


        protected void OnIdle(object sender, EventArgs e)
        {
            btnRun.Enabled = (GetCheckedQueueFileCounts() > 0);
        }

        private void Form1_Load(object sender, EventArgs e)
        {            
            Messages = new List<string>();
            richTextBox1.Clear();
            btnRun.Enabled = false;
            dgTemplates.AutoGenerateColumns = false;
            dgQueues.AutoGenerateColumns = false;
            dgQueueFiles.AutoGenerateColumns = false;        
            LoadSurveyTypeComboBox();
            AddTemplateColumns();
            AddQueueColumns();
            AddQueueFileColumns();
            cmbxSurveyType.SelectedIndex = -1;

            toolStripStatusLabel1.Text = string.Format("Environment: {0}", GetEnvironment());

            //LoadData();
        }

        private void cmbxSurveyType_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (cmbxSurveyType.SelectedIndex >= 0)
            {
                SurveyType selectedSurveyType = (SurveyType)cmbxSurveyType.SelectedItem;
                int surveyTypeId = selectedSurveyType.SurveyTypeID;
                if (surveyTypeId != currentSurveyTypeId)
                {
                    currentSurveyTypeId = surveyTypeId;
                    ClearTemplatesGrid();
                    ClearQueuesGrid();
                    ClearQueueFilesGrid();
                    LoadTemplates(surveyTypeId);
                    //LoadTemplateDS(surveyTypeId);


                    //templateBindingSource.Filter = "[SurveyTypeID]  = 11";
                    //dgTemplates.Refresh();
                }
                
            }
            //else
            //{
            //    templateBindingSource.Filter = "";
            //    dgTemplates.Refresh();
            //}   
        }

        //private void dgTemplates_CellValueChanged(object sender, DataGridViewCellEventArgs e)
        //{
        //    //if (e.ColumnIndex == 0 && e.RowIndex > -1)
        //    //{

        //    //    //foreach (DataGridViewRow r in dgTemplates.Rows)
        //    //    //{
        //    //    //    if ((r.Index != e.RowIndex) && (r.Index > -1))
        //    //    //    {
        //    //    //        r.Cells[0].Value = false;
        //    //    //    }
        //    //    //}

        //    //    bool selected = (bool)dgTemplates[e.ColumnIndex, e.RowIndex].Value;

        //    //    dgTemplates.Rows[e.RowIndex].DefaultCellStyle.BackColor = selected ? Color.LightGray : Color.Empty;

        //    //    if (selected)
        //    //    {
        //    //        int id = (int)dgTemplates[1, e.RowIndex].Value;
        //    //        LoadQueueFiles(id);
        //    //    }             
        //    //}
        //}

        //private void dgTemplates_CellMouseUp(object sender, DataGridViewCellMouseEventArgs e)
        //{
        //    //if (e.ColumnIndex == 0 && e.RowIndex > -1)
        //    //{
        //    //    dgTemplates.EndEdit();
        //    //}
        //}

        private void dgTemplates_RowHeaderMouseClick(object sender, DataGridViewCellMouseEventArgs e)
        {
            if (e.RowIndex > -1)
            {
                //DataRow row = ((DataRowView)dgTemplates.Rows[e.RowIndex].DataBoundItem).Row;
                //ExportTemplate selectedTemplate = ExportTemplate.PopulateExportTemplate(row);
                ExportTemplate selectedTemplate = (ExportTemplate)dgTemplates.Rows[e.RowIndex].DataBoundItem;

                if (selectedTemplate.ExportTemplateID != currentTemplateId)
                {
                    currentTemplateId = selectedTemplate.ExportTemplateID;
                    ClearQueuesGrid();
                    ClearQueueFilesGrid();
                    LoadQueues(selectedTemplate);
                }
            }
        }

        private void dgQueues_RowHeaderMouseClick(object sender, DataGridViewCellMouseEventArgs e)
        {
            if (e.RowIndex > -1)
            {
                //DataRow row = ((DataRowView)dgQueues.Rows[e.RowIndex].DataBoundItem).Row;
                //ExportQueue selectedQueue = ExportQueue.PopulateExportQueue(row);
                ExportQueue selectedQueue = (ExportQueue)dgQueues.Rows[e.RowIndex].DataBoundItem;

                if (selectedQueue.ExportQueueID != currentQueueId)
                {
                    currentQueueId = selectedQueue.ExportQueueID;
                    ClearQueueFilesGrid();
                    LoadQueueFiles(selectedQueue);
                }

            }
        }

        private void btnRun_Click(object sender, EventArgs e)
        {
            richTextBox1.Clear();
            ToggleEnabled(false);
            this.pictureBox1.Image = Properties.Resources.Animation1;
            btnRun.Enabled = false;
            backgroundWorker1.RunWorkerAsync(1);
        }

        private void dgQueueFiles_CellValueChanged(object sender, DataGridViewCellEventArgs e)
        {
            //do nothing
        }

        private void dgQueueFiles_CellMouseUp(object sender, DataGridViewCellMouseEventArgs e)
        {
            dgQueueFiles.EndEdit();
        }

        private void runAllToolStripMenuItem_Click(object sender, EventArgs e)
        {
            cmbxSurveyType.SelectedIndex = -1;
            ClearTemplatesGrid();
            ClearQueuesGrid();
            ClearQueueFilesGrid();
            richTextBox1.Clear();
            richTextBox1.AppendText("Running all..." + Environment.NewLine);
            ToggleEnabled(false);
            this.pictureBox1.Image = Properties.Resources.Animation1;
            btnRun.Enabled = false;
            backgroundWorker1.RunWorkerAsync(0);
        }

        private void exitToolStripMenuItem_Click(object sender, EventArgs e)
        {
            Application.Exit();
        }

        #region backgroundworker events

        private void backgroundWorker1_DoWork(object sender, DoWorkEventArgs e)
        {
            try
            {
                MakeFiles(e.Argument);              
            } catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
                backgroundWorker1.CancelAsync();
            }
            
        }

        private void backgroundWorker1_RunWorkerCompleted(object sender, RunWorkerCompletedEventArgs e)
        {
            pictureBox1.Image = null;
            ToggleEnabled(true);
            LoadMessages();
            LoadQueueFiles(new ExportQueue { ExportQueueID = currentQueueId });
        }

        #endregion

        #endregion

        private void ToggleEnabled(bool state)
        {
            cmbxSurveyType.Enabled = state;
            btnRun.Enabled = state;
            dgTemplates.Enabled = state;
            dgQueues.Enabled = state;
            dgQueueFiles.Enabled = state;
            menuStrip1.Enabled = state;
        }

        private void MakeFiles(object argument)
        {
            
            if ((int)argument == 1)
            {
                List<ExportQueueFile> filesToMake = new List<ExportQueueFile>();
                foreach (DataGridViewRow row in dgQueueFiles.Rows)
                {
                    if (Convert.ToBoolean(row.Cells[0].Value))
                    {
                        filesToMake.Add((ExportQueueFile)row.DataBoundItem);
                        //DataRow r = ((DataRowView)row.DataBoundItem).Row;
                        //filesToMake.Add(ExportQueueFile.PopulateExportQueueFile(r));
                    }
                }
                if (filesToMake.Count > 0)
                {
                    try
                    {
                        Messages = Exporter.MakeFiles(filesToMake);
                    }
                    catch (Exception ex)
                    {
                        richTextBox1.AppendText(ex.Message + Environment.NewLine + ex.StackTrace);
                    }
                }
            }
            else
            {
                try
                {
                    Messages = Exporter.MakeFiles();
                }
                catch (Exception ex)
                {
                    richTextBox1.AppendText(ex.Message + Environment.NewLine + ex.StackTrace);
                }


            }

           
        }

        private void LoadMessages()
        { 
            foreach (string item in Messages)
            {
                richTextBox1.AppendText(item + Environment.NewLine);
            }
        }

        private void clearSelectedQueueFiles()
        {
            foreach (DataGridViewRow row in dgQueueFiles.Rows)
            {
                row.Cells[0].Value = false;
            }
        }

        private void LoadSurveyTypeComboBox()
        {
            cmbxSurveyType.DataSource = SurveyType.Select();
            cmbxSurveyType.DisplayMember = "SurveyTypeName";
            cmbxSurveyType.ValueMember = "SurveyTypeID";
        }

        private void LoadTemplates(int surveyTypeId)
        {
            richTextBox1.Clear();
            List<ExportTemplate> templates = ExportTemplate.Select(new ExportTemplate { SurveyTypeID = surveyTypeId });
            dgTemplates.DataSource = templates;         
        }

        private void AddTemplateColumns()
        {

            DataGridViewTextBoxColumn idColumn = new DataGridViewTextBoxColumn();
            idColumn.Name = "ID";
            idColumn.DataPropertyName = "ExportTemplateID";
            idColumn.ReadOnly = true;

            dgTemplates.Columns.Add(idColumn);

            DataGridViewTextBoxColumn surveyTypeIdColumn = new DataGridViewTextBoxColumn();
            surveyTypeIdColumn.Name = "Survey Type";
            surveyTypeIdColumn.DataPropertyName = "SurveyTypeID";
            surveyTypeIdColumn.ReadOnly = true;

            dgTemplates.Columns.Add(surveyTypeIdColumn);

            DataGridViewTextBoxColumn nameColumn = new DataGridViewTextBoxColumn();
            nameColumn.Name = "Name";
            nameColumn.DataPropertyName = "ExportTemplateName";
            nameColumn.ReadOnly = true;

            dgTemplates.Columns.Add(nameColumn);


            DataGridViewTextBoxColumn MajorVersionColumn = new DataGridViewTextBoxColumn();
            MajorVersionColumn.Name = "Major Version";
            MajorVersionColumn.DataPropertyName = "ExportTemplateVersionMajor";
            MajorVersionColumn.ReadOnly = true;

            dgTemplates.Columns.Add(MajorVersionColumn);

            DataGridViewTextBoxColumn minorVersionColumn = new DataGridViewTextBoxColumn();
            minorVersionColumn.Name = "Minor Version";
            minorVersionColumn.DataPropertyName = "ExportTemplateVersionMinor";
            minorVersionColumn.ReadOnly = true;

            dgTemplates.Columns.Add(minorVersionColumn);

            DataGridViewTextBoxColumn startDateColumn = new DataGridViewTextBoxColumn();
            startDateColumn.Name = "Start Date";
            startDateColumn.DataPropertyName = "ValidStartDate";
            startDateColumn.ReadOnly = true;

            dgTemplates.Columns.Add(startDateColumn);

            DataGridViewTextBoxColumn endDateColumn = new DataGridViewTextBoxColumn();
            endDateColumn.Name = "End Date";
            endDateColumn.DataPropertyName = "ValidEndDate";
            endDateColumn.ReadOnly = true;

            dgTemplates.Columns.Add(endDateColumn);

            dgTemplates.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.AllCells;

        }

        private void LoadQueues(ExportTemplate template)
        {
            List<ExportQueue> queues = ExportQueue.Select(new ExportQueue { ExportTemplateName = template.ExportTemplateName, ExportTemplateVersionMajor =template.ExportTemplateVersionMajor, ExportTemplateVersionMinor = template.ExportTemplateVersionMinor });
            dgQueues.DataSource = queues;
        }

        private void AddQueueColumns()
        {


            DataGridViewTextBoxColumn idColumn = new DataGridViewTextBoxColumn();
            idColumn.Name = "ID";
            idColumn.DataPropertyName = "ExportQueueID";
            idColumn.ReadOnly = true;

            dgQueues.Columns.Add(idColumn);


            DataGridViewTextBoxColumn nameColumn = new DataGridViewTextBoxColumn();
            nameColumn.Name = "Name";
            nameColumn.DataPropertyName = "ExportTemplateName";
            nameColumn.ReadOnly = true;

            dgQueues.Columns.Add(nameColumn);


            DataGridViewTextBoxColumn MajorVersionColumn = new DataGridViewTextBoxColumn();
            MajorVersionColumn.Name = "Major Version";
            MajorVersionColumn.DataPropertyName = "ExportTemplateVersionMajor";
            MajorVersionColumn.ReadOnly = true;

            dgQueues.Columns.Add(MajorVersionColumn);

            DataGridViewTextBoxColumn minorVersionColumn = new DataGridViewTextBoxColumn();
            minorVersionColumn.Name = "Minor Version";
            minorVersionColumn.DataPropertyName = "ExportTemplateVersionMinor";
            minorVersionColumn.ReadOnly = true;

            dgQueues.Columns.Add(minorVersionColumn);

            DataGridViewTextBoxColumn startDateColumn = new DataGridViewTextBoxColumn();
            startDateColumn.Name = "Start Date";
            startDateColumn.DataPropertyName = "ExportDateStart";
            startDateColumn.ReadOnly = true;

            dgQueues.Columns.Add(startDateColumn);

            DataGridViewTextBoxColumn endDateColumn = new DataGridViewTextBoxColumn();
            endDateColumn.Name = "End Date";
            endDateColumn.DataPropertyName = "ExportDateEnd";
            endDateColumn.ReadOnly = true;

            dgQueues.Columns.Add(endDateColumn);

            dgQueues.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.AllCells;

        }

        private void LoadQueueFiles(ExportQueue queue)
        {         
            List<ExportQueueFile> queueFiles = ExportQueueFile.Select(new ExportQueueFile { ExportQueueID = queue.ExportQueueID });
            dgQueueFiles.DataSource = queueFiles;
        }

        private void AddQueueFileColumns()
        {
            DataGridViewCheckBoxColumn selectedColumn = new DataGridViewCheckBoxColumn();

            dgQueueFiles.Columns.Add(selectedColumn);

            DataGridViewTextBoxColumn idColumn = new DataGridViewTextBoxColumn();
            idColumn.Name = "ID";
            idColumn.DataPropertyName = "ExportQueueFileID";
            idColumn.ReadOnly = true;
            idColumn.Visible = false;

            dgQueueFiles.Columns.Add(idColumn);

            DataGridViewTextBoxColumn exportQueueIdColumn = new DataGridViewTextBoxColumn();
            exportQueueIdColumn.Name = "Queue ID";
            exportQueueIdColumn.DataPropertyName = "ExportQueueID";
            exportQueueIdColumn.ReadOnly = true;

            dgQueueFiles.Columns.Add(exportQueueIdColumn);

            DataGridViewTextBoxColumn fileStateColumn = new DataGridViewTextBoxColumn();
            fileStateColumn.Name = "File State";
            fileStateColumn.DataPropertyName = "FileState";
            fileStateColumn.ReadOnly = true;

            dgQueueFiles.Columns.Add(fileStateColumn);

            DataGridViewTextBoxColumn fileMakerTypeColumn = new DataGridViewTextBoxColumn();
            fileMakerTypeColumn.Name = "File Type";
            fileMakerTypeColumn.DataPropertyName = "FileMakerType";
            fileMakerTypeColumn.ReadOnly = true;

            dgQueueFiles.Columns.Add(fileMakerTypeColumn);

            DataGridViewTextBoxColumn fileMakerNameColumn = new DataGridViewTextBoxColumn();
            fileMakerNameColumn.Name = "File Name";
            fileMakerNameColumn.DataPropertyName = "FileMakerName";
            fileMakerNameColumn.ReadOnly = true;

            dgQueueFiles.Columns.Add(fileMakerNameColumn);

            DataGridViewTextBoxColumn fileMakerDateColumn = new DataGridViewTextBoxColumn();
            fileMakerDateColumn.Name = "File Created";
            fileMakerDateColumn.DataPropertyName = "FileMakerDate";
            fileMakerDateColumn.ReadOnly = true;

            dgQueueFiles.Columns.Add(fileMakerDateColumn);

            dgQueueFiles.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.AllCells;

        }
        
        private void ClearTemplatesGrid()
        {
            LoadTemplates(0);
            currentTemplateId = 0;
            richTextBox1.Clear();
        }

        private void ClearQueueFilesGrid()
        {
            LoadQueueFiles(new ExportQueue { ExportQueueID = 0 });
            richTextBox1.Clear();
        }

        private void ClearQueuesGrid()
        {
            LoadQueues(new ExportTemplate { ExportTemplateName = string.Empty });
            currentQueueId = 0;
            richTextBox1.Clear();
        }

        private int GetCheckedQueueFileCounts()
        {
            int iCnt = 0;
            foreach (DataGridViewRow row in dgQueueFiles.Rows)
            {
                if (Convert.ToBoolean(row.Cells[0].Value))
                {
                    iCnt++;
                }
            }

            return iCnt;
        }

        private void LoadTemplateDS(int surveyTypeId)
        {
            //richTextBox1.Clear();
            //DataSet ds = ExportTemplate.SelectAsDataSet(new ExportTemplate { SurveyTypeID = surveyTypeId });
            //templateBindingSource.DataSource = ds;
            //templateBindingSource.DataMember = "Templates";
            //dgTemplates.DataSource = templateBindingSource;
            
        }

        private void LoadQueueDS(ExportTemplate template)
        {
            //richTextBox1.Clear();
            //DataSet ds = ExportQueue.SelectAsDataSet(new ExportQueue { ExportTemplateName = template.ExportTemplateName, ExportTemplateVersionMajor = template.ExportTemplateVersionMajor, ExportTemplateVersionMinor = template.ExportTemplateVersionMinor });
            //queueBindingSource.DataSource = ds;
            //queueBindingSource.DataMember = "Queues";
            //dgQueues.DataSource = queueBindingSource;

        }


        private void LoadData()
        {
            richTextBox1.Clear();
            DataSet ds = new DataSet();
            DataTable dtTemplates = ExportTemplate.SelectAsDataTable(new ExportTemplate()).Copy();

            if (dtTemplates.Rows.Count > 0)
            {
                ds.Tables.Add(dtTemplates);

                DataTable dtQueues = ExportQueue.SelectAsDataTable(new ExportQueue()).Copy();


                ds.Tables.Add(dtQueues);
              

                DataRelation relationTemplatesQueues = new DataRelation("TemplatesQueues",
                    ds.Tables["Templates"].Columns["ExportTemplateID"],
                    ds.Tables["Queues"].Columns["ExportTemplateID"]);

                ds.Relations.Add(relationTemplatesQueues);


                DataTable dtQueueFiles = ExportQueueFile.SelectAsDataTable(new ExportQueueFile()).Copy();

                ds.Tables.Add(dtQueueFiles);

                DataRelation relationQueuesQueueFiles = new DataRelation("QueuesQueueFiles",
                   ds.Tables["Queues"].Columns["ExportQueueID"],
                   ds.Tables["QueueFiles"].Columns["ExportQueueID"]);

                ds.Relations.Add(relationQueuesQueueFiles);

                templateBindingSource.DataSource = ds;
                templateBindingSource.DataMember = "Templates";
                dgTemplates.DataSource = templateBindingSource;

                queueBindingSource.DataSource = templateBindingSource;
                queueBindingSource.DataMember = "TemplatesQueues";
                dgQueues.DataSource = queueBindingSource;

                queueFileBindingSource.DataSource = queueBindingSource;
                queueFileBindingSource.DataMember = "QueuesQueueFiles";
                dgQueueFiles.DataSource = queueFileBindingSource;


            }
        }

        private void btnSelectAll_Click(object sender, EventArgs e)
        {

            foreach (DataGridViewRow row in dgQueueFiles.Rows)
            {
                row.Cells[0].Value = "true";
            }
        }

        private void btnUnselectAll_Click(object sender, EventArgs e)
        {
            foreach (DataGridViewRow row in dgQueueFiles.Rows)
            {
                row.Cells[0].Value = "false";
            }
        }

        static string GetEnvironment()
        {
            string connStr = ConfigurationManager.ConnectionStrings["CEMConnection"].ConnectionString.ToUpper();

            if (connStr.Contains("LNK0TCATSQL01")) return "TEST";
            else if (connStr.Contains("STGCATCLUSTDB2")) return "STAGE";
            else return "PROD";

        }
    }
}
