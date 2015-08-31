Imports Microsoft.VisualBasic
Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Collections
Imports System.Runtime.InteropServices

Namespace CommentsSAEmailServer
    Public Class clsEmailEntries
        Inherits CollectionBase
        ' Methods
        Public Sub Add(ByVal objEmailEntry As clsEmailEntry)
            Me.List.Add(objEmailEntry)
        End Sub

        Public Sub Add(ByVal intClientUserID As Integer, ByVal strLithoCode As String, ByVal strEmailList As String, ByVal strAcctDirector As String, ByVal intEmailFormat As Integer)
            Dim current As clsEmailEntry
            Dim flag As Boolean = False
            Dim enumerator As IEnumerator = Me.List.GetEnumerator
            Do While enumerator.MoveNext
                current = DirectCast(enumerator.Current, clsEmailEntry)
                If (current.ClientUserID = intClientUserID) Then
                    flag = True
                    Dim entry3 As clsEmailEntry = current
                    entry3.LithoCodeList = StringType.FromObject(ObjectType.StrCatObj(entry3.LithoCodeList, ObjectType.StrCatObj(Interaction.IIf((current.LithoCodeList.Length = 0), "", ","), strLithoCode)))
                    GoTo Label_0090
                End If
            Loop
Label_0090:
            If Not flag Then
                current = New clsEmailEntry
                Dim entry2 As clsEmailEntry = current
                entry2.ClientUserID = intClientUserID
                entry2.LithoCodeList = strLithoCode
                entry2.EmailList = strEmailList
                entry2.AcctDirector = strAcctDirector
                entry2.EmailFormat.FormatID = intEmailFormat
                entry2 = Nothing
                Me.Add(current)
            End If
        End Sub

        Public Sub Add(ByVal intClientUserID As Integer, ByVal strLithoList As String, ByVal strEmailList As String, ByVal strAcctDirector As String, ByVal intEmailFormat As Integer, ByVal datDateSent As DateTime)
            Dim objEmailEntry As New clsEmailEntry
            Dim entry2 As clsEmailEntry = objEmailEntry
            entry2.ClientUserID = intClientUserID
            entry2.LithoCodeList = strLithoList
            entry2.EmailList = strEmailList
            entry2.AcctDirector = strAcctDirector
            entry2.EmailFormat.FormatID = intEmailFormat
            entry2.DateSent = datDateSent
            entry2 = Nothing
            Me.Add(objEmailEntry)
        End Sub

        Public Sub Remove(ByVal intIndex As Integer)
            If Not ((intIndex > (Me.Count - 1)) Or (intIndex < 0)) Then
                Me.List.RemoveAt(intIndex)
            End If
        End Sub

        Public Sub SendAllEmails(ByVal Optional bolTo As Boolean = True, ByVal Optional bolCC As Boolean = True)
            modMain.WriteLogEntry("Sending all emails in silent mode")
            Dim entry As clsEmailEntry
            For Each entry In Me.List
                Dim num As Integer
                num += 1
                entry.SendEmail(bolTo, bolCC, num)
            Next
            modMain.WriteLogEntry("End of Send all emails in silent mode")
        End Sub


        ' Properties
        Public ReadOnly Property CountToBeSent As Integer
            Get
                Dim num2 As Integer
                Dim entry As clsEmailEntry
                For Each entry In Me.List
                    If entry.PrivSAEMail Then
                        num2 += 1
                    End If
                Next
                Return num2
            End Get
        End Property

        Public ReadOnly Property Item(ByVal intIndex As Integer) As clsEmailEntry
            Get
                If ((intIndex > (Me.Count - 1)) Or (intIndex < 0)) Then
                    Return Nothing
                End If
                Return DirectCast(Me.List.Item(intIndex), clsEmailEntry)
            End Get
        End Property

    End Class
End Namespace

