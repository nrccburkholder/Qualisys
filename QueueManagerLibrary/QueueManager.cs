using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using QueueManagerLibrary.Objects;
using System.Drawing;
using System.Drawing.Imaging;
using Nrc.Framework.BusinessLogic.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Data.Common;

namespace QueueManagerLibrary
{
    public class QueueManager
    {

        #region private members

        private List<Client> mClients;
        private string strPCL = string.Empty;
        private string strPCLServer = string.Empty;
        private string strPCLDatabase = string.Empty;
        private string strThisServier = string.Empty;
        private string strThisDatabase = string.Empty;

        #endregion

        #region constructors

        public QueueManager()
        {
            mClients = new List<Client>();
            strPCL = string.Empty;
        }

        #endregion

        #region public methods

        public List<Client> LoadClients(bool isReprint)
        {
            return Client.SelectClientList(strPCL, isReprint);
        }

        public List<GroupedPrint> LoadGroupedPrintList(bool isReprint)
        {
            return GroupedPrint.SelectGroupedPrintList(isReprint);
        }

        public List<Configuration> LoadConfigurationList(bool isReprint, int SurveyID)
        {
            return Configuration.SelectConfigurationList(strPCL, isReprint, SurveyID);
        }

        public List<PaperConfig> LoadPaperConfigList(bool isReprint, int SurveyID, int PaperConfigID, DateTime datBundled)
        {
            return PaperConfig.SelectPaperConfigList(strPCL, isReprint, SurveyID, datBundled, PaperConfigID);
        }

        public DateTime GetLastBundleDate()
        {
            bool isRunning = false;
            string bundleDate = "";

            QueueManagerLibrary.DataProviders.CommonProvider.GetLastBundleDate(ref isRunning, ref bundleDate);
           

            return DateTime.Parse(bundleDate);
        }


        public bool ShowGroupedPrint()
        {
            return AppConfig.Params["ShowGroupedPrint"].IntegerValue == 1;
        }

        public bool PrintingInstance_Add(ref DateTime LastBundlingDate)
        {
            bool isAdded = false;
            string bundlingDate = string.Empty;
            QueueManagerLibrary.DataProviders.CommonProvider.GetPrintingAddInstance(ref isAdded, ref bundlingDate);

            LastBundlingDate = DateTime.Parse(bundlingDate);

            return isAdded;
        }

        public void PrintInstance_Remove()
        {
            QueueManagerLibrary.DataProviders.CommonProvider.RemovePrintingInstance();
        }

        public void GroupedPrintRebundleAndSetLithos(int paperConfigID, DateTime printDate)
        {
            QueueManagerLibrary.DataProviders.GroupedPrintProvider.GroupedPrintRebundleAndSetLithos(paperConfigID, printDate);
        }

        public bool GetGroupedPrint(int paperConfigID, bool isReprint, DateTime? printDate = null)
        {
            int numSheets = 0;
            int minLithoCode = 0;
            int numSplitThreshhold = 0;
            int numSplits = 0;
            int numSheetsPerSplit = 0;
            string strFileHeader = string.Empty;
            string strSQL = string.Empty;

            DateTime datPrinted;
            if (!printDate.HasValue)
            {
                datPrinted = DateTime.Parse("1/1/1980");
                isReprint = false;
            }
            else datPrinted = printDate.Value;

            strSQL = "SELECT MM.Survey_id, Z.strSizeCode, P.intSheet_num, P.intPA, P.intPB, P.intPC, P.intPD, S.strLithoCode, S.strPostalBundle, S.strGroupDest, P.PCLStream ";

            string strFromWhere = " FROM pcloutput P, PaperSize Z, NPSentMailing S, " +
                   "MailingMethodology MM, GroupedPrint GP " +
                   " WHERE MM.survey_id = GP.Survey_id " +
                   "       AND MM.Methodology_id = S.Methodology_id " +
                   "       AND S.PaperConfig_id = GP.PaperConfig_id " +
                   "       AND S.PaperConfig_id = " + paperConfigID.ToString() +
                   "       AND P.SentMail_id = S.SentMail_id " +
                   "       AND abs(datediff(second,gp.datBundled,'" + datPrinted.ToString("mm/dd/yyyy hh:mm:ss AMPM") + "'))<=1 " +
                   "       AND GP.datBundled= s.datBundled  " +
                   "       AND P.PaperSize_id = Z.PaperSize_id ";

            if (isReprint)
            {
                strFromWhere = strFromWhere + " AND S.datPrinted<'4000' AND abs(datediff(second,S.datPrinted,'" + datPrinted.ToString("mm/dd/yyyy hh:mm:ss AMPM") + "'))<=1 ";
            }
            else
            {
                strFromWhere = strFromWhere + " AND S.datPrinted = '1/1/4000' ";
            }

            string sql = "SELECT Z.strSizeCode, P.intSheet_num, count(*) as cnt, min(strLithoCode) as minLithoCode " +
                         strFromWhere +
                         "GROUP BY Z.strSizeCode, P.intSheet_num " +
                         "ORDER BY count(*) DESC";

            DataSet ds1 = QueueManagerLibrary.DataProviders.CommonProvider.GetDataSetBySqlString(sql);
            using (ds1)
            {
                if (ds1.Tables.Count > 0)
                {
                    if (ds1.Tables[0].Rows.Count > 0)
                    {
                        numSheets = Convert.ToInt32(ds1.Tables[0].Rows[0]["cnt"]);
                        minLithoCode = Convert.ToInt32(ds1.Tables[0].Rows[0]["minLithoCode"]);
                    }
                    else
                    {
                        throw new Exception("QueManagerDB:clsQueueManager:GetGroupedPrint", new Exception("error accessing print streams"));
                    }
                }
            }

            numSplitThreshhold = AppConfig.Params["SplitThreshold"].IntegerValue;

            if (isReprint)
            {
                strFileHeader = "GP_" + datPrinted.ToString("yyyymmdd_hhmm") + "_" + paperConfigID.ToString();
            }
            else
            {
                strFileHeader = "GP_" + DateTime.Now.ToString("yyyymmdd_hhmm") + "_" + paperConfigID.ToString();
            }

            bool GetGroupedPrint = false;

            if (numSheets > numSplitThreshhold)
            {
                numSplits = 1 + (int)(numSheets / numSplitThreshhold);
                numSheetsPerSplit = 1 + (numSheets / numSplits);
                strSQL = strSQL.Replace("P.PCLStream", "(s.strLithoCode-" + minLithoCode.ToString() + ") / " + numSheetsPerSplit.ToString() + " as intSplit, P.PCLStream");
                strSQL = strSQL + strFromWhere + " order by strLithoCode, intSheet_Num ";

                GetGroupedPrint = PrintBundle(strSQL, strFileHeader, new List<string> { "strSizeCode", "intSheet_num", "intSplit" });
            }
            else
            {
                strSQL = strSQL + strFromWhere + " order by strLithoCode, intSheet_Num ";
                GetGroupedPrint = PrintBundle(strSQL, strFileHeader, new List<string> { "strSizeCode", "intSheet_num" });
            }

            if (!isReprint && GetGroupedPrint)
            {
                QueueManagerLibrary.DataProviders.GroupedPrintProvider.SetPrintDate(0, "", paperConfigID, DateTime.Parse("1/1/1980"), datPrinted);
            }

            return GetGroupedPrint;
        }

        public void SetLithoCodes(bool isReprint, int surveyid, string postalBundle, int paperConfigId, int pageNum, string strBundled)
        {
            QueueManagerLibrary.DataProviders.CommonProvider.SetLithoCodes(isReprint, surveyid, postalBundle, paperConfigId, pageNum, strBundled);
        }

        #region bitmap color methods
        public static Bitmap ChangeColor(Bitmap source, Color oldColor, Color newColor)
       {
          //You can change your new color here. Red,Green,LawnGreen any..
          //Color newColor = Color.Red;          
          //make an empty bitmap the same size as scrBitmap
          Bitmap newBitmap = new Bitmap(source.Width, source.Height);
          for (int i = 0; i < source.Width; i++)
          {
             for (int j = 0; j < source.Height; j++)
             {
                 var originalColor = source.GetPixel(i, j);
                 if (originalColor.R == oldColor.R && originalColor.G == oldColor.G && originalColor.B == oldColor.B)
                     newBitmap.SetPixel(i, j, newColor);
                 else newBitmap.SetPixel(i, j, originalColor);
             }
          }            
          return newBitmap;
       }

        public static unsafe Bitmap ReplaceColor(Bitmap source,
                                  Color toReplace,
                                  Color replacement)
        {
            const int pixelSize = 4; // 32 bits per pixel

            Bitmap target = new Bitmap(
              source.Width,
              source.Height,
              PixelFormat.Format32bppArgb);

            BitmapData sourceData = null, targetData = null;

            try
            {
                sourceData = source.LockBits(
                  new Rectangle(0, 0, source.Width, source.Height),
                  ImageLockMode.ReadOnly, PixelFormat.Format32bppArgb);

                targetData = target.LockBits(
                  new Rectangle(0, 0, target.Width, target.Height),
                  ImageLockMode.WriteOnly, PixelFormat.Format32bppArgb);

                for (int y = 0; y < source.Height; ++y)
                {
                    byte* sourceRow = (byte*)sourceData.Scan0 + (y * sourceData.Stride);
                    byte* targetRow = (byte*)targetData.Scan0 + (y * targetData.Stride);

                    for (int x = 0; x < source.Width; ++x)
                    {
                        byte b = sourceRow[x * pixelSize + 0];
                        byte g = sourceRow[x * pixelSize + 1];
                        byte r = sourceRow[x * pixelSize + 2];
                        byte a = sourceRow[x * pixelSize + 3];

                        if (toReplace.R == r && toReplace.G == g && toReplace.B == b)
                        {
                            r = replacement.R;
                            g = replacement.G;
                            b = replacement.B;
                        }

                        targetRow[x * pixelSize + 0] = b;
                        targetRow[x * pixelSize + 1] = g;
                        targetRow[x * pixelSize + 2] = r;
                        targetRow[x * pixelSize + 3] = a;
                    }
                }
            }
            finally
            {
                if (sourceData != null)
                    source.UnlockBits(sourceData);

                if (targetData != null)
                    target.UnlockBits(targetData);
            }

            return target;
        }

        #endregion

        #endregion

        #region static methods

        public static bool PrintBundle(string sql, string fileheader, List<string>FileNameFields)
        {

            return false;
        }

        #endregion
    }
}
