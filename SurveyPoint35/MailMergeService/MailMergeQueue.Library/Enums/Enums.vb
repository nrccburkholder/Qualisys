Public Enum PaperConfigTypes
    NoPaper = -1
    Legal = 1
    Letter = 2
    Tabloid = 4
    Letter1Legal = 14
    Letter1Tabloid = 15
    Letter2Tabloids = 17
    Letter3Tabloids = 18
    Postcard = 23
    TwoLetter = 30
    TwoTabloid = 31
    TwoLegal = 32
    FourTabloid = 33
    Letter16Tabloid = 34
    Letterhead1Legal = 35
    Letter2Legal = 36
    ThreeTabloid = 37
    Letterhead3Tabloid = 38
    Letterhead2Tabloid = 39
    Letterhead = 40
    Letter5Tabloid = 41
    FourTabloid2 = 42
    FiveLetter = 43
    Letterhead4Tabloid = 44
    Letterhead1Tabloid = 45
    Letterhead1Letter = 46
    Letter6Tabloid = 47
    ThreeLetter = 48
End Enum

Public Enum FileTypes
    OrginalFile = 1
    BaseMergeDataFile = 2
    TemplateFile = 3
    PrintFile = 4
    DocFile = 5
End Enum

Public Enum MessageTypes
    Unknown = 0
    Informational = 1
    Warning = 2
    [Error] = 3
    Print = 4
End Enum

Public Enum MergeStatuses
    Unknown = 1
    Pending = 2
    Processing = 3
    Completed = 4
    Errored = 5
    PreMerge = 6
End Enum

Public Enum ValidationTypes
    Unknown = 0
    File = 1
    Data = 2
    Template = 3
    Unhandled = 4
End Enum