using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Nrc.CatalystExporter.DataContracts
{
    public static class DataContractExtensions
    {
        public static string ExportLogToString(this ExportLog log)
        {
            StringBuilder result = new StringBuilder();

            try
            {
                result.AppendFormat("Log Id: {0} \r\n", log.Id);
                result.AppendFormat("Created By: {0} \r\n", log.CreatedBy);
                result.AppendFormat("Creation Date: {0} \r\n", log.CreationDate);
                result.AppendFormat("Log Name: {0} \r\n", log.Name);
                result.AppendFormat("Directory: {0} \r\n", log.Location);
                result.AppendFormat("Start Date: {0} \r\n", log.StartDate);
                result.AppendFormat("End Date: {0} \r\n", log.EndDate);
                
                if (log.FileDefinitions != null)
                {
                    result.Append("File Definitions: \r\n");

                    foreach (FileDefinition fdef in log.FileDefinitions)
                    {
                        result.AppendFormat("   Client Id: {0} \r\n", fdef.ClientId);
                        result.AppendFormat("   Study Id: {0} \r\n", fdef.StudyId);
                        result.AppendFormat("   Survey Id: {0} \r\n", fdef.SurveyId);

                        if (fdef.Columns != null)
                        {
                            result.Append("   Columns: \r\n");
                            foreach (ColumnDefinition col in fdef.Columns)
                            {
                                result.AppendFormat("       Column Name: {0} \r\n", col.FieldName);
                            }
                            
                        }
                    }
                }

            }
            catch (Exception ex)
            {
            }

            return result.ToString();
        }

        public static string ScheduledExportToString(this ScheduledExport log)
        {
            StringBuilder result = new StringBuilder();

            try
            {
                result.AppendFormat("Schedule Id: {0} \r\n", log.Id);
                result.AppendFormat("Created By: {0} \r\n", log.CreatedBy);
                result.AppendFormat("Creation Date: {0} \r\n", log.CreationDate);
                                
                result.AppendFormat("Data Start Date: {0} \r\n", log.DataStartDate);
                result.AppendFormat("Next Run Date: {0} \r\n", log.NextRunDate);

                result.AppendFormat("Run Interval: {0} \r\n", log.RunInterval);
                result.AppendFormat("Run Interval Count: {0} \r\n", log.RunIntervalCount);

                result.AppendFormat("Data Interval: {0} \r\n", log.DataInterval);
                result.AppendFormat("Data Interval Count: {0} \r\n", log.DataIntervalCount);

                result.AppendFormat("Is Rolling: {0} \r\n", log.IsRolling);

                if (log.FileDefinitions != null)
                {
                    result.Append("File Definitions: \r\n");

                    foreach (FileDefinition fdef in log.FileDefinitions)
                    {
                        result.AppendFormat("   Client Id: {0} \r\n", fdef.ClientId);
                        result.AppendFormat("   Study Id: {0} \r\n", fdef.StudyId);
                        result.AppendFormat("   Survey Id: {0} \r\n", fdef.SurveyId);

                        if (fdef.Columns != null)
                        {
                            result.Append("   Columns: \r\n");
                            foreach (ColumnDefinition col in fdef.Columns)
                            {
                                result.AppendFormat("       Column Name: {0} \r\n", col.FieldName);
                            }

                        }
                    }
                }

            }
            catch (Exception ex)
            {
            }

            return result.ToString();
        }
    }
}
