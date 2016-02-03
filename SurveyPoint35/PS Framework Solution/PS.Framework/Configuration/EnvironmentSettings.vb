Imports System
Imports System.Configuration

Namespace Configuration

    Public Class EnvironmentSettings
        Inherits ConfigurationSection

        <ConfigurationProperty("useDomainDiscovery", IsRequired:=True)> _
        Public ReadOnly Property UseDomainDiscovery() As Boolean
            Get
                Return CBool(Me("useDomainDiscovery"))
            End Get
        End Property

        <ConfigurationProperty("selectedEnvironment", IsRequired:=True)> _
        Public ReadOnly Property SelectedEnvironment() As EnvironmentType
            Get
                If UseDomainDiscovery Then
                    Select Case System.Environment.UserDomainName
                        Case "NRC"
                            Return EnvironmentType.Production
                        Case Else
                            Return EnvironmentType.Test
                    End Select
                Else
                    Return [Enum].Parse(GetType(EnvironmentType), CStr(Me("selectedEnvironment")))
                End If
            End Get
        End Property

        Public ReadOnly Property CurrentEnvironment() As Environment
            Get
                Return Me.Environments([Enum].GetName(GetType(EnvironmentType), SelectedEnvironment))
            End Get
        End Property

        <ConfigurationProperty("Environments", IsDefaultCollection:=False), ConfigurationCollection(GetType(EnvironmentCollection))> _
        Public ReadOnly Property Environments() As EnvironmentCollection
            Get
                Dim col As EnvironmentCollection = CType(MyBase.Item("Environments"), EnvironmentCollection)
                Return col
            End Get
        End Property
        <ConfigurationProperty("GlobalSettings", IsDefaultCollection:=False), ConfigurationCollection(GetType(GlobalSettingCollection))> _
        Public ReadOnly Property GlobalSettings() As GlobalSettingCollection
            Get
                Dim col As GlobalSettingCollection = CType(MyBase.Item("GlobalSettings"), GlobalSettingCollection)
                Return col
            End Get
        End Property
    End Class

End Namespace
