Imports NRC.DataLoader.Library
Imports System.Text
Imports System.Net.Mail
Imports System.Collections.Generic
Imports WebSupergoo.ABCUpload6
Imports NRC.NRCAuthLib
Imports NRC.Qualisys.QLoader.Library
Imports NRC.Framework.Configuration
Imports NRC.DataLoader.ParseBackSlashAndSpace
Imports System.Reflection
Imports NRC.DataLoader.DataTableSetup
Imports System.io


Partial Public Class Upload
    Inherits DataLoader.WebErrorTrappingBaseClass
    Private studyIDs As List(Of Integer) = New List(Of Integer)

#Region "Constants"
    Public Const _MoreThanTen As String = "MoreThanTen"
    Public Const _AlreadyUsedPackage As String = "AlreadyUsedPackage"
    Public Const _NoPackageSelected As String = "NoPackSelected"
    Public Const _NoMSMSelected As String = "NoPmSelected"
    Public Const _SessionEnded As String = "LoggedOut"
    Public Const _selectedPackageUploadfileTypes As String = "1"
    Public Const _NofileTypeSelected As String = "NoFileTypeSelected"
    Public Const _UploadButtonsNoDisplay As String = "UploadButtonsNoDisplay"
    Public Const _UploadButtonsDisplay As String = "UploadButtonsDisplay"
    Public Const _MaxNumberOfUploads As Integer = 10
    Public Const _ListItemWrapLength As Integer = 40
    Public Const _Uploadfailed As String = "Upload Failed"
    Public Const _Uploadsucceded As String = "Upload Succeeded"

#End Region

#Region " Handlers"

    Private Sub page_load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
        If Not IsPostBack Then
            FillFileTypes()
            FillListwithPackages()
            FillListwithPMs()
            AddUploadControlToForm(1)
            uploadsgrid.Visible = False
            ASPxGridView1.Visible = False
            client.Text = CurrentUser.SelectedGroup.OrgUnit.Name
            Dim tb As DataTable = TryCast(Context.Session(DataTableSetup.ParentDataSetSessionName), DataTable)
            Dim tb1 As DataTable = TryCast(Context.Session(DataTableSetup.UploadedTableSession), DataTable)
            If Not tb Is Nothing And ASPxGridView1.Visible = False Then
                Context.Session.Remove(DataTableSetup.ParentDataSetSessionName)
                fgrid.Visible = False
                ScriptManager.RegisterStartupScript(Me, GetType(Page), _
                      "RemoveAll", BuildRemoveUploadControlAllJavaFunction, True)
            End If
            If Not tb1 Is Nothing And ASPxGridView1.Visible = False Then
                uploadsgrid.DataSource = tb1
                uploadsgrid.DataBind()
                GenericUploadsGridPLaceholder.Controls.Add(New LiteralControl("<div id='pnlFileInfoHeader' class='PanelTitle'>Uploads for this Session</div>"))
                uploadsgrid.Visible = True
                tb1.Dispose()
            End If
        Else
            Dim ArgString As String = Request("__EVENTARGUMENT")
            If Right(ArgString, 7) = "UpPanel" Then
                AddFileToQueue(ArgString)
            ElseIf ArgString.IndexOf("IBDC") > 0 Then
                RemoveItemFromdataSet(ArgString)
            ElseIf ArgString.IndexOf("ClearQ") > 0 Then
                Clearqueue()
            ElseIf ArgString.IndexOf("ClearFileOptions") > 0 Then
                ClearAll()
            ElseIf ArgString.IndexOf("UpAll") > -1 Then
                UploadAllFiles()
            Else
            End If
        End If
    End Sub

    Public Sub GridViewLoad(ByVal sender As Object, ByVal e As EventArgs)
        If ASPxGridView1.Visible = True Then
            ASPxGridView1.DataSource = NRC.DataLoader.UploadFileHistory.GetHistory(CurrentUser.SelectedGroup.GroupId)
            ASPxGridView1.DataBind()
        End If
    End Sub

    Private Sub FileGridFormatting(ByVal sender As Object, ByVal e As DataGridItemEventArgs) Handles fgrid.ItemDataBound
        If e.Item.ItemType <> ListItemType.Header And _
         e.Item.ItemType <> ListItemType.Footer Then
            CType(e.Item.Cells(4).FindControl("QueueNotes"), TextBox).Text = e.Item.Cells(6).Text.Replace("&nbsp;", "")
            Dim lb As New ImageButton
            lb.ImageUrl = "img/icon_trash.gif"
            lb.AlternateText = "Delete This Item"
            lb.OnClientClick = "Javascript:if(confirm('Delete this upload from the queue?')) {PostPanel(this.id);} else { return false; }"
            lb.BorderStyle = BorderStyle.None
            lb.ID = "IBDC_" & e.Item.Cells(0).Text
            e.Item.Cells(5).Text = ""
            e.Item.Cells(5).Controls.Add(lb)
            lb.Dispose()
            e.Item.Cells(1).Text = ParseBackSlashAndSpace.ParseText(e.Item.Cells(1).Text)
            e.Item.Cells(3).Text = e.Item.Cells(3).Text.Replace("|", "|<br />")
        End If
    End Sub

    Private Sub UploadedGridFormatting(ByVal sender As Object, ByVal e As DataGridItemEventArgs) Handles uploadsgrid.ItemDataBound
        If e.Item.ItemType <> ListItemType.Header And _
         e.Item.ItemType <> ListItemType.Footer Then
            If e.Item.Cells(3).Text = "UploadAbandoned" Then
                e.Item.Cells(3).Text = "<img align='left' src='img/icon_failure.png' alt='Upload Failed'> " & _
                _Uploadfailed
            Else
                e.Item.Cells(3).Text = "<img align='left' src='img/icon_accept.png' alt='Upload Succeeded'> " & _
                 _Uploadsucceded
            End If
        End If
    End Sub

    Public Sub ChangeTabs(ByVal sender As Object, ByVal e As DevExpress.Web.ASPxTabControl.TabControlEventArgs)
        If ASPxTabControl1.ActiveTab.Index = 0 Then
            MaindisplayDiv.Visible = True
            ASPxGridView1.Visible = False
            AddUploadControlToForm(CurrentFileUploadID.Text)
            If CheckLimitedAccessDisplay() = True Then disableDropEntries()
            Dim tb As DataTable = TryCast(Context.Session(DataTableSetup.ParentDataSetSessionName), DataTable)
            Dim tb1 As DataTable = TryCast(Context.Session(DataTableSetup.UploadedTableSession), DataTable)
            If Not tb Is Nothing Then
                ScriptManager.RegisterClientScriptBlock(Me, GetType(Page), "ReturnDisplay", _
                       "document.getElementById('UploadButtonDiv').style.display = 'block';", True)
            End If
            If Not tb1 Is Nothing Then
                ScriptManager.RegisterClientScriptBlock(Me, GetType(Page), "ReturnDisplay1", _
                       "document.getElementById('uploadDisplay').style.display = 'block';", True)
            End If
        Else
            ASPxGridView1.DataSource = NRC.DataLoader.UploadFileHistory.GetHistory(CurrentUser.SelectedGroup.GroupId)
            ASPxGridView1.DataBind()
            FileControls.Controls.Clear()
            MaindisplayDiv.Visible = False
            ASPxGridView1.Visible = True
            ScriptManager.RegisterClientScriptBlock(Me, GetType(Page), "ClearDisplay", _
                                   "document.getElementById('uploadDisplay').style.display = 'none';" & _
                                   "document.getElementById('UploadButtonDiv').style.display = 'none';", True)
        End If
    End Sub

#End Region

#Region " Partial Posts"

    Public Sub PackagePMDisplay(ByVal sender As Object, ByVal e As EventArgs)
        If Not CurrentUser.IsAuthenticated Then
            ClientScript.RegisterStartupScript(Me.GetType, "key", _
              "alert('You have been logged out due to inactivity');location.href = 'SignIn.aspx';", True)
        Else
            If SelectedFileType.SelectedItem.Value = "disabled" Then
                SelectedFileType.SelectedIndex = 0
                disableDropEntries()
                DisplayOfPackPM(False, False, False, False, True)
            ElseIf SelectedFileType.SelectedIndex <> "0" Then
                Dim uUpAction As UploadAction = UploadAction.Get(SelectedFileType.SelectedItem.Value)
                If uUpAction.UploadFileTypeAction.Name = UploadFileTypeAction.AvailableActions.Packages Then
                    DisplayOfPackPM(False, False, True, True, CheckLimitedAccessDisplay)
                ElseIf uUpAction.UploadFileTypeAction.Name = UploadFileTypeAction.AvailableActions.ProjectManagers Then
                    DisplayOfPackPM(True, True, False, False, False)
                    If CheckLimitedAccessDisplay() = True Then disableDropEntries()
                Else
                    DisplayOfPackPM(False, False, False, False, False)
                End If
            Else
                DisplayOfPackPM(False, False, False, False, False)
            End If
        End If
    End Sub

    Private Sub AddFileToQueue(ByVal ArgString As String)
        If Not CurrentUser.IsAuthenticated Then
            ClientScript.RegisterStartupScript(Me.GetType, "SessionEnded", _SessionEnded, True)
        Else
            Dim Cmem As Member = Member.GetMember(CurrentUser.Member.MemberId)
            Dim uploads As DataTable = TryCast(Context.Session.Item(ParentDataSetSessionName), DataTable)
            Dim PackOrPm As String = String.Empty
            Dim PMId As String = String.Empty
            Dim PackArray As String()
            Dim Upstring As String() = Split(Trim(ArgString), "|")
            Dim UpFileName As String = String.Empty
            Dim UpFileID As String = String.Empty
            Dim sameFilesamePackString As String = String.Empty
            Dim gridpackagestring As String = String.Empty
            Dim datatablepackageid As String = String.Empty
            Dim HasError As Boolean = False
            If UploadFileControlIdLabel.Text <> "" Then
                UpFileID = UploadFileControlIdLabel.Text
                UpFileName = UploadFileControlValueLabel.Text
            Else
                UpFileName = Upstring(0)
                UpFileID = Upstring(1)
            End If
            If uploads Is Nothing Then
                uploads = CreateDataTable()
            End If
            Dim upsfileIds As Integer = CInt(Right(UpFileID, _
                             Len(UpFileID) - UpFileID.LastIndexOf("_") - 1))
            If SelectedFileType.SelectedIndex = 0 Then
                ScriptManager.RegisterClientScriptBlock(Me, GetType(Page), "UploadFileError", _
                    ReturnErrors(_NofileTypeSelected), True)
                UploadErrorControlFill(UpFileID, UpFileName)
                fgridrebind(uploads)
                HasError = True
            End If
            If cbPackageList.Visible And Not HasError Then
                PackArray = GetPackagesFromUpload()
                If PackArray Is Nothing Then
                    ScriptManager.RegisterClientScriptBlock(Me, GetType(Page), "UploadFileError", _
                    ReturnErrors(_NoPackageSelected), True)
                    UploadErrorControlFill(UpFileID, UpFileName)
                    fgridrebind(uploads)
                    HasError = True
                Else
                    sameFilesamePackString = IsPackageUsed(uploads, UpFileName, PackArray, SelectedFileType.SelectedItem.Text)
                    If sameFilesamePackString <> String.Empty Then
                        ScriptManager.RegisterClientScriptBlock(Me, GetType(Page), "UploadFileError", _
                                                            ReturnErrors(_AlreadyUsedPackage, sameFilesamePackString), _
                                                            True)
                        fgridrebind(uploads)
                        UploadErrorControlFill(UpFileID, UpFileName)
                        HasError = True
                    Else
                        For Each str As String In PackArray
                            If str.Replace(" ", "") <> "" And str.Replace(" ", "") <> "|" Then
                                datatablepackageid &= str & "|"
                            End If
                        Next
                        gridpackagestring = PackageDisplayHandler.FriendlyPackageDisplay(PackArray)
                    End If

                End If
            ElseIf rbPMlist.Visible And Not HasError Then
                If rbPMlist.SelectedIndex = -1 Then
                    ScriptManager.RegisterClientScriptBlock(Me, GetType(Page), "UploadFileError", _
                    ReturnErrors(_NoMSMSelected), True)
                    UploadErrorControlFill(UpFileID, UpFileName)
                    fgridrebind(uploads)
                    HasError = True
                Else
                    PackOrPm = ProjectManager.GetByMemberID(CInt(rbPMlist.SelectedItem.Value)).FullName
                    PMId = rbPMlist.SelectedItem.Value
                End If
            Else
                PackArray = Nothing
            End If
            If uploads.Rows.Count >= _MaxNumberOfUploads And Not HasError Then
                ScriptManager.RegisterClientScriptBlock(Me, GetType(Page), "UploadFileError", _
                                ReturnErrors(_MoreThanTen) & _
                                BuildRemoveUploadControlJavaFunction(UpFileID), True)
                ResetOptions(upsfileIds)
                fgridrebind(uploads)
                HasError = True
            End If
            If Not HasError Then
                Context.Session.Remove(ParentDataSetSessionName)
                Dim ups As DataRow = uploads.Rows.Add
                ups.BeginEdit()
                ups.Item(UploadDataTable._ControlID) = UpFileID
                ups.Item(UploadDataTable._UploadFileId) = upsfileIds
                ups.Item(UploadDataTable._ClientFilePath) = UpFileName
                ups.Item(UploadDataTable._FileNotes) = SelectedNotes.Text
                ups.Item(UploadDataTable._FileType) = SelectedFileType.SelectedItem.Text
                ups.Item(UploadDataTable._UploadFileTypeID) = SelectedFileType.SelectedItem.Value
                ups.Item(UploadDataTable._UploadActionID) = UploadAction.Get(SelectedFileType.SelectedItem.Value)
                ups.Item(UploadDataTable._UploadFileState) = UploadFileState.NewUploadFileState
                ups.Item(UploadDataTable._GroupID) = CurrentUser.SelectedGroup.GroupId
                ups.Item(UploadDataTable._MemberId) = Cmem.MemberId
                If cbPackageList.Visible Then
                    ups.Item(UploadDataTable._Package) = datatablepackageid
                    ups.Item(UploadDataTable._PackOrPM) = gridpackagestring

                Else
                    ups.Item(UploadDataTable._ProjectManager) = PackOrPm
                    ups.Item(UploadDataTable._PackOrPM) = PackOrPm
                    ups.Item(UploadDataTable._ProjectManagerID) = PMId
                End If
                ups.EndEdit()
                Context.Session.Add(ParentDataSetSessionName, uploads)
                fgridrebind(uploads)
                ResetOptions(CInt(upsfileIds) + 1)
                ScriptManager.RegisterClientScriptBlock(Me, GetType(Page), "ReturnDisplay", _
                       "document.getElementById('UploadButtonDiv').style.display = 'block'; ", True)
            End If
            If CheckLimitedAccessDisplay() = True Then disableDropEntries()
            Cmem = Nothing
            uploads.Dispose()
            
        End If
    End Sub

    Public Sub RemoveItemFromdataSet(ByVal IBId As String)
        Dim uploads As DataTable
        uploads = TryCast(Context.Session.Item(ParentDataSetSessionName), DataTable)
        If uploads Is Nothing Then
            ScriptManager.RegisterClientScriptBlock(Me, GetType(Page), "LoggedOut", _
             "alert('You have Been Logged Out);", True)
        Else
            Context.Session.Remove(ParentDataSetSessionName)
            Dim ItemToRemoveString As String = IBId.LastIndexOf("_") + 1
            Dim finalString As String = Right(IBId, Len(IBId) - ItemToRemoveString)
            Dim ControlID As String = String.Empty
            For i As Integer = uploads.Rows.Count - 1 To 0 Step -1
                If uploads.Rows(i).Item(UploadDataTable._TransactionID).ToString = finalString Then
                    ControlID = uploads.Rows(i).Item(UploadDataTable._ControlID)
                    uploads.Rows(i).Delete()
                End If
            Next
            fgridrebind(uploads)
            ScriptManager.RegisterClientScriptBlock(Me, GetType(Page), "RemoveItem", _
                         BuildRemoveUploadControlJavaFunction(ControlID), True)
            If uploads.Rows.Count > 0 Then
                Context.Session(ParentDataSetSessionName) = uploads
            End If
            uploads.Dispose()
            End If
    End Sub

    Public Sub ClearAll()
        Dim dt As DataTable = TryCast(Session(ParentDataSetSessionName), DataTable)
        If CheckLimitedAccessDisplay() = True Then disableDropEntries()
        If Not dt Is Nothing Then
            fgridrebind(dt)
            ResetOptions(dt.Rows(dt.Rows.Count - 1).Item(UploadDataTable._TransactionID))
            ScriptManager.RegisterClientScriptBlock(Me, GetType(Page), "Clear Options", _
            BuildRemoveUploadControlJavaFunction(dt.Rows(dt.Rows.Count - 1).Item(UploadDataTable._ControlID)), True)
        Else
            ResetOptions(1)
            ScriptManager.RegisterClientScriptBlock(Me, GetType(Page), "Clear Options", _
            BuildRemoveUploadControlAllJavaFunction(), True)
        End If
    End Sub

#End Region

#Region "Full Page Posts"

    Public Sub Clearqueue()
        Context.Session.Remove(ParentDataSetSessionName)
        Dim ups As New DataTable
        fgrid.DataSource = ups
        fgrid.DataBind()
        fgrid.Visible = False
        GenericContentPlaceholder.Controls.Clear()
        AddUploadControlToForm(1)
        ups.Dispose()
    End Sub

    Public Sub UploadAllFiles()
        Dim dt As DataTable = GetNotesFromQueue(TryCast(Context.Session(ParentDataSetSessionName), DataTable))
        Dim ABCCol As WebSupergoo.ABCUpload6.Upload = New WebSupergoo.ABCUpload6.Upload
        _UploadFile.LogPath = Server.MapPath("~\Logs.txt")
        Dim UploadList As List(Of UploadFile) = _UploadFile.DoUpload(dt, ABCCol)
        Try
            If UploadList.Count > 0 Then
                Context.Session.Remove(ParentDataSetSessionName)
                Dim tbl As DataTable = TryCast(Context.Session(UploadedTableSession), DataTable)
                If tbl Is Nothing Then
                    tbl = New DataTable
                    Dim UploadedTableCols As ArrayList = UploadedFileDataTable.DataTableColumnArraylist
                    For x As Integer = 0 To UploadedTableCols.Count - 1
                        tbl.Columns.Add(UploadedTableCols(x))
                    Next
                    tbl.TableName = UploadedFileDataTable._DataTableName
                Else
                    Context.Session.Remove(UploadedTableSession)
                End If
                tbl = FillUploadedTable(tbl, UploadList)
                'uploadsgrid.DataSource = tbl
                'uploadsgrid.DataBind()
                Context.Session(UploadedTableSession) = tbl
                tbl.Dispose()
            Else
                Throw New System.ExecutionEngineException("File Upload Did not work please contact your administrator")
            End If
        Catch ex As Exception
            _UploadFile.LogPath = Server.MapPath("~\Logs.txt")
            _UploadFile.LogItem = (ex.Message & "-----" & ex.StackTrace)
        End Try
        Page.Controls.Clear()
        Page.Response.Redirect("Upload.aspx")
        'ScriptManager.RegisterClientScriptBlock(Me, GetType(Page), "UploadDone", _
        '"location.href = 'Upload.aspx';", True)
    End Sub

#End Region

#Region " Fill Controls"

    Private Sub FillFileTypes()
        'Fill file types
        SelectedFileType.DataSource = UploadAction.GetAll
        SelectedFileType.DataValueField = "UploadActionId"
        SelectedFileType.DataTextField = "UploadActionName"
        SelectedFileType.DataBind()
        Dim li As New ListItem
        li.Value = "0"
        li.Text = " "
        SelectedFileType.Items.Insert(0, li)
        li = Nothing
    End Sub

    Private Sub FillListwithPackages()
        Dim packages As List(Of NRC.Qualisys.QLoader.Library.DTSPackage) = FillPackages()
        If Not packages Is Nothing AndAlso packages.Count > 0 Then
            Dim newset As DataSet = SortAnyListReturnNativeDataSet.GetDataSetNative(packages, "PackageFriendlyName")
            cbPackageList.DataSource = newset
            cbPackageList.DataTextField = "PackageFriendlyName"
            cbPackageList.DataValueField = "PackageID"
            cbPackageList.DataBind()
            For Each li As ListItem In cbPackageList.Items
                li.Text = ParseBackSlashAndSpace.ParseText(li.Text, "", "<br/>&nbsp;&nbsp;&nbsp;&nbsp;", True, " ", 45)
                li.Attributes.Add("style", "vertical-align:top;")
            Next
            LimitedAccess.Visible = False
        Else
            LimitedAccess.Visible = True
            disableDropEntries()
        End If
    End Sub

    Private Sub FillListwithPMs()
        rbPMlist.DataSource = Qualisys.QLoader.Library.ProjectManager.GetAll()
        rbPMlist.DataTextField = "FullName"
        rbPMlist.DataValueField = "MemberID"
        rbPMlist.DataBind()
    End Sub

    Private Sub AddUploadControlToForm(ByVal Ids As Integer)
        Dim NewUpcontrol As New UI.WebControls.FileUpload
        NewUpcontrol.Width = "300"
        NewUpcontrol.ID = "IpFile_" & Ids
        CurrentFileUploadID.Text = Ids
        NewUpcontrol.Attributes.Add("style", "FONT-SIZE:XX-small;")
        NewUpcontrol.Attributes.Add("onKeyPress", "return false;")
        FileControls.Controls.Add(NewUpcontrol)
        NewUpcontrol.Dispose()
    End Sub

    Private Function FillUploadedTable(ByVal dt As DataTable, ByVal UploadList As List(Of UploadFile)) As DataTable
        Dim newdt As DataTable = dt
        newdt.BeginLoadData()
        For Each ups As UploadFile In UploadList
            If Not ups Is Nothing Then
                Dim rows As DataRow = newdt.NewRow
                rows(UploadedFileDataTable._FileName) = ParseBackSlashAndSpace.ParseText(ups.OrigFileName)
                rows(UploadedFileDataTable._FileType) = ups.UploadAction.UploadActionName
                If ups.UploadAction.UploadFileTypeAction.Name = UploadFileTypeAction.AvailableActions.Packages Then
                    Dim FillStr As String = String.Empty
                    For Each uppack As UploadFilePackage In ups.UploadFilePackages
                        FillStr &= uppack.Package.PackageID & "|"
                    Next
                    rows(UploadedFileDataTable._Packages) = PackageDisplayHandler.FriendlyPackageDisplay(Split(FillStr, "|"))
                Else
                    rows(UploadedFileDataTable._Packages) = ups.ProjectManager.FullName
                End If
                rows(UploadedFileDataTable._Status) = ups.UploadFileState.StateOfUpload.UploadStateName
                newdt.Rows.Add(rows)
            End If
        Next
        newdt.EndLoadData()
        Return newdt
        newdt.Dispose()
    End Function

#End Region

#Region " Package Functions"

    Private Function FillPackages()
        Dim mem As NRC.NRCAuthLib.Member = CurrentUser.Member
        Dim myGroup As NRC.NRCAuthLib.Group = CurrentUser.SelectedGroup
        Dim dmTree As NRC.NRCAuthLib.DataMartPrivilegeTree
        dmTree = NRC.NRCAuthLib.DataMartPrivilegeTree.GetGroupTree(myGroup)
        For Each clientNode As NRC.NRCAuthLib.DataMartPrivilegeTree.DataMartPrivilegeNode In dmTree.Nodes
            For Each studyNode As NRC.NRCAuthLib.DataMartPrivilegeTree.DataMartPrivilegeNode In clientNode.Nodes
                Dim studyID As Integer = ConvertNodeIDValue(studyNode)
                If ((clientNode.IsGranted) Or (studyNode.IsGranted)) Then
                    If Not StudyExists(studyID) Then
                        studyIDs.Add(studyID)
                    End If
                Else
                    RecurseTree(studyNode, studyID)
                End If
            Next
        Next
        'Next 
        Dim packcol As List(Of DTSPackage) = DTSPackage.CreatePackageCollectionByStudyIds(studyIDs)
        For i As Integer = packcol.Count - 1 To 0 Step -1
            If Not packcol.Item(i).BitActive Then
                packcol.RemoveAt(i)
            End If
        Next
        Return packcol
    End Function

    Private Function ConvertNodeIDValue(ByVal node As NRC.NRCAuthLib.DataMartPrivilegeTree.DataMartPrivilegeNode) As Integer
        Dim retVal As Integer = 0
        Select Case node.PrivilegeLevel
            Case NRC.NRCAuthLib.DataMartPrivilegeTree.PrivilegeLevelEnum.Client
                'TODO:  Implement
            Case DataMartPrivilegeTree.PrivilegeLevelEnum.Study
                retVal = Val(Replace(node.NodeId, "ST", ""))
            Case DataMartPrivilegeTree.PrivilegeLevelEnum.Survey
                'TODO:  Implement
            Case DataMartPrivilegeTree.PrivilegeLevelEnum.Unit
                'TODO:  Implement
        End Select
        Return retVal
    End Function

    Private Function StudyExists(ByVal id As Integer) As Boolean
        For Each studyID As Integer In studyIDs
            If studyID = id Then
                Return True
            End If
        Next
        Return False
    End Function

    Private Sub RecurseTree(ByVal node As NRC.NRCAuthLib.DataMartPrivilegeTree.DataMartPrivilegeNode, ByVal studyID As Integer)
        If Not node.Nodes Is Nothing Then
            For Each childNode As NRC.NRCAuthLib.DataMartPrivilegeTree.DataMartPrivilegeNode In node.Nodes
                If childNode.IsGranted Then
                    If Not StudyExists(studyID) Then
                        studyIDs.Add(studyID)
                        Exit For
                    End If
                Else
                    RecurseTree(childNode, studyID)
                End If
            Next
        End If
    End Sub

#End Region

#Region "Utility Functions"


    Private Function GetNotesFromQueue(ByVal oDT As DataTable) As DataTable
        Dim dt As DataTable = oDT
        For Each dr As DataRow In dt.Rows
            Dim TransId As String = dr.Item(UploadDataTable._TransactionID)
            For x As Integer = 0 To fgrid.Items.Count - 1
                Dim NotesValue As TextBox = CType(fgrid.Items(x).Cells(4).Controls(1), TextBox)
                If NotesValue.Text <> "" And _
                   fgrid.Items(x).Cells(0).Text = TransId Then
                    dr.Item(UploadDataTable._FileNotes) = NotesValue.Text
                    Exit For
                End If
            Next
        Next
            Return dt
    End Function

    Private Function UploadDisplay(ByVal txt As String)
        If txt = _UploadButtonsNoDisplay Then
            Return "document.getElementById('UploadButtonDiv').style.display = 'none';"
        Else
            Return "document.getElementById('UploadButtonDiv').style.display = 'block';"
        End If


    End Function

    Private Function GetPackagesFromUpload() As String()
        Dim PackArray As String()
        Dim PackString As String = String.Empty
        For Each checked As ListItem In cbPackageList.Items
            If checked.Selected Then
                PackString &= (checked.Value) & "|"
            End If
        Next
        If PackString = String.Empty Then
            PackArray = Nothing
        Else
            PackArray = Split(PackString, "|")
        End If
        Return PackArray
    End Function

    Private Sub DisplayOfPackPM(ByVal PMlist As Boolean, ByVal PMLabel As Boolean, _
      ByVal Packlist As Boolean, ByVal Packlabel As Boolean, ByVal LtdAccess As Boolean)
        cbPackageList.Visible = Packlist
        lblPacks.Visible = Packlabel
        rbPMlist.Visible = PMlist
        lblPMs.Visible = PMLabel
        LimitedAccess.Visible = LtdAccess
    End Sub

    Private Sub ResetOptions(ByVal ids As Integer)
        FileControls.Controls.Clear()
        AddUploadControlToForm(ids)
        SelectedFileType.SelectedIndex = 0
        DisplayOfPackPM(False, False, False, False, CheckLimitedAccessDisplay)
        cbPackageList.ClearSelection()
        rbPMlist.ClearSelection()
        SelectedNotes.Text = ""
        UploadFileControlIdLabel.Text = ""
        UploadFileControlValueLabel.Text = ""
    End Sub

    Private Function MakeDisplayLabelControl(ByVal Labeltext As String) As Label
        Dim lbl As New Label
        lbl.Text = Labeltext
        lbl.ID = "DispLabel"
        lbl.Font.Size = FontUnit.XXSmall
        Return lbl
        lbl.Dispose()
    End Function

    Private Function BuildRemoveUploadControlJavaFunction(ByVal ControlId As String) As String
        Dim retstring As String = _
        "var ToDel = document.getElementById('UploadFileControlHolder'); " & _
        "var Findel = ToDel.getElementsByTagName('input');" & _
        "var InputToRemove;" & _
        "for (var i = 0; i < Findel.length; i++){" & _
        "if (Findel[i].id == '" & ControlId & "'){" & _
        "InputToRemove = Findel[i];" & _
        "break;}}" & _
        "if(InputToRemove != null)" & _
        "{" & _
        "InputToRemove.parentNode.removeChild(InputToRemove);" & _
        "}"
        Return retstring
    End Function

    Private Function BuildRemoveUploadControlAllJavaFunction() As String
        Dim retstring As String = _
        "var ToDel = document.getElementById('UploadFileControlHolder'); " & _
        "var Findel = ToDel.getElementsByTagName('input');" & _
        "var InputToRemove;" & _
        "for (var i = 0; i < Findel.length; i++){" & _
        "InputToRemove = Findel[i];" & _
        "InputToRemove.parentNode.removeChild(InputToRemove);" & _
        "}"
        Return retstring
    End Function

    Private Sub fgridrebind(ByVal tbl As DataTable)
        If tbl.Rows.Count > 0 Then
            Dim dt As DataTable = GetNotesFromQueue(tbl)
            fgrid.DataSource = dt
            fgrid.DataBind()
            fgrid.Visible = True
            GenericContentPlaceholder.Controls.Add(New LiteralControl("<div id='pnlFileInfoHeader' class='PanelTitle'>File Queue</div>"))
            ScriptManager.RegisterClientScriptBlock(Me, GetType(Page), "UploadFileError", _
                    UploadDisplay(_UploadButtonsDisplay), True)
        Else
            fgrid.Visible = False
            GenericContentPlaceholder.Controls.Clear()
            ScriptManager.RegisterClientScriptBlock(Me, GetType(Page), "UploadFileError", _
                     UploadDisplay(_UploadButtonsNoDisplay), True)
        End If
    End Sub

    Private Sub UploadErrorControlFill(ByVal upfileid As String, ByVal upfilename As String)
        FileControls.Controls.Clear()
        FileControls.Controls.Add(MakeDisplayLabelControl(upfilename))
        UploadFileControlIdLabel.Text = upfileid
        UploadFileControlValueLabel.Text = upfilename
    End Sub

    Private Function IsPackageUsed(ByVal tbl As DataTable, ByVal UpFileName As String, ByVal PackArray As String(), _
      ByVal SelectedFileType As String)
        Dim SameFileSamePackString As String = String.Empty
        If tbl.Rows.Count > 0 Then
            For Each drow As DataRow In tbl.Rows
                Dim DataTableFileName As String = drow.Item(UploadDataTable._ClientFilePath).ToString.Replace("<br />", "")
                Dim DataTableFileType As String = drow.Item(UploadDataTable._FileType).ToString.Replace("<br />", "")
                Dim DataTablePackages As String() = Split(drow(UploadDataTable._Package).ToString.Replace("<br />", ""), "|")
                If DataTableFileName = UpFileName And _
                   DataTableFileType = SelectedFileType Then
                    Dim spstring As String() = Split(drow(UploadDataTable._Package).ToString.Replace("<br />", ""), "|")
                    For Each str As String In PackArray
                        For Each str1 As String In DataTablePackages
                            If str = str1 And str <> "" And str1 <> "" Then
                                SameFileSamePackString = drow(UploadDataTable._TransactionID).ToString
                                Exit For
                            End If
                        Next
                        If SameFileSamePackString <> String.Empty Then Exit For
                    Next
                End If
                If SameFileSamePackString <> String.Empty Then Exit For
            Next
        End If
        Return SameFileSamePackString
    End Function

    Private Function ReturnErrors(ByVal errormessage As String, Optional ByVal MessageVariable As String = "") As String
        Dim MessageString As String = String.Empty
        Select Case errormessage
            Case "MoreThanTen"
                MessageString = "alert('You may not upload more than 10 files at a time.');"
            Case "AlreadyUsedPackage"
                MessageString = "alert('The Source File you are trying to upload has already been " & _
                                    "associated with the package you have selected. \n Please review " & _
                                    "upload ID " & MessageVariable & ".');"

            Case "NoPackSelected"
                MessageString = "alert('You must select a package to continue.');"
            Case "NoPmSelected"
                MessageString = "alert('You must select a Measurement Services Manager to continue.');"
            Case "LoggedOut"
                MessageString = "alert('You have been logged out due to inactivity');location.href = 'SignIn.aspx';"
            Case "NoFileTypeSelected"
                MessageString = "alert('You must select a file type to continue.');"
        End Select
        Return MessageString
    End Function

    Private Function CreateDataTable() As DataTable
        Dim Uploads As DataTable
        Uploads = New DataTable(UploadDataTable._DataTableName)
        Dim ColArray As ArrayList = UploadDataTable.DataTableColumnArraylist
        For x As Integer = 0 To ColArray.Count - 1
            Uploads.Columns.Add(ColArray(x))
        Next
        Uploads.Columns(UploadDataTable._AutoIncrementColumn).AutoIncrementSeed = UploadDataTable._AutoIncrementSeed
        Uploads.Columns(UploadDataTable._AutoIncrementColumn).AutoIncrementStep = UploadDataTable._AutoIncrementStep
        Uploads.Columns(UploadDataTable._AutoIncrementColumn).AutoIncrement = UploadDataTable._AutoIncrement
        Return Uploads
    End Function

    Private Function CheckLimitedAccessDisplay() As Boolean
        Dim result As Boolean = False
        For Each item As ListItem In SelectedFileType.Items
            If item.Value = "disabled" Then
                result = True
            End If
        Next
        Return result
    End Function

    Private Sub disableDropEntries()
        For Each item As ListItem In SelectedFileType.Items
            If item.Value <> "0" Then
                If item.Value <> "disabled" Then
                    Dim uUpAction As UploadAction = UploadAction.Get(item.Value)
                    If uUpAction.UploadFileTypeAction.Id = _selectedPackageUploadfileTypes Then
                        item.Attributes.Add("disabled", "true")
                        item.Attributes.Add("style", "color:silver;background-color:gainsboro;")
                        item.Value = "disabled"
                    End If
                Else
                    item.Attributes.Add("disabled", "true")
                    item.Attributes.Add("style", "color:silver;background-color:gainsboro;")
                    item.Value = "disabled"
                End If
            End If
        Next
    End Sub

#End Region

End Class
