using System;

namespace NRC.Picker.SamplingService.Store.Models
{
    public class StoreCorruptException : Exception { }

    public class CorruptDatasetException : Exception { }

    public class ProcessingAbortedException : Exception { }

    public class HCAHPSGapException : Exception { }

    public class NoValidSurveysException : Exception { }

    public class NoValidPeriodsException : Exception { }

    public class CAHPSRecalculationFailedException : Exception { }

    public class CAHPSCCNLockedException : Exception { }
}
