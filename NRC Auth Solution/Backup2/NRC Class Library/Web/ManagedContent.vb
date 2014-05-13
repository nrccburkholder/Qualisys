Option Strict On

Imports NRC.Data

Namespace Web
    Public Class ManagedContent

        Public Enum SelectOrder
            Alpha = 0
            Created = 1
            Modified = 2
        End Enum
#Region " Private Members "
        Private mContentId As Integer
        Private mCategory As String
        Private mKey As String
        Private mContent As String
        Private mTeaser As String
        Private mIsActive As Boolean
        Private mDateCreated As DateTime
        Private mDateModified As DateTime

#End Region

#Region " Public Properties "
        Public Property Category() As String
            Get
                Return mCategory
            End Get
            Set(ByVal Value As String)
                mCategory = Value
            End Set
        End Property
        Public Property Key() As String
            Get
                Return mKey
            End Get
            Set(ByVal Value As String)
                mKey = Value
            End Set
        End Property
        Public Property Content() As String
            Get
                Return mContent
            End Get
            Set(ByVal Value As String)
                mContent = Value
            End Set
        End Property
        Public Property Teaser() As String
            Get
                Return mTeaser
            End Get
            Set(ByVal Value As String)
                mTeaser = Value
            End Set
        End Property
        Public Property IsActive() As Boolean
            Get
                Return mIsActive
            End Get
            Set(ByVal Value As Boolean)
                mIsActive = Value
            End Set
        End Property
        Public Property DateCreated() As DateTime
            Get
                Return mDateCreated
            End Get
            Set(ByVal Value As DateTime)
                mDateCreated = Value
            End Set
        End Property
        Public Property DateModified() As DateTime
            Get
                Return mDateModified
            End Get
            Set(ByVal Value As DateTime)
                mDateModified = Value
            End Set
        End Property

#End Region

        Private Shared config As Configuration.RSCMConfig = Configuration.RSCMConfig.Instance
        Private Shared conString As String = config.ConnectionString

        Public Sub New()

        End Sub
        Public Sub New(ByVal category As String, ByVal key As String)
            Me.mCategory = category
            Me.mKey = key
        End Sub

#Region " CRUD Methods"
        Public Shared Function SelectFromDB(ByVal category As String, ByVal key As String, ByVal includeInactive As Boolean, ByVal orderBy As SelectOrder) As ManagedContent
            Dim rdr As IDataReader
            Dim mc As ManagedContent

            Try
                rdr = SqlHelper.ExecuteReader(conString, "CM_Select_Content", Null.GetNull(category), Null.GetNull(key), includeInactive, System.Enum.GetName(GetType(SelectOrder), orderBy))
                mc = CType(CBO.FillObject(rdr, GetType(ManagedContent)), ManagedContent)
                Return mc
            Finally
                rdr.Close()
            End Try
        End Function

        Public Shared Function SelectFromDB(ByVal category As String, ByVal includeInactive As Boolean, ByVal orderBy As SelectOrder) As ManagedContentCollection
            Dim rdr As IDataReader
            Dim contents As New ManagedContentCollection

            Try
                rdr = SqlHelper.ExecuteReader(conString, "CM_Select_Content", Null.GetNull(category), DBNull.Value, includeInactive, System.Enum.GetName(GetType(SelectOrder), orderBy))
                Return CType(CBO.FillCollection(rdr, GetType(ManagedContent), CType(contents, IList)), ManagedContentCollection)
            Finally
                If Not rdr Is Nothing Then
                    rdr.Close()
                End If
            End Try
        End Function

        Public Shared Function SelectFromDB(ByVal includeInactive As Boolean) As ManagedContentCollection
            Return SelectFromDB("", includeInactive, SelectOrder.Alpha)
        End Function

        Public Sub UpdateDB()
            Dim params(4) As Object
            params(0) = mCategory
            params(1) = mKey
            params(2) = Null.GetNull(mContent)
            params(3) = Null.GetNull(mTeaser)
            params(4) = mIsActive

            SqlHelper.ExecuteNonQuery(conString, "CM_Update_Content", params)
        End Sub

        Public Sub InsertDB()
            Dim params(3) As Object
            params(0) = mCategory
            params(1) = mKey
            params(2) = mContent
            params(3) = mTeaser

            Dim newId As Integer
            newId = CType(SqlHelper.ExecuteScalar(conString, "CM_Insert_Content", params), Integer)
            mContentId = newId
        End Sub

        Public Sub Delete()
            SqlHelper.ExecuteNonQuery(conString, "CM_Delete_Content", mCategory, mKey)
        End Sub

        Public Shared Function SelectCategories() As ArrayList
            Dim list As New ArrayList
            Dim rdr As IDataReader
            Try
                rdr = SqlHelper.ExecuteReader(conString, "CM_Select_ContentCategories")
                While rdr.Read
                    list.Add(rdr("Category"))
                End While

                Return list
            Finally
                If Not rdr Is Nothing Then
                    rdr.Close()
                End If
            End Try

        End Function
        Public Shared Function SelectKeys(ByVal category As String) As ArrayList
            Dim list As New ArrayList
            Dim rdr As IDataReader
            Try
                rdr = SqlHelper.ExecuteReader(conString, "CM_Select_ContentKeys", category)
                While rdr.Read
                    list.Add(rdr("Key"))
                End While

                Return list
            Finally
                If Not rdr Is Nothing Then
                    rdr.Close()
                End If
            End Try

        End Function
#End Region

    End Class

    Public Class ManagedContentCollection
        Inherits CollectionBase

        Default Public ReadOnly Property Item(ByVal index As Integer) As ManagedContent
            Get
                Return CType(MyBase.List(index), ManagedContent)
            End Get
        End Property

        Public Function Add(ByVal content As ManagedContent) As Integer
            Return MyBase.List.Add(content)
        End Function
    End Class
End Namespace