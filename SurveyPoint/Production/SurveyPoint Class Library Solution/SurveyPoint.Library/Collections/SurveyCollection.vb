Imports Nrc.Framework.BusinessLogic
''' <summary>Allow for a collection of script objects.  Right now, 1 script is used per export.  However we need a collection to display all of them.</summary>
''' <CreatedBy>Tony Piccoli</CreatedBy>
''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
<Serializable()> _
Public Class ExportSurveyCollection
    Inherits BusinessListBase(Of ExportSurveyCollection, ExportSurvey)

    Protected Overrides Function AddNewCore() As Object
        Dim newObj As ExportSurvey = ExportSurvey.NewSurvey
        Me.Add(newObj)
        Return newObj
    End Function
End Class
