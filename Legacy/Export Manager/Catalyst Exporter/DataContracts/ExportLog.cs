using System;
using System.ComponentModel.DataAnnotations;
using System.Runtime.Serialization;
using System.Collections.Generic;

namespace Nrc.CatalystExporter.DataContracts
{
    [DataContract]
    public class ExportLog
    {
        [DataMember]
        [Key]
        public long Id { get; set; }

        [DataMember]
        public string CreatedBy { get; set; }

        [DataMember]
        [Column(TypeName = "datetime2")]
        public DateTime CreationDate { get; set; }

        [DataMember]
        public string Name { get; set; }

        [DataMember]
        [Column(TypeName = "datetime2")]
        public DateTime StartDate { get; set; }

        [DataMember]
        [Column(TypeName = "datetime2")]
        public DateTime EndDate { get; set; }

        [DataMember]
        public string Location { get; set; }

        [DataMember]
        [Column(TypeName = "datetime2")]
        public DateTime? FileCreationCompleteTime { get; set; }

        public List<FileDefinition> FileDefinitions { get; set; }
    }
}
