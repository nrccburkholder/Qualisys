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
    public class TransformsController : ControllerBase
    {
        #region RETRIEVE
        //
        // GET: /Transforms/

        public ActionResult Index()
        {
           return View(TransformRepository.GetRepository().GetTransforms());
        }

        public ActionResult Details(int id)
        {
            return View(TransformRepository.GetRepository().GetTransform(id));
        }
        #endregion

        #region CREATE
        public ActionResult Create(FormCollection collection)
        {
            if (collection.Keys.Count == 0)
            {
                return View(new Generated.Transform());
            }

            Generated.Transform t = new Generated.Transform
                {
                    TransformName = collection["TransformName"]
                };

            List<int> selectedLibraryIds = new List<int>(); ;

            if (collection["importLibraries"] != null)
            {
                selectedLibraryIds = Array
                    .ConvertAll(collection["importLibraries"]
                                .Split(','), n => Convert.ToInt32(n))
                    .ToList<int>();
            }

            foreach (var v in selectedLibraryIds)
            {
                t.TransformImports.Add(new Generated.TransformImports
                {
                    TransformId = t.TransformId,
                    TransformLibraryId = v,
                    CreateDate = DateTime.Now,
                    CreateUser = @"nrc\aaliabadi"
                });
            }

            TransformRepository.GetRepository().CreateTransform(t);

            return RedirectToAction("Index");
        }
        #endregion

        #region UPDATE
        public ActionResult Edit(int id)
        {
            return View(TransformRepository.GetRepository().GetTransform(id));
        }

        [HttpPost]
        public ActionResult Edit(int id, Generated.Transform updatedTransform, FormCollection collection)
        {
            if (!ModelState.IsValid)
            {
                return View(updatedTransform);
            }

            try
            {
                var db = TransformRepository.GetRepository();

                var transform = db.GetTransform(id);

                List<int> selectedLibraryIds = new List<int>();;

                if (collection["importLibraries"] != null)
                {
                    selectedLibraryIds = Array
                        .ConvertAll(collection["importLibraries"].ToString().Split(','), n => Convert.ToInt32(n))
                        .ToList<int>();
                }

                transform.TransformName = collection["TransformName"].ToString();

                List<Generated.TransformImports> removeImports = new List<Generated.TransformImports>();
                List<Generated.TransformImports> addedImports = new List<Generated.TransformImports>();

                foreach (var import in transform.TransformImports)
                {
                    if (!selectedLibraryIds.Contains(import.TransformLibraryId))
                    {
                        removeImports.Add(import);
                    }
                }

                foreach (var v in selectedLibraryIds)
                {
                    if (transform.TransformImports.Where(t => t.TransformLibraryId.Equals(v)).FirstOrDefault() == null)
                    {
                        transform.TransformImports.Add(new Generated.TransformImports
                        {
                            TransformLibraryId = v,
                            CreateDate = DateTime.Now,
                            CreateUser = @"nrc\aaliabadi"
                        });
                    }
                }

                foreach( var v in removeImports )
                {
                    db.DeleteTransformImport(v);
                }

                db.UpdateTransform(transform);

                return RedirectToAction("Index");
            }
            catch
            {
                return View(TransformRepository.GetRepository().GetTransform(id));
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

                var t = db.GetTransform(id);

                db.DeleteTransform(t);

                return RedirectToAction("Index");
            }
            catch
            {
                return View();
            }
        } 
        #endregion

    }
}
