using System;
using System.Collections.Generic;
using System.Data;
using System.Data.OleDb;
using System.IO;
using System.Linq;

namespace NRCFileConverterLibrary.Common
{
    public partial class FileConverter : IDisposable
    {
        public string Full { get; set; }
        public string FileName { get; set; }
        public string DirName { get; set; }
        public FileConverter(string fullPath)
        {
            Full = Path.GetFullPath(fullPath);
            FileName = Path.GetFileName(Full);
            DirName = Path.GetDirectoryName(Full);
        }
        /// <summary>
        ///  Convert the CSV data into a datatable. Use a filename without spaces.
        /// </summary>
        /// <param name="path"></param>
        /// <returns></returns>
        /// 
        public DataTable FromCsvToDataTable(string path)
        {
            string connString = "";
            if (!File.Exists(path))
                return null;
            //create the "database" connection string. HDR is for the headers.  

            connString = "Provider=Microsoft.Jet.OLEDB.4.0;"
             + "Data Source=\"" + DirName + "\\\";"
             + "Extended Properties=\"text;HDR=Yes;FMT=Delimited(,)\"";

            string query = "SELECT * FROM [" + FileName+"]";
            //create a DataTable to hold the query results
            DataTable dTable = new DataTable();
            //create an OleDbDataAdapter to execute the query
            OleDbDataAdapter dAdapter = new OleDbDataAdapter(query, connString);
            try
            {
                //fill the DataTable
                dAdapter.Fill(dTable);
            }
            catch (InvalidOperationException ex)
            {
                Logs.LogFatalException(ex);
                throw;

            }
            catch (Exception ex)
            {
                Logs.LogFatalException(ex);
                throw;
            }
            dAdapter.Dispose();
            return dTable;
        }

        /// <summary>
        ///  Get a csv file and convert to access
        /// </summary>
        /// <param name="path">Full path (including file)</param>
        public static string FromCsvToAccess(string path, string PrimaryKey)
        {
            FileInfo fi = new FileInfo(path);
            FileConverter fileConv = new FileConverter(path);
            string fullPath = fi.FullName;
            string name = fi.Name;
            try
            {

               return  CreateDB.CreateAccessDB(fullPath, PrimaryKey, fileConv.FromCsvToDataTable(fullPath));

            }
            catch (Exception ex)
            {
                Logs.LogFatalException(ex);
                throw;
            }
        }

        public static void FromTabDelimitedToCsv(FileInfo fi)
        {
            using (StreamReader rdr = new StreamReader(fi.FullName))
            {
                //StringBuilder file = new StringBuilder();
                string line;
                using (StreamWriter wr = new StreamWriter(fi.DirectoryName + "\\" + fi.Name.Replace(fi.Extension, ".csv")))
                {
                    while ((line = rdr.ReadLine()) != null)
                    {
                        //what to do if it is a value with commas before transformation??
                        // Well, I am going to replace the comman for something else
                        line = line.Replace(",", "-@-");
                        wr.WriteLine(line.Replace('\t', ',')); //
                    }
                }

            }

        }
        //Got this code from Stackoverflow
        //http://stackoverflow.com/questions/2536181/is-there-any-simple-way-to-convert-xls-file-to-csv-file-excel

        public static void ConvertExcelToCsv(string excelFilePath, string csvOutputFile, int worksheetNumber = 1)
        {
            if (!File.Exists(excelFilePath)) throw new FileNotFoundException(excelFilePath);
            if (File.Exists(csvOutputFile)) throw new ArgumentException("File exists: " + csvOutputFile);
            // connection string
            var cnnStr = String.Format(@"Provider=Microsoft.ACE.OLEDB.12.0;Data Source={0};Extended Properties=""Excel 12.0 Xml;HDR=YES;IMEX=1""", excelFilePath);//String.Format("Provider=Microsoft.ACE.OLEDB.12.0;Data Source={0};Extended Properties=\"Excel 12.0;HDR=YES\"", excelFilePath);
            var cnn = new OleDbConnection(cnnStr);
            // get schema, then data
            var dt = new DataTable();
            try
            {
                cnn.Open();
                var schemaTable = cnn.GetOleDbSchemaTable(OleDbSchemaGuid.Tables, null);
                if (schemaTable.Rows.Count < worksheetNumber) throw new ArgumentException("The worksheet number provided cannot be found in the spreadsheet");
                string worksheet = schemaTable.Rows[worksheetNumber - 1]["table_name"].ToString().Replace("'", "");
                string sql = String.Format("select * from [{0}]", worksheet);
                var da = new OleDbDataAdapter(sql, cnn);
                da.Fill(dt);
            }
            catch (Exception ex)
            {

                Logs.LogFatalException(ex);
                throw;
            }
            finally
            {
                // free resources
                cnn.Close();
            }

            // write out CSV data
            if (dt == null)
            {
                DataTableToCsv(csvOutputFile, dt);
            }


        }

        private static void DataTableToCsv(string csvOutputFile, DataTable dt)
        {
            using (var wtr = new StreamWriter(csvOutputFile))
            {
                bool firstLine = true;
                bool isHeaderPrint = false;
                foreach (DataRow row in dt.Rows)
                {
                    firstLine = true;
                    var data = "";
                    foreach (DataColumn col in dt.Columns)
                    {
                        if (!firstLine)
                        {
                            wtr.Write(",");
                        }
                        else
                        {
                            firstLine = false;
                        }
                        if (!isHeaderPrint)
                        {
                            data = col.ColumnName.ToString().Replace("\"", "\"\"");
                        }
                        else
                        {
                            data = row[col.ColumnName].ToString().Replace("\"", "\"\"");
                        }
                        wtr.Write(String.Format("\"{0}\"", data));
                    }
                    wtr.WriteLine();
                    isHeaderPrint = true;
                }
            }
        }


        public static string[] GetFiles(string path, string searchPattern, SearchOption searchOption)
        {
            string[] searchPatterns = searchPattern.Split('|');
            List<string> files = new List<string>();
            foreach (string sp in searchPatterns)
                files.AddRange(System.IO.Directory.GetFiles(path, sp, searchOption));
            files.Sort();
            return files.ToArray();
        }


        public void Dispose()
        {
            throw new NotImplementedException();
        }
    }

}

