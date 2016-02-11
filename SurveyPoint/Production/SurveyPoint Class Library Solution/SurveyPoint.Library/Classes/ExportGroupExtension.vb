Imports Nrc.Framework.BusinessLogic
Imports Nrc.SurveyPoint.Library.DataProviders

Public Interface IExportGroupExtension
    Property ClientExtensionID() As Integer
End Interface

Public Class ExportGroupExtension
    Inherits ExportExtension

    Dim mParentExportGroup As ExportGroup

    Private Property ParentExportGroup() As ExportGroup
        Get
            Return mParentExportGroup
        End Get
        Set(ByVal value As ExportGroup)
            mParentExportGroup = value
        End Set
    End Property

    Private Sub New(ByVal exportGroup As ExportGroup, ByVal ColumnName As String, ByVal DisplayName As String, ByVal Value As String)

        Me.ParentExportGroup = exportGroup
        Me.ColumnName = ColumnName
        Me.DisplayName = DisplayName
        Me.Value = Value

    End Sub

    Public Shared Function NewExportGroupExtension(ByVal exportGroup As ExportGroup, ByVal columnName As String, ByVal DisplayName As String, ByVal Value As String) As ExportGroupExtension
        Dim retVal As ExportGroupExtension = New ExportGroupExtension(exportGroup, columnName, DisplayName, Value)
        retVal.SetRules()
        Return retVal
    End Function

    Protected Overrides Sub SetParentProperty(ByVal colName As String, ByVal setValue As String)
        Select Case colName
            Case "MiscChar1"
                Me.ParentExportGroup.MiscChar1 = setValue
            Case "MiscChar1Name"
                Me.ParentExportGroup.MiscChar1Name = setValue
            Case "MiscChar2"
                Me.ParentExportGroup.MiscChar2 = setValue
            Case "MiscChar2Name"
                Me.ParentExportGroup.MiscChar2Name = setValue
            Case "MiscChar3"
                Me.ParentExportGroup.MiscChar3 = setValue
            Case "MiscChar3Name"
                Me.ParentExportGroup.MiscChar3Name = setValue
            Case "MiscChar4"
                Me.ParentExportGroup.MiscChar4 = setValue
            Case "MiscChar4Name"
                Me.ParentExportGroup.MiscChar4Name = setValue
            Case "MiscChar5"
                Me.ParentExportGroup.MiscChar5 = setValue
            Case "MiscChar5Name"
                Me.ParentExportGroup.MiscChar5Name = setValue
            Case "MiscChar6"
                Me.ParentExportGroup.MiscChar6 = setValue
            Case "MiscChar6Name"
                Me.ParentExportGroup.MiscChar6Name = setValue
            Case "MiscNum1"
                If Me.IsValid Then
                    Dim ndec As Nullable(Of Decimal)
                    Dim dec As Decimal = Nothing
                    Decimal.TryParse(setValue, dec)
                    ndec = dec
                    If setValue = "" Then
                        Me.ParentExportGroup.MiscNum1 = Nothing
                    Else
                        Me.ParentExportGroup.MiscNum1 = ndec
                    End If
                End If
            Case "MiscNum1Name"
                Me.ParentExportGroup.MiscNum1Name = setValue
            Case "MiscNum2"
                If Me.IsValid Then
                    Dim ndec As Nullable(Of Decimal)
                    Dim dec As Decimal = Nothing
                    Decimal.TryParse(setValue, dec)
                    ndec = dec
                    If setValue = "" Then
                        Me.ParentExportGroup.MiscNum2 = Nothing
                    Else
                        Me.ParentExportGroup.MiscNum2 = ndec
                    End If
                End If
            Case "MiscNum2Name"
                Me.ParentExportGroup.MiscNum2Name = setValue
            Case "MiscNum3"
                If Me.IsValid Then
                    Dim ndec As Nullable(Of Decimal)
                    Dim dec As Decimal = Nothing
                    Decimal.TryParse(setValue, dec)
                    ndec = dec
                    If setValue = "" Then
                        Me.ParentExportGroup.MiscNum3 = Nothing
                    Else
                        Me.ParentExportGroup.MiscNum3 = ndec
                    End If
                End If
            Case "MiscNum3Name"
                Me.ParentExportGroup.MiscNum3Name = setValue
            Case "MiscDate1"
                If Me.IsValid Then
                    Dim ndte As Nullable(Of Date)
                    Dim dte As Date
                    Date.TryParse(setValue, dte)
                    ndte = dte
                    'TryParse on an empty string will return #12:00AM#                    
                    If Not IsDate(setValue) Then
                        Me.ParentExportGroup.MiscDate1 = Nothing
                    Else
                        Me.ParentExportGroup.MiscDate1 = ndte
                    End If
                End If
            Case "MiscDate1Name"
                Me.ParentExportGroup.MiscDate1Name = setValue
            Case "MiscDate2"
                If Me.IsValid Then
                    Dim ndte As Nullable(Of Date)
                    Dim dte As Date
                    Date.TryParse(setValue, dte)
                    ndte = dte
                    'TryParse on an empty string will return #12:00AM#        
                    If Not IsDate(setValue) Then
                        Me.ParentExportGroup.MiscDate2 = Nothing
                    Else
                        Me.ParentExportGroup.MiscDate2 = ndte
                    End If
                End If
            Case "MiscDate2Name"
                Me.ParentExportGroup.MiscDate2Name = setValue
            Case "MiscDate3"
                If Me.IsValid Then
                    Dim ndte As Nullable(Of Date)
                    Dim dte As Date
                    Date.TryParse(setValue, dte)
                    ndte = dte
                    'TryParse on an empty string will return #12:00AM#        
                    If Not IsDate(setValue) Then
                        Me.ParentExportGroup.MiscDate3 = Nothing
                    Else
                        Me.ParentExportGroup.MiscDate3 = ndte
                    End If
                End If
            Case "MiscDate3Name"
                Me.ParentExportGroup.MiscDate3Name = setValue
        End Select
    End Sub



End Class
