Imports Nrc.Framework.BusinessLogic
Imports System.IO

Public Interface IVRTDisposition
    Property VRTID() As Integer
End Interface

<Serializable()> _
Public Class VRTDisposition
    Inherits BusinessBase(Of VRTDisposition)
    Implements IVRTDisposition

#Region " Private Fields "
    <NotUndoable()> Private mInstanceGuid As Guid = Guid.NewGuid
    Private mVRTID As Integer
    Private mrespondentID As Integer
    Private mPhoneNumber As String = String.Empty
    Private mCallDate1 As Nullable(Of DateTime) = Nothing
    Private mCallDate2 As Nullable(Of DateTime) = Nothing
    Private mCallDate3 As Nullable(Of DateTime) = Nothing
    Private mCallCode1 As String = String.Empty
    Private mCallCode2 As String = String.Empty
    Private mCallCode3 As String = String.Empty
#End Region

#Region " Public Properties "
    Public Property VRTID() As Integer Implements IVRTDisposition.VRTID
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
    Public Property PhoneNumber() As String
        Get
            Return Me.mPhoneNumber
        End Get
        Set(ByVal value As String)
            If Not (Me.mPhoneNumber = value) Then
                Me.mPhoneNumber = value
                PropertyHasChanged("PhoneNumber")
            End If
        End Set
    End Property
    Public Property CallCode1() As String
        Get
            Return Me.mCallCode1
        End Get
        Set(ByVal value As String)
            If Not (Me.mCallCode1 = value) Then
                Me.mCallCode1 = value
                PropertyHasChanged("CallCode1")
            End If
        End Set
    End Property
    Public Property CallCode2() As String
        Get
            Return Me.mCallCode2
        End Get
        Set(ByVal value As String)
            If Not (Me.mCallCode2 = value) Then
                Me.mCallCode2 = value
                PropertyHasChanged("CallCode2")
            End If
        End Set
    End Property
    Public Property CallCode3() As String
        Get
            Return Me.mCallCode3
        End Get
        Set(ByVal value As String)
            If Not (Me.mCallCode3 = value) Then
                Me.mCallCode3 = value
                PropertyHasChanged("CallCode3")
            End If
        End Set
    End Property
    Public Property CallDate1() As Nullable(Of DateTime)
        Get
            Return Me.mCallDate1
        End Get
        Set(ByVal value As Nullable(Of DateTime))
            Me.mCallDate1 = value
        End Set
    End Property
    Public Property CallDate2() As Nullable(Of DateTime)
        Get
            Return Me.mCallDate2
        End Get
        Set(ByVal value As Nullable(Of DateTime))
            Me.mCallDate2 = value
        End Set
    End Property
    Public Property CallDate3() As Nullable(Of DateTime)
        Get
            Return Me.mCallDate3
        End Get
        Set(ByVal value As Nullable(Of DateTime))
            Me.mCallDate3 = value
        End Set
    End Property

#End Region

#Region " Constructors "
    Private Sub New(ByVal respID As Integer, ByVal phoneNumber As String, ByVal callCode1 As String, ByVal callCode2 As String, ByVal callCode3 As String, _
    ByVal callDate1 As Nullable(Of DateTime), ByVal callDate2 As Nullable(Of DateTime), ByVal callDate3 As Nullable(Of DateTime))
        Me.mrespondentID = respID
        Me.mPhoneNumber = phoneNumber
        Me.mCallCode1 = callCode1
        Me.mCallCode2 = callCode2
        Me.mCallCode3 = callCode3
        Me.mCallDate1 = callDate1
        Me.mCallDate2 = callDate2
        Me.mCallDate3 = callDate3
        Me.CreateNew()
    End Sub
    Private Sub New()        
        Me.CreateNew()
    End Sub
#End Region

#Region " Factory Methods "
    Public Shared Function NewVRTDisposition(ByVal respID As Integer, ByVal phoneNumber As String, _
    ByVal callCode1 As String, ByVal callCode2 As String, ByVal callCode3 As String, ByVal calldate1 As Nullable(Of DateTime), _
    ByVal callDate2 As Nullable(Of DateTime), ByVal callDate3 As Nullable(Of DateTime)) As VRTDisposition
        Return New VRTDisposition(respID, phoneNumber, callCode1, callCode2, callCode3, calldate1, callDate2, callDate3)
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
            retVal = ValidateLine(index)
            If retVal = "" Then
                retVal = SPImportLine(index)
            End If

        Catch ex As Exception
            retVal = "Line " & index & " error: " & ex.Message
        End Try
        Return retVal
    End Function
    Private Function ValidateLine(ByVal Index As Integer) As String
        Dim RetVal As String = ""
        Dim lst As New List(Of String)
        lst.Add("")
        lst.Add("K0")
        lst.Add("K1")
        For i As Integer = 18 To 26
            lst.Add("K" & i)
        Next
        If lst.Contains(CallCode1) = False OrElse lst.Contains(CallCode2) = False OrElse lst.Contains(CallCode3) = False Then
            RetVal = "Line " & Index & " contains an invalid K Code."
        ElseIf (CallCode1 <> "" And CallDate1.HasValue = False) OrElse (CallCode2 <> "" And CallDate2.HasValue = False) OrElse (CallCode3 <> "" And CallDate3.HasValue = False) Then
            RetVal = "Line " & Index & " contains a K Code with no corresponding date."
        End If
        Return RetVal
    End Function
    Private Function SPImportLine(ByVal index As Integer) As String
        Dim RetVal As String = "'"
        Try
            RetVal = DataProviders.VRTDispositionProvider.Instance.ImportVRTDisposition(index, Me)
        Catch ex As Exception
            RetVal = "Line " & index & " errored: " & ex.Message
        End Try
        Return RetVal
    End Function
#End Region

End Class