Imports NRC.Framework.BusinessLogic
Imports Nrc.QualiSys.Library

Public Interface IVendorFileCreationQueue

    Property VendorFileId() As Integer

End Interface

<Serializable()> _
Public Class VendorFileCreationQueue
	Inherits BusinessBase(Of VendorFileCreationQueue)
	Implements IVendorFileCreationQueue

#Region " Private Fields "

    Private mInstanceGuid As Guid = Guid.NewGuid
    Private mVendorFileId As Integer
    Private mSamplesetId As Integer
    Private mMailingStepId As Integer
    Private mVendorFileStatusId As Integer
    Private mDateFileCreated As Date
    Private mDateDataCreated As Date
    Private mArchiveFileName As String = String.Empty
    Private mRecordsInFile As Integer
    Private mRecordsNoLitho As Integer
    Private mShowInTree As Boolean
    Private mErrorDesc As String = String.Empty

    Private mInProcessFileName As String = String.Empty
    Private mSampleSet As SampleSet
    Private mSurvey As Survey

#End Region

#Region " Public Properties "

    Public Property VendorFileId() As Integer Implements IVendorFileCreationQueue.VendorFileId
        Get
            Return mVendorFileId
        End Get
        Private Set(ByVal value As Integer)
            If Not value = mVendorFileId Then
                mVendorFileId = value
                PropertyHasChanged("VendorFileId")
            End If
        End Set
    End Property

    Public Property SamplesetId() As Integer
        Get
            Return mSamplesetId
        End Get
        Set(ByVal value As Integer)
            If Not value = mSamplesetId Then
                mSamplesetId = value
                PropertyHasChanged("SamplesetId")
            End If
        End Set
    End Property

    Public Property MailingStepId() As Integer
        Get
            Return mMailingStepId
        End Get
        Set(ByVal value As Integer)
            If Not value = mMailingStepId Then
                mMailingStepId = value
                PropertyHasChanged("MailingStepId")
            End If
        End Set
    End Property

    Public Property VendorFileStatusId() As Integer
        Get
            Return mVendorFileStatusId
        End Get
        Set(ByVal value As Integer)
            If Not value = mVendorFileStatusId Then
                mVendorFileStatusId = value
                PropertyHasChanged("VendorFileStatusId")
            End If
        End Set
    End Property

    Public Property DateFileCreated() As Date
        Get
            Return mDateFileCreated
        End Get
        Set(ByVal value As Date)
            If Not value = mDateFileCreated Then
                mDateFileCreated = value
                PropertyHasChanged("DateFileCreated")
            End If
        End Set
    End Property

    Public Property DateDataCreated() As Date
        Get
            Return mDateDataCreated
        End Get
        Set(ByVal value As Date)
            If Not value = mDateDataCreated Then
                mDateDataCreated = value
                PropertyHasChanged("DateDataCreated")
            End If
        End Set
    End Property

    Public Property ArchiveFileName() As String
        Get
            Return mArchiveFileName
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mArchiveFileName Then
                mArchiveFileName = value
                PropertyHasChanged("ArchiveFileName")
            End If
        End Set
    End Property

    Public Property RecordsInFile() As Integer
        Get
            Return mRecordsInFile
        End Get
        Set(ByVal value As Integer)
            If Not value = mRecordsInFile Then
                mRecordsInFile = value
                PropertyHasChanged("RecordsInFile")
            End If
        End Set
    End Property

    Public Property RecordsNoLitho() As Integer
        Get
            Return mRecordsNoLitho
        End Get
        Set(ByVal value As Integer)
            If Not value = mRecordsNoLitho Then
                mRecordsNoLitho = value
                PropertyHasChanged("RecordsNoLitho")
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

    Public Property ErrorDesc() As String
        Get
            Return mErrorDesc
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mErrorDesc Then
                mErrorDesc = value
                PropertyHasChanged("ErrorDesc")
            End If
        End Set
    End Property
#End Region

#Region " Public Readonly Properties "

    Public ReadOnly Property SampleSet() As SampleSet
        Get
            If mSampleSet Is Nothing Then
                mSampleSet = SampleSet.GetSampleSet(SamplesetId)
            End If

            Return mSampleSet
        End Get
    End Property

    Public ReadOnly Property Survey() As Survey
        Get
            If mSurvey Is Nothing Then
                mSurvey = Survey.Get(SampleSet.SurveyId)
            End If

            Return mSurvey
        End Get
    End Property

    Public ReadOnly Property Study() As Study
        Get
            Return Survey.Study
        End Get
    End Property

    Public ReadOnly Property Client() As Client
        Get
            Return Study.Client
        End Get
    End Property

#End Region

#Region " Friend Properties "

    Friend Property InProcessFileName() As String
        Get
            Return mInProcessFileName
        End Get
        Set(ByVal value As String)
            mInProcessFileName = value
        End Set
    End Property

#End Region

#Region " Constructors "

    Private Sub New()

        Me.CreateNew()

    End Sub

#End Region

#Region " Factory Methods "

    Public Shared Function NewVendorFileCreationQueue() As VendorFileCreationQueue

        Return New VendorFileCreationQueue

    End Function

    Public Shared Function [Get](ByVal vendorFileId As Integer) As VendorFileCreationQueue

        Return VendorFileCreationQueueProvider.Instance.SelectVendorFileCreationQueue(vendorFileId)

    End Function

    Public Shared Function GetAll() As VendorFileCreationQueueCollection

        Return VendorFileCreationQueueProvider.Instance.SelectAllVendorFileCreationQueues()

    End Function

    Public Shared Function GetBySamplesetId(ByVal samplesetId As Integer) As VendorFileCreationQueueCollection

        Return VendorFileCreationQueueProvider.Instance.SelectVendorFileCreationQueuesBySamplesetId(samplesetId)

    End Function

    Public Shared Function GetByMailingStepId(ByVal mailingStepId As Integer) As VendorFileCreationQueueCollection

        Return VendorFileCreationQueueProvider.Instance.SelectVendorFileCreationQueuesByMailingStepId(mailingStepId)

    End Function

    Public Shared Function GetByVendorFileStatusId(ByVal vendorFileStatusId As VendorFileStatusCodes) As VendorFileCreationQueueCollection

        Return VendorFileCreationQueueProvider.Instance.SelectVendorFileCreationQueuesByVendorFileStatusId(vendorFileStatusId)

    End Function

    Public Shared Function GetVendorFileData(ByVal vendorFileId As Integer) As System.Data.DataTable

        Return VendorFileCreationQueueProvider.Instance.SelectVendorFileData(vendorFileId)

    End Function

    Public Shared Sub RemakeVendorFileData(ByVal vendorFileId As Integer, ByVal sampleSetId As Integer)

        VendorFileCreationQueueProvider.Instance.RemakeVendorFileData(vendorFileId, sampleSetId)

    End Sub

#End Region

#Region " Basic Overrides "

    Protected Overrides Function GetIdValue() As Object

        If Me.IsNew Then
            Return mInstanceGuid
        Else
            Return mVendorFileId
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

        VendorFileId = VendorFileCreationQueueProvider.Instance.InsertVendorFileCreationQueue(Me)

    End Sub

    Protected Overrides Sub Update()

        VendorFileCreationQueueProvider.Instance.UpdateVendorFileCreationQueue(Me)

    End Sub

    Protected Overrides Sub DeleteImmediate()

        VendorFileCreationQueueProvider.Instance.DeleteVendorFileCreationQueue(Me)

    End Sub

#End Region

#Region " Public Methods "

#End Region

#Region " Private Methods "

#End Region

End Class


