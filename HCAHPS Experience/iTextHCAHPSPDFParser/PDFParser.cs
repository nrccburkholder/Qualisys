using System;
using System.Collections.Generic;
using System.Text;
using System.IO;
using iTextSharp.text.pdf;
using iTextSharp.text.pdf.parser;

namespace iTextHCAHPS
{
    public class ParsedData
    {
        public string CCN { get; set; }
        public string FacilityName { get; set; }
    }

    public static class PDFParser
    {
        public static void Split(string filename, string outputDirectory)
        {
            FileInfo fi = new FileInfo(filename);

            iTextSharp.text.pdf.PdfReader p = new iTextSharp.text.pdf.PdfReader(filename);

            int pageCount = p.NumberOfPages;

            List<ParsedData> pd = new List<ParsedData>();
            for (int i = 0; i < pageCount; i++)
            {
                string pageContent = PdfTextExtractor.GetTextFromPage(p, i + 1);
                ParsedData parsedData = ParsePage(pageContent);
                pd.Add(parsedData);
            }
            
            for (int i = 0; i < pageCount; i++)
            {
                //string pageContent = PdfTextExtractor.GetTextFromPage(p, i+1);
                //ParsedData parsedData = ParsePage(pageContent);
                ParsedData parsedData = pd[i];

                string outfile = Path.Combine(outputDirectory, string.Format("{0}_{1}.pdf", parsedData.CCN, parsedData.FacilityName));

                iTextSharp.text.Document newDoc = new iTextSharp.text.Document(p.GetPageSizeWithRotation(i + 1));

                PdfWriter pdfWriter = PdfWriter.GetInstance(newDoc, new FileStream(outfile, FileMode.CreateNew));
                newDoc.Open();
                PdfContentByte cb1 = pdfWriter.DirectContent;

                newDoc.SetPageSize(p.GetPageSizeWithRotation(i+1));
                newDoc.NewPage();
                PdfImportedPage page = pdfWriter.GetImportedPage(p, i+1); 
                int rotation = p.GetPageRotation(i+1); 
                if (rotation == 90 || rotation == 270)  
                { 
                    cb1.AddTemplate(page, 0, -1f, 1f, 0, 0, p.GetPageSizeWithRotation(i+1).Height); 
                } 
                else  
                { 
                    cb1.AddTemplate(page, 1f, 0, 0, 1f, 0, 0); 
                }
                newDoc.Close();
            }
        }

        public static ParsedData Parse(string filename)
        {
            iTextSharp.text.pdf.PdfReader p = new iTextSharp.text.pdf.PdfReader(filename);

            string pageText = iTextSharp.text.pdf.parser.PdfTextExtractor.GetTextFromPage(p, 1);

            return ParsePage(pageText);
        }

        public static ParsedData ParsePage(string pageContent)
        {
            string[] lines = pageContent.Split(new char[] { '\r', '\n' });

            string fn = lines[1].Replace("Springboarding the patient experience for ", "");

            fn = fn.Replace("Springboarding the patient experience forR", "");

            if (lines[2].Length != 6)
            {
                string linesText = string.Empty;
                if (lines.Length >= 3)
                {
                    linesText = string.Format("{0}\r\n{1}\r\n{2}\r\n", lines[0], lines[1], lines[2]);
                }

                throw new Exception(string.Format("Could not parse CCN from PDF \r\n{0}", linesText));
            }

            ParsedData retVal = new ParsedData()
            {
                CCN = lines[2],
                FacilityName = fn
            };

            return retVal;

        }

        public static string GetClientNameFromInsidePDF(string filename)
        {
            return Parse(filename).FacilityName;
        }
    }
}
