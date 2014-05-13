Imports System.Configuration
Imports System.Xml

Namespace Configuration
    Public Class RSCMSectionHandler
        Implements IConfigurationSectionHandler

        Public Function Create(ByVal parent As Object, ByVal configContext As Object, ByVal section As System.Xml.XmlNode) As Object Implements IConfigurationSectionHandler.Create
            Return RSCMConfig.FromXML(section)
        End Function
    End Class

End Namespace
