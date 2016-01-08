using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace NRC.Picker.Depricated.OCSHHCAHPS.ImportProcessor.DAL.Generated
{
    public partial class GetClientTransformsResult
    {
        public DateTime? LastModDate
        {
            set { }
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
            set { }
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
