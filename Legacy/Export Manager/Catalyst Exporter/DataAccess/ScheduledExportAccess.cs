using System;
using System.Data.Entity;
using System.Diagnostics;
using System.Linq;
using Nrc.CatalystExporter.DataContracts;
using Nrc.CatalystExporter.Logging;
using System.Collections.Generic;

namespace Nrc.CatalystExporter.DataAccess
{
    public class ScheduledExportAccess
    {
        public ScheduledExport Find(long id, UserContext userContext)
        {
            if (id <= 0) throw new ArgumentException("Invalid id", "id");

            Logger.Log(string.Format("ScheduledExport Find: {0}", id), TraceEventType.Verbose, userContext);
            using (var db = new CatalystExportContext())
            {
                return db.ScheduledExports.Where(e => e.Id == id).Include("FileDefinitions").FirstOrDefault();
            }
        }

        public ScheduledExport Find_IncludeColumns(long id, UserContext userContext)
        {
            if (id <= 0) throw new ArgumentException("Invalid id", "id");

            Logger.Log(string.Format("ScheduledExport Find_IncludeColumns: {0}", id), TraceEventType.Verbose, userContext);
            using (var db = new CatalystExportContext())
            {
                return db.ScheduledExports.Where(e => e.Id == id).Include("FileDefinitions.Columns.Replacements").FirstOrDefault();
            }
        }

        public ScheduledExport[] FindAllActive(UserContext userContext)
        {
            Logger.Log("ScheduledExport FindAllActive", TraceEventType.Verbose, userContext);
            using (var db = new CatalystExportContext())
            {
                return db.ScheduledExports.Where(e => e.IsActive).Include("FileDefinitions").ToArray();
            }
        }

        public ScheduledExport[] FindManyByDay_IncludeColumns(UserContext userContext)
        {
            Logger.Log("ScheduledExport FindManyByDay_IncludeColumns", TraceEventType.Verbose, userContext);
            using (var db = new CatalystExportContext())
            {
                return db.ScheduledExports.Where(e => e.IsActive && e.NextRunDate == DateTime.Today).Include("FileDefinitions.Columns.Replacements").ToArray();
            }
        }

        public ScheduledExport Save(ScheduledExport entity, UserContext userContext)
        {
            if (entity == null) throw new ArgumentException("Cannot save null ScheduledExport", "entity");

            Logger.Log(string.Format("ScheduledExport Save: {0}", entity.Id), TraceEventType.Verbose, userContext);

            if (entity.Id == 0)
            {
                entity.CreatedBy = userContext.UserName;
                entity.CreationDate = DateTime.Now;

                using (var db = new CatalystExportContext())
                {
                    db.ScheduledExports.Add(entity);
                    db.SaveChanges();
                }

                Logger.Log(string.Format("ScheduledExport Created: {0}", entity.Id), TraceEventType.Verbose, userContext);
            }
            else
            {
                using (var db = new CatalystExportContext())
                {
                    foreach (FileDefinition fdef in entity.FileDefinitions)
                    {
                        if (db.Entry(fdef).State.Equals(System.Data.EntityState.Detached))
                        {
                            if (fdef.Id.Equals(0))
                                db.Entry(fdef).State = System.Data.EntityState.Added;
                        }
                    }

                    db.Entry(entity).State = System.Data.EntityState.Modified;
                    db.SaveChanges();
                }

                Logger.Log(string.Format("ScheduledExport Updated: {0}", entity.Id), TraceEventType.Verbose, userContext);
            }

            return entity;
        }

        public void RemoveFileDefinitions(ScheduledExport scheduledExport)
        {
            using (var db = new CatalystExportContext())
            {
                db.ScheduledExports.Attach(scheduledExport);
                scheduledExport.FileDefinitions.RemoveAll(fd => fd.Id > 0);
                db.Entry(scheduledExport).State = System.Data.EntityState.Modified;
                db.SaveChanges();
            }
        }

        public void SaveMany(ScheduledExport[] entities, UserContext userContext)
        {
            if (entities == null) throw new ArgumentException("Cannot save null ScheduledExport[]", "entity");

            foreach (var entity in entities)
            {
                Logger.Log(string.Format("ScheduledExport Save: {0}", entity.Id), TraceEventType.Verbose, userContext);

                if (entity.Id == 0)
                {
                    entity.CreatedBy = userContext.UserName;
                    entity.CreationDate = DateTime.Now;

                    using (var db = new CatalystExportContext())
                    {
                        db.ScheduledExports.Add(entity);
                        db.SaveChanges();
                    }

                    Logger.Log(string.Format("ScheduledExport Created: {0}", entity.Id), TraceEventType.Verbose, userContext);
                }
                else
                {
                    using (var db = new CatalystExportContext())
                    {
                        db.Entry(entity).State = System.Data.EntityState.Modified;
                        db.SaveChanges();
                    }

                    Logger.Log(string.Format("ScheduledExport Updated: {0}", entity.Id), TraceEventType.Verbose, userContext);
                }
            }
        }

    }
}
