using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Runtime.Serialization;
using System.Linq;

namespace Nrc.CatalystExporter.DataContracts
{
    [DataContract]
    public class FileDefinition
    {
        [DataMember]
        [Key]
        public long Id { get; set; }

        [DataMember]
        public int ClientId { get; set; }

        [DataMember]
        public int StudyId { get; set; }

        [DataMember]
        public int SurveyId { get; set; }

        [DataMember]
        public string Name { get; set; }

        [DataMember]
        [EnumDataType(typeof(FileType))]
        public int FileType { get; set; }

        [DataMember]
        [StringLength(2)]
        public string Delimiter { get; set; }

        [DataMember]
        [EnumDataType(typeof(ExportDateType))]
        public int ExportDateType { get; set; }

        [DataMember]
        [EnumDataType(typeof(FileStructureType))]
        public int FileStructureType { get; set; }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly"), System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Design", "CA1002:DoNotExposeGenericLists"), DataMember]
        public List<ColumnDefinition> Columns { get; set; }

        public List<ExportLog> ExportLogs { get; set; }

        public List<ScheduledExport> ScheduledExports { get; set; }

        public string[] FindChanges(FileDefinition newDef)
        {
            var changes = new List<string>();
            if (this.Name != newDef.Name)
                changes.Add("Name changed from " + this.Name + " to " + newDef.Name);
            if (this.FileType != newDef.FileType)
                changes.Add("FileType changed from " + ((FileType)this.FileType).ToString() + " to " + ((FileType)newDef.FileType).ToString());
            if (this.Delimiter != newDef.Delimiter)
                changes.Add("Delimiter changed from " + this.Delimiter + " to " + newDef.Delimiter);
            if (this.ExportDateType != newDef.ExportDateType)
                changes.Add("ExportDateType changed from " + ((ExportDateType)this.ExportDateType).ToString().Replace("_", " ") + " to " + ((ExportDateType)newDef.ExportDateType).ToString().Replace("_", " "));
            if (this.FileStructureType != newDef.FileStructureType)
                changes.Add("FileStructureType changed from " + ((FileStructureType)this.FileStructureType).ToString().Replace("_", " ") + " to " + ((FileStructureType)newDef.FileStructureType).ToString().Replace("_", " "));

            if (this.Columns != null && newDef.Columns != null)
            {
                var newFields = newDef.Columns.Select(c => c.FieldName);
                var oldFields = this.Columns.Select(c => c.FieldName);
                foreach (var add in newDef.Columns.Where(c => !oldFields.Contains(c.FieldName)))
                {
                    changes.Add("Added Column " + add.FieldName + " at position " + add.ColumnOrder);
                }
                foreach (var remove in this.Columns.Where(c => !newFields.Contains(c.FieldName)))
                {
                    changes.Add("Removed Column " + remove.FieldName);
                }
                foreach (var old in this.Columns.Where(c => newFields.Contains(c.FieldName)))
                {
                    var neww = newDef.Columns.Where(c => c.FieldName == old.FieldName).First();
                    if (old.ColumnOrder != neww.ColumnOrder)
                        changes.Add("Column " + neww.FieldName + " moved from position " + old.ColumnOrder + " to position " + neww.ColumnOrder);
                    if (old.DisplayName != neww.DisplayName)
                        changes.Add("Column " + neww.FieldName + " display name changed from " + old.DisplayName + " to " + neww.DisplayName);
                }
            }
            return changes.ToArray();
        }
    }

    public enum FileType
    {
        CSV = 0,
        XLSX = 1,
        XLS = 2,
        Other_Delimiter = 9
    }

    public enum FileStructureType
    {
        Stacked = 0,
        Raw = 1
    }
}
