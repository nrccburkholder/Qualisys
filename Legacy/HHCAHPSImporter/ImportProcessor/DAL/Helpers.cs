using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace HHCAHPSImporter.ImportProcessor.DAL
{
    #region Enums
    public enum DataFileState
    {
        /// <summary>
        /// 0
        /// </summary>
        FileQueued = 0,

        /// <summary>
        /// 1
        /// </summary>
        FileLoading = 1,

        /// <summary>
        /// 2
        /// </summary>
        AwaitingAddressClean = 2,

        /// <summary>
        /// 3
        /// </summary>
        AddressCleaning = 3,

        /// <summary>
        /// 4
        /// </summary>
        AwaitingValidation = 4,

        /// <summary>
        /// 5
        /// </summary>
        Validating = 5,

        /// <summary>
        /// 6
        /// </summary>
        AwaitingFirstAproval = 6,

        /// <summary>
        /// 7
        /// </summary>
        AwaitingFinalApproval = 7,

        /// <summary>
        /// 8
        /// </summary>
        AwaitingApply = 8,

        /// <summary>
        /// 9
        /// </summary>
        Applying = 9,

        /// <summary>
        /// 10
        /// </summary>
        Applied = 10,

        /// <summary>
        /// 11
        /// </summary>
        Abandoned = 11,

        /// <summary>
        /// 12
        /// </summary>
        RolledBack = 12,

        /// <summary>
        /// 13
        /// </summary>
        DRGUpdating = 13,

        /// <summary>
        /// 14
        /// </summary>
        DRGApplied = 14,

        /// <summary>
        /// 15
        /// </summary>
        LoadToLiveAwaitingDupCheck = 15,

        /// <summary>
        /// 16
        /// </summary>
        LoadToLiveCheckingDups = 16,

        /// <summary>
        /// 17
        /// </summary>
        LoadToLiveAwaitingUpdate = 17,

        /// <summary>
        /// 18
        /// </summary>
        LoadToLiveUpdating = 18,

        /// <summary>
        /// 19
        /// </summary>
        LoadToLiveApplied = 19,

        /// <summary>
        /// 20
        /// </summary>
        AwaitingHHCAHPSUpdate = 20,

        /// <summary>
        /// 21
        /// </summary>
        HHCAHPSUpdating = 21,

        /// <summary>
        /// 22
        /// </summary>
        HHCAHPSUpdateApplied = 22,

        /// <summary>
        /// 23
        /// </summary>
        LoadToLiveAwaitingDupApproval = 23,

        /// <summary>
        /// 24
        /// </summary>
        HHCAHPSUpdateAbandoned = 24
    }

    public enum UploadState
    {
        /// <summary>
        /// 1
        /// </summary>
        UploadQueued = 1,

        /// <summary>
        /// 2
        /// </summary>
        UploadAwaitingPreProcessing = 2,

        /// <summary>
        /// 3
        /// </summary>
        UploadPreProcessing = 3,

        /// <summary>
        /// 4
        /// </summary>
        Uploaded = 4,

        /// <summary>
        /// 5
        /// </summary>
        UploadedAbandoned = 5
    }

    public enum UploadAction
    {
        /// <summary>
        /// 1
        /// </summary>
        ProductionFile = 1,

        /// <summary>
        /// 2
        /// </summary>
        DRGUpdateFile = 2,

        /// <summary>
        /// 3
        /// </summary>
        NonDRGDataUpdateFile = 3,

        /// <summary>
        /// 4
        /// </summary>
        SetupFiles = 4,

        /// <summary>
        /// 5
        /// </summary>
        MaintenanceFiles = 5,

        /// <summary>
        /// 6
        /// </summary>
        HCAHPSExclusionCounts = 6
    }
    #endregion
}
