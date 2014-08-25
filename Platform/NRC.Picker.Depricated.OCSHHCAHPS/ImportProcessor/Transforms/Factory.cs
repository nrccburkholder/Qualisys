using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;
using System.Text.RegularExpressions;

using NRC.Picker.Depricated.OCSHHCAHPS.ImportProcessor.DAL;

namespace NRC.Picker.Depricated.OCSHHCAHPS.ImportProcessor.Transforms
{
    public static class Factory
    {
        private static ITransform transform = null;

        public static ITransform GetTransformProcessor(DAL.Generated.ClientDetail client)
        {
            if (transform == null)
            {
                transform = (ITransform)(new NRC.Picker.Depricated.OCSHHCAHPS.ImportProcessor.Transforms.DynamicTransform());
            }
            return transform;
        }
    }
}
