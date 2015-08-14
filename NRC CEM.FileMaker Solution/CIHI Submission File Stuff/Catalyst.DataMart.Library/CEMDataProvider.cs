using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Nrc.Framework.Data;
using Nrc.Framework.BusinessLogic.Configuration;



namespace Catalyst.DataMart.Library
{
    public abstract class CEMDataProvider
    {

        private static CEMDataProvider mInstance;
        private const string PROVIDERNAME = "SqlDataProvider";

        public static CEMDataProvider Instance
        {
            get{

                if (mInstance == null){
                    mInstance = CEMDataProviderFactory.CreateInstance<CEMDataProvider>(PROVIDERNAME);
                }
                return mInstance;
            }
        }


        public abstract ExportTemplate SelectTemplateByTemplateId(int templateId);


    }
}
