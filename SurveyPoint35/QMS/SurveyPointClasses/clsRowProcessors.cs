using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using SurveyPointDAL;

namespace SurveyPointClasses
{
    /// <summary>
    /// Summary description for clsRowProcessors.
    /// </summary>
    public class clsRowProcessors
    {
        public clsRowProcessors()
        {
            //
            // TODO: Add constructor logic here
            //
        }
    }

    public class rpExecuteTriggers
    {
        public int TriggerID = -1;
        public int UserID = -1;
        private clsTriggers _trigger = null;

        public rpExecuteTriggers(int iTriggerID, int iUserID)
        {
            TriggerID = iTriggerID;
            UserID = iUserID;
        }

        public clsTriggers TriggerHelper
        {
            get
            {
                if (_trigger == null)
                {
                    _trigger = new clsTriggers(0, UserID);


                }
                return _trigger;
            }
        }
    }
}
