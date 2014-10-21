using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using System.ComponentModel.DataAnnotations;

namespace Nrc.CatalystExporter.DataContracts
{
    [DataContract]
    public class ChangeLog
    {
        [DataMember]
        [Key]
        public long Id { get; set; }

        [DataMember]
        public long ScheduledExportId { get; set; }

        [DataMember]
        public string ModifiedBy { get; set; }

        [DataMember]
        [Column(TypeName = "datetime2")]
        public DateTime ModifiedDate { get; set; }

        [DataMember]
        public string Description { get; set; }
    }
}
