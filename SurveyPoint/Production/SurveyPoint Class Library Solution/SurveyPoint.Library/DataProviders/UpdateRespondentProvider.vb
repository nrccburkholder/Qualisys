Imports System.Collections.ObjectModel

Namespace DataProviders

    Public MustInherit Class UpdateRespondentProvider

#Region " Singleton Implementation "

        Private Shared mInstance As UpdateRespondentProvider
        Private Const mProviderName As String = "UpdateRespondentProvider"

        Public Shared ReadOnly Property Instance() As UpdateRespondentProvider
            Get
                If mInstance Is Nothing Then
                    mInstance = DataProviderFactory.CreateInstance(Of UpdateRespondentProvider)(mProviderName)
                End If

                Return mInstance
            End Get
        End Property

#End Region

#Region "Constructors"

        Protected Sub New()

        End Sub

#End Region

#Region "CRUD Methods"

        Public MustOverride Function [Select](ByVal id As Integer) As UpdateRespondent
        Public MustOverride Function SelectByAlreadyUpdated(ByVal respondentIDs As String) As UpdateRespondentCollection
        Public MustOverride Function SelectByMissingStartCodes(ByVal respondentIDs As String, ByVal importDate As Date) As UpdateRespondentCollection
        Public MustOverride Function UpdateMissingEventCodes(ByVal respondentIDs As String) As UpdateRespondentCollection
        Public MustOverride Function UpdateMapping(ByVal respondentID As Integer, ByVal oldEventCode As Integer, ByVal newEventCode As Integer) As Integer

#End Region

    End Class

End Namespace

