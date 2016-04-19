using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System.Web;
using System.Net;
using System.IO;
using System.Xml;



namespace PersonatorAddressCleaner_POC
{
    class Program
    {
        static void Main(string[] args)
        {

            Console.WriteLine("Personator Address Cleaner:  POC ");
            Console.WriteLine();
            Console.WriteLine("Press ENTER to begin.");
            Console.ReadLine();
            Start();
            Console.WriteLine("End of Processing");
            Console.WriteLine("Press ENTER to exit.");
            Console.ReadLine();
            Console.WriteLine("Exiting application...");

        }


        static void Start()
        {
            HttpWebRequest request;
            HttpWebResponse response;
            Stream responseReader;
            XmlDocument xmlDoc;

            Uri apiUri = new Uri("https://personator.melissadata.net/v3/WEB/ContactVerify/doContactVerify");
            string customerID = "99869570";
            string tAction = "Check";
            string tCols = "";
            string tCentricHint = "Address";
            string tAppend = "CheckError";
            string tFirstName = "Timothy";
            string tLastName = "Butler";
            string tMiddleInit = "S";
            string tFullName = $"{tFirstName} {tMiddleInit} {tLastName}";
            string tCompany = "";
            string tAddress1 = "610 S Evergreen Drive";
            string tAddress2 = "";
            string tCity = "Seward";
            string tState = "Nebraska";
            string tPostalCode = "68444";
            string tCountry = "USA";
            string tLastLines = "";
            string tFreeForm = "";
            string tPhone = "4026416896";
            string tEmail = "tbutler1@neb.rr.com";

            string parameters = "?t=" + "Testing.";
            parameters += "&id=" + customerID;
            parameters += "&act=" + tAction;
            parameters += "&cols="+ tCols;
            parameters += "&opt=CentricHint:" + tCentricHint;
            parameters += "Append:" + tAppend;
            parameters += "&first=" + tFirstName;
            parameters += "&last=" + tLastName;
            parameters += "&full=" + tFullName;
            parameters += "&comp="+ tCompany;
            parameters += "&a1=" + tAddress1;
            parameters += "&a2=" + tAddress2;
            parameters += "&city=" + tCity;
            parameters += "&state=" + tState;
            parameters += "&postal=" + tPostalCode;
            parameters += "&ctry=" + tCountry;
            parameters += "&lastlines=" + tLastLines;
            parameters += "&freeform=" + tFreeForm;
            parameters += "&email=" + tEmail;
            parameters += "&phone=" + tPhone;
            parameters += "&reserved=";

            //https://personator.melissadata.net/v3/WEB/ContactVerify/doContactVerify?t=Testing.&id=99869570&act=Check,&cols=&opt=CentricHint:AddressAppend:CheckError&first=&last=&full=Mr. Timothy S. Butler&comp=&a1=610 S Evergreen Drove&a2=&city=Seward&state=NE&postal=68433&ctry=USA&lastlines=&freeform=&email=tbutler1@neb.rr.com&phone=4026416741&reserved=


            string tRequest = apiUri + parameters;

            // create the web request
            request = (HttpWebRequest)WebRequest.Create(tRequest);

            // get response
            response = (HttpWebResponse)request.GetResponse();

            // get the response into a reader
            responseReader = response.GetResponseStream();

            XmlTextWriter outXML = new XmlTextWriter("response.xml", null);

            xmlDoc = new XmlDocument();
            xmlDoc.Load(responseReader);
            xmlDoc.Save(outXML);
            outXML.Close();

            response.Close();
            responseReader.Close();

            Console.WriteLine();
            Console.WriteLine(xmlDoc.InnerText);
            Console.WriteLine();

            WriteOutput(xmlDoc);


        }


        static void WriteOutput(XmlDocument xmlDoc)
        {
            //TODO:

        }
    }
}
