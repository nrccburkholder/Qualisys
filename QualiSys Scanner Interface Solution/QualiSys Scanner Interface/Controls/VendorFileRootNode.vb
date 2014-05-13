Imports Nrc.QualiSys.Library
Imports Nrc.QualiSys.Scanning.Library
Imports Nrc.Framework.BusinessLogic.Configuration

Public Class VendorFileRootNode
    Inherits TreeNode

#Region " Private Members "

    Private mSource As VendorFileNavigatorTree

#End Region

#Region " Public ReadOnly Properties "

    Public ReadOnly Property DisplayName() As String
        Get
            If mSource.VendorID.HasValue AndAlso mSource.VendorID.Value = AppConfig.Params("QSIBedsideVendorID").IntegerValue Then
                Return "Bedside"
            Else
                Return mSource.MailingStepMethodName
            End If
        End Get

    End Property

    Public ReadOnly Property Source() As VendorFileNavigatorTree
        Get
            Return mSource
        End Get
    End Property

#End Region

#Region " Friend ReadOnly Properties "

    Friend ReadOnly Property Key() As String
        Get
            Return String.Format("RT{0}", mSource.MailingStepMethodID)
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
        Select Case mSource.MailingStepMethodID
            Case MailingStepMethodCodes.Phone
                ImageKey = VendorFileImageKeys.RootPhone
                SelectedImageKey = VendorFileImageKeys.RootPhone

            Case MailingStepMethodCodes.Web
                If mSource.VendorID.HasValue AndAlso mSource.VendorID.Value = AppConfig.Params("QSIBedsideVendorID").IntegerValue Then
                    ImageKey = VendorFileImageKeys.RootBedside
                    SelectedImageKey = VendorFileImageKeys.RootBedside
                Else
                    ImageKey = VendorFileImageKeys.RootWeb
                    SelectedImageKey = VendorFileImageKeys.RootWeb
                End If

            Case MailingStepMethodCodes.IVR
                ImageKey = VendorFileImageKeys.RootIVR
                SelectedImageKey = VendorFileImageKeys.RootIVR

            Case MailingStepMethodCodes.MailWeb
                ImageKey = VendorFileImageKeys.RootMailWeb
                SelectedImageKey = VendorFileImageKeys.RootMailWeb

            Case MailingStepMethodCodes.LetterWeb
                ImageKey = VendorFileImageKeys.RootLetterWeb
                SelectedImageKey = VendorFileImageKeys.RootLetterWeb

        End Select

    End Sub

#End Region

End Class