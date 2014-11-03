Public Class USPS_Address



    Private mId As Integer
    Private mFName As String = String.Empty
    Private mLastName As String = String.Empty
    Private mPrimaryNumber As String = String.Empty
    Private mPreDirectional As String = String.Empty
    Private mStreetName As String = String.Empty
    Private mStreetSuffix As String = String.Empty
    Private mPostDirectional As String = String.Empty
    Private mUnitDesignator As String = String.Empty
    Private mSecondaryNumber As String = String.Empty
    Private mCity As String = String.Empty
    Private mState As String = String.Empty
    Private mZip5 As String = String.Empty
    Private mPlus4Zip As String = String.Empty


    Public Property Id As Integer
        Get
            Return mId
        End Get
        Set(value As Integer)
            If mId = value Then
                Return
            End If
            mId = value
        End Set
    End Property
    Public Property FirstName As String
        Get
            Return mFName
        End Get
        Set(value As String)
            If mFName = value Then
                Return
            End If
            mFName = value
        End Set
    End Property
    Public Property LastName As String
        Get
            Return mLastName
        End Get
        Set(value As String)
            If mLastName = value Then
                Return
            End If
            mLastName = value
        End Set
    End Property

    Public Property PrimaryNumber As String
        Get
            Return mPrimaryNumber
        End Get
        Set(value As String)
            If mPrimaryNumber = value Then
                Return
            End If
            mPrimaryNumber = value
        End Set
    End Property
    Public Property PreDirectional As String
        Get
            Return mPreDirectional
        End Get
        Set(value As String)
            If mPreDirectional = value Then
                Return
            End If
            mPreDirectional = value
        End Set
    End Property
    Public Property StreetName As String
        Get
            Return mStreetName
        End Get
        Set(value As String)
            If mStreetName = value Then
                Return
            End If
            mStreetName = value
        End Set
    End Property
    Public Property StreetSuffix As String
        Get
            Return mStreetSuffix
        End Get
        Set(value As String)
            If mStreetSuffix = value Then
                Return
            End If
            mStreetSuffix = value
        End Set
    End Property
    Public Property PostDirectional As String
        Get
            Return mPostDirectional
        End Get
        Set(value As String)
            If mPostDirectional = value Then
                Return
            End If
            mPostDirectional = value
        End Set
    End Property
    Public Property UnitDesignator As String
        Get
            Return mUnitDesignator
        End Get
        Set(value As String)
            If mUnitDesignator = value Then
                Return
            End If
            mUnitDesignator = value
        End Set
    End Property
    Public Property SecondaryNumber As String
        Get
            Return mSecondaryNumber
        End Get
        Set(value As String)
            If mSecondaryNumber = value Then
                Return
            End If
            mSecondaryNumber = value
        End Set
    End Property

    Public ReadOnly Property Addr As String
        Get
            Dim mAddr As String = String.Empty
            If mPrimaryNumber.Length > 0 Then
                mAddr = String.Format("{0}{1} ", mAddr, mPrimaryNumber)
            End If

            If mPreDirectional.Length > 0 Then
                mAddr = String.Format("{0}{1} ", mAddr, mPreDirectional)
            End If

            If mStreetName.Length > 0 Then
                mAddr = String.Format("{0}{1} ", mAddr, mStreetName)
            End If

            If mStreetSuffix.Length > 0 Then
                mAddr = String.Format("{0}{1} ", mAddr, mStreetSuffix)
            End If

            If mPostDirectional.Length > 0 Then
                mAddr = String.Format("{0}{1}", mAddr, mPostDirectional)
            End If
            Return mAddr
        End Get

    End Property
    Public ReadOnly Property Addr2 As String
        Get
            Dim mAddr2 As String = String.Empty

            If mUnitDesignator.Length > 0 Then
                mAddr2 = String.Format("{0}{1} ", mAddr2, mUnitDesignator)
            End If

            If mSecondaryNumber.Length > 0 Then
                mAddr2 = String.Format("{0}{1}", mAddr2, mSecondaryNumber)
            End If

            Return mAddr2
        End Get

    End Property

    Public Property City As String
        Get
            Return mCity
        End Get
        Set(value As String)
            If mCity = value Then
                Return
            End If
            mCity = value
        End Set
    End Property
    Public Property State As String
        Get
            Return mState
        End Get
        Set(value As String)
            If mState = value Then
                Return
            End If
            mState = value
        End Set
    End Property
    Public Property Zip As String
        Get
            Return mZip5
        End Get
        Set(value As String)
            If mZip5 = value Then
                Return
            End If
            mZip5 = value
        End Set
    End Property

    Public Property Plus4Zip As String
        Get
            Return mPlus4Zip
        End Get
        Set(value As String)
            If mPlus4Zip = value Then
                Return
            End If
            mPlus4Zip = value
        End Set
    End Property

#Region "Constructors"

    Public Sub New()

    End Sub

    Public Sub New(ByVal fId As Integer,
                    ByVal fFname As String,
                    ByVal fLastName As String,
                    ByVal fPrimaryNumber As String,
                    ByVal fPreDirectional As String,
                    ByVal fStreetName As String,
                    ByVal fStreetSuffix As String,
                    ByVal fPostDirectional As String,
                    ByVal fUnitDesignator As String,
                    ByVal fSecondaryNumber As String,
                    ByVal fCity As String,
                    ByVal fState As String,
                    ByVal fZip5 As String,
                    ByVal fPlus4Zip As String)

        mId = fId
        mFName = fFname
        mLastName = fLastName
        mPrimaryNumber = fPrimaryNumber
        mPreDirectional = fPreDirectional
        mStreetName = fStreetName
        mStreetSuffix = fStreetSuffix
        mPostDirectional = fPostDirectional
        mUnitDesignator = fUnitDesignator
        mSecondaryNumber = fSecondaryNumber
        mCity = fCity
        mState = fState
        mZip5 = fZip5
        mPlus4Zip = fPlus4Zip

    End Sub

#End Region

End Class
