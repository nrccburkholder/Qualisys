Imports NRC.Framework.BusinessLogic
Imports Nrc.QualiSys.Library.DataProvider

Public Interface ISurveyType

    Property Id() As Integer

End Interface

<Serializable()> _
Public Class SurveyType
	Inherits BusinessBase(Of SurveyType)
	Implements ISurveyType

#Region " Private Fields "

    Private mInstanceGuid As Guid = Guid.NewGuid
    Private mId As Integer
    Private mDescription As String = String.Empty
    Private mOptionTypeId As Integer
    Private mSeedMailings As Boolean
    Private mSeedSurveyPercent As Integer
    Private mSeedUnitField As String = String.Empty

    Private mSeedSurveys As New Collection(Of Survey)

#End Region

#Region " Public Properties "

    Public Property Id() As Integer Implements ISurveyType.Id
        Get
            Return mId
        End Get
        Private Set(ByVal value As Integer)
            If Not value = mId Then
                mId = value
                PropertyHasChanged("Id")
            End If
        End Set
    End Property

    Public Property Description() As String
        Get
            Return mDescription
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mDescription Then
                mDescription = value
                PropertyHasChanged("Description")
            End If
        End Set
    End Property

    Public Property OptionTypeId() As Integer
        Get
            Return mOptionTypeId
        End Get
        Set(ByVal value As Integer)
            If Not value = mOptionTypeId Then
                mOptionTypeId = value
                PropertyHasChanged("OptionTypeId")
            End If
        End Set
    End Property

    Public Property SeedMailings() As Boolean
        Get
            Return mSeedMailings
        End Get
        Set(ByVal value As Boolean)
            If Not value = mSeedMailings Then
                mSeedMailings = value
                PropertyHasChanged("SeedMailings")
            End If
        End Set
    End Property

    Public Property SeedSurveyPercent() As Integer
        Get
            Return mSeedSurveyPercent
        End Get
        Set(ByVal value As Integer)
            If Not value = mSeedSurveyPercent Then
                mSeedSurveyPercent = value
                PropertyHasChanged("SeedSurveyPercent")
            End If
        End Set
    End Property

    Public Property SeedUnitField() As String
        Get
            Return mSeedUnitField
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mSeedUnitField Then
                mSeedUnitField = value
                PropertyHasChanged("SeedUnitField")
            End If
        End Set
    End Property

#End Region

#Region " Public ReadOnly Properties "

    Public ReadOnly Property SeedSurveys() As Collection(Of Survey)
        Get
            Return mSeedSurveys
        End Get
    End Property

#End Region

#Region " Constructors "

    Private Sub New()

        CreateNew()

    End Sub

#End Region

#Region " Factory Methods "

    Public Shared Function NewSurveyType() As SurveyType

        Return New SurveyType

    End Function

    Public Shared Function [Get](ByVal id As Integer) As SurveyType

        Return SurveyTypeProvider.Instance.SelectSurveyType(id)

    End Function

    Public Shared Function GetAll() As SurveyTypeCollection

        Return SurveyTypeProvider.Instance.SelectAllSurveyTypes()

    End Function

#End Region

#Region " Basic Overrides "

    Protected Overrides Function GetIdValue() As Object

        If IsNew Then
            Return mInstanceGuid
        Else
            Return mId
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

        Id = SurveyTypeProvider.Instance.InsertSurveyType(Me)

    End Sub

    Protected Overrides Sub Update()

        SurveyTypeProvider.Instance.UpdateSurveyType(Me)

    End Sub

    Protected Overrides Sub DeleteImmediate()

        SurveyTypeProvider.Instance.DeleteSurveyType(Me)

    End Sub

#End Region

#Region " Public Methods "

#End Region

End Class


