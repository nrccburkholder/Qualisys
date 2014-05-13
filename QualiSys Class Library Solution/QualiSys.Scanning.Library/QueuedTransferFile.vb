Imports System.IO
Imports Nrc.Framework.BusinessLogic.Configuration
Imports Nrc.Framework.Notification

Public Class QueuedTransferFile

#Region "Private Members"

    Private mVendor As Vendor
    Private mTranslator As TranslationModule
    Private mFile As FileInfo
    Private mOriginalFileName As String
    Private mFileLocation As TransferFileLocations

#End Region

#Region "Constructors"

    Public Sub New(ByVal vendor As Vendor, ByVal translator As TranslationModule, ByVal file As FileInfo)

        mVendor = vendor
        mTranslator = translator
        mFile = file
        mOriginalFileName = file.Name
        mFileLocation = TransferFileLocations.Original

    End Sub

#End Region

#Region "Public Properties"

    Public ReadOnly Property Vendor() As Vendor
        Get
            Return mVendor
        End Get
    End Property

    Public ReadOnly Property Translator() As TranslationModule
        Get
            Return mTranslator
        End Get
    End Property

    Public ReadOnly Property File() As FileInfo
        Get
            Return mFile
        End Get
    End Property

    Public ReadOnly Property OriginalFileName() As String
        Get
            Return mOriginalFileName
        End Get
    End Property

    Public ReadOnly Property FileLocation() As TransferFileLocations
        Get
            Return mFileLocation
        End Get
    End Property

#End Region

#Region "Public Methods"

    Public Sub MoveToInbound()

        'Move the file to the Inbound folder
        MoveTo(mTranslator.WatchedFolderPath, String.Empty, String.Empty)

        'Set the file location
        mFileLocation = TransferFileLocations.InBound

    End Sub

    Public Sub MoveToInProcess()

        Dim tempPath As String = Path.Combine(AppConfig.Params("QSITransferTempFolder").StringValue, Format(Now(), "yyyyMMdd HHmmssff"))

        'Move the file to the archive folder
        MoveTo(tempPath, String.Empty, String.Empty)

        'Set the file location
        mFileLocation = TransferFileLocations.InProcess

    End Sub

    Public Sub MoveToArchive(ByVal filePrefix As String)

        Dim tempPath As String = Path.Combine(AppConfig.Params("QSITransferArchiveFolder").StringValue, mVendor.VendorId.ToString)
        Dim origPath As String = mFile.DirectoryName
        Dim xmlFileName As String = mFile.Name.Replace(mFile.Extension, ".xml")

        'Move the file to the archive folder
        MoveTo(tempPath, origPath, filePrefix & "_")

        'Set the file location
        mFileLocation = TransferFileLocations.Archive

        'Move the corresponding Vovici XML data file if exists
        If IO.File.Exists(Path.Combine(mTranslator.WatchedFolderPath, xmlFileName)) Then
            IO.File.Move(Path.Combine(mTranslator.WatchedFolderPath, xmlFileName), Path.Combine(tempPath, filePrefix & xmlFileName))
        End If

    End Sub

    Public Function SendFileReceivedNotification() As String

        Dim toList As New List(Of String)
        Dim ccList As New List(Of String)
        Dim bccList As New List(Of String)
        Dim recipientNoteText As String = String.Empty
        Dim recipientNoteHtml As String = String.Empty
        Dim environmentName As String = String.Empty

        Try
            'Determine who the recipients are going to be
            For Each contact As VendorContact In mVendor.Contacts
                If contact.SendFileArrivalEmail Then
                    If Not String.IsNullOrEmpty(contact.emailAddr1) Then
                        toList.Add(contact.emailAddr1)
                    End If
                    If Not String.IsNullOrEmpty(contact.emailAddr2) Then
                        toList.Add(contact.emailAddr2)
                    End If
                End If
            Next
            ccList.Add("eDDFiles@NRCPicker.com")

            'Determine recipients bases on the environment
            If AppConfig.EnvironmentType <> EnvironmentTypes.Production Then
                'We are not in production
                'Add the real recipients to the note
                recipientNoteText = String.Format("{0}{0}Production To:{0}", vbCrLf)
                For Each email As String In toList
                    recipientNoteText &= email & vbCrLf
                Next
                recipientNoteText &= String.Format("{0}Production CC:{0}", vbCrLf)
                For Each email As String In ccList
                    recipientNoteText &= email & vbCrLf
                Next
                recipientNoteText &= String.Format("{0}Production BCC:{0}", vbCrLf)
                For Each email As String In bccList
                    recipientNoteText &= email & vbCrLf
                Next
                recipientNoteHtml = recipientNoteText.Replace(vbCrLf, "<BR>")

                'Clear the lists
                toList.Clear()
                ccList.Clear()
                bccList.Clear()

                'Populate the toList with the Testing group only
                toList.Add("Testing@NRCPicker.com")

                'Set the environment string
                environmentName = String.Format("({0})", AppConfig.EnvironmentName)
            End If

            'Create the message object
            Dim msg As Message = New Message("QSIFileMoverServiceFileReceived", AppConfig.SMTPServer)

            'Set the message properties
            With msg
                'To recipient
                For Each email As String In toList
                    .To.Add(email)
                Next

                'Cc recipient
                For Each email As String In ccList
                    .Cc.Add(email)
                Next

                'Bcc recipient
                For Each email As String In bccList
                    .Bcc.Add(email)
                Next

                'Add the replacement values
                With .ReplacementValues
                    .Add("Environment", environmentName)
                    .Add("VendorName", mVendor.VendorName)
                    .Add("DateOccurred", DateTime.Now.ToString)
                    .Add("FileName", mFile.Name)
                    .Add("FileSize", mFile.Length.ToString("#,0"))
                    .Add("FileDate", mFile.LastWriteTime.ToString)
                    .Add("RecipientNoteText", recipientNoteText)
                    .Add("RecipientNoteHtml", recipientNoteHtml)
                End With
            End With

            'Merge the template
            msg.MergeTemplate()

            'Get the body text
            Dim bodyText As String = msg.BodyText

            'Send the message
            msg.Send()

            'Return the body text
            Return bodyText

        Catch ex As Exception
            'Return this exception
            Return String.Format("Exception encountered while attempting to send FileReceived Email!{0}{0}{1}{0}{0}Source: {2}{0}{0}Stack Trace:{0}{3}", vbCrLf, ex.Message, ex.Source, ex.StackTrace)

        End Try

    End Function

#End Region

#Region "Private Methods"

    Private Sub MoveTo(ByVal newPath As String, ByVal oldPath As String, ByVal filePrefix As String)

        'Make sure the folder exists
        If Not Directory.Exists(newPath) Then
            Directory.CreateDirectory(newPath)
        End If

        'Move the file
        mFile.MoveTo(Path.Combine(newPath, filePrefix & mFile.Name))

        'Cleanup the old folder
        If mFileLocation = TransferFileLocations.InProcess Then
            If System.IO.File.Exists(Path.Combine(oldPath, "schema.ini")) Then
                System.IO.File.Delete(Path.Combine(oldPath, "schema.ini"))
            End If
            Directory.Delete(oldPath)
        End If

    End Sub

#End Region

End Class
