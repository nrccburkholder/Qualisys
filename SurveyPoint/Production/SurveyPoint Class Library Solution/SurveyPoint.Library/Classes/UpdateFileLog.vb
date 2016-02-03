Imports Nrc.Framework.BusinessLogic
Imports Nrc.SurveyPoint.Library.DataProviders

Public Interface IUpdateFileLog
    Property FileLogID() As Integer
End Interface

Public Class UpdateFileLog
    Inherits BusinessBase(Of UpdateFileLog)
    Implements IUpdateFileLog

#Region " Private Fields "

    <NotUndoable()> Private mInstanceGuid As Guid = Guid.NewGuid
    Private mFileLogID As Integer
    Private mFileName As String
    Private mDateLoaded As Date
    Private mUserID As Integer
    Private mUserName As String
    Private mNumRecords As Integer
    Private mNumUpdated As Integer
    Private mNumMissingCodes As Integer
    Private mUpdateTypeID As Integer

    Private Shared mUpdateTypes As UpdateTypeCollection

#End Region

#Region " Public Properties "
    Public Property FileLogID() As Integer Implements IUpdateFileLog.FileLogID
        Get
            Return mFileLogID
        End Get
        Private Set(ByVal value As Integer)
            If Not value = mFileLogID Then
                mFileLogID = value
                PropertyHasChanged("FileLogID")
            End If
        End Set
    End Property

    Public Property FileName() As String
        Get
            Return mFileName
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mFileName Then
                mFileName = value
                PropertyHasChanged("FileName")
            End If
        End Set
    End Property

    Public Property DateLoaded() As Date
        Get
            Return mDateLoaded
        End Get
        Set(ByVal value As Date)
            If Not value = mDateLoaded Then
                mDateLoaded = value
                PropertyHasChanged("DateLoaded")
            End If
        End Set
    End Property

    Public Property UserID() As Integer
        Get
            Return mUserID
        End Get
        Set(ByVal value As Integer)
            If Not value = mUserID Then
                mUserID = value
                PropertyHasChanged("UserID")
            End If
        End Set
    End Property

    Public Property UserName() As String
        Get
            Return mUserName
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mUserName Then
                mUserName = value
                PropertyHasChanged("UserName")
            End If
        End Set
    End Property

    Public Property NumRecords() As Integer
        Get
            Return mNumRecords
        End Get
        Set(ByVal value As Integer)
            If Not value = mNumRecords Then
                mNumRecords = value
                PropertyHasChanged("NumRecords")
            End If
        End Set
    End Property

    Public Property NumUpdated() As Integer
        Get
            Return mNumUpdated
        End Get
        Set(ByVal value As Integer)
            If Not value = mNumUpdated Then
                mNumUpdated = value
                PropertyHasChanged("NumUpdated")
            End If
        End Set
    End Property

    Public Property NumMissingCodes() As Integer
        Get
            Return mNumMissingCodes
        End Get
        Set(ByVal value As Integer)
            If Not value = mNumMissingCodes Then
                mNumMissingCodes = value
                PropertyHasChanged("NumMissingCodes")
            End If
        End Set
    End Property

    Public Property UpdateTypeID() As Integer
        Get
            Return mUpdateTypeID
        End Get
        Set(ByVal value As Integer)
            If Not value = mUpdateTypeID Then
                mUpdateTypeID = value
                PropertyHasChanged("UpdateTypeID")
            End If
        End Set
    End Property

    Public ReadOnly Property UpdateTypeName() As String
        Get
            If mUpdateTypes Is Nothing Then
                mUpdateTypes = UpdateType.GetAll
            End If

            Dim typeName As String = String.Empty

            For Each updType As UpdateType In mUpdateTypes
                If updType.UpdateTypeID = mUpdateTypeID Then
                    typeName = updType.Name
                    Exit For
                End If
            Next

            Return typeName
        End Get
    End Property
#End Region

#Region " Constructors "

    Private Sub New()

        Me.CreateNew()

    End Sub

#End Region

#Region " Factory Methods "

    Public Shared Function NewUpdateFileLog() As UpdateFileLog

        Return New UpdateFileLog

    End Function

    Public Shared Function GetAll() As UpdateFileLogCollection

        Return UpdateFileLogProvider.Instance.SelectAll()

    End Function

    Public Shared Function GetByDate(ByVal minDate As Date, ByVal maxDate As Date) As UpdateFileLogCollection

        Return UpdateFileLogProvider.Instance.SelectByDate(minDate, maxDate)

    End Function

    Public Shared Function GetUpdatedRespondents(ByVal fileLogID As Integer) As String()

        Return UpdateFileLogProvider.Instance.SelectAllUpdatedRespondents(fileLogID)

    End Function
#End Region

#Region " Basic Overrides "

    Protected Overrides Function GetIdValue() As Object
        If Me.IsNew Then
            Return mInstanceGuid
        Else
            Return mFileLogID
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

    Protected Overrides Sub Insert()

        UpdateFileLogProvider.Instance.Insert(Me)

    End Sub

    Public Overloads Shared Sub Insert(ByVal fileName As String, ByVal numRecords As Integer, ByVal numUpdated As Integer, ByVal numMissingCodes As Integer, ByVal updateTypeID As Integer, ByVal userID As Integer, ByVal userName As String, ByVal respondents As UpdateRespondentCollection)

        'Insert the log entry
        Dim log As UpdateFileLog = NewUpdateFileLog()
        With log
            .FileName = fileName
            .NumRecords = numRecords
            .NumUpdated = numUpdated
            .NumMissingCodes = numMissingCodes
            .UpdateTypeID = updateTypeID
            .UserID = userID
            .UserName = userName
        End With
        log.Insert()

        'Insert the respondent ids
        For Each resp As UpdateRespondent In respondents
            If resp.Status = RespondentStatusTypes.Updated OrElse resp.Status = RespondentStatusTypes.InsertedMissingCodeUpdated Then
                Try
                    UpdateFileLogProvider.Instance.InsertRespondent(resp.RespondentID, log.FileLogID)
                Catch ex As Exception
                    resp.Status = RespondentStatusTypes.StartCodesMissing
                End Try
            End If
        Next

    End Sub
#End Region

#Region " Public Methods "

#End Region

End Class