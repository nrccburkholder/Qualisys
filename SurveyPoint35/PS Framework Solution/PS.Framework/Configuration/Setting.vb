Imports System.Configuration

Namespace Configuration
    Public Class GlobalSettingCollection
        Inherits ConfigurationElementCollection

        Protected Overloads Overrides Function CreateNewElement() As System.Configuration.ConfigurationElement
            Return New Setting
        End Function

        Protected Overrides Function GetElementKey(ByVal element As System.Configuration.ConfigurationElement) As Object
            Return CType(element, Setting).Name
        End Function
        Public Overrides ReadOnly Property CollectionType() As System.Configuration.ConfigurationElementCollectionType
            Get
                Return ConfigurationElementCollectionType.BasicMap
            End Get
        End Property
        Protected Overrides ReadOnly Property ElementName() As String
            Get
                Return "Setting"
            End Get
        End Property
        Default Public Shadows Property Item(ByVal index As Integer) As Setting
            Get
                Return CType(BaseGet(index), Setting)
            End Get
            Set(ByVal value As Setting)
                If Not (BaseGet(index) Is Nothing) Then
                    BaseRemoveAt(index)
                End If
                BaseAdd(index, value)
            End Set
        End Property
        Default Public Shadows ReadOnly Property Item(ByVal Name As String) As Setting
            Get
                Return CType(BaseGet(Name), Setting)
            End Get
        End Property
    End Class
    Public Class SettingCollection
        Inherits ConfigurationElementCollection

        Protected Overloads Overrides Function CreateNewElement() As System.Configuration.ConfigurationElement
            Return New Setting
        End Function

        Protected Overrides Function GetElementKey(ByVal element As System.Configuration.ConfigurationElement) As Object
            Return CType(element, Setting).Name
        End Function

        Public Overrides ReadOnly Property CollectionType() As System.Configuration.ConfigurationElementCollectionType
            Get
                Return ConfigurationElementCollectionType.BasicMap
            End Get
        End Property
        Protected Overrides ReadOnly Property ElementName() As String
            Get
                Return "Setting"
            End Get
        End Property
        Default Public Shadows Property Item(ByVal index As Integer) As Setting
            Get
                Return CType(BaseGet(index), Setting)
            End Get
            Set(ByVal value As Setting)
                If Not (BaseGet(index) Is Nothing) Then
                    BaseRemoveAt(index)
                End If
                BaseAdd(index, value)
            End Set
        End Property
        Default Public Shadows ReadOnly Property Item(ByVal Name As String) As Setting
            Get
                Return CType(BaseGet(Name), Setting)
            End Get
        End Property
    End Class


    Public Class Setting
        Inherits ConfigurationElement
        Private Shared mKeyData As Byte()
        Private Shared mVectorData As Byte()
        Private Shared mCryptoHelper As PS.Framework.Security.CryptoHelper

        Shared Sub New()
            mKeyData = New Byte() {78, 82, 67, 32, 68, 66, 67, 111, 110, 110, 101, 99, 116, 105, 111, 110}
            mVectorData = New Byte() {78, 82, 67, 83, 81, 76, 68, 66}
            mCryptoHelper = PS.Framework.Security.CryptoHelper.CreateTripleDESCryptoHelper(mKeyData, mVectorData)
        End Sub

        <ConfigurationProperty("name", IsRequired:=True, IsKey:=True)> _
        Public Property Name() As String
            Get
                Return CStr(Me("name"))
            End Get
            Set(ByVal value As String)
                Me("name") = value
            End Set
        End Property
        <ConfigurationProperty("value", IsRequired:=True)> _
        Public Property Value() As String
            Get
                If IsEncrypted Then
                    Return mCryptoHelper.DecryptString(CStr(Me("value")))
                Else
                    Return CStr(Me("value"))
                End If
            End Get
            Set(ByVal value As String)
                Me("value") = value
            End Set
        End Property
        <ConfigurationProperty("isEncrypted", IsRequired:=True)> _
        Public Property IsEncrypted() As Boolean
            Get
                Return CBool(Me("isEncrypted"))
            End Get
            Set(ByVal value As Boolean)
                Me("isEncrypted") = value
            End Set
        End Property        
    End Class
End Namespace
