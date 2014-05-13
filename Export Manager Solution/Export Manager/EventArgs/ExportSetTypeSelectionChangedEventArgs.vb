Imports Nrc.DataMart.Library

Public Class ExportSetTypeSelectionChangedEventArgs
    Inherits System.EventArgs

#Region " Private Members "

    Private mExportSetType As ExportSetType

#End Region

#Region " Public Properties "

    Public ReadOnly Property ExportSetType() As ExportSetType
        Get
            Return mExportSetType
        End Get
    End Property

#End Region

#Region " Constructors "

    Public Sub New(ByVal exportSetType As ExportSetType)

        mExportSetType = ExportSetType

    End Sub

#End Region

End Class
