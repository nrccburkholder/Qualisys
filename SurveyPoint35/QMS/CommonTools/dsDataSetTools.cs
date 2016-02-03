using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Data.SqlClient;

namespace Tools
{
    /// <summary>
    /// Summary description for dsDataSetTools.
    /// </summary>
    public class dsDataSetTools
    {
        public dsDataSetTools()
        {
            //
            // TODO: Add constructor logic here
            //
        }

        public static void AddNewNullRow(DataTable dt)
        {
            DataRow row = dt.NewRow();
            foreach (DataColumn col in dt.Columns)
            {
                if (col.AutoIncrement || row[col.Ordinal] == DBNull.Value)
                    row[col.Ordinal] = DbNullConverter.DbNullHelper.GetDBValueByTypeName(col.DataType.Name);
            }
            dt.Rows.Add(row);
        }
    }
}
