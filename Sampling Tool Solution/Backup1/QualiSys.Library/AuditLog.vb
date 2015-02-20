Imports System.Reflection
Imports Nrc.QualiSys.Library.DataProvider

Friend NotInheritable Class AuditLog

    Private Sub New()
    End Sub


    Friend Shared Sub LogChanges(Of T)(ByVal initialObject As T, ByVal finalObject As T, ByVal idPropertyName As String, ByVal objectType As AuditLogObject)
        Dim changes As List(Of AuditLogChange) = CompareObjects(Of T)(initialObject, finalObject, idPropertyName, objectType)

        LogChanges(changes)
    End Sub

    Friend Shared Sub LogChanges(ByVal changes As List(Of AuditLogChange))
        Dim userName As String = Environment.UserName

        'Use AuditLogProvider to persist the audit information...
        For Each change As AuditLogChange In changes
            AuditLogProvider.Instance.InsertAuditLogChange(userName, change.ObjectId, change.ObjectType, change.PropertyName, change.ChangeType, change.InitialValue, change.FinalValue)
        Next
    End Sub


    Friend Shared Function CompareObjects(Of T)(ByVal initialObject As T, ByVal finalObject As T, ByVal idPropertyName As String, ByVal objectType As AuditLogObject) As List(Of AuditLogChange)
        'Initialize the list of object changes
        Dim changes As New List(Of AuditLogChange)

        DetermineFieldChanges(Of T)(initialObject, finalObject, idPropertyName, objectType, changes)
        DeterminePropertyChanges(Of T)(initialObject, finalObject, idPropertyName, objectType, changes)
        Return changes
    End Function

    Private Shared Sub DeterminePropertyChanges(Of T)(ByVal initialObject As T, ByVal finalObject As T, ByVal idPropertyName As String, ByVal changeObjectType As AuditLogObject, ByVal changes As List(Of AuditLogChange))
        'Get the object type
        Dim objectType As Type = GetType(T)
        Dim changeType As AuditLogChangeType

        'Determine the type of change being made
        If initialObject Is Nothing AndAlso finalObject Is Nothing Then
            Throw New ArgumentNullException("initialObject", "Initial object and final object cannot both be null")
        ElseIf initialObject Is Nothing Then
            changeType = AuditLogChangeType.Add
        ElseIf finalObject Is Nothing Then
            changeType = AuditLogChangeType.Delete
        Else
            changeType = AuditLogChangeType.Update
        End If

        'The the collection of public properties for the type and look for Logable ones
        Dim props As PropertyInfo() = objectType.GetProperties(BindingFlags.Instance Or BindingFlags.Public)
        'Check each property for the Logable Attribute
        For Each prop As PropertyInfo In props
            'If this field has been decorated with the Logable Attribute
            Dim logAttributes() As Object = prop.GetCustomAttributes(GetType(LogableAttribute), True)
            If logAttributes.Length = 1 Then
                Dim logAttribute As LogableAttribute = DirectCast(logAttributes(0), LogableAttribute)
                'Get the values from the two objects
                Dim initialValue As Object = Nothing
                If initialObject IsNot Nothing Then initialValue = prop.GetValue(initialObject, Nothing)
                Dim finalValue As Object = Nothing
                If finalObject IsNot Nothing Then finalValue = prop.GetValue(finalObject, Nothing)
                Dim initialString As String = ""
                Dim finalString As String = ""
                If initialValue IsNot Nothing Then
                    initialString = initialValue.ToString
                End If

                If finalValue IsNot Nothing Then
                    finalString = finalValue.ToString
                End If
                Dim propName As String = prop.Name
                If logAttribute.PropertyName.Trim.Length > 0 Then
                    propName = logAttribute.PropertyName
                End If

                'If the values have changed then we need to add an entry to the change list
                If Not initialString.Equals(finalString) Then
                    If changeType = AuditLogChangeType.Delete Then
                        changes.Add(New AuditLogChange(initialObject, idPropertyName, propName, changeType, initialString, finalString, changeObjectType))
                    Else
                        changes.Add(New AuditLogChange(finalObject, idPropertyName, propName, changeType, initialString, finalString, changeObjectType))
                    End If
                End If
            End If
        Next
    End Sub

    Private Shared Sub DetermineFieldChanges(Of T)(ByVal initialObject As T, ByVal finalObject As T, ByVal idPropertyName As String, ByVal changeObjectType As AuditLogObject, ByVal changes As List(Of AuditLogChange))
        'Get the object type 
        Dim objectType As Type = GetType(T)
        Dim changeType As AuditLogChangeType

        'Determine the type of change being made
        If initialObject Is Nothing AndAlso finalObject Is Nothing Then
            Throw New ArgumentNullException("initialObject", "Initial object and final object cannot both be null")
        ElseIf initialObject Is Nothing Then
            changeType = AuditLogChangeType.Add
        ElseIf finalObject Is Nothing Then
            changeType = AuditLogChangeType.Delete
        Else
            changeType = AuditLogChangeType.Update
        End If

        Dim fields As FieldInfo() = objectType.GetFields(BindingFlags.Instance Or BindingFlags.Public Or BindingFlags.NonPublic)
        'Check each field for the Logable Attribute
        For Each field As FieldInfo In fields
            'If this field has been decorated with the Logable Attribute
            Dim logAttributes() As Object = field.GetCustomAttributes(GetType(LogableAttribute), True)
            If logAttributes.Length = 1 Then
                Dim logAttribute As LogableAttribute = DirectCast(logAttributes(0), LogableAttribute)
                'Get the values from the two objects
                Dim initialValue As Object = Nothing
                If initialObject IsNot Nothing Then initialValue = field.GetValue(initialObject)
                Dim finalValue As Object = Nothing
                If finalObject IsNot Nothing Then finalValue = field.GetValue(finalObject)
                Dim initialString As String = ""
                Dim finalString As String = ""
                If initialValue IsNot Nothing Then
                    initialString = initialValue.ToString
                End If
                If finalValue IsNot Nothing Then
                    finalString = finalValue.ToString
                End If
                Dim propName As String = field.Name
                If logAttribute.PropertyName.Trim.Length > 0 Then
                    propName = logAttribute.PropertyName
                End If

                'If the values have changed then we need to add an entry to the change list
                If Not initialString.Equals(finalString) Then
                    If changeType = AuditLogChangeType.Delete Then
                        changes.Add(New AuditLogChange(initialObject, idPropertyName, propName, changeType, initialString, finalString, changeObjectType))
                    Else
                        changes.Add(New AuditLogChange(finalObject, idPropertyName, propName, changeType, initialString, finalString, changeObjectType))
                    End If
                End If
            End If
        Next
    End Sub

End Class
