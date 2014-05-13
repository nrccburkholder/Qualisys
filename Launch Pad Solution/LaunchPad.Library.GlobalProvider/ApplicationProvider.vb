Imports System.IO
Imports System.Xml.Serialization
Imports System.DirectoryServices

Public Class ApplicationProvider
    Inherits Nrc.LaunchPad.Library.ApplicationProvider

    Private Shared ReadOnly Property FilePath() As String
        Get
            Return GlobalAppsSection.DataStorePath
        End Get
    End Property

    Private mApplications As ApplicationCollection
    Private mIdGenerator As Random

    Public Sub New()
        mIdGenerator = New Random(Date.UtcNow.Second)

        'Get the application list from the XML file
        If Not File.Exists(FilePath) Then
            mApplications = New ApplicationCollection
            Serialize()
        Else
            mApplications = Deserialize()
        End If
    End Sub

    Public Overrides Sub RefreshApplicationList()
        mApplications = Deserialize()
    End Sub

    Public Overrides Sub AddApplication(ByVal app As Application)
        mApplications.Add(app)
        app.Id = mIdGenerator.Next(1, Integer.MaxValue)

        Serialize()
    End Sub

    Public Overrides Function CanAdministerApplications() As Boolean
        For Each group As String In GlobalAppsSection.AdminGroups
            If My.User.IsInRole(group) Then Return True
        Next
        Return False
    End Function

    Public Overrides Sub DeleteApplication(ByVal app As Application)
        mApplications.Remove(app)
        Serialize()
    End Sub

    Public Overrides Function GetAllApplications() As ApplicationCollection
        Dim applicationsCopy As New ApplicationCollection
        For Each app As Application In mApplications
            applicationsCopy.Add(app)
        Next
        Return applicationsCopy
    End Function

    Public Overrides Function GetApplicationsForUser() As ApplicationCollection
        Return GetAllApplications()
    End Function

    Public Overrides Sub UpdateApplication(ByVal app As Application)
        Serialize()
    End Sub

    Private Shared Function Deserialize() As ApplicationCollection
        If File.Exists(FilePath) Then
            Dim serializer As New XmlSerializer(GetType(ApplicationCollection))
            Using stream As FileStream = File.OpenRead(FilePath)
                Return DirectCast(serializer.Deserialize(stream), ApplicationCollection)
            End Using
        Else
            Return New ApplicationCollection
        End If
    End Function

    Private Sub Serialize()
        SyncLock Me
            Dim serializer As New XmlSerializer(GetType(ApplicationCollection))
            Using stream As FileStream = File.Open(FilePath, FileMode.Create)
                serializer.Serialize(stream, mApplications)
            End Using
        End SyncLock
    End Sub

End Class
