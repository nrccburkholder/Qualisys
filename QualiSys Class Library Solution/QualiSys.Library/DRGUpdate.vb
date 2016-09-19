Imports System.Collections.ObjectModel

Public Class DRGUpdate


#Region "private members"

    Private mDataFileID As Integer
    Private mStudyID As Integer
    Private mOrigFileName As String = String.Empty
    Private mDatMinEncounter As DateTime = DateTime.MinValue
    Private mDatMaxEncounter As DateTime = DateTime.MinValue
    Private mLoadedBy As String = String.Empty
    Private mMemberID As Integer
    Private mIsRollback As Boolean
    Private mStatus As String = String.Empty

#End Region

#Region "public properties"

    Public Property DataFileID As Integer
        Get
            Return mDataFileID
        End Get
        Set(value As Integer)
            mDataFileID = value
        End Set
    End Property

    Public Property StudyID As Integer
        Get
            Return mStudyID
        End Get
        Set(value As Integer)
            mStudyID = value
        End Set
    End Property

    Public Property OrigFileName As String
        Get
            Return mOrigFileName
        End Get
        Set(value As String)
            mOrigFileName = value
        End Set
    End Property

    Public Property DatMinEncounter As DateTime
        Get
            Return mDatMinEncounter
        End Get
        Set(value As DateTime)
            mDatMinEncounter = value
        End Set
    End Property

    Public Property DatMaxEncounter As DateTime
        Get
            Return mDatMaxEncounter
        End Get
        Set(value As DateTime)
            mDatMaxEncounter = value
        End Set
    End Property

    Public Property LoadedBy As String
        Get
            Return mLoadedBy
        End Get
        Set(value As String)
            mLoadedBy = value
        End Set
    End Property

    Public Property MemberID As Integer
        Get
            Return mMemberID
        End Get
        Set(value As Integer)
            mMemberID = value
        End Set
    End Property

    Public Property IsRollback As Boolean
        Get
            Return mIsRollback
        End Get
        Set(value As Boolean)
            mIsRollback = value
        End Set
    End Property

    Public Property Status As String
        Get
            Return mStatus
        End Get
        Set(value As String)
            mStatus = value
        End Set
    End Property


#End Region

#Region "constructors"

    Public Sub New()

    End Sub


#End Region

#Region "shared methods"

    Public Shared Function SelectDRGUpdates(ByVal studyid As Integer) As Collection(Of DRGUpdate)

        Return DataProvider.DRGUpdateProvider.Instance.Select(studyid)

    End Function

    Public Shared Function RollbackDRGUpdates(ByVal datafile As DRGUpdate) As DataTable

        Return DataProvider.DRGUpdateProvider.Instance.Rollback(datafile)

    End Function

    Public Shared Sub UpdateFileState(ByVal datafile_id As Integer, ByVal State_id As Integer, ByVal StateParameter As String, ByVal StateDescription As String, ByVal Member_id As Integer)

        DataProvider.DRGUpdateProvider.Instance.UpdateFileStateDRG(datafile_id, State_id, StateParameter, StateDescription, Member_id)

    End Sub

#End Region

End Class
