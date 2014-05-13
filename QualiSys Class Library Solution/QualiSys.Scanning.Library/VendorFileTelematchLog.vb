Imports NRC.Framework.BusinessLogic

Public Interface IVendorFileTelematchLog

    Property Id() As Integer

End Interface

<Serializable()> _
Public Class VendorFileTelematchLog
    Inherits BusinessBase(Of VendorFileTelematchLog)
    Implements IVendorFileTelematchLog

#Region " Private Fields "

    Private mInstanceGuid As Guid = Guid.NewGuid
    Private mId As Integer
    Private mVendorFileId As Integer
    Private mDateSent As Date
    Private mDateReturned As Date
    Private mRecordsReturned As Integer
    Private mDateOverdueNoticeSent As Date

#End Region

#Region " Public Properties "

    Public Property Id() As Integer Implements IVendorFileTelematchLog.Id
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

    Public Property VendorFileId() As Integer
        Get
            Return mVendorFileId
        End Get
        Set(ByVal value As Integer)
            If Not value = mVendorFileId Then
                mVendorFileId = value
                PropertyHasChanged("VendorFileId")
            End If
        End Set
    End Property

    Public Property DateSent() As Date
        Get
            Return mDateSent
        End Get
        Set(ByVal value As Date)
            If Not value = mDateSent Then
                mDateSent = value
                PropertyHasChanged("DateSent")
            End If
        End Set
    End Property

    Public Property DateReturned() As Date
        Get
            Return mDateReturned
        End Get
        Set(ByVal value As Date)
            If Not value = mDateReturned Then
                mDateReturned = value
                PropertyHasChanged("DateReturned")
            End If
        End Set
    End Property

    Public Property RecordsReturned() As Integer
        Get
            Return mRecordsReturned
        End Get
        Set(ByVal value As Integer)
            If Not value = mRecordsReturned Then
                mRecordsReturned = value
                PropertyHasChanged("RecordsReturned")
            End If
        End Set
    End Property

    Public Property DateOverdueNoticeSent() As Date
        Get
            Return mDateOverdueNoticeSent
        End Get
        Set(ByVal value As Date)
            If Not value = mDateOverdueNoticeSent Then
                mDateOverdueNoticeSent = value
                PropertyHasChanged("DateOverdueNoticeSent")
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

    Public Shared Function NewVendorFileTelematchLog() As VendorFileTelematchLog

        Return New VendorFileTelematchLog

    End Function

    Public Shared Function [Get](ByVal id As Integer) As VendorFileTelematchLog

        Return VendorFileTelematchLogProvider.Instance.SelectVendorFileTelematchLog(id)

    End Function

    Public Shared Function GetAll() As VendorFileTelematchLogCollection

        Return VendorFileTelematchLogProvider.Instance.SelectAllVendorFileTelematchLogs()

    End Function

    Public Shared Function GetByVendorFileId(ByVal vendorFileId As Integer) As VendorFileTelematchLogCollection

        Return VendorFileTelematchLogProvider.Instance.SelectVendorFileTelematchLogsByVendorFileId(vendorFileId)

    End Function

    Public Shared Function GetByNotReturned() As VendorFileTelematchLogCollection

        Return VendorFileTelematchLogProvider.Instance.SelectVendorFileTelematchLogByNotReturned()

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

    Protected Overrides Sub Insert()

        Id = VendorFileTelematchLogProvider.Instance.InsertVendorFileTelematchLog(Me)

    End Sub

    Protected Overrides Sub Update()

        VendorFileTelematchLogProvider.Instance.UpdateVendorFileTelematchLog(Me)

    End Sub

    Protected Overrides Sub DeleteImmediate()

        VendorFileTelematchLogProvider.Instance.DeleteVendorFileTelematchLog(Me)

    End Sub

#End Region

#Region " Public Methods "

#End Region

End Class


