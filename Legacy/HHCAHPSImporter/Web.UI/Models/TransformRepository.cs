using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Security;
using System.IO;

using Generated = NRC.Picker.Depricated.OCSHHCAHPS.ImportProcessor.DAL.Generated;
using NRC.Common.Configuration;

namespace NRC.Picker.Depricated.OCSHHCAHPS.Web.UI.Models
{
    public class TransformRepository 
    {
        #region Singleton Pattern
        private TransformRepository() { }

        private Generated.QP_DataLoad dbContext = null;
        // private static TransformRepository _tr = null;
        public static TransformRepository GetRepository()
        {
            Settings settings = ConfigManager.Load<Settings>();

            var _tr = new TransformRepository()
            {
                ConnectionString = settings.QP_DataLoadConnectionString,
                dbContext = new Generated.QP_DataLoad(settings.QP_DataLoadConnectionString)
            };

            return _tr;
        }
        #endregion


        #region Properties
        public string ConnectionString { get; set; }
        #endregion


        #region RETRIEVE
        public IEnumerable<Generated.Transform> GetTransforms()
        {
            return dbContext.Transform;
        }

        public IEnumerable<Generated.TransformTarget> GetTransformTargets(int transformId)
        {
            var transformTargets = from td in dbContext.TransformDefinition
                                   join tt in dbContext.TransformTarget on td.TransformTargetId equals tt.TransformTargetId
                                   where td.TransformId.Equals(transformId)
                                   select tt;

            return transformTargets;
        }

        public IEnumerable<Generated.TransformMapping> GetTransfromMappings(int transformTargetId)
        {
            return dbContext.TransformMapping.Where(t => t.TransformTargetId.Equals(transformTargetId));
        }

        public IEnumerable<Generated.TransformImports> GetTransformImports(int transformId)
        {
            var v = dbContext.Transform.Where(t => t.TransformId.Equals(transformId)).FirstOrDefault();
            if (v != null)
            {
                return dbContext.Transform.Where(t => t.TransformId.Equals(transformId)).FirstOrDefault().TransformImports;
            }

            return new List<Generated.TransformImports>();
        }

        public IEnumerable<Generated.TransformLibrary> GetTransformLibraries()
        {
            return dbContext.TransformLibrary;
        }

        public Generated.Transform GetTransform(int transformId)
        {
            Generated.Transform item = dbContext.Transform.Where(t => t.TransformId.Equals(transformId)).FirstOrDefault();
            item.TransformImports.Load();
            item.TransformDefinition.Load();
            return item;
        }

        public Generated.TransformMapping GetTransformMapping(int transformMappingId)
        {
            Generated.TransformMapping item = dbContext.TransformMapping.Where(t => t.TransformMappingId.Equals(transformMappingId)).FirstOrDefault();
            return item;
        }

        public Generated.TransformLibrary GetTransformLibrary(int transformLibraryId)
        {
            Generated.TransformLibrary item = dbContext.TransformLibrary.Where(t => t.TransformLibraryId.Equals(transformLibraryId)).FirstOrDefault();
            item.TransformImports.Load();
            return item;
        }

        public Generated.TransformTarget GetTransformTarget(int transformTargetId)
        {
            Generated.TransformTarget item = dbContext.TransformTarget.Where(t => t.TransformTargetId.Equals(transformTargetId)).FirstOrDefault();

            item.TransformDefinition.Load();
            item.TransformMapping.Load();

            return item;
        }

        public IEnumerable<Generated.ClientDetail> GetClients()
        {
            return dbContext.ClientDetail;
        }

        public Generated.ClientDetail GetClientDetail(int clientId, int studyId, int surveyId)
        {
            return dbContext.ClientDetail
                        .Where(t =>
                            t.Client_id.Equals(clientId) &&
                            t.Study_id.Equals(studyId) &&
                            t.Survey_id.Equals(surveyId))
                        .FirstOrDefault();
        }

        public Models.ClientDetailInfo GetClientDetailInfo(int clientId, int studyId, int surveyId)
        {
            Models.ClientDetailInfo v = new Models.ClientDetailInfo();

            v.ClientDetail = GetClientDetail(clientId, studyId, surveyId);

            if (!string.IsNullOrEmpty(v.ClientDetail.Languages))
            {
                v.Languages = v.ClientDetail.Languages.Replace(" ", "").Split(new char[] { ',' }).Where(t => t.Length.Equals(1)).ToList();
            }

            var associatedTransform =
            dbContext.ClientTransform.Where(t =>
                t.Client_id.Equals(clientId) &&
                t.Study_id.Equals(studyId) &&
                t.Survey_id.Equals(surveyId)).FirstOrDefault();

            if (associatedTransform != null)
            {
                v.Transform = associatedTransform.Transform;
                v.Transform.TransformDefinition.Load();
            }

            return v;
        }

        public Models.ClientEditInfo GetClientEditInfo(int clientId, int studyId, int surveyId)
        {
            Models.ClientEditInfo cei = new ClientEditInfo();

            cei.ClientDetailInfo = GetClientDetailInfo(clientId, studyId, surveyId);

            cei.AvailableTransforms = dbContext.Transform.ToList();

            return cei;
        }

        public Models.ClientDetailInfo GetClientTransformMappingsInfo(int clientId, int studyId, int surveyId, int transformId, int transformTargetId)
        {
            Models.ClientDetailInfo clientDetailInfo = GetClientDetailInfo(clientId, studyId, surveyId);

            clientDetailInfo.TransformMappings = dbContext.GetClientTransforms(clientId, studyId, surveyId).Where(t => t.TransformId.Equals(transformId) && t.TransformTargetId.Equals(transformTargetId)).ToList();

            return clientDetailInfo;
        }

        public Generated.TransformClientMapping GetTransformClientMapping(int clientId, int studyId, int surveyId, int transformId, int transformTargetId, int transformMappingId)
        {
            return dbContext.TransformClientMapping.Where(t =>
                t.Client_id.Equals(clientId) &&
                t.Study_id.Equals(studyId) &&
                t.Survey_id.Equals(surveyId) &&
                t.TransformMappingId.Equals(transformMappingId)).FirstOrDefault();
        }

        public List<Generated.ClientTransform> GetClientTransfroms(int clientId, int studyId, int surveyId)
        {
            var v = dbContext.ClientTransform.Where(
                t => t.Client_id == clientId &&
                    t.Study_id == studyId &&
                    t.Survey_id == surveyId)
                    .ToList();

            return v;
        }

        public Generated.ClientTransform GetClientTransfrom(int clientId, int studyId, int surveyId, int transformId)
        {
            var v = dbContext.ClientTransform.Where(
                t => t.Client_id == clientId &&
                    t.Study_id == studyId &&
                    t.Survey_id == surveyId &&
                    t.TransformId == transformId)
                    .FirstOrDefault();

            return v;
        }

        #endregion


        #region CREATE
        public void CreateTransformLibrary(Generated.TransformLibrary transformLibrary)
        {
            transformLibrary.CreateDate = DateTime.Now;
            transformLibrary.CreateUser = HttpContext.Current.User.Identity.Name;

            dbContext.TransformLibrary.InsertOnSubmit(transformLibrary);
            dbContext.SubmitChanges();
        }

        public void AssociateClientWithTransform(int clientId, int studyId, int surveyId, int transformId)
        {
            Generated.ClientTransform clientTransform = new Generated.ClientTransform
            {
                Client_id = clientId,
                Survey_id = surveyId,
                Study_id = studyId,
                TransformId = transformId,
                CreateDate = DateTime.Now,
                CreateUser = HttpContext.Current.User.Identity.Name
            };

            dbContext.ClientTransform.InsertOnSubmit(clientTransform);
            dbContext.SubmitChanges();
        }


        public void CreateTransform(Generated.Transform transform)
        {
            transform.CreateDate = DateTime.Now;
            transform.CreateUser = HttpContext.Current.User.Identity.Name;

            dbContext.Transform.InsertOnSubmit(transform);
            dbContext.SubmitChanges();
        }

        public void CreateTransformTarget(Generated.TransformTarget transformTarget)
        {
            transformTarget.CreateDate = DateTime.Now;
            transformTarget.CreateUser = HttpContext.Current.User.Identity.Name;

            dbContext.TransformTarget.InsertOnSubmit(transformTarget);
            dbContext.SubmitChanges();
        }

        public void CreateTransformMapping(Generated.TransformMapping transformMapping)
        {
            transformMapping.CreateDate = DateTime.Now;
            transformMapping.CreateUser = HttpContext.Current.User.Identity.Name;
            transformMapping.Transform = transformMapping.Transform.Trim();

            dbContext.TransformMapping.InsertOnSubmit(transformMapping);
            dbContext.SubmitChanges();
        }

        public void CreateTranformClientMapping(Generated.TransformClientMapping transformClientMapping)
        {
            transformClientMapping.CreateDate = DateTime.Now;
            transformClientMapping.CreateUser = HttpContext.Current.User.Identity.Name;
            dbContext.TransformClientMapping.InsertOnSubmit(transformClientMapping);
            dbContext.SubmitChanges();
        }
        #endregion


        #region UPDATE
        public void UpdateClient(Generated.ClientDetail client)
        {
            dbContext.SubmitChanges();
        }

        public void UpdateTransform(Generated.Transform transform)
        {
            transform.UpdateDate = DateTime.Now;
            transform.UpdateUser = HttpContext.Current.User.Identity.Name;
            dbContext.SubmitChanges();
        }

        public void UpdateTransformTarget(Generated.TransformTarget transformTarget)
        {
            transformTarget.UpdateDate = DateTime.Now;
            transformTarget.UpdateUser = HttpContext.Current.User.Identity.Name;
            dbContext.SubmitChanges();
        }

        public void UpdateTransformLibrary(Generated.TransformLibrary transformLibrary)
        {
            transformLibrary.UpdateDate = DateTime.Now;
            transformLibrary.UpdateUser = HttpContext.Current.User.Identity.Name;
            dbContext.SubmitChanges();
        }

        public void UpdateTransformMapping(Generated.TransformMapping transformMapping)
        {
            transformMapping.UpdateDate = DateTime.Now;
            transformMapping.UpdateUser = HttpContext.Current.User.Identity.Name;

            transformMapping.Transform = transformMapping.Transform;

            dbContext.SubmitChanges();
        }

        public void UpdateTranformClientMapping(Generated.TransformClientMapping transformClientMapping)
        {
            transformClientMapping.UpdateDate = DateTime.Now;
            transformClientMapping.UpdateUser = HttpContext.Current.User.Identity.Name;
            dbContext.SubmitChanges();
        }

        #endregion


        #region DELETE
        public void DeleteTransform(Generated.Transform transform)
        {
            // TODO: Archive data
            
            // TODO: Cascade the delete
            dbContext.TransformDefinition.DeleteAllOnSubmit(transform.TransformDefinition);
            dbContext.TransformImports.DeleteAllOnSubmit(transform.TransformImports);
            dbContext.Transform.DeleteOnSubmit(transform);

            dbContext.SubmitChanges();
        }

        public void DisassociateClientFromTransform(int clientId, int studyId, int surveyId, int transformId)
        {
            var v = this.GetClientTransfrom(clientId, studyId, surveyId, transformId);

            if (v != null)
            {
                dbContext.ClientTransform.DeleteOnSubmit(v);
            }

            dbContext.SubmitChanges();
        }

        public void DeleteTransformTarget(Generated.TransformTarget transformTarget)
        {
            // TODO: Archive data

            // Cascade the delete
            dbContext.TransformMapping.DeleteAllOnSubmit(dbContext.TransformMapping.Where(t => t.TransformTargetId.Equals(transformTarget.TransformTargetId)));
            dbContext.TransformDefinition.DeleteAllOnSubmit(dbContext.TransformDefinition.Where(t => t.TransformTargetId.Equals(transformTarget.TransformTargetId)));
            dbContext.TransformTarget.DeleteOnSubmit(transformTarget);

            dbContext.SubmitChanges();
        }

        public void DeleteTransformLibrary(Generated.TransformLibrary transformLibrary)
        {
            // TODO: Archive data

            // TODO: Cascade the delete
            dbContext.TransformLibrary.DeleteOnSubmit(transformLibrary);

            dbContext.SubmitChanges();
        }

        public void DeleteTransformMapping(Generated.TransformMapping transformMapping)
        {
            // TODO: Archive data
            dbContext.TransformMapping.DeleteOnSubmit(transformMapping);

            dbContext.SubmitChanges();
        }

        public void DeleteTransformImport(Generated.TransformImports import)
        {
            dbContext.TransformImports.DeleteOnSubmit(import);
            dbContext.SubmitChanges();
        }

        public void DeleteTransformClientMapping(Generated.TransformClientMapping transformClientMapping)
        {
            dbContext.TransformClientMapping.DeleteOnSubmit(transformClientMapping);
            dbContext.SubmitChanges();
        }
        #endregion

    }

}