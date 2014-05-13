Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports Nrc.Framework.Data
Imports Nrc.QualiSys.Library

Public Class SampleUnitServiceTypeProvider
    Inherits Nrc.QualiSys.Library.DataProvider.SampleUnitServiceTypeProvider

    Public Overrides Function SelectServiceTypes() As System.Collections.ObjectModel.Collection(Of SampleUnitServiceType)
        Dim serviceTypes As New Collection(Of SampleUnitServiceType)
        Dim id As Integer
        Dim parentId As Integer
        Dim name As String
        Dim serviceType As SampleUnitServiceType
        Dim parentServiceType As SampleUnitServiceType

        Dim cmd As DBCommand = Db.GetStoredProcCommand(SP.SelectServiceTypes)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            Do While rdr.Read
                id = rdr.GetInteger("Service_ID")
                parentId = rdr.GetInteger("ParentService_id", 0)
                name = rdr.GetString("strService_nm")

                If (parentId = 0) Then
                    serviceType = New SampleUnitServiceType(id, name)
                    serviceTypes.Add(serviceType)
                Else
                    parentServiceType = Library.SampleUnitServiceType.FindServiceTypeById(serviceTypes, parentId)
                    If (parentServiceType IsNot Nothing) Then
                        serviceType = New SampleUnitServiceType(id, name, parentServiceType)
                        parentServiceType.ChildServices.Add(serviceType)
                    End If
                End If
            Loop
            Return serviceTypes
        End Using

    End Function

    Public Overrides Function SelectServiceTypeBySampleUnitId(ByVal sampleUnitId As Integer) As SampleUnitServiceType
        Dim id As Integer
        Dim parentId As Integer
        Dim name As String
        Dim parentService As SampleUnitServiceType = Nothing
        Dim childService As SampleUnitServiceType
        Dim childServices As New Collection(Of SampleUnitServiceType)

        Dim cmd As DBCommand = Db.GetStoredProcCommand(SP.SelectServiceTypesBySampleUnitId, sampleUnitId)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            While rdr.Read
                id = rdr.GetInteger("Service_ID")
                parentId = rdr.GetInteger("ParentService_ID", 0)
                name = rdr.GetString("strService_nm")

                If (parentId = 0) Then
                    'Parent service type
                    If (parentService Is Nothing) Then
                        parentService = New SampleUnitServiceType(id, name)
                    End If
                Else
                    'Sub service type
                    If (parentService Is Nothing) Then
                        Throw New ArgumentException("Sub service record must follow its parent service record")
                    End If
                    childService = New SampleUnitServiceType(id, name, parentService)
                    parentService.ChildServices.Add(childService)
                End If
            End While
            Return parentService
        End Using
    End Function

    Public Shared Sub DeleteSampleUnitServiceByUnitId(ByVal sampleUnitId As Integer, ByVal tran As DbTransaction)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.DeleteSampleUnitServiceBySampleUnitID, sampleUnitId)
        ExecuteNonQuery(cmd, tran)
    End Sub

    Public Shared Sub InsertSampleUnitService(ByVal sampleUnitId As Integer, ByVal serviceId As Integer, ByVal alternateService As String, ByVal tran As DbTransaction)
        Dim cmd As DbCommand
        If alternateService Is Nothing Then
            cmd = Db.GetStoredProcCommand(SP.InsertSampleUnitService, sampleUnitId, serviceId, DBNull.Value)
        Else
            cmd = Db.GetStoredProcCommand(SP.InsertSampleUnitService, sampleUnitId, serviceId, alternateService)

        End If
        ExecuteNonQuery(cmd, tran)
    End Sub

End Class
