Imports NRC.Framework.BusinessLogic

Public Interface IContractedLanguage

    Property LanguageCode() As String

End Interface

<Serializable()> _
Public Class ContractedLanguage
	Inherits BusinessBase(Of ContractedLanguage)
	Implements IContractedLanguage

#Region " Private Fields "

    Private mInstanceGuid As Guid = Guid.NewGuid
    Private mLanguageCode As String = String.Empty
    Private mLanguageName As String = String.Empty
    Private mLangID As Integer
    Private mDisplayOrder As Short

#End Region

#Region " Public Properties "

    Public Property LanguageCode() As String Implements IContractedLanguage.LanguageCode
        Get
            Return mLanguageCode
        End Get
        Private Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mLanguageCode Then
                mLanguageCode = value
                PropertyHasChanged("LanguageCode")
            End If
        End Set
    End Property

    Public Property LanguageName() As String
        Get
            Return mLanguageName
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mLanguageName Then
                mLanguageName = value
                PropertyHasChanged("LanguageName")
            End If
        End Set
    End Property

    Public Property LangID() As Integer
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

    Public Property DisplayOrder() As Short
        Get
            Return mDisplayOrder
        End Get
        Set(ByVal value As Short)
            If Not value = mDisplayOrder Then
                mDisplayOrder = value
                PropertyHasChanged("DisplayOrder")
            End If
        End Set
    End Property

#End Region

#Region " Public ReadOnly Properties "

    Public Overrides Function ToString() As String

        Return String.Format("{0} ({1})", LanguageName, LanguageCode)

    End Function

#End Region

#Region " Constructors "

    Private Sub New()

        CreateNew()

    End Sub
#End Region

#Region " Factory Methods "

    Public Shared Function NewContractedLanguage() As ContractedLanguage

        Return New ContractedLanguage

    End Function

    Public Shared Function [Get](ByVal languageCode As String) As ContractedLanguage

        Return DataProvider.ContractedLanguageProvider.Instance.SelectContractedLanguage(languageCode)

    End Function

    Public Shared Function GetAll() As ContractedLanguageCollection

        Return DataProvider.ContractedLanguageProvider.Instance.SelectAllContractedLanguages()

    End Function
#End Region

#Region " Basic Overrides "

    Protected Overrides Function GetIdValue() As Object

        If IsNew Then
            Return mInstanceGuid
        Else
            Return mLanguageCode
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


