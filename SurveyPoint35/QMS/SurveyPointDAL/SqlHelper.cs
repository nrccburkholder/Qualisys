using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.Common;
using Microsoft.Practices.EnterpriseLibrary.Data;

namespace SurveyPointDAL
{
    class SqlHelper
    {
        public static Database Db(string conn)
        {
            return new Microsoft.Practices.EnterpriseLibrary.Data.Sql.SqlDatabase(conn);
        }
    }
}
