Imports Nrc.Qualisys.Library

Public Class MedicareSelectionChangedEventArgs
    Inherits System.EventArgs

#Region " Private Members "

    Private mMedicareNumber As MedicareNumber

#End Region

#Region " Public Properties "

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
