Imports NRC.Framework.BusinessLogic

Public Interface ITransferResultsNavigatorTree

    Property VendorID() As Integer

End Interface

<Serializable()> _
Public Class TransferResultsNavigatorTree
    Inherits BusinessBase(Of TransferResultsNavigatorTree)
    Implements ITransferResultsNavigatorTree

#Region " Private Fields "

    Private mInstanceGuid As Guid = Guid.NewGuid
    Private mVendorID As Integer
    Private mVendorName As String = String.Empty
    Private mDataLoadID As Integer
    Private mDataLoadName As String = String.Empty
    Private mShowInTree As Boolean
    Private mDataLoadHasSurveyErrors As Boolean
    Private mDataLoadHasBadLithos As Boolean
    Private mSurveyDataLoadID As Integer
    Private mSurveyID As Integer
    Private mSurveyName As String = String.Empty
    Private mSurveyDataLoadHasErrors As Boolean

    Private mSurvey As QualiSys.Library.Survey

#End Region

#Region " Public Properties "

    Public Property VendorID() As Integer Implements ITransferResultsNavigatorTree.VendorID
        Get
            Return mVendorID
        End Get
        Private Set(ByVal value As Integer)
            If Not value = mVendorID Then
                mVendorID = value
                PropertyHasChanged("VendorID")
            End If
        End Set
    End Property

    Public Property VendorName() As String
        Get
            Return mVendorName
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mVendorName Then
                mVendorName = value
                PropertyHasChanged("VendorName")
            End If
        End Set
    End Property

    Public Property DataLoadID() As Integer
        Get
            Return mDataLoadID
        End Get
        Set(ByVal value As Integer)
            If Not value = mDataLoadID Then
                mDataLoadID = value
                PropertyHasChanged("DataLoadID")
            End If
        End Set
    End Property

    Public Property DataLoadName() As String
        Get
            Return mDataLoadName
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mDataLoadName Then
                mDataLoadName = value
                PropertyHasChanged("DisplayName")
            End If
        End Set
    End Property

    Public Property ShowInTree() As Boolean
        Get
            Return mShowInTree
        End Get
        Set(ByVal value As Boolean)
            If Not value = mShowInTree Then
                mShowInTree = value
                PropertyHasChanged("ShowInTree")
            End If
        End Set
    End Property

    Public Property DataLoadHasSurveyErrors() As Boolean
        Get
            Return mDataLoadHasSurveyErrors
        End Get
        Set(ByVal value As Boolean)
            If Not value = mDataLoadHasSurveyErrors Then
                mDataLoadHasSurveyErrors = value
                PropertyHasChanged("DataLoadHasSurveyErrors")
            End If
        End Set
    End Property

    Public Property DataLoadHasBadLithos() As Boolean
        Get
            Return mDataLoadHasBadLithos
        End Get
        Set(ByVal value As Boolean)
            If Not value = mDataLoadHasBadLithos Then
                mDataLoadHasBadLithos = value
                PropertyHasChanged("DataLoadHasBadLithos")
            End If
        End Set
    End Property

    Public Property SurveyDataLoadID() As Integer
        Get
            Return mSurveyDataLoadID
        End Get
        Set(ByVal value As Integer)
            If Not value = mSurveyDataLoadID Then
                mSurveyDataLoadID = value
                PropertyHasChanged("SurveyDataLoadID")
            End If
        End Set
    End Property

    Public Property SurveyID() As Integer
        Get
            Return mSurveyID
        End Get
        Set(ByVal value As Integer)
            If Not value = mSurveyID Then
                mSurveyID = value
                PropertyHasChanged("SurveyID")
            End If
        End Set
    End Property

    Public Property SurveyName() As String
        Get
            Return mSurveyName
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mSurveyName Then
                mSurveyName = value
                PropertyHasChanged("SurveyName")
            End If
        End Set
    End Property

    Public Property SurveyDataLoadHasErrors() As Boolean
        Get
            Return mSurveyDataLoadHasErrors
        End Get
        Set(ByVal value As Boolean)
            If Not value = mSurveyDataLoadHasErrors Then
                mSurveyDataLoadHasErrors = value
                PropertyHasChanged("SurveyDataLoadHasErrors")
            End If
        End Set
    End Property

    Public ReadOnly Property Survey() As QualiSys.Library.Survey
        Get
            If mSurvey Is Nothing Then
                mSurvey = QualiSys.Library.Survey.Get(SurveyID)
            End If
            Return mSurvey
        End Get
    End Property

#End Region

#Region " Constructors "

    Private Sub New()

        Me.CreateNew()

    End Sub

#End Region

#Region " Factory Methods "

    Public Shared Function NewTransferResultsNavigatorTree() As TransferResultsNavigatorTree

        Return New TransferResultsNavigatorTree

    End Function

    Public Shared Function GetAllByDateRange(ByVal startDate As Date, ByVal endDate As Date, ByVal sortMode As TransferSortModes) As TransferResultsNavigatorTreeCollection

        Return TransferResultsNavigatorTreeProvider.Instance.SelectTransferResultsNavigatorTreeByDateRange(startDate, endDate, sortMode)

    End Function

#End Region

#Region " Basic Overrides "

    Protected Overrides Function GetIdValue() As Object

        If Me.IsNew Then
            Return mInstanceGuid
        Else
            Return mVendorID
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


