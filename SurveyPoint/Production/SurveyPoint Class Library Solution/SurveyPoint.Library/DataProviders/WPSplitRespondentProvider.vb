Namespace DataProviders
    ''' <summary>Abstract class that holds stubs for DAL Calls.</summary>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public MustInherit Class WPSplitRespondentProvider

#Region " Singleton Implementation "
        Private Shared mInstance As WPSplitRespondentProvider
        Private Const mProviderName As String = "WPSplitRespondentProvider"
        ''' <summary>Retrieves the instance of the Data provider class that will implement the astract methods.</summary>
        ''' <value></value>
        ''' <CreatedBy>Tony Piccoli</CreatedBy>
        ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
        Public Shared ReadOnly Property Instance() As WPSplitRespondentProvider
            Get
                If mInstance Is Nothing Then
                    mInstance = DataProviderFactory.CreateInstance(Of WPSplitRespondentProvider)(mProviderName)
                End If

                Return mInstance
            End Get
        End Property
#End Region

        Protected Sub New()
        End Sub


        Public MustOverride Function GetDuplicateRespondents(ByVal id As String, ByVal clientID As Integer, ByVal surveyInstanceStartDate As Nullable(Of Date)) As WPSplitRespondentCollection
        Public MustOverride Sub InsertWPRespondentForDupCheck(ByVal id As String, ByVal firstName As String, ByVal lastName As String, ByVal dob As Nullable(Of Date))        
    End Class

End Namespace