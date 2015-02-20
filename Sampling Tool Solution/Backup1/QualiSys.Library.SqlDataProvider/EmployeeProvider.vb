Imports Nrc.Framework.Data
Imports Nrc.Framework.BusinessLogic
Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports System.Data.Common

Friend Class EmployeeProvider
    Inherits Nrc.QualiSys.Library.DataProvider.EmployeeProvider

    Private Function PopulateEmployee(ByVal rdr As SafeDataReader) As Employee

        Dim newObject As Employee = Employee.NewEmployee
        Dim privateInterface As IEmployee = newObject
        newObject.BeginPopulate()
        privateInterface.Id = rdr.GetInteger("Employee_id")
        newObject.FirstName = rdr.GetString("strEmployee_First_nm")
        newObject.LastName = rdr.GetString("strEmployee_Last_nm")
        newObject.Title = rdr.GetString("strEmployee_Title")
        newObject.NTLoginName = rdr.GetString("strNTLogin_nm")
        newObject.Email = rdr.GetString("strEmail")
        newObject.EndPopulate()

        Return newObject

    End Function

    Public Overrides Function [Select](ByVal employeeId As Integer) As Employee

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectEmployee, employeeId)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            If Not rdr.Read Then
                Return Nothing
            Else
                Return PopulateEmployee(rdr)
            End If
        End Using

    End Function

    Public Overrides Function SelectByLoginName(ByVal loginName As String) As Employee

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectEmployeeByLoginName, loginName)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            If Not rdr.Read Then
                Return Nothing
            Else
                Return PopulateEmployee(rdr)
            End If
        End Using

    End Function

    Public Overrides Function SelectAllEmployees() As EmployeeCollection

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectAllEmployees)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            Return PopulateCollection(Of EmployeeCollection, Employee)(rdr, AddressOf PopulateEmployee)
        End Using

    End Function

    Public Overrides Function SelectAllUnAuthEmployees(ByVal studyID As Integer) As EmployeeCollection

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectAllUnAuthEmployees, studyID)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            Return PopulateCollection(Of EmployeeCollection, Employee)(rdr, AddressOf PopulateEmployee)
        End Using

    End Function

End Class
