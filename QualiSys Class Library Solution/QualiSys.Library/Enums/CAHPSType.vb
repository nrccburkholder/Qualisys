''' <summary>
''' Enumerates the Qualisys supported CAHPS types
''' </summary>
''' <remarks></remarks>
Public Enum CAHPSType
    'FORMERTODO: remove completely (THESE ARE BEING LEFT IN HERE FOR LEGACY PURPOSES--NO NEW ADDITIONS ARE TO BE MADE HERE)
    None = 0
    HCAHPS = 1
    HHCAHPS = 2
    CHART = 3
    MNCM = 4
    ACOCAHPS = 5
    CAHPS = 6 'This is the generic CAHPS intended to work for any CAHPS going forward without code changes
    'PCMH = 6
    'MDPDPCAHPS = 7
End Enum
