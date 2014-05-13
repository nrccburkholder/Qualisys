Imports NRC.Framework.BusinessLogic

Public Interface IDataLoad

    Property DataLoadId() As Integer

End Interface

<Serializable()> _
Public Class DataLoad
	Inherits BusinessBase(Of DataLoad)
	Implements IDataLoad

#Region " Private Fields "

    Private mInstanceGuid As Guid = Guid.NewGuid
    Private mDataLoadId As Integer
    Private mVendorId As Integer
    Private mTranslationModuleId As Integer
    Private mDisplayName As String = String.Empty
    Private mOrigFileName As String = String.Empty
    Private mCurrentFilePath As String = String.Empty
    Private mDateLoaded As Date
    Private mShowInTree As Boolean
    Private mTotalRecordsLoaded As Integer
    Private mTotalDispositionUpdateRecords As Integer
    Private mDateCreated As Date

    Private mSurveys As SurveyDataLoadCollection
    Private mBadLithoCodes As BadLithoCollection

    Private mParentVendor As Vendor = Nothing

#End Region

#Region " Public Properties "

    Public Property DataLoadId() As Integer Implements IDataLoad.DataLoadId
        Get
            Return mDataLoadId
        End Get
        Private Set(ByVal value As Integer)
            If Not value = mDataLoadId Then
                mDataLoadId = value
                PropertyHasChanged("DataLoadId")
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

    Public Property TranslationModuleId() As Integer
        Get
            Return mTranslationModuleId
        End Get
        Set(ByVal value As Integer)
            If Not value = mTranslationModuleId Then
                mTranslationModuleId = value
                PropertyHasChanged("TranslationModuleId")
            End If
        End Set
    End Property

    Public Property DisplayName() As String
        Get
            Return mDisplayName
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mDisplayName Then
                mDisplayName = value
                PropertyHasChanged("DisplayName")
            End If
        End Set
    End Property

    Public Property OrigFileName() As String
        Get
            Return mOrigFileName
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mOrigFileName Then
                mOrigFileName = value
                PropertyHasChanged("OrigFileName")
            End If
        End Set
    End Property

    Public Property CurrentFilePath() As String
        Get
            Return mCurrentFilePath
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mCurrentFilePath Then
                mCurrentFilePath = value
                PropertyHasChanged("CurrentFilePath")
            End If
        End Set
    End Property

    Public Property DateLoaded() As Date
        Get
            Return mDateLoaded
        End Get
        Set(ByVal value As Date)
            If Not value = mDateLoaded Then
                mDateLoaded = value
                PropertyHasChanged("DateLoaded")
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

    Public Property TotalRecordsLoaded() As Integer
        Get
            Return mTotalRecordsLoaded
        End Get
        Set(ByVal value As Integer)
            If Not value = mTotalRecordsLoaded Then
                mTotalRecordsLoaded = value
                PropertyHasChanged("TotalRecordsLoaded")
            End If
        End Set
    End Property

    Public Property TotalDispositionUpdateRecords() As Integer
        Get
            Return mTotalDispositionUpdateRecords
        End Get
        Set(ByVal value As Integer)
            If Not value = mTotalDispositionUpdateRecords Then
                mTotalDispositionUpdateRecords = value
                PropertyHasChanged("TotalDispositionUpdateRecords")
            End If
        End Set
    End Property

    Public Property DateCreated() As Date
        Get
            Return mDateCreated
        End Get
        Set(ByVal value As Date)
            If Not value = mDateCreated Then
                mDateCreated = value
                PropertyHasChanged("DateCreated")
            End If
        End Set
    End Property

    Public ReadOnly Property Surveys() As SurveyDataLoadCollection
        Get
            If mSurveys Is Nothing Then
                mSurveys = SurveyDataLoad.GetByDataLoadId(mDataLoadId)
            End If

            Return mSurveys
        End Get
    End Property

    Public ReadOnly Property BadLithoCodes() As BadLithoCollection
        Get
            If mBadLithoCodes Is Nothing Then
                mBadLithoCodes = BadLitho.GetByDataLoadId(mDataLoadId)
            End If

            Return mBadLithoCodes
        End Get
    End Property

#End Region

#Region "Private Properties"

    Friend ReadOnly Property ParentVendor() As Vendor
        Get
            If mParentVendor Is Nothing Then
                mParentVendor = Vendor.Get(mVendorId)
            End If

            Return mParentVendor
        End Get
    End Property

#End Region

#Region " Constructors "

    Private Sub New()

        Me.CreateNew()

    End Sub

#End Region

#Region " Factory Methods "

    Public Shared Function NewDataLoad() As DataLoad

        Return New DataLoad

    End Function

    Public Shared Function [Get](ByVal dataLoadId As Integer) As DataLoad

        Return DataLoadProvider.Instance.SelectDataLoad(dataLoadId)

    End Function

    Public Shared Function GetByVendorId(ByVal vendorId As Integer) As DataLoadCollection

        Return DataLoadProvider.Instance.SelectDataLoadsByVendorId(vendorId)

    End Function

#End Region

#Region " Basic Overrides "

    Protected Overrides Function GetIdValue() As Object

        If Me.IsNew Then
            Return mInstanceGuid
        Else
            Return mDataLoadId
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

        DataLoadId = DataLoadProvider.Instance.InsertDataLoad(Me)

    End Sub

    Protected Overrides Sub Update()

        DataLoadProvider.Instance.UpdateDataLoad(Me)

    End Sub

    Protected Overrides Sub DeleteImmediate()

        DataLoadProvider.Instance.DeleteDataLoad(Me)

    End Sub

#End Region

#Region " Public Methods "

    Public Function LithoErrorCount() As Integer

        Dim count As Integer

        For Each srvy As SurveyDataLoad In Surveys
            count += srvy.LithoErrorCount
        Next

        Return count

    End Function

    Public Function DispositionErrorCount() As Integer

        Dim count As Integer

        For Each srvy As SurveyDataLoad In Surveys
            count += srvy.DispositionErrorCount
        Next

        Return count

    End Function

    Public Function QuestionResultErrorCount() As Integer

        Dim count As Integer

        For Each srvy As SurveyDataLoad In Surveys
            count += srvy.QuestionResultErrorCount
        Next

        Return count

    End Function

    Public Function CommentErrorCount() As Integer

        Dim count As Integer

        For Each srvy As SurveyDataLoad In Surveys
            count += srvy.CommentErrorCount
        Next

        Return count

    End Function

    Public Function HandEntryErrorCount() As Integer

        Dim count As Integer

        For Each srvy As SurveyDataLoad In Surveys
            count += srvy.HandEntryErrorCount
        Next

        Return count

    End Function

#End Region

End Class


