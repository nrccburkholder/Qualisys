Imports Nrc.Qualisys.Library
Imports DevExpress.XtraTreeList.Nodes
Imports DevExpress.XtraGrid.Views.Base
Imports DevExpress.XtraGrid.Views.Grid.ViewInfo
Imports DevExpress.Utils
Imports DevExpress.XtraGrid.Views.Grid
Imports DevExpress.XtraGrid.Columns
Imports System.Windows.Forms


Friend Class CoverLetterEx
    Private mStatus As Integer = CoverLetterMappingStatusCodes.None

    Public Property Survey_Id() As Integer

    Public Property CoverLetterName() As String

    Public Property Label() As String

    Public Property Status As Integer
        Get
            Return mStatus
        End Get
        Set(value As Integer)
            mStatus = value
        End Set
    End Property

    Public Property ItemType() As Integer


    Public Sub New(ByVal surveyid As Integer, ByVal name As String, ByVal itemLabel As String, ByVal fItemType As Integer)

        Survey_Id = surveyid
        CoverLetterName = name
        Label = itemLabel
        ItemType = fItemType

    End Sub
End Class
