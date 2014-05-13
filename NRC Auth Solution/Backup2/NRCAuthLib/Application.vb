Imports NRC.Data
''' <summary>
''' Represents an NRC application with secured access
''' </summary>
<AutoPopulate(), Serializable()> _
Public Class Application

#Region " Private Members "
    <SQLField("Application_id")> Private mApplicationId As Integer
    <SQLField("strApplication_nm")> Private mName As String
    <SQLField("strApplication_dsc")> Private mDescription As String
    <SQLField("bitInternal")> Private mIsInternalOnly As Boolean
    <SQLField("DeploymentType_id")> Private mDeploymentType As DeploymentType
    <SQLField("strPath")> Private mPath As String
    <SQLField("IconImage")> Private mImageData As Byte()
    <SQLField("strCategory_nm")> Private mCategory As String

    Private mPrivileges As New PrivilegeCollection
    Private mIsDirty As Boolean
#End Region

#Region " Public Properties "
    ''' <summary>
    ''' The database ID of the application
    ''' </summary>
    Public ReadOnly Property ApplicationId() As Integer
        Get
            Return mApplicationId
        End Get
    End Property
    ''' <summary>
    ''' The name of the application
    ''' </summary>
    Public Property Name() As String
        Get
            Return mName
        End Get
        Set(ByVal value As String)
            If mName <> value Then
                mName = value
                mIsDirty = True
            End If
        End Set
    End Property
    ''' <summary>
    ''' A description of the application
    ''' </summary>
    Public Property Description() As String
        Get
            Return mDescription
        End Get
        Set(ByVal value As String)
            If mDescription <> value Then
                mDescription = value
                mIsDirty = True
            End If
        End Set
    End Property
    ''' <summary>
    ''' Indicates the method for deploying this application
    ''' </summary>
    Public Property DeploymentType() As DeploymentType
        Get
            Return mDeploymentType
        End Get
        Set(ByVal value As DeploymentType)
            If mDeploymentType <> value Then
                mDeploymentType = value
                mIsDirty = True
            End If
        End Set
    End Property
    ''' <summary>
    ''' Inidicates the path for accessing this application
    ''' </summary>
    Public Property Path() As String
        Get
            Return mPath
        End Get
        Set(ByVal value As String)
            If mPath <> value Then
                mPath = value
                mIsDirty = True
            End If
        End Set
    End Property
    ''' <summary>
    ''' Indicates the icon to use for this application
    ''' </summary>
    Public Property ImageData() As Byte()
        Get
            Return mImageData
        End Get
        Set(ByVal value As Byte())
            mImageData = value
            mIsDirty = True
        End Set
    End Property
    ''' <summary>
    ''' Indicates the icon to use for this application
    ''' </summary>
    Public Property Category() As String
        Get
            Return mCategory
        End Get
        Set(ByVal value As String)
            If mCategory <> value Then
                mCategory = value
                mIsDirty = True
            End If
        End Set
    End Property
    ''' <summary>
    ''' Inidicates if the application is used only internally at NRC
    ''' </summary>
    Public Property IsInternalOnly() As Boolean
        Get
            Return mIsInternalOnly
        End Get
        Set(ByVal value As Boolean)
            If mIsInternalOnly <> value Then
                mIsInternalOnly = value
                mIsDirty = True
            End If
        End Set
    End Property
    ''' <summary>
    ''' The set of privileges for this application
    ''' </summary>
    Public ReadOnly Property Privileges() As PrivilegeCollection
        Get
            Return mPrivileges
        End Get
    End Property

    Public ReadOnly Property HasMemberLevelPrivileges() As Boolean
        Get
            For Each priv As Privilege In Me.Privileges
                If priv.PrivilegeLevel = Privilege.PrivilegeLevelEnum.Member Then
                    Return True
                End If
            Next

            Return False
        End Get
    End Property

    Public ReadOnly Property HasGroupLevelPrivileges() As Boolean
        Get
            For Each priv As Privilege In Me.Privileges
                If priv.PrivilegeLevel = Privilege.PrivilegeLevelEnum.Group Then
                    Return True
                End If
            Next

            Return False
        End Get
    End Property

    Public ReadOnly Property IsDirty() As Boolean
        Get
            Return mIsDirty
        End Get
    End Property

    Public ReadOnly Property IsNew() As Boolean
        Get
            Return (Me.mApplicationId = 0)
        End Get
    End Property

#End Region

#Region " Constructors "
    Public Sub New()

    End Sub
#End Region

    Public Shared Function GetApplication(ByVal applicationId As Integer) As Application
        Dim ds As DataSet
        Dim dv As DataView
        ds = DAL.SelectApplication(applicationId)
        
        Dim app As Application
        If ds.Tables.Count > 0 AndAlso ds.Tables(0).Rows.Count > 0 Then
            app = DirectCast(Populator.FillObject(ds.Tables(0).Rows(0), GetType(Application)), Application)

            For Each row As DataRow In ds.Tables(0).Rows
                Populator.FillCollection(row.GetChildRows("AppPrivilege"), GetType(Privilege), app.Privileges)
            Next
        End If

        Return app
    End Function

    Public Sub UpdateApplication(ByVal authorMemberId As Integer)
        DAL.UpdateApplication(Me.mApplicationId, Me.mName, Me.mDescription, Me.mIsInternalOnly, authorMemberId, Me.mDeploymentType, Me.mPath, Me.mImageData, Me.mCategory)
        mIsDirty = False
    End Sub

    Public Shared Function CreateNewApplication(ByVal name As String, ByVal description As String, ByVal isInternalOnly As Boolean, ByVal authorMemberId As Integer, ByVal appDeploymentType As DeploymentType, ByVal path As String, ByVal imageData As Byte(), ByVal categoryName As String) As Integer
        Return DAL.InsertApplication(name, description, isInternalOnly, authorMemberId, appDeploymentType, path, imageData, categoryName)
    End Function

    Public Sub Insert(ByVal authorMemberId As Integer)
        mApplicationId = CreateNewApplication(mName, mDescription, mIsInternalOnly, authorMemberId, mDeploymentType, mPath, mImageData, mCategory)
        mIsDirty = False
    End Sub

End Class
Public Enum DeploymentType
    None = 0
    ClickOnce = 1
    NoTouch = 2
    LocalInstall = 3
    WebApplication = 4
End Enum