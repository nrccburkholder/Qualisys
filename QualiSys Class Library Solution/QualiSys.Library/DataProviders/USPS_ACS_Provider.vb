
Namespace DataProvider


    Public MustInherit Class USPS_ACS_Provider
#Region " Singleton Implementation "

        Private Shared mInstance As USPS_ACS_Provider
        Private Const mProviderName As String = "USPS_ACS_Provider"

        Public Shared ReadOnly Property Instance() As USPS_ACS_Provider
            Get
                If mInstance Is Nothing Then
                    mInstance = DataProviderFactory.CreateInstance(Of USPS_ACS_Provider)(mProviderName)
                End If

                Return mInstance
            End Get
        End Property

#End Region

#Region "Public Must Override Methods"

        Public MustOverride Function SelectByStatus(ByVal status As Integer) As List(Of USPS_PartialMatch)
        Public MustOverride Function SelectPartialMatchesByStatus(ByVal status As Integer, ByVal fromDate As String, ByVal toDate As String) As DataSet
        Public MustOverride Sub UpdatePartialMatchStatus(ByVal id As Integer, ByVal status As Integer)

#End Region
    End Class

End Namespace