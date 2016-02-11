using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml.Linq;

namespace HHCAHPSImporter.ImportProcessor.Transforms
{
    public interface ITransform
    {
        XDocument Transform(DAL.Generated.ClientDetail client, XDocument transforms, XDocument data);
        void TestLibrary(string libraryCode);
    }
}
