Imports System.Configuration

Namespace Configuration

    Public Class EnvironmentCollection
        Inherits ConfigurationElementCollection

        Protected Overloads Overrides Function CreateNewElement() As System.Configuration.ConfigurationElement
            Return New Environment
        End Function

        Protected Overrides Function GetElementKey(ByVal element As System.Configuration.ConfigurationElement) As Object
            Return CType(element, Environment).Name
        End Function

        Public Overrides ReadOnly Property CollectionType() As System.Configuration.ConfigurationElementCollectionType
            Get
                Return ConfigurationElementCollectionType.BasicMap
            End Get
        End Property
        Protected Overrides ReadOnly Property ElementName() As String
            Get
                Return "Environment"
            End Get
        End Property
        Default Public Shadows Property Item(ByVal index As Integer) As Environment
            Get
                Return CType(BaseGet(index), Environment)
            End Get
            Set(ByVal value As Environment)
                If Not (BaseGet(index) Is Nothing) Then
                    BaseRemoveAt(index)
                End If
                BaseAdd(index, value)
            End Set
        End Property
        Default Public Shadows ReadOnly Property Item(ByVal Name As String) As Environment
            Get
                Return CType(BaseGet(Name), Environment)
            End Get
        End Property
    End Class

    Public Class Environment
        Inherits ConfigurationElement

        <ConfigurationProperty("name", IsRequired:=True, IsKey:=True)> _
        Public Property Name() As String
            Get
                Return CStr(Me("name"))
            End Get
            Set(ByVal value As String)
                Me("name") = value
            End Set
        End Property

        <ConfigurationProperty("Settings", IsDefaultCollection:=False), ConfigurationCollection(GetType(SettingCollection))> _
       Public ReadOnly Property Settings() As SettingCollection
            Get
                Dim col As SettingCollection = CType(MyBase.Item("Settings"), SettingCollection)
                Return col
            End Get
        End Property
    End Class
End Namespace
