Option Strict On

Public Class USNormSettingCollection
    Inherits CollectionBase

#Region " Public Properties"

    Default Public Overloads Property Item(ByVal index As Integer) As USNormSetting
        Get
            Return CType(MyBase.List.Item(index), USNormSetting)
        End Get
        Set(ByVal Value As USNormSetting)
            MyBase.List.Item(index) = Value
        End Set
    End Property

    Public Sub Add(ByVal dest As USNormSetting)
        MyBase.List.Add(dest)
    End Sub

#End Region

End Class
