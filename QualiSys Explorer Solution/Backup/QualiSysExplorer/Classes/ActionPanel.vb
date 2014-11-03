Imports NRC.QualiSys.Library

Public Class ActionPanel
    Inherits UserControl


#Region " ActionTaken Event "
    Public Class ActionTakenEventArgs
        Inherits EventArgs

        Private mMessage As String

        Public ReadOnly Property Message() As String
            Get
                Return mMessage
            End Get
        End Property

        Public Sub New(ByVal message As String)
            mMessage = message
        End Sub
    End Class
    Public Delegate Sub ActionTakenEventHandler(ByVal sender As Object, ByVal e As ActionTakenEventArgs)
    Public Event ActionTaken As ActionTakenEventHandler
#End Region

    Private mMailing As Mailing
    Private mDisposition As QDisposition
    Private mReceiptType As ReceiptType

    Protected ReadOnly Property Mailing() As Mailing
        Get
            Return mMailing
        End Get
    End Property

    Protected ReadOnly Property Disposition() As QDisposition
        Get
            Return mDisposition
        End Get
    End Property

    Protected ReadOnly Property ReceiptType() As ReceiptType
        Get
            Return mReceiptType
        End Get
    End Property

    Protected Overridable Sub OnActionTaken(ByVal e As ActionTakenEventArgs)
        RaiseEvent ActionTaken(Me, e)
    End Sub

    Public Overridable Sub LoadPanel(ByVal mail As Mailing, ByVal dispo As QDisposition, ByVal receiptMethod As ReceiptType)
        mMailing = mail
        mDisposition = dispo
        mReceiptType = receiptMethod
    End Sub

End Class
