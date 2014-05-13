<Serializable()> _
Public Class NameSub

#Region " Private Members "

    Private mTitle As String = String.Empty
    Private mFirstName As String = String.Empty
    Private mMiddleInitial As String = String.Empty
    Private mLastName As String = String.Empty
    Private mSuffix As String = String.Empty
    Private mNameStatus As String = String.Empty

#End Region

#Region " Public Properties "

    Public Property Title() As String
        Get
            Return mTitle
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mTitle Then
                mTitle = value
            End If
        End Set
    End Property

    Public Property FirstName() As String
        Get
            Return mFirstName
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mFirstName Then
                mFirstName = value
            End If
        End Set
    End Property

    Public Property MiddleInitial() As String
        Get
            Return mMiddleInitial
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mMiddleInitial Then
                mMiddleInitial = value
            End If
        End Set
    End Property

    Public Property LastName() As String
        Get
            Return mLastName
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mLastName Then
                mLastName = value
            End If
        End Set
    End Property

    Public Property Suffix() As String
        Get
            Return mSuffix
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mSuffix Then
                mSuffix = value
            End If
        End Set
    End Property

    Public Property NameStatus() As String
        Get
            Return mNameStatus
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mNameStatus Then
                mNameStatus = value
            End If
        End Set
    End Property

#End Region

End Class