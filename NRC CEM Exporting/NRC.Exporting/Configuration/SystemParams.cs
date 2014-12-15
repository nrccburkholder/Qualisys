using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using NRC.Exporting.DataProviders;

namespace NRC.Exporting.Configuration
{
    public static class SystemParams
    {

        private static ParamCollection mParams = null;
  

        public static ParamCollection Params
        {
            get
            {
                if (mParams == null)
                {
                    mParams = new ParamCollection();

                    foreach(Param param in SystemParamsProvider.SelectAll())
                    {
                        mParams.Add(param);
                    }
                }
                return mParams;
            }
        }
    }

    public class Param
    {
        #region public members

        private int mParamID;
        private string mName = string.Empty;
        private ParamTypes mType;
        private string mGroup = string.Empty;
        private string mStringValue = string.Empty;
        private int? mIntegerValue;
        private DateTime? mDateValue;
        private string mComments = string.Empty;



        public int ParamID { get { return mParamID; }set { mParamID = value; }  }
        public string Name { get {return mName;} set { mName = value; }}
        public ParamTypes Type { get { return mType; } set { mType = value; } }
        public string Group { get { return mGroup; } set { mGroup = value; } }
        public string StringValue { get { return mStringValue; } set { mStringValue = value; } }
        public int? IntegerValue { get { return mIntegerValue; } set { mIntegerValue = value; } }
        public DateTime? DateValue { get { return mDateValue; } set { mDateValue = value; } }
        public string Comments { get { return mComments; } set { mComments = value; } }

        #endregion

        #region constructors

        public Param()
        {

        }

        #endregion


        #region public methods


        #endregion

    }

    public class ParamCollection : List<Param>
    {
        public  Param GetParam(string name)
        {
            return this.Where(x => x.Name == name).First();
        }

    }

    public enum ParamTypes
    {
        Numeric = 0,
        String = 1,
        Date = 2
    }


}
