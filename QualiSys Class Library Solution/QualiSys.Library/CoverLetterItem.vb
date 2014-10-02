

Public Class CoverLetterItem


#Region " Private Fields "
    Private mItemID As Integer
    Private mCoverID As Integer
    Private mLabel As String
    Private mItemType As Integer
#End Region
#Region " Public Properties "
    ''' <summary>The unique identifier of the Cover Letter Item</summary>
    ''' 
    Public Property ItemID As Integer
        Get
            Return mItemID
        End Get
        Set(value As Integer)
            mItemID = value
        End Set
    End Property

    Public Property CoverID As Integer
        Get
            Return mCoverID
        End Get
        Set(value As Integer)
            mCoverID = value
        End Set
    End Property

    Public Property Label() As String
        Get
            Return mLabel
        End Get
        Set(ByVal value As String)
            mLabel = value
        End Set
    End Property

    ''' <summary>The type of the cover letter item</summary>
    Public Property ItemType() As Integer
        Get
            Return mItemType
        End Get
        Set(ByVal value As Integer)
            mItemType = value
        End Set
    End Property
#End Region
End Class
