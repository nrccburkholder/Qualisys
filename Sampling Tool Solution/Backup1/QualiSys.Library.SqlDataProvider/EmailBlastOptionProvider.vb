'********************************************************************************
' Concrete SqlProvider Class
'********************************************************************************
Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports System.Data.Common
Imports NRC.Framework.Data


Friend Class EmailBlastOptionProvider
    Inherits QualiSys.Library.EmailBlastOptionProvider

    Private ReadOnly Property Db() As Database
        Get
            Return Globals.Db
        End Get
    End Property


#Region " MM_EmailBlast_Option Procs "

    Private Function PopulateEmailBlastOption(ByVal rdr As SafeDataReader) As EmailBlastOption
        Dim newObject As EmailBlastOption = EmailBlastOption.NewEmailBlastOption
        Dim privateInterface As IEmailBlastOption = newObject
        newObject.BeginPopulate()
        privateInterface.EmailBlastId = rdr.GetInteger("EmailBlast_ID")
        newObject.Value = rdr.GetString("Value")
        newObject.EndPopulate()

        Return newObject
    End Function

    Public Overrides Function SelectEmailBlastOption(ByVal emailBlastId As Integer) As EmailBlastOption
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectEmailBlastOption, emailBlastId)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            If Not rdr.Read Then
                Return Nothing
            Else
                Return PopulateEmailBlastOption(rdr)
            End If
        End Using
    End Function

    Public Overrides Function SelectAllEmailBlastOptions() As EmailBlastOptionCollection
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectAllEmailBlastOptions)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            Return PopulateCollection(Of EmailBlastOptionCollection, EmailBlastOption)(rdr, AddressOf PopulateEmailBlastOption)
        End Using
    End Function

    Public Overrides Function InsertEmailBlastOption(ByVal instance As EmailBlastOption) As Integer
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.InsertEmailBlastOption, instance.Value)
        Return ExecuteInteger(cmd)
    End Function

    Public Overrides Sub UpdateEmailBlastOption(ByVal instance As EmailBlastOption)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.UpdateEmailBlastOption, instance.EmailBlastId, instance.Value)
        ExecuteNonQuery(cmd)
    End Sub

    Public Overrides Sub DeleteEmailBlastOption(ByVal instance As EmailBlastOption)
        If instance IsNot Nothing Then
            Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.DeleteEmailBlastOption, instance.EmailBlastId)
            ExecuteNonQuery(cmd)
        End If
    End Sub

#End Region


End Class
