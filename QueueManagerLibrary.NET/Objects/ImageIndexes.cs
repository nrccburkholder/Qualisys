using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace QueueManagerLibrary.Objects
{
    public class ImageIndexes
    {

        public int Hospital { get; set; }
        public int Configuration { get; set; }
        public int Bundle { get; set; }
        public int FadedConfiguration { get; set; }
        public int GroupedPrint { get; set; }
        public int GroupedPrintHospital { get; set; }
        public int GroupedPrintConfiguration { get; set; }
        public int CheckedHospital { get; set; }
        public int CheckedBundle { get; set; }
        public int CheckedConfiguration { get; set; }
        public int CheckedGroupedPrintHospital { get; set; }
        public int MailedBundle { get; set; }
        public int AlreadyMailed { get; set; }
        public int Deleted { get; set; }
        public int Printing { get; set; }


        public ImageIndexes()
        {

        }

    }
}
