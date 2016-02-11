Imports System.Collections.ObjectModel

Namespace DataProviders

    Public MustInherit Class UpdateFileLogProvider

#Region " Singleton Implementation "

        Private Shared mInstance As UpdateFileLogProvider
        Private Const mProviderName As String = "UpdateFileLogProvider"

        Public Shared ReadOnly Property Instance() As UpdateFileLogProvider
            Get
                If mInstance Is Nothing Then
                    mInstance = DataProviderFactory.CreateInstance(Of UpdateFileLogProvider)(mProviderName)
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

        Public MustOverride Function SelectAll() As UpdateFileLogCollection
        Public MustOverride Function SelectByDate(ByVal minDate As Date, ByVal maxDate As Date) As UpdateFileLogCollection
        Public MustOverride Function SelectAllUpdatedRespondents(ByVal fileLogID As Integer) As String()
        Public MustOverride Sub Insert(ByVal obj As UpdateFileLog)
        Public MustOverride Sub InsertRespondent(ByVal respondentID As Integer, ByVal fileLogID As Integer)

#End Region

    End Class

End Namespace

