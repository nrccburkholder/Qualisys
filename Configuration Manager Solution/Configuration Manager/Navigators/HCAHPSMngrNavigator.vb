''' <summary>HCAHPS Navigator control.</summary>
''' <CreatedBy>Tony Piccoli</CreatedBy>
''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
Public Class HCAHPSMngrNavigator
    Private mSection As Section

    Public Overrides Sub RegisterSectionControl(ByVal sect As Section)

        mSection = sect

    End Sub
End Class
