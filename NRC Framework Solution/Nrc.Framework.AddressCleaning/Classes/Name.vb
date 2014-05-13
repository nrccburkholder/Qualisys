Imports Nrc.Framework.BusinessLogic

<Serializable()> _
Public Class Name
    Inherits BusinessBase(Of Name)

#Region " Private Members "

    Private mInstanceGuid As Guid = Guid.NewGuid
    Private mDBKey As Integer
    Private mOriginalName As New NameSub
    Private mCleanedName As New NameSub
    Private mWorkingName As New NameSub

    Private mTitle As String = String.Empty
    Private mFirstName As String = String.Empty
    Private mMiddleInitial As String = String.Empty
    Private mLastName As String = String.Empty
    Private mSuffix As String = String.Empty
    Private mNewTitle As String = String.Empty
    Private mNewFirstName As String = String.Empty
    Private mNewMiddleInitial As String = String.Empty
    Private mNewLastName As String = String.Empty
    Private mNewSuffix As String = String.Empty
    Private mNameStatus As String = String.Empty

#End Region

#Region " Public ReadOnly Properties "

    Public ReadOnly Property OriginalName() As NameSub
        Get
            Return mOriginalName
        End Get
    End Property

    Public ReadOnly Property CleanedName() As NameSub
        Get
            Return mCleanedName
        End Get
    End Property

    Public ReadOnly Property WorkingName() As NameSub
        Get
            Return mWorkingName
        End Get
    End Property

#End Region

#Region " Friend properties "

    Friend Property DBKey() As Integer
        Get
            Return mDBKey
        End Get
        Set(ByVal value As Integer)
            If Not value = mDBKey Then
                mDBKey = value
                PropertyHasChanged("DBKey")
            End If
        End Set
    End Property

#End Region

#Region " Constructors "

    Private Sub New()

        CreateNew()

    End Sub

#End Region

#Region " Factory Methods "

    Public Shared Function NewName() As Name

        Return New Name

    End Function

#End Region

#Region " Basic Overrides "

    Protected Overrides Function GetIdValue() As Object

        If IsNew Then
            Return mInstanceGuid
        Else
            Return mDBKey
        End If

    End Function

#End Region

#Region " Validation Methods "

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

#Region " Friend Methods "

    Friend Sub SetCleanedTo(ByVal setToName As NameSub, ByVal nameStat As String)

        SetCleanedTo(setToName)

        mCleanedName.NameStatus = nameStat

    End Sub

    Friend Sub SetCleanedTo(ByVal setToName As NameSub)

        With mCleanedName
            .Title = CleanString(setToName.Title, True, True)
            .FirstName = CleanString(setToName.FirstName, True, True)
            .MiddleInitial = CleanString(setToName.MiddleInitial, True, True)
            .LastName = CleanString(setToName.LastName, True, True)
            .Suffix = CleanString(setToName.Suffix, True, True)
            .NameStatus = setToName.NameStatus
        End With

    End Sub

#End Region

End Class