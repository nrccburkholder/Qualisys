using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Web.Mvc;
using Nrc.CatalystExporter.DataContracts;

namespace Nrc.CatalystExporter.ExportClient.Models
{
    public class CreateNewModel
    {
        public IEnumerable<NewDefinition> Definitions { get; set; }

        public bool IsScheduled { get; set; }

        public bool IsCombined { get; set; }

        [Required]
        public string FileName { get; set; }
        public DateTime? StartDate { get; set; }
        public DateTime? EndDate { get; set; }
        [Required]
        public FileType TypeOfFile { get; set; }
        public string Delimiter { get; set; }
        public ScheduledExport Schedule { get; set; }
        [Required]
        public ExportDateType DateType { get; set; }
        [Required]
        public FileStructureType FileStructure { get; set; }

        //Values for drop downs
        public IEnumerable<SelectListItem> FileTypes { get; set; }
        public IEnumerable<SelectListItem> Intervals { get; set; }
        public IEnumerable<SelectListItem> DateTypes { get; set; }
        public IEnumerable<SelectListItem> FileStructureTypes { get; set; }
    }
}