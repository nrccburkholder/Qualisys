Public Class CustomerSelectedEventArgs
    Inherits EventArgs
#Region " Fields "
    Private mCustomerID
#End Region
#Region " Properties "
    Public Property CustomerID() As String
        Get
            Return mCustomerID
        End Get
        Set(ByVal value As String)
            mCustomerID = value
        End Set
    End Property
#End Region
#Region " Constructors "
    Public Sub New(ByVal custID As String)
        mCustomerID = custID
    End Sub
#End Region
End Class