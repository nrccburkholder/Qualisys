using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml.Linq;

namespace HHCAHPSImporter.ImportProcessor.Extractors
{
    public interface IExtract
    {
        XDocument Extract(DAL.Generated.ClientDetail client, string file);
    }
}
