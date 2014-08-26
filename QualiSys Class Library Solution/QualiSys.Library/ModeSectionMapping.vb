Imports Nrc.Framework.BusinessLogic
Imports Nrc.QualiSys.Library.DataProvider



Public Class ModeSectionMapping
    Inherits BusinessBase(Of ModeSectionMapping)


#Region " Private Fields "
    <NotUndoable()> Private mInstanceGuid As Guid = Guid.NewGuid
    Private mId As Integer
    Private mMailingStepMethodId As Integer
    Private mMailingStepMethodName As String
    Private mSectionId As Integer
    Private mSectionLabel As String
    Private mSurveyId As Integer
    Private mIsDirty As Boolean
    Private mNeedsDelete As Boolean
#End Region

#Region " Public Properties "

    <Logable()> _
    Public Property Id() As Integer
        Get
            Return mId
        End Get
        Set(ByVal value As Integer)
            mId = value
        End Set
    End Property

    <Logable()> _
    Public Property MailingStepMethodId() As Integer
        Get
            Return mMailingStepMethodId
        End Get
        Set(ByVal value As Integer)
            If Not value = mMailingStepMethodId Then
                mMailingStepMethodId = value
                PropertyHasChanged("mMailingStepMethodId")
            End If
        End Set
    End Property

    <Logable()> _
    Public Property MailingStepMethodName() As String
        Get
            Return mMailingStepMethodName
        End Get
        Set(ByVal value As String)
            If Not value = mMailingStepMethodName Then
                mMailingStepMethodName = value
                PropertyHasChanged("mMailingStepMethodName")
            End If
        End Set
    End Property

    <Logable()> _
    Public Property QuestionSectionId() As Integer
        Get
            Return mSectionId
        End Get
        Set(ByVal value As Integer)
            If Not value = mSectionId Then
                mSectionId = value
                PropertyHasChanged("SectionId")
            End If
        End Set
    End Property

    <Logable()> _
    Public Property QuestionSectionLabel() As String
        Get
            Return mSectionLabel
        End Get
        Set(ByVal value As String)
            If Not value = mSectionLabel Then
                mSectionLabel = value
                PropertyHasChanged("mSectionLabel")
            End If
        End Set
    End Property

    <Logable()> _
    Public Property SurveyId() As Integer
        Get
            Return mSurveyId
        End Get
        Set(ByVal value As Integer)
            If Not value = mSurveyId Then
                mSurveyId = value
                PropertyHasChanged("SurveyId")
            End If
        End Set
    End Property


    ''' <summary>
    ''' Indicates if a unit needs to be deleted from the database.
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Property NeedsDelete() As Boolean
        Get
            Return mNeedsDelete
        End Get
        Set(ByVal value As Boolean)
            mNeedsDelete = value
        End Set
    End Property


#End Region

#Region " Constructors "
    Private Sub New()

    End Sub
#End Region

#Region " Factory Methods "
    Public Shared Function NewModeSectionMapping() As ModeSectionMapping
        Dim obj As New ModeSectionMapping
        Return obj
    End Function

    Public Shared Function NewModeSectionMapping(ByVal surveyId As Integer, ByVal id As Integer, ByVal mailingStepMethodId As Integer, ByVal mailingStepMethodName As String, ByVal sectionId As Integer, ByVal sectionLabel As String) As ModeSectionMapping
        Dim obj As New ModeSectionMapping
        obj.Id = id
        obj.QuestionSectionId = sectionId
        obj.SurveyId = surveyId
        obj.MailingStepMethodId = mailingStepMethodId
        obj.MailingStepMethodName = mailingStepMethodName
        obj.QuestionSectionLabel = sectionLabel
        Return obj
    End Function


    Public Shared Function GetModeSectionMappingsBySurveyId(ByVal SurveyId As Integer) As List(Of ModeSectionMapping) 'Collection
        Return ModeSectionMappingProvider.Instance.SelectModeSectionMappingsBySurveyId(SurveyId)
    End Function
#End Region

#Region " Basic Overrides "

    Protected Overrides Function GetIdValue() As Object
        Return 0
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

    Public Overrides Sub Delete()
        If Me.IsChild Then
            Me.Parent.RemoveChild(Me)
        Else
            MyBase.Delete()
        End If
    End Sub

    Protected Overrides Sub Insert()
        ModeSectionMappingProvider.Instance.InsertModeSectionMapping(Me)
    End Sub

    Protected Overrides Sub DeleteImmediate()
        ModeSectionMappingProvider.Instance.DeleteModeSectionMapping(Me)
    End Sub


#End Region

#Region "CRUD"

    Public Shared Function [Get](ByVal Id As Integer, ByVal Survey_Id As Integer) As ModeSectionMapping
        Return ModeSectionMappingProvider.Instance.[Select](Id, Survey_Id)
    End Function

    ''' <summary>
    ''' This method will traverse the Mapping Grid and take appropriate action on each unit.  The action 
    ''' will be an insert, update, delete, or nothing.
    ''' </summary>
    ''' <remarks></remarks>
    Public Sub UpdateObj()

        If Me.NeedsDelete Then
            ModeSectionMappingProvider.Instance.DeleteModeSectionMapping(Me)
        ElseIf Me.IsNew Then
            Me.Id = ModeSectionMappingProvider.Instance.InsertModeSectionMapping(Me)
        Else
            ModeSectionMappingProvider.Instance.UpdateModeSectionMapping(Me)
        End If

        Dim changes As List(Of AuditLogChange) = GetChanges()
        AuditLog.LogChanges(changes)

    End Sub



    ''' <summary>
    ''' Gets a list of all changes that have been made to the object since it was loaded or created.
    ''' </summary>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Friend Function GetChanges() As List(Of AuditLogChange)
        Dim changes As New List(Of AuditLogChange)

        If Me.IsNew = False And Me.NeedsDelete Then
            'Delete
            changes.AddRange(AuditLog.CompareObjects(Of ModeSectionMapping)(Me, Nothing, "Id", AuditLogObject.ModeSectionMapping))
        ElseIf Me.IsNew = False Then
            'Update
            If IsDirty Then
                Dim original As ModeSectionMapping = ModeSectionMapping.Get(Me.Id, Me.SurveyId)
                changes.AddRange(AuditLog.CompareObjects(Of ModeSectionMapping)(original, Me, "Id", AuditLogObject.ModeSectionMapping))
            End If
        Else
            'New
            changes.AddRange(AuditLog.CompareObjects(Of ModeSectionMapping)(Nothing, Me, "Id", AuditLogObject.ModeSectionMapping))
        End If


        Return changes
    End Function
#End Region

#Region " Public Methods "
#End Region

End Class
