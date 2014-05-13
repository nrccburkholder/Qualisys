Imports System
Imports System.Reflection

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


    '*********************************************************************
    '
    ' Null Class
    '
    ' Class for dealing with the translation of database null values
    '
    '*********************************************************************

    Public Class Null

        ' define application encoded null values
        Public Shared ReadOnly Property NullInteger() As Integer
            Get
                Return -1
            End Get
        End Property
        Public Shared ReadOnly Property NullDate() As Date
            Get
                Return Date.MinValue
            End Get
        End Property
        Public Shared ReadOnly Property NullString() As String
            Get
                Return ""
            End Get
        End Property
        Public Shared ReadOnly Property NullBoolean() As Boolean
            Get
                Return False
            End Get
        End Property
        Public Shared ReadOnly Property NullGuid() As Guid
            Get
                Return Guid.Empty
            End Get
        End Property

        ' sets a field to an application encoded null value ( used in Presentation layer )
        Public Shared Function SetNull(ByVal objField As Object) As Object
            If Not objField Is Nothing Then
                If TypeOf objField Is Integer Then
                    SetNull = NullInteger
                ElseIf TypeOf objField Is Single Then
                    SetNull = NullInteger
                ElseIf TypeOf objField Is Double Then
                    SetNull = NullInteger
                ElseIf TypeOf objField Is Decimal Then
                    SetNull = NullInteger
                ElseIf TypeOf objField Is Date Then
                    SetNull = NullDate
                ElseIf TypeOf objField Is String Then
                    SetNull = NullString
                ElseIf TypeOf objField Is Boolean Then
                    SetNull = NullBoolean
                ElseIf TypeOf objField Is Guid Then
                    SetNull = NullGuid
                Else
                    Throw New NullReferenceException
                End If
            Else ' assume string
                SetNull = NullString
            End If
        End Function
        ' sets a field to an application encoded null value ( used in BLL layer )
        Public Shared Function SetNull(ByVal objPropertyInfo As PropertyInfo) As Object
            Select Case objPropertyInfo.PropertyType.ToString
                Case "System.Int16", "System.Int32", "System.Int64", "System.Single", "System.Double", "System.Decimal"
                    SetNull = NullInteger
                Case "System.DateTime"
                    SetNull = NullDate
                Case "System.String", "System.Char"
                    SetNull = NullString
                Case "System.Boolean"
                    SetNull = NullBoolean
                Case "System.Guid"
                    SetNull = NullGuid
                Case Else
                    ' Enumerations default to the first entry
                    Dim pType As Type = objPropertyInfo.PropertyType
                    If pType.BaseType.Equals(GetType(System.Enum)) Then
                        Dim objEnumValues As System.Array = System.Enum.GetValues(pType)
                        Array.Sort(objEnumValues)
                        SetNull = System.Enum.ToObject(pType, objEnumValues.GetValue(0))
                    Else
                        Throw New NullReferenceException
                    End If
            End Select
        End Function

        ' sets a field to an application encoded null value ( used in BLL layer )
        Public Shared Function SetNull(ByVal objFieldInfo As FieldInfo) As Object
            Select Case objFieldInfo.FieldType.ToString
                Case "System.Int16", "System.Int32", "System.Int64", "System.Single", "System.Double", "System.Decimal"
                    SetNull = NullInteger
                Case "System.DateTime"
                    SetNull = NullDate
                Case "System.String", "System.Char"
                    SetNull = NullString
                Case "System.Boolean"
                    SetNull = NullBoolean
                Case "System.Guid"
                    SetNull = NullGuid
                Case "System.Byte[]", "System.Drawing.Image"
                    SetNull = Nothing
                Case Else
                    ' Enumerations default to the first entry
                    Dim pType As Type = objFieldInfo.FieldType
                    If pType.BaseType.Equals(GetType(System.Enum)) Then
                        Dim objEnumValues As System.Array = System.Enum.GetValues(pType)
                        Array.Sort(objEnumValues)
                        SetNull = System.Enum.ToObject(pType, objEnumValues.GetValue(0))
                    Else
                        Throw New NullReferenceException
                    End If
            End Select
        End Function

        Public Shared Function GetNull(ByVal objField As Object)
            Return GetNull(objField, DBNull.Value)
        End Function
        ' convert an application encoded null value to a database null value ( used in DAL )
        Public Shared Function GetNull(ByVal objField As Object, ByVal objDBNull As Object) As Object
            GetNull = objField
            If objField Is Nothing Then
                GetNull = objDBNull
            ElseIf TypeOf objField Is Integer Then
                If Convert.ToInt32(objField) = NullInteger Then
                    GetNull = objDBNull
                End If
            ElseIf TypeOf objField Is Single Then
                If Convert.ToSingle(objField) = NullInteger Then
                    GetNull = objDBNull
                End If
            ElseIf TypeOf objField Is Double Then
                If Convert.ToDouble(objField) = NullInteger Then
                    GetNull = objDBNull
                End If
            ElseIf TypeOf objField Is Decimal Then
                If Convert.ToDecimal(objField) = NullInteger Then
                    GetNull = objDBNull
                End If
            ElseIf TypeOf objField Is Date Then
                If Convert.ToDateTime(objField) = NullDate Then
                    GetNull = objDBNull
                End If
            ElseIf TypeOf objField Is String Then
                If objField Is Nothing Then
                    GetNull = objDBNull
                Else
                    If objField.ToString = NullString Then
                        GetNull = objDBNull
                    End If
                End If
            ElseIf TypeOf objField Is Boolean Then
                If Convert.ToBoolean(objField) = NullBoolean Then
                    GetNull = objDBNull
                End If
            ElseIf TypeOf objField Is Guid Then
                If CType(objField, System.Guid).Equals(NullGuid) Then
                    GetNull = objDBNull
                End If
            Else
                Throw New NullReferenceException
            End If
        End Function

        ' checks if a field contains an application encoded null value
        Public Shared Function IsNull(ByVal objField As Object) As Boolean
            If objField.Equals(SetNull(objField)) Then
                IsNull = True
            Else
                IsNull = False
            End If
        End Function

    End Class

End Namespace
