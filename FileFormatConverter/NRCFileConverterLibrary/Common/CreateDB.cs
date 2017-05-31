using System;
using System.Data;
using System.Data.OleDb;
using System.Linq;
using System.Text;
using System.IO;
using System.Configuration;

namespace NRCFileConverterLibrary.Common
{
    public class CreateDB
    {
        /// <summary>
        ///  CreateAccessDB
        ///  This method uses Interop.Access.Dao to create the database. Version: 12.0.0. The version is something important
        ///  to keeps in mind when this is service is installed
        /// </summary>
        /// <param name="path">The path where the CSV file is located</param>
        /// <param name="fileName">The csv file used to create the Access database</param>
        /// <param name="data">The data from the csv file</param>
        public static string CreateAccessDB(string path,string PrimaryKey, DataTable data)
        {
            try
            {
                //Create Access file in this case accdb
                
                StringBuilder columnsAndTypes;
                StringBuilder columns;            
                CreateAccessFile(ref path);
                //Create table
                columnsAndTypes = new StringBuilder();
                columns = new StringBuilder();
                foreach (DataColumn col in data.Columns)
                {
                    columnsAndTypes.Append(String.Concat(col.ColumnName.ToString(), " ", 
                        ConvertToAccessDataType(col.DataType.ToString()),
                        (PrimaryKey.ToLower().Contains(col.ColumnName.ToLower().ToString())) ? " NOT NULL PRIMARY KEY" : "", ","));
                    columns.Append(String.Concat(col.ColumnName.ToString(), ","));
                   
                }
                columnsAndTypes.Remove(columnsAndTypes.Length - 1, 1);
                columns.Remove(columns.Length - 1, 1);
                using (OleDbConnection conn = new OleDbConnection(
                   String.Format("Provider=Microsoft.ACE.OLEDB.12.0;Data Source={0};Persist Security Info=False;", path)))
                {
                    using (OleDbCommand cmd = new OleDbCommand())
                    {
                        var file = new FileInfo(path);
                        cmd.CommandText = String.Concat("CREATE TABLE [", file.Name.Replace(".accdb", ""), "] (", columnsAndTypes.ToString(), ")");
                        cmd.Connection = conn;
                        try
                        {
                            conn.Open();
                            //Create Table
                            cmd.ExecuteNonQuery();
                            //Insert Data to the table
                            InsertDataIntoTable(file.Name.Replace(".accdb", ""), data, columns, cmd); 
                        }
                        catch (Exception ex)
                        {
                            Logs.LogFatalException(ex);
                            throw;
                        }
                        finally
                        {
                            if (conn.State == ConnectionState.Open)
                            {
                                conn.Close();
                            }
                        }
                    }
                }
                return path;
            }
            catch (Exception ex)
            {
                Logs.LogFatalException(ex);
                throw;
            }
        }
        /// <summary>
        /// CreaeAccessFile 
        /// Create the Access file with the same file name
        /// </summary>
        /// <param name="path"></param>
        /// <param name="fileName"></param>
        private static void CreateAccessFile(ref string path)
        {
            FileInfo fi = new FileInfo(path);
            string extension = fi.Extension.ToLower();
            if (0== string.Compare(extension,".csv",true) )
            {
                path = path.ToLower().Replace("csv", "accdb");
            }
            else if (0 == string.Compare(extension, ".txt", true))
            {
                path = path.ToLower().Replace("txt", "accdb");               
            }
            else
            {
                throw new NRCFileConversionException(string.Format("the file {0}'s the extension is not supported", fi.Name));
            }

            //2013-0830 [camelinckx] I have replaced the logic that used the Office PIA by an embedded binary resource
            //                       which has en empty Access database that gets copied from the assembly down to disk.
            string resourceName = "NRCFileConverterLibrary.Processor.Resource.Template.accdb";
            //using (Stream resourceStr = System.Reflection.Assembly.GetExecutingAssembly().GetManifestResourceStream(resourceName))
            using (Stream resourceStr = System.Reflection.Assembly.GetExecutingAssembly().GetManifestResourceStream(resourceName))
            {
                using (Stream fileOutStr = File.Create(path))
                {
                    resourceStr.CopyTo(fileOutStr);
                }
            } 
        }
        /// <summary>
        ///  InsertDataIntoTable
        ///  Create data into the table.
        /// </summary>
        /// <param name="fileName"></param>
        /// <param name="data"></param>
        /// <param name="columns"></param>
        /// <param name="cmd"></param>
        private static void InsertDataIntoTable(string table, DataTable data, StringBuilder columns, OleDbCommand cmd)
        {
            foreach (DataRow row in data.Rows)
            {
                StringBuilder values = new StringBuilder();
                foreach (DataColumn col in data.Columns)
                {
                    values.Append(String.Concat(GetRightString(row[col],col.DataType.ToString()), ","));
                }
                values.Remove(values.Length - 1, 1);
                cmd.CommandText = String.Concat("Insert into [",table, "] (", columns.ToString(), ") ", "Values", "(", values.ToString(), ")");
                try
                {
                    cmd.ExecuteNonQuery();
                }
                catch (Exception ex)
                {
                    throw new ApplicationException("ERROR Executing: " + cmd.CommandText, ex);
                }
            }
        }

        private static string GetRightString(Object p, string datatype)
        {
            string returnString = String.Concat("'", p.ToString().Replace("'","''"), "'");

            switch (datatype)
            {
                case "System.String":
                    break;
                case "System.DateTime":
                    //  case "System.Boolean":
                    if (p.GetType().ToString().Contains("Null"))
                    {
                        returnString = "''";
                    }
                    else
                    {
                        returnString = String.Concat("'", p.ToString(), "'");
                    }
                    break;
                default:
                    if (p.GetType().ToString().Contains("Null"))
                    {
                        returnString = "0";
                    }
                    else
                    {
                        returnString = p.ToString();
                    }
                    
                    break;
            }
            //Just removing this funny character
            return returnString.Replace("-@-",",");
        }
        private static string ConvertToAccessDataType(string p)
        {
            string type = "VARCHAR";
            switch (p)
            {
                case "System.Int32":
                    type = "LONG";
                    break;
                case "System.Boolean":
                    type = "BIT";
                    break;
                case "System.DateTime":
                    type = "DATETIME";
                    break;
                case "System.Double":
                    type = "DOUBLE";
                    break;
            }
            return type;
        }
    }
    internal abstract class LangConstants
    {
        public const string dbLangGeneral = ";LANGID=0x0409;CP=1252;COUNTRY=0";
    }
}
