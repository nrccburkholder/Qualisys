using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Data.SqlClient;
using System.IO;

namespace CommonTools
{
    /// <summary>
    /// Summary description for FileExport.
    /// </summary>
    public class FileExport
    {
        private String _delimiter = ",";
        private string _connstr = null;
        private int _exportCount = 0;
        private object _lockExportCount = new object();

        public FileExport(string connstr)
        {
            _connstr = connstr;
        }

        public string Delimiter
        {
            set { _delimiter = value; }
            get { return _delimiter; }
        }

        public int ExportCount
        {
            get
            {
                int i;
                lock (_lockExportCount)
                {
                    i = _exportCount;
                }
                return i;
            }
        }

        private void IncrementExportCount()
        {
            lock (_lockExportCount)
            {
                _exportCount++;
            }
        }

        public void ExecuteExport(TextWriter sw, SqlDataReader dr)
        {
            bool bHeader = true;
            _exportCount = 0;
            while (dr.Read())
            {
                if (bHeader)
                {
                    ExportHeader(sw, dr);
                    bHeader = false;
                }
                ExportRow(sw, dr);

                IncrementExportCount();
            }
        }

        private void ExportRow(TextWriter sw, SqlDataReader dr)
        {
            for (int i = 0; i < dr.FieldCount; i++)
            {
                if (i == dr.FieldCount - 1)
                {
                    sw.WriteLine(dr.GetValue(i));
                }
                else
                {
                    sw.Write("{0}{1}", dr.GetValue(i), _delimiter);
                }
            }

        }

        private void ExportHeader(TextWriter sw, SqlDataReader dr)
        {
            for (int i = 0; i < dr.FieldCount; i++)
            {
                if (i == dr.FieldCount - 1)
                {
                    sw.WriteLine(dr.GetName(i));
                }
                else
                {
                    sw.Write("{0}{1}", dr.GetName(i), _delimiter);
                }
            }
        }
    }
}

