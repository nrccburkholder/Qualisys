Imports Nrc.Qualisys.Library.DataProvider
Imports Nrc.Qualisys.Library
Public Class DataStructureModule
    Inherits ConfigurationModule

    Sub New(ByVal configPanel As Panel)
        MyBase.New(configPanel)
    End Sub

    Public Overrides Sub BeginConfig(ByVal selectedClientGroup As Navigation.ClientGroupNavNode, ByVal selectedClient As Navigation.ClientNavNode, ByVal selectedStudy As Navigation.StudyNavNode, ByVal selectedSurvey As Navigation.SurveyNavNode, ByVal endConfigCallback As EndConfigCallBackMethod)
        Dim studyId As Integer = selectedStudy.Id
        Dim studyDataStruct As New StudyDataClient.StudyDataStructure
        Dim lockCategory As ConcurrencyLockCategory = ConcurrencyLockCategory.StudyDataStructure

        If ConcurrencyManager.AcquireLock(lockCategory, studyId, CurrentUser.UserName, Environment.MachineName, Process.GetCurrentProcess.ProcessName) Then
            studyDataStruct.GO(studyId, True)

            'Call LD_StudyTables from here in case it didn't work inside COM object
            Dim studyProvider As StudyProvider
            studyProvider = StudyProvider.Instance()
            studyProvider.SetUpStudyOwnedTables(studyId)

            ConcurrencyManager.ReleaseLock(lockCategory, studyId)
        Else
            Dim lock As ConcurrencyLock = ConcurrencyManager.ViewLock(lockCategory, studyId)
            Dim lockCategoryName As String = System.Enum.GetName(lock.LockCategory.GetType, lockCategory)
            MessageBox.Show(lockCategoryName & " Locked by " & lock.UserName & "; process=" & lock.ProcessName & "; machineID=" & lock.MachineName, lockCategoryName & " Locked", MessageBoxButtons.OK)
            studyDataStruct.GO(studyId, False)
        End If

        'Release the unmanaged resource.
        If studyDataStruct IsNot Nothing Then
            System.Runtime.InteropServices.Marshal.ReleaseComObject(studyDataStruct)
        End If

        endConfigCallback(ConfigResultActions.StudyRefresh, Nothing)
    End Sub

    Public Overrides ReadOnly Property Image() As System.Drawing.Image
        Get
            Return My.Resources.DataStructure16
        End Get
    End Property

    Public Overrides ReadOnly Property Name() As String
        Get
            Return "Data Structure"
        End Get
    End Property

End Class
