using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.SqlClient;

namespace SurveyPointDAL
{
    /// <summary>
    /// Summary description for clsIUpdateData.
    /// </summary>
    public abstract class clsUpdateData
    {
        protected abstract SqlCommand DeleteCommand(SqlConnection conn);
        protected abstract SqlCommand UpdateCommand(SqlConnection conn);
        protected abstract SqlCommand InsertCommand(SqlConnection conn);

        public SqlDataAdapter GetDataAdapter(SqlConnection conn)
        {
            SqlDataAdapter da = new SqlDataAdapter();

            da.UpdateCommand = UpdateCommand(conn);
            da.DeleteCommand = DeleteCommand(conn);
            da.InsertCommand = InsertCommand(conn);

            return da;
        }
    }
}
