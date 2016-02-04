Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports System.Data.Common
Imports PS.Framework.Data
Imports MailMergePrep.Library
Public Class MailMergeTemplateInstructionProvider
    Inherits MailMergePrep.Library.MailMergeTemplateInstructionProvider
    Private ReadOnly Property Db(ByVal connString As String) As Database
        Get
            Return DatabaseHelper.Db(connString)
        End Get
    End Property    
#Region " Overrides "
    Public Overrides Function GetMailMergeTemplateInstruction(ByVal templateID As Integer) As MailMergeTemplateInstruction
        Dim cmd As DbCommand = Db(Config.QMSConnection).GetStoredProcCommand(SP.GetTemplateInstruction, templateID)
        Dim obj As MailMergeTemplateInstruction = MailMergeTemplateInstruction.NewMailMergeTemplateInstruction
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            While rdr.Read
                obj.MailMergeTemplateInstructionID = rdr.GetInteger("TemplateID")
                obj.Instructions = rdr.GetString("Instructions")
                obj.SpecialInstructions = rdr.GetString("SpecialInstructions")
            End While
        End Using
        Return obj
    End Function
    Public Overrides Sub SetMailMeregeTemplateInstruction(ByVal templateID As Integer, ByVal instruction As String, ByVal specialInstruction As String)
        Dim cmd As DbCommand = Db(Config.QMSConnection).GetStoredProcCommand(SP.SetTemplateInstruction, templateID, instruction, specialInstruction)
        ExecuteNonQuery(cmd)
    End Sub    
#End Region
End Class
