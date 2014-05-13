''' <summary>Wrapper class containing attachment path info that the active up object will use to attatch a file to an email</summary>
''' <CreatedBy>Jeff Fleming</CreatedBy>
''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
Public Class Attachment

    Private mFilePath As String = String.Empty

    ''' <summary>File path of the attachment you are trying to send.</summary>
    ''' <value></value>
    ''' <CreatedBy>Jeff Fleming</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public ReadOnly Property FilePath() As String
        Get
            Return mFilePath
        End Get
    End Property

    ''' <summary>Constructor states you must path in the file path of the attachment you are trying to send.</summary>
    ''' <param name="filePath"></param>
    ''' <CreatedBy>Jeff Fleming</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Sub New(ByVal filePath As String)

        mFilePath = filePath

    End Sub

End Class
