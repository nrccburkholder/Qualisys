'This file should be in your SQLDataProvider project
'Stored procedure names for DAL
#Region " SP Declarations "
Partial Public NotInheritable Class SP
    'Uncomment the following lines in ONLY ONE of the SP classes if needed.
    'Private Sub New()
    'End Sub
    Public Const SelectClientsStudysAndSurveysByUser As String = "dbo.LD_SelectClientsStudiesAndSurveysByUser"
    Public Const SelectClientGroupsClientsStudysAndSurveysByUser As String = "dbo.LD_SelectClientGroupsClientsStudysAndSurveysByUser"
    Public Const SelectClientsStudysAndSurveysByUserAndFileStates As String = "dbo.LD_SelectClientsStudiesAndSurveysByUserAndDataFileStates"
    Public Const SelectClientGroupsClientsStudysAndSurveysByUserAndFileStates As String = "dbo.LD_SelectClientGroupsClientsStudysAndSurveysByUserAndDataFileStates"
End Class
#End Region
