using System.Data.Entity;
using Nrc.CatalystExporter.DataContracts;

namespace Nrc.CatalystExporter.DataAccess
{
    public class CatalystExportContext : DbContext
    {
        public DbSet<ExportLog> ExportLogs { get; set; }
        public DbSet<ColumnDefinition> ColumnDefinitions { get; set; }
        public DbSet<ColumnTextReplacement> ColumnTextReplacements { get; set; }
        public DbSet<ScheduledExport> ScheduledExports { get; set; }
        public DbSet<FileDefinition> FileDefinitions { get; set; }
        public DbSet<ChangeLog> ChangeLogs { get; set; }
        public DbSet<UserSetting> UserSettings { get; set; }

        public CatalystExportContext()
            : base("CatalystExportContext") //pass in ConnectionString name to get the correct db name
        {

        }

        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            modelBuilder.Entity<ExportLog>().HasMany<FileDefinition>(el => el.FileDefinitions);
            modelBuilder.Entity<FileDefinition>().HasMany<ExportLog>(fd => fd.ExportLogs);

            modelBuilder.Entity<ScheduledExport>().HasMany<FileDefinition>(se => se.FileDefinitions);
            modelBuilder.Entity<FileDefinition>().HasMany<ScheduledExport>(fd => fd.ScheduledExports);
        }
    }
}
