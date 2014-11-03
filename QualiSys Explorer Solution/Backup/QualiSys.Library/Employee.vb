Imports NRC.Framework.BusinessLogic

Public Interface IEmployee

    Property Id() As Integer

End Interface

''' <summary>
''' Represents an Employee in the QualiSys system
''' </summary>
<Serializable()> _
Public Class Employee
    Inherits BusinessBase(Of Employee)
    Implements IEmployee

#Region " Private Fields "

    <NotUndoable()> Private mInstanceGuid As Guid = Guid.NewGuid
    Private mId As Integer
    Private mFirstName As String = String.Empty
    Private mLastName As String = String.Empty
    Private mTitle As String = String.Empty
    Private mNTLoginName As String = String.Empty
    Private mEmail As String = String.Empty

#End Region

#Region " Public Properties "

    Public Property Id() As Integer Implements IEmployee.Id
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

    Public Property FirstName() As String
        Get
            Return mFirstName
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mFirstName Then
                mFirstName = value
                PropertyHasChanged("FirstName")
            End If
        End Set
    End Property

    Public Property LastName() As String
        Get
            Return mLastName
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mLastName Then
                mLastName = value
                PropertyHasChanged("LastName")
            End If
        End Set
    End Property

    Public Property Title() As String
        Get
            Return mTitle
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mTitle Then
                mTitle = value
                PropertyHasChanged("Title")
            End If
        End Set
    End Property

    Public Property NTLoginName() As String
        Get
            Return mNTLoginName
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mNTLoginName Then
                mNTLoginName = value
                PropertyHasChanged("NTLoginName")
            End If
        End Set
    End Property

    Public Property Email() As String
        Get
            Return mEmail
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mEmail Then
                mEmail = value
                PropertyHasChanged("Email")
            End If
        End Set
    End Property

    Public ReadOnly Property FullName() As String
        Get
            Return String.Format("{0} {1}", mFirstName, mLastName).Trim
        End Get
    End Property

#End Region

#Region " Constructors "

    Private Sub New()

        Me.CreateNew()

    End Sub

#End Region

#Region " Factory Methods "

    Public Shared Function NewEmployee() As Employee

        Return New Employee

    End Function

    Public Shared Function GetEmployee(ByVal employeeId As Integer) As Employee

        Return DataProvider.EmployeeProvider.Instance.[Select](employeeId)

    End Function

    Public Shared Function GetEmployeeByLoginName(ByVal loginName As String) As Employee

        Return DataProvider.EmployeeProvider.Instance.SelectByLoginName(loginName)

    End Function

    Public Shared Function GetAllActive() As EmployeeCollection

        Return DataProvider.EmployeeProvider.Instance.SelectAllEmployees()

    End Function

    Public Shared Function GetAllStudyUnAuthorized(ByVal studyID As Integer) As EmployeeCollection

        Return DataProvider.EmployeeProvider.Instance.SelectAllUnAuthEmployees(studyID)

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
