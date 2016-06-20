Public Enum DataFileStates
    FileQueued = 0
    FileLoading = 1
    AwaitingAddressClean = 2
    AddressCleaning = 3
    AwaitingValidation = 4
    Validating = 5
    AwaitingFirstApproval = 6
    AwaitingFinalApproval = 7
    AwaitingApply = 8
    Applying = 9
    Applied = 10
    Abandoned = 11
    RolledBack = 12
    DRGUpdating = 13
    DRGApplied = 14
    DuplicateCCNInSampleMonth = 25
End Enum
