Imports Nrc.QualiSys.Library.DataProvider
Imports Nrc.Framework.BusinessLogic

Public Interface IMedicarePropCalcType

    Property MedicarePropCalcTypeId() As Integer

End Interface

<Serializable()> _
Public Class MedicarePropCalcType
    Inherits BusinessBase(Of MedicarePropCalcType)
    Implements IMedicarePropCalcType

#Region " Private Fields "

    <NotUndoable()> Private mInstanceGuid As Guid = Guid.NewGuid
    Private mMedicarePropCalcTypeId As Integer
    Private mMedicarePropCalcTypeName As String = String.Empty

#End Region

#Region " Public Properties "

    Public Property MedicarePropCalcTypeId() As Integer Implements IMedicarePropCalcType.MedicarePropCalcTypeId
        Get
            Return mMedicarePropCalcTypeId
        End Get
        Private Set(ByVal value As Integer)
            If Not value = mMedicarePropCalcTypeId Then
                mMedicarePropCalcTypeId = value
                PropertyHasChanged("MedicarePropCalcTypeId")
            End If
        End Set
    End Property

    Public Property MedicarePropCalcTypeName() As String
        Get
            Return mMedicarePropCalcTypeName
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mMedicarePropCalcTypeName Then
                mMedicarePropCalcTypeName = value
                PropertyHasChanged("MedicarePropCalcTypeName")
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

    Public Shared Function NewMedicarePropCalcType() As MedicarePropCalcType

        Return New MedicarePropCalcType

    End Function

    Public Shared Function [Get](ByVal medicarePropCalcTypeId As Integer) As MedicarePropCalcType

        Return MedicarePropCalcTypeProvider.Instance.Select(medicarePropCalcTypeId)

    End Function

    Public Shared Function GetAll() As MedicarePropCalcTypeCollection

        Return MedicarePropCalcTypeProvider.Instance.SelectAll()

    End Function

#End Region

#Region " Basic Overrides "

    Protected Overrides Function GetIdValue() As Object

        If Me.IsNew Then
            Return mInstanceGuid
        Else
            Return mMedicarePropCalcTypeId
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

#Region " Operator Overloading "

    Public Shared Operator =(ByVal left As MedicarePropCalcType, ByVal right As MedicarePropCalcType) As Boolean
        If left Is Nothing OrElse right Is Nothing Then
            Return False
        Else
            Return (left.mMedicarePropCalcTypeId = right.mMedicarePropCalcTypeId)
        End If
    End Operator

    Public Shared Operator <>(ByVal left As MedicarePropCalcType, ByVal right As MedicarePropCalcType) As Boolean
        Return Not (left = right)
    End Operator

#End Region

End Class
