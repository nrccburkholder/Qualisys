Imports NRC.Framework.BusinessLogic

Namespace DataProvider

    Public MustInherit Class ToBeSeededProvider

#Region " Singleton Implementation "

        Private Shared mInstance As ToBeSeededProvider
        Private Const mProviderName As String = "ToBeSeededProvider"

        Public Shared ReadOnly Property Instance() As ToBeSeededProvider
            Get
                If mInstance Is Nothing Then
                    mInstance = DataProviderFactory.CreateInstance(Of ToBeSeededProvider)(mProviderName)
                End If

                Return mInstance
            End Get
        End Property
#End Region

#Region " Constructors "

        Protected Sub New()

        End Sub

#End Region

#Region " Public MustOverride Methods "

        Public MustOverride Function SelectToBeSeeded(ByVal seedId As Integer) As ToBeSeeded
        Public MustOverride Function SelectAllToBeSeededs() As ToBeSeededCollection
        Public MustOverride Function InsertToBeSeeded(ByVal instance As ToBeSeeded) As Integer
        Public MustOverride Sub UpdateToBeSeeded(ByVal instance As ToBeSeeded)
        Public MustOverride Sub DeleteToBeSeeded(ByVal ToBeSeeded As ToBeSeeded)
        Public MustOverride Function SelectToBeSeededBySurveyIDYearQtr(ByVal surveyId As Integer, ByVal yrQtr As String) As ToBeSeeded
        Public MustOverride Function IsTimeToPopulateForQuarter(ByVal yrQtr As String) As Boolean
        Public MustOverride Function SelectToBeSeededsIncompleteByYearQtr(ByVal yrQtr As String) As ToBeSeededCollection

#End Region

    End Class

End Namespace
