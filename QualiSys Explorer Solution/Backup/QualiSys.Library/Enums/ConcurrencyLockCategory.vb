''' <summary>
''' Represents a category of entities that can be locked with the <see cref="ConcurrencyManager">ConcurrencyManager</see>.
''' </summary>
Public Enum ConcurrencyLockCategory
    None = 0
    Client = 1
    Study = 2
    Survey = 3
    'SurveyBusinessRules = 4
    'SurveyFormLayout = 5
    'SurveyMethodology = 6
    'SurveyPersonalization = 7
    'SurveySamplePeriods = 8
    'SurveySamplePlan = 9
    'SurveySampleUnitMappings = 10
    'SurveyProperties = 11
    'SurveyValidation = 12
    StudyDataStructure = 13
    StudyProperties = 14
    ClientGroup = 15
End Enum
