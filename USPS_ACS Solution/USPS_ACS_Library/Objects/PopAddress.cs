using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace USPS_ACS_Library.Objects
{
    public class PopAddress
    {
        #region private members

        private int mStudy_id = 0;
        private int mPop_id = 0;
        private string mPop_Fname = string.Empty;
        private string mPop_Lname = string.Empty;
        private string mPop_Addr = string.Empty;
        private string mPop_Addr2 = string.Empty;
        private string mPop_City = string.Empty;
        private string mPop_State = string.Empty;
        private string mPop_Zip5 = string.Empty;

        #endregion


        #region constructors

        public PopAddress()
        {

        }

        #endregion
    }
}
