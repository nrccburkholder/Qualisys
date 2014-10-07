
Module Globals
    'Use sub Main for testing.  In the project properties, temporarily set the output type to Windows Appication
    Sub main()
        Dim testingApp As New nrcTestPrint
        Dim employeeID As Integer = 263
        Dim surveyID As Integer = 4757
        testingApp.GetPrints(surveyID, employeeID)
    End Sub

End Module
