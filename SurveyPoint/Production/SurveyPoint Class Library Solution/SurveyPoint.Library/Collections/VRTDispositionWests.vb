Imports Nrc.Framework.BusinessLogic
Imports System.Text

<Serializable()> _
Public Class VRTDispositionWests
    Inherits BusinessListBase(Of VRTDispositionWests, VRTDispositionWest)
    Dim msgs As New StringBuilder()

    Public Function ProcessVRTDispositionWestImport() As StringBuilder
        Try
            For i As Integer = 0 To Me.Count - 1
                Dim msg As String = Me(i).ImportLine(i)
                If msg <> String.Empty AndAlso msg <> "" Then
                    msgs.AppendLine(msg)
                End If
            Next
        Catch ex As System.Exception
            msgs.AppendLine(ex.Message)
        End Try
        Return msgs
    End Function

    Public Function GenericCount() As Integer
        Return Me.Count
    End Function
End Class

