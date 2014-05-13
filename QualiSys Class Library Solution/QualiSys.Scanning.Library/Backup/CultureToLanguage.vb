Imports NRC.Framework.BusinessLogic

Public Interface ICultureToLanguage
	Property CultureLangID As Integer
End Interface

<Serializable()> _
Public Class CultureToLanguage
	Inherits BusinessBase(Of CultureToLanguage)
	Implements ICultureToLanguage

#Region " Private Fields "
	Private mInstanceGuid As Guid = Guid.NewGuid
	Private mCultureLangID As Integer
    Private mCultureID As Integer
    Private mCultureCode As String = String.Empty
    Private mCultureDesc As String = String.Empty
    Private mLangID As Integer
    Private mLanguage As String = String.Empty
    Private mIsQualisysLanguage As Boolean
#End Region

#Region " Public Properties "
	Public Property CultureLangID As Integer Implements ICultureToLanguage.CultureLangID
		Get
			Return mCultureLangID
		End Get
		Private Set(ByVal value As Integer)
			If Not value = mCultureLangID Then
				mCultureLangID = value
				PropertyHasChanged("CultureLangID")
			End If		
		End Set
	End Property
	Public Property CultureID As Integer
		Get
			Return mCultureID
		End Get
		Set(ByVal value As Integer)
			If Not value = mCultureID Then
				mCultureID = value
				PropertyHasChanged("CultureID")
			End If
		End Set
	End Property
    Public Property CultureCode() As String
        Get
            Return mCultureCode
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mCultureCode Then
                mCultureCode = value
                PropertyHasChanged("CultureCode")
            End If
        End Set
    End Property
    Public Property CultureDesc() As String
        Get
            Return mCultureDesc
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mCultureDesc Then
                mCultureDesc = value
                PropertyHasChanged("CultureDesc")
            End If
        End Set
    End Property
	Public Property LangID As Integer
        Get
            Return mLangID
        End Get
        Set(ByVal value As Integer)
            If Not value = mLangID Then
                mLangID = value
                PropertyHasChanged("LangID")
            End If
        End Set
    End Property
    Public Property Language() As String
        Get
            Return mLanguage
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mLanguage Then
                mLanguage = value
                PropertyHasChanged("Language")
            End If
        End Set
    End Property
    Public Property IsQualisysLanguage() As Boolean
        Get
            Return mIsQualisysLanguage
        End Get
        Set(ByVal value As Boolean)
            If Not value = mIsQualisysLanguage Then
                mIsQualisysLanguage = value
                PropertyHasChanged("IsQualisysLanguage")
            End If
        End Set
    End Property
#End Region

#Region " Constructors "
	Private Sub New()
		Me.CreateNew()
	End Sub
#End Region

#Region " Factory Methods "
	Public Shared Function NewCultureToLanguage As CultureToLanguage
		Return New CultureToLanguage
	End Function
	
	Public Shared Function [Get](ByVal cultureLangID As Integer) As CultureToLanguage
		Return CultureToLanguageProvider.Instance.SelectCultureToLanguage(cultureLangID)
	End Function

	Public Shared Function GetAll() As CultureToLanguageCollection
		Return CultureToLanguageProvider.Instance.SelectAllCultureToLanguages()
    End Function

    Public Shared Function GetByCultureCode(ByVal cultureCode As String) As CultureToLanguage
        Return CultureToLanguageProvider.Instance.SelectByCultureCode(cultureCode)
    End Function

    Public Shared Function GetByLangId(ByVal langID As Integer) As CultureToLanguage
        Return CultureToLanguageProvider.Instance.SelectByLanguageID(langID)
    End Function
#End Region
#Region " Basic Overrides "
    Protected Overrides Function GetIdValue() As Object
        If Me.IsNew Then
            Return mInstanceGuid
        Else
            Return mCultureLangID
        End If
    End Function
#End Region
#Region " Validation "
	Protected Overrides Sub AddBusinessRules()
		'Add validation rules here...
	End Sub
#End Region

#Region " Data Access "
	Protected Overrides Sub CreateNew()
		'Set default values here
		
		'Optionally finish by validating default values
		ValidationRules.CheckRules()
	End Sub

#End Region

#Region " Public Methods "

#End Region

End Class


