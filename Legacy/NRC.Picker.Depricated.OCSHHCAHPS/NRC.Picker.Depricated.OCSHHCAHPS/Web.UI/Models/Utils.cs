using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Xml.Linq;

using HostingEnvironment = System.Web.Hosting.HostingEnvironment;
using Generated = NRC.Picker.Depricated.OCSHHCAHPS.ImportProcessor.DAL.Generated;
using NRC.Picker.Depricated.OCSHHCAHPS.ImportProcessor.DAL;
using NRC.Common.Configuration;

namespace NRC.Picker.Depricated.OCSHHCAHPS.Web.UI.Models
{
    public static class Utils
    {
        public static Settings Settings = ConfigManager.Load<Settings>();

        public static List<TransformLibraryImportItem> TransformLibraries(int transformId)
        {
            List<TransformLibraryImportItem> items = new List<TransformLibraryImportItem>();

            var importedLibs = TransformRepository.GetRepository().GetTransformImports(transformId);

            IEnumerable<Generated.TransformLibrary> libs = TransformRepository.GetRepository().GetTransformLibraries();
            foreach (var lib in libs)
            {
                TransformLibraryImportItem item = new TransformLibraryImportItem
                    {
                        TransformId = transformId,
                        TransformLibraryId = lib.TransformLibraryId,
                        TransformLibraryName = lib.TransformLibraryName,
                        IsImported = false
                    };

                foreach (var imp in importedLibs)
                {
                    if (imp.TransformLibraryId.Equals(lib.TransformLibraryId))
                    {
                        item.IsImported = true;
                        break;
                    }
                }

                items.Add(item);
            }

            return items;
        }

        public static void ValidateTransformMapping(Generated.TransformMapping transformMapping)
        {
            if (string.IsNullOrEmpty(transformMapping.Transform))
            {
                return;
            }

            #region Build a complete Transform and sample data
            // This does not really belong here.  The problem is the TransformMapping is not saved to the database
            // yet (when creating or updating) and so I can't easily use the code that takes a transform from the database
            // and converts that to the xml representation.  Need to either eliminate the XML representation of the transform
            // or create a helper function to deserealize the db Transform data to XML.
            #region Build the Transform
            XElement xroot = new XElement("transforms");

            #region Get any Imports for the tranform
            XElement xImports = new XElement("imports");

            var target = TransformRepository.GetRepository().GetTransformTarget(transformMapping.TransformTargetId);

            if (target != null)
            {
                var imports = target.TransformDefinition.FirstOrDefault().Transform.TransformImports;
                foreach (var import in imports)
                {
                    XElement xImport = new XElement("import", new XAttribute("name", import.TransformLibrary.TransformLibraryName));
                    xImport.Value = import.TransformLibrary.Code;

                    xImports.Add(xImport);
                }
            }
            xroot.Add(xImports);
            #endregion

            // Create a a dummy target
            XElement xtarget = new XElement("transform",
                new XAttribute("target", "test"),
                new XAttribute("transformtargetid", -1),
                new XAttribute("transformtargetname", "test"));

            // Create the field level transform mapping
            XElement fieldTransform = new XElement("field", new XAttribute("targetfield", transformMapping.TargetFieldname));
            fieldTransform.Value = transformMapping.Transform;
            if (!string.IsNullOrEmpty(transformMapping.SourceFieldName))
            {
                fieldTransform.Add(new XAttribute("sourcefield", transformMapping.SourceFieldName));
            }

            // add the field level transform to the dummy target
            xtarget.Add(fieldTransform);
            xroot.Add(xtarget);

            XDocument transforms = new XDocument();
            transforms.Add(xroot);
            #endregion

            #region Load a sample data file that we can apply to the transform
            var p = HostingEnvironment.MapPath("~/Content/OCSHHCAHPS_TestData.xml");
            XDocument data = XDocument.Load(p);
            #endregion

            #region create a dummy test client
            Generated.ClientDetail client = new Generated.ClientDetail
            {
                Client_id = -1,
                ClientName = "test",
                CCN = "000000",
                Languages = "E,S",
                Study_id = -1,
                Survey_id = -1
            };
            #endregion 
            #endregion

            XDocument transformedData = NRC.Picker.Depricated.OCSHHCAHPS.ImportProcessor.Transforms.Factory
                .GetTransformProcessor(client)
                .Transform(client, transforms, data);

        }

        public static string GetDataFileDirectory(Generated.UploadedFileLogView item)
        {
            if (item.DataFileState_id == (int)DataFileState.Abandoned)
            {
                string cssDir = System.IO.Directory.GetParent(item.DataFileLocation).FullName;
                string date = item.DateUploadFileStateChange.ToString("yyyyMMdd");
                string path = System.IO.Path.Combine(cssDir, "Abandoned");
                path = System.IO.Path.Combine(path, date);
                return path;
            }

            return System.IO.Directory.GetParent(item.DataFileLocation).FullName;
        }

        public static string GetUploadFileDirectory(Generated.UploadedFileLogView item)
        {
            if (item.UploadFileState_id == (int)UploadState.UploadedAbandoned)
            {
                // \\minerva\OCS\AbandonedUploads
                string date = item.DateUploadFileStateChange.ToString("yyyyMMdd");
                string path = Settings.AbandonedUploadsDirectory; //.FullName;
                path = System.IO.Path.Combine(path,date);
                return path;
            }

            if (!string.IsNullOrEmpty(item.DataFileLocation))
            {
                string cssDir = System.IO.Directory.GetParent(item.DataFileLocation).FullName;
                return System.IO.Path.Combine(cssDir, "UploadFiles");
            }

            return Settings.AbandonedUploadsDirectory; //.Parent.FullName;

        }
    }

}