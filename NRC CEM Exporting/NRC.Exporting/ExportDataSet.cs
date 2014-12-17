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

        public int? ExportQueueID { get; set; }
        public string FileMakerName { get; set; }
        public ExportSection Section { get; set; }
        public DataTable DataTable { get; set; }

        public ExportDataSet()
        {

        }

        public static List<ExportDataSet> Select(ExportDataSet dataset, List<ExportSection> sections)
        {
            List<ExportDataSet> list = new List<ExportDataSet>();

            foreach (ExportSection section in sections)
            {
                bool oneRecordPerPatient = section.OneRecordPerPatient;
                ExportDataSet ds = ExportDataSetProvider.Select(dataset.ExportQueueID, section.ExportTemplateID, section.ExportTemplateSectionName, dataset.FileMakerName, oneRecordPerPatient);
                ds.Section = section;
                list.Add(ds);
            }

            return list;
        }
    }

}
