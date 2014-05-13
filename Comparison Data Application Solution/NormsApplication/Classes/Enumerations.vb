Option Strict On

Public Enum TaskType
    NewNorm = 1
    UpdateNorm = 2
End Enum

Public Enum WeightingType
    NoWeighting = 0
    CanadaSurveyWeighting = 1
End Enum

Public Enum NormType
    StandardNorm = 1
    TopNPercent = 2
    BottomNPercent = 3
    IndividualPercentile = 4
    StandardPercentile = 5
    BestNorm = 6
    WorstNorm = 7
End Enum

Public Enum ComponentSize
    ScrollBar = 22
    MinColumnSize = 50
End Enum
