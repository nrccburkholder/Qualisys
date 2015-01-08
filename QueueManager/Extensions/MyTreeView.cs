﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace QueueManagerUI.Extensions
{
    public class MyTreeView : TreeView
    {
        protected override CreateParams CreateParams
        {
            get
            {
                CreateParams parms = base.CreateParams;
                parms.Style |= 0x80;  // Turn on TVS_NOTOOLTIPS 
                return parms;
            }
        }
    } 

}
