Imports Nrc.QualiSys.Library.DataProvider
Imports Nrc.Framework.BusinessLogic

Public Interface ISiteGroup
    Property Id() As Integer
End Interface


Public Class SiteGroup
    Inherits Nrc.Framework.BusinessLogic.BusinessBase(Of SiteGroup)
    Implements ISiteGroup

#Region "Private Members"
    <NotUndoable()> Private mInstanceGuid As Guid = Guid.NewGuid
    Private mId As Integer
    Private mSiteGroup_ID As Integer
    Private mAssigned_id As Integer
    Private mGroupName As String
    Private mAddr1 As String
    Private mAddr2 As String
    Private mCity As String
    Private mState As String
    Private mZip5 As String
    Private mPhone As String
    Private mGroupOwnerShip As String
    Private mGroupContactName As String
    Private mGroupContactPhone As String
    Private mGroupContactEmail As String
    Private mMasterGroup_id As Integer
    Private mMasterGroupName As String
    Private mIsActive As Boolean
    Private mPracticeSites As PracticeSiteList

#End Region


#Region "Public Properties"
    <Logable()> _
    Public Property Id As Integer Implements ISiteGroup.Id
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

    Public Property AssignedID As Integer
        Get
            Return mAssigned_id
        End Get
        Set(value As Integer)
            If mAssigned_id = value Then
                Return
            End If
            mAssigned_id = value
        End Set
    End Property
    Public Property GroupName As String
        Get
            Return mGroupName
        End Get
        Set(value As String)
            If mGroupName = value Then
                Return
            End If
            mGroupName = value
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
            Return mState
        End Get
        Set(value As String)
            If mState = value Then
                Return
            End If
            mState = value
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
    Public Property GroupOwnerShip As String
        Get
            Return mGroupOwnerShip
        End Get
        Set(value As String)
            If mGroupOwnerShip = value Then
                Return
            End If
            mGroupOwnerShip = value
        End Set
    End Property
    Public Property GroupContactName As String
        Get
            Return mGroupContactName
        End Get
        Set(value As String)
            If mGroupContactName = value Then
                Return
            End If
            mGroupContactName = value
        End Set
    End Property
    Public Property GroupContactPhone As String
        Get
            Return mGroupContactPhone
        End Get
        Set(value As String)
            If mGroupContactPhone = value Then
                Return
            End If
            mGroupContactPhone = value
        End Set
    End Property
    Public Property GroupContactEmail As String
        Get
            Return mGroupContactEmail
        End Get
        Set(value As String)
            If mGroupContactEmail = value Then
                Return
            End If
            mGroupContactEmail = value
        End Set
    End Property
    Public Property MasterGroupID As Integer
        Get
            Return mMasterGroup_id
        End Get
        Set(value As Integer)
            If mMasterGroup_id = value Then
                Return
            End If
            mMasterGroup_id = value
        End Set
    End Property
    Public Property MasterGroupName As String
        Get
            Return mMasterGroupName
        End Get
        Set(value As String)
            If mMasterGroupName = value Then
                Return
            End If
            mMasterGroupName = value
        End Set
    End Property

    Public Property IsActive As Boolean
        Get
            Return mIsActive
        End Get
        Set(value As Boolean)
            If mIsActive = Value Then
                Return
            End If
            mIsActive = Value
        End Set
    End Property


    Public Property PracticeSites As PracticeSiteList
        Get
            Return mPracticeSites
        End Get
        Set(value As PracticeSiteList)           
            mPracticeSites = value
        End Set
    End Property
#End Region

#Region "Overrides"
    Protected Overrides Function GetIdValue() As Object
        If IsNew Then
            Return mInstanceGuid
        Else
            Return Id
        End If
    End Function

    Protected Overrides Sub Update()

    End Sub

    Protected Overrides Sub Insert()

    End Sub

    Protected Overrides Sub DeleteImmediate()

    End Sub

    Protected Overrides Sub CreateNew()

    End Sub
#End Region

#Region "Constructors"

    Private Sub New()

    End Sub

    Friend Sub New(ByVal id As Integer)
        Me.mId = id
    End Sub
#End Region


#Region " Factory Methods "
    Public Shared Function NewSiteGroup() As SiteGroup
        Dim obj As New SiteGroup
        obj.CreateNew()
        Return obj
    End Function
#End Region
#Region "DB CRUD"

    Public Shared Function GetAllSiteGroups() As DataSet
        Return FacilityProvider.Instance.SelectAllSiteGroups()
    End Function


#End Region


End Class
