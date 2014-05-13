Option Strict On
Option Explicit On

Imports Nrc.Framework.BusinessLogic

Public Enum EmailNotifyMethod
    NoEmail = 1
    HtmlEmail = 2
    PlainTextEmail = 3
End Enum

Public Interface IMemberReportPreference
    Property MemberId() As Integer
End Interface

<Serializable()> _
Public Class MemberReportPreference
    Inherits BusinessBase(Of MemberReportPreference)
    Implements IMemberReportPreference

#Region " Private Members "
    <NotUndoable()> Private mInstanceGuid As Guid = Guid.NewGuid
    Private mMemberId As Integer
    Private mContentNotifyMethod As EmailNotifyMethod
    Private mDateCreated As DateTime
    Private mDateUpdated As DateTime
#End Region

#Region " Public Properties "

    Public Property MemberId() As Integer Implements IMemberReportPreference.MemberId
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
    Public Property ContentNotifyMethod() As EmailNotifyMethod
        Get
            Return mContentNotifyMethod
        End Get
        Set(ByVal value As EmailNotifyMethod)
            If Not value = mContentNotifyMethod Then
                mContentNotifyMethod = value
                PropertyHasChanged("ContentNotifyMethod")
            End If
        End Set
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

    Public Shared Function NewMemberReportPreference() As MemberReportPreference
        Return New MemberReportPreference
    End Function

    Public Shared Function NewMemberReportPreference(ByVal memberId As Integer) As MemberReportPreference
        Dim preference As New MemberReportPreference
        preference.MemberId = memberId
        Return preference
    End Function

    Public Shared Function GetByKey(ByVal memberId As Integer) As MemberReportPreference
        Return DataProvider.Instance.SelectMemberReportPreference(memberId)
    End Function

    Public Shared Function GetAll() As MemberReportPreferenceCollection
        Return DataProvider.Instance.SelectAllMemberReportPreference()
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
        ContentNotifyMethod = EmailNotifyMethod.HtmlEmail

        'Optionally finish by validating default values
        ValidationRules.CheckRules()
    End Sub

    Protected Overrides Sub Insert()
        DataProvider.Instance.InsertMemberReportPreference(Me)
    End Sub

    Protected Overrides Sub Update()
        DataProvider.Instance.UpdateMemberReportPreference(Me)
    End Sub

    Protected Overrides Sub DeleteImmediate()
        DataProvider.Instance.DeleteMemberReportPreference(mMemberId)
    End Sub

#End Region

#Region " Public Methods "

#End Region

End Class

<Serializable()> _
Public Class MemberReportPreferenceCollection
    Inherits BusinessListBase(Of MemberReportPreferenceCollection, MemberReportPreference)

    Protected Overrides Function AddNewCore() As Object
        Dim newObj As MemberReportPreference = MemberReportPreference.NewMemberReportPreference
        Me.Add(newObj)
        Return newObj
    End Function

End Class

