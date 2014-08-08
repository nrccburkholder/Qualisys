using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml.Linq;

namespace NRC.Picker.Depricated.OCSHHCAHPS.ImportProcessor.Extractors
{
    public interface IExtract
    {
        XDocument Extract(DAL.Generated.ClientDetail client, string file);
    }
}
