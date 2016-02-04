Imports Nrc.Framework.BusinessLogic
<Serializable()> _
Public Class ExportFileLogCollection
    Inherits BusinessListBase(Of ExportFileLogCollection, ExportFileLog)

    Protected Overrides Function AddNewCore() As Object
        Dim newObj As ExportFileLog = ExportFileLog.NewExportFileLog
        Me.Add(newObj)
        Return newObj
    End Function
End Class