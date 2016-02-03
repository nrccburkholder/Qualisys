Imports system.text
Imports System.IO
Public Class VRTFileExpandSection

    Private Sub VRTFileExpandSection_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim sb As New StringBuilder
        sb.AppendLine("This tabs takes a VRT short file (see the string below for example of format).")
        sb.AppendLine(" 20090423 GSHQ02040006504838265   12511121212211121")
        sb.AppendLine("And converts it to match file def 489.")
        Me.txtDescription.Text = sb.ToString
    End Sub

    Private Sub cmdSource_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdSource.Click
        Dim result As DialogResult = Me.OpenFileDialog1.ShowDialog
        If result = DialogResult.OK Then
            Me.txtSource.Text = Me.OpenFileDialog1.FileName
        End If
    End Sub

    Private Sub cmdDestination_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdDestination.Click
        Dim result As DialogResult = Me.SaveFileDialog1.ShowDialog
        If result = DialogResult.OK Then
            Me.txtDestination.Text = Me.SaveFileDialog1.FileName
        End If
    End Sub

    Private Sub cmdExecute_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdExecute.Click
        Dim myReader As StreamReader = Nothing
        Dim myWriter As StreamWriter = Nothing        
        Try
            If Me.txtSource.Text.Length > 0 AndAlso Me.txtDestination.Text.Length Then
                If System.IO.File.Exists(Me.txtSource.Text) Then
                    Dim lst As New List(Of String)
                    myReader = New StreamReader(Me.txtSource.Text)
                    Do While myReader.Peek >= 0
                        Dim tempString As String = myReader.ReadLine
                        If tempString.Length > 0 Then
                            lst.Add(tempString)
                        End If
                    Loop
                    myReader.Close()
                    myReader = Nothing
                    myWriter = New StreamWriter(Me.txtDestination.Text)
                    For Each item As String In lst
                        Dim sb As New StringBuilder
                        sb.Append(item.Substring(0, 32))
                        sb.Append(PadString(154))
                        sb.Append(item.Substring(34, 1))    '1
                        sb.Append(PadString(6))
                        sb.Append(item.Substring(35, 1))    '2
                        sb.Append(PadString(1))
                        sb.Append(item.Substring(36, 1))    '3
                        sb.Append(PadString(1))
                        sb.Append(item.Substring(43, 1))    '4   
                        sb.Append(PadString(6))
                        sb.Append(item.Substring(44, 1))    '5
                        sb.Append(PadString(92))
                        sb.Append(item.Substring(37, 1))    '6                        
                        sb.Append(item.Substring(38, 1))    '7                        
                        sb.Append(item.Substring(39, 1))    '8
                        sb.Append(item.Substring(40, 1))    '9
                        sb.Append(item.Substring(41, 1))    '10
                        sb.Append(PadString(87))
                        sb.Append(item.Substring(50, 1))    '11
                        sb.Append(item.Substring(47, 1))    '12
                        sb.Append(item.Substring(48, 1))    '13
                        sb.Append(item.Substring(49, 1))    '14
                        sb.Append(item.Substring(46, 1))    '15
                        sb.Append(PadString(15))
                        sb.Append(item.Substring(42, 1))    '16
                        sb.Append(item.Substring(45, 1))    '17     
                        sb.Append(PadString(1118))
                        myWriter.WriteLine(sb.ToString())
                    Next
                    myWriter.Close()
                    myWriter = Nothing
                    txtDescription.Text += vbCrLf & "File Successfully created."
                End If
            End If
        Catch ex As System.Exception
            Globals.ReportException(ex)
        Finally
            If myReader IsNot Nothing Then
                myReader.Close()
                myReader = Nothing
            End If
            If myWriter IsNot Nothing Then
                myWriter.Close()
                myWriter = Nothing
            End If
        End Try
    End Sub
    Private Function PadString(ByVal number As Integer) As String
        Dim str As String = String.Empty
        For i As Integer = 1 To number
            str += " "
        Next
        Return str
    End Function
End Class
