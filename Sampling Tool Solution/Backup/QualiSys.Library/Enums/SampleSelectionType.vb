''' <summary>
''' Enumerates the Qualisys supported sampleunit selection types sampleunits
''' </summary>
''' <remarks>The order of these is critical.  They must be ordered based 
''' on how the order they should be sampled in.
''' </remarks>
''' 


Public Enum SampleSelectionType
    None = 0
    NonExclusive = 1
    Exclusive = 2
    MinorModule = 3
End Enum