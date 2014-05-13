Option Explicit On 
Option Strict On

Imports NRC
Imports NRC.NRCAuthLib

Public Class CurrentUser

#Region " Private Members "
    Private Shared mLoginName As String
    Private Shared mMember As NRCAuthLib.Member
    Private Shared mOrgUnitsConcateString As String
    Private Shared mOrgUnitsList As New Generic.List(Of OrgUnit)

#End Region

#Region " Public Properties "
    Public Shared ReadOnly Property LoginName() As String
        Get
            Return mLoginName
        End Get
    End Property

    Public Shared ReadOnly Property OrgUnitsConcateString() As String
        Get
            Return mOrgUnitsConcateString
        End Get
    End Property

    Public Shared ReadOnly Property OrgUnitsList() As Generic.List(Of OrgUnit)
        Get
            Return mOrgUnitsList
        End Get
    End Property

    Public Shared ReadOnly Property Member() As NRCAuthLib.Member
        Get
            Return mMember
        End Get
    End Property

#End Region

    Public Enum AuthResult
        ErrorOccurred = 0
        AccessDenied = 1
        Success = 2
    End Enum

    'Constructor
    Shared Sub New()
        mLoginName = Environment.UserName
        mMember = NRCAuthLib.Member.GetNTLoginMember(Environment.UserName)
        PopulateOrgUnitsConcateString()
        PopulateOrgUnitsList()
    End Sub

    Public Shared Function Authenticate() As AuthResult
        If (mMember Is Nothing) Then
            Return AuthResult.AccessDenied
        ElseIf Not mMember.HasAccessToApplication("Web Document Manager") Then
            Return AuthResult.AccessDenied
        Else
            Return AuthResult.Success
        End If
    End Function

#Region " Private Methods"
    Private Shared Sub PopulateOrgUnitsConcateString()
        If (CurrentUser.Member Is Nothing) Then Return
        mOrgUnitsConcateString = ""
        Dim orgUnit As NRCAuthLib.OrgUnit = mMember.OrgUnit
        PopulateOrgUnitsConcateStringSub(orgUnit)
    End Sub

    Private Shared Sub PopulateOrgUnitsConcateStringSub(ByVal orgUnit As NRCAuthLib.OrgUnit)
        mOrgUnitsConcateString &= orgUnit.OrgUnitId & ","
        If (orgUnit.HasChildren) Then
            Dim childOrgUnit As NRCAuthLib.OrgUnit
            For Each childOrgUnit In orgUnit.OrgUnits
                If (childOrgUnit.OrgUnitType = NRCAuthLib.OrgUnit.OrgUnitTypeEnum.NrcOU OrElse _
                    childOrgUnit.OrgUnitType = NRCAuthLib.OrgUnit.OrgUnitTypeEnum.TeamOU) Then
                    PopulateOrgUnitsConcateStringSub(childOrgUnit)
                End If
            Next
        End If
    End Sub

    Private Shared Sub PopulateOrgUnitsList()
        Dim orgUnit As NRCAuthLib.OrgUnit = CurrentUser.Member.OrgUnit
        PopulateOrgUnitsListSub(orgUnit)
    End Sub

    Private Shared Sub PopulateOrgUnitsListSub(ByVal orgUnit As NRCAuthLib.OrgUnit)
        mOrgUnitsList.Add(orgUnit)
        If (orgUnit.HasChildren) Then
            Dim childOrgUnit As NRCAuthLib.OrgUnit
            For Each childOrgUnit In orgUnit.OrgUnits
                PopulateOrgUnitsListSub(childOrgUnit)
            Next
        End If
    End Sub
#End Region

End Class
