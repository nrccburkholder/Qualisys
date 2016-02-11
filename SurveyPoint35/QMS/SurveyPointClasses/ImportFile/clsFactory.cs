using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using SurveyPointDAL;

namespace SurveyPointClasses.ImportFile
{
    /// <summary>
    /// Summary description for clsImportFactory.
    /// </summary>
    public class clsFactory
    {
        public static IImportFile CreateByFileType(clsFileDefs.FileTypes fileType)
        {
            IImportFile result = null;
            if (fileType == clsFileDefs.FileTypes.FIXED_WIDTH)
            {
                result = new ImportFile.clsFixedWidth();
            }
            else if (fileType == clsFileDefs.FileTypes.COMMA_DELIMITED)
            {
                throw new Exception("Comma delimited file types are not currently supported. Please check the file definition.");
                //result = null;
            }
            else if (fileType == clsFileDefs.FileTypes.TAB_DELIMITED)
            {
                throw new Exception("Tab delimited file types are not currently supported.  Please check the file definition.");
                //result = null;
            }
            else if (fileType == clsFileDefs.FileTypes.OTHER_DELIMITED)
            {
                throw new Exception("Delimited file types are not currently supported.  Please check the file definition.");
                //result = null;
            }

            return result;
        }

        public static IImportFile CreateByFileDef(int FileDefID)
        {
            dsSurveyPoint.FileDefsRow filedef = clsFileDefs.getFileDef(FileDefID);
            IImportFile result = CreateByFileType((clsFileDefs.FileTypes)filedef.FileTypeID);
            return result;
        }
    }
}
