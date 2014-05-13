Imports Nrc.Framework.BusinessLogic.Configuration
Imports Nrc.Framework.AddressCleaning

Public Class MainForm

#Region " Private Members "

    Private mCountryID As CountryIDs
    Private mLoadDB As LoadDatabases

#End Region

#Region " Constructors "

    Public Sub New()

        'This call is required by the Windows Form Designer.
        InitializeComponent()

        'Populate the country list box
        Dim list As New List(Of ListItem(Of CountryIDs))
        list.Add(New ListItem(Of CountryIDs)("United States of America", CountryIDs.US))
        list.Add(New ListItem(Of CountryIDs)("Canada", CountryIDs.Canada))
        With CountryComboBox
            .DisplayMember = "Label"
            .ValueMember = "Value"
            .DataSource = list
        End With

        'Populate the Database list box
        Dim dbList As New List(Of ListItem(Of LoadDatabases))
        dbList.Add(New ListItem(Of LoadDatabases)("QLoader (QP_Load)", LoadDatabases.QPLoad))
        dbList.Add(New ListItem(Of LoadDatabases)("Pervasive (QP_DataLoad)", LoadDatabases.QPDataLoad))
        With DatabaseComboBox
            .DisplayMember = "Label"
            .ValueMember = "Value"
            .DataSource = dbList
        End With

    End Sub

#End Region

#Region " Form Events "

    Private Sub CountryComboBox_SelectedIndexChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles CountryComboBox.SelectedIndexChanged

        With CountryComboBox
            'Check to see if anything is selected
            If .SelectedIndex < 0 Then Exit Sub

            'Get the selected country
            mCountryID = CType(.SelectedValue, CountryIDs)

            'Clear the screen
            ClearName()
            ClearAddress()
            ClearFile()

            'Setup the labels
            Select Case mCountryID
                Case CountryIDs.US
                    OriginalStateLabel.Text = "State:"
                    OriginalZip5Label.Text = "Zip5:"
                    WorkingStateLabel.Text = "State:"
                    WorkingZip5Label.Text = "Zip5:"
                    CleanedStateLabel.Text = "State:"
                    CleanedZip5Label.Text = "Zip5:"

                Case CountryIDs.Canada
                    OriginalStateLabel.Text = "Province:"
                    OriginalZip5Label.Text = "Postal:"
                    WorkingStateLabel.Text = "Province:"
                    WorkingZip5Label.Text = "Postal:"
                    CleanedStateLabel.Text = "Province:"
                    CleanedZip5Label.Text = "Postal:"

            End Select
        End With

    End Sub

    Private Sub DatabaseComboBox_SelectedIndexChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles DatabaseComboBox.SelectedIndexChanged

        With DatabaseComboBox
            'Check to see if anything is selected
            If .SelectedIndex < 0 Then Exit Sub

            'Get the selected database
            mLoadDB = CType(.SelectedValue, LoadDatabases)
        End With

    End Sub

    Private Sub ClearNameButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ClearNameButton.Click

        ClearName()

    End Sub

    Private Sub CleanNameButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles CleanNameButton.Click

        'Create the cleaner object
        Dim clean As Cleaner = New Cleaner(mCountryID, mLoadDB)

        'Add the name
        Dim item As Name = Nrc.Framework.AddressCleaning.Name.NewName
        With item.OriginalName
            .Title = OriginalTitleTextBox.Text
            .FirstName = OriginalFirstNameTextBox.Text
            .MiddleInitial = OriginalMiddleInitialTextBox.Text
            .LastName = OriginalLastNameTextBox.Text
            .Suffix = OriginalSuffixTextBox.Text
        End With
        clean.Names.Add(item)

        'Clean the name
        clean.Names.Clean(True, ForceProxyCheckBox.Checked)

        'Load the working name
        With item.WorkingName
            WorkingTitleTextBox.Text = .Title
            WorkingFirstNameTextBox.Text = .FirstName
            WorkingMiddleInitialTextBox.Text = .MiddleInitial
            WorkingLastNameTextBox.Text = .LastName
            WorkingSuffixTextBox.Text = .Suffix
            WorkingNameStatusTextBox.Text = .NameStatus
        End With

        'Load the cleaned name
        With item.CleanedName
            CleanedTitleTextBox.Text = .Title
            CleanedFirstNameTextBox.Text = .FirstName
            CleanedMiddleInitialTextBox.Text = .MiddleInitial
            CleanedLastNameTextBox.Text = .LastName
            CleanedSuffixTextBox.Text = .Suffix
            CleanedNameStatusTextBox.Text = .NameStatus
        End With

        'Set the current tab to the cleaned tab
        NameCleaningTabControl.SelectTab("CleanedNameTabPage")

        'Cleanup
        clean = Nothing

    End Sub

    Private Sub ClearAddressButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ClearAddressButton.Click

        ClearAddress()

    End Sub

    Private Sub CleanAddressButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles CleanAddressButton.Click

        'Create the cleaner object
        Dim clean As Cleaner = New Cleaner(mCountryID, mLoadDB)

        'Add the Address
        Dim item As Address = Address.NewAddress
        With item.OriginalAddress
            .StreetLine1 = OriginalStreetLine1TextBox.Text
            .StreetLine2 = OriginalStreetLine2TextBox.Text
            .City = OriginalCityTextBox.Text
            .Country = OriginalCountryTextBox.Text
            Select Case mCountryID
                Case CountryIDs.US
                    .State = OriginalStateTextBox.Text
                    .Zip5 = OriginalZip5TextBox.Text
                    .Zip4 = OriginalZip4TextBox.Text
                    .Province = String.Empty
                    .Postal = String.Empty

                Case CountryIDs.Canada
                    .State = String.Empty
                    .Zip5 = String.Empty
                    .Zip4 = String.Empty
                    .Province = OriginalStateTextBox.Text
                    .Postal = OriginalZip5TextBox.Text

            End Select
        End With
        clean.Addresses.Add(item)

        'Clean the address
        clean.Addresses.Clean(ForceProxyCheckBox.Checked, PopulateGeoCodingCheckBox.Checked)

        'Load the working address
        With item.WorkingAddress
            WorkingStreetLine1TextBox.Text = .StreetLine1
            WorkingStreetLine2TextBox.Text = .StreetLine2
            WorkingCityTextBox.Text = .City
            Select Case mCountryID
                Case CountryIDs.US
                    WorkingStateTextBox.Text = .State

                Case CountryIDs.Canada
                    WorkingStateTextBox.Text = .Province

            End Select
            WorkingCountryTextBox.Text = .Country
            Select Case mCountryID
                Case CountryIDs.US
                    WorkingZip5TextBox.Text = .Zip5

                Case CountryIDs.Canada
                    WorkingZip5TextBox.Text = .Postal

            End Select
            WorkingZip4TextBox.Text = .Zip4
            WorkingDeliveryPointTextBox.Text = .DeliveryPoint
            WorkingCarrierTextBox.Text = .Carrier
            WorkingAddressTypeTextBox.Text = .AddressType.ToString
            WorkingZipCodeTypeTextBox.Text = .ZipCodeType.ToString
            WorkingUrbanizationNameTextBox.Text = .UrbanizationName
            WorkingPrivateMailBoxTextBox.Text = .PrivateMailBox
            WorkingAddressErrorTextBox.Text = .AddressError
            WorkingAddressStatusTextBox.Text = .AddressStatus
        End With

        'Load the cleaned address
        With item.CleanedAddress
            CleanedStreetLine1TextBox.Text = .StreetLine1
            CleanedStreetLine2TextBox.Text = .StreetLine2
            CleanedCityTextBox.Text = .City
            Select Case mCountryID
                Case CountryIDs.US
                    CleanedStateTextBox.Text = .State

                Case CountryIDs.Canada
                    CleanedStateTextBox.Text = .Province

            End Select
            CleanedCountryTextBox.Text = .Country
            Select Case mCountryID
                Case CountryIDs.US
                    CleanedZip5TextBox.Text = .Zip5

                Case CountryIDs.Canada
                    CleanedZip5TextBox.Text = .Postal

            End Select
            CleanedZip4TextBox.Text = .Zip4
            CleanedDeliveryPointTextBox.Text = .DeliveryPoint
            CleanedCarrierTextBox.Text = .Carrier
            CleanedAddressTypeTextBox.Text = .AddressType.ToString
            CleanedZipCodeTypeTextBox.Text = .ZipCodeType.ToString
            CleanedUrbanizationNameTextBox.Text = .UrbanizationName
            CleanedPrivateMailBoxTextBox.Text = .PrivateMailBox
            CleanedAddressErrorTextBox.Text = .AddressError
            CleanedAddressStatusTextBox.Text = .AddressStatus
        End With

        'Load the GeoCoding data
        With item.GeoCode
            LatitudeTextBox.Text = .Latitude
            LongitudeTextBox.Text = .Longitude
            CountyNameTextBox.Text = .CountyName
            CountyFIPSTextBox.Text = .CountyFIPS
            PlaceNameTextBox.Text = .PlaceName
            PlaceCodeTextBox.Text = .PlaceCode
            CensusBlockTextBox.Text = .CensusBlock
            CensusTractTextBox.Text = .CensusTract
            TimeZoneNameTextBox.Text = .TimeZoneName
            TimeZoneCodeTextBox.Text = .TimeZoneCode
            CBSACodeTextBox.Text = .CBSACode
            CBSALevelTextBox.Text = .CBSALevel
            CBSATitleTextBox.Text = .CBSATitle
            CBSADivisionCodeTextBox.Text = .CBSADivisionCode
            CBSADivisionLevelTextBox.Text = .CBSADivisionLevel
            CBSADivisionTitleTextBox.Text = .CBSADivisionTitle
            GeoCodeStatTextBox.Text = .GeoCodeStatus
        End With

        'Set the current tab to the cleaned tab
        AddressCleaningTabControl.SelectTab("CleanedAddressTabPage")

        'Cleanup
        clean = Nothing

    End Sub

    Private Sub ClearFileButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ClearFileButton.Click

        ClearFile()

    End Sub

    Private Sub CleanFileButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles CleanFileButton.Click

        Const msgFormat As String = "{2}{0}{3}{0}{4}{0}{5}{0}{6}{0}{7}{1}"

        'Set the wait cursor
        Cursor = Cursors.WaitCursor
        Enabled = False

        'Add the headers to the message
        Dim message As String = String.Format(msgFormat, vbTab, vbCrLf, "GrpName", "GrpType", "Updated", "Errors", "Remain", "Total")

        'Create the cleaner object
        Dim clean As Cleaner = New Cleaner(mCountryID, mLoadDB)

        'Clean the specified file
        Dim metaGroups As MetaGroupCollection = clean.CleanAll(CInt(FileIDTextBox.Text), CInt(StudyIDTextBox.Text), CInt(BatchSizeTextBox.Text), ForceProxyCheckBox.Checked)

        'Add the MetaGroup's statistics to the message
        For Each metaGroup As MetaGroup In metaGroups
            With metaGroup
                message &= String.Format(msgFormat, vbTab, vbCrLf, .GroupName, .GroupType, .QtyUpdated, .QtyErrors, .QtyRemaining, .QtyTotal)
            End With
        Next

        'Show the results
        MessageBox.Show(message, "Clean Results", MessageBoxButtons.OK)

        'Cleanup
        clean = Nothing

        'Reset the wait cursor
        Enabled = True
        Cursor = Cursors.Default

    End Sub

#End Region

#Region " Public Methods "

#End Region

#Region " Private Methods "

    Private Sub ClearName()

        OriginalTitleTextBox.Text = String.Empty
        OriginalFirstNameTextBox.Text = String.Empty
        OriginalMiddleInitialTextBox.Text = String.Empty
        OriginalLastNameTextBox.Text = String.Empty
        OriginalSuffixTextBox.Text = String.Empty

        WorkingTitleTextBox.Text = String.Empty
        WorkingFirstNameTextBox.Text = String.Empty
        WorkingMiddleInitialTextBox.Text = String.Empty
        WorkingLastNameTextBox.Text = String.Empty
        WorkingSuffixTextBox.Text = String.Empty
        WorkingNameStatusTextBox.Text = String.Empty

        CleanedTitleTextBox.Text = String.Empty
        CleanedFirstNameTextBox.Text = String.Empty
        CleanedMiddleInitialTextBox.Text = String.Empty
        CleanedLastNameTextBox.Text = String.Empty
        CleanedSuffixTextBox.Text = String.Empty
        CleanedNameStatusTextBox.Text = String.Empty

        'Set the current tab to the original tab
        NameCleaningTabControl.SelectTab("OriginalNameTabPage")

    End Sub

    Private Sub ClearAddress()

        OriginalStreetLine1TextBox.Text = String.Empty
        OriginalStreetLine2TextBox.Text = String.Empty
        OriginalCityTextBox.Text = String.Empty
        OriginalStateTextBox.Text = String.Empty
        OriginalCountryTextBox.Text = String.Empty
        OriginalZip5TextBox.Text = String.Empty
        OriginalZip4TextBox.Text = String.Empty

        WorkingStreetLine1TextBox.Text = String.Empty
        WorkingStreetLine2TextBox.Text = String.Empty
        WorkingCityTextBox.Text = String.Empty
        WorkingStateTextBox.Text = String.Empty
        WorkingCountryTextBox.Text = String.Empty
        WorkingZip5TextBox.Text = String.Empty
        WorkingZip4TextBox.Text = String.Empty
        WorkingDeliveryPointTextBox.Text = String.Empty
        WorkingCarrierTextBox.Text = String.Empty
        WorkingAddressTypeTextBox.Text = String.Empty
        WorkingZipCodeTypeTextBox.Text = String.Empty
        WorkingUrbanizationNameTextBox.Text = String.Empty
        WorkingPrivateMailBoxTextBox.Text = String.Empty
        WorkingAddressErrorTextBox.Text = String.Empty
        WorkingAddressStatusTextBox.Text = String.Empty

        CleanedStreetLine1TextBox.Text = String.Empty
        CleanedStreetLine2TextBox.Text = String.Empty
        CleanedCityTextBox.Text = String.Empty
        CleanedStateTextBox.Text = String.Empty
        CleanedCountryTextBox.Text = String.Empty
        CleanedZip5TextBox.Text = String.Empty
        CleanedZip4TextBox.Text = String.Empty
        CleanedDeliveryPointTextBox.Text = String.Empty
        CleanedCarrierTextBox.Text = String.Empty
        CleanedAddressTypeTextBox.Text = String.Empty
        CleanedZipCodeTypeTextBox.Text = String.Empty
        CleanedUrbanizationNameTextBox.Text = String.Empty
        CleanedPrivateMailBoxTextBox.Text = String.Empty
        CleanedAddressErrorTextBox.Text = String.Empty
        CleanedAddressStatusTextBox.Text = String.Empty

        LatitudeTextBox.Text = String.Empty
        LongitudeTextBox.Text = String.Empty
        CountyNameTextBox.Text = String.Empty
        CountyFIPSTextBox.Text = String.Empty
        PlaceNameTextBox.Text = String.Empty
        PlaceCodeTextBox.Text = String.Empty
        CensusBlockTextBox.Text = String.Empty
        CensusTractTextBox.Text = String.Empty
        TimeZoneNameTextBox.Text = String.Empty
        TimeZoneCodeTextBox.Text = String.Empty
        CBSACodeTextBox.Text = String.Empty
        CBSALevelTextBox.Text = String.Empty
        CBSATitleTextBox.Text = String.Empty
        CBSADivisionCodeTextBox.Text = String.Empty
        CBSADivisionLevelTextBox.Text = String.Empty
        CBSADivisionTitleTextBox.Text = String.Empty
        GeoCodeStatTextBox.Text = String.Empty

        'Set the current tab to the original tab
        AddressCleaningTabControl.SelectTab("OriginalAddressTabPage")

    End Sub

    Private Sub ClearFile()

        FileIDTextBox.Text = String.Empty
        StudyIDTextBox.Text = String.Empty
        BatchSizeTextBox.Text = String.Empty

    End Sub

#End Region

End Class
