using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using System.ComponentModel.DataAnnotations;

namespace Nrc.CatalystExporter.DataContracts
{
    [DataContract]
    public class UserSetting
    {
        [DataMember]
        [Key]
        public string Username { get; set; }

        [DataMember]
        public string NetworkLocation { get; set; }

        [NotMapped]
        public string NetworkLocationStart
        {
            get
            {
                var dollar = this.NetworkLocation.IndexOf('$');
                var colon = this.NetworkLocation.IndexOf(':');

                var root = this.NetworkLocation;
                if (dollar != -1)
                    root = this.NetworkLocation.Substring(0, dollar + 1);
                else if (colon != -1)
                    root = this.NetworkLocation.Substring(0, colon + 1);

                return root.Replace("\\", "\\\\");
            }
        }
    }
}
