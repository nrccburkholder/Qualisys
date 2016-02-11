Imports Nrc.Framework.BusinessLogic
Imports System.IO

Public Interface IVRTDispositionWest
    Property VRTID() As Integer
End Interface

<Serializable()> _
Public Class VRTDispositionWest
    Inherits BusinessBase(Of VRTDispositionWest)
    Implements IVRTDispositionWest

#Region " Private Fields "
    <NotUndoable()> Private mInstanceGuid As Guid = Guid.NewGuid
    Private mVRTID As Integer
    Private mrespondentID As Integer
    Private mCallOutcome As String = String.Empty
    Private mDateTimeStamp As String = String.Empty
    Private mCallType As String = String.Empty
#End Region

#Region " Public Properties "
    Public Property VRTID() As Integer Implements IVRTDispositionWest.VRTID
        Get
            Return mVRTID
        End Get
        Private Set(ByVal value As Integer)
            If Not value = mVRTID Then
                mVRTID = value
                PropertyHasChanged("VRTID")
            End If
        End Set
    End Property
    Public Property RespondentID() As Integer
        Get
            Return Me.mrespondentID
        End Get
        Set(ByVal value As Integer)
            If Not (Me.mrespondentID = value) Then
                Me.mrespondentID = value
                PropertyHasChanged("RespondentID")
            End If
        End Set
    End Property
    Public Property CallOutcome() As String
        Get
            Return Me.mCallOutcome
        End Get
        Set(ByVal value As String)
            If Not (Me.mCallOutcome = value) Then
                Me.mCallOutcome = value
                PropertyHasChanged("CallOutcome")
            End If
        End Set
    End Property
    Public Property DateTimeStamp() As String
        Get
            Return Me.mDateTimeStamp
        End Get
        Set(ByVal value As String)
            If Not (Me.mDateTimeStamp = value) Then
                Me.mDateTimeStamp = value
                PropertyHasChanged("DateTimeStamp")
            End If
        End Set
    End Property
    Public Property CallType() As String
        Get
            Return Me.mCallType
        End Get
        Set(ByVal value As String)
            If Not (Me.mCallType = value) Then
                Me.mCallType = value
                PropertyHasChanged("CallType")
            End If
        End Set
    End Property
#End Region

#Region " Constructors "
    Private Sub New(ByVal respID As Integer, ByVal callOutcome As String, ByVal datetimestamp As String, ByVal CallType As String)
        Me.mrespondentID = respID
        Me.mCallOutcome = callOutcome
        Me.mDateTimeStamp = datetimestamp
        Me.mCallType = CallType.ToUpper()
        Me.CreateNew()
    End Sub
    Private Sub New()
        Me.CreateNew()
    End Sub
#End Region

#Region " Factory Methods "
    Public Shared Function NewVRTDispositionWest(ByVal respID As Integer, ByVal callOutcome As String, _
    ByVal dateTimeStamp As String, ByVal CallType As String) As VRTDispositionWest
        Return New VRTDispositionWest(respID, callOutcome, dateTimeStamp, CallType)
    End Function
#End Region

#Region " Basic Overrides "
    Protected Overrides Function GetIdValue() As Object
        If Me.IsNew Then
            Return mInstanceGuid
        Else
            Return mVRTID
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
        'ValidationRules.CheckRules()
    End Sub

    Protected Overrides Sub Insert()
        Throw New NotImplementedException
    End Sub

    Protected Overrides Sub Update()
        Throw New NotImplementedException
    End Sub

    Protected Overrides Sub DeleteImmediate()
        Throw New NotImplementedException
    End Sub
    Public Overrides Sub Save()
        Throw New NotImplementedException
    End Sub
#End Region

#Region " Public Methods "
    Public Function ImportLine(ByVal index As Integer) As String
        Dim retVal As String = String.Empty
        Try
            retVal = ValidateObject(index)
            If retVal = "" Then
                retVal = SPImportLine(index)
            End If

        Catch ex As Exception
            retVal = "Line " & index & " error: " & ex.Message
        End Try
        Return retVal
    End Function
    Private Function ValidateObject(ByVal Index As Integer) As String
        Dim RetVal As String = ""
        If Not ParseDateTimeStamp().HasValue Then
            Return "DateTimeStamp has an incorrect format."
        End If
        If RespondentID <= 0 Then
            Return "An invalid respondentID was given."
        End If
        Return RetVal
    End Function
    Private Function ParseDateTimeStamp() As Nullable(Of DateTime)
        Dim retVal As Nullable(Of DateTime)
        Try
            Dim strArray() As String = Me.DateTimeStamp.Split("."c)
            If IsDate((strArray(1) & "/" & strArray(2) & "/" & strArray(0) & " " & strArray(3) & ":" & strArray(4) & ":" & strArray(5))) Then
                retVal = CDate((strArray(1) & "/" & strArray(2) & "/" & strArray(0) & " " & strArray(3) & ":" & strArray(4) & ":" & strArray(5)))
            End If

        Catch ex As Exception
            Return retVal
        End Try
        Return retVal
    End Function
    Private Function SPImportLine(ByVal index As Integer) As String
        Dim RetVal As String = "'"
        Try
            RetVal = DataProviders.VRTDispositionWestProvider.Instance.ImportVRTDisposition(index, Me)
        Catch ex As Exception
            RetVal = "Line " & index & " errored: " & ex.Message
        End Try
        Return RetVal
    End Function
#End Region

End Class