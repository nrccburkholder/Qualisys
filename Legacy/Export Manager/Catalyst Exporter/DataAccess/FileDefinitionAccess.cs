using System;
using System.Data.Entity;
using System.Diagnostics;
using System.Linq;
using Nrc.CatalystExporter.DataContracts;
using Nrc.CatalystExporter.Logging;

namespace Nrc.CatalystExporter.DataAccess
{
    public class FileDefinitionAccess
    {
        public FileDefinition Find(long id, UserContext userContext)
        {
            if (id <= 0) throw new ArgumentException("Invalid id", "id");

            Logger.Log(string.Format("FileDefinition Find: {0}", id), TraceEventType.Verbose, userContext);
            using (var db = new CatalystExportContext())
            {
                return db.FileDefinitions.Where(f => f.Id == id).Include(f => f.Columns.Select(c => c.Replacements)).FirstOrDefault();
            }
        }

        public FileDefinition[] FindMany(long[] ids, UserContext userContext)
        {
            Logger.Log("FileDefinition FindMany", TraceEventType.Verbose, userContext);
            using (var db = new CatalystExportContext())
            {
                return db.FileDefinitions.Where(e => ids.Contains(e.Id)).Include(f => f.Columns.Select(c => c.Replacements)).ToArray();
            }
        }

        public FileDefinition Save(FileDefinition entity, UserContext userContext)
        {
            if (entity == null) throw new ArgumentException("Cannot save null FileDefinition", "entity");

            Logger.Log(string.Format("FileDefinition Save: {0}", entity.Id), TraceEventType.Verbose, userContext);

            if (entity.Id == 0)
            {
                using (var db = new CatalystExportContext())
                {
                    db.FileDefinitions.Add(entity);
                    db.SaveChanges();
                }

                Logger.Log(string.Format("FileDefinition Created: {0}", entity.Id), TraceEventType.Verbose, userContext);
            }
            else
            {
                using (var db = new CatalystExportContext())
                {
                    db.Entry(entity).State = System.Data.EntityState.Modified;
                    db.SaveChanges();
                }

                Logger.Log(string.Format("FileDefinition Updated: {0}", entity.Id), TraceEventType.Verbose, userContext);
            }

            return entity;
        }

        public void SaveMany(FileDefinition[] entities, UserContext userContext)
        {
            if (entities == null) throw new ArgumentException("Cannot save null FileDefinition[]", "entity");

            foreach (var entity in entities)
            {
                Logger.Log(string.Format("FileDefinition Save: {0}", entity.Id), TraceEventType.Verbose, userContext);

                if (entity.Id == 0)
                {
                    using (var db = new CatalystExportContext())
                    {
                        db.FileDefinitions.Add(entity);
                        db.SaveChanges();
                    }

                    Logger.Log(string.Format("FileDefinition Created: {0}", entity.Id), TraceEventType.Verbose, userContext);
                }
                else
                {
                    using (var db = new CatalystExportContext())
                    {
                        db.Entry(entity).State = System.Data.EntityState.Modified;
                        db.SaveChanges();
                    }

                    Logger.Log(string.Format("FileDefinition Updated: {0}", entity.Id), TraceEventType.Verbose, userContext);
                }
            }
        }
    }
}
