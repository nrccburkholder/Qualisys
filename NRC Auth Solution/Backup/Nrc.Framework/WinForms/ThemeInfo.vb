Imports System.Windows.Forms

Namespace WinForms
    ''' -----------------------------------------------------------------------------
    ''' Project	 : NRC Class Library
    ''' Class	 : WinForms.ThemeInfo
    ''' 
    ''' -----------------------------------------------------------------------------
    ''' <summary>
    ''' Provides information about the current Windows XP theme
    ''' </summary>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[jcamp]	8/18/2005	Created
    ''' </history>
    ''' -----------------------------------------------------------------------------
    Public NotInheritable Class ThemeInfo
        'Delcare an event for when the color scheme changes
        Public Shared Event ColorSchemeChanged As EventHandler

        Shared Sub New()
            'Attach a handler to the UserPreferenceChanged event
            AddHandler Microsoft.Win32.SystemEvents.UserPreferenceChanged, AddressOf OnUserPreferenceChanged
        End Sub

        Private Sub New()
        End Sub

        Private Shared Sub OnUserPreferenceChanged(ByVal sender As Object, ByVal e As Microsoft.Win32.UserPreferenceChangedEventArgs)
            'Determine if this is a color scheme change and if so then raise the ColorSchemeChanged event
            If e.Category = Microsoft.Win32.UserPreferenceCategory.Color Then
                RaiseEvent ColorSchemeChanged(sender, e)
            End If
        End Sub

    End Class

End Namespace
