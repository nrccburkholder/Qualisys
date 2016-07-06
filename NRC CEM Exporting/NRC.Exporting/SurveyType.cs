using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel;

namespace CEM.Exporting
{
    public class SurveyType
    {

        public int SurveyTypeID { get; set; }

        public string SurveyTypeName { get; set; }


        public SurveyType()
        {

        }

        public static BindingList<SurveyType> Select()
        {
            return DataProviders.SurveyTypeDataProvider.Select();
        }


        public static SurveyType Select(int surveyTypeId)
        {
            return DataProviders.SurveyTypeDataProvider.Select(surveyTypeId);
        }
    }
}
