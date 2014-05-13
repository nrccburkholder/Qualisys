''' <summary>
''' Represents a users personal information
''' </summary>
<Serializable()> _
Public Class Profile

#Region " Private Members "
    Private mFirstName As String
    Private mLastName As String
    Private mOccupationalTitle As String
    Private mEmailAddress As String
    Private mPhoneNumber As String
    Private mCity As String
    Private mState As String
#End Region

#Region " Public Properties "
    ''' <summary>
    ''' The user's first name
    ''' </summary>
    Public Property FirstName() As String
        Get
            Return mFirstName
        End Get
        Set(ByVal value As String)
            mFirstName = value
        End Set
    End Property
    ''' <summary>
    ''' The user's last name
    ''' </summary>
    Public Property LastName() As String
        Get
            Return mLastName
        End Get
        Set(ByVal value As String)
            mLastName = value
        End Set
    End Property
    ''' <summary>
    ''' The user's title
    ''' </summary>
    Public Property OccupationalTitle() As String
        Get
            Return mOccupationalTitle
        End Get
        Set(ByVal value As String)
            mOccupationalTitle = value
        End Set
    End Property
    ''' <summary>
    ''' The user's email address
    ''' </summary>
    Public Property EmailAddress() As String
        Get
            Return mEmailAddress
        End Get
        Set(ByVal value As String)
            mEmailAddress = value
        End Set
    End Property
    ''' <summary>
    ''' The user's phone number
    ''' </summary>
    Public Property PhoneNumber() As String
        Get
            Return mPhoneNumber
        End Get
        Set(ByVal value As String)
            mPhoneNumber = value
        End Set
    End Property
    ''' <summary>
    ''' The user's city
    ''' </summary>
    Public Property City() As String
        Get
            Return mCity
        End Get
        Set(ByVal value As String)
            mCity = value
        End Set
    End Property
    ''' <summary>
    ''' The user's state
    ''' </summary>
    Public Property State() As String
        Get
            Return mState
        End Get
        Set(ByVal value As String)
            mState = value
        End Set
    End Property
#End Region

#Region " Constructors "
    Public Sub New()

    End Sub
#End Region
End Class
