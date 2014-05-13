Option Explicit On 
Option Strict On

Imports System.Data.SqlClient
Imports System.Text
Imports NormsApplicationBusinessObjectsLibrary

Public Class CanadaRollupController

#Region " Private Fields"

    Private mRollupID As Integer

#End Region

#Region " Public Properties"

    Public Property RollupID() As Integer
        Get
            Return mRollupID
        End Get
        Set(ByVal Value As Integer)
            mRollupID = Value
        End Set
    End Property

#End Region

#Region " Public Methods"

    Public Function SelectAllRollup() As SqlDataReader
        Return DataAccess.SelectCanadaAllRollup()
    End Function

    Public Function SelectRollupSurvey() As SqlDataReader
        Return DataAccess.SelectCanadaRollupSurvey(mRollupID)
    End Function

    Public Function UpdateCanadaRollup(ByVal rollupID As Integer, _
                                          ByVal rollupName As String, _
                                          ByVal Description As String, _
                                          ByVal surveys As StringBuilder) As SqlClient.SqlDataReader
        Return DataAccess.UpdateCanadaRollup(rollupID, rollupName, Description, surveys)
    End Function

    Public Function SelectUsedRollup(ByVal rollups As String) As SqlClient.SqlDataReader
        Return DataAccess.SelectCanadaUsedRollup(rollups)
    End Function

    Public Shared Sub DeleteRollup(ByVal rollups As String)
        DataAccess.DeleteCanadaRollup(rollups)
    End Sub

#End Region

End Class
