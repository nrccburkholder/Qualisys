Imports Nrc.Framework.BusinessLogic
Imports System.Collections.ObjectModel

Public Class UpdateFileCollection
    Inherits BusinessListBase(Of UpdateFileCollection, UpdateFile)

    Public Event UpdateProgress As EventHandler(Of UpdateProgressEventArgs)

    Public ReadOnly Property Exceptions() As UpdateFileCollection
        Get
            Dim excColl As New UpdateFileCollection

            For Each file As UpdateFile In Me
                If file.Exceptions.Count > 0 Then
                    excColl.Add(file)
                End If
            Next

            Return excColl
        End Get
    End Property

    Public Function CheckForFilesWithNoUpdates() As UpdateFileCollection

        Dim noUpdates As New UpdateFileCollection

        For Each file As UpdateFile In Me
            If file.Respondents.CanUpdateCount = 0 Then
                noUpdates.Add(file)
            End If
        Next

        Return noUpdates

    End Function

    Public Function ProcessFiles(ByVal updateMappings As UpdateMappingCollection, ByVal updateTypeID As Integer, ByVal userName As String, ByVal updateMissing As Boolean) As UpdateRespondentCollection

        Dim percentCnt As Integer = 0
        Dim fileCnt As Integer = 0

        'Loop through all of the files
        For Each file As UpdateFile In Me
            'Update the progress bar
            fileCnt += 1
            percentCnt += 1
            RaiseEvent UpdateProgress(Me, New UpdateProgressEventArgs(file.FileName, fileCnt, GetPercent(percentCnt)))

            'Find and Update the respondents with missing codes
            If updateMissing Then file.UpdateMissingEventCodes()

            'Update the progress bar
            percentCnt += 1
            RaiseEvent UpdateProgress(Me, New UpdateProgressEventArgs(file.FileName, fileCnt, GetPercent(percentCnt)))

            'Perform the specified mappings
            If updateMappings.Count > 0 Then
                'There are updates to perform so let's do it
                file.UpdateMappings(updateMappings)
            End If

            'Log this file
            UpdateFileLog.Insert(file.FileName, file.Respondents.Count, file.Respondents.UpdatedCount, file.Respondents.InsertedMissingCount, updateTypeID, 1, userName, file.Respondents)
        Next

        Return DisplayRespondents()

    End Function

    Private Function GetPercent(ByVal count As Integer) As Integer

        Return CType((count / (Me.Count * 2)) * 100, Integer)

    End Function

    Private Function DisplayRespondents() As UpdateRespondentCollection

        Dim resps As New UpdateRespondentCollection

        For Each file As UpdateFile In Me
            For Each resp As UpdateRespondent In file.Respondents
                resps.Add(resp)
            Next
        Next

        Return resps

    End Function

End Class