using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;
using System.Text.RegularExpressions;

namespace NRC.Picker.Depricated.OCSHHCAHPS.ImportProcessor.Extractors
{
    public static class Factory
    {
        private static IExtract extract = null;

        public static IExtract GetExtractor(DAL.Generated.ClientDetail client)
        {
            // TODO: need to be smarter about different types of extractors.  for now all extractor are of the same type.
            if (extract == null)
            {
                extract = (IExtract)(new OCS.HHCAHPS());
            }
            return extract;
        }
    }
}
