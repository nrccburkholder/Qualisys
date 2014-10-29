using System.ComponentModel.DataAnnotations;
using System.Runtime.Serialization;

namespace Nrc.CatalystExporter.DataContracts
{
    [DataContract]
    public class ColumnTextReplacement
    {
        [DataMember]
        [Key]
        public long Id { get; set; }

        [DataMember]
        public long ColumnDefinitionId { get; set; }

        [DataMember]
        public string OldText { get; set; }

        [DataMember]
        public string NewText { get; set; }

    }
}
