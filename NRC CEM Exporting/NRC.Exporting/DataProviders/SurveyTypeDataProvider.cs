using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;
using System.Data.SqlClient;
using System.Data.Common;
using System.ComponentModel;

namespace CEM.Exporting.DataProviders
{
    internal static class SurveyTypeDataProvider
    {

        private static SqlDataProvider SqlProvider
        {
            get
            {
                return new SqlDataProvider(DB.QPPROD);
            }
        }

        #region private methods


        private static BindingList<SurveyType> PopulateSurveyTypeList(DataSet ds)
        {
            BindingList<SurveyType> surveyTypes = new BindingList<SurveyType>();

            if (ds.Tables.Count > 0)
            {
                SurveyType surveyType = new SurveyType();

                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    surveyTypes.Add(PopulateSurveyType(dr));
                }
            }

            return surveyTypes;
        }

        private static SurveyType PopulateSurveyType(DataRow dr)
        {
            SurveyType st = new SurveyType();

            st.SurveyTypeID = (int)dr["surveytype_id"];
            st.SurveyTypeName = dr["surveyType_dsc"].ToString();

            return st;
        }

        #endregion


        #region public methods

        public static BindingList<SurveyType> Select()
        {

            DataSet ds = new DataSet();
            SqlProvider.Fill(ref ds, "QCL_SelectAllSurveyTypes", CommandType.StoredProcedure);

            using (ds)
            {
                return PopulateSurveyTypeList(ds);
            }
        }

        #endregion

    }
}
