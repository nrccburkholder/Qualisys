Imports Nrc.NRCAuthLib
Imports System.IO

Public Class ApplicationManagementSection

    Private mAppNavigator As ApplicationNavigator
    Private mSelectedApplication As Application
    Private mAddingPrivilegeType As Privilege.PrivilegeLevelEnum

#Region " ListItem Class "
    Private Class ListItem(Of T)
        Private mLabel As String
        Private mValue As T

        Public ReadOnly Property Label() As String
            Get
                Return mLabel
            End Get
        End Property

        Public ReadOnly Property Value() As T
            Get
                Return mValue
            End Get
        End Property

        Public Sub New(ByVal lbl As String, ByVal val As T)
            Me.mLabel = lbl
            Me.mValue = val
        End Sub

    End Class
#End Region

#Region " Base Class Overrides "
    Public Overrides Sub RegisterNavControl(ByVal navCtrl As Navigator)
        Me.mAppNavigator = TryCast(navCtrl, ApplicationNavigator)
        If Me.mAppNavigator Is Nothing Then
            Throw New Exception("The ApplicationManagementSection control expects a Navigation control of type ApplicationNavigator.")
        End If
    End Sub

    Public Overrides Sub ActivateSection()
        AddHandler mAppNavigator.ApplicationSelected, AddressOf mAppNavigator_ApplicationSelected
    End Sub

    Public Overrides Sub InactivateSection()
        RemoveHandler mAppNavigator.ApplicationSelected, AddressOf mAppNavigator_ApplicationSelected
    End Sub

    Public Overrides Function AllowInactivate() As Boolean
        Return True
    End Function

#End Region

#Region " Private Properties "
    Private ReadOnly Property SelectedDeploymentType() As DeploymentType
        Get
            Return DirectCast(Me.DeploymentTypeList.SelectedValue, DeploymentType)
        End Get
    End Property
#End Region

#Region " Control Event Handlers "
    Private Sub ApplicationManagementSection_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Me.PopulateDeploymentTypeList()
        Me.Enabled = False
    End Sub
#End Region

#Region " Private Methods "
    Private Sub mAppNavigator_ApplicationSelected(ByVal sender As Object, ByVal e As ApplicationNavigator.ApplicationSelectedEventArgs)
        If e.Application IsNot Nothing Then
            Me.mSelectedApplication = e.Application
            Me.AppManagementPanel.Caption = mSelectedApplication.Name
            Me.PopulateForm(mSelectedApplication)
            Me.ApplicationName.Focus()
        Else
            Me.ClearForm()
        End If
    End Sub

    Private Sub PopulateDeploymentTypeList()
        Me.DeploymentTypeList.Items.Clear()
        Dim items As New List(Of ListItem(Of DeploymentType))

        items.Add(New ListItem(Of DeploymentType)("Click Once", DeploymentType.ClickOnce))
        items.Add(New ListItem(Of DeploymentType)("Local Install", DeploymentType.LocalInstall))
        items.Add(New ListItem(Of DeploymentType)("No Touch Deployment", DeploymentType.NoTouch))
        items.Add(New ListItem(Of DeploymentType)("Web Application", DeploymentType.WebApplication))
        Me.DeploymentTypeList.DataSource = items
        Me.DeploymentTypeList.DisplayMember = "Label"
        Me.DeploymentTypeList.ValueMember = "Value"

    End Sub

    Private Sub ClearForm()
        Me.Enabled = False
        Me.ApplicationName.Text = ""
        Me.Description.Text = ""
        Me.DeploymentTypeList.SelectedIndex = 0
        Me.ApplicationPath.Text = ""
        Me.Category.Text = ""
        Me.IsInternalApplication.Checked = False
        Me.ApplicationImage.Image = Nothing
        Me.PrivilegeBindingSource.DataSource = Nothing
    End Sub

    Private Sub PopulateForm(ByVal app As Application)
        Me.Enabled = True
        If app IsNot Nothing Then
            Me.ApplicationName.Text = app.Name
            Me.Description.Text = app.Description
            If app.DeploymentType = DeploymentType.None Then
                Me.DeploymentTypeList.SelectedIndex = 0
            Else
                Me.DeploymentTypeList.SelectedValue = app.DeploymentType
            End If
            Me.ApplicationPath.Text = app.Path
            Me.Category.Text = app.Category
            Me.IsInternalApplication.Checked = app.IsInternalOnly
            Me.ApplicationImage.Image = BytesToImage(app.ImageData)

            Me.PopulatePrivilegeGrid(app.Privileges)
        End If
    End Sub

    Private Sub PopulatePrivilegeGrid(ByVal privileges As PrivilegeCollection)
        Me.PrivilegeBindingSource.DataSource = privileges
    End Sub

    Private Sub SaveChanges()
        Me.mSelectedApplication.Name = Me.ApplicationName.Text
        Me.mSelectedApplication.Description = Me.Description.Text
        Me.mSelectedApplication.DeploymentType = CType(Me.DeploymentTypeList.SelectedValue, DeploymentType)
        Me.mSelectedApplication.Path = Me.ApplicationPath.Text
        Me.mSelectedApplication.Category = Me.Category.Text
        Me.mSelectedApplication.IsInternalOnly = Me.IsInternalApplication.Checked
        Me.mSelectedApplication.ImageData = ImageToBytes(Me.ApplicationImage.Image)

        If mSelectedApplication.ApplicationId = 0 Then
            Me.mSelectedApplication.Insert(CurrentUser.Member.MemberId)
        Else
            Me.mSelectedApplication.UpdateApplication(CurrentUser.Member.MemberId)
        End If

        For Each priv As Privilege In mSelectedApplication.Privileges
            If priv.PrivilegeId = 0 Then
                priv.Insert(mSelectedApplication.ApplicationId, CurrentUser.Member.MemberId)
            ElseIf priv.IsDirty Then
                priv.UpdatePrivilege(CurrentUser.Member.MemberId)
            End If
        Next

        Me.mAppNavigator.ReloadSelectedButton()
    End Sub

    Private Function BytesToImage(ByVal imgData As Byte()) As Image
        'Return NULL when there is no data
        If imgData Is Nothing OrElse imgData.Length = 0 Then
            Return Nothing
        End If

        'Put the bytes into a stream and load it into an image
        Using ms As New IO.MemoryStream(imgData)
            Return System.Drawing.Image.FromStream(ms)
        End Using

    End Function

    Private Shared Function ImageToBytes(ByVal img As Drawing.Image) As Byte()
        'Return NULL if there is not image object
        If img Is Nothing Then
            Return Nothing
        End If

        'Create a membory stream and save the image to it
        'Export the stream to a byte array
        Using ms As New IO.MemoryStream
            img.Save(ms, System.Drawing.Imaging.ImageFormat.Png)
            Return ms.ToArray
        End Using
    End Function

#End Region

    Private Sub OKButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles OKButton.Click
        Me.SaveChanges()
    End Sub

    Private Sub CancelButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles CancelButton.Click
        Me.mAppNavigator.ReloadSelectedButton()
    End Sub

    Private Sub ChangeImageButton_LinkClicked(ByVal sender As System.Object, ByVal e As System.Windows.Forms.LinkLabelLinkClickedEventArgs) Handles ChangeImageButton.LinkClicked
        ChangeImage()
    End Sub

    Private Sub ExportImageButton_LinkClicked(ByVal sender As System.Object, ByVal e As System.Windows.Forms.LinkLabelLinkClickedEventArgs) Handles ExportImageButton.LinkClicked
        ExportImage()
    End Sub

    Private Sub ChangeImage()
        'Show the file open dialog
        If Me.ImageSelectorDialog.ShowDialog(Me) = Windows.Forms.DialogResult.OK Then
            Dim img As Image
            'Get a stream to the file
            Using strm As Stream = Me.ImageSelectorDialog.OpenFile
                'If the file is a .ICO then convert icon to bitmap
                'If the file is a .EXE then extract icon from executable
                'If the file is anything else then assume it is an image format and load the image
                If Me.ImageSelectorDialog.FileName.EndsWith(".ico", StringComparison.CurrentCultureIgnoreCase) Then
                    Dim ico As New Icon(strm)
                    img = ico.ToBitmap
                ElseIf Me.ImageSelectorDialog.FileName.EndsWith(".exe", StringComparison.CurrentCultureIgnoreCase) Then
                    img = Drawing.Icon.ExtractAssociatedIcon(ImageSelectorDialog.FileName).ToBitmap
                Else
                    img = Image.FromStream(strm)
                End If

                'Resize the image if needed
                If img.Width > 32 OrElse img.Height > 32 Then
                    Dim bmp As New Bitmap(img, 32, 32)
                    img = bmp
                End If

                'Now load the image into the picture box
                Me.ApplicationImage.Image = img
            End Using
        End If
    End Sub

    Private Sub ExportImage()
        Me.ExportImageDialog.FileName = Me.ApplicationName.Text
        If Me.ExportImageDialog.ShowDialog = Windows.Forms.DialogResult.OK Then
            'Write the image out to a file
            Dim img As Image = ApplicationImage.Image
            Dim format As System.Drawing.Imaging.ImageFormat
            Select Case System.IO.Path.GetExtension(Me.ExportImageDialog.FileName).ToUpper
                Case ".BMP"
                    format = Imaging.ImageFormat.Bmp
                Case ".EMF"
                    format = Imaging.ImageFormat.Emf
                Case ".GIF"
                    format = Imaging.ImageFormat.Gif
                Case ".ICO"
                    format = Imaging.ImageFormat.Icon
                Case ".JPG"
                    format = Imaging.ImageFormat.Jpeg
                Case ".PNG"
                    format = Imaging.ImageFormat.Png
                Case ".TIF"
                    format = Imaging.ImageFormat.Tiff
                Case ".WMF"
                    format = Imaging.ImageFormat.Wmf
                Case Else
                    Throw New ArgumentException("Unknown image type")
            End Select
            img.Save(Me.ExportImageDialog.FileName, format)
        End If
    End Sub

    Private Sub AddGroupPrivilegeButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles AddGroupPrivilegeButton.Click
        Me.mAddingPrivilegeType = Privilege.PrivilegeLevelEnum.Group
        Me.PrivilegeBindingSource.AddNew()
    End Sub

    Private Sub AddMemberPrivilegeButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles AddMemberPrivilegeButton.Click
        Me.mAddingPrivilegeType = Privilege.PrivilegeLevelEnum.Member
        Me.PrivilegeBindingSource.AddNew()
    End Sub


    Private Sub PrivilegeBindingSource_AddingNew(ByVal sender As Object, ByVal e As System.ComponentModel.AddingNewEventArgs) Handles PrivilegeBindingSource.AddingNew
        Dim priv As New Privilege(Me.mAddingPrivilegeType)
        e.NewObject = priv
    End Sub

End Class
