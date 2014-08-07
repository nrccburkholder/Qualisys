using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

using Generated = NRC.Picker.Depricated.OCSHHCAHPS.ImportProcessor.DAL.Generated;
using NRC.Picker.Depricated.OCSHHCAHPS.Web.UI.Models;
using NRC.Common.Configuration;

namespace NRC.Picker.Depricated.OCSHHCAHPS.Web.UI.Controllers
{
    [HandleError()]
    public class DataFilesController : ControllerBase
    {
        //
        // GET: /UploadFiles/

        public ActionResult Index()
        {
            Settings settings = ConfigManager.Load<Settings>();

            Generated.QP_DataLoad qpDataLoad = new Generated.QP_DataLoad(settings.QP_DataLoadConnectionString);

            // UploadedFileLogView
            var uploadfiles = qpDataLoad.UploadedFileLogView
                .Where(t => t.DataFile_id.HasValue &&
                            t.DateUploadFileStateChange >= DateTime.Now.AddDays(-7).Date )
                .OrderByDescending(t => t.DataFile_id)
                .Take(25);

            return View(uploadfiles);
        }

        [HttpPost]
        public ActionResult Index(string startDate, string endDate, string take, bool abandonedFilesOnly)
        {
            DateTime _startDate = DateTime.Now.AddDays(-7);
            if (!DateTime.TryParse(startDate, out _startDate))
            {
                _startDate = DateTime.Now.AddDays(-7);
            }

            DateTime _endDate = DateTime.Now.AddDays(-7);
            if (!DateTime.TryParse(endDate, out _endDate))
            {
                _endDate = DateTime.Now.AddDays(-7);
            }

            int _take = 25;
            if (!int.TryParse(take, out _take))
            {
                _take = 25;
            }

            ViewData["startDate"] = _startDate.ToString("MM/dd/yyyy");
            ViewData["endDate"] = _endDate.ToString("MM/dd/yyyy");
            ViewData["take"] = _take;

            Settings settings = ConfigManager.Load<Settings>();

            Generated.QP_DataLoad qpDataLoad = new Generated.QP_DataLoad(settings.QP_DataLoadConnectionString);

            List<Generated.UploadedFileLogView> uploadfiles = null;
            if (abandonedFilesOnly)
            {
                // UploadedFileLogView
                uploadfiles = qpDataLoad.UploadedFileLogView
                    .Where(t => t.DataFile_id.HasValue &&
                                t.DateUploadFileStateChange >= _startDate &&
                                t.DateUploadFileStateChange < _endDate.AddDays(1) &&
                                t.DataFileState_id.Equals(NRC.Picker.Depricated.OCSHHCAHPS.ImportProcessor.DAL.DataFileState.Abandoned))
                    .OrderByDescending(t => t.DataFile_id)
                    .Take(_take)
                    .ToList();
            }
            else
            {
                // UploadedFileLogView
                uploadfiles = qpDataLoad.UploadedFileLogView
                    .Where(t => t.DataFile_id.HasValue &&
                                t.DateUploadFileStateChange >= _startDate &&
                                t.DateUploadFileStateChange < _endDate.AddDays(1))
                    .OrderByDescending(t => t.DataFile_id)
                    .Take(_take)
                    .ToList();
            }
            return View(uploadfiles);
        }


        //// If you want to use Ajax and a jQuery grid...
        //[AcceptVerbs(HttpVerbs.Get)]
        //public JsonResult UploadFileGridData(string sidx, string sord, int page, int rows)
        //{
        //    Settings settings = ConfigManager.Load<Settings>();

        //    Generated.QP_DataLoad qpDataLoad = new Generated.QP_DataLoad(settings.QP_DataLoadConnectionString);

        //    // UploadedFileLogView
        //    var uploadfiles = qpDataLoad.UploadedFileLogView
        //        .Where(t => t.DateUploadFileStateChange >= DateTime.Now.AddDays(-1))
        //        .OrderByDescending(t => t.UploadFile_id)
        //        .Take(100);


        //    var jsonData = new
        //    {
        //        total = 1, // we'll implement later 
        //        page = page,
        //        records = 3, // implement later 

        //        rows = (
        //            from uploadfile in uploadfiles
        //            select new
        //            {
        //                i = uploadfile.UploadFile_id,
        //                cell = new string[] 
        //                    { 
        //                        uploadfile.UploadFile_id.ToString(),
        //                        uploadfile.File_Nm,
        //                        uploadfile.UploadStateParam,
        //                        uploadfile.DateUploadFileStateChange.ToString(),
        //                        uploadfile.DataFile_id.ToString()
        //                    }
        //            }).ToArray()
        //    };

        //    return Json(jsonData, JsonRequestBehavior.AllowGet);
        //}

    }
}
