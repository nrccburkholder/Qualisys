Public Enum TransferErrorCodes
    IgnoreQstnCore = -1
    None = 0
    Disposition = 1
    ErrorSavingToQualiSys = 2
    Scale = 3
    MissingQstnCore = 4
    ExtraQstnCore = 5
    DateValidation = 6
    CommentLengthExceeded = 7
    HandEntryLengthExceeded = 8
    ResponseTypeInvalid = 9
    SurveyIdMismatch = 10
    HandEntryInvalidInteger = 11
    HandEntryInvalidDate = 12
    HandEntryInvalidItem = 13
    HandEntryInvalidLine = 14
    NoDispositionsProvided = 15
    MoreThanOneFinalDispostion = 16
    DispositionMustHaveResults = 17
    PopMappingInvalidInteger = 18
    PopMappingInvalidDate = 19
    PopMappingLengthExceeded = 20
End Enum
