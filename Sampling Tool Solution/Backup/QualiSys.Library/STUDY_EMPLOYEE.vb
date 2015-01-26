Imports NRC.Framework.BusinessLogic

Public Interface ISTUDY_EMPLOYEE
	Property EMPLOYEEId As Integer
	Property STUDYId As Integer
End Interface

<Serializable()> _
Public Class STUDY_EMPLOYEE
	Inherits BusinessBase(Of STUDY_EMPLOYEE)
	Implements ISTUDY_EMPLOYEE

#Region " Private Fields "
	Private mInstanceGuid As Guid = Guid.NewGuid
	Private mEMPLOYEEId As Integer
    Private mSTUDYId As Integer
    Private mEmployeeName As String
#End Region

#Region " Public Properties "
	Public Property EMPLOYEEId As Integer Implements ISTUDY_EMPLOYEE.EMPLOYEEId
		Get
			Return mEMPLOYEEId
		End Get
		Private Set(ByVal value As Integer)
			If Not value = mEMPLOYEEId Then
				mEMPLOYEEId = value
				PropertyHasChanged("EMPLOYEEId")
			End If		
		End Set
	End Property
	Public Property STUDYId As Integer Implements ISTUDY_EMPLOYEE.STUDYId
		Get
			Return mSTUDYId
		End Get
		Private Set(ByVal value As Integer)
			If Not value = mSTUDYId Then
				mSTUDYId = value
				PropertyHasChanged("STUDYId")
			End If		
		End Set
	End Property
    Public Property EmployeeName() As String
        Get
            Return mEmployeeName
        End Get
        Set(ByVal value As String)
            If Not value = mEmployeeName Then
                mEmployeeName = value
                PropertyHasChanged("EmployeeName")
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
	Public Shared Function NewSTUDY_EMPLOYEE As STUDY_EMPLOYEE
		Return New STUDY_EMPLOYEE
	End Function
    Public Shared Function [Get](ByVal eMPLOYEEId As Integer) As STUDY_EMPLOYEE
        Return STUDY_EMPLOYEEProvider.Instance.SelectSTUDY_EMPLOYEE(eMPLOYEEId)
    End Function
    Public Shared Function GetAll() As STUDY_EMPLOYEECollection
        Return STUDY_EMPLOYEEProvider.Instance.SelectAllSTUDY_EMPLOYEEs()
    End Function
	Public Shared Function GetByEMPLOYEEId(ByVal eMPLOYEEId As Integer) As STUDY_EMPLOYEECollection
		Return STUDY_EMPLOYEEProvider.Instance.SelectSTUDY_EMPLOYEEsByEMPLOYEEId(eMPLOYEEId)
	End Function
	Public Shared Function GetBySTUDYId(ByVal sTUDYId As Integer) As STUDY_EMPLOYEECollection
		Return STUDY_EMPLOYEEProvider.Instance.SelectSTUDY_EMPLOYEEsBySTUDYId(sTUDYId)
    End Function
    Public Shared Function GetAllWithFullAccess() As STUDY_EMPLOYEECollection
        Return STUDY_EMPLOYEEProvider.Instance.SelectAllFullAccessSTUDY_EMPLOYEEs
    End Function
#End Region

#Region " Basic Overrides "
    Protected Overrides Function GetIdValue() As Object
        If Me.IsNew Then
            Return mInstanceGuid
        Else
            Return mEMPLOYEEId
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
	
	Protected Overrides Sub Insert()
		EMPLOYEEId = STUDY_EMPLOYEEProvider.Instance.InsertSTUDY_EMPLOYEE(Me)
	End Sub
	
	Protected Overrides Sub Update
		STUDY_EMPLOYEEProvider.Instance.UpdateSTUDY_EMPLOYEE(Me)
	End Sub
	Protected Overrides Sub DeleteImmediate()
		STUDY_EMPLOYEEProvider.Instance.DeleteSTUDY_EMPLOYEE(Me)
	End Sub

#End Region

#Region " Public Methods "

#End Region

End Class


