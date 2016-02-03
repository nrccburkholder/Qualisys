Imports Nrc.Framework.BusinessLogic
Imports Nrc.SurveyPoint.Library.DataProviders

Public Interface IClientExtension
    Property ClientExtensionID() As Integer
End Interface


Public Class ExportClientExtension
    Inherits ExportExtension

    Dim mParentExportClient As ExportClientSelected

    Private Property ParentExportClient() As ExportClientSelected
        Get
            Return mParentExportClient
        End Get
        Set(ByVal value As ExportClientSelected)
            mParentExportClient = value
        End Set
    End Property

    Private Sub New(ByVal ExportClient As ExportClientSelected, ByVal ColumnName As String, ByVal DisplayName As String, ByVal Value As String)

        Me.ParentExportClient = ExportClient
        Me.ColumnName = ColumnName
        Me.DisplayName = DisplayName
        Me.Value = Value

    End Sub

    Public Shared Function NewExportClientExtension(ByVal ExportClient As ExportClientSelected, ByVal columnName As String, ByVal DisplayName As String, ByVal Value As String) As ExportClientExtension
        'TP set the validation 20080304
        Dim retVal As ExportClientExtension = New ExportClientExtension(ExportClient, columnName, DisplayName, Value)
        retVal.SetRules()
        Return retVal
    End Function

    Protected Overrides Sub SetParentProperty(ByVal colName As String, ByVal setValue As String)
        Select Case colName
            Case "MiscChar1"
                Me.ParentExportClient.MiscChar1 = setValue
            Case "MiscChar1Name"
                Me.ParentExportClient.MiscChar1Name = setValue
            Case "MiscChar2"
                Me.ParentExportClient.MiscChar2 = setValue
            Case "MiscChar2Name"
                Me.ParentExportClient.MiscChar2Name = setValue
            Case "MiscChar3"
                Me.ParentExportClient.MiscChar3 = setValue
            Case "MiscChar3Name"
                Me.ParentExportClient.MiscChar3Name = setValue
            Case "MiscChar4"
                Me.ParentExportClient.MiscChar4 = setValue
            Case "MiscChar4Name"
                Me.ParentExportClient.MiscChar4Name = setValue
            Case "MiscChar5"
                Me.ParentExportClient.MiscChar5 = setValue
            Case "MiscChar5Name"
                Me.ParentExportClient.MiscChar5Name = setValue
            Case "MiscChar6"
                Me.ParentExportClient.MiscChar6 = setValue
            Case "MiscChar6Name"
                Me.ParentExportClient.MiscChar6Name = setValue
            Case "MiscNum1"
                If Me.IsValid Then
                    Dim ndec As Nullable(Of Decimal)
                    Dim dec As Decimal = Nothing
                    Decimal.TryParse(setValue, dec)
                    ndec = dec
                    If setValue = "" Then
                        Me.ParentExportClient.MiscNum1 = Nothing
                    Else
                        Me.ParentExportClient.MiscNum1 = ndec
                    End If
                End If
            Case "MiscNum1Name"
                Me.ParentExportClient.MiscNum1Name = setValue
            Case "MiscNum2"
                If Me.IsValid Then
                    Dim ndec As Nullable(Of Decimal)
                    Dim dec As Decimal = Nothing
                    Decimal.TryParse(setValue, dec)
                    ndec = dec
                    If setValue = "" Then
                        Me.ParentExportClient.MiscNum2 = Nothing
                    Else
                        Me.ParentExportClient.MiscNum2 = ndec
                    End If
                End If
            Case "MiscNum2Name"
                Me.ParentExportClient.MiscNum2Name = setValue
            Case "MiscNum3"
                If Me.IsValid Then
                    Dim ndec As Nullable(Of Decimal)
                    Dim dec As Decimal = Nothing
                    Decimal.TryParse(setValue, dec)
                    ndec = dec
                    If setValue = "" Then
                        Me.ParentExportClient.MiscNum3 = Nothing
                    Else
                        Me.ParentExportClient.MiscNum3 = ndec
                    End If
                End If
            Case "MiscNum3Name"
                Me.ParentExportClient.MiscNum3Name = setValue
            Case "MiscDate1"
                If Me.IsValid Then
                    Dim ndte As Nullable(Of Date)
                    Dim dte As Date
                    Date.TryParse(setValue, dte)
                    ndte = dte                    
                    'TryParse on an empty string will return #12:00AM#        
                    If Not IsDate(setValue) Then
                        Me.ParentExportClient.MiscDate1 = Nothing
                    Else
                        Me.ParentExportClient.MiscDate1 = ndte
                    End If
                End If
            Case "MiscDate1Name"
                Me.ParentExportClient.MiscDate1Name = setValue
            Case "MiscDate2"
                If Me.IsValid Then
                    Dim ndte As Nullable(Of Date)
                    Dim dte As Date
                    Date.TryParse(setValue, dte)
                    ndte = dte
                    'TryParse on an empty string will return #12:00AM#        
                    If Not IsDate(setValue) Then
                        Me.ParentExportClient.MiscDate2 = Nothing
                    Else
                        Me.ParentExportClient.MiscDate2 = ndte
                    End If
                End If
            Case "MiscDate2Name"
                Me.ParentExportClient.MiscDate2Name = setValue
            Case "MiscDate3"
                If Me.IsValid Then
                    Dim ndte As Nullable(Of Date)
                    Dim dte As Date
                    Date.TryParse(setValue, dte)
                    ndte = dte
                    'TryParse on an empty string will return #12:00AM#        
                    If Not IsDate(setValue) Then
                        Me.ParentExportClient.MiscDate3 = Nothing
                    Else
                        Me.ParentExportClient.MiscDate3 = ndte
                    End If
                End If
            Case "MiscDate3Name"
                Me.ParentExportClient.MiscDate3Name = setValue
        End Select
    End Sub

End Class
