using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml.Linq;

namespace NRC.Picker.Depricated.OCSHHCAHPS.ImportProcessor.Transforms
{
    public interface ITransform
    {
        XDocument Transform(DAL.Generated.ClientDetail client, XDocument transforms, XDocument data);
        void TestLibrary(string libraryCode);
    }
}
