using System;
using System.Data.Entity;
using System.Diagnostics;
using System.Linq;
using Nrc.CatalystExporter.DataContracts;
using Nrc.CatalystExporter.Logging;

namespace Nrc.CatalystExporter.DataAccess
{
    public class ExportLogAccess
    {
        public ExportLog Find(long id, UserContext userContext)
        {
            if (id <= 0) throw new ArgumentException("Invalid id", "id");

            Logger.Log(string.Format("ExportLog Find: {0}", id), TraceEventType.Verbose, userContext);
            using (var db = new CatalystExportContext())
            {
                return db.ExportLogs.Where(e => e.Id == id).Include("FileDefinitions").FirstOrDefault();
            }
        }

        public ExportLog Find_IncludeColumns(long id, UserContext userContext)
        {
            if (id <= 0) throw new ArgumentException("Invalid id", "id");

            Logger.Log(string.Format("ExportLog Find_IncludeColumns: {0}", id), TraceEventType.Verbose, userContext);
            using (var db = new CatalystExportContext())
            {
                return db.ExportLogs.Where(e => e.Id == id).Include("FileDefinitions.Columns.Replacements").FirstOrDefault();
            }
        }

        public ExportLog[] FindMany(long[] ids, UserContext userContext)
        {
            Logger.Log("ExportLog FindMany", TraceEventType.Verbose, userContext);
            using (var db = new CatalystExportContext())
            {
                return db.ExportLogs.Where(e => ids.Contains(e.Id)).Include("FileDefinitions").ToArray();
            }
        }

        public ExportLog[] FindMany_IncludeColumns(long[] ids, UserContext userContext)
        {
            Logger.Log("ExportLog FindMany", TraceEventType.Verbose, userContext);
            using (var db = new CatalystExportContext())
            {
                return db.ExportLogs.Where(e => ids.Contains(e.Id)).Include("FileDefinitions.Columns.Replacements").ToArray();
            }
        }

        public ExportLog[] FindManyBySurveyIds(int[] ids, UserContext userContext)
        {
            Logger.Log("ExportLog FindManyBySurveyIds", TraceEventType.Verbose, userContext);
            using (var db = new CatalystExportContext())
            {   
                var query = from el in db.ExportLogs
                            from fd in db.FileDefinitions
                            where ids.Contains(fd.SurveyId) 
                            && fd.ExportLogs.Contains(el)
                            select el;

                return query.Include("FileDefinitions").ToArray();
            }
        }

        public ExportLog Save(ExportLog entity, UserContext userContext)
        {
            if (entity == null) throw new ArgumentException("Cannot save null ExportLog", "entity");

            Logger.Log(string.Format("ExportLog Save: {0}", entity.Id), TraceEventType.Verbose, userContext);

            if (entity.Id == 0)
            {
                entity.CreatedBy = userContext.UserName;
                entity.CreationDate = DateTime.Now;
                
                using (var db = new CatalystExportContext())
                {

                    foreach (FileDefinition fdef in entity.FileDefinitions)
                    {
                        if (fdef.Id > 0)
                        {
                            db.Entry(fdef).State = System.Data.EntityState.Modified;
                        }
                    }

                    db.ExportLogs.Add(entity);
                    db.SaveChanges();
                }

                Logger.Log(string.Format("ExportLog Created: {0}", entity.Id), TraceEventType.Verbose, userContext);
            }
            else
            {
                using (var db = new CatalystExportContext())
                {
                    db.Entry(entity).State = System.Data.EntityState.Modified;
                    db.SaveChanges();
                }

                Logger.Log(string.Format("ExportLog Updated: {0}", entity.Id), TraceEventType.Verbose, userContext);
            }

            return entity;
        }

        public void SaveMany(ExportLog[] entities, UserContext userContext)
        {
            if (entities == null) throw new ArgumentException("Cannot save null ExportLog[]", "entity");

            foreach (var entity in entities)
            {
                Logger.Log(string.Format("ExportLog Save: {0}", entity.Id), TraceEventType.Verbose, userContext);

                if (entity.Id == 0)
                {
                    entity.CreatedBy = userContext.UserName;
                    entity.CreationDate = DateTime.Now;

                    using (var db = new CatalystExportContext())
                    {
                        db.ExportLogs.Add(entity);
                        db.SaveChanges();
                    }

                    Logger.Log(string.Format("ExportLog Created: {0}", entity.Id), TraceEventType.Verbose, userContext);
                }
                else
                {
                    using (var db = new CatalystExportContext())
                    {
                        db.Entry(entity).State = System.Data.EntityState.Modified;
                        db.SaveChanges();
                    }

                    Logger.Log(string.Format("ExportLog Updated: {0}", entity.Id), TraceEventType.Verbose, userContext);
                }
            }
        }
    }
}
