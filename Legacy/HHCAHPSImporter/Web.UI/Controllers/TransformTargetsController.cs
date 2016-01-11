using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

using Generated = HHCAHPSImporter.ImportProcessor.DAL.Generated;
using HHCAHPSImporter.Web.UI.Models;

namespace HHCAHPSImporter.Web.UI.Controllers
{
    [HandleError()]
    public class TransformTargetsController : ControllerBase
    {
        #region RETRIEVE
        //
        // GET: /TransformTargets/

        public ActionResult Index(int transformId)
        {
            return View(TransformRepository.GetRepository().GetTransform(transformId));
        }

        //
        // GET: /TransformTargets/Details/5

        public ActionResult Details(int id)
        {
            return View(TransformRepository.GetRepository().GetTransformTarget(id));
        } 
        #endregion

        #region CREATE
        //
        // GET: /TransformTargets/Create/1

        public ActionResult Create(int transformId)
        {
            var v = new Generated.TransformTarget();
            //v.TransformDefinition = new System.Data.Linq.EntitySet<Generated.TransformDefinition>();
            //v.TransformDefinition.Add(new Generated.TransformDefinition { TransformId = transformId });

            return View(v);
        }

        //
        // POST: /TransformTargets/Create

        [HttpPost]
        public ActionResult Create(int transformId, Generated.TransformTarget transformTarget)
        {
            try
            {
                var db = TransformRepository.GetRepository();

                db.CreateTransformTarget(transformTarget);

                var transform = db.GetTransform(transformId);

                transform.TransformDefinition.Add(new Generated.TransformDefinition
                {
                    TransformId = transformId,
                    TransformTargetId = transformTarget.TransformTargetId,
                    CreateDate = DateTime.Now,
                    CreateUser = @"nrc\aaliabadi"
                });

                db.UpdateTransform(transform);

                return RedirectToAction("Index", new { transformId = transformId });
            }
            catch
            {
                return View(transformTarget);
            }
        } 
        #endregion

        #region UPDATE
        //
        // GET: /TransformTargets/Edit/5

        public ActionResult Edit(int id)
        {
            return this.Details(id);
        }

        //
        // POST: /TransformTargets/Edit/5

        [HttpPost]
        public ActionResult Edit(int id, Generated.TransformTarget transformTarget, FormCollection collection)
        {
            if (!ModelState.IsValid)
            {
                return View(transformTarget);
            }

            try
            {
                var db = TransformRepository.GetRepository();

                var v = db.GetTransformTarget(transformTarget.TransformTargetId);

                v.TargetName = transformTarget.TargetName;
                v.TargetTable = transformTarget.TargetTable;

                db.UpdateTransformTarget(v);

                return RedirectToAction("Index", new { transformId = v.TransformId });
            }
            catch
            {
                return View(transformTarget);
            }
        } 
        #endregion

        #region DELETE
        //
        // GET: /TransformTargets/Delete/5

        public ActionResult Delete(int id)
        {
            return this.Details(id);
        }

        //
        // POST: /TransformTargets/Delete/5

        [HttpPost]
        public ActionResult Delete(int id, FormCollection collection)
        {
            try
            {
                var db = TransformRepository.GetRepository();

                var v = db.GetTransformTarget(id);

                int transformId = v.TransformDefinition.FirstOrDefault().TransformId;

                db.DeleteTransformTarget(v);

                return RedirectToAction("Index", new { transformId = transformId } );
            }
            catch
            {
                return this.Details(id);
            }
        } 
        #endregion
    }
}
