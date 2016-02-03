''' <summary>An export file with greater than 200000 records is too large to process in memory.</summary>
''' <CreatedBy>Tony Piccoli</CreatedBy>
''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
<Serializable()> _
Public Class FileTooLargeToProcessException
    Inherits Exception

    Public Sub New()

        MyBase.New()

    End Sub

    Public Sub New(ByVal message As String)

        MyBase.New(message)

    End Sub

    Public Sub New(ByVal message As String, ByVal innerException As Exception)

        MyBase.New(message, innerException)

    End Sub


    Protected Sub New(ByVal info As System.Runtime.Serialization.SerializationInfo, ByVal context As System.Runtime.Serialization.StreamingContext)

        MyBase.New(info, context)

    End Sub

End Class

