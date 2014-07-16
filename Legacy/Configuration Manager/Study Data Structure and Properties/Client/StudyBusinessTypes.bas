Attribute VB_Name = "StudyBusinessTypes"
Option Explicit
' 9/9/1999 DV
' Added variable UsePhoneChecking as boolean to this structure.
' 06-02-2003 SH - Added CountryID
' 05-09-2005 SH Added PII and AllowUS
Public Type StudyProps
    ID As Long
    name As String * 10
    Description As String * 255
    ClientID As Long
    CreationDate As Date
    CloseDate As Date
    AccountingCode As String * 10
    BBSUserName As String * 8
    BBSPassword As String * 8
    ArchiveMonths As Long
    UseAddressCleaning As Boolean
    UsePhoneChecking As Boolean
    UseProperCase As Boolean
    CountryID As Long ' 06-02-2003 SH Added
    IsStudyOnGoing As Boolean
    NumberOfReports As Long
    ConfidenceInterval As Long
    ErrorMargin As Long
    CutOffTarget As Long
    ObjectiveSignOffDate As Date
    BudgetAmount As Currency
    TotalSpent As Currency
    ActionPlanBelowQuata As String * 255
    AccountDirectorEmployeeID As Long
    ContractStartDate As Date
    ContractEndDate As Date
    IsNew As Boolean
    IsDeleted As Boolean
    IsDirty As Boolean
End Type

Public Type StudyData
    Buffer As String * 628
End Type

Public Type StudyComparisonProps
    ID As Long
    StudyID As Long
    State As Long
    ComparisonType As Long
    MarketGuideMSA As Long
    MarketGuidePlanType As Long
    IsNew As Boolean
    IsDeleted As Boolean
    IsDirty As Boolean
End Type

Public Type StudyComparisonData
    Buffer As String * 30
End Type

Public Type StudyDeliveryProps
    ID As Long
    StudyID As Long
    DeliveryDate As Date
    Description As String * 80
    ContactID As Long
    DateWorked As Date
    HoursWorked As Long
    IsBillable As Boolean
    IsClientRequest As Boolean
    IsCorrection As Boolean
    IsNew As Boolean
    IsDeleted As Boolean
    IsDirty As Boolean
End Type

Public Type StudyDeliveryData
    Buffer As String * 124
End Type

Public Type StudyReportProps
    ID As Long
    StudyID As Long
    ReportType As Long
    Description As String * 80
    IsNew As Boolean
    IsDeleted As Boolean
    IsDirty As Boolean
End Type

Public Type StudyReportData
    Buffer As String * 98
End Type

Public Type StudyEmployeeProps
    StudyID As Long
    EmployeeID As Long
    IsNew As Boolean
    IsDeleted As Boolean
    IsDirty As Boolean
End Type

Public Type StudyEmployeeData
    Buffer As String * 14
End Type

Public Type MetaTableProps
    StudyID As Long
    ID As Long
    name As String * 13
    Description As String * 80
    UsesAddress As Boolean
    IsNew As Boolean
    IsDeleted As Boolean
    IsDirty As Boolean
End Type

Public Type MetaTableData
    Buffer As String * 109
End Type

Public Type MetaFieldProps
    TableID As Long
    ID As Long
    IsKeyField As Boolean
    IsUserField As Boolean
    IsMatchField As Boolean
    lookupTableID As Long
    lookupFieldID As Long
    LookupType As String * 1
    IsPosted As Boolean
    IsNew As Boolean
    IsDeleted As Boolean
    IsDirty As Boolean
    IsPII As Boolean     ' 05-09-2005 SH Added
    IsAllowUS As Boolean ' 05-09-2005 SH Added
End Type

Public Type MetaFieldData
    Buffer As String * 31
End Type

Public Type MetaFieldListProps
    ID As Long
    name As String * 16
    ShortName As String * 8
    Description As String * 80
    DataType As String * 1
    fieldLength As Long
    EditMask As String * 20
    SpecialCode As Long
    GroupID As Long
    GroupName As String * 20
    PII As Boolean     ' 05-10-2005 SH Added
End Type

Public Type MetaFieldListData
    Buffer As String * 161
End Type

Public Type RelationProps
    masterTableID As Long
    masterFieldID As Long
    lookupTableID As Long
    lookupFieldID As Long
    currentTableID As Long
End Type

Public Type RelationData
    Buffer As String * 20
End Type

Public Type TextListProps
    Key As String * 30
    Item As String * 255
End Type

Public Type TextListData
    Buffer As String * 285
End Type

