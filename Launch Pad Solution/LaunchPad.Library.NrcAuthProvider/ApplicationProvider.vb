Imports Nrc
Imports Nrc.LaunchPad.Library

Public Class ApplicationProvider
    Inherits Nrc.LaunchPad.Library.ApplicationProvider

#Region " Private Members "
    Private mMember As NRCAuthLib.Member
#End Region

#Region " Private Properties "
    Private ReadOnly Property Member() As NRCAuthLib.Member
        Get
            If mMember Is Nothing Then
                mMember = NRCAuthLib.Member.GetNTLoginMember(Environment.UserName)
            End If
            Return mMember
        End Get
    End Property
#End Region

#Region " Base Class Overrides "
    Public Overrides Sub RefreshApplicationList()
        'Reset the member object so privileges will refresh
        Me.mMember = Nothing
    End Sub

    Public Overrides Function CanAdministerApplications() As Boolean
        'Only allow administration if the user is an NRCAuth NRCAdmin
        If Me.Member Is Nothing Then
            Return False
        Else
            Return (Me.Member.MemberType = NRCAuthLib.Member.MemberTypeEnum.NRC_Admin)
        End If
    End Function

    Public Overrides Function GetApplicationsForUser() As ApplicationCollection
        'Get the list of applications for the current user
        'Dim appList As NRCAuthLib.ApplicationCollection = NRCAuthLib.ApplicationCollection.GetMemberApplications(Me.Member.MemberId)

        'Get all applications in NRCAuth
        Dim allApplications As NRCAuthLib.ApplicationCollection = NRCAuthLib.ApplicationCollection.GetAllApplications
        Dim memberApplications As New NRCAuthLib.ApplicationCollection

        'Make a list of all apps that the user has access to
        If Me.Member IsNot Nothing Then
            For Each app As NRCAuthLib.Application In allApplications
                If Me.Member.HasAccessToApplication(app.Name) Then
                    memberApplications.Add(app)
                End If
            Next
        End If

        'Convert the list of apps to LaunchPad Apps
        Return Me.ConvertNRCAuthAppsToLaunchPadApps(memberApplications)
    End Function

    Public Overrides Sub AddApplication(ByVal app As Application)
        'Convert the Launch Pad DelpoymentType Enum to the NRCAuth DeploymentType Enum
        Dim authDeployType As Nrc.NRCAuthLib.DeploymentType
        If Not System.Enum.IsDefined(GetType(Nrc.NRCAuthLib.DeploymentType), CType(app.DeploymentType, Integer)) Then
            Throw New InvalidCastException(app.DeploymentType & " is not a valid value for the NRCAuth DeploymentType enumeration.")
        Else
            authDeployType = CType(CInt(app.DeploymentType), NRCAuthLib.DeploymentType)
        End If

        'Tell NRCAuth to add a new application
        Nrc.NRCAuthLib.Application.CreateNewApplication(app.Name, app.Description, True, Me.Member.MemberId, authDeployType, app.Path, app.ImageData, app.CategoryName)
    End Sub

    Public Overrides Sub DeleteApplication(ByVal app As Application)
        'This is not implemented because NRCAuth does not currently support deletion of apps
        Throw New NotImplementedException
    End Sub

    Public Overrides Sub UpdateApplication(ByVal app As Application)
        'Get the NRCAuth application
        Dim nrcAuthApp As NRCAuthLib.Application = NRCAuthLib.Application.GetApplication(app.Id)

        'Update the properties with the info from the Launch Pad application
        nrcAuthApp.Name = app.Name
        nrcAuthApp.Description = app.Description

        'Convert the enums
        Dim authDeployType As Nrc.NRCAuthLib.DeploymentType
        If Not System.Enum.IsDefined(GetType(Nrc.NRCAuthLib.DeploymentType), CType(app.DeploymentType, Integer)) Then
            Throw New InvalidCastException(app.DeploymentType & " is not a valid value for the NRCAuth DeploymentType enumeration.")
        Else
            authDeployType = CType(CInt(app.DeploymentType), NRCAuthLib.DeploymentType)
        End If

        nrcAuthApp.DeploymentType = authDeployType
        nrcAuthApp.Path = app.Path
        nrcAuthApp.ImageData = app.ImageData
        nrcAuthApp.Category = app.CategoryName

        'Now update the application in NRCAuth
        nrcAuthApp.UpdateApplication(Me.Member.MemberId)

        'Set the application back to "Up-To-Date"
        app.ResetDirtyFlag()
    End Sub

    Public Overrides Function GetAllApplications() As ApplicationCollection
        'Get the list of all NRCAuth applications
        Dim appList As NRCAuthLib.ApplicationCollection = NRCAuthLib.ApplicationCollection.GetAllApplications

        Return Me.ConvertNRCAuthAppsToLaunchPadApps(appList)
    End Function

#End Region

#Region " Private Methods "
    Private Function ConvertNRCAuthAppsToLaunchPadApps(ByVal nrcAuthApps As Nrc.NRCAuthLib.ApplicationCollection) As ApplicationCollection
        'Create a list of Launch Pad Applications
        Dim launchPadApps As New ApplicationCollection
        Dim launchPadApp As Application

        'Convert the NRCAuth application object to the Launch Pad application object
        For Each userApplication As NRCAuthLib.Application In nrcAuthApps
            launchPadApp = New Application(userApplication.ApplicationId)
            launchPadApp.Name = userApplication.Name
            launchPadApp.Description = userApplication.Description
            If Not System.Enum.IsDefined(GetType(DeploymentType), CType(userApplication.DeploymentType, Integer)) Then
                Throw New InvalidCastException(userApplication.DeploymentType & " is not a valid value for the DeploymentType enumeration.")
            Else
                launchPadApp.DeploymentType = CType(CInt(userApplication.DeploymentType), DeploymentType)
            End If
            launchPadApp.Path = userApplication.Path
            launchPadApp.ImageData = userApplication.ImageData
            launchPadApp.CategoryName = userApplication.Category

            'Once we have set all the properties we need to re-mark the application as "Up-To-Date"
            launchPadApp.ResetDirtyFlag()
            launchPadApps.Add(launchPadApp)
        Next

        'Return the collection
        Return launchPadApps
    End Function
#End Region

End Class

