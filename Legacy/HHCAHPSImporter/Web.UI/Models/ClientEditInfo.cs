using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

using Generated = NRC.Picker.Depricated.OCSHHCAHPS.ImportProcessor.DAL.Generated;

namespace NRC.Picker.Depricated.OCSHHCAHPS.Web.UI.Models
{
    public class ClientEditInfo
    {
        public ClientDetailInfo ClientDetailInfo { get; set; }
        public List<Generated.Transform> AvailableTransforms { get; set; }

        public int ClientId { get { return this.ClientDetailInfo.Client_id; } }
        public int StudyId { get { return this.ClientDetailInfo.Study_id; } }
        public int SurveyId { get { return this.ClientDetailInfo.Survey_id; } } 

        public int CurrentTransformId
        {
            get
            {
                if (this.ClientDetailInfo.Transform != null)
                {
                    return this.ClientDetailInfo.Transform.TransformId;
                }
                return -1;
            }
        }
    }
}