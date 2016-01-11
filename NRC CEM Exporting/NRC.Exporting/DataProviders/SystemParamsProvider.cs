using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;
using System.Data.SqlClient;
using System.Data.Common;
using CEM.Exporting.Configuration;

namespace CEM.Exporting.DataProviders
{
    public class SystemParamsProvider
    {

        private static SqlDataProvider SqlProvider
        {
            get
            {
                return new SqlDataProvider(DB.CEM);
            }
        }


        private static Param PopulateParam(SqlDataReader rdr)
        {
            Param param = new Param();
            param.ParamID = (int)rdr["Param_ID"];
            param.Name = rdr["strParam_nm"].ToString();

            switch (rdr["strParam_Type"].ToString().ToUpper())
            {
                case "N":
                    param.Type = ParamTypes.Numeric;
                    break;
                case "S":
                    param.Type = ParamTypes.String;
                    break;
                case "D":
                    param.Type = ParamTypes.Date;
                    break;
                default:
                    throw new ArgumentOutOfRangeException("strParam_Type", string.Format("The value '{0}' is not valid for the strParam_Type column", rdr["strParam_Type"].ToString()));
            }

            param.Group = rdr["strParam_Grp"].ToString();
            param.StringValue = rdr["strParam_Value"].ToString();
            param.IntegerValue = rdr["numParam_Value"] == DBNull.Value ? null : (int?)rdr["numParam_Value"];
            param.DateValue = rdr["datParam_Value"] == DBNull.Value ? null : (DateTime?)rdr["datParam_Value"]; // GetDate(rdr, "datParam_Value");
            param.Comments = rdr["Comments"].ToString();

            return param;
        }

        public static List<Param> SelectAll()
        {
                 
            SqlDataReader rdr = SqlProvider.ExecuteReader( "CEM.SelectSystemParams", CommandType.StoredProcedure);
            using (rdr)
            {
                //ParamCollection paramList = new ParamCollection();
                List<Param> paramList = new List<Param>();
                while (rdr.Read())
                {
                    paramList.Add(PopulateParam(rdr));
                }
                return paramList;
            }

        }


        #region date methods

        private static DateTime GetDate(SqlDataReader rdr, string name)
        {
            return GetDate(rdr, rdr.GetOrdinal(name));
        }

        private static DateTime GetDate(SqlDataReader rdr, int i)
        {
            if (rdr.IsDBNull(i))
            {
                return DateTime.MinValue;
            }
            else
            {
                return rdr.GetDateTime(i);
            }
        }
        #endregion
    }
}
