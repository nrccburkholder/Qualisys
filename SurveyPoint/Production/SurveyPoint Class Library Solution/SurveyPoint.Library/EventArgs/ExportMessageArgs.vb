''' <summary>USed to pass object messages up the object chain of a file export.</summary>
''' <CreatedBy>Tony Piccoli</CreatedBy>
''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
Public Class ExportMessageArgs
    Inherits EventArgs

#Region " Private Fields "
    Private mExportMessage As ExportObjectMessage
#End Region
#Region " Constructors "
    Public Sub New(ByVal exportMessage As ExportObjectMessage)
        Me.mExportMessage = exportmessage
    End Sub
#End Region
#Region " Public properties "
    Public ReadOnly Property ExportObjectMessage() As ExportObjectMessage
        Get
            Return Me.mExportMessage
        End Get
    End Property
#End Region
End Class
