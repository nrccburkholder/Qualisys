using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace HHCAHPSImporter.ImportProcessor.DAL
{
    public class EntityBase
    {
        /// <summary>
        /// Returns a formated string with the user and date of the last modification to this item
        /// </summary>
        /// <returns></returns>
        public string GetLastModString()
        {
            var createUserField = this.GetType().GetProperty("CreateUser");
            var createDateField = this.GetType().GetProperty("CreateDate");

            if (createUserField != null && createDateField != null)
            {
                string createUser = createUserField.GetValue(this, null).ToString();
                DateTime createDate = DateTime.Parse(createDateField.GetValue(this, null).ToString());

                object uu = this.GetType().GetProperty("UpdateUser").GetValue(this,null);
                object ud = this.GetType().GetProperty("UpdateDate").GetValue(this,null);

                string updateUser = string.Empty;
                DateTime? updateDate = null;
                if( uu != null && ud != null )
                {
                    updateUser = uu.ToString();
                    updateDate = DateTime.Parse(ud.ToString());
                }

                return string.Format("{0} at {1}", string.IsNullOrEmpty(updateUser) ? createUser : updateUser, updateDate.HasValue ? updateDate : createDate);
            }

            return "";
        }

        public DateTime? LastModDate
        {
            get
            {
                var createDateField = this.GetType().GetProperty("CreateDate");

                if (createDateField != null)
                {
                    object createDateValue = createDateField.GetValue(this, null);

                    if (createDateValue != null)
                    {
                        DateTime createDate = DateTime.Parse(createDateValue.ToString());

                        object ud = this.GetType().GetProperty("UpdateDate").GetValue(this, null);

                        if (ud != null)
                        {
                            return DateTime.Parse(ud.ToString());
                        }

                        return createDate;
                    }
                }

                return null;
            }
        }

        public string LastModUser
        {
            get
            {
                var createUserField = this.GetType().GetProperty("CreateUser");

                if (createUserField != null)
                {
                    object createUserValue = createUserField.GetValue(this, null);

                    if (createUserValue != null)
                    {
                        string createUser = createUserValue.ToString();

                        object uu = this.GetType().GetProperty("UpdateUser").GetValue(this, null);

                        if (uu != null)
                        {
                            return uu.ToString();
                        }

                        return createUser;
                    }
                }

                return "";

            }
        }

    }
}
