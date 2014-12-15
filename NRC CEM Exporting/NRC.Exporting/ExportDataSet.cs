using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;
using NRC.Exporting.DataProviders;

namespace NRC.Exporting
{
    public class ExportDataSet
    {

        public ExportSection Section { get; set; }
        public DataTable DataTable { get; set; }

        public ExportDataSet()
        {

        }


        public static List<ExportDataSet> Select(List<ExportSection> sections, int? exportQueueID)
        {
            List<ExportDataSet> list = new List<ExportDataSet>();

            foreach (ExportSection section in sections)
            {
                bool oneRecordPerPatient = section.ExportTemplateSectionName != "header";
                ExportDataSet ds = ExportDataSetProvider.Select(exportQueueID, section.ExportTemplateID, section.ExportTemplateSectionName, oneRecordPerPatient);
                ds.Section = section;
                list.Add(ds);
            }

            return list;
        }


    }


    public class ExportDataSetList : List<ExportDataSet>
    {



    }
}
