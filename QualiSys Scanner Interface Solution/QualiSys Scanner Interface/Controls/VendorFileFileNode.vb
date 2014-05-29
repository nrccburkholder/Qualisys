Imports Nrc.QualiSys.Scanning.Library

Public Class VendorFileFileNode
    Inherits TreeNode

#Region " Private Fields "

    Private mSource As VendorFileNavigatorTree

#End Region

#Region " Public ReadOnly Properties "

    Public ReadOnly Property DisplayName() As String
        Get
            Return String.Format("{0} ({1})", mSource.DisplayName, mSource.VendorFileID)
        End Get
    End Property

    Public ReadOnly Property Source() As VendorFileNavigatorTree
        Get
            Return mSource
        End Get
    End Property

    Public Property DateFileCreated() As Nullable(Of DateTime)
        Get
            Return mSource.DateFileCreated
        End Get
        Set(value As Nullable(Of DateTime))
            mSource.DateFileCreated = value
        End Set
    End Property

#End Region

#Region " Friend ReadOnly Properties "

    Friend ReadOnly Property Key() As String
        Get
            Return String.Format("RT{0}-CL{1}-ST{2}-SD{3}-VF{4}", mSource.MailingStepMethodID, mSource.ClientID, mSource.StudyID, mSource.SurveyID, mSource.VendorFileID)
        End Get
    End Property

#End Region

#Region " Constructors "

    Public Sub New(ByVal source As VendorFileNavigatorTree)

        'Save the source object
        mSource = source

        'Set the name and text
        Text = DisplayName
        Name = Key

        'Set the image
        Select Case mSource.VendorFileStatusID
            Case VendorFileStatusCodes.Processing
                ImageKey = VendorFileImageKeys.FileProcessing
                SelectedImageKey = VendorFileImageKeys.FileProcessing

            Case VendorFileStatusCodes.ProcessingFailed
                ImageKey = VendorFileImageKeys.FileProcessingFailed
                SelectedImageKey = VendorFileImageKeys.FileProcessingFailed

            Case VendorFileStatusCodes.Pending
                ImageKey = VendorFileImageKeys.FilePending
                SelectedImageKey = VendorFileImageKeys.FilePending

            Case VendorFileStatusCodes.Approved
                ImageKey = VendorFileImageKeys.FileApproved
                SelectedImageKey = VendorFileImageKeys.FileApproved

            Case VendorFileStatusCodes.Telematching
                ImageKey = VendorFileImageKeys.FileTelematching
                SelectedImageKey = VendorFileImageKeys.FileTelematching

            Case VendorFileStatusCodes.Sent
                ImageKey = VendorFileImageKeys.FileSent
                SelectedImageKey = VendorFileImageKeys.FileSent

        End Select

    End Sub

#End Region

#Region " Friend Methods "

    Friend Sub Approve()

        'Get the Queue object for this node
        Dim fileQueue As VendorFileCreationQueue = VendorFileCreationQueue.Get(mSource.VendorFileID)

        'Set the status to APPROVED and save it
        fileQueue.VendorFileStatusId = VendorFileStatusCodes.Approved
        fileQueue.Save()

        'Setup the status and image in the tree
        mSource.VendorFileStatusID = VendorFileStatusCodes.Approved
        ImageKey = VendorFileImageKeys.FileApproved
        SelectedImageKey = VendorFileImageKeys.FileApproved

        'Log this action
        VendorFileTracking.LogAction(fileQueue.VendorFileId, VendorFileTrackingActions.Approved, CurrentUser.MemberID)

    End Sub

    Friend Sub Remake()

        'Remake the file
        VendorFileCreationQueue.RemakeVendorFileData(mSource.VendorFileID, mSource.SampleSetID)

        'Log this action
        VendorFileTracking.LogAction(mSource.VendorFileID, VendorFileTrackingActions.Remake, CurrentUser.MemberID)

    End Sub

    Friend Sub Rollback()

        'Get the Queue object for this node
        Dim fileQueue As VendorFileCreationQueue = VendorFileCreationQueue.Get(mSource.VendorFileID)

        'Set the status to PENDING and save it
        fileQueue.VendorFileStatusId = VendorFileStatusCodes.Pending
        fileQueue.Save()

        'Setup the status and image in the tree
        mSource.VendorFileStatusID = VendorFileStatusCodes.Pending
        ImageKey = VendorFileImageKeys.FilePending
        SelectedImageKey = VendorFileImageKeys.FilePending

        'Log this action
        VendorFileTracking.LogAction(fileQueue.VendorFileId, VendorFileTrackingActions.Rollback, CurrentUser.MemberID)

    End Sub

    Friend Sub SetDateFileCreated(ByVal newDateFileCreated As DateTime)

        Dim fileQueue As VendorFileCreationQueue = VendorFileCreationQueue.Get(mSource.VendorFileID)

        'Set the date to the modified date and save it
        fileQueue.DateFileCreated = newDateFileCreated
        fileQueue.Save()

        'Log this action
        VendorFileTracking.LogAction(fileQueue.VendorFileId, VendorFileTrackingActions.SetDateFileCreated, CurrentUser.MemberID)

    End Sub

#End Region

End Class
