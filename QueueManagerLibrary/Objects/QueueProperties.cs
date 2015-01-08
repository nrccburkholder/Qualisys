using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace QueueManagerLibrary.Objects
{
    public class QueueProperties
    {

        private string mKey;

        public string Key
        {
            get { return mKey; }
            set { mKey = value; }
        }
        public string Title { get; set; }
        public object SourceObject { get; set; }


        public QueueProperties()
        {

        }

    }
}
