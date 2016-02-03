Imports TestFramework.Library
Public Class CustomerSection
    Private mSubSection As Section
    Friend WithEvents mNavigator As CustomerNavigator
    Private mCurrentCustomer As Customer = Nothing
    Private mCustomers As Customers = Nothing    
#Region "Baseclass Overrides"
    Public Overrides Sub RegisterNavControl(ByVal navCtrl As Navigator)
        mNavigator = DirectCast(navCtrl, CustomerNavigator)
    End Sub
    Public Overrides Function AllowInactivate() As Boolean
        If mSubSection Is Nothing Then
            Return True
        Else
            Return mSubSection.AllowInactivate
        End If
    End Function
#End Region
#Region " Events "
    Private Sub mNavigator_CustomerSelected(ByVal sender As Object, ByVal e As CustomerSelectedEventArgs) Handles mNavigator.CustomerSelected        
        PopulateScreen(e.CustomerID)
    End Sub
#End Region
#Region " Methods "
    Private Sub PopulateScreen(ByVal custID As String)
        Me.mCurrentCustomer = Customer.GetCustomer(custID)
        Me.mCustomers = Customer.GetCustomers
        LoadScreen()
    End Sub
    Private Sub LoadScreen()
        bsCustomer.DataSource = mCustomers
        Me.txtCompName.Text = Me.mCurrentCustomer.CompanyName
        Me.txtName.Text = Me.mCurrentCustomer.ContactName
        Me.txtTitle.Text = Me.mCurrentCustomer.ContactTitle
        Me.txtAddress.Text = Me.mCurrentCustomer.Address
        Me.txtCity.Text = Me.mCurrentCustomer.City
        Me.txtRegion.Text = Me.mCurrentCustomer.Region
        Me.txtPostalCode.Text = Me.mCurrentCustomer.Postalcode
        Me.txtCountry.Text = Me.mCurrentCustomer.Country
        Me.txtPhone.Text = Me.mCurrentCustomer.Phone
        Me.txtFax.Text = Me.mCurrentCustomer.Fax
    End Sub
#End Region

    
    Private Sub grdCustomers_MouseClick(ByVal sender As Object, ByVal e As System.Windows.Forms.MouseEventArgs) Handles grdCustomers.MouseClick
        'No the most efficient way, but I'm just showing an example.
        If e.Button = Windows.Forms.MouseButtons.Left Then
            Dim cust As Customer = Nothing
            cust = TryCast(bsCustomer.Current, Customer)
            If cust IsNot Nothing Then
                PopulateScreen(cust.CustomerID)
            End If
        End If
    End Sub

    Private Sub cmdDialog_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdDialog.Click
        Dim dialog As New SampleDialog
        dialog.ShowDialog()
    End Sub
End Class
