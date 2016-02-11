Imports Nrc.Framework.BusinessLogic
Imports Nrc.SurveyPoint.Library.DataProviders
Imports Nrc.Framework.BusinessLogic.Validation

Public Interface IExportObjectMessage
    Property ExportObjectMessageID() As Integer
End Interface

''' <summary>This object records messages during an export</summary>
''' <CreatedBy>Tony Piccoli</CreatedBy>
''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
<Serializable()> _
Public Class ExportObjectMessage
    Inherits BusinessBase(Of ExportObjectMessage)
    Implements IExportObjectMessage

#Region " Private Fields "
    <NotUndoable()> Private mInstanceGuid As Guid = Guid.NewGuid
    Private mExportObjectMessageID As Integer
    Private mMessageType As ExportObjectMessageType
    Private mMessage As String = String.Empty
    Private mErrorNumber As Nullable(Of Long)
    Private mStackTrace As String = String.Empty
    Private mMessageTitle As String = String.Empty
#End Region

#Region " Public Properties "
    ''' <summary>Key value of the Export Message Object.</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property ExportObjectMessageID() As Integer Implements IExportObjectMessage.ExportObjectMessageID
        Get
            Return Me.mExportObjectMessageID
        End Get
        Private Set(ByVal value As Integer)
            If Not value = mExportObjectMessageID Then
                mExportObjectMessageID = value
                PropertyHasChanged("ExportObjectMessageID")
            End If
        End Set
    End Property
    ''' <summary>An enum stating the type of message.</summary>
    ''' <value>ExportObjectMessageType enum.</value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public ReadOnly Property MessageType() As ExportObjectMessageType
        Get
            Return Me.mMessageType
        End Get
    End Property
    ''' <summary>This message for this message object</summary>
    ''' <value>String</value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public ReadOnly Property Message() As String
        Get
            Return Me.mMessage
        End Get
    End Property
    ''' <summary>Allows you to enter an error number if this message is an error.</summary>
    ''' <value>Nullable long integer</value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public ReadOnly Property ErrorNumber() As Nullable(Of Long)
        Get
            If Me.mErrorNumber.HasValue Then
                Return Me.mErrorNumber
            Else
                Return Nothing
            End If
        End Get
    End Property
    ''' <summary>If and error, this allows you to send in the stack trace.</summary>
    ''' <value>String</value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public ReadOnly Property StackTrace() As String
        Get
            Return Me.mStackTrace
        End Get
    End Property
    ''' <summary>The title of the message you are creating.</summary>
    ''' <value>String</value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public ReadOnly Property MessageTitle() As String
        Get
            Return Me.mMessageTitle
        End Get
    End Property
#End Region

#Region " Constructors "

    ''' <summary>Creates and load a new export message object.</summary>
    ''' <param name="messageType"></param>
    ''' <param name="message"></param>
    ''' <param name="errorNumber"></param>
    ''' <param name="stackTrace"></param>
    ''' <param name="messageTitle"></param>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub New(ByVal messageType As ExportObjectMessageType, ByVal message As String, _
        ByVal errorNumber As Nullable(Of Long), ByVal stackTrace As String, ByVal messageTitle As String)
        Me.mMessageType = messageType
        Me.mMessage = message
        Me.mErrorNumber = errorNumber
        Me.mStackTrace = stackTrace
        Me.mMessageTitle = messageTitle
    End Sub
#End Region

#Region " Factory Methods "
    ''' <summary>Factory method to create and load a new export message object.</summary>
    ''' <param name="messageType"></param>
    ''' <param name="message"></param>
    ''' <param name="errorNumber"></param>
    ''' <param name="stackTrace"></param>
    ''' <param name="messageTitle"></param>
    ''' <returns></returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared Function NewExportObjectMessage(ByVal messageType As ExportObjectMessageType, ByVal message As String, _
            ByVal errorNumber As Nullable(Of Long), ByVal stackTrace As String, ByVal messageTitle As String) As ExportObjectMessage
        Return New ExportObjectMessage(messageType, message, errorNumber, stackTrace, messageTitle)
    End Function
#End Region

#Region " Basic Overrides "
    ''' <summary>Allows for key value associate of new objects.</summary>
    ''' <returns></returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Protected Overrides Function GetIdValue() As Object
        If Me.IsNew Then
            Return mInstanceGuid
        Else
            Return Me.mExportObjectMessageID
        End If
    End Function

#End Region

#Region " Validation "
    Protected Overrides Sub AddBusinessRules()
        'Add validation rules here...
    End Sub
#End Region

#Region " Data Access "
    ''' <summary>Save is not implmented for this object.</summary>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Overrides Sub Save()
        Throw New NotImplementedException("This object does not support saving functionality.")
        'MyBase.Save()
    End Sub

#End Region

#Region " Public Methods "

#End Region

End Class