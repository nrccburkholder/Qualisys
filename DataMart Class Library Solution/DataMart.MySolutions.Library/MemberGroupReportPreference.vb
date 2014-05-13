Option Strict On
Option Explicit On

Imports Nrc.Framework.BusinessLogic

Public Interface IMemberGroupReportPreference
    Property MemberId() As Integer
    Property GroupId() As Integer
    Property QualityProgramName() As String
    Property CompDatasetName() As String
End Interface

<Serializable()> _
Public Class MemberGroupReportPreference
    Inherits BusinessBase(Of MemberGroupReportPreference)
    Implements IMemberGroupReportPreference

#Region " Private Members "
    <NotUndoable()> Private mInstanceGuid As Guid = Guid.NewGuid
    Private mMemberId As Integer
    Private mGroupId As Integer
    Private mQualityProgramId As Integer
    Private mQualityProgramName As String = String.Empty
    Private mCompDatasetId As Integer
    Private mCompDatasetName As String = String.Empty
    Private mAnalysisId As Legacy.ToolkitServer.AnalysisVariable
    Private mReportStartDate As DateTime
    Private mReportEndDate As DateTime
    Private mServiceTypeId As Integer
    Private mSelectedUnit As String = String.Empty
    Private mSelectedViewId As Integer
    Private mDateCreated As DateTime
    Private mDateUpdated As DateTime
#End Region

#Region " Public Properties "

    Public Property MemberId() As Integer Implements IMemberGroupReportPreference.MemberId
        Get
            Return mMemberId
        End Get
        Private Set(ByVal value As Integer)
            If Not value = mMemberId Then
                mMemberId = value
                PropertyHasChanged("MemberId")
            End If
        End Set
    End Property
    Public Property GroupId() As Integer Implements IMemberGroupReportPreference.GroupId
        Get
            Return mGroupId
        End Get
        Private Set(ByVal value As Integer)
            If Not value = mGroupId Then
                mGroupId = value
                PropertyHasChanged("GroupId")
            End If
        End Set
    End Property
    Public Property QualityProgramId() As Integer
        Get
            Return mQualityProgramId
        End Get
        Set(ByVal value As Integer)
            If Not value = mQualityProgramId Then
                mQualityProgramId = value
                PropertyHasChanged("QualityProgramId")
            End If
        End Set
    End Property
    Public Property QualityProgramName() As String Implements IMemberGroupReportPreference.QualityProgramName
        Get
            Return mQualityProgramName
        End Get
        Private Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mQualityProgramName Then
                mQualityProgramName = value
                PropertyHasChanged("QualityProgramName")
            End If
        End Set
    End Property
    Public Property CompDatasetId() As Integer
        Get
            Return mCompDatasetId
        End Get
        Set(ByVal value As Integer)
            If Not value = mCompDatasetId Then
                mCompDatasetId = value
                PropertyHasChanged("CompDatasetId")
            End If
        End Set
    End Property
    Public Property CompDatasetName() As String Implements IMemberGroupReportPreference.CompDatasetName
        Get
            Return mCompDatasetName
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mCompDatasetName Then
                mCompDatasetName = value
                PropertyHasChanged("CompDatasetName")
            End If
        End Set
    End Property
    Public Property AnalysisId() As Legacy.ToolkitServer.AnalysisVariable
        Get
            Return mAnalysisId
        End Get
        Set(ByVal value As Legacy.ToolkitServer.AnalysisVariable)
            If Not value = mAnalysisId Then
                mAnalysisId = value
                PropertyHasChanged("AnalysisId")
            End If
        End Set
    End Property
    Public Property ReportStartDate() As DateTime
        Get
            Return mReportStartDate
        End Get
        Set(ByVal value As DateTime)
            If Not value = mReportStartDate Then
                mReportStartDate = value
                PropertyHasChanged("ReportStartDate")
            End If
        End Set
    End Property
    Public ReadOnly Property ReportStartMonth() As Integer
        Get
            Return mReportStartDate.Month
        End Get
    End Property
    Public ReadOnly Property ReportStartYear() As Integer
        Get
            Return mReportStartDate.Year
        End Get
    End Property
    Public Property ReportEndDate() As DateTime
        Get
            Return mReportEndDate
        End Get
        Set(ByVal value As DateTime)
            If Not value = mReportEndDate Then
                Dim endMonth As Integer = value.Month
                Dim endYear As Integer = value.Year
                If endMonth = 12 Then
                    endMonth = 1
                    endYear += 1
                Else
                    endMonth += 1
                End If
                value = New DateTime(endYear, endMonth, 1).AddMinutes(-1)
                mReportEndDate = value
                PropertyHasChanged("ReportEndDate")
            End If
        End Set
    End Property
    Public ReadOnly Property ReportEndMonth() As Integer
        Get
            Return mReportEndDate.Month
        End Get
    End Property
    Public ReadOnly Property ReportEndYear() As Integer
        Get
            Return mReportEndDate.Year
        End Get
    End Property
    Public Property ServiceTypeId() As Integer
        Get
            Return mServiceTypeId
        End Get
        Set(ByVal value As Integer)
            If Not value = mServiceTypeId Then
                mServiceTypeId = value
                PropertyHasChanged("ServiceTypeId")
            End If
        End Set
    End Property
    Public Property SelectedUnit() As String
        Get
            Return mSelectedUnit
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mSelectedUnit Then
                mSelectedUnit = value
                PropertyHasChanged("SelectedUnit")
            End If
        End Set
    End Property
    Public Property SelectedViewId() As Integer
        Get
            Return mSelectedViewId
        End Get
        Set(ByVal value As Integer)
            If Not value = mSelectedViewId Then
                mSelectedViewId = value
                PropertyHasChanged("SelectedViewId")
            End If
        End Set
    End Property
    Public ReadOnly Property IsChooseQuestionSelected() As Boolean
        Get
            Return (mSelectedViewId = -1)
        End Get
    End Property
    Public Property DateCreated() As DateTime
        Get
            Return mDateCreated
        End Get
        Set(ByVal value As DateTime)
            If Not value = mDateCreated Then
                mDateCreated = value
                PropertyHasChanged("DateCreated")
            End If
        End Set
    End Property
    Public Property DateUpdated() As DateTime
        Get
            Return mDateUpdated
        End Get
        Set(ByVal value As DateTime)
            If Not value = mDateUpdated Then
                mDateUpdated = value
                PropertyHasChanged("DateUpdated")
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

    Public Shared Function NewMemberGroupReportPreference() As MemberGroupReportPreference
        Return New MemberGroupReportPreference
    End Function

    Public Shared Function NewMemberGroupReportPreference(ByVal memberId As Integer, ByVal groupId As Integer) As MemberGroupReportPreference
        Dim preference As New MemberGroupReportPreference
        preference.MemberId = memberId
        preference.GroupId = groupId
        Return preference
    End Function

    Public Shared Function GetByKey(ByVal memberId As Integer, ByVal groupId As Integer) As MemberGroupReportPreference
        Return DataProvider.Instance.SelectMemberGroupReportPreference(memberId, groupId)
    End Function

    Public Shared Function GetAll() As MemberGroupReportPreferenceCollection
        Return DataProvider.Instance.SelectAllMemberGroupReportPreference()
    End Function

#End Region

#Region " Basic Overrides "
    Protected Overrides Function GetIdValue() As Object
        If Me.IsNew Then
            Return mInstanceGuid
        Else
            Return mMemberId
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
        Dim today As DateTime = DateTime.Today
        ReportEndDate = today.Date
        ReportStartDate = New DateTime(today.Year - 1, today.Month, 1)

        'Steve Kennedy 03/24/2008 Changed default from ProblemScore to PositiveScore per Ted S. (Ticket 66867)
        'AnalysisId = Legacy.ToolkitServer.AnalysisVariable.ProblemScore
        AnalysisId = Legacy.ToolkitServer.AnalysisVariable.PositiveScore

        ' TODO: Decide what these really should default to!
        QualityProgramId = 2
        CompDatasetId = 1

        'Optionally finish by validating default values
        ValidationRules.CheckRules()
    End Sub

    Protected Overrides Sub Insert()
        DataProvider.Instance.InsertMemberGroupReportPreference(Me)
    End Sub

    Protected Overrides Sub Update()
        DataProvider.Instance.UpdateMemberGroupReportPreference(Me)
    End Sub

    Protected Overrides Sub DeleteImmediate()
        DataProvider.Instance.DeleteMemberGroupReportPreference(mMemberId, mGroupId)
    End Sub

#End Region

#Region " Public Methods "

#End Region

End Class

<Serializable()> _
Public Class MemberGroupReportPreferenceCollection
    Inherits BusinessListBase(Of MemberGroupReportPreferenceCollection, MemberGroupReportPreference)

    Protected Overrides Function AddNewCore() As Object
        Dim newObj As MemberGroupReportPreference = MemberGroupReportPreference.NewMemberGroupReportPreference
        Me.Add(newObj)
        Return newObj
    End Function

End Class

