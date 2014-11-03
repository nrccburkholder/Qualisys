Imports Nrc.QualiSys.Library.DataProvider
Imports System.ComponentModel
Imports System.Data.SqlClient

Public Class USPS_PartialMatch

#Region "Properties"

    Private mId As Integer
    Private mExtractFileID As Integer
    Private mStudy_id As Integer
    Private mPop_id As Integer
    Private mLithocode As String
    Private mStatus As String
    Private mFirstName As String
    Private mLastName As String
    Private mAddr As String
    Private mAddr2 As String
    Private mCity As String
    Private mState As String
    Private mZip As String
    Private mOldAddress As USPS_Address
    Private mNewAddress As USPS_Address

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
    Public Property ExtractFileID As Integer
        Get
            Return mExtractFileID
        End Get
        Set(value As Integer)
            If mExtractFileID = value Then
                Return
            End If
            mExtractFileID = value
        End Set
    End Property
    Public Property Study_id As Integer
        Get
            Return mStudy_id
        End Get
        Set(value As Integer)
            If mStudy_id = value Then
                Return
            End If
            mStudy_id = value
        End Set
    End Property
    Public Property Pop_id As Integer
        Get
            Return mPop_id
        End Get
        Set(value As Integer)
            If mPop_id = value Then
                Return
            End If
            mPop_id = value
        End Set
    End Property
    Public Property Lithocode As String
        Get
            Return mLithocode
        End Get
        Set(value As String)
            If mLithocode = value Then
                Return
            End If
            mLithocode = value
        End Set
    End Property
    Public Property Status As String
        Get
            Return mStatus
        End Get
        Set(value As String)
            If mStatus = value Then
                Return
            End If
            mStatus = value
        End Set
    End Property
    Public Property FirstName As String
        Get
            Return mFirstName
        End Get
        Set(value As String)
            If mFirstName = value Then
                Return
            End If
            mFirstName = value
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
    Public Property Addr As String
        Get
            Return mAddr
        End Get
        Set(value As String)
            If mAddr = value Then
                Return
            End If
            mAddr = value
        End Set
    End Property
    Public Property Addr2 As String
        Get
            Return mAddr2
        End Get
        Set(value As String)
            If mAddr2 = value Then
                Return
            End If
            mAddr2 = value
        End Set
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
            Return mZip
        End Get
        Set(value As String)
            If mZip = value Then
                Return
            End If
            mZip = value
        End Set
    End Property

    Public Property OldAddress As USPS_Address
        Get
            Return mOldAddress
        End Get
        Set(value As USPS_Address)
            mOldAddress = value
        End Set
    End Property
    Public Property NewAddress As USPS_Address
        Get
            Return mNewAddress
        End Get
        Set(value As USPS_Address)    
            mNewAddress = value
        End Set
    End Property
#End Region
#Region "Constructors"
    Public Sub New()

    End Sub
#End Region

#Region "Public Methods"
    Public Shared Function GetPartialMatches(ByVal status As Integer) As List(Of USPS_PartialMatch)
        Return USPS_ACS_Provider.Instance.SelectByStatus(status)
    End Function

    Public Shared Function GetPartialMatchesDataSet(ByVal status As Integer) As DataSet

        Dim ds As New DataSet()
        ds = USPS_ACS_Provider.Instance.SelectPartialMatchesByStatus(status)

        'Set up a master-detail relationship between the DataTables
        Dim keyColumn As DataColumn = ds.Tables(0).Columns("Id")
        Dim foreignKeyColumn1 As DataColumn = ds.Tables(1).Columns("Id")
        'Dim foreignKeyColumn2 As DataColumn = ds.Tables(2).Columns("USPS_ACS_ExtractFile_PartialMatch_id")

        ds.Relations.Add("FK_PopAddress_OldAddress", keyColumn, foreignKeyColumn1)
        'ds.Relations.Add("FK_PopAddress_NewAddress", keyColumn, foreignKeyColumn2)


        Return ds

    End Function
#End Region

End Class
