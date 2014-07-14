Attribute VB_Name = "GlobalFormConstants"
'-----------------------------------------------------------------
' Copyright © National Research Corporation
'
' Required References:
'       Microsoft ActiveX Data Objects 2.5 Library
'       OLE Automation
'       QualiSysFunctions
'       GetEmpId
'       DBTagFields
'       StudyDataPROC
'       ValidateSurvey
'       Audit
'
' Revisions:
'       Date        By  Description
'       09-27-2002  FG  - Merged GetEmpIdPROC with GetEmpId.
'                       - Merged ValidateSurveyPROC with
'                         ValidateSurveyClient and called it
'                         ValidateSurvey.
'       09-28-2002  SH  - Renamed QualProFunctions to
'                         QualiSysFunctions.
'                       - Renamed StudyDataMTS to StudyDataPROC.
'                       - Removed DBConnection.
'       10-03-2002  SH  - Recompiled with VB6.0 and moved DLL to
'                         \components\QualiSysDLLs\.
'       05-05-2005  SH  - Added PII and AllowUS on Properties Form.
'       05-11-2005  SH  - Removed Country drop down box from
'                         Study Properties Form.
'       08-09-2005  SH  - AllowUS is set to True as a default for
'                         Non-PII fields and False and disabled if
'                         it's PII field.
'       01-17-2006  DC  - Removed all code that displays the status
'                         dialog because it crashes when called from
'                         a .NET application
'       03-12-2006  SH  - Removed Client list box in frmNewStudy
'                         since the client list is displayed using
'                         the tree in .NET application.
'                         Also modified StudyCreate module to pass
'                         the client ID as well as Employee ID.
'       03-24-2006  SH  - Removed Study type from frmStudyProperties
'                         and set the #month archived to 6 months.
'       04-04-2006  SH  - Modified the frmFields so that the
'                         selected fields will contain unique
'                         fields from the master list.
'-----------------------------------------------------------------
Public G_Study As Study
Public G_StudyID As Long
Public G_SurveyID As Long
Public G_CountryID As Long

Public Const MAX_INTEGER_VALUE = 32767
