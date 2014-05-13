Imports Nrc.Qualisys.Library

Public Class MedicareSelectionChangingEventArgs
    Inherits System.EventArgs

#Region " Private Members "

    Private mCancel As Boolean = False
    Private mMedicareNumber As MedicareNumber

#End Region

#Region " Public Properties "

    Public Property Cancel() As Boolean
        Get
            Return mCancel
        End Get
        Set(ByVal value As Boolean)
            mCancel = value
        End Set
    End Property

    Public ReadOnly Property MedicareNumber() As MedicareNumber
        Get
            Return mMedicareNumber
        End Get
    End Property

#End Region

#Region " Constructors "

    Public Sub New(ByVal medicareNumber As MedicareNumber)

        mMedicareNumber = medicareNumber

    End Sub

#End Region

End Class
