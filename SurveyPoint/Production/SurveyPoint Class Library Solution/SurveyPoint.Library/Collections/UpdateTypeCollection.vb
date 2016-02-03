Imports Nrc.Framework.BusinessLogic

Public Class UpdateTypeCollection
    Inherits BusinessListBase(Of UpdateTypeCollection, UpdateType)

    Public Function GetUpdateTypesByGroup(ByVal fromGroup As UpdateTypeGroups) As UpdateTypeCollection

        Dim updateTypes As New UpdateTypeCollection

        For Each type As UpdateType In Me
            If type.FromGroupID = UpdateTypeGroups.None OrElse type.FromGroupID = fromGroup Then
                updateTypes.Add(type)
            End If
        Next

        Return updateTypes

    End Function

    Public Function GetUpdateTypesByUpdateTypeID(ByVal updateTypeID As Integer) As UpdateTypeCollection

        Dim updateTypes As New UpdateTypeCollection

        For Each type As UpdateType In Me
            If type.UpdateTypeID = updateTypeID Then
                updateTypes = GetUpdateTypesByGroup(type.ToGroupID)
                Exit For
            End If
        Next

        Return updateTypes

    End Function

End Class