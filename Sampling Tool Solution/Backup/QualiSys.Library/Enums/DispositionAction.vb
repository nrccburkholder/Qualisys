''' -----------------------------------------------------------------------------
''' <summary>
''' Represents the various actions that can be taken when a disposition is selected.
''' </summary>
''' <remarks>
''' </remarks>
''' <history>
''' 	[jcamp]	10/4/2005	Created
''' </history>
''' -----------------------------------------------------------------------------
Public Enum DispositionAction
    None = 0
    Tocl = 1
    ChangeOfAddress = 2
    RegenerateNewLang = 3
    Regenerate = 4
    CancelMailings = 5
    ContactTeam = 6
End Enum
