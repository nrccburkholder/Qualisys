Imports NRC.DataLoader.Library
Imports WebSupergoo.ABCUpload6
Imports NRC.NRCAuthLib
Imports NRC.Qualisys.QLoader.Library
Imports NRC.DataLoader.ParseBackSlashAndSpace
Imports NRC.DataLoader.DataTableSetup
Imports System.Data
Imports System.io
Imports System.Web.HttpServerUtility


Public Class _UploadFile
    Inherits System.Web.UI.Page

    Private Shared sLogPath As String = String.Empty
    Private Shared Upcols As List(Of UploadFile)

#Region "Public"

    ''' <summary>Retrieve the uploadfilecollection that has just been uploaded</summary>
    ''' <value></value>
    ''' <CreateBy>Brock Fleming</CreateBy>
    ''' <RevisionList>
    ''' <list type="table">
    ''' <listheader>
    ''' <term></term>
    ''' <description>Description</description>
    ''' </listheader>
    ''' <item>
    ''' <term></term>
    ''' <description></description>
    ''' </item>
    ''' <item>
    ''' <term></term>
    ''' <description></description>
    ''' </item>
    ''' </list>
    ''' </RevisionList>
    Public Shared ReadOnly Property UploadFileCol() As List(Of UploadFile)
        Get
            Return Upcols
        End Get
    End Property

    Public Shared WriteOnly Property LogItem()
        Set(ByVal value)
            writelog(value)
        End Set
    End Property



    ''' <summary>Add The Path as string to this property to log to text document</summary>
    ''' <value></value>
    ''' <CreateBy>Brock Fleming</CreateBy>
    ''' <RevisionList>
    ''' <list type="table">
    ''' <listheader>
    ''' <term></term>
    ''' <description>Description</description>
    ''' </listheader>
    ''' <item>
    ''' <term></term>
    ''' <description></description>
    ''' </item>
    ''' <item>
    ''' <term></term>
    ''' <description></description>
    ''' </item>
    ''' </list>
    ''' </RevisionList>
    Public Shared WriteOnly Property LogPath() As String
        Set(ByVal value As String)
            sLogPath = value
        End Set
    End Property

    Public Shared Function DoUpload(ByVal dt As DataTable, _
                                        ByVal UpCol As WebSupergoo.ABCUpload6.Upload) As List(Of UploadFile)
        Dim Verify As Boolean = UploadControler(dt, UpCol)
        Return Upcols
    End Function

#End Region

#Region "Private"

    Private Shared Sub writelog(ByVal txt As String)
        If sLogPath <> String.Empty Then
            Dim sWrite As StreamWriter = File.AppendText(sLogPath)
            sWrite.WriteLine(DateTime.Now.ToString & ": " & txt)
            sWrite.Close()
        End If
    End Sub

    Private Shared Function UploadControler(ByVal dt As DataTable, _
                                            ByVal UpCol As WebSupergoo.ABCUpload6.Upload) As Boolean
        Try
            Dim Upfilecol As UploadFileCollection = AddItemsToUploadFileCollection(dt)

            writelog("UploadControler")
            ' temporary logging
            For Each ul As UploadFile In Upfilecol

                writelog("UploadControler: UploadFile.")

            Next


            UploadFiles(Upfilecol, UpCol)
            Return True
        Catch ex As Exception
            writelog(ex.Message & "----" & ex.StackTrace)
            Return False
        End Try
    End Function

    Private Shared Function FindUploadFile(ByVal htmlFileUploadControlName As String, _
                                           ByVal MyUploads As UploadFileCollection) As UploadFile
        Dim upsfileIds As Integer = CInt(Right(htmlFileUploadControlName, _
                            Len(htmlFileUploadControlName) - htmlFileUploadControlName.LastIndexOf("_") - 1))
        For Each upload As UploadFile In MyUploads
            If upsfileIds = upload.ClientFileId.ToString Then
                Return upload
            End If
        Next
        Return Nothing
    End Function

    Private Shared Function UploadFiles(ByVal myUploads As UploadFileCollection, _
                                        ByVal Upload As WebSupergoo.ABCUpload6.Upload)
        Dim excreturn As String = String.Empty
        Dim NewUpCol As New List(Of UploadFile)

        writelog("UploadFiles")
        writelog("UploadFiles: Upload.Files.Count = " & Upload.Files.Count.ToString)

        For iCnt As Integer = 0 To Upload.Files.Count - 1
            Dim UploadedFile As UploadedFile
            UploadedFile = Upload.Files(iCnt)
            writelog("UploadFiles: UploadedFile.FileName = " & UploadedFile.FileName)
            Dim HtmlFileUploadControlName As String = Upload.Files.AllKeys(iCnt)
            writelog("UploadFiles: HtmlFileUploadControlName = " & HtmlFileUploadControlName)
            Dim tempUpload As UploadFile '= myUploads(iCnt)

            writelog("UploadFiles: FindUploadFile")
            tempUpload = FindUploadFile(HtmlFileUploadControlName, myUploads)



            If Not tempUpload Is Nothing Then
                Try
                    writelog("UploadFiles: tempUpload.OrigFileName = " & tempUpload.OrigFileName)
                    writelog("UploadFiles: tempUpload.FileName = " & tempUpload.FileName)

                    If tempUpload IsNot Nothing Then
                        tempUpload.UploadFileState.StateOfUpload = UploadState.GetByName(UploadState.AvailableStates.Uploading)
                        tempUpload.FileSize = UploadedFile.ContentLength

                        writelog("UploadFiles: tempUpload.FileSize = " & tempUpload.FileSize.ToString)

                        tempUpload.FileName = tempUpload.Id & "_" & UploadedFile.WinSafeFileName()

                        writelog("UploadFiles: tempUpload.FileName using UploadedFile.WinSafeFileName = " & tempUpload.FileName)

                        tempUpload.Save()
                        'TODO:  How do we update status.                                    
                        If UploadedFile.ContentLength <= 0 Then
                            tempUpload.UploadFileState.StateParameter = "Reached point where file size was 0 or less"
                            tempUpload.UploadFileState.StateOfUpload = UploadState.GetByName(UploadState.AvailableStates.UploadAbandoned)
                            tempUpload.Save()
                            tempUpload.FileStatusSaved = False

                            writelog("UploadFiles: tempUpload.UploadFileState.StateParameter = " & tempUpload.UploadFileState.StateParameter)

                            UploadFileEmailClass.makeemail(tempUpload, UploadNotificationMailType.UploadFailed)
                            tempUpload.FileNotificationHandled = True
                        Else
                            Dim FinalDirectory As String = System.IO.Path.Combine(Config.DataLoaderSaveFolder, tempUpload.UploadAction.FolderName)
                            If Not System.IO.Directory.Exists(FinalDirectory) Then System.IO.Directory.CreateDirectory(FinalDirectory)
                            UploadedFile.SaveAs(FinalDirectory & "\" & tempUpload.FileName)
                            tempUpload.UploadFileState.StateOfUpload = UploadState.GetByName(UploadState.AvailableStates.Uploaded)
                            tempUpload.Save()
                            tempUpload.FileStatusSaved = True

                            writelog("UploadFiles: tempUpload.UploadFileState.StateOfUpload = " & UploadState.AvailableStates.Uploaded)

                            UploadFileEmailClass.makeemail(tempUpload, UploadNotificationMailType.UploadSuccessful)
                            tempUpload.FileNotificationHandled = True
                            'TODO:  Remove from myUploads collection and add to session collection.
                        End If
                    End If
                Catch ex As Exception
                    writelog("UploadFiles: tempUpload.Exception encountered")
                    writelog("Before" & Config.EnvironmentName & ex.Message & vbCrLf & ex.StackTrace)
                    excreturn = ex.Message & vbCrLf & ex.StackTrace
                    tempUpload.UploadFileState.StateParameter = ex.Message & vbCrLf & ex.StackTrace
                    tempUpload.UploadFileState.StateOfUpload = UploadState.GetByName(UploadState.AvailableStates.UploadAbandoned)
                    tempUpload.Save()
                    tempUpload.FileStatusSaved = True

                    writelog("UploadFiles: tempUpload.UploadFileState.StateOfUpload = " & UploadState.AvailableStates.Uploaded)

                    UploadFileEmailClass.makeTeamemail(ex, tempUpload, UploadNotificationMailType.UploadFailed)
                    tempUpload.FileNotificationHandled = True
                End Try
                Library.UploadedFiles.UploadedFileCollection.AddToList(tempUpload)

                writelog("UploadFiles: tempUpload Added To UploadedFileCollection")

            End If
            NewUpCol.Add(tempUpload)
        Next
        Upcols = NewUpCol
        UploadFileEmailClass.makeclientsemail()
        Library.UploadedFiles.DisposeUploadFilesCollection()
        Return excreturn
    End Function

    Private Shared Function AddItemsToUploadFileCollection(ByVal dt As DataTable) As UploadFileCollection
        Dim uploads As UploadFileCollection = Nothing
        If uploads Is Nothing Then
            uploads = New UploadFileCollection
        End If
        For Each row As DataRow In dt.Rows
            Dim upload As UploadFile = UploadFile.NewUploadFile
            Dim currentFileID As Integer = CInt(row(UploadDataTable._UploadFileId))
            Dim fileName As String = row(UploadDataTable._ClientFilePath)
            'Dim fileName As String = (Right(Upfname, Len(Upfname) - Upfname.LastIndexOf("\") - 1))
            Dim notes As String = row(UploadDataTable._FileNotes)
            Dim fileTypeID As Integer = CInt(row(UploadDataTable._UploadFileTypeID))
            Dim uUpAction As UploadAction = UploadAction.Get(fileTypeID)
            Dim packageIDs As String()
            upload.ClientFileId = currentFileID
            upload.OrigFileName = fileName
            upload.UserNotes = notes
            upload.UploadAction = uUpAction
            upload.UploadFileState = UploadFileState.NewUploadFileState
            upload.GroupID = CurrentUser.SelectedGroup.GroupId
            upload.MemberId = CurrentUser.Member.MemberId
            If uUpAction.UploadFileTypeAction.Name = UploadFileTypeAction.AvailableActions.ProjectManagers Then
                upload.ProjectManager = ProjectManager.GetByMemberID(CInt(row(UploadDataTable._ProjectManagerID)))
            Else
                packageIDs = Split(row(UploadDataTable._Package), "|")
                If upload.UploadFilePackages Is Nothing Then upload.UploadFilePackages = New UploadFilePackageCollection()
                If upload.UploadAction.UploadFileTypeAction.Name = UploadFileTypeAction.AvailableActions.Packages Then
                    'Existing Code; Go thru list of packages and determine if they were selected; if so, add them to uploadfilepackages
                    For Each id As String In packageIDs
                        If id <> "" Then
                            Dim uploadPackage As UploadFilePackage = UploadFilePackage.NewUploadFilePackage
                            Dim dtsPackage As NRC.Qualisys.QLoader.Library.DTSPackage = _
                                              NRC.Qualisys.QLoader.Library.DTSPackage.GetPackageByID(id)
                            uploadPackage.Package = dtsPackage
                            upload.UploadFilePackages.Add(uploadPackage)
                        End If
                    Next
                End If
            End If
            Try
                upload.UploadFileState.StateOfUpload = UploadState.GetByName(UploadState.AvailableStates.UploadQueued)
                upload.Save()
            Catch ex As Exception
                writelog("File: " & upload.FileName & " encountered the following error:<br />" & ex.Message)
            End Try
            uploads.Add(upload)
        Next
        Return uploads
    End Function

#End Region

End Class
