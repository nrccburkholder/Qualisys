Imports System.Xml.Serialization

<Serializable()> _
Public Class Application

#Region " Private Members "
    Private mId As Integer
    Private mName As String
    Private mImage As Drawing.Image
    Private mCurrentVersion As String
    Private mDescription As String
    Private mDeploymentType As DeploymentType
    Private mPath As String
    Private mCategoryName As String

    Private mIsDirty As Boolean
#End Region

#Region " Constructors "
    Public Sub New()
    End Sub

    Public Sub New(ByVal id As Integer)
        Me.mId = id
    End Sub
#End Region

#Region " Public Properties "
    Public Property Id() As Integer
        Get
            Return mId
        End Get
        Set(ByVal value As Integer)
            mId = value
        End Set
    End Property
    Public Property Name() As String
        Get
            Return mName
        End Get
        Set(ByVal value As String)
            If Not mName = value Then
                mName = value
                mIsDirty = True
            End If
        End Set
    End Property

    <Xml.Serialization.XmlIgnore()> _
    Public Property Image() As Drawing.Image
        Get
            Return mImage
        End Get
        Set(ByVal value As Drawing.Image)
            mImage = value
            mIsDirty = True
        End Set
    End Property

    Public Property ImageData() As Byte()
        Get
            Return ImageToBytes(mImage)
        End Get
        Set(ByVal value As Byte())
            mImage = BytesToImage(value)
            mIsDirty = True
        End Set
    End Property
    Public Property CurrentVersion() As String
        Get
            Return mCurrentVersion
        End Get
        Set(ByVal value As String)
            If Not mCurrentVersion = value Then
                mCurrentVersion = value
                mIsDirty = True
            End If
        End Set
    End Property
    Public Property Description() As String
        Get
            Return mDescription
        End Get
        Set(ByVal value As String)
            If Not mDescription = value Then
                mDescription = value
                mIsDirty = True
            End If
        End Set
    End Property
    Public Property DeploymentType() As DeploymentType
        Get
            Return mDeploymentType
        End Get
        Set(ByVal value As DeploymentType)
            If Not mDeploymentType = value Then
                mDeploymentType = value
                mIsDirty = True
            End If
        End Set
    End Property
    Public Property Path() As String
        Get
            Return mPath
        End Get
        Set(ByVal value As String)
            If Not mPath = value Then
                mPath = value
                mIsDirty = True
            End If
        End Set
    End Property
    Public Property CategoryName() As String
        Get
            Return mCategoryName
        End Get
        Set(ByVal value As String)
            If Not mCategoryName = value Then
                mCategoryName = value
                mIsDirty = True
            End If
        End Set
    End Property

    Public ReadOnly Property IsDirty() As Boolean
        Get
            Return mIsDirty
        End Get
    End Property
    Public ReadOnly Property IsNew() As Boolean
        Get
            Return (mId = 0)
        End Get
    End Property
#End Region

#Region " Public Methods "
    Public Sub ResetDirtyFlag()
        Me.mIsDirty = False
    End Sub
#End Region

#Region " Private Methods "

    ''' <summary>
    ''' Converts an array of bytes into an image object
    ''' </summary>
    ''' <param name="imgData">The array of bytes containing an image</param>
    ''' <returns>An image object</returns>
    Private Shared Function BytesToImage(ByVal imgData As Byte()) As Drawing.Image
        'Return NULL when there is no data
        If imgData Is Nothing OrElse imgData.Length = 0 Then
            Return Nothing
        End If

        'Put the bytes into a stream and load it into an image
        Using ms As New IO.MemoryStream(imgData)
            Return System.Drawing.Image.FromStream(ms)
        End Using
    End Function

    ''' <summary>
    ''' Converts an image object into a array of bytes for storage
    ''' </summary>
    ''' <param name="img">The image object to serialize</param>
    ''' <returns>An array of bytes containing the image data</returns>
    Private Shared Function ImageToBytes(ByVal img As Drawing.Image) As Byte()
        'Return NULL if there is not image object
        If img Is Nothing Then
            Return Nothing
        End If

        'Create a membory stream and save the image to it
        'Export the stream to a byte array
        Using ms As New IO.MemoryStream
            img.Save(ms, System.Drawing.Imaging.ImageFormat.Png)
            Return ms.ToArray
        End Using
    End Function
#End Region

End Class
