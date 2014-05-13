Imports NRC.Framework.BusinessLogic

Public Interface ITranslationModule

    Property TranslationModuleId() As Integer

End Interface

<Serializable()> _
Public Class TranslationModule
	Inherits BusinessBase(Of TranslationModule)
	Implements ITranslationModule

#Region " Private Fields "

    Private mInstanceGuid As Guid = Guid.NewGuid
    Private mTranslationModuleId As Integer
    Private mVendorId As Integer
    Private mModuleName As String = String.Empty
    Private mWatchedFolderPath As String = String.Empty
    Private mFileType As String = String.Empty
    Private mStudyId As Integer
    Private mSurveyId As Integer
    Private mLithoLookupType As LithoLookupTypes

#End Region

#Region " Public Properties "

    Public Property TranslationModuleId() As Integer Implements ITranslationModule.TranslationModuleId
        Get
            Return mTranslationModuleId
        End Get
        Private Set(ByVal value As Integer)
            If Not value = mTranslationModuleId Then
                mTranslationModuleId = value
                PropertyHasChanged("TranslationModuleId")
            End If
        End Set
    End Property

    Public Property VendorId() As Integer
        Get
            Return mVendorId
        End Get
        Set(ByVal value As Integer)
            If Not value = mVendorId Then
                mVendorId = value
                PropertyHasChanged("VendorId")
            End If
        End Set
    End Property

    Public Property ModuleName() As String
        Get
            Return mModuleName
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mModuleName Then
                mModuleName = value
                PropertyHasChanged("ModuleName")
            End If
        End Set
    End Property

    Public Property WatchedFolderPath() As String
        Get
            Return mWatchedFolderPath
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mWatchedFolderPath Then
                mWatchedFolderPath = value
                PropertyHasChanged("WatchedFolderPath")
            End If
        End Set
    End Property

    Public Property FileType() As String
        Get
            Return mFileType
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mFileType Then
                mFileType = value
                PropertyHasChanged("FileType")
            End If
        End Set
    End Property

    Public Property StudyId() As Integer
        Get
            Return mStudyId
        End Get
        Set(ByVal value As Integer)
            If Not value = mStudyId Then
                mStudyId = value
                PropertyHasChanged("StudyId")
            End If
        End Set
    End Property

    Public Property SurveyId() As Integer
        Get
            Return mSurveyId
        End Get
        Set(ByVal value As Integer)
            If Not value = mSurveyId Then
                mSurveyId = value
                PropertyHasChanged("SurveyId")
            End If
        End Set
    End Property

    Public Property LithoLookupType() As LithoLookupTypes
        Get
            Return mLithoLookupType
        End Get
        Set(ByVal value As LithoLookupTypes)
            If Not value = mLithoLookupType Then
                mLithoLookupType = value
                PropertyHasChanged("LithoLookupType")
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

    Public Shared Function NewTranslationModule() As TranslationModule

        Return New TranslationModule

    End Function

    Public Shared Function [Get](ByVal translationModuleId As Integer) As TranslationModule

        Return TranslationModuleProvider.Instance.SelectTranslationModule(translationModuleId)

    End Function

    Public Shared Function GetByVendorId(ByVal vendorId As Integer) As TranslationModuleCollection

        Return TranslationModuleProvider.Instance.SelectTranslationModulesByVendorId(vendorId)

    End Function

#End Region

#Region " Basic Overrides "

    Protected Overrides Function GetIdValue() As Object

        If Me.IsNew Then
            Return mInstanceGuid
        Else
            Return mTranslationModuleId
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

    Protected Overrides Sub Insert()

        TranslationModuleId = TranslationModuleProvider.Instance.InsertTranslationModule(Me)

    End Sub

    Protected Overrides Sub Update()

        TranslationModuleProvider.Instance.UpdateTranslationModule(Me)

    End Sub

    Protected Overrides Sub DeleteImmediate()

        TranslationModuleProvider.Instance.DeleteTranslationModule(Me)

    End Sub

#End Region

#Region " Public Methods "

#End Region

End Class


