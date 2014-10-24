using System;
using System.ComponentModel.DataAnnotations;
using System.Runtime.Serialization;
using System.Collections.Generic;

namespace Nrc.CatalystExporter.DataContracts
{
    [DataContract]
    public class ScheduledExport
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
        [Column(TypeName = "datetime2")]
        public DateTime NextRunDate { get; set; }

        [DataMember]
        [EnumDataType(typeof(IntervalType))]
        public int RunInterval { get; set; }

        [DataMember]
        public int RunIntervalCount { get; set; }

        [DataMember]
        [EnumDataType(typeof(IntervalType))]
        public int DataInterval { get; set; }

        [DataMember]
        public int DataIntervalCount { get; set; }

        [DataMember]
        public bool IsActive { get; set; }

        [DataMember]
        [Column(TypeName = "datetime2")]
        public DateTime DataStartDate { get; set; }

        [DataMember]
        public bool IsRolling { get; set; }

        public List<FileDefinition> FileDefinitions { get; set; }
    }

    public enum IntervalType
    {
        Weeks = 0,
        Months = 1,
        Years = 2
    }
}
