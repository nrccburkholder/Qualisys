Imports NRC.Data

<Serializable()> _
Public Class ApplicationCollection
    Inherits CollectionBase

    Default Public ReadOnly Property Item(ByVal index As Integer) As Application
        Get
            Return DirectCast(MyBase.List(index), Application)
        End Get
    End Property

    Default Public ReadOnly Property Item(ByVal appName As String) As Application
        Get
            For Each app As Application In MyBase.List
                If appName.ToLower = app.Name.ToLower Then
                    Return app
                End If
            Next

            Return Nothing
        End Get
    End Property

    Public Function Add(ByVal application As Application) As Integer
        Return MyBase.List.Add(application)
    End Function


    Public Shared Function GetAllApplications() As ApplicationCollection
        Return GetApplications(AppCollectionEnum.AllApps, 0)
    End Function

    Public Shared Function GetOrgUnitApplications(ByVal orgUnitId As Integer) As ApplicationCollection
        Return GetApplications(AppCollectionEnum.OrgUnitApps, orgUnitId)
    End Function

    Public Shared Function GetMemberApplications(ByVal memberId As Integer) As ApplicationCollection
        Return GetApplications(AppCollectionEnum.MemberApps, memberId)
    End Function

    Public Shared Function GetGroupApplications(ByVal groupId As Integer) As ApplicationCollection
        Return GetApplications(AppCollectionEnum.GroupApps, groupId)
    End Function

    Private Shared Function GetApplications(ByVal collectionType As AppCollectionEnum, ByVal param As Integer) As ApplicationCollection
        Dim ds As DataSet
        Dim dv As DataView
        Select Case collectionType
            Case AppCollectionEnum.AllApps
                ds = DAL.SelectApplications
            Case AppCollectionEnum.MemberApps
                ds = DAL.SelectMemberApplications(param)
            Case AppCollectionEnum.OrgUnitApps
                ds = DAL.SelectOrgUnitApplications(param)
            Case AppCollectionEnum.GroupApps
                ds = DAL.SelectGroupApplications(param)
        End Select

        Dim appCollection As New ApplicationCollection
        Dim list As IList = appCollection

        Populator.FillCollection(ds.Tables(0).Rows, GetType(Application), list)
        Dim appName As String
        Dim app As Application

        For Each row As DataRow In ds.Tables(0).Rows
            appName = row("strApplication_nm").ToString
            app = appCollection(appName)
            Populator.FillCollection(row.GetChildRows("AppPrivilege"), GetType(Privilege), app.Privileges)
        Next

        Return appCollection
    End Function

    Private Enum AppCollectionEnum
        AllApps = 0
        OrgUnitApps
        MemberApps
        GroupApps
    End Enum
End Class

