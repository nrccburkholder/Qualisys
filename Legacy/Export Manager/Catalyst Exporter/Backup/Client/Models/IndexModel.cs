using System.Collections.Generic;
using Nrc.CatalystExporter.DataContracts;

namespace Nrc.CatalystExporter.ExportClient.Models
{
    public class IndexModel
    {
        public IEnumerable<ClientStudySurvey> Navigation { get; set; }

        public IEnumerable<string> FileLocations { get; set; }

        public int? ScheduledSavedCount { get; set; }
    }
}