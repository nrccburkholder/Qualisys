using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

using Generated = NRC.Picker.Depricated.OCSHHCAHPS.ImportProcessor.DAL.Generated;
using NRC.Picker.Depricated.OCSHHCAHPS.Web.UI.Models;

namespace NRC.Picker.Depricated.OCSHHCAHPS.Web.UI.Controllers
{
    [HandleError()]
    public class LibrariesController : ControllerBase
    {

        #region RETRIEVE

        //
        // GET: /Libraries/

        public ActionResult Index()
        {            
            return View(TransformRepository.GetRepository().GetTransformLibraries());
        }

        public ActionResult Details(int id)
        {
            return View(TransformRepository.GetRepository().GetTransformLibrary(id));
        }
        #endregion

        #region CREATE
        //
        // GET: /TransformMappings/Create/7

        public ActionResult Create()
        {
            return View(new Generated.TransformLibrary());
        }

        //
        // POST: /TransformMappings/Create

        [HttpPost]
        public ActionResult Create(Generated.TransformLibrary newTransformLibrary)
        {
            try
            {
                newTransformLibrary.ValidatedCode();

                TransformRepository.GetRepository().CreateTransformLibrary(newTransformLibrary);

                return RedirectToAction("Index");
            }
            catch
            {
                return View(newTransformLibrary);
            }
        }
        #endregion

        #region UPDATE
        public ActionResult Edit(int id)
        {
            return View(TransformRepository.GetRepository().GetTransformLibrary(id));
        }

        [HttpPost]
        public ActionResult Edit(int id, Generated.TransformLibrary transformLibrary)
        {
            if (!ModelState.IsValid)
            {
                return View(transformLibrary);
            }

            try
            {
                transformLibrary.ValidatedCode();

                var db = TransformRepository.GetRepository();

                var v = db.GetTransformLibrary(transformLibrary.TransformLibraryId);

                v.TransformLibraryName = transformLibrary.TransformLibraryName;
                v.Code = transformLibrary.Code;

                db.UpdateTransformLibrary(transformLibrary);

                return RedirectToAction("Index");
            }
            catch (Exception ex)
            {
                return View(transformLibrary);
            }
        }
        #endregion

        #region DELETE
        //
        // GET: /Libraries/Delete/5

        public ActionResult Delete(int id)
        {
            return this.Details(id);
        }

        ////
        //// POST: /Libraries/Delete/5

        [HttpPost]
        public ActionResult Delete(int id, FormCollection collection)
        {
            try
            {
                var db = TransformRepository.GetRepository();

                var v = db.GetTransformLibrary(id);

                db.DeleteTransformLibrary(v);

                return RedirectToAction("Index");
            }
            catch
            {
                return this.Details(id);
            }
        }
        #endregion

    }
}
