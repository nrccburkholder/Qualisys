using System;
using System.Xml;
using System.Xml.Schema;
using System.IO;
using System.Collections;
using System.Xml.Serialization;
using System.CodeDom;
using Microsoft.CSharp;
using System.Text;
using XmlSchemaClassGenerator;
using System.Collections.Generic;
using System.CodeDom.Compiler;

namespace GenerateSchema {
	public enum NestingType {
        RussianDoll,
		SeparateComplexTypes
	}

	public class SchemaBuilder {
		public SchemaBuilder() 	{}

		const string SCHEMA_NAMESPACE = "http://www.w3.org/2001/XMLSchema";
		ArrayList complexTypes = new ArrayList();
		NestingType generationType;

        List<string> listFields = new List<string>();
        string classText = string.Empty;

		public string BuildSchema(string xml,NestingType type) {
			generationType = type;
			//Create schema element
            
            XmlSchema schema = new XmlSchema();
			schema.ElementFormDefault = XmlSchemaForm.Qualified;
			schema.AttributeFormDefault = XmlSchemaForm.Unqualified;
			schema.Version = "1.0";
			//Add additional namespaces using the Add() method shown below
			//if desired
			XmlSerializerNamespaces ns = new XmlSerializerNamespaces();
			ns.Add("xsd", SCHEMA_NAMESPACE);
			schema.Namespaces = ns;
			
			//Begin parsing source XML document
			XmlDocument doc = new XmlDocument();
			try { //Assume string XML
				doc.LoadXml(xml);
			}
			catch {
				try { //String XML load failed.  Try loading as a file path
					doc.Load(xml);
				}
				catch {
					return "XML document is not well-formed.";
				}
			}
			XmlElement root = doc.DocumentElement;

			//Create root element definition for schema
			//Call CreateComplexType to either add a complexType tag
			//or simply add the necesary schema attributes
			XmlSchemaElement elem = CreateComplexType(root);
			//Add root element definition into the XmlSchema object
			schema.Items.Add(elem);
			//Reverse elements in ArrayList so root complexType appears first
			//where applicable
			complexTypes.Reverse();
			//In cases where the user wants to separate out the complexType tags
			//loop through the complexType ArrayList and add the types to the schema
			foreach(object obj in complexTypes) {
				XmlSchemaComplexType ct = (XmlSchemaComplexType)obj;
				schema.Items.Add(ct);
			}

            XmlSchemaSet schemaSet = new XmlSchemaSet();
            schemaSet.ValidationEventHandler += new ValidationEventHandler(ValidateSchema);
            schemaSet.Add(schema);
			//Compile the schema and then write its contents to a StringWriter
			try {

                schemaSet.Compile();

				StringWriter sw = new StringWriter();
				schema.Write(sw);

                //MakeObject(schema);
                MakeInMemoryClass();

				return sw.ToString();
			} catch (Exception exp) {
				return exp.Message;
			}
		}

        

		public void ValidateSchema(object sender, ValidationEventArgs args) {}

		private XmlSchemaElement CreateComplexType(XmlElement element) {
			ArrayList namesArray = new ArrayList();

			//Create complexType
			XmlSchemaComplexType ct = new XmlSchemaComplexType();
			if (element.HasChildNodes) {
				//loop through children and place in schema sequence tag
				XmlSchemaSequence seq = new XmlSchemaSequence();
				foreach (XmlNode node in element.ChildNodes) {
					if (node.NodeType == XmlNodeType.Element) {
						if (namesArray.BinarySearch(node.Name) < 0) {
							namesArray.Add(node.Name);
							namesArray.Sort(); //Needed for BinarySearch()
							XmlElement tempNode = (XmlElement)node;
							XmlSchemaElement sElem = null;
							//If node has children or attributes then create a new
							//complexType container
							if (tempNode.HasChildNodes || tempNode.HasAttributes) {
								sElem = CreateComplexType(tempNode);
							} else { //No comlexType needed...add SchemaTypeName
								sElem = new XmlSchemaElement();
								sElem.Name = tempNode.Name;
								if (tempNode.InnerText == null || tempNode.InnerText == String.Empty) {
									sElem.SchemaTypeName = new XmlQualifiedName("string",SCHEMA_NAMESPACE);
								} else {
									//Try to detect the appropriate data type for the element
									sElem.SchemaTypeName = new XmlQualifiedName(CheckDataType(tempNode.InnerText),SCHEMA_NAMESPACE);
								}
							}
							//Detect if node repeats in XML so we can handle maxOccurs
							if (element.SelectNodes(node.Name).Count > 1) {
								sElem.MaxOccursString = "unbounded";
							}
							//Add element to sequence tag
							seq.Items.Add(sElem);
						}
					}
				}
				//Add sequence tag to complexType tag
				if (seq.Items.Count > 0) ct.Particle = seq;
			}
			if (element.HasAttributes) {
				foreach (XmlAttribute att in element.Attributes) {
					XmlSchemaAttribute sAtt = new XmlSchemaAttribute();
					sAtt.Name = att.Name;
					sAtt.SchemaTypeName = new XmlQualifiedName(CheckDataType(att.Value),SCHEMA_NAMESPACE);
					ct.Attributes.Add(sAtt);
				}
			}

			//Now that complexType is created, create element and add 
			//complexType into the element using its SchemaType property
			XmlSchemaElement elem = new XmlSchemaElement();
			elem.Name = element.Name;
			if (ct.Attributes.Count > 0 || ct.Particle != null) {
				//Handle nesting style of schema
				if (generationType == NestingType.SeparateComplexTypes) {
					string typeName = element.Name + "Type";
					ct.Name = typeName;
					complexTypes.Add(ct);
					elem.SchemaTypeName = new XmlQualifiedName(typeName,null);
				} else {
					elem.SchemaType = ct;
				}
			} else {
				if (element.InnerText == null || element.InnerText == String.Empty) {
					elem.SchemaTypeName = new XmlQualifiedName("string",SCHEMA_NAMESPACE);
				} else {
					elem.SchemaTypeName = new XmlQualifiedName(CheckDataType(element.InnerText),SCHEMA_NAMESPACE);
				}

			}
			return elem;
		}

		private string CheckDataType(string data) {
			//Int test
			try {
				Int32.Parse(data);
				return "int";
			} catch {}

			//Decimal test
			try {
				Decimal.Parse(data);
				return "decimal";
			} catch {}

			//DateTime test
			try {
				DateTime.Parse(data);
				return "dateTime";
			} catch {}

			//Boolean test
			if (data.ToLower() == "true" || data.ToLower() == "false") {
				return "boolean";
			}

			return "string";
		}


        private void MakeObject(XmlSchema schema)
        {
            Func<string, string> getNameSpace = s => "MyNameSpace";
            try
            {


                Generator gen = new Generator();
                gen.GenerateNamespaceName = getNameSpace;
                gen.NamespaceMapping = new Dictionary<string, string>();
                gen.NamespaceMapping.Add("MyClass", "MyNameSpace");
                gen.OutputFolder = @"C:\Users\tbutler\Documents";


                List<string> files = new List<string>();
                files.Add(@"C:\Users\tbutler\Documents\HHCAHPS_XML_Sample_File.xsd");

                gen.Generate(files);


                // CHECK this out -- http://www.codeproject.com/Articles/19635/Create-a-Class-and-its-Collection-in-Memory-Create

                //XmlSchemas schemas = new XmlSchemas();
                //schemas.Add(schema);
                //CodeNamespace ns = new CodeNamespace { Name = "MyNamespace" };

                //ns.Imports.Add(new CodeNamespaceImport("System"));
                //ns.Imports.Add(new CodeNamespaceImport("System.Collections.Generic"));

                //XmlCodeExporter exporter = new XmlCodeExporter(ns);
                //XmlSchemaImporter importer = new XmlSchemaImporter(schemas);



                //foreach (XmlSchemaElement element in schema.Elements.Values)
                //{

                //    XmlTypeMapping  mapping = importer.ImportTypeMapping(element.QualifiedName);
                //    exporter.ExportTypeMapping(mapping);
                //}


                //return ns;
                //// Transform CodeDOM as required, adding new attributes, methods, modifying
                //// inheritance hierarchy, whatever.

                ////var provider = new CSharpCodeProvider();
                ////using (var writer = new StreamWriter(outputFile, false))
                ////  provider.GenerateCodeFromNamespace(ns, writer, new CodeGeneratorOptions())

            }
            catch (Exception ex)
            {
                throw ex;
            }

        }

        private void MakeInMemoryClass()
        {

             //classText= "using System.Collections.Generic; namespace DynamicCollection class Entity{string _name;string _address;string _city;public string name{get{return _name;}set{_name =  value;}}public string address{get{return _address;}set{_address =  value;}}public string city{get{return _city;}set{_city =  value;}}} class EntityList:List<Entity>{}}";

            GenerateCode();

            try
            {
                    /// <summary>
                    /// run time compiler variables
                    /// </summary>
                    CompilerResults CompilationResult;
                    CodeDomProvider RuntimeCompiler = new Microsoft.CSharp.CSharpCodeProvider();
                    CompilerParameters Parameters = new CompilerParameters();

                    /// <summary>
                    /// This configuration tells the runtime compiler
                    /// to generate code in Memory
                    ///</summary>
                    Parameters.GenerateExecutable = false;

                    Parameters.GenerateInMemory = true;

                    Parameters.IncludeDebugInformation = false;

                    // compile the code and return the result in compilerresult 
                    CompilationResult = RuntimeCompiler.CompileAssemblyFromSource(Parameters, classText);

                    //object that represent our class
                    object myClass;
                    if (CompilationResult == null || classText == string.Empty)
                    {
                        if (CompilationResult == null)
                            Console.WriteLine("Compile First");
                        else
                            Console.WriteLine("Determine number of objects you want to create");

                        return;
                    }

                    //Create instance from our collection
                    object myClasslist = CompilationResult.CompiledAssembly.CreateInstance("DynamicCollection.EntityList");

                    //Create Object instance from the class
                    myClass = CompilationResult.CompiledAssembly.CreateInstance("DynamicCollection.Entity");

                    //Get Properties of our class at run time using reflection
                    System.Reflection.PropertyInfo[] ProI = myClass.GetType().GetProperties();

                    //for each property, set a value
                    //for simplicity, I make all things strings
                    //this is because finally you can convert string to anything 
                    foreach (System.Reflection.PropertyInfo Pro in ProI)
                    {
                        //set member variable value
                        Pro.SetValue(myClass, "Smile", null);
                    }

                    // we do this because the Invoke method take the values 
                    //array of objects
                    object[] myObject = new object[1];
                    myObject[0] = myClass;
                    //Add the Object to our collection using reflection and Invoke
                    myClasslist.GetType().GetMethod("Add").Invoke(myClasslist, myObject);

                    int x = 1;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }


        private void GenerateCode()
        {
            listFields.Add("name");
            listFields.Add("address");
            listFields.Add("city");
            listFields.Add("state");

            //this is just to convert fielsds to 
            // class and collection
            //you can do it in any way 

            #region CsharpLanguage
            //you can do it as enumrator outside 
            // but i put it here for simplicity 
            const string usingss = @"using System.Collections.Generic;";
            const string _namespace = "namespace ";
            const string myNamespace = "DynamicCollection";
            const string open = "{";
            const string close = "}";
            const string _class = "class ";
            const string Entity = "Entity";
            const string underscore = "_";
            const string variable = "string ";
            const string Property = "public ";
            const string get = "get";
            const string set = "set";
            const string ret = "return ";
            const string eq = " = ";
            const string doted = ":";
            const string EntityList = "EntityList";
            const string collection = "List<" + Entity + ">";
            const string followstop = ";";
            const string val = " value";
            #endregion

            StringBuilder sourcecode = new StringBuilder();

            #region Generate usings + class header
            //generate usings + class
            sourcecode.Append(usingss);
            sourcecode.Append(Environment.NewLine);
            sourcecode.Append(_namespace + myNamespace);
            sourcecode.Append(Environment.NewLine);
            sourcecode.Append(open);
            sourcecode.Append(Environment.NewLine);
            sourcecode.Append(_class);
            sourcecode.Append(Entity);
            sourcecode.Append(Environment.NewLine);
            sourcecode.Append(open);
            sourcecode.Append(Environment.NewLine);

            #endregion

            #region Generate members
            //generate class member variables 
            foreach (object item in listFields)
            {
                sourcecode.Append(variable);
                sourcecode.Append(underscore + item.ToString());
                sourcecode.Append(followstop);
                sourcecode.Append(Environment.NewLine);
            }

            #endregion

            #region Generate proprties
            //generate proprties for each variable 
            foreach (object item in listFields)
            {
                sourcecode.Append(Property);
                sourcecode.Append(variable);
                sourcecode.Append(item.ToString());
                sourcecode.Append(Environment.NewLine);
                sourcecode.Append(open);
                sourcecode.Append(Environment.NewLine);
                sourcecode.Append(get);
                sourcecode.Append(open);
                sourcecode.Append(ret + underscore + item.ToString() + followstop);
                sourcecode.Append(close);
                sourcecode.Append(Environment.NewLine);
                sourcecode.Append(set);
                sourcecode.Append(open);
                sourcecode.Append(underscore + item.ToString() + eq + val + followstop);
                sourcecode.Append(close);
                sourcecode.Append(Environment.NewLine);
                sourcecode.Append(close);
                sourcecode.Append(Environment.NewLine);
            }

            #endregion
            // close the class
            sourcecode.Append(Environment.NewLine);
            sourcecode.Append(close);
            sourcecode.Append(Environment.NewLine);
            sourcecode.Append(Environment.NewLine);

            //generate entitylist
            sourcecode.Append(_class + EntityList + doted + collection);
            sourcecode.Append(open);
            sourcecode.Append(close);
            sourcecode.Append(Environment.NewLine);
            sourcecode.Append(close);


            classText = sourcecode.ToString();
        }

	}
}
