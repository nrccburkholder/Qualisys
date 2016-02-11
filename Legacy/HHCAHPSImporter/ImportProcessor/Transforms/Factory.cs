using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;
using System.Text.RegularExpressions;

using HHCAHPSImporter.ImportProcessor.DAL;

namespace HHCAHPSImporter.ImportProcessor.Transforms
{
    public static class Factory
    {
        private static ITransform transform = null;

        public static ITransform GetTransformProcessor(DAL.Generated.ClientDetail client)
        {
            if (transform == null)
            {
                transform = (ITransform)(new HHCAHPSImporter.ImportProcessor.Transforms.DynamicTransform());
            }
            return transform;
        }
    }
}
