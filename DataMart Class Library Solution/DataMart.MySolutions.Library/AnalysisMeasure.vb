Option Strict On
Option Explicit On

Imports Nrc.Framework.BusinessLogic

Public Interface IAnalysisMeasure
    Property Id() As Byte
End Interface

<Serializable()> _
Public Class AnalysisMeasure
    Inherits BusinessBase(Of AnalysisMeasure)
    Implements IAnalysisMeasure

#Region " Private Members "
    <NotUndoable()> Private mInstanceGuid As Guid = Guid.NewGuid
    Private mId As Byte
    Private mName As String = String.Empty
#End Region

#Region " Public Properties "

    Public Property Id() As Byte Implements IAnalysisMeasure.Id
        Get
            Return mId
        End Get
        Private Set(ByVal value As Byte)
            If Not value = mId Then
                mId = value
                PropertyHasChanged("Id")
            End If
        End Set
    End Property
    Public Property Name() As String
        Get
            Return mName
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mName Then
                mName = value
                PropertyHasChanged("Name")
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

    Public Shared Function NewAnalysisMeasure(ByVal name As String) As AnalysisMeasure
        Dim mr As New AnalysisMeasure
        mr.Name = name
        Return mr
    End Function

    Public Shared Function NewAnalysisMeasure() As AnalysisMeasure
        Return New AnalysisMeasure
    End Function

    Public Shared Function GetByKey(ByVal id As Integer) As AnalysisMeasure
        Return DataProvider.Instance.SelectAnalysisMeasure(id)
    End Function

    Public Shared Function GetAll() As AnalysisMeasureCollection
        Return DataProvider.Instance.SelectAllAnalysisMeasure()
    End Function

#End Region

#Region " Basic Overrides "
    Protected Overrides Function GetIdValue() As Object
        If Me.IsNew Then
            Return mInstanceGuid
        Else
            Return mId
        End If
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
Public Class AnalysisMeasureCollection
    Inherits BusinessListBase(Of AnalysisMeasureCollection, AnalysisMeasure)

    Protected Overrides Function AddNewCore() As Object
        Dim newObj As AnalysisMeasure = AnalysisMeasure.NewAnalysisMeasure
        Me.Add(newObj)
        Return newObj
    End Function

End Class

