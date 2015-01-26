Imports NRC.Framework.BusinessLogic

'This class should go to your .Library project
Public MustInherit Class STUDY_EMPLOYEEProvider

#Region " Singleton Implementation "
    Private Shared mInstance As STUDY_EMPLOYEEProvider
	Private Const mProviderName As String = "STUDY_EMPLOYEEProvider"
	Public Shared ReadOnly Property Instance() As STUDY_EMPLOYEEProvider
        Get
            If mInstance Is Nothing Then
                mInstance = DataProvider.DataProviderFactory.CreateInstance(Of STUDY_EMPLOYEEProvider)(mProviderName)
            End If

            Return mInstance
        End Get
    End Property
#End Region

	Protected Sub New()
	End Sub

	Public MustOverride Function SelectSTUDY_EMPLOYEE(ByVal eMPLOYEEId As Integer) As STUDY_EMPLOYEE
	Public MustOverride Function SelectAllSTUDY_EMPLOYEEs() As STUDY_EMPLOYEECollection
	Public MustOverride Function SelectSTUDY_EMPLOYEEsByEMPLOYEEId(ByVal eMPLOYEEId As Integer) As STUDY_EMPLOYEECollection
	Public MustOverride Function SelectSTUDY_EMPLOYEEsBySTUDYId(ByVal sTUDYId As Integer) As STUDY_EMPLOYEECollection
	Public MustOverride Function InsertSTUDY_EMPLOYEE(ByVal instance As STUDY_EMPLOYEE) As Integer
	Public MustOverride Sub UpdateSTUDY_EMPLOYEE(ByVal instance As STUDY_EMPLOYEE)
	Public MustOverride Sub DeleteSTUDY_EMPLOYEE(ByVal STUDY_EMPLOYEE As STUDY_EMPLOYEE)
    Public MustOverride Function SelectAllFullAccessSTUDY_EMPLOYEEs() As STUDY_EMPLOYEECollection
End Class

