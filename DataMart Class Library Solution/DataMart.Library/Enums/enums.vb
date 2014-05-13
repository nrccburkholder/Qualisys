''' <summary>
''' Takes existing CMS/HCAHPS export definitions and creates an export file.
''' In addition to the export file, it also creates a summary, exception and TPS report. 
''' </summary>
''' <remarks></remarks>
''' 
Public Enum Mode
    Mail = 1
    Telephone = 2
    Mixed = 3
    IVR = 4
End Enum
Public Enum HCAHPSLanguages
    English = 1
    Spanish = 2
    Chinese = 3
    Russian = 4
    Vietnamese = 5
End Enum
