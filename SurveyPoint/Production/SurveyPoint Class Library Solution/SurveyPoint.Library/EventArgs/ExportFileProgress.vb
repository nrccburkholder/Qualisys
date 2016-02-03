''' <summary>Event arguements to pass export file progress back up the object chain.</summary>
''' <CreatedBy>Tony Piccoli</CreatedBy>
''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
Public Class ExportFileProgress
    Inherits EventArgs

#Region " Private Fields "
    Private mPercentComplete As Integer
    Private mProgressMessage As String = String.Empty
    Private mAbort As Boolean = False
#End Region
#Region " Constructors "
    Public Sub New(ByVal percentComplete As Integer, ByVal progressMessage As String, ByVal abort As Boolean)
        Me.mAbort = abort
        Me.mPercentComplete = percentComplete
        Me.mProgressMessage = progressMessage
    End Sub
#End Region
#Region " Public Properties "
    ''' <summary>An Int value representing how much of the export is complete.</summary>
    ''' <value>Integer</value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public ReadOnly Property PercentComplete() As Integer
        Get
            Return Me.mPercentComplete
        End Get
    End Property
    ''' <summary>A message associated with the progress of the file export.</summary>
    ''' <value>String</value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public ReadOnly Property ProgressMessage() As String
        Get
            Return Me.mProgressMessage
        End Get
    End Property
    ''' <summary>Flag that notifies whether to file export has been aborted.</summary>
    ''' <value>Boolean</value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public ReadOnly Property Abort() As Boolean
        Get
            Return Me.mAbort
        End Get
    End Property
#End Region
End Class
