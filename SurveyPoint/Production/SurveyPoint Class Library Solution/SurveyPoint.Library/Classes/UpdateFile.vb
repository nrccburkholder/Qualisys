Imports Nrc.Framework.BusinessLogic
Imports Nrc.SurveyPoint.Library.DataProviders
Imports System.IO
Imports System.Collections.ObjectModel

Public Class UpdateFile
    Inherits BusinessBase(Of UpdateFile)

#Region " Private Fields "

    <NotUndoable()> Private mInstanceGuid As Guid = Guid.NewGuid
    Private mFileName As String
    Private mRespondents As New UpdateRespondentCollection
    Private mExceptions As New Collection(Of Exception)

#End Region

#Region " Public Properties "

    Public Property FileName() As String
        Get
            Return mFileName
        End Get
        Set(ByVal value As String)
            If Not value = mFileName Then
                mFileName = value
                PropertyHasChanged("FileName")
            End If
        End Set
    End Property

    Public ReadOnly Property Respondents() As UpdateRespondentCollection
        Get
            Return mRespondents
        End Get
    End Property

    Public ReadOnly Property Exceptions() As Collection(Of Exception)
        Get
            Return mExceptions
        End Get
    End Property
#End Region

#Region " Constructors "

    Private Sub New()

        Me.CreateNew()

    End Sub

#End Region

#Region " Factory Methods "

    Public Shared Function NewUpdateFile(ByVal fileName As String, ByVal importDate As Date) As UpdateFile

        Dim file As New UpdateFile
        file.FileName = fileName
        file.LoadRespondents(importDate)
        Return file

    End Function

    Public Shared Function NewUpdateFile(ByVal logItem As UpdateFileLog) As UpdateFile

        Dim file As New UpdateFile
        file.FileName = logItem.FileName
        file.LoadRespondents(UpdateFileLog.GetUpdatedRespondents(logItem.FileLogID))
        Return file

    End Function

    Private Shared Function NewUpdateFile(ByVal fileName As String, ByVal ex As Exception) As UpdateFile

        Dim file As New UpdateFile
        file.FileName = fileName
        file.Exceptions.Add(ex)
        Return file

    End Function

    Public Shared Function GetAll(ByVal fileNames As String(), ByVal importDate As Date) As UpdateFileCollection

        Dim allFiles As New UpdateFileCollection

        For Each fileName As String In fileNames
            Dim file As UpdateFile
            Try
                'Read the file
                file = UpdateFile.NewUpdateFile(fileName, importDate)

            Catch ex As Exception
                'Log the exception
                file = UpdateFile.NewUpdateFile(fileName, ex)

            End Try

            'Add this file to the collection
            allFiles.Add(file)
        Next

        Return allFiles

    End Function

    Public Sub UpdateMissingEventCodes()

        Dim respIDs As String = String.Empty

        Try
            For Each resp As UpdateRespondent In mRespondents
                'Add this respondent to the list
                If resp.Status = RespondentStatusTypes.CanUpdate Then
                    If respIDs.Length > 0 Then respIDs &= ","
                    respIDs &= resp.RespondentID
                End If

                'We cannot exceed 7700 characters in the respondent id list
                If respIDs.Length > 7650 Then
                    'We need to update the missing event codes for the respondents we have so far
                    mRespondents.ChangeStatus(UpdateRespondent.UpdateMissingEventCodes(respIDs), RespondentStatusTypes.InsertedMissingCode)
                    respIDs = String.Empty
                End If
            Next

            'Update the missing event codes for any remaining respondents
            If respIDs.Length > 0 Then
                mRespondents.ChangeStatus(UpdateRespondent.UpdateMissingEventCodes(respIDs), RespondentStatusTypes.InsertedMissingCode)
            End If

        Catch ex As Exception
            mExceptions.Add(New UpdateMissingEventCodesException("Error adding missing event codes for respondent IDs: " & respIDs, ex))

        End Try

    End Sub

    Public Sub UpdateMappings(ByVal updateMappings As UpdateMappingCollection)

        Dim updated As Boolean

        For Each resp As UpdateRespondent In mRespondents
            'Setup for this pass
            updated = False

            'If the respondent has not been disqualified then try to update the event codes
            If resp.Status = RespondentStatusTypes.CanUpdate OrElse resp.Status = RespondentStatusTypes.InsertedMissingCode Then
                'Loop through all of the selected mappings
                For Each map As UpdateMapping In updateMappings
                    Try
                        If resp.UpdateMapping(map.OldEventID, map.NewEventID) Then
                            'If this mapping was updated then we are out of here.  No need to try anymore.
                            updated = True
                            Exit For
                        End If

                    Catch ex As Exception
                        mExceptions.Add(New UpdateMappingsException("Error updating mappings for respondentID: " & resp.RespondentID.ToString & ", Old Event: " & map.OldEventID.ToString & ", New Event: " & map.NewEventID, ex))

                    End Try
                Next

                'Set the status of this respondent
                Select Case resp.Status
                    Case RespondentStatusTypes.CanUpdate
                        If updated Then
                            resp.Status = RespondentStatusTypes.Updated
                        Else
                            resp.Status = RespondentStatusTypes.NotUpdated
                        End If

                        'We need to get this respondents name
                        resp.PopulateName()

                    Case RespondentStatusTypes.InsertedMissingCode
                        If updated Then
                            resp.Status = RespondentStatusTypes.InsertedMissingCodeUpdated
                        Else
                            resp.Status = RespondentStatusTypes.InsertedMissingCodeNotUpdated
                        End If

                End Select
            End If
        Next

    End Sub
#End Region

#Region " Basic Overrides "

    Protected Overrides Function GetIdValue() As Object
        If Me.IsNew Then
            Return mInstanceGuid
        Else
            Return mFileName
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

        'Optionally finish by validating default values
        ValidationRules.CheckRules()

    End Sub

#End Region

#Region " Public Methods "

#End Region

#Region "Private Methods"

    Private Sub LoadRespondents(ByVal importDate As Date)

        Try
            'Get all of the respondent IDs from the file
            Using sr As StreamReader = New StreamReader(mFileName)
                Dim line As String = sr.ReadLine()
                While Not line Is Nothing
                    Dim respID As Integer

                    'Try to get the respondent ID
                    If Integer.TryParse(line.Substring(23, 8), respID) Then
                        Dim resp As UpdateRespondent = UpdateRespondent.NewUpdateRespondent(respID)
                        resp.Status = RespondentStatusTypes.CanUpdate
                        mRespondents.Add(resp)
                    End If

                    'Read the next line of the file
                    line = sr.ReadLine()
                End While

                'Close the file
                sr.Close()
            End Using

            'Check to see if these respondents are clear for updating
            ExcludeRespondentsAlreadyUpdated()
            ExcludeRespondentsMissingStartCodes(importDate)

        Catch ex As Exception
            'Throw an exception
            Throw New UpdateFileException("Error loading file: " & mFileName, ex)

        End Try

    End Sub

    Private Sub LoadRespondents(ByVal respondents As String())

        For Each respID As String In respondents
            Dim resp As UpdateRespondent = UpdateRespondent.NewUpdateRespondent(CType(respID, Integer))
            resp.Status = RespondentStatusTypes.CanUpdate
            mRespondents.Add(resp)
        Next

    End Sub

    Private Sub ExcludeRespondentsAlreadyUpdated()

        Dim respIDs As String = String.Empty

        For Each resp As UpdateRespondent In mRespondents
            'Add this respondent to the list
            If resp.Status = RespondentStatusTypes.CanUpdate Then
                If respIDs.Length > 0 Then respIDs &= ","
                respIDs &= resp.RespondentID
            End If

            'We cannot exceed 7700 characters in the respondent id list
            If respIDs.Length > 7650 Then
                'We need to check the respondents we have so far
                mRespondents.ChangeStatus(UpdateRespondent.GetByAlreadyUpdated(respIDs), RespondentStatusTypes.AlreadyProcessed)
                respIDs = String.Empty
            End If
        Next

        'Update the missing event codes for any remaining respondents
        If respIDs.Length > 0 Then
            mRespondents.ChangeStatus(UpdateRespondent.GetByAlreadyUpdated(respIDs), RespondentStatusTypes.AlreadyProcessed)
        End If

    End Sub

    Private Sub ExcludeRespondentsMissingStartCodes(ByVal importDate As Date)

        Dim respIDs As String = String.Empty

        For Each resp As UpdateRespondent In mRespondents
            'Add this respondent to the list
            If resp.Status = RespondentStatusTypes.CanUpdate Then
                If respIDs.Length > 0 Then respIDs &= ","
                respIDs &= resp.RespondentID
            End If

            'We cannot exceed 7700 characters in the respondent id list
            If respIDs.Length > 7650 Then
                'We need to check the respondents we have so far
                mRespondents.ChangeStatus(UpdateRespondent.GetByMissingStartCodes(respIDs, importDate), RespondentStatusTypes.StartCodesMissing)
                respIDs = String.Empty
            End If
        Next

        'Update the missing event codes for any remaining respondents
        If respIDs.Length > 0 Then
            mRespondents.ChangeStatus(UpdateRespondent.GetByMissingStartCodes(respIDs, importDate), RespondentStatusTypes.StartCodesMissing)
        End If

    End Sub

#End Region

End Class