'********************************************************************************
' Concrete SqlProvider Class
'********************************************************************************
Imports Nrc.Framework.Data
Imports Nrc.Framework.BusinessLogic
Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports System.Data.Common
Imports System.ComponentModel

Friend Class ExportWPMedicareQFileProvider
    Inherits Nrc.SurveyPoint.Library.DataProviders.ExportWPMedicareQFileProvider

    Private ReadOnly Property Db() As Database
        Get
            Return DatabaseHelper.Db
        End Get
    End Property


#Region " SPU_ExportGroup Procs "

    ''' <summary>Populate each question file object which represents a row in the
    ''' question file export.</summary>
    ''' <param name="questionController"></param>
    ''' <param name="rdr"></param>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table">
    ''' <listheader>
    ''' <term>Date Modified - Modified By</term>
    ''' <description>Description</description></listheader>
    ''' <item>
    ''' <term>20080414 - TP</term>
    ''' <description>Added Script Extensions to the populate.</description></item>
    ''' <item>
    ''' <term>	20080414 - Tony Piccoli</term>
    ''' <description>Added new field
    ''' removeHTMLAndEncoding.</description></item></list></RevisionList>
    Private Function PopulateQuestion(ByVal questionController As ExportWPMedicareQFileController, ByVal rdr As SafeDataReader) As ExportWPMedicareQFile
        Dim newObject As ExportWPMedicareQFile = ExportWPMedicareQFile.NewExportWPMedicareQFile
        Dim privateInterface As IExportWPMedicareQFileID = newObject
        newObject.BeginPopulate()
        newObject.ParentQuestionFileController = questionController
        newObject.ScriptID = rdr.GetInteger("ScriptID")
        newObject.SurveyQuestionID = rdr.GetInteger("SurveyQuestionID")
        newObject.QuestionID = rdr.GetInteger("QuestionID")
        newObject.CaculationTypeID = rdr.GetInteger("CalculationTypeID")
        newObject.ItemOrder = rdr.GetInteger("ItemOrder")
        newObject.QText = rdr.GetString("Text")
        newObject.AnswerCategoryTypeID = rdr.GetInteger("AnswerCategoryTypeID")
        newObject.AnswerValue = rdr.GetInteger("AnswerValue")
        newObject.AnswerText = rdr.GetString("AnswerText")
        newObject.ExportGroupID = rdr.GetInteger("ExportGroupID")
        newObject.RemoveHTMLAndEncoding = CBool(rdr.Item("RemoveHTMLAndEncoding"))
        newObject.Name = rdr.GetString("Name")
        newObject.MiscChar1 = rdr.GetString("MiscChar1")
        newObject.MiscChar2 = rdr.GetString("MiscChar2")
        newObject.MiscChar3 = rdr.GetString("MiscChar3")
        newObject.MiscChar4 = rdr.GetString("MiscChar4")
        newObject.MiscChar5 = rdr.GetString("MiscChar5")
        newObject.MiscChar6 = rdr.GetString("MiscChar6")
        newObject.MiscNum1 = rdr.GetNullableDecimal("MiscNum1")
        newObject.MiscNum2 = rdr.GetNullableDecimal("MiscNum2")
        newObject.MiscNum3 = rdr.GetNullableDecimal("MiscNum3")
        newObject.MiscDate1 = rdr.GetNullableDate("MiscDate1")
        newObject.MiscDate2 = rdr.GetNullableDate("MiscDate2")
        newObject.MiscDate3 = rdr.GetNullableDate("MiscDate3")
        'TP 20080414  Question file needs the script extensions.
        newObject.SCMiscChar1 = rdr.GetString("SCMiscChar1")
        newObject.SCMiscChar2 = rdr.GetString("SCMiscChar2")
        newObject.SCMiscChar3 = rdr.GetString("SCMiscChar3")
        newObject.SCMiscChar4 = rdr.GetString("SCMiscChar4")
        newObject.SCMiscChar5 = rdr.GetString("SCMiscChar5")
        newObject.SCMiscChar6 = rdr.GetString("SCMiscChar6")
        newObject.SCMiscNum1 = rdr.GetNullableDecimal("SCMiscNum1")
        newObject.SCMiscNum2 = rdr.GetNullableDecimal("SCMiscNum2")
        newObject.SCMiscNum3 = rdr.GetNullableDecimal("SCMiscNum3")
        newObject.SCMiscDate1 = rdr.GetNullableDate("SCMiscDate1")
        newObject.SCMiscDate2 = rdr.GetNullableDate("SCMiscDate2")
        newObject.SCMiscDate3 = rdr.GetNullableDate("SCMiscDate3")
        newObject.EndPopulate()
        Return newObject
    End Function

    ''' <summary>Create the collection of question file objects each of which represent a row in the question file export.</summary>
    ''' <param name="exportGroupID"></param>
    ''' <returns></returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Overrides Function CreateQuestionFileCollection(ByVal questionController As ExportWPMedicareQFileController, ByVal exportGroupID As Integer) As ExportWPMedicareQFileCollection
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.CreateQuestionFile, exportGroupID)
        Dim list As ExportWPMedicareQFileCollection = New ExportWPMedicareQFileCollection
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            While rdr.Read
                list.Add(PopulateQuestion(questionController, rdr))
            End While
            Return list
        End Using
    End Function
#End Region
End Class
