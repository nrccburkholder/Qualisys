Namespace Navigation
    <Flags()> _
       Public Enum InitialPopulationDepth
        None = 0
        Client = 1
        Study = 2 Or Client
        Survey = 4 Or Study
        DataFile = 5 Or Survey
    End Enum
End Namespace
