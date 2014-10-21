using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Runtime.Serialization;

namespace Nrc.CatalystExporter.DataContracts
{
    [DataContract]
    public class ColumnDefinition
    {
        [DataMember]
        [Key]
        public long Id { get; set; }

        [DataMember]
        public long FileDefinitionId { get; set; }

        [DataMember]
        [Required]
        public string FieldName { get; set; }

        [DataMember]
        public int ColumnOrder { get; set; }

        [DataMember]
        public string DisplayName { get; set; }

        public List<ColumnTextReplacement> Replacements { get; set; }

        public bool IsQuestionData()
        {
            return ExportResult.QuestionDataPropertyNames().Contains(this.FieldName);
        }

        public bool IsCommentData()
        {
            return ExportResult.CommentDataPropertyNames().Contains(this.FieldName);
        }
    }
}
