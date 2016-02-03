Imports Nrc.Framework.BusinessLogic
<Serializable()> _
Public Class ExportEventSelectedCollection
    Inherits BusinessListBase(Of ExportEventSelectedCollection, ExportEventSelected)

    ''' <summary>Don't use inherited Add() method because we don't have a way to mark the parent objects as dirty.
    ''' Insted use ExportSurvey.SelectEvent</summary>
    ''' <returns></returns>
    ''' <CreateBy>Arman Mnatsakanyan</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Protected Overrides Function AddNewCore() As Object
        Throw New NotImplementedException("Please don't use this method. Use ExportSurvey.AddSelectedEvent instead.")
        'Dim newObj As ExportEventSelected = ExportEventSelected.NewExportEvent
        'Me.Add(newObj)
        'Return newObj
    End Function


    Public Function is2401Exists() As Boolean
        Dim retval As Boolean = False
        For Each item As ExportEventSelected In Me

            If item.EventID = 2401 Then
                retval = True
                Exit For
            End If


        Next


        Return retval


    End Function


End Class
