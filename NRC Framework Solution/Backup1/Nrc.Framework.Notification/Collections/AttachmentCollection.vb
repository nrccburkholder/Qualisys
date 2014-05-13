''' <summary>Represents a list of attachment objects.</summary>
''' <CreatedBy>Jeff Fleming</CreatedBy>
''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
Public Class AttachmentCollection
    Inherits List(Of Attachment)

    ''' <summary>Adds to the list with an attachment object.</summary>
    ''' <param name="attachment"></param>
    ''' <CreatedBy>Jeff Fleming</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Overloads Sub Add(ByVal attachment As Attachment)

        MyBase.Add(attachment)

    End Sub

    ''' <summary>Adds to the list with a filepath as a string.</summary>
    ''' <param name="fileName"></param>
    ''' <CreatedBy>Jeff Fleming</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Overloads Sub Add(ByVal fileName As String)

        MyBase.Add(New Attachment(fileName))

    End Sub

End Class
