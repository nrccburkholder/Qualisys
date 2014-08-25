using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.CodeDom.Compiler;
using Microsoft.CSharp;
using Microsoft.VisualBasic;
using System.Xml.Linq;
using System.Reflection;
using System.IO;
using System.Text.RegularExpressions;

using NRC.Picker.Depricated.OCSHHCAHPS.ImportProcessor.DAL;

namespace NRC.Picker.Depricated.OCSHHCAHPS.ImportProcessor.Transforms
{
    class DynamicTransform : ITransform
    {
        private Dictionary<string, object> _compiledCode = new Dictionary<string, object>();

        // if this is a straight field-to-field mapping no need to run any dynamic code to transform it
        Regex fieldMapOnlyPattern = new Regex(@"^Records\(""R1""\)\.Fields\(""(.+)""\)$", RegexOptions.Compiled|RegexOptions.Singleline);

        #region ITransform Members

        public XDocument Transform(DAL.Generated.ClientDetail client, XDocument xtrans, XDocument data)
        {
            List<XElement> transforms = xtrans.Root.Elements("transform").ToList<XElement>();
            List<XElement> imports = xtrans.Root.Descendants("import").ToList<XElement>();

            var xMetaData = data.Root.Descendants("metadata").Elements();

            int dataFileId = Convert.ToInt32(xMetaData.Elements()
                .Where(t => t.Attribute("n").Value.Equals("DATAFILE_ID"))
                .First().Value);

            XElement xroot = new XElement("datafile", data.Root.Attributes() );

            StringBuilder importedMethods = new StringBuilder();
            foreach (XElement import in imports)
            {
                importedMethods.AppendLine(import.Value);
            }

            foreach (XElement transform in transforms)
            {
                XElement transformedRows = new XElement("target", new XAttribute("table", transform.Attribute("target").Value)) ;

                Dictionary<string, string> macroValueDict = new Dictionary<string, string>();
                macroValueDict["ClientId"] = client.Client_id.ToString() ;
                macroValueDict["StudyId"] = client.Study_id.ToString();
                macroValueDict["SurveyId"] = client.Survey_id.ToString();
                macroValueDict["ContractedLanguages"] = client.Languages;

                macroValueDict["DATAFILE_ID"] = dataFileId.ToString();

                foreach (XElement row in data.Root.Descendants("rows").Elements())
                {
                    XElement copyRow = new XElement(row);
                    copyRow.Add(xMetaData.Elements());

                    XElement transformedRow = TransformRow(client, copyRow, macroValueDict, importedMethods.ToString(), transform);
                    transformedRows.Add(transformedRow);
                }

                xroot.Add(transformedRows); 
            }

            XDocument xdoc = new XDocument();
            xdoc.Add(xroot);
            return xdoc;
        }

        public void TestLibrary(string libraryCode)
        {
            CodeDomProvider compiler = null;

            compiler = new VBCodeProvider();

            CompilerParameters loParameters = new CompilerParameters();

            // *** Start by adding any referenced assemblies
            loParameters.ReferencedAssemblies.Add("System.dll");
            loParameters.ReferencedAssemblies.Add("Microsoft.VisualBasic.dll");
            loParameters.ReferencedAssemblies.Add(Assembly.GetExecutingAssembly().Location);//, "NRC.Picker.Depricated.ImportProcessors.OCSHHCAHPS.dll"));

            string vbCode =
@"Imports System
Imports System.IO
Imports System.Collections.Generic
Imports Microsoft.VisualBasic
Imports Microsoft.VisualBasic.Constants
Imports Microsoft.VisualBasic.Conversion
Imports Microsoft.VisualBasic.DateAndTime
Imports Microsoft.VisualBasic.Financial
Imports Microsoft.VisualBasic.Strings
Imports Microsoft.VisualBasic.VBMath
Imports NRC.Picker.Depricated.OCSHHCAHPS.ImportProcessor.Transforms.Misc

Namespace NRC
Public Class DynamicCode 
    Inherits Methods
    ''''''''''''''''''''''''''''''''''
    {0}
    ''''''''''''''''''''''''''''''''''
End Class
End Namespace";

            // string lcCode = string.Format(csharpCode, sourceCode);
            string lcCode = string.Format(vbCode, libraryCode);

            // *** Load the resulting assembly into memory
            loParameters.GenerateInMemory = false;
            // loParameters.WarningLevel = 0;

            // *** Now compile the whole thing
            CompilerResults loCompiled = compiler.CompileAssemblyFromSource(loParameters, lcCode);

            if (loCompiled.Errors.HasErrors)
            {
                string lcErrorMsg = "";

                lcErrorMsg = loCompiled.Errors.Count.ToString() + " Errors:";
                for (int x = 0; x < loCompiled.Errors.Count; x++)
                {
                    lcErrorMsg = lcErrorMsg + "\r\nLine: " +
                                    loCompiled.Errors[x].Line.ToString() + " - " +
                                    loCompiled.Errors[x].ErrorText;
                }
                throw new Exception(lcErrorMsg);
            }
        }

        #endregion

        #region Private Methods
        private XElement TransformRow(DAL.Generated.ClientDetail client, XElement row, Dictionary<string, string> macroValueDict, string importedMethods, XElement transform)
        {
            Dictionary<string, string> rowDict = new Dictionary<string, string>();
            if (row != null)
            {
                rowDict = row.Elements("nv").ToDictionary(
                    t => t.Attribute("n").Value,
                    t => t.Value);
            }
            if (row.Attribute("id") != null)
            {
                rowDict.Add("_rowid", row.Attribute("id").Value);
            }

            XElement r = new XElement("r", new XAttribute("id", row.Attribute("id").Value));

            foreach (XElement field in transform.Descendants("field"))
            {
                // source field to transform
                // note, it is possible to not have a source field
                // this would mean we are create a new field that will be derived 
                // from a set of fields or some other value (etc, metadata)
                XAttribute sourceField = field.Attribute("sourcefield");

                // this is the code used to transform a field.
                // not required, but if this the transformCode is empty then we must have the sourceField
                string transformCode = field.Value.Trim();

                string sourceValue = string.Empty;

                // if a sourceField is specified then read the value of the source field into the sourceValue variable
                if (sourceField != null)
                {
                    // extract the source element
                    var sourceElement = row.Elements("nv")
                        .Where(t => t.Attribute("n").Value.Equals(sourceField.Value))
                        .FirstOrDefault();

                    if (sourceElement != null)
                    {
                        sourceValue = sourceElement.Value;
                    }
                    else
                    {
                        throw new Exception(string.Format("Could not find column '{0}' in the row.", sourceField.Value));
                    }
                }
                else
                {
                    if (string.IsNullOrEmpty(transformCode))
                    {
                        throw new Exception(string.Format("The transform mapping for the field {0} is empty and there is no sourcefield specified.", field.Attribute("targetfield").Value));
                    }
                }

                string transformedValue = string.Empty;

                if (string.IsNullOrEmpty(transformCode))
                {
                    transformedValue = sourceValue;
                }
                else
                {
                    transformedValue = ExecuteDynamicTransform(sourceValue, rowDict, macroValueDict, importedMethods, field.Value);
                }

                // TODO: Can I exclude empty nodes?
                // include all target field values, even empty ones.
                // if (!string.IsNullOrEmpty(transformedValue))
                {
                    r.Add(new XElement(field.Attribute("targetfield").Value.ToLower(), transformedValue));
                }
            }

            return r;
        }

        private string ExecuteDynamicTransform(string inputValue, Dictionary<string, string> rowDict, Dictionary<string, string> macroValueDict, string imports, string sourceCode)
        {
            return ExecuteDynamicTransform(inputValue, rowDict, macroValueDict, imports, sourceCode, false);
        }

        private string ExecuteDynamicTransform(string inputValue, Dictionary<string, string> rowDict, Dictionary<string, string> macroValueDict, string imports, string sourceCode, bool isTestOnly)
        {
            Match m = fieldMapOnlyPattern.Match(sourceCode);
            if (m.Success)
            {
                string sourceFieldName = m.Groups[1].Value;
                if (rowDict.Keys.Contains(sourceFieldName))
                {
                    return rowDict[sourceFieldName];
                }
                else if( macroValueDict.Keys.Contains(sourceFieldName) )
                {
                    return macroValueDict[sourceFieldName];
                }
            }
            //////////////

            string codeKey = "~null~";
            if (!string.IsNullOrEmpty(sourceCode))
            {
                codeKey = sourceCode.GetHashCode().ToString();
            }

            if (!_compiledCode.Keys.Contains(codeKey) || isTestOnly)
            {
                CodeDomProvider compiler = null;

                compiler = new VBCodeProvider();

                CompilerParameters loParameters = new CompilerParameters();

                // *** Start by adding any referenced assemblies
                loParameters.ReferencedAssemblies.Add("System.dll");
                loParameters.ReferencedAssemblies.Add("Microsoft.VisualBasic.dll");
                loParameters.ReferencedAssemblies.Add(Assembly.GetExecutingAssembly().Location);//, "NRC.Picker.Depricated.ImportProcessors.OCSHHCAHPS.dll"));

                string vbCode =
@"Imports System
Imports System.IO
Imports System.Collections.Generic
Imports Microsoft.VisualBasic
Imports Microsoft.VisualBasic.Constants
Imports Microsoft.VisualBasic.Conversion
Imports Microsoft.VisualBasic.DateAndTime
Imports Microsoft.VisualBasic.Financial
Imports Microsoft.VisualBasic.Strings
Imports Microsoft.VisualBasic.VBMath
Imports NRC.Picker.Depricated.OCSHHCAHPS.ImportProcessor.Transforms.Misc

Namespace NRC
    Public Class DynamicCode 
        Inherits Methods
        Public Function Execute(ByVal sourceFieldValue As String, ByVal row As Dictionary(Of String, String), ByVal MacroValue As Dictionary(Of String,String)) as String
            SetData(row, MacroValue)

            {0}

            Return String.Empty
        End Function

        ''''''''''''''''''''''''''''''''''
        {1}
        ''''''''''''''''''''''''''''''''''
    End Class
End Namespace";

                sourceCode = sourceCode.Replace("Records(\"R1\").Fields", "row");
                sourceCode = sourceCode.Trim();

                if (string.IsNullOrEmpty(sourceCode))
                {
                    sourceCode = "Return sourceFieldValue";
                }
                else
                {
                    if (!sourceCode.Contains("Return"))
                    {
                        sourceCode = "Return " + sourceCode;
                    }
                }

                // string lcCode = string.Format(csharpCode, sourceCode);
                string lcCode = string.Format(vbCode, sourceCode, imports.ToString());

                // *** Load the resulting assembly into memory
                loParameters.GenerateInMemory = false;
                // loParameters.WarningLevel = 0;

                // *** Now compile the whole thing
                CompilerResults loCompiled = compiler.CompileAssemblyFromSource(loParameters, lcCode);

                if (loCompiled.Errors.HasErrors)
                {
                    string lcErrorMsg = "";

                    lcErrorMsg = loCompiled.Errors.Count.ToString() + " Errors:";
                    for (int x = 0; x < loCompiled.Errors.Count; x++)
                    {
                        // subtract 20 from the line number to give the illusion that is there no other code.
                        // this will make the first line of code read as line 1.  currently use 20, I *think* this is right but could be off-by-one.
                        lcErrorMsg = lcErrorMsg + "\r\nLine: " +
                                     (loCompiled.Errors[x].Line - 20).ToString() + " - " +
                                     loCompiled.Errors[x].ErrorText;
                    }
                    throw new Exception(lcErrorMsg);
                }

                Assembly loAssembly = loCompiled.CompiledAssembly;

                // *** Retrieve an obj ref – generic type only
                object loObject = loAssembly.CreateInstance("NRC.DynamicCode");

                if (loObject == null)
                {
                    throw new Exception("failed to create instance of NRC.DynamicCode");
                }

                if (isTestOnly) return "test only!";

                _compiledCode[codeKey] = loObject;
            }

            object[] loCodeParms = new object[3];
            loCodeParms[0] = inputValue;
            loCodeParms[1] = rowDict;
            loCodeParms[2] = macroValueDict;

            try
            {
                object loResult = _compiledCode[codeKey].GetType().InvokeMember(
                                 "Execute", BindingFlags.InvokeMethod,
                                 null, _compiledCode[codeKey], loCodeParms);

                return Convert.ToString(loResult);
                // return loResult.ToString();
            }
            catch (Exception loError)
            {
                throw loError.InnerException;
            }
        }
        #endregion
    }
}
