<DebuggerDisplay("{Name} ({Id})")> _
Public Class ACOCAHPSExport

#Region " Private Fields "

    Private mSurveyId As Integer
    Private mFinder As String = String.Empty '1 8
    Private mACO_Id As String = String.Empty '9 5
    Private mDispositn As String = "10" '14 2
    Private mMode As String = "8" '16 1
    Private mDispo_Lang As String = "8" '17 1
    Private mReceived As String = "88888888" '18 8 yyyymmdd
    Private mFocalType As String = "1" '26 1
    Private mPRTitle As String = String.Empty '27 35
    Private mPRFName As String = String.Empty '62 30
    Private mPRLName As String = String.Empty '92 50
    Private mBitComplete As System.Nullable(Of Boolean) = Nothing
    Private mQs As List(Of String) = Nothing

    'Private mQ(0) As String
    'Private mQ1 As String = "M " '142 2
    'Private mQ2 As String = "M " '144 2
    'Private mQ3 As String = "M " '146 2
    'Private mQ4 As String = "M " '148 2
    'Private mQ5 As String = "M " '150 2
    'Private mQ6 As String = "M " '152 2
    'Private mQ7 As String = "M " '154 2
    'Private mQ8 As String = "M " '156 2
    'Private mQ9 As String = "M " '158 2
    'Private mQ10 As String = "M " '160 2

#End Region

#Region " Public Properties "

    Public Property SurveyId() As Integer
        Get
            Return mSurveyId
        End Get
        Set(ByVal value As Integer)
            If mSurveyId <> value Then
                mSurveyId = value
            End If
        End Set
    End Property

    Public Property Finder() As String 
        Get
            Return mFinder
        End Get
        Set(ByVal value As String)
            mFinder = value
        End Set
    End Property

    Public Property ACO_Id() As String
        Get
            Return mACO_Id
        End Get
        Set(ByVal value As String)
            mACO_Id = value
        End Set
    End Property

    Public Property Dispositn() As String
        Get
            Return mDispositn
        End Get
        Set(ByVal value As String)
            mDispositn = value
        End Set
    End Property

    Public Property Mode() As String
        Get
            Return mMode
        End Get
        Set(ByVal value As String)
            mMode = value
        End Set
    End Property

    Public Property Dispo_Lang() As String
        Get
            Return mDispo_Lang
        End Get
        Set(ByVal value As String)
            mDispo_Lang = value
        End Set
    End Property

    Public Property Received() As String
        Get
            Return mReceived
        End Get
        Set(ByVal value As String)
            mReceived = value
        End Set
    End Property

    Public Property FocalType() As String
        Get
            Return mFocalType
        End Get
        Set(ByVal value As String)
            mFocalType = value
        End Set
    End Property

    Public Property PRTitle() As String
        Get
            Return mPRTitle
        End Get
        Set(ByVal value As String)
            mPRTitle = value
        End Set
    End Property

    Public Property PRFName() As String
        Get
            Return mPRFName
        End Get
        Set(ByVal value As String)
            mPRFName = value
        End Set
    End Property

    Public Property PRLName() As String
        Get
            Return mPRLName
        End Get
        Set(ByVal value As String)
            mPRLName = value
        End Set
    End Property

    Public Property BitComplete() As System.Nullable(Of Boolean)
        Get
            Return mBitComplete
        End Get
        Set(ByVal value As System.Nullable(Of Boolean))
            mBitComplete = value
        End Set
    End Property

    Public Property Qs() As List(Of String)
        Get
            Return mQs
        End Get
        Set(ByVal value As List(Of String))
            mQs = value
        End Set
    End Property

#End Region

End Class
