Public Class ExportDefintionSelectedEventArgs
    Inherits EventArgs

    Private mExportDefinitionID As Integer
    Private mExportDefintionAction As ExportDefinitionActions
    Public ReadOnly Property ExportDefinitionID() As Integer
        Get
            Return Me.mExportDefinitionID
        End Get
    End Property
    Public ReadOnly Property ExportDefintionAction() As ExportDefinitionActions
        Get
            Return Me.mExportDefintionAction
        End Get
    End Property
    Public Sub New(ByVal exportDefintionID As Integer, ByVal exportDefAction As ExportDefinitionActions)
        Me.mExportDefinitionID = exportDefintionID
        Me.mExportDefintionAction = exportDefAction
    End Sub
End Class
