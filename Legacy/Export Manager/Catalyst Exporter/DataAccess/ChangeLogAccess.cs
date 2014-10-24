using System;
using System.Data.Entity;
using System.Diagnostics;
using System.Linq;
using Nrc.CatalystExporter.DataContracts;
using Nrc.CatalystExporter.Logging;

namespace Nrc.CatalystExporter.DataAccess
{
    public class ChangeLogAccess
    {
        public ChangeLog Find(long id, UserContext userContext)
        {
            if (id <= 0) throw new ArgumentException("Invalid id", "id");

            Logger.Log(string.Format("ChangeLog Find: {0}", id), TraceEventType.Verbose, userContext);
            using (var db = new CatalystExportContext())
            {
                return db.ChangeLogs.Where(e => e.Id == id).FirstOrDefault();
            }
        }
        
        public ChangeLog[] FindMany(long[] ids, UserContext userContext)
        {
            Logger.Log("ChangeLog FindMany", TraceEventType.Verbose, userContext);
            using (var db = new CatalystExportContext())
            {
                return db.ChangeLogs.Where(e => ids.Contains(e.Id)).ToArray();
            }
        }

        public ChangeLog[] FindManyByScheduledExportId(long scheduledId, UserContext userContext)
        {
            Logger.Log(string.Format("ChangeLog FindManyByScheduledExportId: {0}", scheduledId), TraceEventType.Verbose, userContext);
            using (var db = new CatalystExportContext())
            {
                return db.ChangeLogs.Where(e => e.ScheduledExportId == scheduledId).ToArray();
            }
        }

        public ChangeLog Save(ChangeLog entity, UserContext userContext)
        {
            if (entity == null) throw new ArgumentException("Cannot save null ChangeLog", "entity");

            Logger.Log(string.Format("ChangeLog Save: {0}", entity.Id), TraceEventType.Verbose, userContext);

            if (entity.Id == 0)
            {
                entity.ModifiedBy = userContext.UserName;
                entity.ModifiedDate = DateTime.Now;

                using (var db = new CatalystExportContext())
                {
                    db.ChangeLogs.Add(entity);
                    db.SaveChanges();
                }

                Logger.Log(string.Format("ChangeLog Created: {0}", entity.Id), TraceEventType.Verbose, userContext);
            }
            else
            {
                using (var db = new CatalystExportContext())
                {
                    db.Entry(entity).State = System.Data.EntityState.Modified;
                    db.SaveChanges();
                }

                Logger.Log(string.Format("ChangeLog Updated: {0}", entity.Id), TraceEventType.Verbose, userContext);
            }

            return entity;
        }

        public void SaveMany(ChangeLog[] entities, UserContext userContext)
        {
            if (entities == null) throw new ArgumentException("Cannot save null ChangeLog[]", "entity");

            foreach (var entity in entities)
            {
                Logger.Log(string.Format("ChangeLog Save: {0}", entity.Id), TraceEventType.Verbose, userContext);

                if (entity.Id == 0)
                {
                    entity.ModifiedBy = userContext.UserName;
                    entity.ModifiedDate = DateTime.Now;

                    using (var db = new CatalystExportContext())
                    {
                        db.ChangeLogs.Add(entity);
                        db.SaveChanges();
                    }

                    Logger.Log(string.Format("ChangeLog Created: {0}", entity.Id), TraceEventType.Verbose, userContext);
                }
                else
                {
                    using (var db = new CatalystExportContext())
                    {
                        db.Entry(entity).State = System.Data.EntityState.Modified;
                        db.SaveChanges();
                    }

                    Logger.Log(string.Format("ChangeLog Updated: {0}", entity.Id), TraceEventType.Verbose, userContext);
                }
            }
        }
    }
}
