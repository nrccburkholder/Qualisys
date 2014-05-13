Option Strict On
Option Explicit On

Imports Nrc.Framework.BusinessLogic

<Serializable()> _
Public Class QuestionSearchWork
    Inherits BusinessBase(Of QuestionSearchWork)

#Region " Private Members "
    <NotUndoable()> Private mInstanceGuid As Guid = Guid.NewGuid
    Private mQstnCore As Integer
    Private mQuestionText As String = String.Empty
    Private mRank As Integer
#End Region

#Region " Public Properties "

    Public Property QstnCore() As Integer
        Get
            Return mQstnCore
        End Get
        Set(ByVal value As Integer)
            If Not value = mQstnCore Then
                mQstnCore = value
                PropertyHasChanged("QstnCore")
            End If
        End Set
    End Property
    Public Property QuestionText() As String
        Get
            Return mQuestionText
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mQuestionText Then
                mQuestionText = value
                PropertyHasChanged("QuestionText")
            End If
        End Set
    End Property
    Public Property Rank() As Integer
        Get
            Return mRank
        End Get
        Set(ByVal value As Integer)
            If Not value = mRank Then
                mRank = value
                PropertyHasChanged("Rank")
            End If
        End Set
    End Property

#End Region

#Region " Constructors "
    Private Sub New()
        Me.CreateNew()
    End Sub
#End Region

#Region " Factory Methods "

    Public Shared Function NewQuestionSearchWork() As QuestionSearchWork
        Return New QuestionSearchWork
    End Function

    Public Shared Function GetSearchQuestionText(ByVal resultSet As Guid, ByVal text As String) As QuestionSearchWorkCollection
        Return DataProvider.Instance.SearchQuestionSearchText(resultSet, text)
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

#End Region

#Region " Public Methods "

#End Region

End Class

<Serializable()> _
Public Class QuestionSearchWorkCollection
    Inherits BusinessListBase(Of QuestionSearchWorkCollection, QuestionSearchWork)

    Protected Overrides Function AddNewCore() As Object
        Dim newObj As QuestionSearchWork = QuestionSearchWork.NewQuestionSearchWork
        Me.Add(newObj)
        Return newObj
    End Function

#Region " Contains qstncore support "

    Private ReadOnly m_qstncoreLookup As New Dictionary(Of Integer, QuestionSearchWork)

    Public Function ContainsQstncore(ByVal qstncore As Integer) As Boolean
        Return m_qstncoreLookup.ContainsKey(qstncore)
    End Function

    Protected Overrides Sub ClearItems()
        MyBase.ClearItems()
        m_qstncoreLookup.Clear()
    End Sub

    Protected Overrides Sub InsertItem(ByVal index As Integer, ByVal item As QuestionSearchWork)
        MyBase.InsertItem(index, item)
        m_qstncoreLookup.Add(item.QstnCore, item)
    End Sub

    Protected Overrides Sub RemoveItem(ByVal index As Integer)
        Dim item As QuestionSearchWork = MyBase.Item(index)
        m_qstncoreLookup.Remove(item.QstnCore)
        MyBase.RemoveItem(index)
    End Sub

    Protected Overrides Sub SetItem(ByVal index As Integer, ByVal item As QuestionSearchWork)
        Dim oldItem As QuestionSearchWork = MyBase.Item(index)
        m_qstncoreLookup.Remove(oldItem.QstnCore)
        m_qstncoreLookup.Add(item.QstnCore, item)
        MyBase.SetItem(index, item)
    End Sub

#End Region

End Class

