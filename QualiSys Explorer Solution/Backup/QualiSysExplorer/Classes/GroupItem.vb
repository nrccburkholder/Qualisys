' The ExpandableList control contains a collection of GroupItem objects.
' Each object specifies the group title and filter that determines
' which rows are displayed in the group.

<System.ComponentModel.TypeConverter(GetType(GroupItemConverter))> _
Public Class GroupItem
    ' Internal members.
    Private m_groupTitle As String
    Private m_rowFilter As String

    Public Sub New()
    End Sub

    Public Sub New(ByVal title As String, ByVal filter As String)
        m_groupTitle = title
        m_rowFilter = filter
    End Sub

    ' Title of the group.
    Public Property GroupTitle() As String
        Get
            Return m_groupTitle
        End Get
        Set(ByVal Value As String)
            m_groupTitle = Value
        End Set
    End Property

    ' Filter used for the group.
    Public Property RowFilter() As String
        Get
            Return m_rowFilter
        End Get
        Set(ByVal Value As String)
            m_rowFilter = Value
        End Set
    End Property
End Class
