using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace QueueManagerUI.Enums
{

 [Flags]
    public enum NodeTypes
    {
        None = 0,
        Hospital = 1,
        CheckedHospital = 2,
        Configuration = 4,
        CheckedConfiguration = 8,
        FadedConfiguration = 16,
        Bundle = 32,
        AlreadyMailed = 64,
        MailBundle = 128,
        Printing = 256,
        Deleted = 512,
        GroupedPrint = 1024,
        GroupedPrintHospital = 2048,
        CheckedGroupedPrintHospital = 4096,
        GroupedPrintConfiguration = 8192
    }
}
