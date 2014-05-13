Namespace ORYX
    Public Class OryxClientSettings

        Private OryxClients As Dictionary(Of Int32, String)
        Private AllMeasurements As List(Of Int32)
        Private SelectedMeasurements As List(Of Int32)
        Private SelectedHCO As Int32
        Public ReadOnly Property SelectedHCOID() As Int32
            Get
                Return SelectedHCO
            End Get
        End Property
        Private _NeedSaved As Boolean = False
        Public ReadOnly Property NeedSaved() As Boolean
            Get
                Return _NeedSaved
            End Get
        End Property
        Public Sub New()
            GetOryxClients()
            RefreshMeasurements(-1)
        End Sub
        Public Function AllOryxClients(ByVal Refresh As Boolean) As Dictionary(Of Int32, String)
            If Refresh Then
                GetOryxClients()
            End If
            Return OryxClients
        End Function
        Private Sub GetOryxClients()
            OryxClients = DataProvider.Instance.SelectAllOryxClients()
        End Sub
        Public Function AllNonOryxClients() As Dictionary(Of Int32, String)
            Return DataProvider.Instance.SelectAllNonOryxClients()
        End Function
        Public Function AddOryxClient(ByVal HCOID As Int32, ByVal Clientid As Int32) As Boolean
            Return DataProvider.Instance.AddOryxClient(HCOID, Clientid)
        End Function
        Public Function AllOryxMeasurements(ByVal Refresh As Boolean) As List(Of Int32)
            If Refresh Then
                RefreshMeasurements(-1)
            End If
            Return AllMeasurements
        End Function
        Public Function HCOMeasurements(ByVal HCOID As Int32) As List(Of Int32)
            If Not HCOID = SelectedHCO Then
                RefreshMeasurements(HCOID)
            End If
            Return SelectedMeasurements
        End Function
        Public Sub RefreshMeasurements(ByVal HCOID As Int32)
            AllMeasurements = DataProvider.Instance.SelectOryxMeasurements()
            SelectedHCO = HCOID
            SelectedMeasurements = DataProvider.Instance.SelectOryxMeasurements(HCOID)
            RemoveSelectedMeasuresFromAllMeasures()
            _NeedSaved = False
        End Sub
        Private Sub RemoveSelectedMeasuresFromAllMeasures()
            AllMeasurements = DataProvider.Instance.SelectOryxMeasurements()
            For Each m As Int32 In SelectedMeasurements
                If AllMeasurements.Contains(m) Then
                    AllMeasurements.Remove(m)
                End If
            Next
        End Sub
        Public Sub AddMeasurement(ByVal MeasurementID As Int32)
            If Not SelectedMeasurements.Contains(MeasurementID) Then
                SelectedMeasurements.Add(MeasurementID)
                RemoveSelectedMeasuresFromAllMeasures()
                _NeedSaved = True
            End If
        End Sub
        Public Sub RemoveMeasurement(ByVal measurementid As Int32)
            If SelectedMeasurements.Contains(measurementid) Then
                SelectedMeasurements.Remove(measurementid)
                RemoveSelectedMeasuresFromAllMeasures()
                _NeedSaved = True
            End If
        End Sub
        Public Sub AbandonChanges()
            RefreshMeasurements(SelectedHCO)
        End Sub
        Public Sub SaveChanges()
            If NeedSaved Then
                If SelectedHCO > 0 Then
                    DataProvider.Instance.DeleteAllHCOMeasurements(SelectedHCO)
                    For Each m As Int32 In SelectedMeasurements
                        DataProvider.Instance.AddHCOMeasurement(SelectedHCO, m)
                    Next
                End If
            End If
            RefreshMeasurements(SelectedHCO)
        End Sub
    End Class
End Namespace
