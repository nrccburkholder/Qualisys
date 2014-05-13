Imports System.Reflection
Imports System.Xml
Imports System.Xml.Serialization
Imports System.Text
Imports System.IO

Namespace Data
    ' DotNetNuke -  http://www.dotnetnuke.com
    ' Copyright (c) 2002-2004
    ' by Shaun Walker ( sales@perpetualmotion.ca ) of Perpetual Motion Interactive Systems Inc. ( http://www.perpetualmotion.ca )
    '
    ' Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated 
    ' documentation files (the "Software"), to deal in the Software without restriction, including without limitation 
    ' the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and 
    ' to permit persons to whom the Software is furnished to do so, subject to the following conditions:
    '
    ' The above copyright notice and this permission notice shall be included in all copies or substantial portions 
    ' of the Software.
    '
    ' THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED 
    ' TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL 
    ' THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF 
    ' CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER 
    ' DEALINGS IN THE SOFTWARE.
    '

    '*********************************************************************
    '
    ' CBO Class
    '
    ' Class that hydrates custom business objects with data
    '
    '*********************************************************************

    Public Class CBO

        Private Shared mPrivatePrefix As String = "m"
        Public Shared Property PrivateMemberPrefix() As String
            Get
                Return mPrivatePrefix
            End Get
            Set(ByVal Value As String)
                mPrivatePrefix = Value
            End Set
        End Property

        Protected Shared Function GetCache(ByVal CacheKey As String) As Object
            Dim objCache As System.Web.Caching.Cache = System.Web.HttpRuntime.Cache
            Return objCache(CacheKey)
        End Function
        Protected Shared Sub SetCache(ByVal CacheKey As String, ByVal objObject As Object)
            Dim objCache As System.Web.Caching.Cache = System.Web.HttpRuntime.Cache
            objCache.Insert(CacheKey, objObject)
        End Sub

        Public Shared Function GetPropertyInfo(ByVal objType As Type) As ArrayList
            ' Use the cache because the reflection used later is expensive
            Dim objProperties As ArrayList = CType(GetCache(objType.FullName), ArrayList)

            If objProperties Is Nothing Then
                objProperties = New ArrayList
                Dim objProperty As PropertyInfo
                For Each objProperty In objType.GetProperties()
                    objProperties.Add(objProperty)
                Next
                SetCache(objType.FullName, objProperties)
            End If

            Return objProperties
        End Function

        Private Shared Function GetOrdinals(ByVal objProperties As ArrayList, ByVal dr As IDataReader) As Integer()

            Dim arrOrdinals(objProperties.Count - 1) As Integer
            Dim intProperty As Integer

            If Not dr Is Nothing Then
                For intProperty = 0 To objProperties.Count - 1
                    arrOrdinals(intProperty) = -1
                    Try
                        arrOrdinals(intProperty) = dr.GetOrdinal(CType(objProperties(intProperty), PropertyInfo).Name)
                    Catch
                        ' property does not exist in datareader
                    End Try
                Next intProperty
            End If

            Return arrOrdinals
        End Function

        Private Shared Function GetOrdinals(ByVal objProperties As ArrayList, ByVal dr As DataRow) As Integer()
            Dim arrOrdinals(objProperties.Count - 1) As Integer
            Dim intProperty As Integer

            If Not dr Is Nothing Then
                For intProperty = 0 To objProperties.Count - 1
                    arrOrdinals(intProperty) = -1
                    Try
                        arrOrdinals(intProperty) = dr.Table.Columns(CType(objProperties(intProperty), PropertyInfo).Name).Ordinal
                        'arrOrdinals(intProperty) = dr.GetOrdinal(CType(objProperties(intProperty), PropertyInfo).Name)
                    Catch
                        ' property does not exist in datareader
                    End Try
                Next intProperty
            End If

            Return arrOrdinals
        End Function

        Private Shared Function CreateObject(ByVal type As Type, ByVal values() As Object, ByVal objProperties As ArrayList, ByVal arrOrdinals As Integer()) As Object
            Dim obj As Object = Activator.CreateInstance(type)
            Dim intProperty As Integer
            Dim prop As PropertyInfo
            Dim field As FieldInfo
            Dim value As Object

            For i As Integer = 0 To objProperties.Count - 1
                prop = objProperties(i)

                If Not prop.CanWrite Then
                    field = obj.GetType.GetField(String.Format("{0}{1}", mPrivatePrefix, prop.Name), BindingFlags.IgnoreCase Or BindingFlags.Instance Or BindingFlags.NonPublic)
                End If
                If prop.CanWrite OrElse Not field Is Nothing Then
                    If arrOrdinals(i) <> -1 Then
                        value = values(arrOrdinals(i))

                        If IsDBNull(value) Then
                            ' translate Null value
                            If prop.CanWrite Then
                                prop.SetValue(obj, Null.SetNull(prop), Nothing)
                            Else
                                field.SetValue(obj, Null.SetNull(prop))
                            End If
                        Else
                            Try
                                ' try implicit conversion first
                                If prop.CanWrite Then
                                    prop.SetValue(obj, value, Nothing)
                                Else
                                    field.SetValue(obj, value)
                                End If
                            Catch ' data types do not match
                                Try
                                    Dim pType As Type = prop.PropertyType
                                    'need to handle enumeration conversions differently than other base types
                                    If pType.BaseType.Equals(GetType(System.Enum)) Then
                                        If prop.CanWrite Then
                                            prop.SetValue(obj, System.Enum.ToObject(pType, value), Nothing)
                                        Else
                                            field.SetValue(obj, System.Enum.ToObject(pType, value))
                                        End If
                                    Else
                                        ' try explicit conversion
                                        If prop.CanWrite Then
                                            prop.SetValue(obj, Convert.ChangeType(value, pType), Nothing)
                                        Else
                                            field.SetValue(obj, Convert.ChangeType(value, pType))
                                        End If
                                    End If
                                Catch
                                    ' error assigning a datareader value to a property
                                    If prop.CanWrite Then
                                        prop.SetValue(obj, Null.SetNull(prop), Nothing)
                                    Else
                                        field.SetValue(obj, Null.SetNull(prop))
                                    End If
                                End Try
                            End Try
                        End If
                    Else ' property does not exist in datareader
                        If prop.CanWrite Then
                            prop.SetValue(obj, Null.SetNull(prop), Nothing)
                        Else
                            field.SetValue(obj, Null.SetNull(prop))
                        End If
                    End If
                End If
            Next

            Return obj
        End Function

        Public Shared Function FillObject(ByVal dr As IDataReader, ByVal objType As Type) As Object
            Dim objFillObject As Object
            Dim intProperty As Integer

            ' get properties for type
            Dim objProperties As ArrayList = GetPropertyInfo(objType)

            ' get ordinal positions in datareader
            Dim arrOrdinals As Integer() = GetOrdinals(objProperties, dr)

            ' read datareader
            If dr.Read Then
                ' fill business object
                Dim values(dr.FieldCount - 1) As Object
                dr.GetValues(values)
                objFillObject = CreateObject(objType, values, objProperties, arrOrdinals)
            Else
                objFillObject = Nothing
            End If

            ' close datareader
            If Not dr Is Nothing Then
                dr.Close()
            End If

            Return objFillObject
        End Function

        Public Shared Function FillObject(ByVal dr As DataRow, ByVal objType As Type) As Object
            Dim objFillObject As Object
            Dim intProperty As Integer

            ' get properties for type
            Dim objProperties As ArrayList = GetPropertyInfo(objType)

            ' get ordinal positions in datareader
            Dim arrOrdinals As Integer() = GetOrdinals(objProperties, dr)

            ' read datarow
            If Not dr Is Nothing Then
                ' fill business object
                objFillObject = CreateObject(objType, dr.ItemArray, objProperties, arrOrdinals)
            Else
                objFillObject = Nothing
            End If

            Return objFillObject
        End Function

        Public Shared Function FillCollection(ByVal dr As IDataReader, ByVal objType As Type) As ArrayList
            Dim objFillCollection As New ArrayList
            Dim objFillObject As Object
            Dim intProperty As Integer

            ' get properties for type
            Dim objProperties As ArrayList = GetPropertyInfo(objType)

            ' get ordinal positions in datareader
            Dim arrOrdinals As Integer() = GetOrdinals(objProperties, dr)

            ' iterate datareader
            While dr.Read
                ' fill business object
                Dim values(dr.FieldCount - 1) As Object
                dr.GetValues(values)
                objFillObject = CreateObject(objType, values, objProperties, arrOrdinals)
                ' add to collection
                objFillCollection.Add(objFillObject)
            End While

            ' close datareader
            If Not dr Is Nothing Then
                dr.Close()
            End If

            Return objFillCollection
        End Function

        Public Shared Function FillCollection(ByVal dr As DataRow(), ByVal objType As Type) As ArrayList
            Dim objFillCollection As New ArrayList
            Dim objFillObject As Object
            Dim intProperty As Integer

            ' get properties for type
            Dim objProperties As ArrayList = GetPropertyInfo(objType)

            ' get ordinal positions in datareader
            Dim arrOrdinals As Integer() = GetOrdinals(objProperties, dr)

            ' iterate datareader
            For Each row As DataRow In dr
                ' fill business object
                objFillObject = CreateObject(objType, row.ItemArray, objProperties, arrOrdinals)
                ' add to collection
                objFillCollection.Add(objFillObject)
            Next

            Return objFillCollection
        End Function

        Public Shared Function FillCollection(ByVal dr As IDataReader, ByVal objType As Type, ByRef objToFill As IList) As IList
            Dim objFillObject As Object
            Dim intProperty As Integer

            ' get properties for type
            Dim objProperties As ArrayList = GetPropertyInfo(objType)

            ' get ordinal positions in datareader
            Dim arrOrdinals As Integer() = GetOrdinals(objProperties, dr)

            ' iterate datareader
            While dr.Read
                ' fill business object
                Dim values(dr.FieldCount - 1) As Object
                dr.GetValues(values)
                objFillObject = CreateObject(objType, values, objProperties, arrOrdinals)
                ' add to collection
                objToFill.Add(objFillObject)
            End While

            ' close datareader
            If Not dr Is Nothing Then
                dr.Close()
            End If

            Return objToFill
        End Function

        Public Shared Function FillCollection(ByVal dr As DataRow(), ByVal objType As Type, ByRef objToFill As IList) As IList
            Dim objFillObject As Object
            Dim intProperty As Integer

            ' get properties for type
            Dim objProperties As ArrayList = GetPropertyInfo(objType)

            ' get ordinal positions in datareader
            Dim arrOrdinals As Integer() = GetOrdinals(objProperties, dr)

            ' iterate datareader
            For Each row As DataRow In dr
                ' fill business object
                objFillObject = CreateObject(objType, row.ItemArray, objProperties, arrOrdinals)
                ' add to collection
                objToFill.Add(objFillObject)
            Next

            Return objToFill
        End Function

        'Public Shared Function InitializeObject(ByVal objObject As Object, ByVal objType As Type) As Object

        '    Dim intProperty As Integer

        '    ' get properties for type
        '    Dim objProperties As ArrayList = GetPropertyInfo(objType)

        '    ' initialize properties
        '    For intProperty = 0 To objProperties.Count - 1
        '        If CType(objProperties(intProperty), PropertyInfo).CanWrite Then
        '            CType(objProperties(intProperty), PropertyInfo).SetValue(objObject, Null.SetNull(CType(objProperties(intProperty), PropertyInfo)), Nothing)
        '        End If
        '    Next intProperty

        '    Return objObject

        'End Function

        Public Shared Function Serialize(ByVal objObject As Object) As XmlDocument
            Dim objXmlSerializer As New XmlSerializer(objObject.GetType())
            Dim objStringBuilder As New StringBuilder
            Dim objTextWriter As TextWriter = New StringWriter(objStringBuilder)

            objXmlSerializer.Serialize(objTextWriter, objObject)

            Dim objStringReader As New StringReader(objTextWriter.ToString())
            Dim objDataSet As New DataSet
            objDataSet.ReadXml(objStringReader)

            Dim xmlSerializedObject As New XmlDocument
            xmlSerializedObject.LoadXml(objDataSet.GetXml())

            Return xmlSerializedObject
        End Function

        Protected Overrides Sub Finalize()
            MyBase.Finalize()
        End Sub
    End Class


End Namespace
