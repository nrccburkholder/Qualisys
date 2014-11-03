''' <summary>
''' Enumerates the possible types of Qualisys Metafields that can be
''' used to define reporting periods
''' </summary>
Public Enum CutoffFieldType
    ''' <summary>Categorizes data by the date on which the sample was created</summary>
    SampleCreate = 0

    ''' <summary>Categorizes data by the date on which the survey was returned</summary>
    ReturnDate = 1

    ''' <summary>Categorizes data by a date metafield in the study specific tables</summary>
    CustomMetafield = 2

    ''' <summary>Date field is not applicable</summary>
    NotApplicable = 3

End Enum

