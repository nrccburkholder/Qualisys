Imports System.Reflection

Namespace Data
    Public Class Populator

#Region " FieldMap Class "
        Private Class FieldMap
            Private mFieldName As String
            Private mField As FieldInfo
            Private mProperty As PropertyInfo

            Public ReadOnly Property FieldName() As String
                Get
                    Return mFieldName
                End Get
            End Property
            Public ReadOnly Property Field() As FieldInfo
                Get
                    Return mField
                End Get
            End Property
            Public ReadOnly Property [Property]() As PropertyInfo
                Get
                    Return mProperty
                End Get
            End Property
            Public ReadOnly Property IsProperty() As Boolean
                Get
                    Return (mField Is Nothing)
                End Get
            End Property

            Public Sub New(ByVal fieldName As String, ByVal prop As PropertyInfo)
                mFieldName = fieldName
                mProperty = prop
            End Sub
            Public Sub New(ByVal fieldName As String, ByVal field As FieldInfo)
                mFieldName = fieldName
                mField = field
            End Sub
        End Class
        Private Class FieldMapCollection
            Inherits CollectionBase

            Default Public ReadOnly Property Item(ByVal index As Integer) As FieldMap
                Get
                    Return DirectCast(MyBase.List(index), FieldMap)
                End Get
            End Property
            Public Function Add(ByVal map As FieldMap) As Integer
                Return MyBase.List.Add(map)
            End Function
        End Class
#End Region

#Region " GetFieldMappings "
        Private Shared Function GetFieldMappings(ByVal type As Type) As FieldMapCollection
            Dim col As FieldMapCollection = DirectCast(GetCache(type.FullName), FieldMapCollection)

            If col Is Nothing Then
                col = New FieldMapCollection
                If Not type.IsClass Then
                    Throw New ArgumentException("Type must be a class.", "type")
                End If
                If type.GetCustomAttributes(GetType(AutoPopulateAttribute), True).Length = 0 Then
                    Throw New ArgumentException("Type must be a marked with the AutoPopulate attribute.", "type")
                End If

                Dim attributes() As Object
                Dim map As FieldMap
                For Each field As Reflection.FieldInfo In type.GetFields(BindingFlags.Instance Or BindingFlags.NonPublic)
                    attributes = field.GetCustomAttributes(GetType(SQLFieldAttribute), True)
                    If attributes.Length > 0 Then
                        map = New FieldMap(DirectCast(attributes(0), SQLFieldAttribute).FieldName(), field)
                        col.Add(map)
                    End If
                Next
                For Each prop As Reflection.PropertyInfo In type.GetProperties()
                    attributes = prop.GetCustomAttributes(GetType(SQLFieldAttribute), True)
                    If attributes.Length > 0 Then
                        map = New FieldMap(DirectCast(attributes(0), SQLFieldAttribute).FieldName(), prop)
                        col.Add(map)
                    End If
                Next

                SetCache(type.FullName, col)
            End If

            Return col
        End Function

#End Region

#Region " GetOrdinals "
        Private Shared Function GetOrdinals(ByVal mappings As FieldMapCollection, ByVal rdr As IDataReader) As Integer()
            Dim ordinals(mappings.Count - 1) As Integer

            Dim i As Integer
            For i = 0 To mappings.Count - 1
                ordinals(i) = -1
                Try
                    ordinals(i) = rdr.GetOrdinal(mappings(i).FieldName)
                Catch ex As Exception
                    'Field doesn't exist
                End Try
            Next

            Return ordinals
        End Function
        Private Shared Function GetOrdinals(ByVal mappings As FieldMapCollection, ByVal dr As DataRow) As Integer()
            Dim ordinals(mappings.Count - 1) As Integer

            Dim i As Integer
            For i = 0 To mappings.Count - 1
                ordinals(i) = -1
                Try
                    ordinals(i) = dr.Table.Columns(mappings(i).FieldName).Ordinal
                Catch ex As Exception
                    'Field doesn't exist
                End Try
            Next

            Return ordinals
        End Function

#End Region

#Region " CreateObject "
        Private Shared Function CreateObject(ByVal values() As Object, ByVal type As Type, ByVal mappings As FieldMapCollection, ByVal ordinals() As Integer) As Object
            Dim obj As Object = Activator.CreateInstance(type)
            Dim i As Integer

            Dim map As FieldMap
            Dim value As Object
            For i = 0 To mappings.Count - 1
                If ordinals(i) > -1 Then
                    map = mappings(i)
                    value = values(ordinals(i))
                    If Microsoft.VisualBasic.Information.IsDBNull(value) Then
                        If map.IsProperty Then
                            value = NRC.Data.Null.SetNull(map.Property)
                        Else
                            value = NRC.Data.Null.SetNull(map.Field)
                        End If
                    End If

                    If map.IsProperty Then
                        If map.Property.CanWrite Then
                            Try
                                map.Property.SetValue(obj, value, Nothing)
                            Catch
                                Try
                                    If map.Property.PropertyType.BaseType.Equals(GetType(System.Enum)) Then
                                        map.Property.SetValue(obj, System.Enum.ToObject(map.Property.PropertyType, value), Nothing)
                                    Else
                                        map.Property.SetValue(obj, Convert.ChangeType(value, map.Property.PropertyType), Nothing)
                                    End If
                                Catch
                                    map.Property.SetValue(obj, NRC.Data.Null.SetNull(map.Property), Nothing)
                                End Try
                            End Try
                        End If
                    Else
                        Try
                            map.Field.SetValue(obj, value)
                        Catch
                            Try
                                If map.Field.FieldType.BaseType.Equals(GetType(System.Enum)) Then
                                    map.Field.SetValue(obj, System.Enum.ToObject(map.Field.FieldType, value))
                                Else
                                    map.Field.SetValue(obj, Convert.ChangeType(value, map.Field.FieldType))
                                End If
                            Catch
                                map.Field.SetValue(obj, NRC.Data.Null.SetNull(map.Field))
                            End Try
                        End Try
                    End If
                End If
            Next

            Return obj
        End Function
#End Region

#Region " FillObject "
        Public Shared Function FillObject(ByVal rdr As IDataReader, ByVal type As Type) As Object
            Dim mappings As FieldMapCollection = GetFieldMappings(type)
            Dim ordinals() As Integer = GetOrdinals(mappings, rdr)
            Dim obj As Object

            If rdr.Read Then
                Dim values(rdr.FieldCount - 1) As Object
                rdr.GetValues(values)
                obj = CreateObject(values, type, mappings, ordinals)
            Else
                obj = Nothing
            End If

            If Not rdr Is Nothing Then
                rdr.Close()
            End If

            Return obj
        End Function
        Public Shared Function FillObject(ByVal dr As DataRow, ByVal type As Type) As Object
            Dim mappings As FieldMapCollection = GetFieldMappings(type)
            Dim ordinals() As Integer = GetOrdinals(mappings, dr)
            Dim obj As Object

            If Not dr Is Nothing Then
                obj = CreateObject(dr.ItemArray, type, mappings, ordinals)
            Else
                obj = Nothing
            End If

            Return obj
        End Function
#End Region

#Region " FillCollection "
        Public Shared Function FillCollection(ByVal rdr As IDataReader, ByVal type As Type, ByRef listToFill As IList) As IList
            Dim mappings As FieldMapCollection = GetFieldMappings(type)
            Dim ordinals() As Integer = GetOrdinals(mappings, rdr)
            Dim obj As Object

            ' iterate datareader
            While rdr.Read
                ' fill business object
                Dim values(rdr.FieldCount - 1) As Object
                rdr.GetValues(values)
                obj = CreateObject(values, type, mappings, ordinals)
                ' add to collection
                listToFill.Add(obj)
            End While

            ' close datareader
            If Not rdr Is Nothing Then
                rdr.Close()
            End If

            Return listToFill
        End Function
        Public Shared Function FillCollection(ByVal dr As DataRow(), ByVal type As Type, ByRef listToFill As IList) As IList
            Dim mappings As FieldMapCollection = GetFieldMappings(type)
            If dr.Length = 0 Then
                Return Nothing
            End If
            Dim ordinals() As Integer = GetOrdinals(mappings, dr(0))
            Dim obj As Object

            ' iterate datareader
            For Each row As DataRow In dr
                ' fill business object
                obj = CreateObject(row.ItemArray, type, mappings, ordinals)
                ' add to collection
                listToFill.Add(obj)
            Next

            Return listToFill
        End Function

        Public Shared Function FillCollection(ByVal dr As DataRowCollection, ByVal type As Type, ByRef listToFill As IList) As IList
            Dim mappings As FieldMapCollection = GetFieldMappings(type)
            If dr.Count = 0 Then
                Return Nothing
            End If
            Dim ordinals() As Integer = GetOrdinals(mappings, dr(0))
            Dim obj As Object

            ' iterate datareader
            For Each row As DataRow In dr
                ' fill business object
                obj = CreateObject(row.ItemArray, type, mappings, ordinals)
                ' add to collection
                listToFill.Add(obj)
            Next

            Return listToFill
        End Function

#End Region

#Region " Cache "
        Protected Shared Function GetCache(ByVal CacheKey As String) As Object
            Dim objCache As System.Web.Caching.Cache = System.Web.HttpRuntime.Cache
            Return objCache(CacheKey)
        End Function
        Protected Shared Sub SetCache(ByVal CacheKey As String, ByVal objObject As Object)
            Dim objCache As System.Web.Caching.Cache = System.Web.HttpRuntime.Cache
            objCache.Insert(CacheKey, objObject)
        End Sub
#End Region


    End Class

    <AttributeUsage(AttributeTargets.All)> _
    Public Class AutoPopulateAttribute
        Inherits Attribute

        Public Sub New()

        End Sub
    End Class

    Public Class SQLFieldAttribute
        Inherits Attribute

        Private mFieldName As String
        Public Property FieldName() As String
            Get
                Return mFieldName
            End Get
            Set(ByVal Value As String)
                mFieldName = Value
            End Set
        End Property
        Sub New(ByVal fieldName As String)
            mFieldName = fieldName
        End Sub
    End Class

End Namespace
