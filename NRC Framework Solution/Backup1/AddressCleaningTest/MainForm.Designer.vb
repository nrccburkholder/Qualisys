<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class MainForm
    Inherits System.Windows.Forms.Form

    'Form overrides dispose to clean up the component list.
    <System.Diagnostics.DebuggerNonUserCode()> _
    Protected Overrides Sub Dispose(ByVal disposing As Boolean)
        Try
            If disposing AndAlso components IsNot Nothing Then
                components.Dispose()
            End If
        Finally
            MyBase.Dispose(disposing)
        End Try
    End Sub

    'Required by the Windows Form Designer
    Private components As System.ComponentModel.IContainer

    'NOTE: The following procedure is required by the Windows Form Designer
    'It can be modified using the Windows Form Designer.  
    'Do not modify it using the code editor.
    <System.Diagnostics.DebuggerStepThrough()> _
    Private Sub InitializeComponent()
        Me.LocationGroupBox = New System.Windows.Forms.GroupBox
        Me.ForceProxyCheckBox = New System.Windows.Forms.CheckBox
        Me.CountryComboBox = New System.Windows.Forms.ComboBox
        Me.CountryLabel = New System.Windows.Forms.Label
        Me.CleaningTabControl = New System.Windows.Forms.TabControl
        Me.AddressCleaningTabPage = New System.Windows.Forms.TabPage
        Me.AddressCleaningTabControl = New System.Windows.Forms.TabControl
        Me.OriginalAddressTabPage = New System.Windows.Forms.TabPage
        Me.OriginalStreetLine2Label = New System.Windows.Forms.Label
        Me.OriginalCountryTextBox = New System.Windows.Forms.TextBox
        Me.OriginalCountryLabel = New System.Windows.Forms.Label
        Me.OriginalZip4TextBox = New System.Windows.Forms.TextBox
        Me.OriginalZip5TextBox = New System.Windows.Forms.TextBox
        Me.OriginalStateTextBox = New System.Windows.Forms.TextBox
        Me.OriginalCityTextBox = New System.Windows.Forms.TextBox
        Me.OriginalZip4Label = New System.Windows.Forms.Label
        Me.OriginalZip5Label = New System.Windows.Forms.Label
        Me.OriginalStateLabel = New System.Windows.Forms.Label
        Me.OriginalCityLabel = New System.Windows.Forms.Label
        Me.OriginalStreetLine2TextBox = New System.Windows.Forms.TextBox
        Me.OriginalStreetLine1TextBox = New System.Windows.Forms.TextBox
        Me.OriginalStreetLine1Label = New System.Windows.Forms.Label
        Me.WorkingAddressTabPage = New System.Windows.Forms.TabPage
        Me.WorkingStreetLine2Label = New System.Windows.Forms.Label
        Me.WorkingPrivateMailBoxTextBox = New System.Windows.Forms.TextBox
        Me.WorkingUrbanizationNameTextBox = New System.Windows.Forms.TextBox
        Me.WorkingPrivateMailBoxLabel = New System.Windows.Forms.Label
        Me.WorkingUrbanizationNameLabel = New System.Windows.Forms.Label
        Me.WorkingZipCodeTypeTextBox = New System.Windows.Forms.TextBox
        Me.WorkingAddressTypeTextBox = New System.Windows.Forms.TextBox
        Me.WorkingZipCodeTypeLabel = New System.Windows.Forms.Label
        Me.WorkingAddressTypeLabel = New System.Windows.Forms.Label
        Me.WorkingAddressErrorTextBox = New System.Windows.Forms.TextBox
        Me.WorkingAddressStatusTextBox = New System.Windows.Forms.TextBox
        Me.WorkingCarrierTextBox = New System.Windows.Forms.TextBox
        Me.WorkingDeliveryPointTextBox = New System.Windows.Forms.TextBox
        Me.WorkingCarrierLabel = New System.Windows.Forms.Label
        Me.WorkingDeliveryPointLabel = New System.Windows.Forms.Label
        Me.WorkingAddressErrorLabel = New System.Windows.Forms.Label
        Me.WorkingAddressStatusLabel = New System.Windows.Forms.Label
        Me.WorkingCountryTextBox = New System.Windows.Forms.TextBox
        Me.WorkingCountryLabel = New System.Windows.Forms.Label
        Me.WorkingZip4TextBox = New System.Windows.Forms.TextBox
        Me.WorkingZip5TextBox = New System.Windows.Forms.TextBox
        Me.WorkingStateTextBox = New System.Windows.Forms.TextBox
        Me.WorkingCityTextBox = New System.Windows.Forms.TextBox
        Me.WorkingZip4Label = New System.Windows.Forms.Label
        Me.WorkingZip5Label = New System.Windows.Forms.Label
        Me.WorkingStateLabel = New System.Windows.Forms.Label
        Me.WorkingCityLabel = New System.Windows.Forms.Label
        Me.WorkingStreetLine2TextBox = New System.Windows.Forms.TextBox
        Me.WorkingStreetLine1TextBox = New System.Windows.Forms.TextBox
        Me.WorkingStreetLine1Label = New System.Windows.Forms.Label
        Me.CleanedAddressTabPage = New System.Windows.Forms.TabPage
        Me.CleanedStreetLine2Label = New System.Windows.Forms.Label
        Me.CleanedPrivateMailBoxTextBox = New System.Windows.Forms.TextBox
        Me.CleanedUrbanizationNameTextBox = New System.Windows.Forms.TextBox
        Me.CleanedPrivateMailBoxLabel = New System.Windows.Forms.Label
        Me.CleanedUrbanizationNameLabel = New System.Windows.Forms.Label
        Me.CleanedZipCodeTypeTextBox = New System.Windows.Forms.TextBox
        Me.CleanedAddressTypeTextBox = New System.Windows.Forms.TextBox
        Me.CleanedZipCodeTypeLabel = New System.Windows.Forms.Label
        Me.CleanedAddressTypeLabel = New System.Windows.Forms.Label
        Me.CleanedAddressErrorTextBox = New System.Windows.Forms.TextBox
        Me.CleanedAddressStatusTextBox = New System.Windows.Forms.TextBox
        Me.CleanedCarrierTextBox = New System.Windows.Forms.TextBox
        Me.CleanedDeliveryPointTextBox = New System.Windows.Forms.TextBox
        Me.CleanedCarrierLabel = New System.Windows.Forms.Label
        Me.CleanedDeliveryPointLabel = New System.Windows.Forms.Label
        Me.CleanedAddressErrorLabel = New System.Windows.Forms.Label
        Me.CleanedAddressStatusLabel = New System.Windows.Forms.Label
        Me.CleanedCountryTextBox = New System.Windows.Forms.TextBox
        Me.CleanedCountryLabel = New System.Windows.Forms.Label
        Me.CleanedZip4TextBox = New System.Windows.Forms.TextBox
        Me.CleanedZip5TextBox = New System.Windows.Forms.TextBox
        Me.CleanedStateTextBox = New System.Windows.Forms.TextBox
        Me.CleanedCityTextBox = New System.Windows.Forms.TextBox
        Me.CleanedZip4Label = New System.Windows.Forms.Label
        Me.CleanedZip5Label = New System.Windows.Forms.Label
        Me.CleanedStateLabel = New System.Windows.Forms.Label
        Me.CleanedCityLabel = New System.Windows.Forms.Label
        Me.CleanedStreetLine2TextBox = New System.Windows.Forms.TextBox
        Me.CleanedStreetLine1TextBox = New System.Windows.Forms.TextBox
        Me.CleanedStreetLine1Label = New System.Windows.Forms.Label
        Me.GeoCodeTabPage = New System.Windows.Forms.TabPage
        Me.GeoCodeStatTextBox = New System.Windows.Forms.TextBox
        Me.GeoCodeStatLabel = New System.Windows.Forms.Label
        Me.CensusTractTextBox = New System.Windows.Forms.TextBox
        Me.CensusBlockTextBox = New System.Windows.Forms.TextBox
        Me.CensusTractLabel = New System.Windows.Forms.Label
        Me.CensusBlockLabel = New System.Windows.Forms.Label
        Me.CoreBasedStatisticalGroupBox = New System.Windows.Forms.GroupBox
        Me.CBSADivisionTitleTextBox = New System.Windows.Forms.TextBox
        Me.CBSADivisionTitleLabel = New System.Windows.Forms.Label
        Me.CBSADivisionLevelTextBox = New System.Windows.Forms.TextBox
        Me.CBSADivisionLevelLabel = New System.Windows.Forms.Label
        Me.CBSADivisionCodeTextBox = New System.Windows.Forms.TextBox
        Me.CBSADivisionCodeLabel = New System.Windows.Forms.Label
        Me.CBSATitleTextBox = New System.Windows.Forms.TextBox
        Me.CBSATitleLabel = New System.Windows.Forms.Label
        Me.CBSALevelTextBox = New System.Windows.Forms.TextBox
        Me.CBSALevelLabel = New System.Windows.Forms.Label
        Me.CBSACodeTextBox = New System.Windows.Forms.TextBox
        Me.CBSACodeLabel = New System.Windows.Forms.Label
        Me.TimeZoneCodeTextBox = New System.Windows.Forms.TextBox
        Me.TimeZoneNameTextBox = New System.Windows.Forms.TextBox
        Me.TimeZoneCodeLabel = New System.Windows.Forms.Label
        Me.TimeZoneNameLabel = New System.Windows.Forms.Label
        Me.PlaceCodeTextBox = New System.Windows.Forms.TextBox
        Me.PlaceNameTextBox = New System.Windows.Forms.TextBox
        Me.PlaceCodeLabel = New System.Windows.Forms.Label
        Me.PlaceNameLabel = New System.Windows.Forms.Label
        Me.LongitudeTextBox = New System.Windows.Forms.TextBox
        Me.LatitudeTextBox = New System.Windows.Forms.TextBox
        Me.LongitudeLabel = New System.Windows.Forms.Label
        Me.LatitudeLabel = New System.Windows.Forms.Label
        Me.CountyFIPSTextBox = New System.Windows.Forms.TextBox
        Me.CountyNameTextBox = New System.Windows.Forms.TextBox
        Me.CountyFIPSLabel = New System.Windows.Forms.Label
        Me.CountyNameLabel = New System.Windows.Forms.Label
        Me.PopulateGeoCodingCheckBox = New System.Windows.Forms.CheckBox
        Me.ClearAddressButton = New System.Windows.Forms.Button
        Me.CleanAddressButton = New System.Windows.Forms.Button
        Me.FileCleaningTabPage = New System.Windows.Forms.TabPage
        Me.DatabaseComboBox = New System.Windows.Forms.ComboBox
        Me.DatabaseLabel = New System.Windows.Forms.Label
        Me.ClearFileButton = New System.Windows.Forms.Button
        Me.CleanFileButton = New System.Windows.Forms.Button
        Me.BatchSizeTextBox = New System.Windows.Forms.TextBox
        Me.BatchSizeLabel = New System.Windows.Forms.Label
        Me.FileIDTextBox = New System.Windows.Forms.TextBox
        Me.FileIDLabel = New System.Windows.Forms.Label
        Me.StudyIDTextBox = New System.Windows.Forms.TextBox
        Me.StudyIDLabel = New System.Windows.Forms.Label
        Me.NameCleaningTabPage = New System.Windows.Forms.TabPage
        Me.NameCleaningTabControl = New System.Windows.Forms.TabControl
        Me.OriginalNameTabPage = New System.Windows.Forms.TabPage
        Me.OriginalSuffixTextBox = New System.Windows.Forms.TextBox
        Me.OriginalSuffixLabel = New System.Windows.Forms.Label
        Me.OriginalTitleTextBox = New System.Windows.Forms.TextBox
        Me.OriginalTitleLabel = New System.Windows.Forms.Label
        Me.OriginalLastNameTextBox = New System.Windows.Forms.TextBox
        Me.OriginalLastNameLabel = New System.Windows.Forms.Label
        Me.OriginalMiddleInitialTextBox = New System.Windows.Forms.TextBox
        Me.OriginalMiddleInitialLabel = New System.Windows.Forms.Label
        Me.OriginalFirstNameTextBox = New System.Windows.Forms.TextBox
        Me.OriginalFirstNameLabel = New System.Windows.Forms.Label
        Me.WorkingNameTabPage = New System.Windows.Forms.TabPage
        Me.WorkingSuffixTextBox = New System.Windows.Forms.TextBox
        Me.WorkingSuffixLabel = New System.Windows.Forms.Label
        Me.WorkingTitleTextBox = New System.Windows.Forms.TextBox
        Me.WorkingTitleLabel = New System.Windows.Forms.Label
        Me.WorkingNameStatusTextBox = New System.Windows.Forms.TextBox
        Me.WorkingNameStatusLabel = New System.Windows.Forms.Label
        Me.WorkingLastNameTextBox = New System.Windows.Forms.TextBox
        Me.WorkingLastNameLabel = New System.Windows.Forms.Label
        Me.WorkingMiddleInitialTextBox = New System.Windows.Forms.TextBox
        Me.WorkingMiddleInitialLabel = New System.Windows.Forms.Label
        Me.WorkingFirstNameTextBox = New System.Windows.Forms.TextBox
        Me.WorkingFirstNameLabel = New System.Windows.Forms.Label
        Me.CleanedNameTabPage = New System.Windows.Forms.TabPage
        Me.CleanedSuffixTextBox = New System.Windows.Forms.TextBox
        Me.CleanedSuffixLabel = New System.Windows.Forms.Label
        Me.CleanedTitleTextBox = New System.Windows.Forms.TextBox
        Me.CleanedTitleLabel = New System.Windows.Forms.Label
        Me.CleanedNameStatusTextBox = New System.Windows.Forms.TextBox
        Me.CleanedNameStatusLabel = New System.Windows.Forms.Label
        Me.CleanedLastNameTextBox = New System.Windows.Forms.TextBox
        Me.CleanedLastNameLabel = New System.Windows.Forms.Label
        Me.CleanedMiddleInitialTextBox = New System.Windows.Forms.TextBox
        Me.CleanedMiddleInitialLabel = New System.Windows.Forms.Label
        Me.CleanedFirstNameTextBox = New System.Windows.Forms.TextBox
        Me.CleanedFirstNameLabel = New System.Windows.Forms.Label
        Me.ClearNameButton = New System.Windows.Forms.Button
        Me.CleanNameButton = New System.Windows.Forms.Button
        Me.LocationGroupBox.SuspendLayout()
        Me.CleaningTabControl.SuspendLayout()
        Me.AddressCleaningTabPage.SuspendLayout()
        Me.AddressCleaningTabControl.SuspendLayout()
        Me.OriginalAddressTabPage.SuspendLayout()
        Me.WorkingAddressTabPage.SuspendLayout()
        Me.CleanedAddressTabPage.SuspendLayout()
        Me.GeoCodeTabPage.SuspendLayout()
        Me.CoreBasedStatisticalGroupBox.SuspendLayout()
        Me.FileCleaningTabPage.SuspendLayout()
        Me.NameCleaningTabPage.SuspendLayout()
        Me.NameCleaningTabControl.SuspendLayout()
        Me.OriginalNameTabPage.SuspendLayout()
        Me.WorkingNameTabPage.SuspendLayout()
        Me.CleanedNameTabPage.SuspendLayout()
        Me.SuspendLayout()
        '
        'LocationGroupBox
        '
        Me.LocationGroupBox.Controls.Add(Me.ForceProxyCheckBox)
        Me.LocationGroupBox.Controls.Add(Me.CountryComboBox)
        Me.LocationGroupBox.Controls.Add(Me.CountryLabel)
        Me.LocationGroupBox.Location = New System.Drawing.Point(12, 12)
        Me.LocationGroupBox.Name = "LocationGroupBox"
        Me.LocationGroupBox.Size = New System.Drawing.Size(458, 54)
        Me.LocationGroupBox.TabIndex = 0
        Me.LocationGroupBox.TabStop = False
        Me.LocationGroupBox.Text = "Location Selection"
        '
        'ForceProxyCheckBox
        '
        Me.ForceProxyCheckBox.AutoSize = True
        Me.ForceProxyCheckBox.Location = New System.Drawing.Point(362, 23)
        Me.ForceProxyCheckBox.Name = "ForceProxyCheckBox"
        Me.ForceProxyCheckBox.Size = New System.Drawing.Size(84, 17)
        Me.ForceProxyCheckBox.TabIndex = 2
        Me.ForceProxyCheckBox.Text = "Force Proxy"
        Me.ForceProxyCheckBox.UseVisualStyleBackColor = True
        '
        'CountryComboBox
        '
        Me.CountryComboBox.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.CountryComboBox.FormattingEnabled = True
        Me.CountryComboBox.Location = New System.Drawing.Point(61, 21)
        Me.CountryComboBox.Name = "CountryComboBox"
        Me.CountryComboBox.Size = New System.Drawing.Size(267, 21)
        Me.CountryComboBox.TabIndex = 1
        '
        'CountryLabel
        '
        Me.CountryLabel.AutoSize = True
        Me.CountryLabel.Location = New System.Drawing.Point(9, 24)
        Me.CountryLabel.Name = "CountryLabel"
        Me.CountryLabel.Size = New System.Drawing.Size(50, 13)
        Me.CountryLabel.TabIndex = 0
        Me.CountryLabel.Text = "Country:"
        '
        'CleaningTabControl
        '
        Me.CleaningTabControl.Controls.Add(Me.AddressCleaningTabPage)
        Me.CleaningTabControl.Controls.Add(Me.FileCleaningTabPage)
        Me.CleaningTabControl.Controls.Add(Me.NameCleaningTabPage)
        Me.CleaningTabControl.Location = New System.Drawing.Point(12, 81)
        Me.CleaningTabControl.Name = "CleaningTabControl"
        Me.CleaningTabControl.SelectedIndex = 0
        Me.CleaningTabControl.Size = New System.Drawing.Size(459, 396)
        Me.CleaningTabControl.TabIndex = 1
        '
        'AddressCleaningTabPage
        '
        Me.AddressCleaningTabPage.Controls.Add(Me.AddressCleaningTabControl)
        Me.AddressCleaningTabPage.Controls.Add(Me.PopulateGeoCodingCheckBox)
        Me.AddressCleaningTabPage.Controls.Add(Me.ClearAddressButton)
        Me.AddressCleaningTabPage.Controls.Add(Me.CleanAddressButton)
        Me.AddressCleaningTabPage.Location = New System.Drawing.Point(4, 22)
        Me.AddressCleaningTabPage.Name = "AddressCleaningTabPage"
        Me.AddressCleaningTabPage.Padding = New System.Windows.Forms.Padding(3)
        Me.AddressCleaningTabPage.Size = New System.Drawing.Size(451, 370)
        Me.AddressCleaningTabPage.TabIndex = 0
        Me.AddressCleaningTabPage.Text = "Address Cleaning"
        '
        'AddressCleaningTabControl
        '
        Me.AddressCleaningTabControl.Controls.Add(Me.OriginalAddressTabPage)
        Me.AddressCleaningTabControl.Controls.Add(Me.WorkingAddressTabPage)
        Me.AddressCleaningTabControl.Controls.Add(Me.CleanedAddressTabPage)
        Me.AddressCleaningTabControl.Controls.Add(Me.GeoCodeTabPage)
        Me.AddressCleaningTabControl.ItemSize = New System.Drawing.Size(90, 18)
        Me.AddressCleaningTabControl.Location = New System.Drawing.Point(10, 10)
        Me.AddressCleaningTabControl.Name = "AddressCleaningTabControl"
        Me.AddressCleaningTabControl.SelectedIndex = 0
        Me.AddressCleaningTabControl.Size = New System.Drawing.Size(432, 314)
        Me.AddressCleaningTabControl.TabIndex = 0
        '
        'OriginalAddressTabPage
        '
        Me.OriginalAddressTabPage.Controls.Add(Me.OriginalStreetLine2Label)
        Me.OriginalAddressTabPage.Controls.Add(Me.OriginalCountryTextBox)
        Me.OriginalAddressTabPage.Controls.Add(Me.OriginalCountryLabel)
        Me.OriginalAddressTabPage.Controls.Add(Me.OriginalZip4TextBox)
        Me.OriginalAddressTabPage.Controls.Add(Me.OriginalZip5TextBox)
        Me.OriginalAddressTabPage.Controls.Add(Me.OriginalStateTextBox)
        Me.OriginalAddressTabPage.Controls.Add(Me.OriginalCityTextBox)
        Me.OriginalAddressTabPage.Controls.Add(Me.OriginalZip4Label)
        Me.OriginalAddressTabPage.Controls.Add(Me.OriginalZip5Label)
        Me.OriginalAddressTabPage.Controls.Add(Me.OriginalStateLabel)
        Me.OriginalAddressTabPage.Controls.Add(Me.OriginalCityLabel)
        Me.OriginalAddressTabPage.Controls.Add(Me.OriginalStreetLine2TextBox)
        Me.OriginalAddressTabPage.Controls.Add(Me.OriginalStreetLine1TextBox)
        Me.OriginalAddressTabPage.Controls.Add(Me.OriginalStreetLine1Label)
        Me.OriginalAddressTabPage.Location = New System.Drawing.Point(4, 22)
        Me.OriginalAddressTabPage.Name = "OriginalAddressTabPage"
        Me.OriginalAddressTabPage.Padding = New System.Windows.Forms.Padding(3)
        Me.OriginalAddressTabPage.Size = New System.Drawing.Size(424, 288)
        Me.OriginalAddressTabPage.TabIndex = 0
        Me.OriginalAddressTabPage.Text = "Original Address"
        '
        'OriginalStreetLine2Label
        '
        Me.OriginalStreetLine2Label.AutoSize = True
        Me.OriginalStreetLine2Label.Location = New System.Drawing.Point(10, 44)
        Me.OriginalStreetLine2Label.Name = "OriginalStreetLine2Label"
        Me.OriginalStreetLine2Label.Size = New System.Drawing.Size(72, 13)
        Me.OriginalStreetLine2Label.TabIndex = 2
        Me.OriginalStreetLine2Label.Text = "Street Line 2:"
        '
        'OriginalCountryTextBox
        '
        Me.OriginalCountryTextBox.Location = New System.Drawing.Point(300, 95)
        Me.OriginalCountryTextBox.Name = "OriginalCountryTextBox"
        Me.OriginalCountryTextBox.Size = New System.Drawing.Size(111, 21)
        Me.OriginalCountryTextBox.TabIndex = 13
        '
        'OriginalCountryLabel
        '
        Me.OriginalCountryLabel.AutoSize = True
        Me.OriginalCountryLabel.Location = New System.Drawing.Point(244, 98)
        Me.OriginalCountryLabel.Name = "OriginalCountryLabel"
        Me.OriginalCountryLabel.Size = New System.Drawing.Size(50, 13)
        Me.OriginalCountryLabel.TabIndex = 12
        Me.OriginalCountryLabel.Text = "Country:"
        '
        'OriginalZip4TextBox
        '
        Me.OriginalZip4TextBox.Location = New System.Drawing.Point(187, 95)
        Me.OriginalZip4TextBox.Name = "OriginalZip4TextBox"
        Me.OriginalZip4TextBox.Size = New System.Drawing.Size(39, 21)
        Me.OriginalZip4TextBox.TabIndex = 11
        '
        'OriginalZip5TextBox
        '
        Me.OriginalZip5TextBox.Location = New System.Drawing.Point(86, 95)
        Me.OriginalZip5TextBox.Name = "OriginalZip5TextBox"
        Me.OriginalZip5TextBox.Size = New System.Drawing.Size(47, 21)
        Me.OriginalZip5TextBox.TabIndex = 9
        '
        'OriginalStateTextBox
        '
        Me.OriginalStateTextBox.Location = New System.Drawing.Point(371, 68)
        Me.OriginalStateTextBox.Name = "OriginalStateTextBox"
        Me.OriginalStateTextBox.Size = New System.Drawing.Size(40, 21)
        Me.OriginalStateTextBox.TabIndex = 7
        '
        'OriginalCityTextBox
        '
        Me.OriginalCityTextBox.Location = New System.Drawing.Point(86, 68)
        Me.OriginalCityTextBox.Name = "OriginalCityTextBox"
        Me.OriginalCityTextBox.Size = New System.Drawing.Size(224, 21)
        Me.OriginalCityTextBox.TabIndex = 5
        '
        'OriginalZip4Label
        '
        Me.OriginalZip4Label.AutoSize = True
        Me.OriginalZip4Label.Location = New System.Drawing.Point(150, 98)
        Me.OriginalZip4Label.Name = "OriginalZip4Label"
        Me.OriginalZip4Label.Size = New System.Drawing.Size(31, 13)
        Me.OriginalZip4Label.TabIndex = 10
        Me.OriginalZip4Label.Text = "Zip4:"
        '
        'OriginalZip5Label
        '
        Me.OriginalZip5Label.AutoSize = True
        Me.OriginalZip5Label.Location = New System.Drawing.Point(10, 98)
        Me.OriginalZip5Label.Name = "OriginalZip5Label"
        Me.OriginalZip5Label.Size = New System.Drawing.Size(31, 13)
        Me.OriginalZip5Label.TabIndex = 8
        Me.OriginalZip5Label.Text = "Zip5:"
        '
        'OriginalStateLabel
        '
        Me.OriginalStateLabel.AutoSize = True
        Me.OriginalStateLabel.Location = New System.Drawing.Point(329, 71)
        Me.OriginalStateLabel.Name = "OriginalStateLabel"
        Me.OriginalStateLabel.Size = New System.Drawing.Size(37, 13)
        Me.OriginalStateLabel.TabIndex = 6
        Me.OriginalStateLabel.Text = "State:"
        '
        'OriginalCityLabel
        '
        Me.OriginalCityLabel.AutoSize = True
        Me.OriginalCityLabel.Location = New System.Drawing.Point(10, 71)
        Me.OriginalCityLabel.Name = "OriginalCityLabel"
        Me.OriginalCityLabel.Size = New System.Drawing.Size(30, 13)
        Me.OriginalCityLabel.TabIndex = 4
        Me.OriginalCityLabel.Text = "City:"
        '
        'OriginalStreetLine2TextBox
        '
        Me.OriginalStreetLine2TextBox.Location = New System.Drawing.Point(86, 41)
        Me.OriginalStreetLine2TextBox.Name = "OriginalStreetLine2TextBox"
        Me.OriginalStreetLine2TextBox.Size = New System.Drawing.Size(325, 21)
        Me.OriginalStreetLine2TextBox.TabIndex = 3
        '
        'OriginalStreetLine1TextBox
        '
        Me.OriginalStreetLine1TextBox.Location = New System.Drawing.Point(86, 14)
        Me.OriginalStreetLine1TextBox.Name = "OriginalStreetLine1TextBox"
        Me.OriginalStreetLine1TextBox.Size = New System.Drawing.Size(325, 21)
        Me.OriginalStreetLine1TextBox.TabIndex = 1
        '
        'OriginalStreetLine1Label
        '
        Me.OriginalStreetLine1Label.AutoSize = True
        Me.OriginalStreetLine1Label.Location = New System.Drawing.Point(10, 17)
        Me.OriginalStreetLine1Label.Name = "OriginalStreetLine1Label"
        Me.OriginalStreetLine1Label.Size = New System.Drawing.Size(72, 13)
        Me.OriginalStreetLine1Label.TabIndex = 0
        Me.OriginalStreetLine1Label.Text = "Street Line 1:"
        '
        'WorkingAddressTabPage
        '
        Me.WorkingAddressTabPage.Controls.Add(Me.WorkingStreetLine2Label)
        Me.WorkingAddressTabPage.Controls.Add(Me.WorkingPrivateMailBoxTextBox)
        Me.WorkingAddressTabPage.Controls.Add(Me.WorkingUrbanizationNameTextBox)
        Me.WorkingAddressTabPage.Controls.Add(Me.WorkingPrivateMailBoxLabel)
        Me.WorkingAddressTabPage.Controls.Add(Me.WorkingUrbanizationNameLabel)
        Me.WorkingAddressTabPage.Controls.Add(Me.WorkingZipCodeTypeTextBox)
        Me.WorkingAddressTabPage.Controls.Add(Me.WorkingAddressTypeTextBox)
        Me.WorkingAddressTabPage.Controls.Add(Me.WorkingZipCodeTypeLabel)
        Me.WorkingAddressTabPage.Controls.Add(Me.WorkingAddressTypeLabel)
        Me.WorkingAddressTabPage.Controls.Add(Me.WorkingAddressErrorTextBox)
        Me.WorkingAddressTabPage.Controls.Add(Me.WorkingAddressStatusTextBox)
        Me.WorkingAddressTabPage.Controls.Add(Me.WorkingCarrierTextBox)
        Me.WorkingAddressTabPage.Controls.Add(Me.WorkingDeliveryPointTextBox)
        Me.WorkingAddressTabPage.Controls.Add(Me.WorkingCarrierLabel)
        Me.WorkingAddressTabPage.Controls.Add(Me.WorkingDeliveryPointLabel)
        Me.WorkingAddressTabPage.Controls.Add(Me.WorkingAddressErrorLabel)
        Me.WorkingAddressTabPage.Controls.Add(Me.WorkingAddressStatusLabel)
        Me.WorkingAddressTabPage.Controls.Add(Me.WorkingCountryTextBox)
        Me.WorkingAddressTabPage.Controls.Add(Me.WorkingCountryLabel)
        Me.WorkingAddressTabPage.Controls.Add(Me.WorkingZip4TextBox)
        Me.WorkingAddressTabPage.Controls.Add(Me.WorkingZip5TextBox)
        Me.WorkingAddressTabPage.Controls.Add(Me.WorkingStateTextBox)
        Me.WorkingAddressTabPage.Controls.Add(Me.WorkingCityTextBox)
        Me.WorkingAddressTabPage.Controls.Add(Me.WorkingZip4Label)
        Me.WorkingAddressTabPage.Controls.Add(Me.WorkingZip5Label)
        Me.WorkingAddressTabPage.Controls.Add(Me.WorkingStateLabel)
        Me.WorkingAddressTabPage.Controls.Add(Me.WorkingCityLabel)
        Me.WorkingAddressTabPage.Controls.Add(Me.WorkingStreetLine2TextBox)
        Me.WorkingAddressTabPage.Controls.Add(Me.WorkingStreetLine1TextBox)
        Me.WorkingAddressTabPage.Controls.Add(Me.WorkingStreetLine1Label)
        Me.WorkingAddressTabPage.Location = New System.Drawing.Point(4, 22)
        Me.WorkingAddressTabPage.Name = "WorkingAddressTabPage"
        Me.WorkingAddressTabPage.Padding = New System.Windows.Forms.Padding(3)
        Me.WorkingAddressTabPage.Size = New System.Drawing.Size(424, 288)
        Me.WorkingAddressTabPage.TabIndex = 1
        Me.WorkingAddressTabPage.Text = "Working Address"
        '
        'WorkingStreetLine2Label
        '
        Me.WorkingStreetLine2Label.AutoSize = True
        Me.WorkingStreetLine2Label.Location = New System.Drawing.Point(10, 44)
        Me.WorkingStreetLine2Label.Name = "WorkingStreetLine2Label"
        Me.WorkingStreetLine2Label.Size = New System.Drawing.Size(72, 13)
        Me.WorkingStreetLine2Label.TabIndex = 2
        Me.WorkingStreetLine2Label.Text = "Street Line 2:"
        '
        'WorkingPrivateMailBoxTextBox
        '
        Me.WorkingPrivateMailBoxTextBox.Location = New System.Drawing.Point(296, 176)
        Me.WorkingPrivateMailBoxTextBox.Name = "WorkingPrivateMailBoxTextBox"
        Me.WorkingPrivateMailBoxTextBox.ReadOnly = True
        Me.WorkingPrivateMailBoxTextBox.Size = New System.Drawing.Size(115, 21)
        Me.WorkingPrivateMailBoxTextBox.TabIndex = 25
        '
        'WorkingUrbanizationNameTextBox
        '
        Me.WorkingUrbanizationNameTextBox.Location = New System.Drawing.Point(86, 176)
        Me.WorkingUrbanizationNameTextBox.Name = "WorkingUrbanizationNameTextBox"
        Me.WorkingUrbanizationNameTextBox.ReadOnly = True
        Me.WorkingUrbanizationNameTextBox.Size = New System.Drawing.Size(115, 21)
        Me.WorkingUrbanizationNameTextBox.TabIndex = 23
        '
        'WorkingPrivateMailBoxLabel
        '
        Me.WorkingPrivateMailBoxLabel.AutoSize = True
        Me.WorkingPrivateMailBoxLabel.Location = New System.Drawing.Point(224, 179)
        Me.WorkingPrivateMailBoxLabel.Name = "WorkingPrivateMailBoxLabel"
        Me.WorkingPrivateMailBoxLabel.Size = New System.Drawing.Size(66, 13)
        Me.WorkingPrivateMailBoxLabel.TabIndex = 24
        Me.WorkingPrivateMailBoxLabel.Text = "Private Box:"
        '
        'WorkingUrbanizationNameLabel
        '
        Me.WorkingUrbanizationNameLabel.AutoSize = True
        Me.WorkingUrbanizationNameLabel.Location = New System.Drawing.Point(10, 179)
        Me.WorkingUrbanizationNameLabel.Name = "WorkingUrbanizationNameLabel"
        Me.WorkingUrbanizationNameLabel.Size = New System.Drawing.Size(71, 13)
        Me.WorkingUrbanizationNameLabel.TabIndex = 22
        Me.WorkingUrbanizationNameLabel.Text = "Urbanization:"
        '
        'WorkingZipCodeTypeTextBox
        '
        Me.WorkingZipCodeTypeTextBox.Location = New System.Drawing.Point(296, 149)
        Me.WorkingZipCodeTypeTextBox.Name = "WorkingZipCodeTypeTextBox"
        Me.WorkingZipCodeTypeTextBox.ReadOnly = True
        Me.WorkingZipCodeTypeTextBox.Size = New System.Drawing.Size(115, 21)
        Me.WorkingZipCodeTypeTextBox.TabIndex = 21
        '
        'WorkingAddressTypeTextBox
        '
        Me.WorkingAddressTypeTextBox.Location = New System.Drawing.Point(86, 149)
        Me.WorkingAddressTypeTextBox.Name = "WorkingAddressTypeTextBox"
        Me.WorkingAddressTypeTextBox.ReadOnly = True
        Me.WorkingAddressTypeTextBox.Size = New System.Drawing.Size(115, 21)
        Me.WorkingAddressTypeTextBox.TabIndex = 19
        '
        'WorkingZipCodeTypeLabel
        '
        Me.WorkingZipCodeTypeLabel.AutoSize = True
        Me.WorkingZipCodeTypeLabel.Location = New System.Drawing.Point(224, 152)
        Me.WorkingZipCodeTypeLabel.Name = "WorkingZipCodeTypeLabel"
        Me.WorkingZipCodeTypeLabel.Size = New System.Drawing.Size(52, 13)
        Me.WorkingZipCodeTypeLabel.TabIndex = 20
        Me.WorkingZipCodeTypeLabel.Text = "Zip Type:"
        '
        'WorkingAddressTypeLabel
        '
        Me.WorkingAddressTypeLabel.AutoSize = True
        Me.WorkingAddressTypeLabel.Location = New System.Drawing.Point(10, 152)
        Me.WorkingAddressTypeLabel.Name = "WorkingAddressTypeLabel"
        Me.WorkingAddressTypeLabel.Size = New System.Drawing.Size(77, 13)
        Me.WorkingAddressTypeLabel.TabIndex = 18
        Me.WorkingAddressTypeLabel.Text = "Address Type:"
        '
        'WorkingAddressErrorTextBox
        '
        Me.WorkingAddressErrorTextBox.Location = New System.Drawing.Point(351, 203)
        Me.WorkingAddressErrorTextBox.Name = "WorkingAddressErrorTextBox"
        Me.WorkingAddressErrorTextBox.ReadOnly = True
        Me.WorkingAddressErrorTextBox.Size = New System.Drawing.Size(60, 21)
        Me.WorkingAddressErrorTextBox.TabIndex = 29
        '
        'WorkingAddressStatusTextBox
        '
        Me.WorkingAddressStatusTextBox.Location = New System.Drawing.Point(86, 203)
        Me.WorkingAddressStatusTextBox.Name = "WorkingAddressStatusTextBox"
        Me.WorkingAddressStatusTextBox.ReadOnly = True
        Me.WorkingAddressStatusTextBox.Size = New System.Drawing.Size(195, 21)
        Me.WorkingAddressStatusTextBox.TabIndex = 27
        '
        'WorkingCarrierTextBox
        '
        Me.WorkingCarrierTextBox.Location = New System.Drawing.Point(296, 122)
        Me.WorkingCarrierTextBox.Name = "WorkingCarrierTextBox"
        Me.WorkingCarrierTextBox.ReadOnly = True
        Me.WorkingCarrierTextBox.Size = New System.Drawing.Size(115, 21)
        Me.WorkingCarrierTextBox.TabIndex = 17
        '
        'WorkingDeliveryPointTextBox
        '
        Me.WorkingDeliveryPointTextBox.Location = New System.Drawing.Point(86, 122)
        Me.WorkingDeliveryPointTextBox.Name = "WorkingDeliveryPointTextBox"
        Me.WorkingDeliveryPointTextBox.ReadOnly = True
        Me.WorkingDeliveryPointTextBox.Size = New System.Drawing.Size(115, 21)
        Me.WorkingDeliveryPointTextBox.TabIndex = 15
        '
        'WorkingCarrierLabel
        '
        Me.WorkingCarrierLabel.AutoSize = True
        Me.WorkingCarrierLabel.Location = New System.Drawing.Point(224, 125)
        Me.WorkingCarrierLabel.Name = "WorkingCarrierLabel"
        Me.WorkingCarrierLabel.Size = New System.Drawing.Size(44, 13)
        Me.WorkingCarrierLabel.TabIndex = 16
        Me.WorkingCarrierLabel.Text = "Carrier:"
        '
        'WorkingDeliveryPointLabel
        '
        Me.WorkingDeliveryPointLabel.AutoSize = True
        Me.WorkingDeliveryPointLabel.Location = New System.Drawing.Point(10, 125)
        Me.WorkingDeliveryPointLabel.Name = "WorkingDeliveryPointLabel"
        Me.WorkingDeliveryPointLabel.Size = New System.Drawing.Size(36, 13)
        Me.WorkingDeliveryPointLabel.TabIndex = 14
        Me.WorkingDeliveryPointLabel.Text = "DelPt:"
        '
        'WorkingAddressErrorLabel
        '
        Me.WorkingAddressErrorLabel.AutoSize = True
        Me.WorkingAddressErrorLabel.Location = New System.Drawing.Point(297, 206)
        Me.WorkingAddressErrorLabel.Name = "WorkingAddressErrorLabel"
        Me.WorkingAddressErrorLabel.Size = New System.Drawing.Size(48, 13)
        Me.WorkingAddressErrorLabel.TabIndex = 28
        Me.WorkingAddressErrorLabel.Text = "AddrErr:"
        '
        'WorkingAddressStatusLabel
        '
        Me.WorkingAddressStatusLabel.AutoSize = True
        Me.WorkingAddressStatusLabel.Location = New System.Drawing.Point(9, 207)
        Me.WorkingAddressStatusLabel.Name = "WorkingAddressStatusLabel"
        Me.WorkingAddressStatusLabel.Size = New System.Drawing.Size(54, 13)
        Me.WorkingAddressStatusLabel.TabIndex = 26
        Me.WorkingAddressStatusLabel.Text = "AddrStat:"
        '
        'WorkingCountryTextBox
        '
        Me.WorkingCountryTextBox.Location = New System.Drawing.Point(300, 95)
        Me.WorkingCountryTextBox.Name = "WorkingCountryTextBox"
        Me.WorkingCountryTextBox.ReadOnly = True
        Me.WorkingCountryTextBox.Size = New System.Drawing.Size(111, 21)
        Me.WorkingCountryTextBox.TabIndex = 13
        '
        'WorkingCountryLabel
        '
        Me.WorkingCountryLabel.AutoSize = True
        Me.WorkingCountryLabel.Location = New System.Drawing.Point(244, 98)
        Me.WorkingCountryLabel.Name = "WorkingCountryLabel"
        Me.WorkingCountryLabel.Size = New System.Drawing.Size(50, 13)
        Me.WorkingCountryLabel.TabIndex = 12
        Me.WorkingCountryLabel.Text = "Country:"
        '
        'WorkingZip4TextBox
        '
        Me.WorkingZip4TextBox.Location = New System.Drawing.Point(187, 95)
        Me.WorkingZip4TextBox.Name = "WorkingZip4TextBox"
        Me.WorkingZip4TextBox.ReadOnly = True
        Me.WorkingZip4TextBox.Size = New System.Drawing.Size(39, 21)
        Me.WorkingZip4TextBox.TabIndex = 11
        '
        'WorkingZip5TextBox
        '
        Me.WorkingZip5TextBox.Location = New System.Drawing.Point(86, 95)
        Me.WorkingZip5TextBox.Name = "WorkingZip5TextBox"
        Me.WorkingZip5TextBox.ReadOnly = True
        Me.WorkingZip5TextBox.Size = New System.Drawing.Size(47, 21)
        Me.WorkingZip5TextBox.TabIndex = 9
        '
        'WorkingStateTextBox
        '
        Me.WorkingStateTextBox.Location = New System.Drawing.Point(371, 68)
        Me.WorkingStateTextBox.Name = "WorkingStateTextBox"
        Me.WorkingStateTextBox.ReadOnly = True
        Me.WorkingStateTextBox.Size = New System.Drawing.Size(40, 21)
        Me.WorkingStateTextBox.TabIndex = 7
        '
        'WorkingCityTextBox
        '
        Me.WorkingCityTextBox.Location = New System.Drawing.Point(86, 68)
        Me.WorkingCityTextBox.Name = "WorkingCityTextBox"
        Me.WorkingCityTextBox.ReadOnly = True
        Me.WorkingCityTextBox.Size = New System.Drawing.Size(224, 21)
        Me.WorkingCityTextBox.TabIndex = 5
        '
        'WorkingZip4Label
        '
        Me.WorkingZip4Label.AutoSize = True
        Me.WorkingZip4Label.Location = New System.Drawing.Point(150, 98)
        Me.WorkingZip4Label.Name = "WorkingZip4Label"
        Me.WorkingZip4Label.Size = New System.Drawing.Size(31, 13)
        Me.WorkingZip4Label.TabIndex = 10
        Me.WorkingZip4Label.Text = "Zip4:"
        '
        'WorkingZip5Label
        '
        Me.WorkingZip5Label.AutoSize = True
        Me.WorkingZip5Label.Location = New System.Drawing.Point(10, 98)
        Me.WorkingZip5Label.Name = "WorkingZip5Label"
        Me.WorkingZip5Label.Size = New System.Drawing.Size(31, 13)
        Me.WorkingZip5Label.TabIndex = 8
        Me.WorkingZip5Label.Text = "Zip5:"
        '
        'WorkingStateLabel
        '
        Me.WorkingStateLabel.AutoSize = True
        Me.WorkingStateLabel.Location = New System.Drawing.Point(329, 71)
        Me.WorkingStateLabel.Name = "WorkingStateLabel"
        Me.WorkingStateLabel.Size = New System.Drawing.Size(37, 13)
        Me.WorkingStateLabel.TabIndex = 6
        Me.WorkingStateLabel.Text = "State:"
        '
        'WorkingCityLabel
        '
        Me.WorkingCityLabel.AutoSize = True
        Me.WorkingCityLabel.Location = New System.Drawing.Point(10, 71)
        Me.WorkingCityLabel.Name = "WorkingCityLabel"
        Me.WorkingCityLabel.Size = New System.Drawing.Size(30, 13)
        Me.WorkingCityLabel.TabIndex = 4
        Me.WorkingCityLabel.Text = "City:"
        '
        'WorkingStreetLine2TextBox
        '
        Me.WorkingStreetLine2TextBox.Location = New System.Drawing.Point(86, 41)
        Me.WorkingStreetLine2TextBox.Name = "WorkingStreetLine2TextBox"
        Me.WorkingStreetLine2TextBox.ReadOnly = True
        Me.WorkingStreetLine2TextBox.Size = New System.Drawing.Size(325, 21)
        Me.WorkingStreetLine2TextBox.TabIndex = 3
        '
        'WorkingStreetLine1TextBox
        '
        Me.WorkingStreetLine1TextBox.Location = New System.Drawing.Point(86, 14)
        Me.WorkingStreetLine1TextBox.Name = "WorkingStreetLine1TextBox"
        Me.WorkingStreetLine1TextBox.ReadOnly = True
        Me.WorkingStreetLine1TextBox.Size = New System.Drawing.Size(325, 21)
        Me.WorkingStreetLine1TextBox.TabIndex = 1
        '
        'WorkingStreetLine1Label
        '
        Me.WorkingStreetLine1Label.AutoSize = True
        Me.WorkingStreetLine1Label.Location = New System.Drawing.Point(10, 17)
        Me.WorkingStreetLine1Label.Name = "WorkingStreetLine1Label"
        Me.WorkingStreetLine1Label.Size = New System.Drawing.Size(72, 13)
        Me.WorkingStreetLine1Label.TabIndex = 0
        Me.WorkingStreetLine1Label.Text = "Street Line 1:"
        '
        'CleanedAddressTabPage
        '
        Me.CleanedAddressTabPage.Controls.Add(Me.CleanedStreetLine2Label)
        Me.CleanedAddressTabPage.Controls.Add(Me.CleanedPrivateMailBoxTextBox)
        Me.CleanedAddressTabPage.Controls.Add(Me.CleanedUrbanizationNameTextBox)
        Me.CleanedAddressTabPage.Controls.Add(Me.CleanedPrivateMailBoxLabel)
        Me.CleanedAddressTabPage.Controls.Add(Me.CleanedUrbanizationNameLabel)
        Me.CleanedAddressTabPage.Controls.Add(Me.CleanedZipCodeTypeTextBox)
        Me.CleanedAddressTabPage.Controls.Add(Me.CleanedAddressTypeTextBox)
        Me.CleanedAddressTabPage.Controls.Add(Me.CleanedZipCodeTypeLabel)
        Me.CleanedAddressTabPage.Controls.Add(Me.CleanedAddressTypeLabel)
        Me.CleanedAddressTabPage.Controls.Add(Me.CleanedAddressErrorTextBox)
        Me.CleanedAddressTabPage.Controls.Add(Me.CleanedAddressStatusTextBox)
        Me.CleanedAddressTabPage.Controls.Add(Me.CleanedCarrierTextBox)
        Me.CleanedAddressTabPage.Controls.Add(Me.CleanedDeliveryPointTextBox)
        Me.CleanedAddressTabPage.Controls.Add(Me.CleanedCarrierLabel)
        Me.CleanedAddressTabPage.Controls.Add(Me.CleanedDeliveryPointLabel)
        Me.CleanedAddressTabPage.Controls.Add(Me.CleanedAddressErrorLabel)
        Me.CleanedAddressTabPage.Controls.Add(Me.CleanedAddressStatusLabel)
        Me.CleanedAddressTabPage.Controls.Add(Me.CleanedCountryTextBox)
        Me.CleanedAddressTabPage.Controls.Add(Me.CleanedCountryLabel)
        Me.CleanedAddressTabPage.Controls.Add(Me.CleanedZip4TextBox)
        Me.CleanedAddressTabPage.Controls.Add(Me.CleanedZip5TextBox)
        Me.CleanedAddressTabPage.Controls.Add(Me.CleanedStateTextBox)
        Me.CleanedAddressTabPage.Controls.Add(Me.CleanedCityTextBox)
        Me.CleanedAddressTabPage.Controls.Add(Me.CleanedZip4Label)
        Me.CleanedAddressTabPage.Controls.Add(Me.CleanedZip5Label)
        Me.CleanedAddressTabPage.Controls.Add(Me.CleanedStateLabel)
        Me.CleanedAddressTabPage.Controls.Add(Me.CleanedCityLabel)
        Me.CleanedAddressTabPage.Controls.Add(Me.CleanedStreetLine2TextBox)
        Me.CleanedAddressTabPage.Controls.Add(Me.CleanedStreetLine1TextBox)
        Me.CleanedAddressTabPage.Controls.Add(Me.CleanedStreetLine1Label)
        Me.CleanedAddressTabPage.Location = New System.Drawing.Point(4, 22)
        Me.CleanedAddressTabPage.Name = "CleanedAddressTabPage"
        Me.CleanedAddressTabPage.Size = New System.Drawing.Size(424, 288)
        Me.CleanedAddressTabPage.TabIndex = 2
        Me.CleanedAddressTabPage.Text = "Cleaned Address"
        '
        'CleanedStreetLine2Label
        '
        Me.CleanedStreetLine2Label.AutoSize = True
        Me.CleanedStreetLine2Label.Location = New System.Drawing.Point(10, 44)
        Me.CleanedStreetLine2Label.Name = "CleanedStreetLine2Label"
        Me.CleanedStreetLine2Label.Size = New System.Drawing.Size(72, 13)
        Me.CleanedStreetLine2Label.TabIndex = 2
        Me.CleanedStreetLine2Label.Text = "Street Line 2:"
        '
        'CleanedPrivateMailBoxTextBox
        '
        Me.CleanedPrivateMailBoxTextBox.Location = New System.Drawing.Point(296, 176)
        Me.CleanedPrivateMailBoxTextBox.Name = "CleanedPrivateMailBoxTextBox"
        Me.CleanedPrivateMailBoxTextBox.ReadOnly = True
        Me.CleanedPrivateMailBoxTextBox.Size = New System.Drawing.Size(115, 21)
        Me.CleanedPrivateMailBoxTextBox.TabIndex = 25
        '
        'CleanedUrbanizationNameTextBox
        '
        Me.CleanedUrbanizationNameTextBox.Location = New System.Drawing.Point(86, 176)
        Me.CleanedUrbanizationNameTextBox.Name = "CleanedUrbanizationNameTextBox"
        Me.CleanedUrbanizationNameTextBox.ReadOnly = True
        Me.CleanedUrbanizationNameTextBox.Size = New System.Drawing.Size(115, 21)
        Me.CleanedUrbanizationNameTextBox.TabIndex = 23
        '
        'CleanedPrivateMailBoxLabel
        '
        Me.CleanedPrivateMailBoxLabel.AutoSize = True
        Me.CleanedPrivateMailBoxLabel.Location = New System.Drawing.Point(224, 179)
        Me.CleanedPrivateMailBoxLabel.Name = "CleanedPrivateMailBoxLabel"
        Me.CleanedPrivateMailBoxLabel.Size = New System.Drawing.Size(66, 13)
        Me.CleanedPrivateMailBoxLabel.TabIndex = 24
        Me.CleanedPrivateMailBoxLabel.Text = "Private Box:"
        '
        'CleanedUrbanizationNameLabel
        '
        Me.CleanedUrbanizationNameLabel.AutoSize = True
        Me.CleanedUrbanizationNameLabel.Location = New System.Drawing.Point(10, 179)
        Me.CleanedUrbanizationNameLabel.Name = "CleanedUrbanizationNameLabel"
        Me.CleanedUrbanizationNameLabel.Size = New System.Drawing.Size(71, 13)
        Me.CleanedUrbanizationNameLabel.TabIndex = 22
        Me.CleanedUrbanizationNameLabel.Text = "Urbanization:"
        '
        'CleanedZipCodeTypeTextBox
        '
        Me.CleanedZipCodeTypeTextBox.Location = New System.Drawing.Point(296, 149)
        Me.CleanedZipCodeTypeTextBox.Name = "CleanedZipCodeTypeTextBox"
        Me.CleanedZipCodeTypeTextBox.ReadOnly = True
        Me.CleanedZipCodeTypeTextBox.Size = New System.Drawing.Size(115, 21)
        Me.CleanedZipCodeTypeTextBox.TabIndex = 21
        '
        'CleanedAddressTypeTextBox
        '
        Me.CleanedAddressTypeTextBox.Location = New System.Drawing.Point(86, 149)
        Me.CleanedAddressTypeTextBox.Name = "CleanedAddressTypeTextBox"
        Me.CleanedAddressTypeTextBox.ReadOnly = True
        Me.CleanedAddressTypeTextBox.Size = New System.Drawing.Size(115, 21)
        Me.CleanedAddressTypeTextBox.TabIndex = 19
        '
        'CleanedZipCodeTypeLabel
        '
        Me.CleanedZipCodeTypeLabel.AutoSize = True
        Me.CleanedZipCodeTypeLabel.Location = New System.Drawing.Point(224, 152)
        Me.CleanedZipCodeTypeLabel.Name = "CleanedZipCodeTypeLabel"
        Me.CleanedZipCodeTypeLabel.Size = New System.Drawing.Size(52, 13)
        Me.CleanedZipCodeTypeLabel.TabIndex = 20
        Me.CleanedZipCodeTypeLabel.Text = "Zip Type:"
        '
        'CleanedAddressTypeLabel
        '
        Me.CleanedAddressTypeLabel.AutoSize = True
        Me.CleanedAddressTypeLabel.Location = New System.Drawing.Point(10, 152)
        Me.CleanedAddressTypeLabel.Name = "CleanedAddressTypeLabel"
        Me.CleanedAddressTypeLabel.Size = New System.Drawing.Size(77, 13)
        Me.CleanedAddressTypeLabel.TabIndex = 18
        Me.CleanedAddressTypeLabel.Text = "Address Type:"
        '
        'CleanedAddressErrorTextBox
        '
        Me.CleanedAddressErrorTextBox.Location = New System.Drawing.Point(351, 203)
        Me.CleanedAddressErrorTextBox.Name = "CleanedAddressErrorTextBox"
        Me.CleanedAddressErrorTextBox.ReadOnly = True
        Me.CleanedAddressErrorTextBox.Size = New System.Drawing.Size(60, 21)
        Me.CleanedAddressErrorTextBox.TabIndex = 29
        '
        'CleanedAddressStatusTextBox
        '
        Me.CleanedAddressStatusTextBox.Location = New System.Drawing.Point(86, 203)
        Me.CleanedAddressStatusTextBox.Name = "CleanedAddressStatusTextBox"
        Me.CleanedAddressStatusTextBox.ReadOnly = True
        Me.CleanedAddressStatusTextBox.Size = New System.Drawing.Size(195, 21)
        Me.CleanedAddressStatusTextBox.TabIndex = 27
        '
        'CleanedCarrierTextBox
        '
        Me.CleanedCarrierTextBox.Location = New System.Drawing.Point(296, 122)
        Me.CleanedCarrierTextBox.Name = "CleanedCarrierTextBox"
        Me.CleanedCarrierTextBox.ReadOnly = True
        Me.CleanedCarrierTextBox.Size = New System.Drawing.Size(115, 21)
        Me.CleanedCarrierTextBox.TabIndex = 17
        '
        'CleanedDeliveryPointTextBox
        '
        Me.CleanedDeliveryPointTextBox.Location = New System.Drawing.Point(86, 122)
        Me.CleanedDeliveryPointTextBox.Name = "CleanedDeliveryPointTextBox"
        Me.CleanedDeliveryPointTextBox.ReadOnly = True
        Me.CleanedDeliveryPointTextBox.Size = New System.Drawing.Size(115, 21)
        Me.CleanedDeliveryPointTextBox.TabIndex = 15
        '
        'CleanedCarrierLabel
        '
        Me.CleanedCarrierLabel.AutoSize = True
        Me.CleanedCarrierLabel.Location = New System.Drawing.Point(224, 125)
        Me.CleanedCarrierLabel.Name = "CleanedCarrierLabel"
        Me.CleanedCarrierLabel.Size = New System.Drawing.Size(44, 13)
        Me.CleanedCarrierLabel.TabIndex = 16
        Me.CleanedCarrierLabel.Text = "Carrier:"
        '
        'CleanedDeliveryPointLabel
        '
        Me.CleanedDeliveryPointLabel.AutoSize = True
        Me.CleanedDeliveryPointLabel.Location = New System.Drawing.Point(10, 125)
        Me.CleanedDeliveryPointLabel.Name = "CleanedDeliveryPointLabel"
        Me.CleanedDeliveryPointLabel.Size = New System.Drawing.Size(36, 13)
        Me.CleanedDeliveryPointLabel.TabIndex = 14
        Me.CleanedDeliveryPointLabel.Text = "DelPt:"
        '
        'CleanedAddressErrorLabel
        '
        Me.CleanedAddressErrorLabel.AutoSize = True
        Me.CleanedAddressErrorLabel.Location = New System.Drawing.Point(297, 206)
        Me.CleanedAddressErrorLabel.Name = "CleanedAddressErrorLabel"
        Me.CleanedAddressErrorLabel.Size = New System.Drawing.Size(48, 13)
        Me.CleanedAddressErrorLabel.TabIndex = 28
        Me.CleanedAddressErrorLabel.Text = "AddrErr:"
        '
        'CleanedAddressStatusLabel
        '
        Me.CleanedAddressStatusLabel.AutoSize = True
        Me.CleanedAddressStatusLabel.Location = New System.Drawing.Point(9, 207)
        Me.CleanedAddressStatusLabel.Name = "CleanedAddressStatusLabel"
        Me.CleanedAddressStatusLabel.Size = New System.Drawing.Size(54, 13)
        Me.CleanedAddressStatusLabel.TabIndex = 26
        Me.CleanedAddressStatusLabel.Text = "AddrStat:"
        '
        'CleanedCountryTextBox
        '
        Me.CleanedCountryTextBox.Location = New System.Drawing.Point(300, 95)
        Me.CleanedCountryTextBox.Name = "CleanedCountryTextBox"
        Me.CleanedCountryTextBox.ReadOnly = True
        Me.CleanedCountryTextBox.Size = New System.Drawing.Size(111, 21)
        Me.CleanedCountryTextBox.TabIndex = 13
        '
        'CleanedCountryLabel
        '
        Me.CleanedCountryLabel.AutoSize = True
        Me.CleanedCountryLabel.Location = New System.Drawing.Point(244, 98)
        Me.CleanedCountryLabel.Name = "CleanedCountryLabel"
        Me.CleanedCountryLabel.Size = New System.Drawing.Size(50, 13)
        Me.CleanedCountryLabel.TabIndex = 12
        Me.CleanedCountryLabel.Text = "Country:"
        '
        'CleanedZip4TextBox
        '
        Me.CleanedZip4TextBox.Location = New System.Drawing.Point(187, 95)
        Me.CleanedZip4TextBox.Name = "CleanedZip4TextBox"
        Me.CleanedZip4TextBox.ReadOnly = True
        Me.CleanedZip4TextBox.Size = New System.Drawing.Size(39, 21)
        Me.CleanedZip4TextBox.TabIndex = 11
        '
        'CleanedZip5TextBox
        '
        Me.CleanedZip5TextBox.Location = New System.Drawing.Point(86, 95)
        Me.CleanedZip5TextBox.Name = "CleanedZip5TextBox"
        Me.CleanedZip5TextBox.ReadOnly = True
        Me.CleanedZip5TextBox.Size = New System.Drawing.Size(47, 21)
        Me.CleanedZip5TextBox.TabIndex = 9
        '
        'CleanedStateTextBox
        '
        Me.CleanedStateTextBox.Location = New System.Drawing.Point(371, 68)
        Me.CleanedStateTextBox.Name = "CleanedStateTextBox"
        Me.CleanedStateTextBox.ReadOnly = True
        Me.CleanedStateTextBox.Size = New System.Drawing.Size(40, 21)
        Me.CleanedStateTextBox.TabIndex = 7
        '
        'CleanedCityTextBox
        '
        Me.CleanedCityTextBox.Location = New System.Drawing.Point(86, 68)
        Me.CleanedCityTextBox.Name = "CleanedCityTextBox"
        Me.CleanedCityTextBox.ReadOnly = True
        Me.CleanedCityTextBox.Size = New System.Drawing.Size(224, 21)
        Me.CleanedCityTextBox.TabIndex = 5
        '
        'CleanedZip4Label
        '
        Me.CleanedZip4Label.AutoSize = True
        Me.CleanedZip4Label.Location = New System.Drawing.Point(150, 98)
        Me.CleanedZip4Label.Name = "CleanedZip4Label"
        Me.CleanedZip4Label.Size = New System.Drawing.Size(31, 13)
        Me.CleanedZip4Label.TabIndex = 10
        Me.CleanedZip4Label.Text = "Zip4:"
        '
        'CleanedZip5Label
        '
        Me.CleanedZip5Label.AutoSize = True
        Me.CleanedZip5Label.Location = New System.Drawing.Point(10, 98)
        Me.CleanedZip5Label.Name = "CleanedZip5Label"
        Me.CleanedZip5Label.Size = New System.Drawing.Size(31, 13)
        Me.CleanedZip5Label.TabIndex = 8
        Me.CleanedZip5Label.Text = "Zip5:"
        '
        'CleanedStateLabel
        '
        Me.CleanedStateLabel.AutoSize = True
        Me.CleanedStateLabel.Location = New System.Drawing.Point(329, 71)
        Me.CleanedStateLabel.Name = "CleanedStateLabel"
        Me.CleanedStateLabel.Size = New System.Drawing.Size(37, 13)
        Me.CleanedStateLabel.TabIndex = 6
        Me.CleanedStateLabel.Text = "State:"
        '
        'CleanedCityLabel
        '
        Me.CleanedCityLabel.AutoSize = True
        Me.CleanedCityLabel.Location = New System.Drawing.Point(10, 71)
        Me.CleanedCityLabel.Name = "CleanedCityLabel"
        Me.CleanedCityLabel.Size = New System.Drawing.Size(30, 13)
        Me.CleanedCityLabel.TabIndex = 4
        Me.CleanedCityLabel.Text = "City:"
        '
        'CleanedStreetLine2TextBox
        '
        Me.CleanedStreetLine2TextBox.Location = New System.Drawing.Point(86, 41)
        Me.CleanedStreetLine2TextBox.Name = "CleanedStreetLine2TextBox"
        Me.CleanedStreetLine2TextBox.ReadOnly = True
        Me.CleanedStreetLine2TextBox.Size = New System.Drawing.Size(325, 21)
        Me.CleanedStreetLine2TextBox.TabIndex = 3
        '
        'CleanedStreetLine1TextBox
        '
        Me.CleanedStreetLine1TextBox.Location = New System.Drawing.Point(86, 14)
        Me.CleanedStreetLine1TextBox.Name = "CleanedStreetLine1TextBox"
        Me.CleanedStreetLine1TextBox.ReadOnly = True
        Me.CleanedStreetLine1TextBox.Size = New System.Drawing.Size(325, 21)
        Me.CleanedStreetLine1TextBox.TabIndex = 1
        '
        'CleanedStreetLine1Label
        '
        Me.CleanedStreetLine1Label.AutoSize = True
        Me.CleanedStreetLine1Label.Location = New System.Drawing.Point(10, 17)
        Me.CleanedStreetLine1Label.Name = "CleanedStreetLine1Label"
        Me.CleanedStreetLine1Label.Size = New System.Drawing.Size(72, 13)
        Me.CleanedStreetLine1Label.TabIndex = 0
        Me.CleanedStreetLine1Label.Text = "Street Line 1:"
        '
        'GeoCodeTabPage
        '
        Me.GeoCodeTabPage.Controls.Add(Me.GeoCodeStatTextBox)
        Me.GeoCodeTabPage.Controls.Add(Me.GeoCodeStatLabel)
        Me.GeoCodeTabPage.Controls.Add(Me.CensusTractTextBox)
        Me.GeoCodeTabPage.Controls.Add(Me.CensusBlockTextBox)
        Me.GeoCodeTabPage.Controls.Add(Me.CensusTractLabel)
        Me.GeoCodeTabPage.Controls.Add(Me.CensusBlockLabel)
        Me.GeoCodeTabPage.Controls.Add(Me.CoreBasedStatisticalGroupBox)
        Me.GeoCodeTabPage.Controls.Add(Me.TimeZoneCodeTextBox)
        Me.GeoCodeTabPage.Controls.Add(Me.TimeZoneNameTextBox)
        Me.GeoCodeTabPage.Controls.Add(Me.TimeZoneCodeLabel)
        Me.GeoCodeTabPage.Controls.Add(Me.TimeZoneNameLabel)
        Me.GeoCodeTabPage.Controls.Add(Me.PlaceCodeTextBox)
        Me.GeoCodeTabPage.Controls.Add(Me.PlaceNameTextBox)
        Me.GeoCodeTabPage.Controls.Add(Me.PlaceCodeLabel)
        Me.GeoCodeTabPage.Controls.Add(Me.PlaceNameLabel)
        Me.GeoCodeTabPage.Controls.Add(Me.LongitudeTextBox)
        Me.GeoCodeTabPage.Controls.Add(Me.LatitudeTextBox)
        Me.GeoCodeTabPage.Controls.Add(Me.LongitudeLabel)
        Me.GeoCodeTabPage.Controls.Add(Me.LatitudeLabel)
        Me.GeoCodeTabPage.Controls.Add(Me.CountyFIPSTextBox)
        Me.GeoCodeTabPage.Controls.Add(Me.CountyNameTextBox)
        Me.GeoCodeTabPage.Controls.Add(Me.CountyFIPSLabel)
        Me.GeoCodeTabPage.Controls.Add(Me.CountyNameLabel)
        Me.GeoCodeTabPage.Location = New System.Drawing.Point(4, 22)
        Me.GeoCodeTabPage.Name = "GeoCodeTabPage"
        Me.GeoCodeTabPage.Size = New System.Drawing.Size(424, 288)
        Me.GeoCodeTabPage.TabIndex = 3
        Me.GeoCodeTabPage.Text = "GeoCode Information"
        '
        'GeoCodeStatTextBox
        '
        Me.GeoCodeStatTextBox.Location = New System.Drawing.Point(86, 255)
        Me.GeoCodeStatTextBox.Name = "GeoCodeStatTextBox"
        Me.GeoCodeStatTextBox.ReadOnly = True
        Me.GeoCodeStatTextBox.Size = New System.Drawing.Size(325, 21)
        Me.GeoCodeStatTextBox.TabIndex = 22
        '
        'GeoCodeStatLabel
        '
        Me.GeoCodeStatLabel.AutoSize = True
        Me.GeoCodeStatLabel.Location = New System.Drawing.Point(10, 258)
        Me.GeoCodeStatLabel.Name = "GeoCodeStatLabel"
        Me.GeoCodeStatLabel.Size = New System.Drawing.Size(75, 13)
        Me.GeoCodeStatLabel.TabIndex = 21
        Me.GeoCodeStatLabel.Text = "GeoCodeStat:"
        '
        'CensusTractTextBox
        '
        Me.CensusTractTextBox.Location = New System.Drawing.Point(297, 95)
        Me.CensusTractTextBox.Name = "CensusTractTextBox"
        Me.CensusTractTextBox.ReadOnly = True
        Me.CensusTractTextBox.Size = New System.Drawing.Size(114, 21)
        Me.CensusTractTextBox.TabIndex = 15
        '
        'CensusBlockTextBox
        '
        Me.CensusBlockTextBox.Location = New System.Drawing.Point(86, 95)
        Me.CensusBlockTextBox.Name = "CensusBlockTextBox"
        Me.CensusBlockTextBox.ReadOnly = True
        Me.CensusBlockTextBox.Size = New System.Drawing.Size(114, 21)
        Me.CensusBlockTextBox.TabIndex = 13
        '
        'CensusTractLabel
        '
        Me.CensusTractLabel.AutoSize = True
        Me.CensusTractLabel.Location = New System.Drawing.Point(218, 98)
        Me.CensusTractLabel.Name = "CensusTractLabel"
        Me.CensusTractLabel.Size = New System.Drawing.Size(74, 13)
        Me.CensusTractLabel.TabIndex = 14
        Me.CensusTractLabel.Text = "Census Tract:"
        '
        'CensusBlockLabel
        '
        Me.CensusBlockLabel.AutoSize = True
        Me.CensusBlockLabel.Location = New System.Drawing.Point(10, 98)
        Me.CensusBlockLabel.Name = "CensusBlockLabel"
        Me.CensusBlockLabel.Size = New System.Drawing.Size(73, 13)
        Me.CensusBlockLabel.TabIndex = 12
        Me.CensusBlockLabel.Text = "Census Block:"
        '
        'CoreBasedStatisticalGroupBox
        '
        Me.CoreBasedStatisticalGroupBox.Controls.Add(Me.CBSADivisionTitleTextBox)
        Me.CoreBasedStatisticalGroupBox.Controls.Add(Me.CBSADivisionTitleLabel)
        Me.CoreBasedStatisticalGroupBox.Controls.Add(Me.CBSADivisionLevelTextBox)
        Me.CoreBasedStatisticalGroupBox.Controls.Add(Me.CBSADivisionLevelLabel)
        Me.CoreBasedStatisticalGroupBox.Controls.Add(Me.CBSADivisionCodeTextBox)
        Me.CoreBasedStatisticalGroupBox.Controls.Add(Me.CBSADivisionCodeLabel)
        Me.CoreBasedStatisticalGroupBox.Controls.Add(Me.CBSATitleTextBox)
        Me.CoreBasedStatisticalGroupBox.Controls.Add(Me.CBSATitleLabel)
        Me.CoreBasedStatisticalGroupBox.Controls.Add(Me.CBSALevelTextBox)
        Me.CoreBasedStatisticalGroupBox.Controls.Add(Me.CBSALevelLabel)
        Me.CoreBasedStatisticalGroupBox.Controls.Add(Me.CBSACodeTextBox)
        Me.CoreBasedStatisticalGroupBox.Controls.Add(Me.CBSACodeLabel)
        Me.CoreBasedStatisticalGroupBox.Location = New System.Drawing.Point(13, 149)
        Me.CoreBasedStatisticalGroupBox.Name = "CoreBasedStatisticalGroupBox"
        Me.CoreBasedStatisticalGroupBox.Size = New System.Drawing.Size(398, 100)
        Me.CoreBasedStatisticalGroupBox.TabIndex = 20
        Me.CoreBasedStatisticalGroupBox.TabStop = False
        Me.CoreBasedStatisticalGroupBox.Text = "Core Based Statistical Area"
        '
        'CBSADivisionTitleTextBox
        '
        Me.CBSADivisionTitleTextBox.Location = New System.Drawing.Point(265, 72)
        Me.CBSADivisionTitleTextBox.Name = "CBSADivisionTitleTextBox"
        Me.CBSADivisionTitleTextBox.ReadOnly = True
        Me.CBSADivisionTitleTextBox.Size = New System.Drawing.Size(122, 21)
        Me.CBSADivisionTitleTextBox.TabIndex = 11
        '
        'CBSADivisionTitleLabel
        '
        Me.CBSADivisionTitleLabel.AutoSize = True
        Me.CBSADivisionTitleLabel.Location = New System.Drawing.Point(186, 75)
        Me.CBSADivisionTitleLabel.Name = "CBSADivisionTitleLabel"
        Me.CBSADivisionTitleLabel.Size = New System.Drawing.Size(70, 13)
        Me.CBSADivisionTitleLabel.TabIndex = 10
        Me.CBSADivisionTitleLabel.Text = "Division Title:"
        '
        'CBSADivisionLevelTextBox
        '
        Me.CBSADivisionLevelTextBox.Location = New System.Drawing.Point(265, 46)
        Me.CBSADivisionLevelTextBox.Name = "CBSADivisionLevelTextBox"
        Me.CBSADivisionLevelTextBox.ReadOnly = True
        Me.CBSADivisionLevelTextBox.Size = New System.Drawing.Size(122, 21)
        Me.CBSADivisionLevelTextBox.TabIndex = 7
        '
        'CBSADivisionLevelLabel
        '
        Me.CBSADivisionLevelLabel.AutoSize = True
        Me.CBSADivisionLevelLabel.Location = New System.Drawing.Point(186, 49)
        Me.CBSADivisionLevelLabel.Name = "CBSADivisionLevelLabel"
        Me.CBSADivisionLevelLabel.Size = New System.Drawing.Size(75, 13)
        Me.CBSADivisionLevelLabel.TabIndex = 6
        Me.CBSADivisionLevelLabel.Text = "Division Level:"
        '
        'CBSADivisionCodeTextBox
        '
        Me.CBSADivisionCodeTextBox.Location = New System.Drawing.Point(265, 20)
        Me.CBSADivisionCodeTextBox.Name = "CBSADivisionCodeTextBox"
        Me.CBSADivisionCodeTextBox.ReadOnly = True
        Me.CBSADivisionCodeTextBox.Size = New System.Drawing.Size(122, 21)
        Me.CBSADivisionCodeTextBox.TabIndex = 3
        '
        'CBSADivisionCodeLabel
        '
        Me.CBSADivisionCodeLabel.AutoSize = True
        Me.CBSADivisionCodeLabel.Location = New System.Drawing.Point(186, 23)
        Me.CBSADivisionCodeLabel.Name = "CBSADivisionCodeLabel"
        Me.CBSADivisionCodeLabel.Size = New System.Drawing.Size(75, 13)
        Me.CBSADivisionCodeLabel.TabIndex = 2
        Me.CBSADivisionCodeLabel.Text = "Division Code:"
        '
        'CBSATitleTextBox
        '
        Me.CBSATitleTextBox.Location = New System.Drawing.Point(47, 72)
        Me.CBSATitleTextBox.Name = "CBSATitleTextBox"
        Me.CBSATitleTextBox.ReadOnly = True
        Me.CBSATitleTextBox.Size = New System.Drawing.Size(122, 21)
        Me.CBSATitleTextBox.TabIndex = 9
        '
        'CBSATitleLabel
        '
        Me.CBSATitleLabel.AutoSize = True
        Me.CBSATitleLabel.Location = New System.Drawing.Point(6, 75)
        Me.CBSATitleLabel.Name = "CBSATitleLabel"
        Me.CBSATitleLabel.Size = New System.Drawing.Size(31, 13)
        Me.CBSATitleLabel.TabIndex = 8
        Me.CBSATitleLabel.Text = "Title:"
        '
        'CBSALevelTextBox
        '
        Me.CBSALevelTextBox.Location = New System.Drawing.Point(47, 46)
        Me.CBSALevelTextBox.Name = "CBSALevelTextBox"
        Me.CBSALevelTextBox.ReadOnly = True
        Me.CBSALevelTextBox.Size = New System.Drawing.Size(122, 21)
        Me.CBSALevelTextBox.TabIndex = 5
        '
        'CBSALevelLabel
        '
        Me.CBSALevelLabel.AutoSize = True
        Me.CBSALevelLabel.Location = New System.Drawing.Point(6, 49)
        Me.CBSALevelLabel.Name = "CBSALevelLabel"
        Me.CBSALevelLabel.Size = New System.Drawing.Size(36, 13)
        Me.CBSALevelLabel.TabIndex = 4
        Me.CBSALevelLabel.Text = "Level:"
        '
        'CBSACodeTextBox
        '
        Me.CBSACodeTextBox.Location = New System.Drawing.Point(47, 20)
        Me.CBSACodeTextBox.Name = "CBSACodeTextBox"
        Me.CBSACodeTextBox.ReadOnly = True
        Me.CBSACodeTextBox.Size = New System.Drawing.Size(122, 21)
        Me.CBSACodeTextBox.TabIndex = 1
        '
        'CBSACodeLabel
        '
        Me.CBSACodeLabel.AutoSize = True
        Me.CBSACodeLabel.Location = New System.Drawing.Point(6, 23)
        Me.CBSACodeLabel.Name = "CBSACodeLabel"
        Me.CBSACodeLabel.Size = New System.Drawing.Size(36, 13)
        Me.CBSACodeLabel.TabIndex = 0
        Me.CBSACodeLabel.Text = "Code:"
        '
        'TimeZoneCodeTextBox
        '
        Me.TimeZoneCodeTextBox.Location = New System.Drawing.Point(351, 122)
        Me.TimeZoneCodeTextBox.Name = "TimeZoneCodeTextBox"
        Me.TimeZoneCodeTextBox.ReadOnly = True
        Me.TimeZoneCodeTextBox.Size = New System.Drawing.Size(60, 21)
        Me.TimeZoneCodeTextBox.TabIndex = 19
        '
        'TimeZoneNameTextBox
        '
        Me.TimeZoneNameTextBox.Location = New System.Drawing.Point(86, 122)
        Me.TimeZoneNameTextBox.Name = "TimeZoneNameTextBox"
        Me.TimeZoneNameTextBox.ReadOnly = True
        Me.TimeZoneNameTextBox.Size = New System.Drawing.Size(187, 21)
        Me.TimeZoneNameTextBox.TabIndex = 17
        '
        'TimeZoneCodeLabel
        '
        Me.TimeZoneCodeLabel.AutoSize = True
        Me.TimeZoneCodeLabel.Location = New System.Drawing.Point(300, 125)
        Me.TimeZoneCodeLabel.Name = "TimeZoneCodeLabel"
        Me.TimeZoneCodeLabel.Size = New System.Drawing.Size(36, 13)
        Me.TimeZoneCodeLabel.TabIndex = 18
        Me.TimeZoneCodeLabel.Text = "Code:"
        '
        'TimeZoneNameLabel
        '
        Me.TimeZoneNameLabel.AutoSize = True
        Me.TimeZoneNameLabel.Location = New System.Drawing.Point(10, 125)
        Me.TimeZoneNameLabel.Name = "TimeZoneNameLabel"
        Me.TimeZoneNameLabel.Size = New System.Drawing.Size(60, 13)
        Me.TimeZoneNameLabel.TabIndex = 16
        Me.TimeZoneNameLabel.Text = "Time Zone:"
        '
        'PlaceCodeTextBox
        '
        Me.PlaceCodeTextBox.Location = New System.Drawing.Point(351, 68)
        Me.PlaceCodeTextBox.Name = "PlaceCodeTextBox"
        Me.PlaceCodeTextBox.ReadOnly = True
        Me.PlaceCodeTextBox.Size = New System.Drawing.Size(60, 21)
        Me.PlaceCodeTextBox.TabIndex = 11
        '
        'PlaceNameTextBox
        '
        Me.PlaceNameTextBox.Location = New System.Drawing.Point(86, 68)
        Me.PlaceNameTextBox.Name = "PlaceNameTextBox"
        Me.PlaceNameTextBox.ReadOnly = True
        Me.PlaceNameTextBox.Size = New System.Drawing.Size(187, 21)
        Me.PlaceNameTextBox.TabIndex = 9
        '
        'PlaceCodeLabel
        '
        Me.PlaceCodeLabel.AutoSize = True
        Me.PlaceCodeLabel.Location = New System.Drawing.Point(300, 71)
        Me.PlaceCodeLabel.Name = "PlaceCodeLabel"
        Me.PlaceCodeLabel.Size = New System.Drawing.Size(36, 13)
        Me.PlaceCodeLabel.TabIndex = 10
        Me.PlaceCodeLabel.Text = "Code:"
        '
        'PlaceNameLabel
        '
        Me.PlaceNameLabel.AutoSize = True
        Me.PlaceNameLabel.Location = New System.Drawing.Point(10, 71)
        Me.PlaceNameLabel.Name = "PlaceNameLabel"
        Me.PlaceNameLabel.Size = New System.Drawing.Size(36, 13)
        Me.PlaceNameLabel.TabIndex = 8
        Me.PlaceNameLabel.Text = "Place:"
        '
        'LongitudeTextBox
        '
        Me.LongitudeTextBox.Location = New System.Drawing.Point(297, 14)
        Me.LongitudeTextBox.Name = "LongitudeTextBox"
        Me.LongitudeTextBox.ReadOnly = True
        Me.LongitudeTextBox.Size = New System.Drawing.Size(114, 21)
        Me.LongitudeTextBox.TabIndex = 3
        '
        'LatitudeTextBox
        '
        Me.LatitudeTextBox.Location = New System.Drawing.Point(86, 14)
        Me.LatitudeTextBox.Name = "LatitudeTextBox"
        Me.LatitudeTextBox.ReadOnly = True
        Me.LatitudeTextBox.Size = New System.Drawing.Size(114, 21)
        Me.LatitudeTextBox.TabIndex = 1
        '
        'LongitudeLabel
        '
        Me.LongitudeLabel.AutoSize = True
        Me.LongitudeLabel.Location = New System.Drawing.Point(234, 17)
        Me.LongitudeLabel.Name = "LongitudeLabel"
        Me.LongitudeLabel.Size = New System.Drawing.Size(58, 13)
        Me.LongitudeLabel.TabIndex = 2
        Me.LongitudeLabel.Text = "Longitude:"
        '
        'LatitudeLabel
        '
        Me.LatitudeLabel.AutoSize = True
        Me.LatitudeLabel.Location = New System.Drawing.Point(10, 17)
        Me.LatitudeLabel.Name = "LatitudeLabel"
        Me.LatitudeLabel.Size = New System.Drawing.Size(50, 13)
        Me.LatitudeLabel.TabIndex = 0
        Me.LatitudeLabel.Text = "Latitude:"
        '
        'CountyFIPSTextBox
        '
        Me.CountyFIPSTextBox.Location = New System.Drawing.Point(351, 41)
        Me.CountyFIPSTextBox.Name = "CountyFIPSTextBox"
        Me.CountyFIPSTextBox.ReadOnly = True
        Me.CountyFIPSTextBox.Size = New System.Drawing.Size(60, 21)
        Me.CountyFIPSTextBox.TabIndex = 7
        '
        'CountyNameTextBox
        '
        Me.CountyNameTextBox.Location = New System.Drawing.Point(86, 41)
        Me.CountyNameTextBox.Name = "CountyNameTextBox"
        Me.CountyNameTextBox.ReadOnly = True
        Me.CountyNameTextBox.Size = New System.Drawing.Size(187, 21)
        Me.CountyNameTextBox.TabIndex = 5
        '
        'CountyFIPSLabel
        '
        Me.CountyFIPSLabel.AutoSize = True
        Me.CountyFIPSLabel.Location = New System.Drawing.Point(300, 44)
        Me.CountyFIPSLabel.Name = "CountyFIPSLabel"
        Me.CountyFIPSLabel.Size = New System.Drawing.Size(33, 13)
        Me.CountyFIPSLabel.TabIndex = 6
        Me.CountyFIPSLabel.Text = "FIPS:"
        '
        'CountyNameLabel
        '
        Me.CountyNameLabel.AutoSize = True
        Me.CountyNameLabel.Location = New System.Drawing.Point(10, 44)
        Me.CountyNameLabel.Name = "CountyNameLabel"
        Me.CountyNameLabel.Size = New System.Drawing.Size(46, 13)
        Me.CountyNameLabel.TabIndex = 4
        Me.CountyNameLabel.Text = "County:"
        '
        'PopulateGeoCodingCheckBox
        '
        Me.PopulateGeoCodingCheckBox.AutoSize = True
        Me.PopulateGeoCodingCheckBox.Location = New System.Drawing.Point(124, 340)
        Me.PopulateGeoCodingCheckBox.Name = "PopulateGeoCodingCheckBox"
        Me.PopulateGeoCodingCheckBox.Size = New System.Drawing.Size(123, 17)
        Me.PopulateGeoCodingCheckBox.TabIndex = 1
        Me.PopulateGeoCodingCheckBox.Text = "Populate GeoCoding"
        Me.PopulateGeoCodingCheckBox.UseVisualStyleBackColor = True
        '
        'ClearAddressButton
        '
        Me.ClearAddressButton.Location = New System.Drawing.Point(254, 336)
        Me.ClearAddressButton.Name = "ClearAddressButton"
        Me.ClearAddressButton.Size = New System.Drawing.Size(90, 23)
        Me.ClearAddressButton.TabIndex = 2
        Me.ClearAddressButton.Text = "Clear Address"
        Me.ClearAddressButton.UseVisualStyleBackColor = True
        '
        'CleanAddressButton
        '
        Me.CleanAddressButton.Location = New System.Drawing.Point(350, 336)
        Me.CleanAddressButton.Name = "CleanAddressButton"
        Me.CleanAddressButton.Size = New System.Drawing.Size(90, 23)
        Me.CleanAddressButton.TabIndex = 3
        Me.CleanAddressButton.Text = "Clean Address"
        Me.CleanAddressButton.UseVisualStyleBackColor = True
        '
        'FileCleaningTabPage
        '
        Me.FileCleaningTabPage.Controls.Add(Me.DatabaseComboBox)
        Me.FileCleaningTabPage.Controls.Add(Me.DatabaseLabel)
        Me.FileCleaningTabPage.Controls.Add(Me.ClearFileButton)
        Me.FileCleaningTabPage.Controls.Add(Me.CleanFileButton)
        Me.FileCleaningTabPage.Controls.Add(Me.BatchSizeTextBox)
        Me.FileCleaningTabPage.Controls.Add(Me.BatchSizeLabel)
        Me.FileCleaningTabPage.Controls.Add(Me.FileIDTextBox)
        Me.FileCleaningTabPage.Controls.Add(Me.FileIDLabel)
        Me.FileCleaningTabPage.Controls.Add(Me.StudyIDTextBox)
        Me.FileCleaningTabPage.Controls.Add(Me.StudyIDLabel)
        Me.FileCleaningTabPage.Location = New System.Drawing.Point(4, 22)
        Me.FileCleaningTabPage.Name = "FileCleaningTabPage"
        Me.FileCleaningTabPage.Padding = New System.Windows.Forms.Padding(3)
        Me.FileCleaningTabPage.Size = New System.Drawing.Size(451, 370)
        Me.FileCleaningTabPage.TabIndex = 1
        Me.FileCleaningTabPage.Text = "File Cleaning"
        '
        'DatabaseComboBox
        '
        Me.DatabaseComboBox.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.DatabaseComboBox.FormattingEnabled = True
        Me.DatabaseComboBox.Location = New System.Drawing.Point(72, 41)
        Me.DatabaseComboBox.Name = "DatabaseComboBox"
        Me.DatabaseComboBox.Size = New System.Drawing.Size(368, 21)
        Me.DatabaseComboBox.TabIndex = 7
        '
        'DatabaseLabel
        '
        Me.DatabaseLabel.AutoSize = True
        Me.DatabaseLabel.Location = New System.Drawing.Point(10, 44)
        Me.DatabaseLabel.Name = "DatabaseLabel"
        Me.DatabaseLabel.Size = New System.Drawing.Size(57, 13)
        Me.DatabaseLabel.TabIndex = 6
        Me.DatabaseLabel.Text = "Database:"
        '
        'ClearFileButton
        '
        Me.ClearFileButton.Location = New System.Drawing.Point(254, 336)
        Me.ClearFileButton.Name = "ClearFileButton"
        Me.ClearFileButton.Size = New System.Drawing.Size(90, 23)
        Me.ClearFileButton.TabIndex = 8
        Me.ClearFileButton.Text = "Clear File"
        Me.ClearFileButton.UseVisualStyleBackColor = True
        '
        'CleanFileButton
        '
        Me.CleanFileButton.Location = New System.Drawing.Point(350, 336)
        Me.CleanFileButton.Name = "CleanFileButton"
        Me.CleanFileButton.Size = New System.Drawing.Size(90, 23)
        Me.CleanFileButton.TabIndex = 9
        Me.CleanFileButton.Text = "Clean File"
        Me.CleanFileButton.UseVisualStyleBackColor = True
        '
        'BatchSizeTextBox
        '
        Me.BatchSizeTextBox.Location = New System.Drawing.Point(393, 14)
        Me.BatchSizeTextBox.Name = "BatchSizeTextBox"
        Me.BatchSizeTextBox.Size = New System.Drawing.Size(47, 21)
        Me.BatchSizeTextBox.TabIndex = 5
        Me.BatchSizeTextBox.Text = "1000"
        '
        'BatchSizeLabel
        '
        Me.BatchSizeLabel.AutoSize = True
        Me.BatchSizeLabel.Location = New System.Drawing.Point(326, 17)
        Me.BatchSizeLabel.Name = "BatchSizeLabel"
        Me.BatchSizeLabel.Size = New System.Drawing.Size(60, 13)
        Me.BatchSizeLabel.TabIndex = 4
        Me.BatchSizeLabel.Text = "Batch Size:"
        '
        'FileIDTextBox
        '
        Me.FileIDTextBox.Location = New System.Drawing.Point(220, 14)
        Me.FileIDTextBox.Name = "FileIDTextBox"
        Me.FileIDTextBox.Size = New System.Drawing.Size(53, 21)
        Me.FileIDTextBox.TabIndex = 3
        '
        'FileIDLabel
        '
        Me.FileIDLabel.AutoSize = True
        Me.FileIDLabel.Location = New System.Drawing.Point(174, 17)
        Me.FileIDLabel.Name = "FileIDLabel"
        Me.FileIDLabel.Size = New System.Drawing.Size(41, 13)
        Me.FileIDLabel.TabIndex = 2
        Me.FileIDLabel.Text = "File ID:"
        '
        'StudyIDTextBox
        '
        Me.StudyIDTextBox.Location = New System.Drawing.Point(72, 14)
        Me.StudyIDTextBox.Name = "StudyIDTextBox"
        Me.StudyIDTextBox.Size = New System.Drawing.Size(50, 21)
        Me.StudyIDTextBox.TabIndex = 1
        '
        'StudyIDLabel
        '
        Me.StudyIDLabel.AutoSize = True
        Me.StudyIDLabel.Location = New System.Drawing.Point(10, 17)
        Me.StudyIDLabel.Name = "StudyIDLabel"
        Me.StudyIDLabel.Size = New System.Drawing.Size(53, 13)
        Me.StudyIDLabel.TabIndex = 0
        Me.StudyIDLabel.Text = "Study ID:"
        '
        'NameCleaningTabPage
        '
        Me.NameCleaningTabPage.Controls.Add(Me.NameCleaningTabControl)
        Me.NameCleaningTabPage.Controls.Add(Me.ClearNameButton)
        Me.NameCleaningTabPage.Controls.Add(Me.CleanNameButton)
        Me.NameCleaningTabPage.Location = New System.Drawing.Point(4, 22)
        Me.NameCleaningTabPage.Name = "NameCleaningTabPage"
        Me.NameCleaningTabPage.Size = New System.Drawing.Size(451, 370)
        Me.NameCleaningTabPage.TabIndex = 2
        Me.NameCleaningTabPage.Text = "Name Cleaning"
        '
        'NameCleaningTabControl
        '
        Me.NameCleaningTabControl.Controls.Add(Me.OriginalNameTabPage)
        Me.NameCleaningTabControl.Controls.Add(Me.WorkingNameTabPage)
        Me.NameCleaningTabControl.Controls.Add(Me.CleanedNameTabPage)
        Me.NameCleaningTabControl.Location = New System.Drawing.Point(10, 10)
        Me.NameCleaningTabControl.Name = "NameCleaningTabControl"
        Me.NameCleaningTabControl.SelectedIndex = 0
        Me.NameCleaningTabControl.Size = New System.Drawing.Size(432, 209)
        Me.NameCleaningTabControl.TabIndex = 0
        '
        'OriginalNameTabPage
        '
        Me.OriginalNameTabPage.Controls.Add(Me.OriginalSuffixTextBox)
        Me.OriginalNameTabPage.Controls.Add(Me.OriginalSuffixLabel)
        Me.OriginalNameTabPage.Controls.Add(Me.OriginalTitleTextBox)
        Me.OriginalNameTabPage.Controls.Add(Me.OriginalTitleLabel)
        Me.OriginalNameTabPage.Controls.Add(Me.OriginalLastNameTextBox)
        Me.OriginalNameTabPage.Controls.Add(Me.OriginalLastNameLabel)
        Me.OriginalNameTabPage.Controls.Add(Me.OriginalMiddleInitialTextBox)
        Me.OriginalNameTabPage.Controls.Add(Me.OriginalMiddleInitialLabel)
        Me.OriginalNameTabPage.Controls.Add(Me.OriginalFirstNameTextBox)
        Me.OriginalNameTabPage.Controls.Add(Me.OriginalFirstNameLabel)
        Me.OriginalNameTabPage.Location = New System.Drawing.Point(4, 22)
        Me.OriginalNameTabPage.Name = "OriginalNameTabPage"
        Me.OriginalNameTabPage.Padding = New System.Windows.Forms.Padding(3)
        Me.OriginalNameTabPage.Size = New System.Drawing.Size(424, 183)
        Me.OriginalNameTabPage.TabIndex = 0
        Me.OriginalNameTabPage.Text = "Original Name"
        '
        'OriginalSuffixTextBox
        '
        Me.OriginalSuffixTextBox.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.OriginalSuffixTextBox.Location = New System.Drawing.Point(80, 122)
        Me.OriginalSuffixTextBox.Name = "OriginalSuffixTextBox"
        Me.OriginalSuffixTextBox.Size = New System.Drawing.Size(331, 21)
        Me.OriginalSuffixTextBox.TabIndex = 9
        '
        'OriginalSuffixLabel
        '
        Me.OriginalSuffixLabel.AutoSize = True
        Me.OriginalSuffixLabel.Location = New System.Drawing.Point(10, 125)
        Me.OriginalSuffixLabel.Name = "OriginalSuffixLabel"
        Me.OriginalSuffixLabel.Size = New System.Drawing.Size(39, 13)
        Me.OriginalSuffixLabel.TabIndex = 8
        Me.OriginalSuffixLabel.Text = "Suffix:"
        '
        'OriginalTitleTextBox
        '
        Me.OriginalTitleTextBox.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.OriginalTitleTextBox.Location = New System.Drawing.Point(80, 14)
        Me.OriginalTitleTextBox.Name = "OriginalTitleTextBox"
        Me.OriginalTitleTextBox.Size = New System.Drawing.Size(331, 21)
        Me.OriginalTitleTextBox.TabIndex = 1
        '
        'OriginalTitleLabel
        '
        Me.OriginalTitleLabel.AutoSize = True
        Me.OriginalTitleLabel.Location = New System.Drawing.Point(10, 17)
        Me.OriginalTitleLabel.Name = "OriginalTitleLabel"
        Me.OriginalTitleLabel.Size = New System.Drawing.Size(31, 13)
        Me.OriginalTitleLabel.TabIndex = 0
        Me.OriginalTitleLabel.Text = "Title:"
        '
        'OriginalLastNameTextBox
        '
        Me.OriginalLastNameTextBox.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.OriginalLastNameTextBox.Location = New System.Drawing.Point(80, 95)
        Me.OriginalLastNameTextBox.Name = "OriginalLastNameTextBox"
        Me.OriginalLastNameTextBox.Size = New System.Drawing.Size(331, 21)
        Me.OriginalLastNameTextBox.TabIndex = 7
        '
        'OriginalLastNameLabel
        '
        Me.OriginalLastNameLabel.AutoSize = True
        Me.OriginalLastNameLabel.Location = New System.Drawing.Point(10, 98)
        Me.OriginalLastNameLabel.Name = "OriginalLastNameLabel"
        Me.OriginalLastNameLabel.Size = New System.Drawing.Size(61, 13)
        Me.OriginalLastNameLabel.TabIndex = 6
        Me.OriginalLastNameLabel.Text = "Last Name:"
        '
        'OriginalMiddleInitialTextBox
        '
        Me.OriginalMiddleInitialTextBox.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.OriginalMiddleInitialTextBox.Location = New System.Drawing.Point(80, 68)
        Me.OriginalMiddleInitialTextBox.Name = "OriginalMiddleInitialTextBox"
        Me.OriginalMiddleInitialTextBox.Size = New System.Drawing.Size(331, 21)
        Me.OriginalMiddleInitialTextBox.TabIndex = 5
        '
        'OriginalMiddleInitialLabel
        '
        Me.OriginalMiddleInitialLabel.AutoSize = True
        Me.OriginalMiddleInitialLabel.Location = New System.Drawing.Point(10, 71)
        Me.OriginalMiddleInitialLabel.Name = "OriginalMiddleInitialLabel"
        Me.OriginalMiddleInitialLabel.Size = New System.Drawing.Size(70, 13)
        Me.OriginalMiddleInitialLabel.TabIndex = 4
        Me.OriginalMiddleInitialLabel.Text = "Middle Initial:"
        '
        'OriginalFirstNameTextBox
        '
        Me.OriginalFirstNameTextBox.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.OriginalFirstNameTextBox.Location = New System.Drawing.Point(80, 41)
        Me.OriginalFirstNameTextBox.Name = "OriginalFirstNameTextBox"
        Me.OriginalFirstNameTextBox.Size = New System.Drawing.Size(331, 21)
        Me.OriginalFirstNameTextBox.TabIndex = 3
        '
        'OriginalFirstNameLabel
        '
        Me.OriginalFirstNameLabel.AutoSize = True
        Me.OriginalFirstNameLabel.Location = New System.Drawing.Point(10, 44)
        Me.OriginalFirstNameLabel.Name = "OriginalFirstNameLabel"
        Me.OriginalFirstNameLabel.Size = New System.Drawing.Size(62, 13)
        Me.OriginalFirstNameLabel.TabIndex = 2
        Me.OriginalFirstNameLabel.Text = "First Name:"
        '
        'WorkingNameTabPage
        '
        Me.WorkingNameTabPage.Controls.Add(Me.WorkingSuffixTextBox)
        Me.WorkingNameTabPage.Controls.Add(Me.WorkingSuffixLabel)
        Me.WorkingNameTabPage.Controls.Add(Me.WorkingTitleTextBox)
        Me.WorkingNameTabPage.Controls.Add(Me.WorkingTitleLabel)
        Me.WorkingNameTabPage.Controls.Add(Me.WorkingNameStatusTextBox)
        Me.WorkingNameTabPage.Controls.Add(Me.WorkingNameStatusLabel)
        Me.WorkingNameTabPage.Controls.Add(Me.WorkingLastNameTextBox)
        Me.WorkingNameTabPage.Controls.Add(Me.WorkingLastNameLabel)
        Me.WorkingNameTabPage.Controls.Add(Me.WorkingMiddleInitialTextBox)
        Me.WorkingNameTabPage.Controls.Add(Me.WorkingMiddleInitialLabel)
        Me.WorkingNameTabPage.Controls.Add(Me.WorkingFirstNameTextBox)
        Me.WorkingNameTabPage.Controls.Add(Me.WorkingFirstNameLabel)
        Me.WorkingNameTabPage.Location = New System.Drawing.Point(4, 22)
        Me.WorkingNameTabPage.Name = "WorkingNameTabPage"
        Me.WorkingNameTabPage.Padding = New System.Windows.Forms.Padding(3)
        Me.WorkingNameTabPage.Size = New System.Drawing.Size(424, 183)
        Me.WorkingNameTabPage.TabIndex = 1
        Me.WorkingNameTabPage.Text = "Working Name"
        '
        'WorkingSuffixTextBox
        '
        Me.WorkingSuffixTextBox.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.WorkingSuffixTextBox.Location = New System.Drawing.Point(80, 122)
        Me.WorkingSuffixTextBox.Name = "WorkingSuffixTextBox"
        Me.WorkingSuffixTextBox.ReadOnly = True
        Me.WorkingSuffixTextBox.Size = New System.Drawing.Size(331, 21)
        Me.WorkingSuffixTextBox.TabIndex = 9
        '
        'WorkingSuffixLabel
        '
        Me.WorkingSuffixLabel.AutoSize = True
        Me.WorkingSuffixLabel.Location = New System.Drawing.Point(10, 125)
        Me.WorkingSuffixLabel.Name = "WorkingSuffixLabel"
        Me.WorkingSuffixLabel.Size = New System.Drawing.Size(39, 13)
        Me.WorkingSuffixLabel.TabIndex = 8
        Me.WorkingSuffixLabel.Text = "Suffix:"
        '
        'WorkingTitleTextBox
        '
        Me.WorkingTitleTextBox.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.WorkingTitleTextBox.Location = New System.Drawing.Point(80, 14)
        Me.WorkingTitleTextBox.Name = "WorkingTitleTextBox"
        Me.WorkingTitleTextBox.ReadOnly = True
        Me.WorkingTitleTextBox.Size = New System.Drawing.Size(331, 21)
        Me.WorkingTitleTextBox.TabIndex = 1
        '
        'WorkingTitleLabel
        '
        Me.WorkingTitleLabel.AutoSize = True
        Me.WorkingTitleLabel.Location = New System.Drawing.Point(10, 17)
        Me.WorkingTitleLabel.Name = "WorkingTitleLabel"
        Me.WorkingTitleLabel.Size = New System.Drawing.Size(31, 13)
        Me.WorkingTitleLabel.TabIndex = 0
        Me.WorkingTitleLabel.Text = "Title:"
        '
        'WorkingNameStatusTextBox
        '
        Me.WorkingNameStatusTextBox.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.WorkingNameStatusTextBox.Location = New System.Drawing.Point(80, 149)
        Me.WorkingNameStatusTextBox.Name = "WorkingNameStatusTextBox"
        Me.WorkingNameStatusTextBox.ReadOnly = True
        Me.WorkingNameStatusTextBox.Size = New System.Drawing.Size(331, 21)
        Me.WorkingNameStatusTextBox.TabIndex = 11
        '
        'WorkingNameStatusLabel
        '
        Me.WorkingNameStatusLabel.AutoSize = True
        Me.WorkingNameStatusLabel.Location = New System.Drawing.Point(10, 152)
        Me.WorkingNameStatusLabel.Name = "WorkingNameStatusLabel"
        Me.WorkingNameStatusLabel.Size = New System.Drawing.Size(58, 13)
        Me.WorkingNameStatusLabel.TabIndex = 10
        Me.WorkingNameStatusLabel.Text = "NameStat:"
        '
        'WorkingLastNameTextBox
        '
        Me.WorkingLastNameTextBox.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.WorkingLastNameTextBox.Location = New System.Drawing.Point(80, 95)
        Me.WorkingLastNameTextBox.Name = "WorkingLastNameTextBox"
        Me.WorkingLastNameTextBox.ReadOnly = True
        Me.WorkingLastNameTextBox.Size = New System.Drawing.Size(331, 21)
        Me.WorkingLastNameTextBox.TabIndex = 7
        '
        'WorkingLastNameLabel
        '
        Me.WorkingLastNameLabel.AutoSize = True
        Me.WorkingLastNameLabel.Location = New System.Drawing.Point(10, 98)
        Me.WorkingLastNameLabel.Name = "WorkingLastNameLabel"
        Me.WorkingLastNameLabel.Size = New System.Drawing.Size(61, 13)
        Me.WorkingLastNameLabel.TabIndex = 6
        Me.WorkingLastNameLabel.Text = "Last Name:"
        '
        'WorkingMiddleInitialTextBox
        '
        Me.WorkingMiddleInitialTextBox.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.WorkingMiddleInitialTextBox.Location = New System.Drawing.Point(80, 68)
        Me.WorkingMiddleInitialTextBox.Name = "WorkingMiddleInitialTextBox"
        Me.WorkingMiddleInitialTextBox.ReadOnly = True
        Me.WorkingMiddleInitialTextBox.Size = New System.Drawing.Size(331, 21)
        Me.WorkingMiddleInitialTextBox.TabIndex = 5
        '
        'WorkingMiddleInitialLabel
        '
        Me.WorkingMiddleInitialLabel.AutoSize = True
        Me.WorkingMiddleInitialLabel.Location = New System.Drawing.Point(10, 71)
        Me.WorkingMiddleInitialLabel.Name = "WorkingMiddleInitialLabel"
        Me.WorkingMiddleInitialLabel.Size = New System.Drawing.Size(70, 13)
        Me.WorkingMiddleInitialLabel.TabIndex = 4
        Me.WorkingMiddleInitialLabel.Text = "Middle Initial:"
        '
        'WorkingFirstNameTextBox
        '
        Me.WorkingFirstNameTextBox.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.WorkingFirstNameTextBox.Location = New System.Drawing.Point(80, 41)
        Me.WorkingFirstNameTextBox.Name = "WorkingFirstNameTextBox"
        Me.WorkingFirstNameTextBox.ReadOnly = True
        Me.WorkingFirstNameTextBox.Size = New System.Drawing.Size(331, 21)
        Me.WorkingFirstNameTextBox.TabIndex = 3
        '
        'WorkingFirstNameLabel
        '
        Me.WorkingFirstNameLabel.AutoSize = True
        Me.WorkingFirstNameLabel.Location = New System.Drawing.Point(10, 44)
        Me.WorkingFirstNameLabel.Name = "WorkingFirstNameLabel"
        Me.WorkingFirstNameLabel.Size = New System.Drawing.Size(62, 13)
        Me.WorkingFirstNameLabel.TabIndex = 2
        Me.WorkingFirstNameLabel.Text = "First Name:"
        '
        'CleanedNameTabPage
        '
        Me.CleanedNameTabPage.Controls.Add(Me.CleanedSuffixTextBox)
        Me.CleanedNameTabPage.Controls.Add(Me.CleanedSuffixLabel)
        Me.CleanedNameTabPage.Controls.Add(Me.CleanedTitleTextBox)
        Me.CleanedNameTabPage.Controls.Add(Me.CleanedTitleLabel)
        Me.CleanedNameTabPage.Controls.Add(Me.CleanedNameStatusTextBox)
        Me.CleanedNameTabPage.Controls.Add(Me.CleanedNameStatusLabel)
        Me.CleanedNameTabPage.Controls.Add(Me.CleanedLastNameTextBox)
        Me.CleanedNameTabPage.Controls.Add(Me.CleanedLastNameLabel)
        Me.CleanedNameTabPage.Controls.Add(Me.CleanedMiddleInitialTextBox)
        Me.CleanedNameTabPage.Controls.Add(Me.CleanedMiddleInitialLabel)
        Me.CleanedNameTabPage.Controls.Add(Me.CleanedFirstNameTextBox)
        Me.CleanedNameTabPage.Controls.Add(Me.CleanedFirstNameLabel)
        Me.CleanedNameTabPage.Location = New System.Drawing.Point(4, 22)
        Me.CleanedNameTabPage.Name = "CleanedNameTabPage"
        Me.CleanedNameTabPage.Size = New System.Drawing.Size(424, 183)
        Me.CleanedNameTabPage.TabIndex = 2
        Me.CleanedNameTabPage.Text = "Cleaned Name"
        '
        'CleanedSuffixTextBox
        '
        Me.CleanedSuffixTextBox.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.CleanedSuffixTextBox.Location = New System.Drawing.Point(80, 122)
        Me.CleanedSuffixTextBox.Name = "CleanedSuffixTextBox"
        Me.CleanedSuffixTextBox.ReadOnly = True
        Me.CleanedSuffixTextBox.Size = New System.Drawing.Size(331, 21)
        Me.CleanedSuffixTextBox.TabIndex = 9
        '
        'CleanedSuffixLabel
        '
        Me.CleanedSuffixLabel.AutoSize = True
        Me.CleanedSuffixLabel.Location = New System.Drawing.Point(10, 125)
        Me.CleanedSuffixLabel.Name = "CleanedSuffixLabel"
        Me.CleanedSuffixLabel.Size = New System.Drawing.Size(39, 13)
        Me.CleanedSuffixLabel.TabIndex = 8
        Me.CleanedSuffixLabel.Text = "Suffix:"
        '
        'CleanedTitleTextBox
        '
        Me.CleanedTitleTextBox.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.CleanedTitleTextBox.Location = New System.Drawing.Point(80, 14)
        Me.CleanedTitleTextBox.Name = "CleanedTitleTextBox"
        Me.CleanedTitleTextBox.ReadOnly = True
        Me.CleanedTitleTextBox.Size = New System.Drawing.Size(331, 21)
        Me.CleanedTitleTextBox.TabIndex = 1
        '
        'CleanedTitleLabel
        '
        Me.CleanedTitleLabel.AutoSize = True
        Me.CleanedTitleLabel.Location = New System.Drawing.Point(10, 17)
        Me.CleanedTitleLabel.Name = "CleanedTitleLabel"
        Me.CleanedTitleLabel.Size = New System.Drawing.Size(31, 13)
        Me.CleanedTitleLabel.TabIndex = 0
        Me.CleanedTitleLabel.Text = "Title:"
        '
        'CleanedNameStatusTextBox
        '
        Me.CleanedNameStatusTextBox.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.CleanedNameStatusTextBox.Location = New System.Drawing.Point(80, 149)
        Me.CleanedNameStatusTextBox.Name = "CleanedNameStatusTextBox"
        Me.CleanedNameStatusTextBox.ReadOnly = True
        Me.CleanedNameStatusTextBox.Size = New System.Drawing.Size(331, 21)
        Me.CleanedNameStatusTextBox.TabIndex = 11
        '
        'CleanedNameStatusLabel
        '
        Me.CleanedNameStatusLabel.AutoSize = True
        Me.CleanedNameStatusLabel.Location = New System.Drawing.Point(10, 152)
        Me.CleanedNameStatusLabel.Name = "CleanedNameStatusLabel"
        Me.CleanedNameStatusLabel.Size = New System.Drawing.Size(58, 13)
        Me.CleanedNameStatusLabel.TabIndex = 10
        Me.CleanedNameStatusLabel.Text = "NameStat:"
        '
        'CleanedLastNameTextBox
        '
        Me.CleanedLastNameTextBox.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.CleanedLastNameTextBox.Location = New System.Drawing.Point(80, 95)
        Me.CleanedLastNameTextBox.Name = "CleanedLastNameTextBox"
        Me.CleanedLastNameTextBox.ReadOnly = True
        Me.CleanedLastNameTextBox.Size = New System.Drawing.Size(331, 21)
        Me.CleanedLastNameTextBox.TabIndex = 7
        '
        'CleanedLastNameLabel
        '
        Me.CleanedLastNameLabel.AutoSize = True
        Me.CleanedLastNameLabel.Location = New System.Drawing.Point(10, 98)
        Me.CleanedLastNameLabel.Name = "CleanedLastNameLabel"
        Me.CleanedLastNameLabel.Size = New System.Drawing.Size(61, 13)
        Me.CleanedLastNameLabel.TabIndex = 6
        Me.CleanedLastNameLabel.Text = "Last Name:"
        '
        'CleanedMiddleInitialTextBox
        '
        Me.CleanedMiddleInitialTextBox.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.CleanedMiddleInitialTextBox.Location = New System.Drawing.Point(80, 68)
        Me.CleanedMiddleInitialTextBox.Name = "CleanedMiddleInitialTextBox"
        Me.CleanedMiddleInitialTextBox.ReadOnly = True
        Me.CleanedMiddleInitialTextBox.Size = New System.Drawing.Size(331, 21)
        Me.CleanedMiddleInitialTextBox.TabIndex = 5
        '
        'CleanedMiddleInitialLabel
        '
        Me.CleanedMiddleInitialLabel.AutoSize = True
        Me.CleanedMiddleInitialLabel.Location = New System.Drawing.Point(10, 71)
        Me.CleanedMiddleInitialLabel.Name = "CleanedMiddleInitialLabel"
        Me.CleanedMiddleInitialLabel.Size = New System.Drawing.Size(70, 13)
        Me.CleanedMiddleInitialLabel.TabIndex = 4
        Me.CleanedMiddleInitialLabel.Text = "Middle Initial:"
        '
        'CleanedFirstNameTextBox
        '
        Me.CleanedFirstNameTextBox.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.CleanedFirstNameTextBox.Location = New System.Drawing.Point(80, 41)
        Me.CleanedFirstNameTextBox.Name = "CleanedFirstNameTextBox"
        Me.CleanedFirstNameTextBox.ReadOnly = True
        Me.CleanedFirstNameTextBox.Size = New System.Drawing.Size(331, 21)
        Me.CleanedFirstNameTextBox.TabIndex = 3
        '
        'CleanedFirstNameLabel
        '
        Me.CleanedFirstNameLabel.AutoSize = True
        Me.CleanedFirstNameLabel.Location = New System.Drawing.Point(10, 44)
        Me.CleanedFirstNameLabel.Name = "CleanedFirstNameLabel"
        Me.CleanedFirstNameLabel.Size = New System.Drawing.Size(62, 13)
        Me.CleanedFirstNameLabel.TabIndex = 2
        Me.CleanedFirstNameLabel.Text = "First Name:"
        '
        'ClearNameButton
        '
        Me.ClearNameButton.Location = New System.Drawing.Point(254, 336)
        Me.ClearNameButton.Name = "ClearNameButton"
        Me.ClearNameButton.Size = New System.Drawing.Size(90, 23)
        Me.ClearNameButton.TabIndex = 1
        Me.ClearNameButton.Text = "Clear Name"
        Me.ClearNameButton.UseVisualStyleBackColor = True
        '
        'CleanNameButton
        '
        Me.CleanNameButton.Location = New System.Drawing.Point(350, 336)
        Me.CleanNameButton.Name = "CleanNameButton"
        Me.CleanNameButton.Size = New System.Drawing.Size(90, 23)
        Me.CleanNameButton.TabIndex = 2
        Me.CleanNameButton.Text = "Clean Name"
        Me.CleanNameButton.UseVisualStyleBackColor = True
        '
        'MainForm
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(482, 488)
        Me.Controls.Add(Me.CleaningTabControl)
        Me.Controls.Add(Me.LocationGroupBox)
        Me.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedSingle
        Me.MaximizeBox = False
        Me.MinimizeBox = False
        Me.Name = "MainForm"
        Me.Text = "Address Cleaning Test Application"
        Me.LocationGroupBox.ResumeLayout(False)
        Me.LocationGroupBox.PerformLayout()
        Me.CleaningTabControl.ResumeLayout(False)
        Me.AddressCleaningTabPage.ResumeLayout(False)
        Me.AddressCleaningTabPage.PerformLayout()
        Me.AddressCleaningTabControl.ResumeLayout(False)
        Me.OriginalAddressTabPage.ResumeLayout(False)
        Me.OriginalAddressTabPage.PerformLayout()
        Me.WorkingAddressTabPage.ResumeLayout(False)
        Me.WorkingAddressTabPage.PerformLayout()
        Me.CleanedAddressTabPage.ResumeLayout(False)
        Me.CleanedAddressTabPage.PerformLayout()
        Me.GeoCodeTabPage.ResumeLayout(False)
        Me.GeoCodeTabPage.PerformLayout()
        Me.CoreBasedStatisticalGroupBox.ResumeLayout(False)
        Me.CoreBasedStatisticalGroupBox.PerformLayout()
        Me.FileCleaningTabPage.ResumeLayout(False)
        Me.FileCleaningTabPage.PerformLayout()
        Me.NameCleaningTabPage.ResumeLayout(False)
        Me.NameCleaningTabControl.ResumeLayout(False)
        Me.OriginalNameTabPage.ResumeLayout(False)
        Me.OriginalNameTabPage.PerformLayout()
        Me.WorkingNameTabPage.ResumeLayout(False)
        Me.WorkingNameTabPage.PerformLayout()
        Me.CleanedNameTabPage.ResumeLayout(False)
        Me.CleanedNameTabPage.PerformLayout()
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents LocationGroupBox As System.Windows.Forms.GroupBox
    Friend WithEvents CountryComboBox As System.Windows.Forms.ComboBox
    Friend WithEvents CountryLabel As System.Windows.Forms.Label
    Friend WithEvents ForceProxyCheckBox As System.Windows.Forms.CheckBox
    Friend WithEvents CleaningTabControl As System.Windows.Forms.TabControl
    Friend WithEvents AddressCleaningTabPage As System.Windows.Forms.TabPage
    Friend WithEvents FileCleaningTabPage As System.Windows.Forms.TabPage
    Friend WithEvents DatabaseComboBox As System.Windows.Forms.ComboBox
    Friend WithEvents DatabaseLabel As System.Windows.Forms.Label
    Friend WithEvents ClearFileButton As System.Windows.Forms.Button
    Friend WithEvents CleanFileButton As System.Windows.Forms.Button
    Friend WithEvents BatchSizeTextBox As System.Windows.Forms.TextBox
    Friend WithEvents BatchSizeLabel As System.Windows.Forms.Label
    Friend WithEvents FileIDTextBox As System.Windows.Forms.TextBox
    Friend WithEvents FileIDLabel As System.Windows.Forms.Label
    Friend WithEvents StudyIDTextBox As System.Windows.Forms.TextBox
    Friend WithEvents StudyIDLabel As System.Windows.Forms.Label
    Friend WithEvents NameCleaningTabPage As System.Windows.Forms.TabPage
    Friend WithEvents NameCleaningTabControl As System.Windows.Forms.TabControl
    Friend WithEvents OriginalNameTabPage As System.Windows.Forms.TabPage
    Friend WithEvents OriginalSuffixTextBox As System.Windows.Forms.TextBox
    Friend WithEvents OriginalSuffixLabel As System.Windows.Forms.Label
    Friend WithEvents OriginalTitleTextBox As System.Windows.Forms.TextBox
    Friend WithEvents OriginalTitleLabel As System.Windows.Forms.Label
    Friend WithEvents OriginalLastNameTextBox As System.Windows.Forms.TextBox
    Friend WithEvents OriginalLastNameLabel As System.Windows.Forms.Label
    Friend WithEvents OriginalMiddleInitialTextBox As System.Windows.Forms.TextBox
    Friend WithEvents OriginalMiddleInitialLabel As System.Windows.Forms.Label
    Friend WithEvents OriginalFirstNameTextBox As System.Windows.Forms.TextBox
    Friend WithEvents OriginalFirstNameLabel As System.Windows.Forms.Label
    Friend WithEvents WorkingNameTabPage As System.Windows.Forms.TabPage
    Friend WithEvents WorkingSuffixTextBox As System.Windows.Forms.TextBox
    Friend WithEvents WorkingSuffixLabel As System.Windows.Forms.Label
    Friend WithEvents WorkingTitleTextBox As System.Windows.Forms.TextBox
    Friend WithEvents WorkingTitleLabel As System.Windows.Forms.Label
    Friend WithEvents WorkingNameStatusTextBox As System.Windows.Forms.TextBox
    Friend WithEvents WorkingNameStatusLabel As System.Windows.Forms.Label
    Friend WithEvents WorkingLastNameTextBox As System.Windows.Forms.TextBox
    Friend WithEvents WorkingLastNameLabel As System.Windows.Forms.Label
    Friend WithEvents WorkingMiddleInitialTextBox As System.Windows.Forms.TextBox
    Friend WithEvents WorkingMiddleInitialLabel As System.Windows.Forms.Label
    Friend WithEvents WorkingFirstNameTextBox As System.Windows.Forms.TextBox
    Friend WithEvents WorkingFirstNameLabel As System.Windows.Forms.Label
    Friend WithEvents CleanedNameTabPage As System.Windows.Forms.TabPage
    Friend WithEvents CleanedSuffixTextBox As System.Windows.Forms.TextBox
    Friend WithEvents CleanedSuffixLabel As System.Windows.Forms.Label
    Friend WithEvents CleanedTitleTextBox As System.Windows.Forms.TextBox
    Friend WithEvents CleanedTitleLabel As System.Windows.Forms.Label
    Friend WithEvents CleanedNameStatusTextBox As System.Windows.Forms.TextBox
    Friend WithEvents CleanedNameStatusLabel As System.Windows.Forms.Label
    Friend WithEvents CleanedLastNameTextBox As System.Windows.Forms.TextBox
    Friend WithEvents CleanedLastNameLabel As System.Windows.Forms.Label
    Friend WithEvents CleanedMiddleInitialTextBox As System.Windows.Forms.TextBox
    Friend WithEvents CleanedMiddleInitialLabel As System.Windows.Forms.Label
    Friend WithEvents CleanedFirstNameTextBox As System.Windows.Forms.TextBox
    Friend WithEvents CleanedFirstNameLabel As System.Windows.Forms.Label
    Friend WithEvents ClearNameButton As System.Windows.Forms.Button
    Friend WithEvents CleanNameButton As System.Windows.Forms.Button
    Friend WithEvents AddressCleaningTabControl As System.Windows.Forms.TabControl
    Friend WithEvents OriginalAddressTabPage As System.Windows.Forms.TabPage
    Friend WithEvents OriginalStreetLine2Label As System.Windows.Forms.Label
    Friend WithEvents OriginalCountryTextBox As System.Windows.Forms.TextBox
    Friend WithEvents OriginalCountryLabel As System.Windows.Forms.Label
    Friend WithEvents OriginalZip4TextBox As System.Windows.Forms.TextBox
    Friend WithEvents OriginalZip5TextBox As System.Windows.Forms.TextBox
    Friend WithEvents OriginalStateTextBox As System.Windows.Forms.TextBox
    Friend WithEvents OriginalCityTextBox As System.Windows.Forms.TextBox
    Friend WithEvents OriginalZip4Label As System.Windows.Forms.Label
    Friend WithEvents OriginalZip5Label As System.Windows.Forms.Label
    Friend WithEvents OriginalStateLabel As System.Windows.Forms.Label
    Friend WithEvents OriginalCityLabel As System.Windows.Forms.Label
    Friend WithEvents OriginalStreetLine2TextBox As System.Windows.Forms.TextBox
    Friend WithEvents OriginalStreetLine1TextBox As System.Windows.Forms.TextBox
    Friend WithEvents OriginalStreetLine1Label As System.Windows.Forms.Label
    Friend WithEvents WorkingAddressTabPage As System.Windows.Forms.TabPage
    Friend WithEvents WorkingStreetLine2Label As System.Windows.Forms.Label
    Friend WithEvents WorkingPrivateMailBoxTextBox As System.Windows.Forms.TextBox
    Friend WithEvents WorkingUrbanizationNameTextBox As System.Windows.Forms.TextBox
    Friend WithEvents WorkingPrivateMailBoxLabel As System.Windows.Forms.Label
    Friend WithEvents WorkingUrbanizationNameLabel As System.Windows.Forms.Label
    Friend WithEvents WorkingZipCodeTypeTextBox As System.Windows.Forms.TextBox
    Friend WithEvents WorkingAddressTypeTextBox As System.Windows.Forms.TextBox
    Friend WithEvents WorkingZipCodeTypeLabel As System.Windows.Forms.Label
    Friend WithEvents WorkingAddressTypeLabel As System.Windows.Forms.Label
    Friend WithEvents WorkingAddressErrorTextBox As System.Windows.Forms.TextBox
    Friend WithEvents WorkingAddressStatusTextBox As System.Windows.Forms.TextBox
    Friend WithEvents WorkingCarrierTextBox As System.Windows.Forms.TextBox
    Friend WithEvents WorkingDeliveryPointTextBox As System.Windows.Forms.TextBox
    Friend WithEvents WorkingCarrierLabel As System.Windows.Forms.Label
    Friend WithEvents WorkingDeliveryPointLabel As System.Windows.Forms.Label
    Friend WithEvents WorkingAddressErrorLabel As System.Windows.Forms.Label
    Friend WithEvents WorkingAddressStatusLabel As System.Windows.Forms.Label
    Friend WithEvents WorkingCountryTextBox As System.Windows.Forms.TextBox
    Friend WithEvents WorkingCountryLabel As System.Windows.Forms.Label
    Friend WithEvents WorkingZip4TextBox As System.Windows.Forms.TextBox
    Friend WithEvents WorkingZip5TextBox As System.Windows.Forms.TextBox
    Friend WithEvents WorkingStateTextBox As System.Windows.Forms.TextBox
    Friend WithEvents WorkingCityTextBox As System.Windows.Forms.TextBox
    Friend WithEvents WorkingZip4Label As System.Windows.Forms.Label
    Friend WithEvents WorkingZip5Label As System.Windows.Forms.Label
    Friend WithEvents WorkingStateLabel As System.Windows.Forms.Label
    Friend WithEvents WorkingCityLabel As System.Windows.Forms.Label
    Friend WithEvents WorkingStreetLine2TextBox As System.Windows.Forms.TextBox
    Friend WithEvents WorkingStreetLine1TextBox As System.Windows.Forms.TextBox
    Friend WithEvents WorkingStreetLine1Label As System.Windows.Forms.Label
    Friend WithEvents CleanedAddressTabPage As System.Windows.Forms.TabPage
    Friend WithEvents CleanedStreetLine2Label As System.Windows.Forms.Label
    Friend WithEvents CleanedPrivateMailBoxTextBox As System.Windows.Forms.TextBox
    Friend WithEvents CleanedUrbanizationNameTextBox As System.Windows.Forms.TextBox
    Friend WithEvents CleanedPrivateMailBoxLabel As System.Windows.Forms.Label
    Friend WithEvents CleanedUrbanizationNameLabel As System.Windows.Forms.Label
    Friend WithEvents CleanedZipCodeTypeTextBox As System.Windows.Forms.TextBox
    Friend WithEvents CleanedAddressTypeTextBox As System.Windows.Forms.TextBox
    Friend WithEvents CleanedZipCodeTypeLabel As System.Windows.Forms.Label
    Friend WithEvents CleanedAddressTypeLabel As System.Windows.Forms.Label
    Friend WithEvents CleanedAddressErrorTextBox As System.Windows.Forms.TextBox
    Friend WithEvents CleanedAddressStatusTextBox As System.Windows.Forms.TextBox
    Friend WithEvents CleanedCarrierTextBox As System.Windows.Forms.TextBox
    Friend WithEvents CleanedDeliveryPointTextBox As System.Windows.Forms.TextBox
    Friend WithEvents CleanedCarrierLabel As System.Windows.Forms.Label
    Friend WithEvents CleanedDeliveryPointLabel As System.Windows.Forms.Label
    Friend WithEvents CleanedAddressErrorLabel As System.Windows.Forms.Label
    Friend WithEvents CleanedAddressStatusLabel As System.Windows.Forms.Label
    Friend WithEvents CleanedCountryTextBox As System.Windows.Forms.TextBox
    Friend WithEvents CleanedCountryLabel As System.Windows.Forms.Label
    Friend WithEvents CleanedZip4TextBox As System.Windows.Forms.TextBox
    Friend WithEvents CleanedZip5TextBox As System.Windows.Forms.TextBox
    Friend WithEvents CleanedStateTextBox As System.Windows.Forms.TextBox
    Friend WithEvents CleanedCityTextBox As System.Windows.Forms.TextBox
    Friend WithEvents CleanedZip4Label As System.Windows.Forms.Label
    Friend WithEvents CleanedZip5Label As System.Windows.Forms.Label
    Friend WithEvents CleanedStateLabel As System.Windows.Forms.Label
    Friend WithEvents CleanedCityLabel As System.Windows.Forms.Label
    Friend WithEvents CleanedStreetLine2TextBox As System.Windows.Forms.TextBox
    Friend WithEvents CleanedStreetLine1TextBox As System.Windows.Forms.TextBox
    Friend WithEvents CleanedStreetLine1Label As System.Windows.Forms.Label
    Friend WithEvents GeoCodeTabPage As System.Windows.Forms.TabPage
    Friend WithEvents GeoCodeStatTextBox As System.Windows.Forms.TextBox
    Friend WithEvents GeoCodeStatLabel As System.Windows.Forms.Label
    Friend WithEvents CensusTractTextBox As System.Windows.Forms.TextBox
    Friend WithEvents CensusBlockTextBox As System.Windows.Forms.TextBox
    Friend WithEvents CensusTractLabel As System.Windows.Forms.Label
    Friend WithEvents CensusBlockLabel As System.Windows.Forms.Label
    Friend WithEvents CoreBasedStatisticalGroupBox As System.Windows.Forms.GroupBox
    Friend WithEvents CBSADivisionTitleTextBox As System.Windows.Forms.TextBox
    Friend WithEvents CBSADivisionTitleLabel As System.Windows.Forms.Label
    Friend WithEvents CBSADivisionLevelTextBox As System.Windows.Forms.TextBox
    Friend WithEvents CBSADivisionLevelLabel As System.Windows.Forms.Label
    Friend WithEvents CBSADivisionCodeTextBox As System.Windows.Forms.TextBox
    Friend WithEvents CBSADivisionCodeLabel As System.Windows.Forms.Label
    Friend WithEvents CBSATitleTextBox As System.Windows.Forms.TextBox
    Friend WithEvents CBSATitleLabel As System.Windows.Forms.Label
    Friend WithEvents CBSALevelTextBox As System.Windows.Forms.TextBox
    Friend WithEvents CBSALevelLabel As System.Windows.Forms.Label
    Friend WithEvents CBSACodeTextBox As System.Windows.Forms.TextBox
    Friend WithEvents CBSACodeLabel As System.Windows.Forms.Label
    Friend WithEvents TimeZoneCodeTextBox As System.Windows.Forms.TextBox
    Friend WithEvents TimeZoneNameTextBox As System.Windows.Forms.TextBox
    Friend WithEvents TimeZoneCodeLabel As System.Windows.Forms.Label
    Friend WithEvents TimeZoneNameLabel As System.Windows.Forms.Label
    Friend WithEvents PlaceCodeTextBox As System.Windows.Forms.TextBox
    Friend WithEvents PlaceNameTextBox As System.Windows.Forms.TextBox
    Friend WithEvents PlaceCodeLabel As System.Windows.Forms.Label
    Friend WithEvents PlaceNameLabel As System.Windows.Forms.Label
    Friend WithEvents LongitudeTextBox As System.Windows.Forms.TextBox
    Friend WithEvents LatitudeTextBox As System.Windows.Forms.TextBox
    Friend WithEvents LongitudeLabel As System.Windows.Forms.Label
    Friend WithEvents LatitudeLabel As System.Windows.Forms.Label
    Friend WithEvents CountyFIPSTextBox As System.Windows.Forms.TextBox
    Friend WithEvents CountyNameTextBox As System.Windows.Forms.TextBox
    Friend WithEvents CountyFIPSLabel As System.Windows.Forms.Label
    Friend WithEvents CountyNameLabel As System.Windows.Forms.Label
    Friend WithEvents PopulateGeoCodingCheckBox As System.Windows.Forms.CheckBox
    Friend WithEvents ClearAddressButton As System.Windows.Forms.Button
    Friend WithEvents CleanAddressButton As System.Windows.Forms.Button

End Class
