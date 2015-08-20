
Imports Nrc.QualiSys.Library.DataProvider
Imports Nrc.Framework.BusinessLogic

Public Interface IPracticeSite
    Property Id() As Integer
End Interface


Public Class PracticeSite
    Inherits Nrc.Framework.BusinessLogic.BusinessBase(Of PracticeSite)
    Implements IPracticeSite

#Region "Private members"
    <NotUndoable()> Private mInstanceGuid As Guid = Guid.NewGuid
    Private mId As Integer
    Private mPracticeSite_ID As Integer
    Private mAssignedID As String
    Private mSiteGroup_ID As Integer
    Private mPracticeName As String
    Private mAddr1 As String
    Private mAddr2 As String
    Private mCity As String
    Private mST As String
    Private mZip5 As String
    Private mPhone As String
    Private mPracticeOwnership As String
    Private mPatVisitsWeek As Integer
    Private mProvWorkWeek As Integer
    Private mPracticeContactName As String
    Private mPracticeContactPhone As String
    Private mPracticeContactEmail As String
    Private mSampleUnit_id? As Integer
    Private mbitActive As Boolean
#End Region

#Region "Public Properties"

    <Logable()> _
    Public Property Id As Integer Implements IPracticeSite.Id
        Get
            Return mId
        End Get
        Set(value As Integer)
            If mId <> value Then
                mId = value
                PropertyHasChanged()
            End If
        End Set
    End Property

    Public Property PracticeSite_ID As Integer
        Get
            Return mPracticeSite_ID
        End Get
        Set(value As Integer)
            If mPracticeSite_ID = value Then
                Return
            End If
            mPracticeSite_ID = value
        End Set
    End Property
    Public Property AssignedID As String
        Get
            Return mAssignedID
        End Get
        Set(value As String)
            If mAssignedID = value Then
                Return
            End If
            mAssignedID = value
        End Set
    End Property
    Public Property SiteGroup_ID As Integer
        Get
            Return mSiteGroup_ID
        End Get
        Set(value As Integer)
            If mSiteGroup_ID = value Then
                Return
            End If
            mSiteGroup_ID = value
        End Set
    End Property
    Public Property PracticeName As String
        Get
            Return mPracticeName
        End Get
        Set(value As String)
            If mPracticeName = value Then
                Return
            End If
            mPracticeName = value
        End Set
    End Property
    Public Property Addr1 As String
        Get
            Return mAddr1
        End Get
        Set(value As String)
            If mAddr1 = value Then
                Return
            End If
            mAddr1 = value
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
    Public Property ST As String
        Get
            Return mST
        End Get
        Set(value As String)
            If mST = value Then
                Return
            End If
            mST = value
        End Set
    End Property
    Public Property Zip5 As String
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
    Public Property Phone As String
        Get
            Return mPhone
        End Get
        Set(value As String)
            If mPhone = value Then
                Return
            End If
            mPhone = value
        End Set
    End Property
    Public Property PracticeOwnership As String
        Get
            Return mPracticeOwnership
        End Get
        Set(value As String)
            If mPracticeOwnership = value Then
                Return
            End If
            mPracticeOwnership = value
        End Set
    End Property
    Public Property PatVisitsWeek As Integer
        Get
            Return mPatVisitsWeek
        End Get
        Set(value As Integer)
            If mPatVisitsWeek = value Then
                Return
            End If
            mPatVisitsWeek = value
        End Set
    End Property
    Public Property ProvWorkWeek As Integer
        Get
            Return mProvWorkWeek
        End Get
        Set(value As Integer)
            If mProvWorkWeek = value Then
                Return
            End If
            mProvWorkWeek = value
        End Set
    End Property
    Public Property PracticeContactName As String
        Get
            Return mPracticeContactName
        End Get
        Set(value As String)
            If mPracticeContactName = value Then
                Return
            End If
            mPracticeContactName = value
        End Set
    End Property
    Public Property PracticeContactPhone As String
        Get
            Return mPracticeContactPhone
        End Get
        Set(value As String)
            If mPracticeContactPhone = value Then
                Return
            End If
            mPracticeContactPhone = value
        End Set
    End Property
    Public Property PracticeContactEmail As String
        Get
            Return mPracticeContactEmail
        End Get
        Set(value As String)
            If mPracticeContactEmail = value Then
                Return
            End If
            mPracticeContactEmail = value
        End Set
    End Property
    Public Property SampleUnit_id As Integer?
        Get
            Return mSampleUnit_id
        End Get
        Set(value As Integer?)
            If mSampleUnit_id = value Then
                Return
            End If
            mSampleUnit_id = value
        End Set
    End Property
    Public Property bitActive As Boolean
        Get
            Return mbitActive
        End Get
        Set(value As Boolean)
            If mbitActive = value Then
                Return
            End If
            mbitActive = value
        End Set
    End Property

#End Region


#Region "Constructors"

    Public Sub New()

    End Sub

    Friend Sub New(ByVal id As Integer)
        Me.mId = id
    End Sub
#End Region



#Region "Overrides"
    Protected Overrides Function GetIdValue() As Object
        If IsNew Then
            Return mInstanceGuid
        Else
            Return Id
        End If
    End Function
#End Region


#Region " Factory Methods "
    Public Shared Function NewPracticeSite() As PracticeSite
        Dim obj As New PracticeSite
        obj.CreateNew()
        Return obj
    End Function
#End Region

End Class
