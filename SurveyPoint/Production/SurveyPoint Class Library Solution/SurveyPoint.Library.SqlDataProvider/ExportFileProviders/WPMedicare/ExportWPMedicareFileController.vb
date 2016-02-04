'********************************************************************************
' Concrete SqlProvider Class
'********************************************************************************
Imports Nrc.Framework.Data
Imports Nrc.Framework.BusinessLogic
Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports System.Data.Common
Imports System.ComponentModel

''' <summary>SQL Provider for an export File Object</summary>
''' <CreatedBy>Tony Piccoli</CreatedBy>
''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
Friend Class ExportWPMedicareFileProvider
    Inherits Nrc.SurveyPoint.Library.DataProviders.ExportWPMedicareFileProvider

    Private ReadOnly Property Db() As Database
        Get
            Return DatabaseHelper.Db
        End Get
    End Property

#Region " SPU_FileLayout Procs "

    ''' <summary>When exporting a file with mark submitted checked. this procedure will mark all the respondents in the answer file with a 2401 event code.</summary>
    ''' <param name="exportLogFileID"></param>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Overrides Sub Mark2401ForLog(ByVal exportLogFileID As Integer)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.Mark2401EventsForLogFile, exportLogFileID, DBNull.Value, DBNull.Value)
        ExecuteNonQuery(cmd)
    End Sub


#End Region


End Class