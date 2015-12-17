'********************************************************************'
' Created by Elibad - 12/01/2007
'
'  This class provides support to read and write settings to an XML file
'  It also provides compatibility to the config files created by visual studio
'*********************************************************************

Imports ServiceBase = System.ServiceProcess.ServiceBase

Public Class Settings

    Public Const TRANSFER_SVC_NAME As String = "NRC SmartLink Transfer"
    Public Const AUTOUPDATE_SVC_NAME As String = "NRC SmartLink Auto Updater"

    Protected Friend Const PATHS_FILE_NAME As String = "SL_Paths.xml"
    Protected Friend Const SETTINGS_FILE_NAME As String = "SL_Settings.xml"
    Protected Friend Const CERNERINTERFACE_FILE_NAME As String = "CernerInterface_QueryStatus.xml"

    Public Enum SettingCategory
        ServiceManager
        ExtractorService
        TransferService
    End Enum

    ''' <summary>
    ''' Global "static" field used to cache the settings file xml DOM.
    ''' </summary>
    ''' <remarks></remarks>
    Private Shared _xmlConfig As System.Xml.Linq.XDocument = Nothing

    ''' <summary>
    ''' Global "static" field used to track the date and time of 
    ''' the most recent in-memory settings cache refresh.
    ''' </summary>
    ''' <remarks></remarks>
    Private Shared _settingsCacheLastRefreshed As Nullable(Of DateTime) = Nothing

    Private Shared _currentServiceName As String = Nothing

    Public Shared Property CurrentServiceName() As String
        Get
            Return _currentServiceName
        End Get
        Set(ByVal value As String)
            _currentServiceName = value
        End Set
    End Property

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="configBackupPath"></param>
    ''' <param name="configPath"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Shared Function RestoreAndMergeConfiguration(ByVal configBackupPath As String, ByVal configPath As String) As Boolean

        If String.IsNullOrEmpty(configBackupPath) OrElse _
            Not My.Computer.FileSystem.DirectoryExists(configBackupPath) Then
            Throw New ArgumentException("The config backup directory path is invalid!  [Path=" _
                                        & Convert.ToString(configBackupPath) & "]", "configBackupPath")
        End If

        If String.IsNullOrEmpty(configPath) OrElse _
            Not My.Computer.FileSystem.DirectoryExists(configPath) Then
            Throw New ArgumentException("The config directory path is invalid! [Path=" _
                                        & Convert.ToString(configPath) & "]", "configPath")
        End If

        ' We have a backup of the original configuration directory!  Let's merge it 
        ' with new files/settings appropriately and then restore it to its ultimate destination.

        ' First, merge any new config settings from the new files into the applicable backup files
        MergeNewSettingsIntoBackupFiles(SETTINGS_FILE_NAME, configBackupPath, configPath)

        ' Finally, copy the entire/updated backup directory structure back into the 
        ' final destination config folder OVERWRITING any existing files - which 
        ' ultimately results in "preserving" all original files (from the backup folder).
        ' NOTE: Any new files or folders will remain as we are merely putting backup files
        ' and folders back were they belong (effectively "on top" of the new folder structure).
        My.Computer.FileSystem.CopyDirectory(configBackupPath, configPath, True)

        ' After successful backup restore, delete the backup directory.
        My.Computer.FileSystem.DeleteDirectory(configBackupPath, FileIO.DeleteDirectoryOption.DeleteAllContents)
    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="fileName"></param>
    ''' <param name="backupDirPath"></param>
    ''' <param name="newFileDirPath"></param>
    ''' <remarks></remarks>
    Private Shared Sub MergeNewSettingsIntoBackupFiles(ByVal fileName As String, ByVal backupDirPath As String, ByVal newFileDirPath As String)

        Try
            If String.IsNullOrEmpty(fileName) Then
                Throw New ArgumentException("The file name is invalid! [fileName=" & Convert.ToString(fileName) & "]", "fileName")
            End If

            If String.IsNullOrEmpty(backupDirPath) OrElse _
                Not My.Computer.FileSystem.DirectoryExists(backupDirPath) Then
                Throw New ArgumentException("The backup file directory path is invalid! [Path=" & Convert.ToString(backupDirPath) & "]", "backupDirPath")
            End If

            If String.IsNullOrEmpty(newFileDirPath) OrElse _
                Not My.Computer.FileSystem.DirectoryExists(newFileDirPath) Then
                Throw New ArgumentException("The new file directory path is invalid! [Path=" & Convert.ToString(newFileDirPath) & "]", "newFileDirPath")
            End If

            Dim newFilePath As String = Path.Combine(newFileDirPath, fileName)
            Dim backupFilePath As String = Path.Combine(backupDirPath, fileName)

            Dim xmlBackupDoc As System.Xml.Linq.XDocument = System.Xml.Linq.XDocument.Load(backupFilePath)
            Dim xmlNewDoc As System.Xml.Linq.XDocument = System.Xml.Linq.XDocument.Load(newFilePath)

            'SL_Settings.xml DOM
            '<SmartLink>
            '  <ServiceManager>
            '    <Settings>
            '       ...
            '    </Settings>
            '  </ServiceManager>
            '  <ExtractorService>
            '    <Settings>
            '       ...
            '    </Settings>
            '  </ExtractorService>
            '  <TransferService>
            '    <Settings>
            '       ...
            '    </Settings>
            '  </TransferService>
            '</SmartLink>

            Dim xmlNew As System.Xml.Linq.XElement = xmlNewDoc.Element("SmartLink")
            Dim xmlOrig As System.Xml.Linq.XElement = xmlBackupDoc.Element("SmartLink")

            If xmlNew IsNot Nothing Then
                If xmlNew.HasElements Then
                    ' Define a flag to determine if we have done any work.
                    Dim elementWasAdded As Boolean = False

                    ' Iterate through the new file's setting categorys (i.e. "ServiceManager") and 
                    ' "Settings" descendant elements and add each to the backup file if missing.

                    ' Loop through the new file's Settings Category elements
                    ' <ServiceManage>, <TrasferService>, etc.
                    For Each xCategory As XElement In xmlNew.Elements()
                        ' If the original file has the category...
                        If xmlOrig.Element(xCategory.Name) IsNot Nothing Then
                            ' Get the new category's Settings element.
                            Dim xNewCategorySettings As XElement = xCategory.Element("Settings")
                            If xNewCategorySettings Is Nothing Then
                                ' New file's setting category doesn't have a "Settings" node.
                                ' TODO: Error? Write to log?  Do nothing?
                            Else
                                ' Get the orig category's Settings element.
                                Dim xOrigCategorySettings As XElement = _
                                    xmlOrig.Element(xCategory.Name).Element("Settings")
                                If xOrigCategorySettings Is Nothing Then
                                    ' Original file's setting category doesn't have a "Settings" node.
                                    ' TODO: Error? Write to log?  Do nothing?
                                Else
                                    ' ...loop through each new setting and add new ones to the original's settings.
                                    For Each xNewSetting As XElement In xNewCategorySettings.Elements
                                        ' If the new setting is not in the original settings...
                                        If xOrigCategorySettings.Element(xNewSetting.Name) Is Nothing Then
                                            ' ...add it!
                                            xOrigCategorySettings.Add(xNewSetting)
                                            elementWasAdded = True
                                        End If
                                    Next

                                    ' TODO: Determine if you would rather just leave unused settings nodes 
                                    ' on the client machine build to build OR if you actually want to delete them
                                    ' from the config settings file. UNCOMMENT the code below if you want to delete
                                    ' them.

                                    '' ...loop through each original setting to determine if it was removed
                                    '' from the new settings (i.e. in a new release the setting is no longer needed).
                                    'For Each xOrigSetting As XElement In xOrigCategorySettings.Elements
                                    '    ' If the new setting is not in the original settings...
                                    '    If xNewCategorySettings.Element(xOrigSetting.Name) Is Nothing Then
                                    '        ' ...remove it!
                                    '        xOrigSetting.Remove()
                                    '        'elementWasAdded = True ' element was removed but same usage here.
                                    '    End If
                                    'Next
                                End If
                            End If
                        Else
                            ' ...otherwise, just add the new category and all root nodes.
                            ' The new file has a new settings category (i.e. a new application was added)
                            xmlOrig.Add(xCategory)
                            elementWasAdded = True
                        End If
                    Next

                    If elementWasAdded Then
                        xmlBackupDoc.Save(backupFilePath)
                    End If
                End If
            End If
        Catch ex As Exception
            ' TODO: Log this exception to the EventLog or trace logs.
            ' Don't bubble up so future calls for other files can be attempted. (i.e. maybe only one file is problematic)
        End Try
    End Sub

    Private Shared Sub ReplaceBackupFileWithNewVersion(ByVal fileName As String, ByVal backupDirPath As String, ByVal newFileDirPath As String)
        Try
            If String.IsNullOrEmpty(fileName) Then
                Throw New ArgumentException("The file name is invalid! [fileName=" & Convert.ToString(fileName) & "]", "fileName")
            End If

            If String.IsNullOrEmpty(backupDirPath) OrElse _
                Not My.Computer.FileSystem.DirectoryExists(backupDirPath) Then
                Throw New ArgumentException("The backup file directory path is invalid! [Path=" & Convert.ToString(backupDirPath) & "]", "backupDirPath")
            End If

            If String.IsNullOrEmpty(newFileDirPath) OrElse _
                Not My.Computer.FileSystem.DirectoryExists(newFileDirPath) Then
                Throw New ArgumentException("The new file directory path is invalid! [Path=" & Convert.ToString(newFileDirPath) & "]", "newFileDirPath")
            End If

            Dim newFilePath As String = Path.Combine(newFileDirPath, fileName)
            Dim backupFilePath As String = Path.Combine(backupDirPath, fileName)

            If Not My.Computer.FileSystem.FileExists(newFilePath) Then
                ' The file we are copying from doesn't exist.  Should we error?
                ' We at least should log it to the EventLog or trace logs.
                ' TODO: Log informative "missing file" message for this operation.
            Else
                My.Computer.FileSystem.CopyFile(newFilePath, backupFilePath, True)
            End If
        Catch ex As Exception
            ' TODO: Log this exception to the EventLog or trace logs.
            ' Don't bubble up so future calls for other files can be attempted. (i.e. maybe only one file is problematic)
        End Try
    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="name"></param>
    ''' <returns>The general setting's value or String.Empty if the setting is not found.</returns>
    ''' <remarks></remarks>
    Public Shared Function GetGeneralSetting(ByVal name As String) As String
        Return GetGeneralSetting(name, String.Empty)
    End Function

    Public Shared Function GetGeneralSetting(ByVal name As String, ByVal defaultValue As String) As String
        ' General settings are stored in the ServiceManager element.
        Return GetSetting(name, defaultValue, SettingCategory.ServiceManager)
    End Function

    Public Shared Function GetGeneralSettings() As Hashtable
        Return GetSettings(SettingCategory.ServiceManager)
    End Function

    Public Shared Sub SetGeneralSetting(ByVal name As String, ByVal newValue As String)
        SetSetting(name, newValue, SettingCategory.ServiceManager)
    End Sub

    Public Shared Sub SetGeneralSettings(ByVal settings As Hashtable)
        SetSettings(settings, SettingCategory.ServiceManager)
    End Sub

    Public Shared Function GetTransferServiceSetting(ByVal name As String) As String
        Return GetTransferServiceSetting(name, String.Empty)
    End Function

    Public Shared Function GetTransferServiceSetting(ByVal name As String, ByVal defaultValue As String) As String
        Return GetSetting(name, defaultValue, SettingCategory.TransferService)
    End Function

    Public Shared Function GetTransferServiceSettings() As Hashtable
        Return GetSettings(SettingCategory.TransferService)
    End Function

    Public Shared Function GetTransferServicePollingFolders() As String()
        ' Make sure the "in memory" cached settings match the settings in the physical file.
        ' Has the file been modified since the last time we loaded it into memory?
        RefreshInMemoryConfigSettings()

        Dim folders As New List(Of String)

        ' Get the appropriate "Settings" child element node from the appropriate
        ' parent element node (i.e. <ServiceManager>, <ExtractorService>, <TransferService>)
        Dim xmlSettings As System.Xml.Linq.XElement = _
            GetSettingsXElementViaCategory(SettingCategory.TransferService)

        If xmlSettings IsNot Nothing Then
            ' Find the <PollingFolders> XElement node.
            Dim xmlPollingFolders As System.Xml.Linq.XElement = _
                xmlSettings.Descendants.FirstOrDefault(Function(x) x.Name.LocalName = "PollingFolders")

            If xmlPollingFolders Is Nothing Then
                'TODO: Log the fact that the SmartLink->TransferService-> "<PollingFolders>" node was not found.
            Else
                If xmlPollingFolders.HasElements() Then
                    ' Get the <Folder> elements.
                    Dim xmlFolders As List(Of System.Xml.Linq.XElement) = _
                        xmlPollingFolders.Descendants.Where(Function(x) x.Name.LocalName = "Folder").ToList()

                    ' Add each <Folder> value to the string collection we will be returning to the caller.
                    For Each xFolder As System.Xml.Linq.XElement In xmlFolders
                        If Not String.IsNullOrEmpty(xFolder.Value) Then
                            folders.Add(xFolder.Value.ToString())
                        End If
                    Next
                End If
            End If
        End If

        Return folders.ToArray()
    End Function

    ''' <summary>
    ''' Persist the specific transfer service setting to the general config file.
    ''' </summary>
    ''' <param name="name"></param>
    ''' <param name="newValue"></param>
    ''' <remarks></remarks>
    Public Shared Sub SetTransferServiceSetting(ByVal name As String, ByVal newValue As String)
        SetSetting(name, newValue, SettingCategory.TransferService)
    End Sub

    ''' <summary>
    ''' Persist the collection of transfer service settings to the general config file.
    ''' </summary>
    ''' <param name="settings"></param>
    ''' <remarks></remarks>
    Public Shared Sub SetTransferServiceSettings(ByVal settings As Hashtable)
        SetSettings(settings, SettingCategory.TransferService)
    End Sub

    Public Shared Sub SetTransferServicePollingFolders(ByVal folders As String())
        ' Make sure the "in memory" cached settings match the settings in the physical file.
        ' Has the file been modified since the last time we loaded it into memory?
        RefreshInMemoryConfigSettings()

        ' Get the appropriate "Settings" child element node from the appropriate
        ' parent element node (i.e. <ServiceManager>, <ExtractorService>, <TransferService>)
        Dim xmlSettings As System.Xml.Linq.XElement = _
            GetSettingsXElementViaCategory(SettingCategory.TransferService)

        If xmlSettings IsNot Nothing Then
            ' Find the <PollingFolders> XElement node.
            Dim xmlPollingFolders As System.Xml.Linq.XElement = _
                xmlSettings.Descendants.FirstOrDefault(Function(x) x.Name.LocalName = "PollingFolders")

            If xmlPollingFolders Is Nothing Then
                'TODO: Log the fact that the SmartLink->TransferService-> "<PollingFolders>" node was not found.
            Else
                ' Does the <PollingFolders> node have child nodes?
                If xmlPollingFolders.HasElements() Then
                    ' Clear the old child <Folder> elements!
                    xmlPollingFolders.RemoveNodes()
                End If

                ' Track what folder values we've already added (duplicate checking)
                Dim addedFolders As New List(Of String)

                For Each sFolderPath As String In folders
                    ' Don't add duplicates to the <Folder> node collection.
                    If Not addedFolders.Contains(sFolderPath) Then
                        xmlPollingFolders.Add(New System.Xml.Linq.XElement("Folder", sFolderPath))
                        addedFolders.Add(sFolderPath)
                    End If
                Next

                ' If no polling folders were added to the <PollingFolders> node 
                ' add a blank one for end-user reference.
                If Not xmlPollingFolders.HasElements() Then
                    xmlPollingFolders.Add(New System.Xml.Linq.XElement("Folder", ""))
                End If

                ' Preserve the new setting to the config file.
                _xmlConfig.Save(ConfigFileAbsolutePath)

                ' Update the global cache refresh datetime.
                _settingsCacheLastRefreshed = DateTime.Now
            End If
        End If
    End Sub

    Public Shared Function GetExtractorServiceSetting(ByVal name As String) As String
        Return GetExtractorServiceSetting(name, String.Empty)
    End Function

    Public Shared Function GetExtractorServiceSetting(ByVal name As String, ByVal defaultValue As String) As String
        Return GetSetting(name, defaultValue, SettingCategory.ExtractorService)
    End Function

    Public Shared Function GetExtractorServiceSettings() As Hashtable
        Return GetSettings(SettingCategory.ExtractorService)
    End Function

    ''' <summary>
    ''' Persists a specific extractor service setting to the general config file.
    ''' </summary>
    ''' <param name="name"></param>
    ''' <param name="newValue"></param>
    ''' <remarks></remarks>
    Public Shared Sub SetExtractorServiceSetting(ByVal name As String, ByVal newValue As String)
        SetSetting(name, newValue, SettingCategory.ExtractorService)
    End Sub

    ''' <summary>
    ''' Persist the collection of extractor service settings to the general config file.
    ''' </summary>
    ''' <param name="settings"></param>
    ''' <remarks></remarks>
    Public Shared Sub SetExtractorServiceSettings(ByVal settings As Hashtable)
        SetSettings(settings, SettingCategory.ExtractorService)
    End Sub

    Public Shared Function GetCernerInterfaceSetting(ByVal settingName As String) As String
        Return GetCernerInterfaceSetting(settingName, "")
    End Function

    Public Shared Function GetCernerInterfaceSetting(ByVal settingName As String, ByVal defaultValue As String) As String
        Dim settingValue As String = defaultValue

        Try
            Dim cernerInterfaceFilePath As String = _
                Settings.GetFilePath2CernerInterfaceQueryStatusFile()

            If My.Computer.FileSystem.FileExists(cernerInterfaceFilePath) Then
                Dim xmlDoc As XDocument = XDocument.Load(cernerInterfaceFilePath)

                If xmlDoc IsNot Nothing AndAlso xmlDoc.Descendants(settingName).Count > 0 Then
                    settingValue = xmlDoc.Descendants(settingName).First().Value
                End If
            End If
        Catch ex As Exception
            ' TODO: Handle and log this exception gracefully.
        End Try

        Return settingValue
    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="settingName"></param>
    ''' <param name="settingValue"></param>
    ''' <remarks></remarks>
    Public Shared Sub SetCernerInterfaceSetting(ByVal settingName As String, ByVal settingValue As String)
        CreateDefaultCernerInterfaceFile()

        Dim cernerInterfaceFilePath As String = _
            Settings.GetFilePath2CernerInterfaceQueryStatusFile()

        If My.Computer.FileSystem.FileExists(cernerInterfaceFilePath) Then
            Dim xmlCerner As XDocument = XDocument.Load(cernerInterfaceFilePath)
            If xmlCerner IsNot Nothing Then
                Dim xCernInt As XElement = xmlCerner.Element("CernerInterface")
                If xCernInt IsNot Nothing Then
                    If xCernInt.HasElements AndAlso xCernInt.Element(settingName) IsNot Nothing Then
                        xCernInt.Element(settingName).Value = settingValue
                    Else
                        Dim newElement As XElement = New XElement(settingName)
                        newElement.Value = settingValue
                        xCernInt.Add(newElement)
                    End If
                    xmlCerner.Save(cernerInterfaceFilePath)
                End If
            End If
        End If
    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <remarks></remarks>
    Private Shared Sub CreateDefaultCernerInterfaceFile()
        Dim cernerInterfaceFilePath As String = _
            Settings.GetFilePath2CernerInterfaceQueryStatusFile()

        If Not My.Computer.FileSystem.FileExists(cernerInterfaceFilePath) Then
            Dim xmlCerner As XElement = _
                <CernerInterface>
                    <PullHistoricalData>No</PullHistoricalData>
                    <LastSuccessfullRun></LastSuccessfullRun>
                </CernerInterface>

            Dim xmlDoc As XDocument = New XDocument()
            xmlDoc.Add(xmlCerner)
            Try
                xmlDoc.Save(cernerInterfaceFilePath)
            Catch ex As Exception
                ' TODO: Handle and log this exception gracefully.
            End Try
        End If
    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="name"></param>
    ''' <param name="defaultValue"></param>
    ''' <param name="settingCategory"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Private Shared Function GetSetting(ByVal name As String, ByVal defaultValue As String, ByVal settingCategory As SettingCategory) As String
        ' Make sure the "in memory" cached settings match the settings in the physical file.
        ' Has the file been modified since the last time we loaded it into memory?
        RefreshInMemoryConfigSettings()

        ' Get the appropriate "Settings" child element node from the appropriate
        ' parent element node (i.e. <ServiceManager>, <ExtractorService>, <TransferService>)
        Dim xmlSettings As System.Xml.Linq.XElement = _
            GetSettingsXElementViaCategory(settingCategory)

        If xmlSettings IsNot Nothing Then
            ' Find the setting element using the supplied "name" parameter.
            Dim xmlSet As System.Xml.Linq.XElement = _
                xmlSettings.Descendants.FirstOrDefault(Function(x) x.Name.LocalName = name)

            ' If the setting element exists and its value is 
            ' not null or String.Empty then return the value...
            If xmlSet IsNot Nothing AndAlso Not String.IsNullOrEmpty(xmlSet.Value) Then
                Return xmlSet.Value
            End If
        End If

        ' ...in all other cases, if we reach this 
        ' point, just return the default value.
        Return defaultValue
    End Function

    ''' <summary>
    ''' Gets all the settings from the config file applicable to the specified SettingCategory.
    ''' Supplied a default value of String.Empty if the setting doesn't have a value.
    ''' </summary>
    ''' <param name="settingCategory"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Private Shared Function GetSettings(ByVal settingCategory As SettingCategory) As Hashtable
        Dim theSettings As New Hashtable()

        RefreshInMemoryConfigSettings()

        ' Get the appropriate "Settings" child element node from the appropriate
        ' parent element node (i.e. <ServiceManager>, <ExtractorService>, <TransferService>)
        Dim xmlSettings As System.Xml.Linq.XElement = _
            GetSettingsXElementViaCategory(settingCategory)

        If xmlSettings IsNot Nothing Then
            For Each elem As System.Xml.Linq.XElement In xmlSettings.Descendants
                ' NOTE: We don't process collections here! (i.e. <PollingFolders><Folder></Folder><Folder></Folder></PollingFolders>) 
                ' they are a special case to be handled elsewhere.

                ' Make sure we are only dealing with elements that are direct descendants of 
                ' the Settings element (not children of children) and that are elements that don't
                ' have any child elements. (See NOTE: directly above) 
                If Not elem.HasElements AndAlso elem.Parent.Name.LocalName = "Settings" Then
                    ' If the settings hashtable does not already contain the key/value pair, add it!
                    If Not theSettings.ContainsKey(elem.Name.LocalName) Then
                        ' Set a default value of empty string for all settings.
                        Dim stringValue As String = String.Empty

                        ' If the setting element is not null then use its value, otherwise just use the empty string.
                        If elem.Value IsNot Nothing Then
                            stringValue = elem.Value
                        End If

                        ' Add it to the collection.
                        theSettings.Add(elem.Name.LocalName, stringValue)
                    End If
                End If
            Next
        End If

        ' Return the hashtable (populated with applicable settings) to the caller.
        Return theSettings
    End Function

    ''' <summary>
    ''' Returns an XElement instance representing the appropriate element node in 
    ''' the config settings file according to the supplied SettingCategory parameter.
    ''' </summary>
    ''' <param name="settingCategory"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Private Shared Function GetSettingCategoryXElement(ByVal settingCategory As SettingCategory) As System.Xml.Linq.XElement
        Dim xmlCategory As System.Xml.Linq.XElement = Nothing
        Dim elementName As String = String.Empty

        ' Get the applicable SettingCategory top-level element.
        Select Case settingCategory
            Case Settings.SettingCategory.ServiceManager
                elementName = "ServiceManager"
            Case Settings.SettingCategory.ExtractorService
                elementName = "ExtractorService"
            Case Settings.SettingCategory.TransferService
                elementName = "TransferService"
        End Select

        xmlCategory = _xmlConfig.Descendants.FirstOrDefault(Function(x) x.Name.LocalName = elementName)

        If xmlCategory Is Nothing Then
            ' TODO: Log the fact that the particular descendant element 
            ' specified in the Select Case above could not be found!

            ' Where to log?  EventLog?  TraceLog?  Both?
            ' Dim message As String = "The config settings file expected a " & elementName & " element node but it was not found."
        End If

        Return xmlCategory
    End Function

    Private Shared Function GetSettingsXElementViaCategory(ByVal settingCategory As SettingCategory) As System.Xml.Linq.XElement
        Dim xmlSettings As System.Xml.Linq.XElement = Nothing

        ' Get the appropriate "Parent" category element node (i.e. 
        ' ServiceManager, ExtractorService, TransferService)
        Dim xmlCategory As System.Xml.Linq.XElement = GetSettingCategoryXElement(settingCategory)

        If xmlCategory IsNot Nothing Then
            xmlSettings = xmlCategory.Descendants.FirstOrDefault(Function(x) x.Name.LocalName = "Settings")

            If xmlSettings Is Nothing Then
                ' TODO: Log the fact that the parent SettingCategory-level element
                ' does not contain a valid child "Settings" element node as expected.
                ' The element could not be found!

                ' Where to log?  EventLog?  TraceLog?  Both?
                ' Dim elementName As String = [Enum].GetName(GetType(SettingCategory), settingCategory)                ' 
                ' Dim message As String = "The config settings file expected the " & elementName & " element node to contain a valid child <Settings> element node but it was not found."
            End If
        End If

        Return xmlSettings
    End Function

    ''' <summary>
    ''' Loads or refreshes the config file's settings' values into memory.
    ''' </summary>
    ''' <remarks></remarks>
    Private Shared Sub RefreshInMemoryConfigSettings()
        Dim cfgAbsPath As String = ConfigFileAbsolutePath

        ' If the global field is null then this must be the first
        ' time we are loading the settings into memory...
        If _xmlConfig Is Nothing OrElse Not _settingsCacheLastRefreshed.HasValue Then
            _xmlConfig = System.Xml.Linq.XDocument.Load(cfgAbsPath)
            _settingsCacheLastRefreshed = DateTime.Now
        Else
            ' Otherwise, this must be a cache refresh request...

            ' Check if any changes to the physical settings file have occurred recently.
            Dim fileInfo As System.IO.FileInfo = _
                My.Computer.FileSystem.GetFileInfo(cfgAbsPath)

            ' If the file's last write datetime is greater/later than 
            ' the datetime we last refreshed the cache, do it now.
            If fileInfo.LastWriteTime > _settingsCacheLastRefreshed.Value Then
                _xmlConfig = System.Xml.Linq.XDocument.Load(cfgAbsPath)
                _settingsCacheLastRefreshed = DateTime.Now
            End If
        End If
    End Sub

    ''' <summary>
    ''' Sets the supplied value of the named setting in the appropriate
    ''' section of the config settings file.
    ''' </summary>
    ''' <param name="name">The name of the setting.</param>
    ''' <param name="newValue">The setting's value.</param>
    ''' <param name="settingCategory">The setting's category (i.e. which application it is applicable to)</param>
    ''' <remarks>If the setting doesn't already exist it will be created.</remarks>
    Private Shared Sub SetSetting(ByVal name As String, ByVal newValue As String, ByVal settingCategory As SettingCategory)

        ' Make sure the "in memory" cached settings match the settings in the physical file.
        ' Has the file been modified since the last time we loaded it into memory?
        RefreshInMemoryConfigSettings()

        ' Get the appropriate "Settings" child element node from the appropriate
        ' parent element node (i.e. <ServiceManager>, <ExtractorService>, <TransferService>)
        Dim xmlSettings As System.Xml.Linq.XElement = _
            GetSettingsXElementViaCategory(settingCategory)

        If xmlSettings IsNot Nothing Then
            ' Find the setting element using the supplied "name" parameter.
            Dim xmlSet As System.Xml.Linq.XElement = _
                xmlSettings.Descendants.FirstOrDefault(Function(x) x.Name.LocalName = name)

            ' If the setting element exists then update its value...
            If xmlSet IsNot Nothing Then
                xmlSet.Value = newValue
            Else
                ' ...otherwise, add the new setting node to the <Settings> node.
                xmlSettings.Add(New System.Xml.Linq.XElement(name, newValue))
            End If

            ' Preserve the new setting to the config file.
            _xmlConfig.Save(ConfigFileAbsolutePath)

            ' Update the global cache refresh datetime.
            _settingsCacheLastRefreshed = DateTime.Now
        End If
    End Sub

    ''' <summary>
    ''' Deletes/Removes a general setting from the in the application config file.
    ''' </summary>
    ''' <param name="name">The name of the setting to delete/remove.</param>
    ''' <remarks></remarks>
    Public Shared Sub DeleteGeneralSetting(ByVal name As String)
        DeleteSetting(name, SettingCategory.ServiceManager)
    End Sub

    ''' <summary>
    ''' Deletes/Removes an extractor service related setting from the in the application config file.
    ''' </summary>
    ''' <param name="name">The name of the setting to delete/remove.</param>
    ''' <remarks></remarks>
    Public Shared Sub DeleteExtractorServiceSetting(ByVal name As String)
        DeleteSetting(name, SettingCategory.ExtractorService)
    End Sub

    ''' <summary>
    ''' Deletes/Removes a transfer service related setting from the in the application config file.
    ''' </summary>
    ''' <param name="name">The name of the setting to delete/remove.</param>
    ''' <remarks></remarks>
    Public Shared Sub DeleteTransferServiceSetting(ByVal name As String)
        DeleteSetting(name, SettingCategory.TransferService)
    End Sub

    ''' <summary>
    ''' Deletes removes a setting from the application config file. The setting
    ''' is removed from its applicable setting category. 
    ''' </summary>
    ''' <param name="name">The name of the setting to delete/remove.</param>
    ''' <param name="settingCategory">The setting's applicable category.</param>
    ''' <remarks></remarks>
    Private Shared Sub DeleteSetting(ByVal name As String, ByVal settingCategory As SettingCategory)
        ' Make sure the "in memory" cached settings match the settings in the physical file.
        ' Has the file been modified since the last time we loaded it into memory?
        RefreshInMemoryConfigSettings()

        If Not String.IsNullOrEmpty(name) Then
            ' Get the appropriate "Settings" child element node from the appropriate
            ' parent element node (i.e. <ServiceManager>, <ExtractorService>, <TransferService>)
            Dim xmlSettings As System.Xml.Linq.XElement = _
                GetSettingsXElementViaCategory(settingCategory)

            If xmlSettings IsNot Nothing Then
                ' Find the setting element using the supplied "name" parameter.
                Dim xmlSet As System.Xml.Linq.XElement = _
                    xmlSettings.Descendants.FirstOrDefault(Function(x) x.Name.LocalName = name)

                ' If the setting element exists then remove it!
                If xmlSet IsNot Nothing Then
                    xmlSet.Remove()
                End If

                ' Preserve the new setting to the config file.
                _xmlConfig.Save(ConfigFileAbsolutePath)

                ' Update the global cache refresh datetime.
                _settingsCacheLastRefreshed = DateTime.Now
            End If
        End If
    End Sub

    ''' <summary>
    ''' Sets the supplied settings collection in their appropriate
    ''' section of the config settings file.
    ''' </summary>
    ''' <param name="theSettings">Hashtable collection of individual settings key/value pairs.</param>
    ''' <param name="settingCategory">The settings applicable category (i.e. which application they are applicable to)</param>
    ''' <remarks>If a particular setting doesn't already exist it will be created.</remarks>
    Private Shared Sub SetSettings(ByVal theSettings As Hashtable, ByVal settingCategory As SettingCategory)

        ' Make sure the "in memory" cached settings match the settings in the physical file.
        ' Has the file been modified since the last time we loaded it into memory?
        RefreshInMemoryConfigSettings()

        ' Check if the caller passed an initialized collection of settings.
        If theSettings Is Nothing Then
            ' TODO: Log this for debugging purposes.

            ' If the hashtable settings collection is empty here we shouldn't 
            ' necessarily throw an exception and error out but we do want to 
            ' be notified when it happens.
        Else
            ' Get the appropriate "Settings" child element node from the appropriate
            ' parent element node (i.e. <ServiceManager>, <ExtractorService>, <TransferService>)
            Dim xmlSettings As System.Xml.Linq.XElement = _
                GetSettingsXElementViaCategory(settingCategory)

            If xmlSettings IsNot Nothing Then
                Try
                    Dim settingName As String = String.Empty
                    Dim settingValue As String = String.Empty

                    ' Loop through the supplied settings collection instance and process each setting.
                    For Each entry As DictionaryEntry In theSettings

                        ' What setting are we adding/updating?
                        settingName = entry.Key.ToString()

                        ' What is the setting's existing/new value?
                        settingValue = entry.Value.ToString()

                        ' Find the setting...
                        Dim xmlSet As System.Xml.Linq.XElement = _
                            xmlSettings.Descendants.FirstOrDefault(Function(x) x.Name.LocalName = settingName)

                        ' If the setting element exists update its value...
                        If xmlSet IsNot Nothing Then
                            xmlSet.Value = settingValue
                        Else
                            ' ...otherwise, add the new setting node to the <Settings> node.
                            xmlSettings.Add(New System.Xml.Linq.XElement(settingName, settingValue))
                        End If
                    Next

                    ' Preserve the new setting to the config file.
                    _xmlConfig.Save(ConfigFileAbsolutePath)

                    ' Update the global cache refresh datetime.
                    _settingsCacheLastRefreshed = DateTime.Now

                Catch ex As Exception
                    ' TODO: Log this exception to the EventLog or trace logs.
                    ' Don't bubble up so future calls for other files can be attempted. (i.e. maybe only one file is problematic)
                End Try
            End If
        End If
    End Sub

    ' This function does a little magic to work out what the right log file is based on the current
    ' assembly
    Public Shared Function GetLogFilePath(Optional ByVal forService As String = Nothing) As String
        Dim fileDirPath As String = _
            Path.Combine(Settings.ConfigRootDirPath, "Logs\")

        If Not Directory.Exists(fileDirPath) Then
            Directory.CreateDirectory(fileDirPath)
        End If

        If forService Is Nothing Then
            forService = _currentServiceName
        End If

        Dim filePrefix As String
        If forService = TRANSFER_SVC_NAME Then
            filePrefix = "NRC_Transfer"
        ElseIf forService = AUTOUPDATE_SVC_NAME Then
            filePrefix = "NRC_Updater"
        Else
            filePrefix = "NRC"
        End If
        Return Path.Combine(fileDirPath, filePrefix + ".log")
    End Function

    ''' <summary>
    ''' Gets the absolute file path to the Transfer service's Submitted Files log.
    ''' </summary>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Shared Function GetFilePath2TransferServiceSubmittedFilesLogFile() As String
        Dim fileName As String = _
            Settings.GetTransferServiceSetting("EventLogFile", "SLT_SubmittedFiles.log")

        Dim fileDirPath As String = _
            Path.Combine(Settings.ConfigRootDirPath, "Logs\")

        If Not My.Computer.FileSystem.DirectoryExists(fileDirPath) Then
            My.Computer.FileSystem.CreateDirectory(fileDirPath)
        End If

        Return Path.Combine(fileDirPath, fileName)
    End Function

    ''' <summary>
    ''' Gets the absolute file path to the Cerner Interface Query Status file.
    ''' </summary>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Friend Shared Function GetFilePath2CernerInterfaceQueryStatusFile() As String
        Return Path.Combine(ConfigRootDirPath, CERNERINTERFACE_FILE_NAME)
    End Function

    ''' <summary>
    ''' Gets the SmartLink application "Updates" root folder path. The directory
    ''' will be created if it doesn't already exist.
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Shared ReadOnly Property ApplicationUpdatesRootDirPath() As String
        Get
            Dim thePath As String = Path.Combine(My.Application.Info.DirectoryPath, "Updates\")
            If Not My.Computer.FileSystem.DirectoryExists(thePath) Then
                My.Computer.FileSystem.CreateDirectory(thePath)
            End If
            Return thePath
        End Get
    End Property

    ''' <summary>
    ''' Returns either the user-defined custom config root directory path (found in SL_Paths.xml)
    ''' or the default config folder path in the application's root "[AppRoot]\Config"
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Shared ReadOnly Property ConfigRootDirPath() As String
        Get
            Dim cfgRootDirPath As String = String.Empty

            ' Find the root path config file!  We expect it to 
            ' be in the application's root execution directory.
            Dim pathFilePath As String = _
                Path.Combine(My.Application.Info.DirectoryPath, PATHS_FILE_NAME)

            If Not My.Computer.FileSystem.FileExists(pathFilePath) Then
                'Create the file and log the event to the eventlog and trace log
            End If

            ' Load the path config file.
            Dim xmlPaths As System.Xml.Linq.XDocument = _
                System.Xml.Linq.XDocument.Load(pathFilePath)

            ' Get the element that will contain a "Custom" root directory path (when applicable).
            Dim xmlCustomCfgRoot As System.Xml.Linq.XElement = _
                xmlPaths.Descendants.FirstOrDefault(Function(x) x.Name.LocalName = "CustomConfigRootDirPath")

            ' Return the non-default, custom config root dir path if one has 
            ' been declared and it physically exists on the machine.
            If xmlCustomCfgRoot IsNot Nothing AndAlso _
                Not String.IsNullOrEmpty(xmlCustomCfgRoot.Value) AndAlso _
                My.Computer.FileSystem.DirectoryExists(xmlCustomCfgRoot.Value) Then
                cfgRootDirPath = xmlCustomCfgRoot.Value
            Else
                ' ...otherwise, return the default config root path per the NRC.Mics project definition.
                cfgRootDirPath = Path.Combine(My.Application.Info.DirectoryPath, "Config")
                If Not My.Computer.FileSystem.DirectoryExists(cfgRootDirPath) Then
                    ' Create the folder if it is missing.
                    My.Computer.FileSystem.CreateDirectory(cfgRootDirPath)
                End If
            End If

            If cfgRootDirPath.Last() <> "\"c Then
                cfgRootDirPath &= "\"
            End If

            Return cfgRootDirPath
        End Get
    End Property

    ''' <summary>
    ''' Updates the root config directory path in the config settings and registry 
    ''' and if necessary moves all existing configuration files, logs, and subfolders
    ''' to the new location.
    ''' </summary>
    ''' <param name="newConfigDirPath"></param>
    ''' <remarks></remarks>
    Public Shared Sub MoveConfigRootDirAndContentsToNewLocation(ByVal newConfigDirPath As String)
        If Not My.Computer.FileSystem.DirectoryExists(newConfigDirPath) Then
            My.Computer.FileSystem.CreateDirectory(newConfigDirPath)
        End If

        ' TODO: Do we want to physically move the directory and its contents or make a copy to the new location?
        My.Computer.FileSystem.CopyDirectory(Settings.ConfigRootDirPath, newConfigDirPath)
        'My.Computer.FileSystem.MoveDirectory(Settings.ConfigRootDirPath, newConfigDirPath)

        Dim pathsFileNameFullPath As String = _
            Path.Combine(My.Application.Info.DirectoryPath, PATHS_FILE_NAME)
        Dim xmlPaths As XDocument = XDocument.Load(pathsFileNameFullPath)

        If xmlPaths IsNot Nothing Then
            Dim xmlConfigPath As XElement = _
                    xmlPaths.Descendants("CustomConfigRootDirPath").FirstOrDefault()

            If xmlConfigPath IsNot Nothing Then

                Dim smartLinkDefaultConfigRootPath As String = _
                    Path.Combine(My.Application.Info.DirectoryPath, "Config")

                ' If the new config directory is set to the default
                ' SmartLink config directory location then...
                If System.IO.Path.GetDirectoryName(newConfigDirPath) = smartLinkDefaultConfigRootPath Then
                    ' ...clear out the entry in the SL_Paths.xml file.
                    xmlConfigPath.Value = String.Empty
                Else
                    ' else, add the new value in the SL_Paths.xml file.
                    xmlConfigPath.Value = newConfigDirPath
                End If

                ' Update the registry with the value - (this value in the registry supports upgrades).
                UpdateConfigFolderDirInRegistry(newConfigDirPath)

                ' If success updating the registry, now save the setting to the SL_Paths.xml file.
                xmlPaths.Save(pathsFileNameFullPath)
            End If
        End If
    End Sub

    Private Const REGKEY_NAME As String = "SOFTWARE\NRC\SmartLink"
    Private Const APP_DIR_REGKEYVALUE_NAME As String = "AppDir"
    Private Const CONFIG_DIR_REGKEYVALUE_NAME As String = "ConfigFileDir"

    Private Shared Sub UpdateConfigFolderDirInRegistry(ByVal configRootDirPath As String)
        Try
            ' Developers, make sure the "HKEY_LOCAL_MACHINE\SOFTWARE\NRC\SmartLink"
            ' key exists on your machine. This key is added during the application install
            ' but you may need to add it manually if you have uninstalled the application
            ' and are trying call this method.

            ' Open the SmartLink registry key for read/write.
            Dim regKey As RegistryKey = Registry.LocalMachine.OpenSubKey(REGKEY_NAME, True)
            If regKey IsNot Nothing Then

                ' During upgrade (uninstall/reinstall) persist the previous/original
                ' config settings folder path to the registry for use after reinstall
                regKey.SetValue(CONFIG_DIR_REGKEYVALUE_NAME, configRootDirPath, RegistryValueKind.String)
                regKey.Close()

            End If
        Catch ex As Exception
            EventLog.WriteEntry("NRC SmartLink Service Manager", _
                                "The following exception occurred while attempting to update the config folder root directory location in the registry: " & ex.Message, _
                                EventLogEntryType.Error)
        End Try
    End Sub

    ''' <summary>
    ''' Returns the absolute path to the SmartLink application suite's main configuration file.
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Shared ReadOnly Property ConfigFileAbsolutePath() As String
        Get
            Dim cfgFileAbsPath As String = _
                Path.Combine(Settings.ConfigRootDirPath, SETTINGS_FILE_NAME)

            If Not My.Computer.FileSystem.FileExists(cfgFileAbsPath) Then
                CreateDefaultSettingsFile(cfgFileAbsPath)
            End If

            ' ValidateConfigSettingsFileIsWellFormed()

            ' TODO: The method commented out above should be implemented!  We always want 
            ' to ensure the SL_Settings.xml file is in the expected structure and 
            ' all required elements are present. For example, the code in the Settings 
            ' type expects the xml DOM to look like the following:
            ' <SmartLink>
            '   <ServiceManager>
            '       <Settings />
            '   </ServiceManager>
            '   <ExtractorService>
            '       <Settings />
            '   </ExtractorService>
            '   <TransferService>
            '       <Settings />
            '   </TransferService>
            ' </SmartLink>

            Return cfgFileAbsPath
        End Get
    End Property

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="value"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Shared Function ConvertToBool(ByVal value As String) As Boolean
        If String.IsNullOrEmpty(value) Then
            Return False
        Else
            Select Case value.ToUpper()
                Case "TRUE", "T", "YES", "Y", "1"
                    Return True
                Case "FALSE", "F", "NO", "N", "0"
                    Return False
                Case Else
                    Throw New ArgumentException("The supplied value cannot be converted to a boolean value.")
            End Select
        End If
    End Function

    ''' <summary>
    ''' Programmatically creates the config file (SL_Settings.xml).
    ''' Usefull if the file is deleted inadvertantly on a client's machine.
    ''' </summary>
    ''' <param name="fullFileNameAndPath"></param>
    ''' <remarks>This method is "Private" and is called only when calls to ConfigFileAbsolutePath reveal
    ''' that the file doesn't exist. ConfigFileAbsolutePath is called throughout 
    ''' this static class and thus the file will always be created if it is not found.</remarks>
    Private Shared Sub CreateDefaultSettingsFile(ByVal fullFileNameAndPath As String)

        ' Declare the default XML DOM for the config settings file.
        Dim xml As XElement =
            <SmartLink>
                <ServiceManager>
                    <Settings>
                        <TraceFlag>True</TraceFlag>
                        <SmartLinkWS>http://localhost:1619/SmartLinkWS.asmx</SmartLinkWS>
                        <ProxyUser></ProxyUser>
                        <ProxyPswrd></ProxyPswrd>
                        <ProxyDomain></ProxyDomain>
                        <ProxyPort></ProxyPort>
                        <ProxyIP></ProxyIP>
                        <ProxyEnabled>No</ProxyEnabled>
                        <SMTPServer></SMTPServer>
                        <OperatorEmail></OperatorEmail>
                        <InternetCheckURL>http://www.google.com</InternetCheckURL>
                        <InternetCheckIP>http://209.85.135.103/</InternetCheckIP>
                        <ProviderNumber></ProviderNumber>
                        <InstallKey></InstallKey>
                        <AgencyID></AgencyID>
                        <AutoDownloadAndInstallUpdates>False</AutoDownloadAndInstallUpdates>
                        <AutoUpdateInterval>Daily</AutoUpdateInterval>
                        <AutoUpdateIntervalModifier>1</AutoUpdateIntervalModifier>
                        <AutoUpdateTime>3:00 AM</AutoUpdateTime>
                        <AutoUpdateWeeklyDays></AutoUpdateWeeklyDays>
                        <AutoUpdateLastCheck></AutoUpdateLastCheck>
                        <AutoUpdateWriteTraceToEventLog>False</AutoUpdateWriteTraceToEventLog>
                        <InstalledSmartLinkVersion></InstalledSmartLinkVersion>
                    </Settings>
                </ServiceManager>
                <TransferService>
                    <Settings>
                        <IsActivated>False</IsActivated>
                        <TraceFlag>True</TraceFlag>
                        <AppName>NRC SmartLink Transfer</AppName>
                        <AppKey>QmR3tgYp7wdf5aOd</AppKey>
                        <Path></Path>
                        <PollingFolder1></PollingFolder1>
                        <PollingFolder2></PollingFolder2>
                        <PollingIntervalInSeconds>10</PollingIntervalInSeconds>
                        <BackupDir></BackupDir>
                        <BackupFiles>No</BackupFiles>
                        <LogWSFiles>Yes</LogWSFiles>
                        <ErrorsDir>NOT USED CURRENTLY - HARDCODED</ErrorsDir>
                        <WorkDir>NOT USED CURRENTLY - HARDCODED</WorkDir>
                        <ErrorLogFile>SLT_Errors.log</ErrorLogFile>
                        <EventLogFile>SLT_SubmittedFiles.log</EventLogFile>
                        <FileNumber>139</FileNumber>
                        <ExcludeFileTypes>.exe;.dll;.htm;.html;.bat;.scr;.wsh;.wmf;.cpx;.lnk</ExcludeFileTypes>
                        <AllowFileRename>Yes</AllowFileRename>
                        <TransferDelayInterval>2</TransferDelayInterval>
                        <MaxInetAccessTries>4</MaxInetAccessTries>
                        <IntervalBetweenTries>15</IntervalBetweenTries>
                        <PauseBeforeFinalWSChk>60</PauseBeforeFinalWSChk>
                        <PollingFolders>
                            <Folder></Folder>
                            <Folder></Folder>
                            <Folder></Folder>
                            <Folder></Folder>
                        </PollingFolders>
                    </Settings>
                </TransferService>
            </SmartLink>

        ' Create an XDocument instance to hold and persist our XML to a file.
        Dim xDocSmartLink As New System.Xml.Linq.XDocument()

        ' Add the xml element DOM to the new XDocument instance.
        xDocSmartLink.Add(xml)

        ' Save the xml DOM to the file.
        xDocSmartLink.Save(fullFileNameAndPath)
    End Sub

End Class
