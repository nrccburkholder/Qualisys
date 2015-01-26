Imports NRC.Framework.BusinessLogic

Public Interface IEmailBlast
    Property Id() As Integer
End Interface

<Serializable()> _
Public Class EmailBlast
    Inherits BusinessBase(Of EmailBlast)
    Implements IEmailBlast

#Region " Private Fields "
    Private mInstanceGuid As Guid = Guid.NewGuid
    Private mId As Integer
    Private mMAILINGSTEPId As Integer
    Private mEmailBlastId As Integer
    Private mDaysFromStepGen As Integer
    Private mDateSent As Nullable(Of Date)
#End Region

#Region " Public Properties "
    Public Property Id() As Integer Implements IEmailBlast.Id
        Get
            Return mId
        End Get
        Private Set(ByVal value As Integer)
            If Not value = mId Then
                mId = value
                PropertyHasChanged("Id")
            End If
        End Set
    End Property
    Public Property MAILINGSTEPId() As Integer
        Get
            Return mMAILINGSTEPId
        End Get
        Set(ByVal value As Integer)
            If Not value = mMAILINGSTEPId Then
                mMAILINGSTEPId = value
                PropertyHasChanged("MAILINGSTEPId")
            End If
        End Set
    End Property
    <Logable()> _
    Public Property EmailBlastId() As Integer
        Get
            Return mEmailBlastId
        End Get
        Set(ByVal value As Integer)
            If Not value = mEmailBlastId Then
                mEmailBlastId = value
                PropertyHasChanged("EmailBlastId")
            End If
        End Set
    End Property
    <Logable()> _
    Public Property DaysFromStepGen() As Integer
        Get
            Return mDaysFromStepGen
        End Get
        Set(ByVal value As Integer)
            If Not value = mDaysFromStepGen Then
                mDaysFromStepGen = value
                PropertyHasChanged("DaysFromStepGen")
            End If
        End Set
    End Property
    Public Property DateSent() As Nullable(Of Date)
        Get
            Return mDateSent
        End Get
        Set(ByVal value As Nullable(Of Date))
            mDateSent = value
            PropertyHasChanged("DateSent")
        End Set
    End Property

#End Region

#Region " Constructors "
    Private Sub New()
        Me.CreateNew()
    End Sub
#End Region

#Region " Factory Methods "
    Public Shared Function NewEmailBlast() As EmailBlast
        Return New EmailBlast
    End Function

    Public Shared Function [Get](ByVal id As Integer) As EmailBlast
        Return EmailBlastProvider.Instance.SelectEmailBlast(id)
    End Function

    Public Shared Function GetAll() As EmailBlastCollection
        Return EmailBlastProvider.Instance.SelectAllEmailBlasts()
    End Function
    Public Shared Function GetByMAILINGSTEPId(ByVal mAILINGSTEPId As Integer) As EmailBlastCollection
        Return EmailBlastProvider.Instance.SelectEmailBlastsByMAILINGSTEPId(mAILINGSTEPId)
    End Function
    Public Shared Function GetByEmailBlastId(ByVal emailBlastId As Integer) As EmailBlastCollection
        Return EmailBlastProvider.Instance.SelectEmailBlastsByEmailBlastId(emailBlastId)
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
        Me.ValidationRules.AddRule(AddressOf Validation.IntegerMinValue, New Validation.IntegerMinValueRuleArgs("EmailBlastId", 1))
        Me.ValidationRules.AddRule(AddressOf Validation.IntegerMinValue, New Validation.IntegerMinValueRuleArgs("DaysFromStepGen", 1))

    End Sub
#End Region

#Region " Data Access "
    Protected Overrides Sub CreateNew()
        'Set default values here

        'Optionally finish by validating default values
        ValidationRules.CheckRules()
    End Sub

    Protected Overrides Sub Insert()
        Id = EmailBlastProvider.Instance.InsertEmailBlast(Me)
    End Sub

    Protected Overrides Sub Update()
        EmailBlastProvider.Instance.UpdateEmailBlast(Me)
    End Sub
    Protected Overrides Sub DeleteImmediate()
        EmailBlastProvider.Instance.DeleteEmailBlast(Me)
    End Sub

#End Region

#Region " Public Methods "

#End Region

End Class


