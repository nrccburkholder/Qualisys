' Used with the Visual Studio property browser so group items
' can be specified at design time.

Imports System.ComponentModel
Imports System.ComponentModel.Design.Serialization
Imports System.Globalization
Imports System.Reflection

Public Class GroupItemConverter
    Inherits ExpandableObjectConverter

    Public Overloads Overrides Function CanConvertTo(ByVal context As ITypeDescriptorContext, ByVal destinationType As Type) As Boolean
        If destinationType Is GetType(InstanceDescriptor) Then Return True

        Return MyBase.CanConvertTo(context, destinationType)
    End Function

    Public Overloads Overrides Function ConvertTo(ByVal context As ITypeDescriptorContext, ByVal culture As CultureInfo, ByVal value As Object, ByVal destinationType As Type) As Object
        If destinationType Is GetType(InstanceDescriptor) Then
            Dim item As GroupItem = DirectCast(value, GroupItem)
            Dim ci As ConstructorInfo = GetType(GroupItem).GetConstructor(New Type() {GetType(String), GetType(String)})
            Return New InstanceDescriptor(ci, New Object() {item.GroupTitle, item.RowFilter})
        End If

        Return MyBase.ConvertTo(context, culture, value, destinationType)
    End Function
End Class
