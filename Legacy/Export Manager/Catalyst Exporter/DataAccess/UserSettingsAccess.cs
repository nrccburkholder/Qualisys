using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Nrc.CatalystExporter.DataContracts;
using Nrc.CatalystExporter.Logging;
using System.Diagnostics;

namespace Nrc.CatalystExporter.DataAccess
{
    public class UserSettingsAccess
    {
        public UserSetting Find(string username, UserContext userContext)
        {
            Logger.Log(string.Format("UserSetting Find: {0}", username), TraceEventType.Verbose, userContext);
            using (var db = new CatalystExportContext())
            {
                return db.UserSettings.Where(e => e.Username == username).FirstOrDefault();
            }
        }

        public UserSetting Save(UserSetting entity, UserContext userContext)
        {
            if (entity == null) throw new ArgumentException("Cannot save null UserSetting", "entity");

            Logger.Log(string.Format("UserSetting Save: {0}", entity.Username), TraceEventType.Verbose, userContext);

            using (var db = new CatalystExportContext())
            {
                if (Find(entity.Username, userContext) == null)
                {
                    db.UserSettings.Add(entity);
                    db.SaveChanges();

                    Logger.Log(string.Format("UserSetting Created: {0}", entity.Username), TraceEventType.Verbose, userContext);
                }
                else
                {
                    db.Entry(entity).State = System.Data.EntityState.Modified;
                    db.SaveChanges();

                    Logger.Log(string.Format("UserSetting Updated: {0}", entity.Username), TraceEventType.Verbose, userContext);
                }
            }
            return entity;
        }

    }
}
