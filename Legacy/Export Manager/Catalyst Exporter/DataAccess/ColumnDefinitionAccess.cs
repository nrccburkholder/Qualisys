using System;
using System.Diagnostics;
using System.Linq;
using Nrc.CatalystExporter.DataContracts;
using Nrc.CatalystExporter.Logging;
using System.Data.Entity;

namespace Nrc.CatalystExporter.DataAccess
{
    public class ColumnDefinitionAccess
    {
        public ColumnDefinition Find(long id, UserContext userContext)
        {
            if (id <= 0) throw new ArgumentException("Invalid id", "id");

            Logger.Log(string.Format("ColumnDefinition Find: {0}", id), TraceEventType.Verbose, userContext);
            using (var db = new CatalystExportContext())
            {
                return db.ColumnDefinitions.Where(c => c.Id == id).Include(c => c.Replacements).FirstOrDefault();
            }
        }

        public ColumnDefinition[] FindMany(long[] ids, UserContext userContext)
        {
            Logger.Log("ColumnDefinition FindMany", TraceEventType.Verbose, userContext);
            using (var db = new CatalystExportContext())
            {
                return db.ColumnDefinitions.Where(e => ids.Contains(e.Id)).Include(c => c.Replacements).ToArray();
            }
        }

        public ColumnDefinition[] FindManyByFileDefinitionId(long fileDefintionId, UserContext userContext)
        {
            Logger.Log("ColumnDefinition FindManyByFileDefinitionId", TraceEventType.Verbose, userContext);
            using (var db = new CatalystExportContext())
            {
                return db.ColumnDefinitions.Where(e => e.FileDefinitionId == fileDefintionId).Include(c => c.Replacements).ToArray();
            }
        }

        public ColumnDefinition Save(ColumnDefinition entity, UserContext userContext)
        {
            if (entity == null) throw new ArgumentException("Cannot save null ColumnDefinition", "entity");

            Logger.Log(string.Format("ColumnDefinition Save: {0}", entity.Id), TraceEventType.Verbose, userContext);

            if (entity.Id == 0)
            {
                using (var db = new CatalystExportContext())
                {
                    db.ColumnDefinitions.Add(entity);
                    db.SaveChanges();
                }

                Logger.Log(string.Format("ColumnDefinition Created: {0}", entity.Id), TraceEventType.Verbose, userContext);
            }
            else
            {
                using (var db = new CatalystExportContext())
                {
                    db.Entry(entity).State = System.Data.EntityState.Modified;
                    db.SaveChanges();
                }

                Logger.Log(string.Format("ColumnDefinition Updated: {0}", entity.Id), TraceEventType.Verbose, userContext);
            }

            return entity;
        }

        public void SaveMany(ColumnDefinition[] entities, UserContext userContext)
        {
            if (entities == null) throw new ArgumentException("Cannot save null ColumnDefinition[]", "entity");

            foreach (var entity in entities)
            {
                Logger.Log(string.Format("ColumnDefinition Save: {0}", entity.Id), TraceEventType.Verbose, userContext);

                if (entity.Id == 0)
                {
                    using (var db = new CatalystExportContext())
                    {
                        db.ColumnDefinitions.Add(entity);
                        db.SaveChanges();
                    }

                    Logger.Log(string.Format("ColumnDefinition Created: {0}", entity.Id), TraceEventType.Verbose, userContext);
                }
                else
                {
                    using (var db = new CatalystExportContext())
                    {
                        db.Entry(entity).State = System.Data.EntityState.Modified;
                        db.SaveChanges();
                    }

                    Logger.Log(string.Format("ColumnDefinition Updated: {0}", entity.Id), TraceEventType.Verbose, userContext);
                }
            }
        }
    }
}
