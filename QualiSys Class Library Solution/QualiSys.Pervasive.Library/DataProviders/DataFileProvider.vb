Imports NRC.Framework.BusinessLogic

'This class should go to your .Library project
Public MustInherit Class DataFileProvider

#Region " Singleton Implementation "
    Private Shared mInstance As DataFileProvider
	Private Const mProviderName As String = "DataFileProvider"
	Public Shared ReadOnly Property Instance() As DataFileProvider
        Get
            If mInstance Is Nothing Then
				mInstance = DataProviderFactory.CreateInstance(Of DataFileProvider)(mProviderName)
            End If

            Return mInstance
        End Get
    End Property
#End Region

	Protected Sub New()
	End Sub

	Public MustOverride Function SelectDataFile(ByVal id As Integer) As DataFile
	Public MustOverride Function SelectAllDataFiles() As DataFileCollection
	Public MustOverride Function InsertDataFile(ByVal instance As DataFile) As Integer
	Public MustOverride Sub UpdateDataFile(ByVal instance As DataFile)
    Public MustOverride Sub DeleteDataFile(ByVal instance As DataFile)
    Public MustOverride Sub Apply(ByVal instance As DataFile)
    Public MustOverride Function Validate(ByVal instance As DataFile) As Boolean
    Public MustOverride Function CheckForDuplicateCCNInSampleMonth(ByVal instance As DataFile) As Integer
    Public MustOverride Sub DisableAutoSampling(ByVal instance As DataFile)
    Public MustOverride Sub UnscheduleSampleSet(ByVal instance As DataFile)

End Class

