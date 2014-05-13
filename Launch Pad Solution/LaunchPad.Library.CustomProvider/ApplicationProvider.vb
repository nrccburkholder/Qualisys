Imports System.IO
Imports System.Xml.Serialization

Public Class ApplicationProvider
    Inherits Nrc.LaunchPad.Library.ApplicationProvider

    Private Shared ReadOnly mAppDataPath As String = My.Computer.FileSystem.SpecialDirectories.CurrentUserApplicationData
    Private Shared ReadOnly mSettingsFileName As String = "CustomApps.xml"
    Private Shared ReadOnly Property FilePath() As String
        Get
            Return Path.Combine(mAppDataPath, mSettingsFileName)
        End Get
    End Property

    Private mApplications As ApplicationCollection
    Private mIdGenerator As Random

    Sub New()
        mApplications = Deserialize()
        mIdGenerator = New Random(Date.UtcNow.Second)
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
        Return True
    End Function

    Public Overrides Sub DeleteApplication(ByVal app As Application)
        mApplications.Remove(app)
        Serialize()
    End Sub

    Public Overrides Function GetApplicationsForUser() As ApplicationCollection
        Dim applicationsCopy As New ApplicationCollection
        For Each app As Application In mApplications
            applicationsCopy.Add(app)
        Next
        Return applicationsCopy
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

    Public Overrides Function GetAllApplications() As ApplicationCollection
        Return Me.GetApplicationsForUser
    End Function
End Class
