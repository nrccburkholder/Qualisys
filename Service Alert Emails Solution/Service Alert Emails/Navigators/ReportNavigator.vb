Imports System.Collections.ObjectModel

Public Class ReportNavigator

    Public Event ReportSelected As EventHandler(Of ReportSelectedEventArgs)

    Private Sub Categories_SelectedIndexChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Categories.SelectedIndexChanged
        Dim selectedCategory As String = DirectCast(Categories.SelectedItem, String)
        Dim reportList() As KeyValuePair(Of String, Uri) = Nothing

        Select Case selectedCategory.ToUpper
            Case "ENTERTAINMENT"
                reportList = New KeyValuePair(Of String, Uri)() { _
                    New KeyValuePair(Of String, Uri)("MSN", New Uri("http://www.msn.com")), _
                    New KeyValuePair(Of String, Uri)("Netscape", New Uri("http://www.netscape.com")), _
                    New KeyValuePair(Of String, Uri)("The Onion", New Uri("http://www.theonion.com")), _
                    New KeyValuePair(Of String, Uri)("Yahoo", New Uri("http://www.yahoo.com")) _
                }
            Case "BUSINESS"
                reportList = New KeyValuePair(Of String, Uri)() { _
                    New KeyValuePair(Of String, Uri)("GHS Global", New Uri("http://www.ghsglobal.com")), _
                    New KeyValuePair(Of String, Uri)("HCMG", New Uri("http://www.hcmg.com")), _
                    New KeyValuePair(Of String, Uri)("National Research Corporation", New Uri("http://www.nationalresearch.com")), _
                    New KeyValuePair(Of String, Uri)("NRC+Picker", New Uri("http://nrcpicker.com")), _
                    New KeyValuePair(Of String, Uri)("Picker Symposium", New Uri("http://www.pickersymposium.com")) _
                }
            Case "SOFTWARE DEVELOPMENT"
                reportList = New KeyValuePair(Of String, Uri)() { _
                    New KeyValuePair(Of String, Uri)("MSDN", New Uri("http://www.msdn.com")), _
                    New KeyValuePair(Of String, Uri)("Code Project", New Uri("http://www.codeproject.com")), _
                    New KeyValuePair(Of String, Uri)("ASP.NET", New Uri("http://www.asp.net")) _
                }
            Case "WEATHER"
                reportList = New KeyValuePair(Of String, Uri)() { _
                    New KeyValuePair(Of String, Uri)("Weather.com", New Uri("http://www.weather.com/weather/local/68522?lswe=68522&lwsa=WeatherLocalUndeclared&from=whatwhere")), _
                    New KeyValuePair(Of String, Uri)("National Weather Service", New Uri("http://www.crh.noaa.gov/ifps/MapClick.php?CityName=Lincoln&state=NE&site=OAX")) _
                }
        End Select

        Me.Reports.Items.Clear()
        If reportList Is Nothing Then Exit Sub

        For Each report As KeyValuePair(Of String, Uri) In reportList
            Me.Reports.Items.Add(report)
        Next
    End Sub

    Private Sub Reports_SelectedIndexChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Reports.SelectedIndexChanged
        Dim selectedReport As KeyValuePair(Of String, Uri)

        selectedReport = DirectCast(Me.Reports.SelectedItem, KeyValuePair(Of String, Uri))

        RaiseEvent ReportSelected(Me, New ReportSelectedEventArgs(selectedReport.Key, selectedReport.Value))
    End Sub

    Private Sub ReportNavigator_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        Me.Categories.SelectedIndex = 0
    End Sub
End Class
