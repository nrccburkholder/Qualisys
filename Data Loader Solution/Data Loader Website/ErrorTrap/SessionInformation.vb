Imports NRC.NRCAuthLib

Public Class SessionInformation

    Private Enum SessionKeys
        LastException
    End Enum

#Region " Item Get/Set "
    Private Shared Function GetItem(ByVal key As SessionKeys) As Object
        Return HttpContext.Current.Session(key.ToString)
    End Function

    Private Shared Function GetItem(Of T)(ByVal key As SessionKeys) As T
        Return CType(GetItem(key), T)
    End Function

    Private Shared Sub SetItem(ByVal key As SessionKeys, ByVal value As Object)
        HttpContext.Current.Session(key.ToString) = value
    End Sub
#End Region

    Public Shared Property LastException() As Exception
        Get
            Return GetItem(Of Exception)(SessionKeys.LastException)
        End Get
        Set(ByVal value As Exception)
            SetItem(SessionKeys.LastException, value)
        End Set
    End Property

End Class
