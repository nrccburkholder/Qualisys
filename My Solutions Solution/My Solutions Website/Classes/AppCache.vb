Imports Nrc.DataMart.MySolutions.Library
Imports System.Web
Imports Nrc.NRCAuthLib

Public Class AppCache

    Private Shared ReadOnly Property Cache() As Caching.Cache
        Get
            Return HttpContext.Current.Cache
        End Get
    End Property

    Public Shared ReadOnly Property AllServiceTypes() As ServiceTypeCollection
        Get
            Dim list As ServiceTypeCollection
            list = DirectCast(Cache("AllServiceTypes"), ServiceTypeCollection)

            If list Is Nothing Then
                list = ServiceType.GetAll
                AddSlidingCache("AllServiceTypes", list, 30)
            End If

            Return list
        End Get
    End Property

    Public Shared ReadOnly Property ServiceTypePrivileges() As PrivilegeCollection
        Get
            Dim privilegeList As PrivilegeCollection
            privilegeList = DirectCast(Cache("ServiceTypePrivilegeList"), PrivilegeCollection)

            If privilegeList Is Nothing Then
                Dim apps As ApplicationCollection = ApplicationCollection.GetAllApplications()

                For Each app As Application In apps
                    If app.Name = "eToolKit" Then
                        privilegeList = app.Privileges
                        Dim removeIndex As Integer = -1
                        For i As Integer = 0 To privilegeList.Count - 1
                            If privilegeList(i).Name = "eToolKit Admin" Then
                                removeIndex = i
                            End If
                        Next

                        If removeIndex > -1 Then
                            privilegeList.RemoveAt(removeIndex)
                        End If
                    End If
                Next

                AddSlidingCache("ServiceTypePrivilegeList", privilegeList, 30)
            End If

            Return privilegeList
        End Get
    End Property

    Private Shared Sub AddSlidingCache(ByVal cacheKey As String, ByVal value As Object, ByVal expirationMinutes As Integer)
        Cache.Add(cacheKey, value, Nothing, Caching.Cache.NoAbsoluteExpiration, TimeSpan.FromMinutes(expirationMinutes), CacheItemPriority.Default, Nothing)
    End Sub

End Class
