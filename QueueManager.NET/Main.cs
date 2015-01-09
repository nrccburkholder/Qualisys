using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using Nrc.Framework.BusinessLogic;
using QueueManagerUI.Extensions;
using QueueManagerUI.Enums;
using QueueManagerLibrary;
using QueueManagerLibrary.Objects;

namespace QueueManagerUI
{
    public partial class Main : Form
    {
        

        #region private members

        private QueueManager moQueueManager;
        private bool mIsReprint;
        private bool mIsTreeSel;
        private bool mIsListSel;
        private bool mIsActivated;
        private Int64 mUniqueKey = 0;
        private object mStartLitho;
        private object mEndLitho;
        private Int64 buttonUsed;
        private ImageList imgList = new ImageList();
        private List<SurveyTypes> CAHPSList = new List<SurveyTypes>();
        private SurveyTypes DefaultSurveyType = new SurveyTypes();
        private ApplicationMode AppMode;
        private DateTime LastBundlingDate;

        ReprintDates frmReprintDates = new ReprintDates();
        

        #endregion

        #region constants

            const int SPLITLIMIT = 5250;

        #endregion

            #region events

            private void Application_Idle(Object sender, EventArgs e)
            {
                btnPrint.Enabled = (tvPrintQueues.Nodes.Count > 0 && tvPrintQueues.SelectedNode != null);
            }

            private void btnClose_Click(object sender, EventArgs e)
            {
                this.Close();
            }

            private void btnPrint_Click(object sender, EventArgs e)
            {
                if (tvPrintQueues.SelectedNode != null)
                {
                    TreeNodeEx node = (TreeNodeEx)tvPrintQueues.SelectedNode;

                    if (node.NodeType == NodeTypes.Hospital || node.NodeType == NodeTypes.CheckedHospital)
                    {
                        Print();
                    }
                    else
                    {
                        MessageBox.Show("You cannot print from this level.", "Queue Manager Warning", MessageBoxButtons.OK, MessageBoxIcon.Information);
                    }
                }
                else
                {
                    MessageBox.Show("You cannot print from this level.", "Queue Manager Warning", MessageBoxButtons.OK, MessageBoxIcon.Information);
                }
            }

            private void mnuReprint_Click(object sender, EventArgs e)
            {
                tvPrintQueues.Nodes.Clear();

                if (this.AppMode == ApplicationMode.MailingQueueManager)
                {
                    PreparePrintQueue();
                }
                else
                {
                    PrepareMailingQueue();                 
                }
                             
                mnuBundle.Visible = true;
                toolStripSeparator1.Visible = true;
                
                LoadQueue();

                ShowAboutInfo();
            }
    
            private void tvPrintQueues_MouseUp(object sender, MouseEventArgs e)
            {
            bool isReprint = (this.AppMode == ApplicationMode.PrintQueueManager);
            bool isShowGroupedPrint = moQueueManager.ShowGroupedPrint();

            mIsTreeSel = true;
            mIsListSel = false;

            TreeNodeEx selectedNode = (TreeNodeEx)tvPrintQueues.GetNodeAt(new Point(e.X, e.Y));

            if (selectedNode == null) return;

            switch (e.Button)
            {
                case MouseButtons.Right:

                    NodeTypes nodeType = selectedNode.NodeType;

                    switch (nodeType)
                    {

                        case NodeTypes.Configuration:
                        case NodeTypes.AlreadyMailed:

                            mnuPopUpPrint.Visible = true;
                            mnuPopUpDelete.Text = "&Delete";
                            if (isReprint)
                            {
                                mnuPopUpPrint.Text = "&Reprint";
                                mnuAddToGroupedPrint.Visible = false;
                                mnuPrintSample.Visible = false;
                                mnuBundleFlats.Visible = false;
                                mnuBundlingReport.Visible = true;
                                mnuMailingDates.Visible = (nodeType == NodeTypes.Configuration);
                            }
                            else
                            {
                                mnuPopUpPrint.Text = "&Print";
                                mnuAddToGroupedPrint.Visible = isShowGroupedPrint;
                                mnuPrintSample.Visible = true;
                                mnuBundleFlats.Visible = true;
                                mnuBundlingReport.Visible = false;
                                mnuMailingDates.Visible = false;
                            }

                            mnuPopUpPrint.Enabled = true;
                            mnuAddToGroupedPrint.Enabled = isShowGroupedPrint;
                            mnuPrintSample.Enabled = true;
                            mnuBundleFlats.Enabled = true;
                            mnuPopupMarkMailing.Visible = false;
                            mnuRollbackGen.Visible = true;

                            mnuPostOfficeReport.Visible = (nodeType == NodeTypes.AlreadyMailed);
                            mnuRemoveFromGroupedPrint.Visible = false;

                            if (!selectedNode.Name.Contains("(unbundled)"))
                            {
                                this.mnuTreeViewPopUp.Show(tvPrintQueues, new Point(e.X, e.Y));
                            }

                            break;
                        case NodeTypes.Bundle:
                        case NodeTypes.MailBundle:
                            mnuPopUpPrint.Visible = true;
                            mnuPopUpDelete.Text = "&Delete";
                            mnuAddToGroupedPrint.Visible = false;
                            if (isReprint)
                            {
                                mnuPopUpPrint.Text = "&Reprint";                               
                                mnuPrintSample.Visible = false;
                                mnuBundleFlats.Visible = false;
                                mnuBundlingReport.Visible = true;
                                mnuPopupMarkMailing.Visible = true;
                                mnuMailingDates.Visible = true;
                            }
                            else
                            {
                                mnuPopUpPrint.Text = "&Print";
                                mnuPrintSample.Visible = true;
                                mnuBundleFlats.Visible = false;
                                mnuBundlingReport.Visible = false;
                                mnuMailingDates.Visible = false;
                                mnuPopupMarkMailing.Text = nodeType == NodeTypes.Bundle ? "Mark for &Mailing" : "Unmark for &Mailing";

                            }

                            mnuPopUpPrint.Enabled = true;
                            mnuAddToGroupedPrint.Enabled = isShowGroupedPrint;
                            mnuPrintSample.Enabled = true;
                            mnuBundleFlats.Enabled = true;                           
                            mnuRollbackGen.Visible = true;
                            mnuPostOfficeReport.Visible = false;
                            mnuRemoveFromGroupedPrint.Visible = false;

                            this.mnuTreeViewPopUp.Show(tvPrintQueues, new Point(e.X, e.Y));
  
                            break;
                        case NodeTypes.Deleted:

                            mnuPopUpDelete.Text = "&UnDelete";
                            mnuPopUpPrint.Enabled = false;
                            mnuPopUpPrint.Visible = false;
                            mnuAddToGroupedPrint.Enabled = false;
                            mnuPrintSample.Enabled = false;
                            mnuBundleFlats.Enabled = false;

                            this.mnuTreeViewPopUp.Show(tvPrintQueues, new Point(e.X, e.Y));
                            ShowProperties(null);

                            break;
                        case NodeTypes.FadedConfiguration:

                            mnuRemoveFromGroupedPrint.Visible = isShowGroupedPrint;
                            mnuPrintSample.Visible = true;
                            mnuAddToGroupedPrint.Visible = false;
                            mnuBundleFlats.Visible = false;
                            mnuBundlingReport.Visible = false;
                            mnuMailingDates.Visible = false;
                            mnuPopUpDelete.Visible = false;
                            mnuPopupMarkMailing.Visible = false;
                            mnuPopUpPrint.Visible = false;
                            mnuPostOfficeReport.Visible = false;
                            mnuRollbackGen.Visible = false;

                            this.mnuTreeViewPopUp.Show(tvPrintQueues, new Point(e.X, e.Y));

                            break;
                        case NodeTypes.GroupedPrintConfiguration:
                        case NodeTypes.CheckedConfiguration:
                            mnuPopUpPrint.Text = isReprint ? "&Reprint" : "&Print";
                            mnuMailingDates.Visible = isReprint && nodeType != NodeTypes.CheckedConfiguration;
                            mnuPopUpPrint.Visible = true;
                            mnuPrintSample.Visible = false;
                            mnuAddToGroupedPrint.Visible = false;
                            mnuBundleFlats.Visible = false;
                            mnuBundlingReport.Visible = isReprint;
                            mnuPopUpDelete.Visible = false;
                            mnuPopupMarkMailing.Visible = false;
                            mnuPostOfficeReport.Visible = isReprint;
                            mnuRollbackGen.Visible = false;
                            mnuRemoveFromGroupedPrint.Visible = false;

                            this.mnuTreeViewPopUp.Show(tvPrintQueues, new Point(e.X, e.Y));

                            break;            
                        case NodeTypes.GroupedPrintHospital:

                            mnuRemoveFromGroupedPrint.Visible = isShowGroupedPrint;
                            mnuPrintSample.Visible = true;
                            mnuAddToGroupedPrint.Visible = false;
                            mnuBundleFlats.Visible = false;
                            mnuBundlingReport.Visible = false;
                            mnuMailingDates.Visible = false;
                            mnuPopUpDelete.Visible = false;
                            mnuPopupMarkMailing.Visible = false;
                            mnuPopUpPrint.Visible = false;
                            mnuPostOfficeReport.Visible = false;
                            mnuRollbackGen.Visible = false;
                            if (!isReprint)
                            {
                                this.mnuTreeViewPopUp.Show(tvPrintQueues, new Point(e.X, e.Y));
                            }

                            break;
                        default:
                            break;
                    }

                    break;
                case MouseButtons.Left:

                    if (selectedNode.Text != "")
                    {
                        ShowProperties((TreeNodeEx)selectedNode);
                    }

                    break;
                default:
                    break;
            }
        }

            private void mnuAbout_Click(object sender, EventArgs e)
            {
                ShowAboutInfo();
            }


            private void mnuPrint_Click(object sender, EventArgs e)
            {

            }

            private void mnuBundle_Click(object sender, EventArgs e)
            {

            }

            private void mnuExit_Click(object sender, EventArgs e)
            {

            }

            private void mnuRefresh_Click(object sender, EventArgs e)
            {

            }

            private void mnuCallList_Click(object sender, EventArgs e)
            {

            }

            private void mnuReprintList_Click(object sender, EventArgs e)
            {

            }

            private void mnuAboutBox_Click(object sender, EventArgs e)
            {

            }

 
            #endregion

        public Main()
        {
            InitializeComponent();

            InitializeUI(); 
        }

        private void InitializeUI()
        {

            Application.Idle += new EventHandler(Application_Idle);
            

            tvPrintQueues.Nodes.Clear();
            tvPrintQueues.ShowNodeToolTips = false;
            lblBundlingDate.Text = "";
            AppMode = ApplicationMode.PrintQueueManager;
            moQueueManager = new QueueManager();
            mIsReprint = true;
            PopulateImageList();
        }

        #region private methods

        private void LoadQueue()
        {

            Cursor.Current = Cursors.WaitCursor;

            bool isEmpty = true;

            rtbxProperties.Clear();

            rtbxProperties.SelectionAlignment = HorizontalAlignment.Center;
            rtbxProperties.SelectionFont = new Font("Lucinda Console", 12);
            rtbxProperties.SelectedText = "Showing available configurations...\n\n ";

            List<Client> clients = new List<Client>();
            clients = moQueueManager.LoadClients(mIsReprint);

            if (this.AppMode == ApplicationMode.PrintQueueManager)
            {
                LastBundlingDate = moQueueManager.GetLastBundleDate();
                lblBundlingDate.Text = string.Format("Last Bundling Date: {0}", LastBundlingDate.ToString("mm/dd/yyyy hh:nn:ss AM/PM"));
            }

            if (clients.Count > 0)
            {
                isEmpty = false;
                foreach (Client client in clients){
                    string key = string.Format("{0}|{1}|{2}", client.ClientName.Trim(),client.SurveyName.Trim(),client.SurveyID.ToString().Trim());
                    TreeNodeEx node = new TreeNodeEx();
                    node.Tag = client;
                    node.SurveyType_ID = client.SurveyType_ID;
                    node.Text = string.Format("{0} ({1} - {2})", client.ClientName.Trim(), client.SurveyName.Trim(), client.SurveyID.ToString().Trim());
                    node.ImageIndex = GetImageIndexBySurveyTypeID(client.SurveyType_ID).Hospital;
                    node.SelectedImageIndex = node.ImageIndex;

                    node.Properties.Add("ClientName", client.ClientName.Trim());
                    node.Properties.Add("SurveyName", client.SurveyName.Trim());
                    node.Properties.Add("SurveyID", client.SurveyID.ToString().Trim());

                    node.Name = key;
                    node.NodeType = NodeTypes.Hospital;

                    if (client.Configurations.Count > 0)
                    {
                        foreach (Configuration config in client.Configurations)
                        {
                            TreeNodeEx configNode = new TreeNodeEx();
                            configNode.Tag = config;
                            configNode.SurveyType_ID = client.SurveyType_ID;
                            configNode.Text = string.Format("{0}", config.PaperConfig_Name);
                            if (config.NumPieces == config.NumberMailed)
                            {
                                configNode.ImageIndex = GetImageIndexBySurveyTypeID(client.SurveyType_ID).CheckedConfiguration;
                                configNode.NodeType = NodeTypes.CheckedConfiguration;
                            }
                            else
                            {
                                configNode.ImageIndex = GetImageIndexBySurveyTypeID(client.SurveyType_ID).Configuration;
                                configNode.NodeType = NodeTypes.Configuration;
                            }
                            configNode.SelectedImageIndex = configNode.ImageIndex;

                            string configkey = string.Format("{0}|{1}|{2}", config.PaperConfig_Name, config.NumPieces.ToString(), config.Survey_ID.ToString());

                            configNode.Properties.Add("ConfigName", config.PaperConfig_Name);
                            configNode.Properties.Add("NumPieces", config.NumPieces.ToString());
                            configNode.Properties.Add("SurveyID", config.Survey_ID.ToString());

                            configNode.Name = configkey;

                            
                            foreach (PaperConfig paperConfig in config.PaperConfigList)
                            {
                                TreeNodeEx paperConfigNode = new TreeNodeEx();
                                paperConfigNode.Tag = paperConfig;
                                paperConfigNode.SurveyType_ID = client.SurveyType_ID;

                                paperConfigNode.Text = paperConfig.PostalBundle == null ? "Not Bundled" : paperConfig.PostalBundle;

                                if (paperConfig.DateMailed.Length == 0)
                                {
                                    paperConfigNode.ImageIndex = GetImageIndexBySurveyTypeID(client.SurveyType_ID).Bundle;
                                    paperConfigNode.NodeType = NodeTypes.Bundle;
                                }
                                else
                                {
                                    paperConfigNode.ImageIndex = GetImageIndexBySurveyTypeID(client.SurveyType_ID).AlreadyMailed;
                                    paperConfigNode.NodeType = NodeTypes.AlreadyMailed;
                                }

                                paperConfigNode.SelectedImageIndex = paperConfigNode.ImageIndex;

                                string strBundleMailed = paperConfig.DateMailed.Length > 0 ? string.Format("This bundle was mailed on {0}", paperConfig.DateMailed) : "";

                                string MinLithoCode = "Unassigned";
                                string MaxLithoCode = string.Empty;
                                if (AppMode == ApplicationMode.MailingQueueManager)
                                {
                                    if (paperConfig.LithocodeRange != null)
                                    {
                                        MinLithoCode = paperConfig.LithocodeRange.MinLitho.ToString();
                                        MaxLithoCode = paperConfig.LithocodeRange.MaxLitho.ToString();
                                    }    
                                }

                                string paperConfigKey = string.Format("{0}|{1}|{2}|{3}|{4}|{5}|{6}|{7}|{8}|{9}", paperConfig.Survey_ID.ToString(), paperConfig.PostalBundle, paperConfig.PaperConfig_ID.ToString(), paperConfig.Pages.ToString(), paperConfig.NumPieces.ToString(), paperConfig.LetterHead.ToString(), MinLithoCode, MaxLithoCode, paperConfig.DateBundled, paperConfig.DateMailed);

                                paperConfigNode.Properties.Add("SurveyID", paperConfig.Survey_ID.ToString());
                                paperConfigNode.Properties.Add("PostalBundle", paperConfig.PostalBundle);
                                paperConfigNode.Properties.Add("PaperConfigID",paperConfig.PaperConfig_ID.ToString());
                                paperConfigNode.Properties.Add("Pages",paperConfig.Pages.ToString());
                                paperConfigNode.Properties.Add("NumPieces",paperConfig.NumPieces.ToString());
                                paperConfigNode.Properties.Add("UseLetterHead",paperConfig.LetterHead.ToString());
                                paperConfigNode.Properties.Add("MinLithoCode", MinLithoCode);
                                paperConfigNode.Properties.Add("MaxLithoCode", MaxLithoCode);
                                paperConfigNode.Properties.Add("DateBundled", paperConfig.DateBundled);
                                paperConfigNode.Properties.Add("DateMailed", paperConfig.DateMailed);
  
                                paperConfigNode.Name = paperConfigKey;

                                configNode.Nodes.Add(paperConfigNode);
                            }

                            node.Nodes.Add(configNode);
       
                        }
                    }


                    tvPrintQueues.Nodes.Add(node);
                }            
            }

            List<GroupedPrint> groupedPrintList = new List<GroupedPrint>();
            groupedPrintList = moQueueManager.LoadGroupedPrintList(mIsReprint);

            if (groupedPrintList.Count > 0)
            {
                TreeNodeEx groupPrintNode;
                isEmpty = false;
                 groupPrintNode = FindNodeByKey("GroupedPrint");

                if (groupPrintNode == null)
                {
                    groupPrintNode = new TreeNodeEx();
                    groupPrintNode.Name = "GroupedPrint";
                    groupPrintNode.Text = "Grouped Print";
                    groupPrintNode.ImageIndex = GetImageIndexBySurveyTypeID(0).GroupedPrint;
                    groupPrintNode.SelectedImageIndex = groupPrintNode.ImageIndex;
                    groupPrintNode.NodeType = NodeTypes.GroupedPrint;
                    tvPrintQueues.Nodes.Add(groupPrintNode);
                }

                foreach (GroupedPrint gp in groupedPrintList)
                {
                    TreeNodeEx node;
                    string key = string.Format("GroupedPrintConfig|{0}|{1}|{2})", gp.PaperConfig_ID, mIsReprint ? gp.DateBundled == string.Empty ? gp.DatePrinted : gp.DateBundled : "" );

                    node = FindNodeByKey(key);
                    if (node == null)
                    {
                        node = new TreeNodeEx();
                        node.Tag = gp;
                        node.Text = string.Format("{0}{1}", mIsReprint ? gp.DatePrinted + " " : "", gp.PaperConfig_Name);
                        node.SurveyType_ID = gp.SurveyType_ID;
                        node.Name = key;
                        node.ImageIndex =  gp.DateMailed < DateTime.Parse("1/1/4000") ? GetImageIndexBySurveyTypeID(gp.SurveyType_ID).CheckedConfiguration : GetImageIndexBySurveyTypeID(gp.SurveyType_ID).GroupedPrintConfiguration;
                        node.SelectedImageIndex = node.ImageIndex;
                        node.NodeType = gp.DateMailed < DateTime.Parse("1/1/4000") ? NodeTypes.CheckedConfiguration : NodeTypes.GroupedPrintConfiguration;
                        groupPrintNode.Nodes.Add(node);
                    }
                    else
                    {
                        GroupedPrint grprt = (GroupedPrint)node.Tag;
                        grprt.NumPieces = grprt.NumPieces + gp.NumPieces;
                        node.Tag = grprt;
                    }

                    //add the detail node
                    TreeNodeEx detailNode = new TreeNodeEx();
                    detailNode.Tag = gp;
                    detailNode.SurveyType_ID = gp.SurveyType_ID;
                    string detailKey = string.Format("GroupedPrintItem|{0}|{1}|{2}|{3}|{4}|{5}", gp.ClientName, gp.PaperConfig_ID, gp.PaperConfig_Name, gp.SurveyDescription, gp.NumPieces, gp.DateMailed < DateTime.Parse("1/1/4000") ? gp.DateMailed.ToShortDateString() : "");
                    detailNode.Name = detailKey;
                    detailNode.Text = string.Format("{0} ({1} - {2})", gp.ClientName, gp.SurveyName,gp.Survey_ID.ToString());
                    detailNode.ImageIndex = gp.DateMailed < DateTime.Parse("1/1/4000") ? GetImageIndexBySurveyTypeID(gp.SurveyType_ID).CheckedGroupedPrintHospital : GetImageIndexBySurveyTypeID(gp.SurveyType_ID).GroupedPrintHospital;
                    detailNode.NodeType = gp.DateMailed < DateTime.Parse("1/1/4000") ? NodeTypes.CheckedGroupedPrintHospital : NodeTypes.GroupedPrintHospital;
                    node.Nodes.Add(detailNode);
                }
            }

            if (isEmpty)
            {
                MessageBox.Show("The Queue is Empty!", "Empty Queue");
                mnuPrint.Enabled = false;
            }
            else
            {
                ShowProperties((TreeNodeEx)tvPrintQueues.Nodes[0]);
            }

            Cursor.Current = Cursors.Default;
        }

        private void CheckConfiguration(TreeNodeEx parentnode, int SurveyID)
        {

            Client client = (Client)parentnode.Tag;
            int SurveyType_ID = client.SurveyType_ID;

            List<Configuration> configList = moQueueManager.LoadConfigurationList(mIsReprint, SurveyID);

            if (configList.Count > 0)
            {
                foreach (Configuration config in configList)
                {
                    TreeNodeEx configNode = new TreeNodeEx();
                    configNode.Tag = config;
                    mUniqueKey += 1;
                    configNode.Text = string.Format("{0}", config.PaperConfig_Name);
                    if (config.NumPieces == config.NumberMailed)
                    {
                        configNode.ImageIndex = GetImageIndexBySurveyTypeID(SurveyType_ID).CheckedConfiguration;
                        configNode.NodeType = NodeTypes.CheckedConfiguration;
                    }
                    else
                    {
                        configNode.ImageIndex = GetImageIndexBySurveyTypeID(SurveyType_ID).Configuration;
                        configNode.NodeType = NodeTypes.Configuration;
                    }
                    configNode.SelectedImageIndex = configNode.ImageIndex;

                    string key = string.Format("{0}|{1}|{2}", config.PaperConfig_Name, config.NumPieces.ToString(), config.Survey_ID.ToString());   
                    configNode.Name = key;

                    parentnode.Nodes.Add(configNode);

                    //key = string.Format("{0}|{1}|{2}|{3}", config.Survey_ID.ToString(), config.PaperConfig_ID.ToString(), config.PaperConfig_Name, config.CheckSum.ToString()); // config.NumberMailed.ToString(), , config.DateMailed < DateTime.Parse("1/1/4000") ? config.DateMailed.ToShortDateString() : "");
                    
                    //TreeNodeEx matchingNode = FindNodeByKey(key);

                    //configNode.Name = key;
                    
                    //if (matchingNode != null)
                    //{
                    //    configNode.Name = key;
                    //}
                    //else
                    //{
                    //    configNode.Name = key;
                    //    parentnode.Nodes.Add(configNode);
                    //}
                }
            }
        }

        private void ShowProperties(TreeNodeEx node)
        {

            NodeTypes nodeType = node == null ? NodeTypes.None : node.NodeType;
            string[] keys;
                switch (nodeType)
                {
                    case NodeTypes.Hospital: case NodeTypes.CheckedHospital:
                       
                        rtbxProperties.Clear();
                        rtbxProperties.SelectionAlignment = HorizontalAlignment.Center;
                        rtbxProperties.SelectionFont = new Font("Lucinda Console", 12);
                        rtbxProperties.SelectedText = string.Format("{0} ({1} - {2})\n\n", node.Properties["ClientName"], node.Properties["SurveyName"], node.Properties["SurveyID"]);

                        break;
                    case NodeTypes.Configuration: case NodeTypes.CheckedConfiguration: case NodeTypes.FadedConfiguration:

                        rtbxProperties.Clear();
                        rtbxProperties.SelectionAlignment = HorizontalAlignment.Center;
                        rtbxProperties.SelectionFont = new Font("Lucinda Console", 12);
                        rtbxProperties.SelectedText = string.Format("{0}\n\n", node.Properties["ConfigName"]);

                        rtbxProperties.SelectionAlignment = HorizontalAlignment.Left;
                        rtbxProperties.SelectedText = string.Format("Number of pieces:\t {0}\n", node.Properties["NumPieces"]);


                        break;
                    case NodeTypes.Bundle: case NodeTypes.AlreadyMailed: case NodeTypes.MailBundle:
                        keys = node.Name.Split('|');

                        rtbxProperties.Clear();
                        rtbxProperties.SelectionAlignment = HorizontalAlignment.Center;
                        rtbxProperties.SelectionFont = new Font("Lucinda Console", 12);
                        rtbxProperties.SelectedText = string.Format("{0}\n\n", node.Properties["PostalBundle"]);

                        rtbxProperties.SelectionAlignment = HorizontalAlignment.Left;
                        if (node.Properties["DateMailed"].Trim().Length > 0)
                        {
                            rtbxProperties.SelectedText = string.Format("This bundle was mailed on:\t {0}\n\n", node.Properties["DateMailed"]);
                        }

                        string LithoCodeRange = node.Properties["MinLithoCode"];

                        if (node.Properties["MaxLithoCode"].Trim().Length > 0)
                        {
                            LithoCodeRange = string.Format("{0} to {1}", node.Properties["MinLithoCode"], node.Properties["MaxLithoCode"]);
                        }
                        string useLetterHead = node.Properties["UseLetterHead"] == "1" ? "Yes" : "No";
                        rtbxProperties.SelectedText = string.Format("Number of pieces:\t {0}\n", node.Properties["NumPieces"]);
                        rtbxProperties.SelectedText = string.Format("Use Letter Head :\t {0}\n", useLetterHead);
                        rtbxProperties.SelectedText = string.Format("LithoCode Range :\t {0}\n", LithoCodeRange); 

                        break;
                    case NodeTypes.Printing:
                        break;
                    case NodeTypes.Deleted:
                        break;
                    case NodeTypes.GroupedPrintHospital:
                        break;
                    case NodeTypes.CheckedGroupedPrintHospital:
                        break;
                    case NodeTypes.GroupedPrintConfiguration:
                        break;
                    default:
                        rtbxProperties.Clear();
                        rtbxProperties.SelectionAlignment = HorizontalAlignment.Center;
                        rtbxProperties.SelectionFont = new Font("Lucinda Console", 12);
                        rtbxProperties.SelectedText = string.Format("{0}\n\n", "National Research Corporation");
                        break;
                }
        }

        private ImageIndexes GetImageIndexBySurveyTypeID(int surveyType_Id)
        {
            if (CAHPSList.Exists(x => x.Survey_ID == surveyType_Id))
                return CAHPSList.Find(x => x.Survey_ID == surveyType_Id).ImageIndexes;
            else return DefaultSurveyType.ImageIndexes;
        }

        private void PopulateImageList()
        {
            imgList.Images.Clear();

            int index = 0;
            Image img; 

            // First, add images that will be used globally or for defaults
            img = Properties.Resources.grouprint;
            imgList.Images.Add(img);
            DefaultSurveyType.ImageIndexes.GroupedPrint = index;
            index += 1;

            img = Properties.Resources.default_folder;
            imgList.Images.Add(img);
            DefaultSurveyType.ImageIndexes.Hospital = index;
            index += 1;

            img = Properties.Resources.default_checkedfolder;
            imgList.Images.Add(img);
            DefaultSurveyType.ImageIndexes.CheckedHospital = index;
            index += 1;

            img = Properties.Resources.default_checkedconfig;
            imgList.Images.Add(img);
            DefaultSurveyType.ImageIndexes.CheckedConfiguration = index;
            index += 1;

            img = Properties.Resources.default_config;
            imgList.Images.Add(img);
            DefaultSurveyType.ImageIndexes.Configuration = index;
            index += 1;

            img = Properties.Resources.default_tag;
            imgList.Images.Add(img);
            DefaultSurveyType.ImageIndexes.Bundle = index;
            index += 1;

            img = Properties.Resources.default_checkedtag;
            imgList.Images.Add(img);
            DefaultSurveyType.ImageIndexes.CheckedBundle = index;
            index += 1;

            img = Properties.Resources.default_mail;
            imgList.Images.Add(img);
            DefaultSurveyType.ImageIndexes.MailedBundle = index;
            index += 1;

            img = Properties.Resources.default_checkedmail;
            imgList.Images.Add(img);
            DefaultSurveyType.ImageIndexes.AlreadyMailed = index;
            index += 1;

            
            //TODO  This list of CAHPS types and colors will come from a table
            CAHPSList.Add(new SurveyTypes { Name = "HCAHPS IP", ColorName = "Cyan", Survey_ID = 2});
            CAHPSList.Add(new SurveyTypes { Name = "Home Health CAHPS", ColorName = "BlueViolet", Survey_ID = 3});
            CAHPSList.Add(new SurveyTypes { Name = "ACOCAHPS", ColorName = "Orange", Survey_ID = 10});
            CAHPSList.Add(new SurveyTypes { Name = "ICHCAHPS", ColorName = "Magenta", Survey_ID = 8});
            CAHPSList.Add(new SurveyTypes { Name = "CGCAHPS", ColorName = "Chartreuse", Survey_ID = 4});
            CAHPSList.Add(new SurveyTypes { Name = "Hospice CAHPS", ColorName = "SkyBlue", Survey_ID = 11});

            foreach (SurveyTypes c in CAHPSList)
            {
                img = Properties.Resources.folder;
                img = QueueManager.ChangeColor(new Bitmap(img), Color.Black, c.ObjectColor);
                imgList.Images.Add(img);
                c.ImageIndexes.Hospital = index;
                index += 1;

                img = Properties.Resources.checkedfolder;
                img = QueueManager.ChangeColor(new Bitmap(img), Color.Black, c.ObjectColor);
                imgList.Images.Add(img);
                c.ImageIndexes.CheckedHospital = index;
                index += 1;

                img = Properties.Resources.checkedconfig;
                img = QueueManager.ChangeColor(new Bitmap(img), Color.Black, c.ObjectColor);
                imgList.Images.Add(img);
                c.ImageIndexes.CheckedConfiguration = index;
                index += 1;

                img = Properties.Resources.config;
                img = QueueManager.ChangeColor(new Bitmap(img), Color.Black, c.ObjectColor);
                imgList.Images.Add(img);
                c.ImageIndexes.Configuration = index;
                index += 1;

                img = Properties.Resources.tag;
                img = QueueManager.ChangeColor(new Bitmap(img), Color.Black, c.ObjectColor);
                imgList.Images.Add(img);
                c.ImageIndexes.Bundle = index;
                index += 1;

                img = Properties.Resources.checkedtag;
                img = QueueManager.ChangeColor(new Bitmap(img), Color.Black, c.ObjectColor);
                imgList.Images.Add(img);
                c.ImageIndexes.CheckedBundle = index;
                index += 1;

                img = Properties.Resources.mail;
                img = QueueManager.ChangeColor(new Bitmap(img), Color.Black, c.ObjectColor);
                imgList.Images.Add(img);
                c.ImageIndexes.MailedBundle = index;
                index += 1;

                img = Properties.Resources.checkedmail;
                img = QueueManager.ChangeColor(new Bitmap(img), Color.Black, c.ObjectColor);
                imgList.Images.Add(img);
                c.ImageIndexes.AlreadyMailed = index;
                index += 1;
            }

            tvPrintQueues.ImageList = imgList;
        }

        private TreeNodeEx FindNodeByKey(string keyValue)
        {
            return (TreeNodeEx)tvPrintQueues.Nodes.Find(keyValue, false).First();
        }

        private void ShowAboutInfo()
        {
            rtbxProperties.Clear();
            rtbxProperties.SelectionAlignment = HorizontalAlignment.Center;
            rtbxProperties.SelectionFont = new Font("Lucinda Console", 12);
            rtbxProperties.SelectedText = string.Format("{0}\n\n", "National Research Corporation");
        }

        private void PrepareMailingQueue()
        {
            mIsReprint = true;
            mnuBundle.Visible = false;
            mnuReprint.Text = "View Print &Queue";
            lblTitle.Text = "Mailing Queue:";
            lblBundlingDate.Visible = false;
            this.Text = "Mailing Queue Manager";
            mnuMailingDates.Visible = true;
            mnuPopupMarkMailing.Visible = true;
            mnuBundlingReport.Visible = true;
            this.AppMode = ApplicationMode.MailingQueueManager;
        }

        private void PreparePrintQueue()
        {
            mnuBundle.Enabled = true;
            lblBundlingDate.Visible = true;
            mnuReprint.Text = "View &Mailing Queue";
            lblTitle.Text = " Print Queue:";
            this.Text = "Print Queue Manager";
            this.AppMode = ApplicationMode.PrintQueueManager;
        }

        private void Print()
        {

            Cursor.Current = Cursors.WaitCursor;

            string strStatus = string.Empty;
            string strMsg = string.Empty;
            DateTime mLastBundlingDate = DateTime.MaxValue;

            if (tvPrintQueues.SelectedNode != null)
            {
                TreeNodeEx node = (TreeNodeEx)tvPrintQueues.SelectedNode;

                if (AppMode == ApplicationMode.MailingQueueManager)
                {
                    mnuPopUpPrint.Text = "&Reprint";
                    mnuAddToGroupedPrint.Visible = false;
                    mnuPrintSample.Visible = false;
                    mnuBundleFlats.Visible = false;
                    mnuMailingDates.Visible = true;
                    mnuPopupMarkMailing.Visible = true;
                    mnuBundlingReport.Visible = true;
                    frmReprintDates.ShowDialog();
                }
                else
                {
                    // printing queue manager
                    if (moQueueManager.PrintingInstance_Add(ref mLastBundlingDate) == false)
                    {
                        strMsg = "Cannot Print.  Another user is currently bundling.";
                        Console.Beep(); // only audible through speakers
                        MessageBox.Show(strMsg, "Queue Manager", MessageBoxButtons.OK, MessageBoxIcon.Information);
                    }
                    else if (mLastBundlingDate != LastBundlingDate)
                    {
                        moQueueManager.PrintInstance_Remove();
                        strMsg = "Cannot Print.  Bundling has been run since you last refreshed the Print Queue.  The view will be refreshed and you can try to print again.";
                        Console.Beep(); // only audible through speakers
                        MessageBox.Show(strMsg, "Queue Manager", MessageBoxButtons.OK, MessageBoxIcon.Information);
                    }
                    else
                    {
                        mnuPopUpPrint.Text = "&Print";
                        mnuAddToGroupedPrint.Visible = true;
                        mnuPrintSample.Visible = true;
                        mnuBundleFlats.Visible = true;
                        mnuMailingDates.Visible = false;
                        mnuPopupMarkMailing.Visible = false;
                        mnuBundlingReport.Visible = false;

                        if (node.NodeType != NodeTypes.Deleted)
                        {
                            if (!node.Name.Contains("(unbundled)"))
                            {
                                PrintBundles(node);
                                moQueueManager.PrintInstance_Remove();
                                // remove the selectedNode and subnodes
                                tvPrintQueues.Nodes.Remove(node);
                            }
                            else
                            {
                                MessageBox.Show("Cannot print unbundled surveys.", "Queue Manager", MessageBoxButtons.OK, MessageBoxIcon.Information);
                            }
                        }
                    }
                }
            }

            Cursor.Current = Cursors.Default;
        }

        private void PrintBundles(TreeNodeEx node)
        {
            node.ExpandAll();

            if (node.NodeType == NodeTypes.GroupedPrintConfiguration)
            {
                GroupedPrintNode(node);
            }
            else if (node.NodeType == NodeTypes.Bundle)
            {
                PrintNode(node);
            }
            else if (node.NodeType != NodeTypes.Hospital && node.NodeType != NodeTypes.CheckedHospital)
            {


            }
            else
            {

            }

        }

        private void GroupedPrintNode(TreeNodeEx node)
        {
            int paperConfigID;
            string[] keys = node.Name.Split('|');
            DateTime PrintDate = DateTime.Now;
            if (keys[0].ToUpper() == "GROUPEDPRINTCONFIG")
            {
                paperConfigID = Convert.ToInt16(keys[1]);
                node.ImageIndex = GetImageIndexBySurveyTypeID(node.SurveyType_ID).Printing;
                moQueueManager.GroupedPrintRebundleAndSetLithos(paperConfigID, PrintDate);

                if (!moQueueManager.GetGroupedPrint(paperConfigID, false, PrintDate))
                {
                    MessageBox.Show("No surveys were printed!", "Print Warning", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                }

                node.ImageIndex = GetImageIndexBySurveyTypeID(node.SurveyType_ID).Bundle;
            }
            else
            {
                MessageBox.Show("That doesn't appear to be a Grouped Print configuration", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }

        }

        private void PrintNode(TreeNodeEx node)
        {
            int paperConfigId;
            int pageNum;
            int Survey_id;
            string strBundled;
            string postalBundle;
            string strID;

            mIsReprint = (AppMode == ApplicationMode.MailingQueueManager);

            node.ImageIndex = GetImageIndexBySurveyTypeID(node.SurveyType_ID).Printing;

            string[] keys = node.Name.Split('|');

            Survey_id = Convert.ToInt32(keys[0]);
            postalBundle = keys[1];
            paperConfigId = Convert.ToInt32(keys[2]);
            pageNum = Convert.ToInt32(keys[4]);
            strBundled = keys[8];


        }

        #endregion




    }
}
