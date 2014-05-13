'********************************************************************************
' Concrete SqlProvider Class
'********************************************************************************
Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports System.Data.Common
Imports NRC.Framework.Data


Friend Class BadLithoProvider
	Inherits QualiSys.Scanning.Library.BadLithoProvider

    Private ReadOnly Property Db() As Database
        Get
            Return QualiSysDatabaseHelper.Db
        End Get
    End Property

#Region " BadLitho Procs "

    Private Function PopulateBadLitho(ByVal rdr As SafeDataReader) As BadLitho

        Dim newObject As BadLitho = BadLitho.NewBadLitho
        Dim privateInterface As IBadLitho = newObject

        newObject.BeginPopulate()
        privateInterface.BadLithoId = rdr.GetInteger("BadLitho_ID")
        newObject.DataLoadId = rdr.GetInteger("DataLoad_ID")
        newObject.BadLithoCode = rdr.GetString("BadstrLithoCode")
        newObject.DateCreated = rdr.GetDate("DateCreated")
        newObject.EndPopulate()

        Return newObject

    End Function
	
    Public Overrides Function SelectBadLitho(ByVal badLithoId As Integer) As BadLitho

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectBadLitho, badLithoId)
        Using rdr As New SafeDataReader(QualiSysDatabaseHelper.ExecuteReader(cmd))
            If Not rdr.Read Then
                Return Nothing
            Else
                Return PopulateBadLitho(rdr)
            End If
        End Using

    End Function

    Public Overrides Function SelectBadLithosByDataLoadId(ByVal dataLoadId As Integer) As BadLithoCollection

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectBadLithosByDataLoadId, dataLoadId)
        Using rdr As New SafeDataReader(QualiSysDatabaseHelper.ExecuteReader(cmd))
            Return QualiSysDatabaseHelper.PopulateCollection(Of BadLithoCollection, BadLitho)(rdr, AddressOf PopulateBadLitho)
        End Using

    End Function

    Public Overrides Function InsertBadLitho(ByVal instance As BadLitho) As Integer

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.InsertBadLitho, instance.DataLoadId, instance.BadLithoCode, SafeDataReader.ToDBValue(instance.DateCreated))
        Return QualiSysDatabaseHelper.ExecuteInteger(cmd)

    End Function

    Public Overrides Sub UpdateBadLitho(ByVal instance As BadLitho)

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.UpdateBadLitho, instance.BadLithoId, instance.DataLoadId, instance.BadLithoCode, SafeDataReader.ToDBValue(instance.DateCreated))
        QualiSysDatabaseHelper.ExecuteNonQuery(cmd)

    End Sub

    Public Overrides Sub DeleteBadLitho(ByVal instance As BadLitho)

        If instance IsNot Nothing Then
            Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.DeleteBadLitho, instance.BadLithoId)
            QualiSysDatabaseHelper.ExecuteNonQuery(cmd)
        End If

    End Sub

#End Region

End Class
