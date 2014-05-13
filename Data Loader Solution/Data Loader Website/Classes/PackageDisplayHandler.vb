Imports NRC.Qualisys.QLoader.Library
Public Class PackageDisplayHandler

    Private Const _SplitAtLen As Integer = 20
    Private Const _Delimeter As String = "|"
    Private Const _LineBreak As String = "<br />"
    Private Const _SplitAtLenDelimeter As String = "-"

    Public Shared Function FriendlyPackageDisplay(ByVal PackageList As String()) As String
        Return CreateString(PackageList)
    End Function


    Private Shared Function CreateString(ByVal PackList As String()) As String
        Dim retstring As String = String.Empty
        If PackList.Length = 2 Then
            retstring = DTSPackage.GetPackageByID(CInt(Trim(PackList(0).ToString))).PackageFriendlyName
            retstring = ParseIfToLong(retstring)
        Else
            For x As Integer = 0 To PackList.Length - 2
                Dim totlength As Integer = PackList.Length - 2
                If PackList(x).Replace(" ", "") <> "" And PackList(x).Replace(" ", "") <> "|" Then
                    Dim packFname As String = DTSPackage.GetPackageByID(CInt(Trim(PackList(x).ToString))).PackageFriendlyName
                    If x = totlength Then
                        retstring &= ParseIfToLong(packFname)
                    Else
                        retstring &= ParseIfToLong(packFname) & _Delimeter & _LineBreak
                    End If
                End If
            Next
        End If
        Return retstring
    End Function


    Private Shared Function ParseIfToLong(ByVal txt As String) As String
        Dim retstring As String = String.Empty
        If Len(txt) > _SplitAtLen Then
            retstring = Left(txt, _SplitAtLen) & _SplitAtLenDelimeter & _LineBreak & _
                       Right(txt, Len(txt) - _SplitAtLen)
        Else
            retstring = txt
        End If
        Return retstring
    End Function

End Class
