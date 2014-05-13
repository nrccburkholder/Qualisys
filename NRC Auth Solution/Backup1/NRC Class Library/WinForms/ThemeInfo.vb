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
    Public Class ThemeInfo

        Public Enum XPTheme
            Windows_Classic
            Luna_Homestead
            Luna_NormalColor
            Luna_Metallic
            Unknown
        End Enum

        'Win32 API Call to get the theme name
        Declare Unicode Function GetCurrentThemeName Lib "uxtheme" (ByVal stringThemeName As System.Text.StringBuilder, ByVal lengthThemeName As Integer, ByVal stringColorName As System.Text.StringBuilder, ByVal lengthColorName As Integer, ByVal stringSizeName As System.Text.StringBuilder, ByVal lengthSizeName As Integer) As Int32

        'Delcare an event for when the color scheme changes
        Public Delegate Sub ColorSchemeChangedEventHandler(ByVal sender As Object, ByVal e As EventArgs)
        Public Shared Event ColorSchemeChanged As ColorSchemeChangedEventHandler

        Shared Sub New()
            'Attach a handler to the UserPreferenceChanged event
            AddHandler Microsoft.Win32.SystemEvents.UserPreferenceChanged, AddressOf OnUserPreferenceChanged
        End Sub

#Region " Public Shared Properties "
        ''' -----------------------------------------------------------------------------
        ''' <summary>
        ''' Determines if the machine executing the code can support Windows XP Themes
        ''' </summary>
        ''' <remarks>
        ''' </remarks>
        ''' <history>
        ''' 	[jcamp]	8/18/2005	Created
        ''' </history>
        ''' -----------------------------------------------------------------------------
        Public Shared ReadOnly Property ThemesSupported() As Boolean
            Get
                Return Environment.OSVersion.Platform = PlatformID.Win32NT AndAlso Environment.OSVersion.Version.Major >= 5 AndAlso Environment.OSVersion.Version.Minor > 0 AndAlso OSFeature.Feature.IsPresent(OSFeature.Themes)
            End Get
        End Property

        ''' -----------------------------------------------------------------------------
        ''' <summary>
        ''' The name of the current theme
        ''' </summary>
        ''' <remarks>
        ''' </remarks>
        ''' <history>
        ''' 	[jcamp]	8/18/2005	Created
        ''' </history>
        ''' -----------------------------------------------------------------------------
        Public Shared ReadOnly Property ThemeName() As String
            Get
                Return GetThemeName()
            End Get
        End Property

        ''' -----------------------------------------------------------------------------
        ''' <summary>
        ''' The name of the current color scheme
        ''' </summary>
        ''' <remarks>
        ''' </remarks>
        ''' <history>
        ''' 	[jcamp]	8/18/2005	Created
        ''' </history>
        ''' -----------------------------------------------------------------------------
        Public Shared ReadOnly Property ColorSchemeName() As String
            Get
                Return GetColorSchemeName()
            End Get
        End Property

        ''' -----------------------------------------------------------------------------
        ''' <summary>
        ''' Returns an enumeration of the supported Windows XP themes that represents the current theme
        ''' </summary>
        ''' <remarks>
        ''' </remarks>
        ''' <history>
        ''' 	[jcamp]	8/18/2005	Created
        ''' </history>
        ''' -----------------------------------------------------------------------------
        Public Shared ReadOnly Property CurrentTheme() As XPTheme
            Get
                Select Case GetThemeName.ToUpper
                    Case "LUNA"
                        Select Case GetColorSchemeName.ToUpper
                            Case "HOMESTEAD"
                                Return XPTheme.Luna_Homestead
                            Case "NORMALCOLOR"
                                Return XPTheme.Luna_NormalColor
                            Case "METALLIC"
                                Return XPTheme.Luna_Metallic
                            Case Else
                                Return XPTheme.Unknown
                        End Select
                    Case ""
                        Return XPTheme.Windows_Classic
                    Case Else
                        Return XPTheme.Unknown
                End Select
            End Get
        End Property
#End Region

#Region " Private  Members "

        Private Shared Sub OnUserPreferenceChanged(ByVal sender As Object, ByVal e As Microsoft.Win32.UserPreferenceChangedEventArgs)
            'Determine if this is a color scheme change and if so then raise the ColorSchemeChanged event
            If e.Category = Microsoft.Win32.UserPreferenceCategory.Color Then
                RaiseEvent ColorSchemeChanged(sender, e)
            End If
        End Sub

        Private Shared Function GetThemeName() As String
            'Get the theme name from the Win32 API and remove the file path and extension
            If ThemeInfo.ThemesSupported Then
                Dim themeName As New System.Text.StringBuilder(260)
                Dim themeNameLen As Integer = 260
                Dim colorName As New System.Text.StringBuilder(260)
                Dim colorNameLen As Integer = 260
                Dim sizeName As New System.Text.StringBuilder(260)
                Dim sizeNameLen As Integer = 260

                Dim result As Integer = GetCurrentThemeName(themeName, themeNameLen, colorName, colorNameLen, sizeName, sizeNameLen)
                Dim theme As String = themeName.ToString
                If theme.LastIndexOf("\") >= 0 Then theme = theme.Substring(theme.LastIndexOf("\") + 1)
                If theme.LastIndexOf(".") >= 0 Then theme = theme.Substring(0, theme.LastIndexOf("."))

                Return theme
            Else
                Return ""
            End If
        End Function

        Private Shared Function GetColorSchemeName() As String
            'Get the color scheme name from the Win32 API and remove the file path and extension
            If ThemeInfo.ThemesSupported Then
                Dim themeName As New System.Text.StringBuilder(260)
                Dim themeNameLen As Integer = 260
                Dim colorName As New System.Text.StringBuilder(260)
                Dim colorNameLen As Integer = 260
                Dim sizeName As New System.Text.StringBuilder(260)
                Dim sizeNameLen As Integer = 260

                Dim result As Integer = GetCurrentThemeName(themeName, themeNameLen, colorName, colorNameLen, sizeName, sizeNameLen)

                Return colorName.ToString
            Else
                Return ""
            End If
        End Function

#End Region

    End Class

End Namespace
