
''' <summary>this class is for providing parameters to ShowModeChanged Event.
''' ShowModeChanged event is notifying the ExportSection that ShowAll or
''' ShowSelected buttons are clicked. So ExportSection Forces ViewExportLogSection
''' to save the show mode appropriately.</summary>
''' <CreateBy>Arman Mnatsakanyan</CreateBy>
''' <RevisionList><list type="table">
''' <listheader>
''' <term>Date Modified - Modified By</term>
''' <description>Description</description></listheader>
''' <item>
''' <term>	</term>
''' <description>
''' <para></para></description></item>
''' <item>
''' <term>	</term>
''' <description>
''' <para></para></description></item></list></RevisionList>
Public Class ShowModeChangedEventArgs
    Inherits EventArgs

    Dim _ShowSelected as Boolean 
    Public Sub New(ByVal pShowSelected As Boolean)
        _ShowSelected = pShowSelected
    End Sub

    Public ReadOnly Property ShowSelected() As Boolean
        Get
            Return _ShowSelected
        End Get
    End Property

End Class

