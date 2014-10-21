using System.Data.Entity;
using Nrc.CatalystExporter.DataContracts;

namespace Nrc.CatalystExporter.DataAccess
{
    public class CatalystDatamartContext : DbContext
    {
        public DbSet<ClientStudySurvey> v_ClientStudySurvey { get; set; }
        public DbSet<SamplePopulationBackgroundColumnAttribute> SamplePopulationBackgroundColumnAttribute { get; set; }
        public DbSet<SamplePopulationBackgroundField> SamplePopulationBackgroundField { get; set; }

        public CatalystDatamartContext()
            : base("Catalyst") //pass in ConnectionString name to get the correct db name
        {

        }

        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            modelBuilder.Entity<ClientStudySurvey>().ToTable("v_ClientStudySurvey");
            modelBuilder.Entity<ClientStudySurvey>().HasKey(c => new { c.ClientID, c.StudyID, c.SurveyID });
            modelBuilder.Entity<SamplePopulationBackgroundColumnAttribute>().ToTable("SamplePopulationBackgroundColumnAttribute");
            modelBuilder.Entity<SamplePopulationBackgroundColumnAttribute>().HasKey(c => new { c.StudyID, c.ColumnName });
            modelBuilder.Entity<SamplePopulationBackgroundField>().ToTable("SamplePopulationBackgroundField");
            modelBuilder.Entity<SamplePopulationBackgroundField>().HasKey(c => new { c.SamplePopulationID, c.ColumnName });
            base.OnModelCreating(modelBuilder);
        }

        public void SetCommandTimeout(int timeout)
        {
            // Get the ObjectContext related to this DbContext
            var objectContext = (this as System.Data.Entity.Infrastructure.IObjectContextAdapter).ObjectContext;
            objectContext.CommandTimeout = timeout;
        }
    }
}
