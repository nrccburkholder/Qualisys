Imports Nrc.QualiSys.Library
Imports Nrc.Framework.AddressCleaning
Imports Nrc.Framework.BusinessLogic.Configuration

Public Class ChangeAddressPanel
    Inherits ActionPanel

#Region " Windows Form Designer generated code "

    Public Sub New()
        MyBase.New()

        'This call is required by the Windows Form Designer.
        InitializeComponent()

        'Add any initialization after the InitializeComponent() call

    End Sub

    'UserControl overrides dispose to clean up the component list.
    Protected Overloads Overrides Sub Dispose(ByVal disposing As Boolean)
        If disposing Then
            If Not (components Is Nothing) Then
                components.Dispose()
            End If
        End If
        MyBase.Dispose(disposing)
    End Sub

    'Required by the Windows Form Designer
    Private components As System.ComponentModel.IContainer

    'NOTE: The following procedure is required by the Windows Form Designer
    'It can be modified using the Windows Form Designer.  
    'Do not modify it using the code editor.
    Friend WithEvents Address1Label As System.Windows.Forms.Label
    Friend WithEvents Address2Label As System.Windows.Forms.Label
    Friend WithEvents CityLabel As System.Windows.Forms.Label
    Friend WithEvents StateLabel As System.Windows.Forms.Label
    Friend WithEvents CountryLabel As System.Windows.Forms.Label
    Friend WithEvents Address1 As System.Windows.Forms.TextBox
    Friend WithEvents Address2 As System.Windows.Forms.TextBox
    Friend WithEvents City As System.Windows.Forms.TextBox
    Friend WithEvents Country As System.Windows.Forms.ComboBox
    Friend WithEvents PostalCodeLabel As System.Windows.Forms.Label
    Friend WithEvents PostalCode As System.Windows.Forms.TextBox
    Friend WithEvents StateProv As System.Windows.Forms.ComboBox
    Friend WithEvents ChangeAddressButton As System.Windows.Forms.Button
    Friend WithEvents ActionLabel As System.Windows.Forms.Label
    Friend WithEvents ValidationError As System.Windows.Forms.ErrorProvider
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.Address1Label = New System.Windows.Forms.Label
        Me.Address2Label = New System.Windows.Forms.Label
        Me.CityLabel = New System.Windows.Forms.Label
        Me.StateLabel = New System.Windows.Forms.Label
        Me.CountryLabel = New System.Windows.Forms.Label
        Me.Address1 = New System.Windows.Forms.TextBox
        Me.Address2 = New System.Windows.Forms.TextBox
        Me.City = New System.Windows.Forms.TextBox
        Me.Country = New System.Windows.Forms.ComboBox
        Me.StateProv = New System.Windows.Forms.ComboBox
        Me.ChangeAddressButton = New System.Windows.Forms.Button
        Me.ActionLabel = New System.Windows.Forms.Label
        Me.PostalCodeLabel = New System.Windows.Forms.Label
        Me.PostalCode = New System.Windows.Forms.TextBox
        Me.ValidationError = New System.Windows.Forms.ErrorProvider
        Me.SuspendLayout()
        '
        'Address1Label
        '
        Me.Address1Label.Location = New System.Drawing.Point(8, 56)
        Me.Address1Label.Name = "Address1Label"
        Me.Address1Label.Size = New System.Drawing.Size(88, 23)
        Me.Address1Label.TabIndex = 0
        Me.Address1Label.Text = "Address 1:"
        Me.Address1Label.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'Address2Label
        '
        Me.Address2Label.Location = New System.Drawing.Point(8, 80)
        Me.Address2Label.Name = "Address2Label"
        Me.Address2Label.Size = New System.Drawing.Size(88, 23)
        Me.Address2Label.TabIndex = 0
        Me.Address2Label.Text = "Address 2:"
        Me.Address2Label.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'CityLabel
        '
        Me.CityLabel.Location = New System.Drawing.Point(8, 104)
        Me.CityLabel.Name = "CityLabel"
        Me.CityLabel.Size = New System.Drawing.Size(88, 23)
        Me.CityLabel.TabIndex = 0
        Me.CityLabel.Text = "City:"
        Me.CityLabel.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'StateLabel
        '
        Me.StateLabel.Location = New System.Drawing.Point(8, 152)
        Me.StateLabel.Name = "StateLabel"
        Me.StateLabel.Size = New System.Drawing.Size(88, 23)
        Me.StateLabel.TabIndex = 0
        Me.StateLabel.Text = "State/Province:"
        Me.StateLabel.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'CountryLabel
        '
        Me.CountryLabel.Location = New System.Drawing.Point(8, 128)
        Me.CountryLabel.Name = "CountryLabel"
        Me.CountryLabel.Size = New System.Drawing.Size(88, 23)
        Me.CountryLabel.TabIndex = 0
        Me.CountryLabel.Text = "Country:"
        Me.CountryLabel.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'Address1
        '
        Me.Address1.Location = New System.Drawing.Point(104, 56)
        Me.Address1.MaxLength = 42
        Me.Address1.Name = "Address1"
        Me.Address1.Size = New System.Drawing.Size(184, 21)
        Me.Address1.TabIndex = 1
        Me.Address1.Text = ""
        '
        'Address2
        '
        Me.Address2.Location = New System.Drawing.Point(104, 80)
        Me.Address2.MaxLength = 42
        Me.Address2.Name = "Address2"
        Me.Address2.Size = New System.Drawing.Size(184, 21)
        Me.Address2.TabIndex = 2
        Me.Address2.Text = ""
        '
        'City
        '
        Me.City.Location = New System.Drawing.Point(104, 104)
        Me.City.MaxLength = 42
        Me.City.Name = "City"
        Me.City.Size = New System.Drawing.Size(184, 21)
        Me.City.TabIndex = 3
        Me.City.Text = ""
        '
        'Country
        '
        Me.Country.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.Country.Items.AddRange(New Object() {"United States", "Canada"})
        Me.Country.Location = New System.Drawing.Point(104, 128)
        Me.Country.Name = "Country"
        Me.Country.Size = New System.Drawing.Size(184, 21)
        Me.Country.TabIndex = 4
        '
        'StateProv
        '
        Me.StateProv.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.StateProv.Location = New System.Drawing.Point(104, 152)
        Me.StateProv.MaxDropDownItems = 15
        Me.StateProv.Name = "StateProv"
        Me.StateProv.Size = New System.Drawing.Size(184, 21)
        Me.StateProv.TabIndex = 5
        '
        'ChangeAddressButton
        '
        Me.ChangeAddressButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.ChangeAddressButton.FlatStyle = System.Windows.Forms.FlatStyle.System
        Me.ChangeAddressButton.Location = New System.Drawing.Point(216, 280)
        Me.ChangeAddressButton.Name = "ChangeAddressButton"
        Me.ChangeAddressButton.Size = New System.Drawing.Size(96, 23)
        Me.ChangeAddressButton.TabIndex = 7
        Me.ChangeAddressButton.Text = "Change Address"
        '
        'ActionLabel
        '
        Me.ActionLabel.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.ActionLabel.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold)
        Me.ActionLabel.Location = New System.Drawing.Point(8, 16)
        Me.ActionLabel.Name = "ActionLabel"
        Me.ActionLabel.Size = New System.Drawing.Size(304, 40)
        Me.ActionLabel.TabIndex = 0
        Me.ActionLabel.Text = "The respondent's address will be changed in the study population table."
        '
        'PostalCodeLabel
        '
        Me.PostalCodeLabel.Location = New System.Drawing.Point(8, 176)
        Me.PostalCodeLabel.Name = "PostalCodeLabel"
        Me.PostalCodeLabel.Size = New System.Drawing.Size(88, 23)
        Me.PostalCodeLabel.TabIndex = 5
        Me.PostalCodeLabel.Text = "Zip/Postal Code:"
        Me.PostalCodeLabel.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'PostalCode
        '
        Me.PostalCode.Location = New System.Drawing.Point(104, 176)
        Me.PostalCode.MaxLength = 10
        Me.PostalCode.Name = "PostalCode"
        Me.PostalCode.Size = New System.Drawing.Size(184, 21)
        Me.PostalCode.TabIndex = 6
        Me.PostalCode.Text = ""
        '
        'ValidationError
        '
        Me.ValidationError.ContainerControl = Me
        '
        'ChangeAddressPanel
        '
        Me.Controls.Add(Me.PostalCode)
        Me.Controls.Add(Me.PostalCodeLabel)
        Me.Controls.Add(Me.ChangeAddressButton)
        Me.Controls.Add(Me.Country)
        Me.Controls.Add(Me.Address1)
        Me.Controls.Add(Me.Address1Label)
        Me.Controls.Add(Me.Address2Label)
        Me.Controls.Add(Me.CityLabel)
        Me.Controls.Add(Me.StateLabel)
        Me.Controls.Add(Me.CountryLabel)
        Me.Controls.Add(Me.Address2)
        Me.Controls.Add(Me.City)
        Me.Controls.Add(Me.StateProv)
        Me.Controls.Add(Me.ActionLabel)
        Me.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Name = "ChangeAddressPanel"
        Me.Size = New System.Drawing.Size(320, 312)
        Me.ResumeLayout(False)

    End Sub

#End Region

#Region " Private Properties "

    Private ReadOnly Property SelectedCountry() As CountryIDs
        Get
            Select Case Country.Text.ToUpper()
                Case "UNITED STATES"
                    Return CountryIDs.US

                Case "CANADA"
                    Return CountryIDs.Canada

            End Select
        End Get
    End Property

    Private ReadOnly Property SelectedState() As State
        Get
            Return DirectCast(StateProv.SelectedItem, State)
        End Get
    End Property

    Private ReadOnly Property FormIsValid() As Boolean
        Get
            Dim isValid As Boolean = True

            If Address1.Text.Trim.Length = 0 Then
                ValidationError.SetError(Address1, "You must enter an address.")
                isValid = False
            Else
                ValidationError.SetError(Address1, Nothing)
            End If

            If City.Text.Trim.Length = 0 Then
                ValidationError.SetError(City, "You must enter a city.")
                isValid = False
            Else
                ValidationError.SetError(City, Nothing)
            End If

            If PostalCode.Text.Trim.Length = 0 Then
                ValidationError.SetError(PostalCode, "You must enter a zip/postal code.")
                isValid = False
            Else
                ValidationError.SetError(PostalCode, Nothing)
            End If

            Return isValid
        End Get
    End Property

#End Region

#Region " Event Handlers "

    Private Sub ChangeAddressPanel_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles MyBase.Load

        If QualisysParams.CountryCode = CountryCode.UnitedStates Then
            Country.SelectedIndex = 0
            PostalCode.MaxLength = 10
        Else
            Country.SelectedIndex = 1
            PostalCode.MaxLength = 7
        End If

        Country.Enabled = False

    End Sub

    Private Sub Country_SelectedIndexChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Country.SelectedIndexChanged

        If Country.SelectedIndex > -1 Then
            Select Case SelectedCountry
                Case CountryIDs.US
                    LoadStateList(StateCollection.GetStates)

                Case CountryIDs.Canada
                    LoadStateList(StateCollection.GetProvinces)

            End Select
        End If

    End Sub

    Private Sub ChangeAddressButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ChangeAddressButton.Click

        'Validate the form
        If Not FormIsValid Then Exit Sub

        'Create the cleaner
        Dim addrCleaner As Cleaner = New Cleaner(SelectedCountry, LoadDatabases.QPLoad)
        Dim addr As Address = Address.NewAddress
        addrCleaner.Addresses.Add(addr)

        Try
            'Set the cursor
            ParentForm.Cursor = Cursors.WaitCursor

            'Set the address objects values
            With addr
                .OriginalAddress.StreetLine1 = Address1.Text
                .OriginalAddress.StreetLine2 = Address2.Text
                .OriginalAddress.City = City.Text
            End With

            Select Case SelectedCountry
                Case CountryIDs.US
                    With addr
                        .OriginalAddress.State = SelectedState.Value
                        .OriginalAddress.Zip5 = PostalCode.Text
                    End With

                Case CountryIDs.Canada
                    With addr
                        .OriginalAddress.Province = SelectedState.Value
                        .OriginalAddress.Postal = PostalCode.Text
                    End With

                Case Else
                    Throw New ArgumentException("Unable to determine a valid country code.")

            End Select


            'Determine if we need to use a web proxy
            Dim forceProxy As Boolean = ((AppConfig.Params("WebServiceProxyRequiredClient").IntegerValue = 1) OrElse System.Diagnostics.Debugger.IsAttached)

            'Clean the address
            addrCleaner.Addresses.Clean(forceProxy)

            'Set the returned address
            With addr
                Address1.Text = .CleanedAddress.StreetLine1
                Address2.Text = .CleanedAddress.StreetLine2
                City.Text = .CleanedAddress.City

                Select Case SelectedCountry
                    Case CountryIDs.US
                        PostalCode.Text = String.Format("{0}-{1}", .CleanedAddress.Zip5, .CleanedAddress.Zip4)
                        SetState(.CleanedAddress.State)

                        'Change address USA
                        Mailing.ChangeRespondentAddress(Disposition.Id, ReceiptType.Id, CurrentUser.UserName, .CleanedAddress.StreetLine1, .CleanedAddress.StreetLine2, .CleanedAddress.City, .CleanedAddress.DeliveryPoint, .CleanedAddress.State, .CleanedAddress.Zip5, .CleanedAddress.Zip4, .CleanedAddress.AddressStatus, .CleanedAddress.AddressError)

                    Case CountryIDs.Canada
                        PostalCode.Text = .CleanedAddress.Postal
                        SetState(.CleanedAddress.Province)

                        'Change address CA
                        Mailing.ChangeRespondentAddress(Disposition.Id, ReceiptType.Id, CurrentUser.UserName, .CleanedAddress.StreetLine1, .CleanedAddress.StreetLine2, .CleanedAddress.City, .CleanedAddress.DeliveryPoint, .CleanedAddress.Province, .CleanedAddress.Postal, .CleanedAddress.AddressStatus, .CleanedAddress.AddressError)

                End Select

            End With

            OnActionTaken(New ActionTakenEventArgs("The address was successfully updated.  It may take up to five minutes for this change to take affect."))

        Finally
            ParentForm.Cursor = Cursors.Default

        End Try

    End Sub

#End Region

#Region " Private Methods "

    Private Sub LoadStateList(ByVal states As StateCollection)

        StateProv.Items.Clear()
        StateProv.DisplayMember = "Label"
        StateProv.ValueMember = "Value"

        For Each st As State In states
            StateProv.Items.Add(st)
        Next

        StateProv.SelectedIndex = 0

    End Sub

    Private Sub SetState(ByVal abbr As String)

        For Each st As State In StateProv.Items
            If st.Value.ToLower = abbr.ToLower Then
                StateProv.SelectedItem = st
                Exit For
            End If
        Next

    End Sub

#End Region

#Region " State Collection "

    Public Class State

        Private mLabel As String
        Private mValue As String

        Public ReadOnly Property Label() As String
            Get
                Return mLabel
            End Get
        End Property

        Public ReadOnly Property Value() As String
            Get
                Return mValue
            End Get
        End Property

        Public Sub New(ByVal value As String, ByVal label As String)

            mLabel = label
            mValue = value

        End Sub

    End Class

    Public Class StateCollection
        Inherits CollectionBase

        Default Public ReadOnly Property Item(ByVal index As Integer) As State
            Get
                Return DirectCast(MyBase.List(index), State)
            End Get
        End Property

        Public Function Add(ByVal st As State) As Integer

            Return MyBase.List.Add(st)

        End Function

        Public Shared Function GetProvinces() As StateCollection

            Dim states As New StateCollection

            states.Add(New State("AB", "Alberta"))
            states.Add(New State("BC", "British Columbia"))
            states.Add(New State("MB", "Manitoba"))
            states.Add(New State("NB", "New Brunswick"))
            states.Add(New State("NL", "Newfoundland and Labrador"))
            states.Add(New State("NT", "Northwest Territories"))
            states.Add(New State("NS", "Nova Scotia"))
            states.Add(New State("NU", "Nunavut"))
            states.Add(New State("PE", "Prince Edward Island"))
            states.Add(New State("QC", "Quebec"))
            states.Add(New State("ON", "Ontario"))
            states.Add(New State("SK", "Saskatchewan"))
            states.Add(New State("YT", "Yukon Territory"))

            Return states

        End Function

        Public Shared Function GetStates() As StateCollection

            Dim states As New StateCollection

            states.Add(New State("AL", "Alabama"))
            states.Add(New State("AK", "Alaska"))
            states.Add(New State("AZ", "Arizona"))
            states.Add(New State("AR", "Arkansas"))
            states.Add(New State("CA", "California"))
            states.Add(New State("CO", "Colorado"))
            states.Add(New State("CT", "Connecticut"))
            states.Add(New State("DE", "Delaware"))
            states.Add(New State("DC", "District of Columbia"))
            states.Add(New State("FL", "Florida"))
            states.Add(New State("GA", "Georgia"))
            states.Add(New State("HI", "Hawaii"))
            states.Add(New State("ID", "Idaho"))
            states.Add(New State("IL", "Illinois"))
            states.Add(New State("IN", "Indiana"))
            states.Add(New State("IA", "Iowa"))
            states.Add(New State("KS", "Kansas"))
            states.Add(New State("KY", "Kentucky"))
            states.Add(New State("LA", "Louisiana"))
            states.Add(New State("ME", "Maine"))
            states.Add(New State("MD", "Maryland"))
            states.Add(New State("MA", "Massachusetts"))
            states.Add(New State("MI", "Michigan"))
            states.Add(New State("MN", "Minnesota"))
            states.Add(New State("MS", "Mississippi"))
            states.Add(New State("MO", "Missouri"))
            states.Add(New State("MT", "Montana"))
            states.Add(New State("NE", "Nebraska"))
            states.Add(New State("NV", "Nevada"))
            states.Add(New State("NH", "New Hampshire"))
            states.Add(New State("NJ", "New Jersey"))
            states.Add(New State("NM", "New Mexico"))
            states.Add(New State("NY", "New York"))
            states.Add(New State("NC", "North Carolina"))
            states.Add(New State("ND", "North Dakota"))
            states.Add(New State("OH", "Ohio"))
            states.Add(New State("OK", "Oklahoma"))
            states.Add(New State("OR", "Oregon"))
            states.Add(New State("PA", "Pennsylvania"))
            states.Add(New State("RI", "Rhode Island"))
            states.Add(New State("SC", "South Carolina"))
            states.Add(New State("SD", "South Dakota"))
            states.Add(New State("TN", "Tennessee"))
            states.Add(New State("TX", "Texas"))
            states.Add(New State("UT", "Utah"))
            states.Add(New State("VT", "Vermont"))
            states.Add(New State("VA", "Virginia"))
            states.Add(New State("WA", "Washington"))
            states.Add(New State("WV", "West Virginia"))
            states.Add(New State("WI", "Wisconsin"))
            states.Add(New State("WY", "Wyoming"))

            Return states

        End Function

    End Class

#End Region

End Class

