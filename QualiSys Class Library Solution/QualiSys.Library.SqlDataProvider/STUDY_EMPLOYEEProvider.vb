'********************************************************************************
' Concrete SqlProvider Class
'********************************************************************************
Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports System.Data.Common
Imports NRC.Framework.Data


Friend Class STUDY_EMPLOYEEProvider
    Inherits QualiSys.Library.STUDY_EMPLOYEEProvider

    Private ReadOnly Property Db() As Database
        Get
            Return Globals.Db
        End Get
    End Property


#Region " STUDY_EMPLOYEE Procs "

    Private Function PopulateSTUDY_EMPLOYEE(ByVal rdr As SafeDataReader) As STUDY_EMPLOYEE
        Dim newObject As STUDY_EMPLOYEE = STUDY_EMPLOYEE.NewSTUDY_EMPLOYEE
        Dim privateInterface As ISTUDY_EMPLOYEE = newObject
        newObject.BeginPopulate()
        privateInterface.EMPLOYEEId = rdr.GetInteger("EMPLOYEE_ID")
        privateInterface.STUDYId = rdr.GetInteger("STUDY_ID")
        newObject.EmployeeName = rdr.GetString("EMPLOYEENAME")
        newObject.EndPopulate()
        Return newObject
    End Function

    Public Overrides Function SelectSTUDY_EMPLOYEE(ByVal eMPLOYEEId As Integer) As STUDY_EMPLOYEE
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectStudyEmployee, eMPLOYEEId)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            If Not rdr.Read Then
                Return Nothing
            Else
                Return PopulateSTUDY_EMPLOYEE(rdr)
            End If
        End Using
    End Function

    Public Overrides Function SelectAllSTUDY_EMPLOYEEs() As STUDY_EMPLOYEECollection
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectAllStudyEmployees)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            Return PopulateCollection(Of STUDY_EMPLOYEECollection, STUDY_EMPLOYEE)(rdr, AddressOf PopulateSTUDY_EMPLOYEE)
        End Using
    End Function

    Public Overrides Function SelectSTUDY_EMPLOYEEsByEMPLOYEEId(ByVal eMPLOYEEId As Integer) As STUDY_EMPLOYEECollection
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectStudyEmployeesByEmployeeId, eMPLOYEEId)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            Return PopulateCollection(Of STUDY_EMPLOYEECollection, STUDY_EMPLOYEE)(rdr, AddressOf PopulateSTUDY_EMPLOYEE)
        End Using
    End Function

    Public Overrides Function SelectSTUDY_EMPLOYEEsBySTUDYId(ByVal sTUDYId As Integer) As STUDY_EMPLOYEECollection
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectStudyEmployeesByStudyId, sTUDYId)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            Return PopulateCollection(Of STUDY_EMPLOYEECollection, STUDY_EMPLOYEE)(rdr, AddressOf PopulateSTUDY_EMPLOYEE)
        End Using
    End Function

    Public Overrides Function InsertSTUDY_EMPLOYEE(ByVal instance As STUDY_EMPLOYEE) As Integer
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.InsertStudyEmployee, instance.EMPLOYEEId, instance.STUDYId)
        Return ExecuteInteger(cmd)
    End Function

    Public Overrides Sub UpdateSTUDY_EMPLOYEE(ByVal instance As STUDY_EMPLOYEE)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.UpdateStudyEmployee, instance.EMPLOYEEId, instance.STUDYId)
        ExecuteNonQuery(cmd)
    End Sub

    Public Overrides Sub DeleteSTUDY_EMPLOYEE(ByVal instance As STUDY_EMPLOYEE)
        If instance IsNot Nothing Then
            Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.DeleteStudyEmployee, instance.EMPLOYEEId, instance.STUDYId)
            ExecuteNonQuery(cmd)
        End If
    End Sub

    Public Overrides Function SelectAllFullAccessSTUDY_EMPLOYEEs() As STUDY_EMPLOYEECollection
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectAllFullAccessStudyEmployees)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            Return PopulateCollection(Of STUDY_EMPLOYEECollection, STUDY_EMPLOYEE)(rdr, AddressOf PopulateSTUDY_EMPLOYEE)
        End Using
    End Function
#End Region

End Class
