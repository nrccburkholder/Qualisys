Imports Nrc.QualiSys.Library.DataProvider

''' <summary>
''' Represents a QualiSys language used in survey generation.
''' </summary>
Public Class Language

#Region " Private Instance Data "

#Region " Persisted Fields "
    Private mId As Integer
    Private mName As String
    Private mDisplayLabel As String
#End Region

    Private mIsDirty As Boolean
#End Region

#Region " Public Properties "

#Region " Persisted Properties "
    ''' -----------------------------------------------------------------------------
    ''' <summary>
    ''' The QualiSys LangId for this language.
    ''' </summary>
    ''' <value></value>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[jcamp]	10/12/2005	Created
    ''' </history>
    ''' -----------------------------------------------------------------------------
    Public Property Id() As Integer
        Get
            Return mId
        End Get
        Friend Set(ByVal value As Integer)
            mId = value
        End Set
    End Property
    ''' -----------------------------------------------------------------------------
    ''' <summary>
    ''' The name of this language.
    ''' </summary>
    ''' <value></value>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[jcamp]	10/12/2005	Created
    ''' </history>
    ''' -----------------------------------------------------------------------------
    Public Property Name() As String
        Get
            Return mName
        End Get
        Set(ByVal value As String)
            If mName <> value Then
                mName = value
                mIsDirty = True
            End If
        End Set
    End Property
    ''' -----------------------------------------------------------------------------
    ''' <summary>
    ''' The display label for this language.
    ''' </summary>
    ''' <value></value>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[jcamp]	10/12/2005	Created
    ''' </history>
    ''' -----------------------------------------------------------------------------
    Public Property DisplayLabel() As String
        Get
            Return mDisplayLabel
        End Get
        Set(ByVal value As String)
            If mDisplayLabel <> value Then
                mDisplayLabel = value
                mIsDirty = True
            End If
        End Set
    End Property
#End Region

    Public ReadOnly Property IsDirty() As Boolean
        Get
            Return mIsDirty
        End Get
    End Property
#End Region

#Region " Constructors "
    ''' -----------------------------------------------------------------------------
    ''' <summary>
    ''' Default constructor.
    ''' </summary>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[jcamp]	10/12/2005	Created
    ''' </history>
    ''' -----------------------------------------------------------------------------
    Public Sub New()
    End Sub

#End Region

#Region " DB CRUD Methods "
    ''' -----------------------------------------------------------------------------
    ''' <summary>
    ''' Retrieves and populates a language object from the database.
    ''' </summary>
    ''' <param name="languageId">The ID of the language to retrieve</param>
    ''' <returns></returns>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[jcamp]	10/12/2005	Created
    ''' </history>
    ''' -----------------------------------------------------------------------------
    Public Shared Function GetLanguage(ByVal languageId As Integer) As Language
        Return LanguageProvider.Instance.[Select](languageId)
    End Function

    ''' -----------------------------------------------------------------------------
    ''' <summary>
    ''' Retrieves a collection of all the available languages for a survey.
    ''' </summary>
    ''' -----------------------------------------------------------------------------
    Public Shared Function GetLanguagesAvailableForSurvey(ByVal surveyId As Integer) As Collection(Of Language)
        Return LanguageProvider.Instance.SelectLanguagesAvailableForSurvey(surveyId)
    End Function
#End Region

    Public Sub ResetDirtyFlag()
        mIsDirty = False
    End Sub

End Class
