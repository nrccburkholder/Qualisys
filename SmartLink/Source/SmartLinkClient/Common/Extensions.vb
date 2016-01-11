Imports System.Runtime.CompilerServices
Imports System.Xml

Module Extensions

    ''' <summary>
    ''' Convert XmlNode to XElement
    ''' </summary>
    <Extension()>
    Public Function GetXElement(node As XmlNode) As XElement
        Dim xDoc As New XDocument()
        Using xmlWriter As XmlWriter = xDoc.CreateWriter()
            node.WriteTo(xmlWriter)
        End Using
        Return xDoc.Root
    End Function

    ''' <summary>
    ''' Convert XElement to XmlNode
    ''' </summary>
    <Extension()>
    Public Function GetXmlNode(element As XElement) As XmlNode
        Using xmlReader As XmlReader = element.CreateReader()
            Dim xmlDoc As New XmlDocument()
            xmlDoc.Load(xmlReader)
            If Not xmlDoc.ChildNodes Is Nothing AndAlso xmlDoc.ChildNodes.Count > 0 Then
                Return xmlDoc.ChildNodes(0)
            End If
            Return xmlDoc
        End Using
    End Function

End Module
