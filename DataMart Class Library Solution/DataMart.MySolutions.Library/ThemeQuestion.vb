Imports Nrc.Framework.BusinessLogic
Imports System.Collections.ObjectModel

<Serializable()> _
Public Class ThemeQuestion
    Inherits BusinessBase(Of ThemeQuestion)

#Region " Private Fields "
    <NotUndoable()> Private mInstanceGuid As Guid = Guid.NewGuid
    Private mServiceTypeId As Integer
    Private mServiceTypeName As String = String.Empty
    Private mViewId As Integer
    Private mViewName As String = String.Empty
    Private mThemeId As Integer
    Private mThemeName As String = String.Empty
    Private mQuestionId As Integer
    Private mQuestionText As String = String.Empty
    Private mIsPending As Boolean
    Private mStatus As ThemeQuestionStatus
    Private mDateSubmitted As Nullable(Of Date)
    Private mUserName As String = String.Empty
    Private mDateProcessed As Nullable(Of Date)
#End Region

#Region " Public Properties "
    Public Property ServiceTypeId() As Integer
        Get
            Return mServiceTypeId
        End Get
        Set(ByVal value As Integer)
            If mServiceTypeId <> value Then
                mServiceTypeId = value
                PropertyHasChanged("ServiceTypeId")
            End If
        End Set
    End Property
    Public Property ServiceTypeName() As String
        Get
            Return mServiceTypeName
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not mServiceTypeName = value Then
                mServiceTypeName = value
                PropertyHasChanged("ServiceTypeName")
            End If
        End Set
    End Property
    Public Property ViewId() As Integer
        Get
            Return mViewId
        End Get
        Set(ByVal value As Integer)
            If mViewId <> value Then
                mViewId = value
                PropertyHasChanged("ViewId")
            End If
        End Set
    End Property
    Public Property ViewName() As String
        Get
            Return mViewName
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If mViewName <> value Then
                mViewName = value
                PropertyHasChanged("ViewName")
            End If
        End Set
    End Property
    Public Property ThemeId() As Integer
        Get
            Return mThemeId
        End Get
        Set(ByVal value As Integer)
            If mThemeId <> value Then
                mThemeId = value
                PropertyHasChanged("ThemeId")
            End If
        End Set
    End Property
    Public Property ThemeName() As String
        Get
            Return mThemeName
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If mThemeName <> value Then
                mThemeName = value
                PropertyHasChanged("ThemeName")
            End If
        End Set
    End Property
    Public Property QuestionId() As Integer
        Get
            Return mQuestionId
        End Get
        Set(ByVal value As Integer)
            If mQuestionId <> value Then
                mQuestionId = value
                PropertyHasChanged("QuestionId")
            End If
        End Set
    End Property
    Public Property QuestionText() As String
        Get
            Return mQuestionText
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If mQuestionText <> value Then
                mQuestionText = value
                PropertyHasChanged("QuestionText")
            End If
        End Set
    End Property
    Public Property IsPending() As Boolean
        Get
            Return mIsPending
        End Get
        Set(ByVal value As Boolean)
            If mIsPending <> value Then
                mIsPending = value
                PropertyHasChanged("IsPending")
            End If
        End Set
    End Property
    Public Property Status() As ThemeQuestionStatus
        Get
            Return mStatus
        End Get
        Set(ByVal value As ThemeQuestionStatus)
            If mStatus <> value Then
                mStatus = value
                PropertyHasChanged("Status")
            End If
        End Set
    End Property
    Public Property DateSubmitted() As Nullable(Of Date)
        Get
            Return mDateSubmitted
        End Get
        Set(ByVal value As Nullable(Of Date))
            If Not mDateSubmitted.Equals(value) Then
                mDateSubmitted = value
                PropertyHasChanged("DateSubmitted")
            End If
        End Set
    End Property
    Public Property UserName() As String
        Get
            Return mUserName
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If mUserName <> value Then
                mUserName = value
                PropertyHasChanged("UserName")
            End If
        End Set
    End Property
    Public Property DateProcessed() As Nullable(Of Date)
        Get
            Return mDateProcessed
        End Get
        Set(ByVal value As Nullable(Of Date))
            If Not mDateProcessed.Equals(value) Then
                mDateProcessed = value
                mDateProcessed = value
            End If
        End Set
    End Property

    Public ReadOnly Property StatusLabel() As String
        Get
            Select Case mStatus
                Case ThemeQuestionStatus.None
                    Return ""
                Case ThemeQuestionStatus.Live
                    Return "Live"
                Case ThemeQuestionStatus.PendingAdd
                    Return "Pending Add"
                Case ThemeQuestionStatus.PendingRemove
                    Return "Pending Remove"
                Case ThemeQuestionStatus.ProcessingAdd
                    Return "Processing Add"
                Case ThemeQuestionStatus.ProcessingRemove
                    Return "Processing Remove"
                Case ThemeQuestionStatus.CompletedAdd
                    Return "Completed Add"
                Case ThemeQuestionStatus.CompletedRemove
                    Return "Completed Remove"
                Case Else
                    Return ""
            End Select
        End Get
    End Property
#End Region

#Region " Constructors "
    Private Sub New()
        Me.CreateNew()
    End Sub
#End Region

#Region " Factory Methods "
    Public Shared Function NewThemeQuestion() As ThemeQuestion
        Return New ThemeQuestion
    End Function

    Public Shared Function GetByThemeId(ByVal themeId As Integer) As ThemeQuestionCollection
        Return DataProvider.Instance.SelectThemeQuestionsByThemeId(themeId)
    End Function

    Public Shared Function GetByQuestionId(ByVal questionId As Integer) As ThemeQuestionCollection
        Return DataProvider.Instance.SelectThemeQuestionsByQuestionId(questionId)
    End Function

#End Region

#Region " Basic Overrides "
    Protected Overrides Function GetIdValue() As Object
        Return mInstanceGuid
    End Function

#End Region

#Region " Validation "
    Protected Overrides Sub AddBusinessRules()
        'Add validation rules here...
    End Sub
#End Region

#Region " Data Access "
    Protected Overrides Sub CreateNew()
        'Set default values here

        'Optionally finish by validating default values
        ValidationRules.CheckRules()
    End Sub

    Protected Overrides Sub Insert()
        Throw New NotImplementedException
        'SurveyId = DataProvider.Instance.InsertClientStudySurvey(Me)
    End Sub

    Protected Overrides Sub Update()
        Throw New NotImplementedException
        'DataProvider.Instance.UpdateClientStudySurvey(Me)
    End Sub

    Protected Overrides Sub DeleteImmediate()
        Throw New NotImplementedException
        'DataProvider.Instance.DeleteClientStudySurvey(mSurveyId)
    End Sub

#Region " Public Methods "

#End Region

#End Region

    Public Shared Sub AddQuestionToTheme(ByVal themeId As Integer, ByVal questionId As Integer, ByVal userName As String)
        DataProvider.Instance.InsertThemeQuestion(themeId, questionId, userName)
    End Sub

    Public Shared Sub RemoveQuestionFromTheme(ByVal themeId As Integer, ByVal questionId As Integer, ByVal userName As String)
        DataProvider.Instance.DeleteThemeQuestion(themeId, questionId, userName)
    End Sub

End Class

<Serializable()> _
Public Class ThemeQuestionCollection
    Inherits BusinessListBase(Of ThemeQuestionCollection, ThemeQuestion)

    Protected Overrides Function AddNewCore() As Object
        Dim newObj As ThemeQuestion = ThemeQuestion.NewThemeQuestion
        Me.Add(newObj)
        Return newObj
    End Function
End Class

Public Enum ThemeQuestionStatus
    Live = -1
    None = 0
    PendingAdd = 1
    PendingRemove = 2
    ProcessingAdd = 3
    ProcessingRemove = 4
    CompletedAdd = 5
    CompletedRemove = 6
End Enum