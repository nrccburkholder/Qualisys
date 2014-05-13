Imports NRC.Framework.BusinessLogic

Public Class ExportFileView
    Inherits BusinessBase(Of ExportFileView)

#Region " Private Fields "

    Private mInstanceGuid As Guid = Guid.NewGuid
    Private mMedicareNumber As String = String.Empty
    Private mMedicareName As String = String.Empty
    Private mIsMedicareActive As Boolean
    Private mExportName As String = String.Empty
    Private mFacilityName As String = String.Empty
    Private mSampleUnitId As Integer
    Private mSampleUnitName As String = String.Empty
    Private mdatSubmitted As Nullable(Of Date)
    Private mdatAccepted As Nullable(Of Date)
    Private mdatRejected As Nullable(Of Date)
    Private mdatOverride As Nullable(Of Date)
    Private mFilePath As String = String.Empty
    Private mTPSFilePath As String = String.Empty
    Private mSummaryFilePath As String = String.Empty
    Private mExceptionFilePath As String = String.Empty
    Private mCreatedDate As Date
    Private mExportStartDate As Date
    Private mExportEndDate As Date
    Private mErrorMessage As String = String.Empty
    Private mStackTrace As String = String.Empty
    Private mOverrideError As Boolean
    Private mOverrideErrorName As String = String.Empty
    Private mIgnore As Boolean
    Private mClientGroupName As String = String.Empty
    Private mClientGroupId As Nullable(Of Integer)
    Private mIsClientGroupActive As Boolean
    Private mClientName As String = String.Empty
    Private mClientId As Integer
    Private mIsClientActive As Boolean
    Private mStudyName As String = String.Empty
    Private mStudyId As Integer
    Private mIsStudyActive As Boolean
    Private mSurveyName As String = String.Empty
    Private mSurveyId As Integer
    Private mIsSurveyActive As Boolean
    Private mMedicareExportSetId As Integer
    Private mExportFileId As Integer
    Private mExportSetTypeId As Integer

#End Region

#Region " Public Properties "

    Public Property MedicareNumber() As String
        Get
            Return mMedicareNumber
        End Get
        Set(ByVal value As String)
            If mMedicareNumber <> value Then
                mMedicareNumber = value
                PropertyHasChanged("MedicareNumber")
            End If
        End Set
    End Property
    Public Property MedicareName() As String
        Get
            Return mMedicareName
        End Get
        Set(ByVal value As String)
            If mMedicareName <> value Then
                mMedicareName = value
                PropertyHasChanged("MedicareName")
            End If
        End Set
    End Property
    Public Property IsMedicareActive() As Boolean
        Get
            Return mIsMedicareActive
        End Get
        Set(ByVal value As Boolean)
            If Not value = mIsMedicareActive Then
                mIsMedicareActive = value
                PropertyHasChanged("IsMedicareActive")
            End If
        End Set
    End Property
    Public Property ExportName() As String
        Get
            Return mExportName
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mExportName Then
                mExportName = value
                PropertyHasChanged("ExportName")
            End If
        End Set
    End Property
    Public Property ClientGroupName() As String
        Get
            Return mClientGroupName
        End Get
        Set(ByVal value As String)
            If mClientGroupName <> value Then
                mClientGroupName = value
                PropertyHasChanged("ClientGroupName")
            End If
        End Set
    End Property
    Public Property FacilityName() As String
        Get
            Return mFacilityName
        End Get
        Set(ByVal value As String)
            If mFacilityName <> value Then
                mFacilityName = value
                PropertyHasChanged("FacilityName")
            End If
        End Set
    End Property
    Public Property ClientName() As String
        Get
            Return mClientName
        End Get
        Set(ByVal value As String)
            If mClientName <> value Then
                mClientName = value
                PropertyHasChanged("ClientName")
            End If
        End Set
    End Property
    Public Property StudyName() As String
        Get
            Return mStudyName
        End Get
        Set(ByVal value As String)
            If mStudyName <> value Then
                mStudyName = value
                PropertyHasChanged("StudyName")
            End If
        End Set
    End Property
    Public Property SurveyName() As String
        Get
            Return mSurveyName
        End Get
        Set(ByVal value As String)
            If mSurveyName <> value Then
                mSurveyName = value
                PropertyHasChanged("SurveyName")
            End If
        End Set
    End Property
    Public Property ClientGroupId() As Nullable(Of Integer)
        Get
            Return mClientGroupId
        End Get
        Set(ByVal value As Nullable(Of Integer))
            mClientGroupId = value
            PropertyHasChanged("ClientGroupId")
        End Set
    End Property
    Public Property ClientId() As Integer
        Get
            Return mClientId
        End Get
        Set(ByVal value As Integer)
            If mClientId <> value Then
                mClientId = value
                PropertyHasChanged("ClientId")
            End If
        End Set
    End Property
    Public Property StudyId() As Integer
        Get
            Return mStudyId
        End Get
        Set(ByVal value As Integer)
            If mStudyId <> value Then
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
            If mSurveyId <> value Then
                mSurveyId = value
                PropertyHasChanged("SurveyId")
            End If
        End Set
    End Property
    Public Property SampleUnitId() As Integer
        Get
            Return mSampleUnitId
        End Get
        Set(ByVal value As Integer)
            If mSampleUnitId <> value Then
                mSampleUnitId = value
                PropertyHasChanged("SampleUnitId")
            End If
        End Set
    End Property
    Public Property datRejected() As Nullable(Of Date)
        Get
            Return mdatRejected
        End Get
        Set(ByVal value As Nullable(Of Date))
            mdatRejected = value
            PropertyHasChanged("datRejected")
        End Set
    End Property
    Public Property datSubmitted() As Nullable(Of Date)
        Get
            Return mdatSubmitted
        End Get
        Set(ByVal value As Nullable(Of Date))
            mdatSubmitted = value
            PropertyHasChanged("datSubmitted")
        End Set
    End Property
    Public Property datAccepted() As Nullable(Of Date)
        Get
            Return mdatAccepted
        End Get
        Set(ByVal value As Nullable(Of Date))
            mdatAccepted = value
            PropertyHasChanged("datAccepted")
        End Set
    End Property
    Public Property OverrideError() As Boolean
        Get
            Return mOverrideError
        End Get
        Set(ByVal value As Boolean)
            If Not value = mOverrideError Then
                mOverrideError = value
                PropertyHasChanged("OverrideError")
            End If
        End Set
    End Property
    Public Property OverrideErrorName() As String
        Get
            Return mOverrideErrorName
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mOverrideErrorName Then
                mOverrideErrorName = value
                PropertyHasChanged("OverrideErrorName")
            End If
        End Set
    End Property
    Public Property datOverride() As Nullable(Of Date)
        Get
            Return mdatOverride
        End Get
        Set(ByVal value As Nullable(Of Date))
            mdatOverride = value
            PropertyHasChanged("datOverride")
        End Set
    End Property
    Public Property Ignore() As Boolean
        Get
            Return mIgnore
        End Get
        Set(ByVal value As Boolean)
            If Not value = mIgnore Then
                mIgnore = value
                PropertyHasChanged("Ignore")
            End If
        End Set
    End Property
    Public Property FilePath() As String
        Get
            Return mFilePath
        End Get
        Set(ByVal value As String)
            If mFilePath <> value Then
                mFilePath = value
                PropertyHasChanged("FilePath")
            End If
        End Set
    End Property
    Public Property TPSFilePath() As String
        Get
            Return mTPSFilePath
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mTPSFilePath Then
                mTPSFilePath = value
                PropertyHasChanged("TPSFilePath")
            End If
        End Set
    End Property
    Public Property SummaryFilePath() As String
        Get
            Return mSummaryFilePath
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mSummaryFilePath Then
                mSummaryFilePath = value
                PropertyHasChanged("SummaryFilePath")
            End If
        End Set
    End Property
    Public Property ExceptionFilePath() As String
        Get
            Return mExceptionFilePath
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mExceptionFilePath Then
                mExceptionFilePath = value
                PropertyHasChanged("ExceptionFilePath")
            End If
        End Set
    End Property
    Public Property CreatedDate() As Date
        Get
            Return mCreatedDate
        End Get
        Set(ByVal value As Date)
            If mCreatedDate <> value Then
                mCreatedDate = value
                PropertyHasChanged("CreatedDate")
            End If
        End Set
    End Property
    Public Property ExportStartDate() As Date
        Get
            Return mExportStartDate
        End Get
        Set(ByVal value As Date)
            If Not value = mExportStartDate Then
                mExportStartDate = value
                PropertyHasChanged("ExportStartDate")
            End If
        End Set
    End Property
    Public Property ExportEndDate() As Date
        Get
            Return mExportEndDate
        End Get
        Set(ByVal value As Date)
            If Not value = mExportEndDate Then
                mExportEndDate = value
                PropertyHasChanged("ExportEndDate")
            End If
        End Set
    End Property
    Public Property ErrorMessage() As String
        Get
            Return mErrorMessage
        End Get
        Set(ByVal value As String)
            mErrorMessage = value
            PropertyHasChanged("ErrorMessage")
        End Set
    End Property
    Public Property StackTrace() As String
        Get
            Return mStackTrace
        End Get
        Set(ByVal value As String)
            mStackTrace = value
            PropertyHasChanged("StackTrace")
        End Set
    End Property
    Public Property SampleUnitName() As String
        Get
            Return mSampleUnitName
        End Get
        Set(ByVal value As String)
            If mSampleUnitName <> value Then
                mSampleUnitName = value
                PropertyHasChanged("SampleUnitName")
            End If
        End Set
    End Property
    Public Property IsClientGroupActive() As Boolean
        Get
            Return mIsClientGroupActive
        End Get
        Set(ByVal value As Boolean)
            mIsClientGroupActive = value
            PropertyHasChanged("IsClientGroupActive")
        End Set
    End Property
    Public Property IsClientActive() As Boolean
        Get
            Return mIsClientActive
        End Get
        Set(ByVal value As Boolean)
            mIsClientActive = value
            PropertyHasChanged("IsClientActive")
        End Set
    End Property
    Public Property IsStudyActive() As Boolean
        Get
            Return mIsStudyActive
        End Get
        Set(ByVal value As Boolean)
            mIsStudyActive = value
            PropertyHasChanged("IsStudyActive")
        End Set
    End Property
    Public Property IsSurveyActive() As Boolean
        Get
            Return mIsSurveyActive
        End Get
        Set(ByVal value As Boolean)
            mIsSurveyActive = value
            PropertyHasChanged("IsSurveyActive")
        End Set
    End Property
    Public Property MedicareExportSetId() As Integer
        Get
            Return mMedicareExportSetId
        End Get
        Set(ByVal value As Integer)
            If Not value = mMedicareExportSetId Then
                mMedicareExportSetId = value
                PropertyHasChanged("MedicareExportSetId")
            End If
        End Set
    End Property
    Public Property ExportFileId() As Integer
        Get
            Return mExportFileId
        End Get
        Set(ByVal value As Integer)
            If Not value = mExportFileId Then
                mExportFileId = value
                PropertyHasChanged("ExportFileId")
            End If
        End Set
    End Property
    Public Property ExportSetTypeId() As Integer
        Get
            Return mExportSetTypeId
        End Get
        Set(ByVal value As Integer)
            If Not value = mExportSetTypeId Then
                mExportSetTypeId = value
                PropertyHasChanged("ExportSetTypeId")
            End If
        End Set
    End Property
    Public ReadOnly Property IsInError() As Boolean
        Get
            Return Not String.IsNullOrEmpty(ErrorMessage)
        End Get
    End Property
#End Region

#Region " DB CRUD Methods "

    Public Shared Function GetByExportType(ByVal exportSetType As ExportSetType, ByVal filterStartDate As Date, ByVal filterEndDate As Date) As System.Collections.ObjectModel.Collection(Of ExportFileView)
        Return DataProvider.Instance.SelectExportFilesByExportSetType(exportSetType, filterStartDate, filterEndDate)
    End Function

    Public Shared Function GetByExportTypeAllDetails(ByVal exportSetType As ExportSetType, ByVal filterStartDate As Date, ByVal filterEndDate As Date) As System.Collections.ObjectModel.Collection(Of ExportFileView)
        Return DataProvider.Instance.SelectExportFilesByExportSetTypeAllDetails(exportSetType, filterStartDate, filterEndDate)
    End Function

    Public Sub UpdateTracking()
        DataProvider.Instance.UpdateExportFileTracking(Me)
    End Sub
#End Region

#Region " Validation "

    Protected Overrides Sub AddBusinessRules()

        'Add validation rules here...
        Me.ValidationRules.AddRule(AddressOf ValidateErrorMessage, "ErrorMessage")

    End Sub

#End Region

#Region "Validation Methods"

    Private Function ValidateErrorMessage(ByVal target As Object, ByVal e As Validation.RuleArgs) As Boolean

        If Not String.IsNullOrEmpty(ErrorMessage) AndAlso Not OverrideError AndAlso Not Ignore Then
            e.Description = "File contains an error message that is not overridden or ignored!"
            Return False
        End If

        Return True

    End Function

#End Region

#Region " Basic Overrides "
    Protected Overrides Function GetIdValue() As Object

        Return mInstanceGuid

    End Function
#End Region

End Class
