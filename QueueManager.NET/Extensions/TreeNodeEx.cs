using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using QueueManagerUI;
using QueueManagerUI.Enums;

namespace QueueManagerUI.Extensions
{
    public class TreeNodeEx: TreeNode
    {

        public NodeTypes NodeType { get; set; }
        public string Description { get; set; }
        public int SurveyType_ID { get; set; }

        public Dictionary<string, string> Properties { get; set; }

        public TreeNodeEx(): base()
        {
            Properties = new Dictionary<string, string>();
        }


    }
}
