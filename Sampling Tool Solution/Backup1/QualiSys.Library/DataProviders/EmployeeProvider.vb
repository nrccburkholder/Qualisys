Namespace DataProvider

    Public MustInherit Class EmployeeProvider

#Region " Singleton Implementation "

        Private Shared mInstance As EmployeeProvider
        Private Const mProviderName As String = "EmployeeProvider"

        Public Shared ReadOnly Property Instance() As EmployeeProvider
            Get
                If mInstance Is Nothing Then
                    mInstance = DataProviderFactory.CreateInstance(Of EmployeeProvider)(mProviderName)
                End If

                Return mInstance
            End Get
        End Property

#End Region

        Protected Sub New()

        End Sub

        Public MustOverride Function [Select](ByVal employeeId As Integer) As Employee
        Public MustOverride Function SelectByLoginName(ByVal loginName As String) As Employee
        Public MustOverride Function SelectAllEmployees() As EmployeeCollection
        Public MustOverride Function SelectAllUnAuthEmployees(ByVal studyID As Integer) As EmployeeCollection

    End Class

End Namespace
