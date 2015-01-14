Imports NRC.Framework.BusinessLogic
Imports Nrc.QualiSys.Library

Public Interface IVendorFileNavigatorTree

    Property VendorFileID() As Integer

End Interface

<Serializable()> _
Public Class VendorFileNavigatorTree
    Inherits BusinessBase(Of VendorFileNavigatorTree)
    Implements IVendorFileNavigatorTree

#Region " Private Fields "

    Private mInstanceGuid As Guid = Guid.NewGuid
    Private mVendorFileID As Integer
    Private mClientName As String = String.Empty
    Private mClientID As Integer
    Private mStudyName As String = String.Empty
    Private mStudyID As Integer
    Private mSurveyName As String = String.Empty
    Private mSurveyID As Integer
    Private mSampleSetID As Integer
    Private mMailingStepMethodName As String = String.Empty
    Private mMailingStepMethodID As MailingStepMethodCodes
    Private mVendorFileStatusName As String = String.Empty
    Private mVendorFileStatusID As VendorFileStatusCodes
    Private mDisplayName As String = String.Empty
    Private mShowInTree As Boolean
    Private mErrorDesc As String = String.Empty
    Private mVendorID As Nullable(Of Integer)
    Private mDateFileCreated As Nullable(Of DateTime)
    Private mTelematchLog_datSent As Nullable(Of DateTime)
    Private mTelematchLog_datReturned As Nullable(Of DateTime)

#End Region

#Region " Public Properties "

    Public Property VendorFileID() As Integer Implements IVendorFileNavigatorTree.VendorFileID
        Get
            Return mVendorFileID
        End Get
        Private Set(ByVal value As Integer)
            If Not value = mVendorFileID Then
                mVendorFileID = value
                PropertyHasChanged("VendorFileID")
            End If
        End Set
    End Property

    Public Property ClientName() As String
        Get
            Return mClientName
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mClientName Then
                mClientName = value
                PropertyHasChanged("ClientName")
            End If
        End Set
    End Property

    Public Property ClientID() As Integer
        Get
            Return mClientID
        End Get
        Set(ByVal value As Integer)
            If Not value = mClientID Then
                mClientID = value
                PropertyHasChanged("ClientID")
            End If
        End Set
    End Property

    Public Property StudyName() As String
        Get
            Return mStudyName
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mStudyName Then
                mStudyName = value
                PropertyHasChanged("StudyName")
            End If
        End Set
    End Property

    Public Property StudyID() As Integer
        Get
            Return mStudyID
        End Get
        Set(ByVal value As Integer)
            If Not value = mStudyID Then
                mStudyID = value
                PropertyHasChanged("StudyID")
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

    Public Property SampleSetID() As Integer
        Get
            Return mSampleSetID
        End Get
        Set(ByVal value As Integer)
            If Not value = mSampleSetID Then
                mSampleSetID = value
                PropertyHasChanged("SampleSetID")
            End If
        End Set
    End Property

    Public Property MailingStepMethodName() As String
        Get
            Return mMailingStepMethodName
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mMailingStepMethodName Then
                mMailingStepMethodName = value
                PropertyHasChanged("MailingStepMethodName")
            End If
        End Set
    End Property

    Public Property MailingStepMethodID() As MailingStepMethodCodes
        Get
            Return mMailingStepMethodID
        End Get
        Set(ByVal value As MailingStepMethodCodes)
            If Not value = mMailingStepMethodID Then
                mMailingStepMethodID = value
                PropertyHasChanged("MailingStepMethodID")
            End If
        End Set
    End Property

    Public Property VendorFileStatusName() As String
        Get
            Return mVendorFileStatusName
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mVendorFileStatusName Then
                mVendorFileStatusName = value
                PropertyHasChanged("VendorFileStatusName")
            End If
        End Set
    End Property

    Public Property VendorFileStatusID() As VendorFileStatusCodes
        Get
            Return mVendorFileStatusID
        End Get
        Set(ByVal value As VendorFileStatusCodes)
            If Not value = mVendorFileStatusID Then
                mVendorFileStatusID = value
                PropertyHasChanged("VendorFileStatusID")
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

    Public Property VendorID() As Nullable(Of Integer)
        Get
            Return mVendorID
        End Get
        Set(ByVal value As Nullable(Of Integer))
            mVendorID = value
            PropertyHasChanged("VendorID")
        End Set
    End Property

    Public Property DateFileCreated() As Nullable(Of DateTime)
        Get
            Return mDateFileCreated
        End Get
        Set(value As Nullable(Of DateTime))
            mDateFileCreated = value
            PropertyHasChanged("DateFileCreated")
        End Set
    End Property

    Public Property TelematchLog_datSent() As Nullable(Of DateTime)
        Get
            Return mTelematchLog_datSent
        End Get
        Set(value As Nullable(Of DateTime))
            mTelematchLog_datSent = value
            PropertyHasChanged("TelematchLog_datSent")
        End Set
    End Property

    Public Property TelematchLog_datReturned() As Nullable(Of DateTime)
        Get
            Return mTelematchLog_datReturned
        End Get
        Set(value As Nullable(Of DateTime))
            mTelematchLog_datReturned = value
            PropertyHasChanged("TelematchLog_datReturned")
        End Set
    End Property

#End Region

#Region " Constructors "

    Private Sub New()

        Me.CreateNew()

    End Sub

#End Region

#Region " Factory Methods "

    Public Shared Function NewVendorFileNavigatorTree() As VendorFileNavigatorTree

        Return New VendorFileNavigatorTree

    End Function

    Public Shared Function GetAllByDateRange(ByVal statusID As Integer, ByVal startDate As Date) As VendorFileNavigatorTreeCollection

        Return VendorFileNavigatorTreeProvider.Instance.SelectVendorFileNavigatorTreeByDateRange(statusID, startDate)

    End Function

#End Region

#Region " Basic Overrides "

    Protected Overrides Function GetIdValue() As Object

        If Me.IsNew Then
            Return mInstanceGuid
        Else
            Return mVendorFileID
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


