using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

using Generated = HHCAHPSImporter.ImportProcessor.DAL.Generated;
using HHCAHPSImporter.Web.UI.Models;
using System.Xml.Linq;

namespace HHCAHPSImporter.Web.UI.Controllers
{
    [HandleError()]
    public class TransformMappingsController : ControllerBase
    {
        #region RETRIEVE
        //
        // GET: /TransformMappings/

        public ActionResult Index(int transformTargetId)
        {
            var v = TransformRepository.GetRepository().GetTransformTarget(transformTargetId);
            return View(v);
        }

        //
        // GET: /TransformMappings/Details/5

        public ActionResult Details(int id)
        {
            return View(TransformRepository.GetRepository().GetTransformMapping(id));
        } 
        #endregion

        #region CREATE
        //
        // GET: /TransformMappings/Create/7

        public ActionResult Create(int transformTargetId)
        {
            Generated.TransformMapping tm = new Generated.TransformMapping();
            tm.TransformTargetId = transformTargetId;

            return View(tm);
        }

        //
        // POST: /TransformMappings/Create

        [HttpPost]
        public ActionResult Create(int transformTargetId, Generated.TransformMapping newTransformMapping)
        {
            ViewData["ValidationError"] = string.Empty;

            if (!ModelState.IsValid)
            {
                return View(newTransformMapping);
            }

            try
            {
                var db = TransformRepository.GetRepository();

                var transformTarget = db.GetTransformTarget(newTransformMapping.TransformTargetId);

                Utils.ValidateTransformMapping(newTransformMapping);

                newTransformMapping.CreateDate = DateTime.Now;
                newTransformMapping.CreateUser = @"nrc\aaliabadi";

                transformTarget.TransformMapping.Add(newTransformMapping);

                db.UpdateTransformTarget(transformTarget);

                return RedirectToAction("Index", new { transformTargetId = newTransformMapping.TransformTargetId });
            }
            catch( Exception e )
            {
                ViewData["ValidationError"] = e.Message;
                return View(newTransformMapping);
            }
        } 
        #endregion

        #region UPDATE
        //
        // GET: /TransformMappings/Edit/5

        public ActionResult Edit(int id)
        {
            return this.Details(id);
        }

        //
        // POST: /TransformMappings/Edit/5

        [HttpPost]
        public ActionResult Edit(int id, Generated.TransformMapping transformMapping)
        {
            ViewData["ValidationError"] = string.Empty;

            if (!ModelState.IsValid)
            {
                var t = TransformRepository.GetRepository().GetTransformMapping(id);
                t.Transform = transformMapping.Transform;
                t.SourceFieldName = transformMapping.SourceFieldName;
                return View(t);
            }

            try
            {
                Utils.ValidateTransformMapping(transformMapping);

                var db = TransformRepository.GetRepository();
                var v = db.GetTransformMapping(transformMapping.TransformMappingId);

                if (v.TransformTargetId.Equals(transformMapping.TransformTargetId))
                {

                    v.Transform = transformMapping.Transform;
                    v.TargetFieldname = transformMapping.TargetFieldname;
                    v.SourceFieldName = transformMapping.SourceFieldName;

                    db.UpdateTransformMapping(v);

                    return RedirectToAction("Index", new { transformTargetId = transformMapping.TransformTargetId });
                }

                throw new Exception("TransformTargetId did not match");
            }
            catch (Exception ex)
            {
                ViewData["ValidationError"] = ex.Message;

                var t = TransformRepository.GetRepository().GetTransformMapping(id);
                t.Transform = transformMapping.Transform;
                t.SourceFieldName = transformMapping.SourceFieldName;
                return View(t);
            }
        } 
        #endregion

        #region DELETE
        //
        // GET: /TransformMappings/Delete/5
 
        public ActionResult Delete(int id)
        {
            return this.Details(id);
        }

        ////
        //// POST: /TransformMappings/Delete/5

        [HttpPost]
        public ActionResult Delete(int id, FormCollection collection)
        {
            try
            {
                var db = TransformRepository.GetRepository();

                var v = db.GetTransformMapping(id);

                int transformTargetId = v.TransformTargetId;

                db.DeleteTransformMapping(v);

                return RedirectToAction("Index", new { transformTargetId = transformTargetId });
            }
            catch
            {
                return this.Details(id);
            }
        }
        #endregion

    }
}
