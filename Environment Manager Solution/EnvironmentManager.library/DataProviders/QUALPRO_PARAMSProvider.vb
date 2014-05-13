Imports NRC.Framework.BusinessLogic

'This class should go to your .Library project
Public MustInherit Class QualproParamsProvider

#Region " Singleton Implementation "
    Private Shared mInstance As QualproParamsProvider
    Private Const mProviderName As String = "QUALPRO_PARAMSProvider"
    Private mQualisysConnectionString As String

    Public Shared ReadOnly Property Instance() As QualproParamsProvider
        Get
            If mInstance Is Nothing Then
                mInstance = DataProviderFactory.CreateInstance(Of QualproParamsProvider)(mProviderName)
            End If

            Return mInstance
        End Get
    End Property
    Public Property QualisysConnectionString() As String
        Get
            Return mQualisysConnectionString
        End Get
        Set(ByVal value As String)
            mQualisysConnectionString = value
        End Set
    End Property
#End Region

    Protected Sub New()
    End Sub

    Public MustOverride Function SelectQUALPRO_PARAMS(ByVal pARAMId As Integer) As QualproParams
    Public MustOverride Function SelectAllQUALPRO_PARAMS() As QUALPRO_PARAMSCollection
    Public MustOverride Function InsertQUALPRO_PARAMS(ByVal instance As QualproParams) As Integer
    Public MustOverride Sub UpdateQUALPRO_PARAMS(ByVal instance As QualproParams)
    Public MustOverride Sub DeleteQualproParams(ByVal QUALPRO_PARAMS As QualproParams)
    Public MustOverride Function SelectParamByName(ByVal ParamName As String) As QualproParams
    Public MustOverride Function SelectParamsLike(ByVal ParamName As String) As QUALPRO_PARAMSCollection
End Class

