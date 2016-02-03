Imports Nrc.Framework.BusinessLogic
Imports Nrc.SurveyPoint.Library.DataProviders

''' <summary>This class takes script extension properties and creates an object that lets you pivot those properties for display.</summary>
''' <CreatedBy>Tony Piccoli</CreatedBy>
''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
Public Class ExportScriptExtension
    Inherits ExportExtension

    Dim mParentExportScriptSelected As ExportScriptSelected

    ''' <summary>Reference back to the script object so that you can update its properties</summary>
    ''' <value>Parent script object</value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Property ParentExportScriptSelected() As ExportScriptSelected
        Get
            Return mParentExportScriptSelected
        End Get
        Set(ByVal value As ExportScriptSelected)
            mParentExportScriptSelected = value
        End Set
    End Property

    ''' <summary>Constructor overload to set all properties</summary>
    ''' <param name="exportScriptSelected"></param>
    ''' <param name="ColumnName"></param>
    ''' <param name="DisplayName"></param>
    ''' <param name="Value"></param>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub New(ByVal exportScriptSelected As ExportScriptSelected, ByVal ColumnName As String, ByVal DisplayName As String, ByVal Value As String)

        Me.ParentExportScriptSelected = exportScriptSelected
        Me.ColumnName = ColumnName
        Me.DisplayName = DisplayName
        Me.Value = Value

    End Sub

    ''' <summary>Factory to create a new script extension object</summary>
    ''' <param name="exportScriptSelected"></param>
    ''' <param name="columnName"></param>
    ''' <param name="DisplayName"></param>
    ''' <param name="Value"></param>
    ''' <returns></returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared Function NewExportScriptExtension(ByVal exportScriptSelected As ExportScriptSelected, ByVal columnName As String, ByVal DisplayName As String, ByVal Value As String) As ExportScriptExtension
        Dim retVal As ExportScriptExtension = New ExportScriptExtension(exportScriptSelected, columnName, DisplayName, Value)
        retVal.SetRules()
        Return retVal
    End Function

    ''' <summary>When a script extension is edited, this method update the related properties of its parent.</summary>
    ''' <param name="colName"></param>
    ''' <param name="setValue"></param>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Protected Overrides Sub SetParentProperty(ByVal colName As String, ByVal setValue As String)
        Select Case colName
            Case "MiscChar1"
                Me.ParentExportScriptSelected.MiscChar1 = setValue
            Case "MiscChar1Name"
                Me.ParentExportScriptSelected.MiscChar1Name = setValue
            Case "MiscChar2"
                Me.ParentExportScriptSelected.MiscChar2 = setValue
            Case "MiscChar2Name"
                Me.ParentExportScriptSelected.MiscChar2Name = setValue
            Case "MiscChar3"
                Me.ParentExportScriptSelected.MiscChar3 = setValue
            Case "MiscChar3Name"
                Me.ParentExportScriptSelected.MiscChar3Name = setValue
            Case "MiscChar4"
                Me.ParentExportScriptSelected.MiscChar4 = setValue
            Case "MiscChar4Name"
                Me.ParentExportScriptSelected.MiscChar4Name = setValue
            Case "MiscChar5"
                Me.ParentExportScriptSelected.MiscChar5 = setValue
            Case "MiscChar5Name"
                Me.ParentExportScriptSelected.MiscChar5Name = setValue
            Case "MiscChar6"
                Me.ParentExportScriptSelected.MiscChar6 = setValue
            Case "MiscChar6Name"
                Me.ParentExportScriptSelected.MiscChar6Name = setValue
            Case "MiscNum1"
                If Me.IsValid Then
                    Dim ndec As Nullable(Of Decimal)
                    Dim dec As Decimal = Nothing
                    Decimal.TryParse(setValue, dec)
                    ndec = dec
                    If setValue = "" Then
                        Me.ParentExportScriptSelected.MiscNum1 = Nothing
                    Else
                        Me.ParentExportScriptSelected.MiscNum1 = ndec
                    End If
                End If
            Case "MiscNum1Name"
                Me.ParentExportScriptSelected.MiscNum1Name = setValue
            Case "MiscNum2"
                If Me.IsValid Then
                    Dim ndec As Nullable(Of Decimal)
                    Dim dec As Decimal = Nothing
                    Decimal.TryParse(setValue, dec)
                    ndec = dec
                    If setValue = "" Then
                        Me.ParentExportScriptSelected.MiscNum2 = Nothing
                    Else
                        Me.ParentExportScriptSelected.MiscNum2 = ndec
                    End If
                End If
            Case "MiscNum2Name"
                Me.ParentExportScriptSelected.MiscNum2Name = setValue
            Case "MiscNum3"
                If Me.IsValid Then
                    Dim ndec As Nullable(Of Decimal)
                    Dim dec As Decimal = Nothing
                    Decimal.TryParse(setValue, dec)
                    ndec = dec
                    If setValue = "" Then
                        Me.ParentExportScriptSelected.MiscNum3 = Nothing
                    Else
                        Me.ParentExportScriptSelected.MiscNum3 = ndec
                    End If
                End If
            Case "MiscNum3Name"
                Me.ParentExportScriptSelected.MiscNum3Name = setValue
            Case "MiscDate1"
                If Me.IsValid Then
                    Dim ndte As Nullable(Of Date)
                    Dim dte As Date
                    Date.TryParse(setValue, dte)
                    ndte = dte
                    'TryParse on an empty string will return #12:00AM#        
                    If Not IsDate(setValue) Then
                        Me.ParentExportScriptSelected.MiscDate1 = Nothing
                    Else
                        Me.ParentExportScriptSelected.MiscDate1 = ndte
                    End If
                End If
            Case "MiscDate1Name"
                Me.ParentExportScriptSelected.MiscDate1Name = setValue
            Case "MiscDate2"
                If Me.IsValid Then
                    Dim ndte As Nullable(Of Date)
                    Dim dte As Date
                    Date.TryParse(setValue, dte)
                    ndte = dte
                    'TryParse on an empty string will return #12:00AM#        
                    If Not IsDate(setValue) Then
                        Me.ParentExportScriptSelected.MiscDate2 = Nothing
                    Else
                        Me.ParentExportScriptSelected.MiscDate2 = ndte
                    End If
                End If
            Case "MiscDate2Name"
                Me.ParentExportScriptSelected.MiscDate2Name = setValue
            Case "MiscDate3"
                If Me.IsValid Then
                    Dim ndte As Nullable(Of Date)
                    Dim dte As Date
                    Date.TryParse(setValue, dte)
                    ndte = dte
                    'TryParse on an empty string will return #12:00AM#        
                    If Not IsDate(setValue) Then
                        Me.ParentExportScriptSelected.MiscDate3 = Nothing
                    Else
                        Me.ParentExportScriptSelected.MiscDate3 = ndte
                    End If
                End If
            Case "MiscDate3Name"
                Me.ParentExportScriptSelected.MiscDate3Name = setValue
        End Select
    End Sub


End Class
