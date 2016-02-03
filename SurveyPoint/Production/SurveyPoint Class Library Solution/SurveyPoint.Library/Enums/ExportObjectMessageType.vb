''' <summary>This is used in Export object message objects and determines the type of message.</summary>
''' <CreatedBy>Tony Piccoli</CreatedBy>
''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
Public Enum ExportObjectMessageType
    ExportError = 1
    ExportWarning = 2
    ExportValidation = 3
    ExportInformation = 4
    ExportSuccess = 5
End Enum
