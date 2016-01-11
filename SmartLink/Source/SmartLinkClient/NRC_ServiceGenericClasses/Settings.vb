'********************************************************************'
' Created by Elibad - 12/01/2007
'
'  This class provides support to read and write settings to an XML file
'  It also provides compatibility to the config files created by visual studio
'*********************************************************************

Namespace Miscellaneous
    Public Class Settings
        Private _sFileName As String
        Private _Doc As Xml.XmlDocument
        Private _bHasChanges As Boolean = False

        ''' <summary>
        ''' FullPath for the Settings File
        ''' </summary>
        Public Property FileName() As String
            Get
                Return _sFileName
            End Get
            Set(ByVal value As String)
                Dim sFileName2 As String = System.IO.Path.GetDirectoryName(value) + "\" _
                    + System.Security.Principal.WindowsIdentity.GetCurrent().Name.Replace("\"c, ".") _
                    + "." + System.IO.Path.GetFileName(value)

                _Doc = New Xml.XmlDocument()

                If System.IO.File.Exists(sFileName2) Then
                    _sFileName = sFileName2
                Else
                    _sFileName = value
                End If

                If System.IO.File.Exists(_sFileName) Then
                    _Doc.Load(_sFileName)
                Else
                    Dim NewElement As Xml.XmlElement
                    NewElement = _Doc.CreateElement("NRC_Setting")

                    _Doc.AppendChild(NewElement)
                End If
            End Set
        End Property

        ''' <summary>
        ''' If the user has modify any setting after the last save will return true
        ''' </summary>
        Public ReadOnly Property HasChanges() As Boolean
            Get
                Return _bHasChanges
            End Get
        End Property

        Public Sub Refresh()
            'Force a reload of the XML file
            Me.FileName = Me.FileName
        End Sub

        ''' <summary>
        ''' Sets the value of a setting
        ''' </summary>
        ''' <param name="Name">Name of the setting to write</param>
        ''' <param name="Value">Value to write</param>
        Public Sub SetSetting(ByVal Name As String, ByVal Value As String)
            Dim CurrentSetting As Xml.XmlElement

            CurrentSetting = CType(_Doc.SelectSingleNode("//setting[@name='" & Name & "']//value"), Xml.XmlElement)

            If Not CurrentSetting Is Nothing Then
                CurrentSetting.InnerText = Value
            Else
                Dim NewSetting As Xml.XmlElement
                Dim NewValue As Xml.XmlElement

                NewSetting = _Doc.CreateElement("setting")
                NewSetting.SetAttribute("name", Name)
                NewSetting.SetAttribute("serializeAs", "String")

                NewValue = _Doc.CreateElement("value")
                NewValue.InnerText = Value

                NewSetting.AppendChild(NewValue)

                CurrentSetting = CType(_Doc.SelectSingleNode("//setting"), Xml.XmlElement)

                If CurrentSetting Is Nothing Then
                    _Doc.DocumentElement.AppendChild(NewSetting)
                Else
                    CurrentSetting.ParentNode.AppendChild(NewSetting)
                End If

            End If

            _bHasChanges = True
        End Sub

        ''' <summary>
        ''' Retrieves the setting value
        ''' </summary>
        ''' <param name="Name">Name of the setting to read</param>
        ''' <param name="DefaultValue">Default value for setting. If the default value is used this value will be available going forward. The default value will need to be passed the first time the setting is read</param>
        Public Function GetSetting(ByVal Name As String, ByVal DefaultValue As String) As String
            Dim CurrentSetting As Xml.XmlElement

            CurrentSetting = CType(_Doc.SelectSingleNode("//setting[@name='" & Name & "']//value"), Xml.XmlElement)

            If Not CurrentSetting Is Nothing Then
                Return CurrentSetting.InnerText
            Else
                If DefaultValue Is Nothing Then DefaultValue = ""

                SetSetting(Name, DefaultValue)
                Return DefaultValue
            End If
        End Function

        Public Function GetSetting(ByVal Name As String) As String
            Return GetSetting(Name, "")
        End Function

        ''' <summary>
        ''' Sets the value of a setting
        ''' </summary>
        ''' <param name="Name">Name of the setting to write</param>
        ''' <param name="Value">Value to write</param>
        Public Sub SetArraySetting(ByVal Name As String, ByVal Value() As String)
            Dim CurrentSetting As Xml.XmlElement
            Dim NewSetting As Xml.XmlElement
            Dim FirstSetting As Xml.XmlElement

            CurrentSetting = CType(_Doc.SelectSingleNode("//setting[@name='" & Name & "']"), Xml.XmlElement)

            If CurrentSetting Is Nothing Then
                NewSetting = _Doc.CreateElement("setting")
                NewSetting.SetAttribute("name", Name)
                NewSetting.SetAttribute("serializeAs", "String()")
            Else
                CurrentSetting.InnerText = ""
                NewSetting = CurrentSetting
            End If

            Dim NewValue As Xml.XmlElement

            For Each sValue As String In Value
                NewValue = _Doc.CreateElement("value")
                NewValue.InnerText = sValue

                NewSetting.AppendChild(NewValue)
            Next

            FirstSetting = CType(_Doc.SelectSingleNode("//setting"), Xml.XmlElement)

            If FirstSetting Is Nothing Then
                _Doc.DocumentElement.AppendChild(NewSetting)
            Else
                FirstSetting.ParentNode.AppendChild(NewSetting)
            End If

            _bHasChanges = True
        End Sub

        ''' <summary>
        ''' Retrieves the setting value
        ''' </summary>
        ''' <param name="Name">Name of the setting to read</param>
        ''' <param name="DefaultValue">Default value for setting</param>
        Public Function GetArraySetting(ByVal Name As String, ByVal DefaultValue() As String) As String()
            Dim CurrentSetting As Xml.XmlNodeList
            Dim sResult(0) As String

            CurrentSetting = _Doc.SelectNodes("//setting[@name='" & Name & "']//value")

            If Not CurrentSetting Is Nothing Then
                Dim iCont As Integer = 0
                Array.Resize(sResult, CurrentSetting.Count)

                For Each Setting As Xml.XmlNode In CurrentSetting
                    sResult(iCont) = Setting.InnerText
                    iCont += 1
                Next
            Else
                Array.Resize(sResult, 0)
            End If

            Return sResult
        End Function

        Public Function GetArraySetting(ByVal Name As String) As String()
            Return GetArraySetting(Name, Nothing)
        End Function

        Public Function GetInternalArraySetting(ByVal Name As String, ByVal InternalName As String, ByVal DefaultValue As String) As String

            Dim strInternalValues() As String = Me.GetArraySetting(Name)

            Return Settings.GetInternalArraySettings(InternalName, strInternalValues, DefaultValue)

            'Dim strRetVal As String

            'For Each strValue As String In strInternalValues
            '    If strValue.Contains(InternalName) And strValue.Contains(":") Then
            '        strRetVal = strValue.Substring(strValue.IndexOf(":"c) + 1).Trim()
            '        If strRetVal <> "" Then
            '            Return strRetVal
            '        End If
            '    End If
            'Next

            'Return DefaultValue

        End Function

        Public Function GetInternalArraySetting(ByVal Name As String, ByVal InternalName As String) As String
            Return GetInternalArraySetting(Name, InternalName, Nothing)
        End Function

        Public Shared Function GetInternalArraySettings(ByVal Internalname As String, ByVal InternalArray() As String, ByVal DefaultValue As String) As String

            Dim strRetVal As String

            For Each strValue As String In InternalArray
                If strValue.Contains(Internalname) And strValue.Contains(":") Then
                    strRetVal = strValue.Substring(strValue.IndexOf(":"c) + 1).Trim()
                    If strRetVal <> "" Then
                        Return strRetVal
                    End If
                End If
            Next

            Return DefaultValue

        End Function

        ''' <summary>
        ''' Gets the XML string representation of the settings.
        ''' </summary>
        ''' <returns></returns>
        Public Function GetXmlString() As String
            Return _Doc.OuterXml
        End Function


        Public Shared Function GetInternalArraySettings(ByVal Internalname As String, ByVal InternalArray() As String) As String
            Return GetInternalArraySettings(Internalname, InternalArray, Nothing)
        End Function

        ''' <summary>
        ''' Get Dictionary Values of type string
        ''' </summary>
        Public Function GetDateDictionarySettings(ByVal Name As String, Optional ByVal DefaultValues As Dictionary(Of String, Date) = Nothing) As Dictionary(Of String, Date)

            Dim StringsDictionary As Dictionary(Of String, String)
            Dim DatesDictionary As New Dictionary(Of String, Date)
            Dim DateValue As Date
            Dim StringDefaultValues As Dictionary(Of String, String)

            If Not DefaultValues Is Nothing Then
                ' Send Default Values
                StringDefaultValues = New Dictionary(Of String, String)
                For Each DateEntry As KeyValuePair(Of String, Date) In DefaultValues
                    ' Add this Item
                    StringDefaultValues.Add(DateEntry.Key, DateEntry.Value.ToString("yyyy/MM/dd HH:mm:ss.ffff"))
                Next
            Else
                StringDefaultValues = Nothing
            End If

            ' Get our Settings
            StringsDictionary = GetDictionarySettings(Name, StringDefaultValues)

            ' Add each Entry
            For Each Entry As KeyValuePair(Of String, String) In StringsDictionary
                ' Add this Item
                DateValue = Date.MinValue
                Date.TryParse(Entry.Value, DateValue)
                DatesDictionary.Add(Entry.Key, DateValue)
            Next

            ' Done
            Return DatesDictionary

        End Function

        ''' <summary>
        ''' Get Dictionary Values of type string
        ''' </summary>
        Public Function GetDictionarySettings(ByVal Name As String, Optional ByVal DefaultValues As Dictionary(Of String, String) = Nothing) As Dictionary(Of String, String)

            Dim Result As New Dictionary(Of String, String)
            Dim CurrentSetting As Xml.XmlElement
            Dim InternalName As String
            Dim Value As String
            Dim Item As Xml.XmlNode
            Dim AttrName As Xml.XmlNode

            CurrentSetting = CType(_Doc.SelectSingleNode("//setting[@name='" & Name & "']"), Xml.XmlElement)
            ' Check if we have our XML Element
            If Not CurrentSetting Is Nothing Then
                ' Get our Values
                For Each Item In CurrentSetting.ChildNodes
                    ' Check if this Node is Valid
                    If Item.InnerXml <> String.Empty Then
                        ' Get our Name
                        If Not Item.Attributes Is Nothing Then
                            AttrName = Item.Attributes("name")
                        Else
                            AttrName = Nothing
                        End If
                        ' Check if this is our Name Attribute
                        If Not AttrName Is Nothing Then
                            InternalName = AttrName.Value
                        Else
                            InternalName = "Unknown"
                        End If
                        ' Get our Value
                        Value = Item.InnerText
                        ' Add this Item to our Dictionary if it does not already Exist
                        If Not Result.ContainsKey(InternalName) Then
                            ' Add this Item
                            Result.Add(InternalName, Value)
                        Else
                            ' Update our Item with a new Value
                            Result(InternalName) = Value
                        End If
                    End If
                Next
            End If

            ' Check if we need to add any Internal Names
            If Not DefaultValues Is Nothing Then
                For Each Entry As KeyValuePair(Of String, String) In DefaultValues
                    ' Check if this Entry needs to be added
                    If Not Result.ContainsKey(Entry.Key) Then
                        ' Add this Item
                        Result.Add(Entry.Key, Entry.Value)
                    End If
                Next
            End If

            ' Done
            Return Result

        End Function

        ''' <summary>
        ''' Saves Dictionary Values as a collection of Values using the Key as the 'name' attribute.
        ''' </summary>
        ''' <param name="Name">The Parent Node Name</param>
        ''' <param name="Values">Value Pairs</param>
        ''' <remarks>The 'Name' attribute will not be included if the Key = 'Unknown'.</remarks>
        Public Sub SetDictionarySettings(ByVal Name As String, ByVal Values As Dictionary(Of String, Date))

            Dim strDict As New Dictionary(Of String, String)

            For Each item As KeyValuePair(Of String, Date) In Values
                strDict.Add(item.Key, item.Value.ToString("yyyy/MM/dd HH:mm:ss.ffff"))
            Next

            Call SetDictionarySettings(Name, strDict)

        End Sub

        ''' <summary>
        ''' Saves Dictionary Values as a collection of Values using the Key as the 'name' attribute.
        ''' </summary>
        ''' <param name="Name">The Parent Node Name</param>
        ''' <param name="Values">Value Pairs</param>
        ''' <remarks>The 'Name' attribute will not be included if the Key = 'Unknown'.</remarks>
        Public Sub SetDictionarySettings(ByVal Name As String, ByVal Values As Dictionary(Of String, String))

            Dim CurrentSetting As Xml.XmlElement
            Dim NewSetting As Xml.XmlElement
            Dim FirstSetting As Xml.XmlElement
            Dim AttName As Xml.XmlAttribute

            CurrentSetting = CType(_Doc.SelectSingleNode("//setting[@name='" & Name & "']"), Xml.XmlElement)

            If CurrentSetting Is Nothing Then
                NewSetting = _Doc.CreateElement("setting")
                NewSetting.SetAttribute("name", Name)
                NewSetting.SetAttribute("serializeAs", "Dictionary(Of String, String)")
            Else
                CurrentSetting.InnerText = ""
                NewSetting = CurrentSetting
            End If

            Dim NewValue As Xml.XmlElement

            For Each Value As KeyValuePair(Of String, String) In Values
                NewValue = _Doc.CreateElement("value")
                ' Check if our Attribute is not "Unknown"
                If Value.Key.ToUpper().Trim() <> "UNKNOWN" Then
                    AttName = _Doc.CreateAttribute("name")
                    AttName.Value = Value.Key
                    NewValue.Attributes.Append(AttName)
                End If
                NewValue.InnerText = Value.Value

                NewSetting.AppendChild(NewValue)
            Next

            ' Get our First Setting Node if available
            FirstSetting = CType(_Doc.SelectSingleNode("//setting"), Xml.XmlElement)

            If FirstSetting Is Nothing Then
                _Doc.DocumentElement.AppendChild(NewSetting)
            Else
                FirstSetting.ParentNode.AppendChild(NewSetting)
            End If

            _bHasChanges = True

        End Sub

        ''' <summary>
        ''' Saves all the settings into the settings file
        ''' </summary>
        Public Sub Save()
            If Me.FileName <> String.Empty Then
                Try
                    _Doc.Save(Me.FileName)
                Catch ex As Exception
                    Throw New System.Exception("The filename provided is not a valid path: " & ex.Message)
                End Try

                _bHasChanges = False
            Else
                Throw New System.Exception("The Config file has not been defined. Can't save the settings without the filename")
            End If
        End Sub

        Public Sub New(ByVal FileName As String)
            If Not Security.ValidateKey Then
                Throw New System.Exception("Not valid Security Key, Please provide a valid Security Key using the security class")
            End If
            Me.FileName = FileName
        End Sub
    End Class

End Namespace

