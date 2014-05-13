Imports Nrc.Qualisys.Library
''' <summary>HCAHPS Section control</summary>
''' <CreatedBy>Tony Piccoli</CreatedBy>
''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
Public Class HCAHPSMngrSection
    Friend WithEvents mNavigator As HCAHPSMngrNavigator
    Private mMedicareGlobalDefault As MedicareGlobalCalculationDefault
    Private months As List(Of String)

#Region " Constructors "
    Public Sub New()

        ' This call is required by the Windows Form Designer.
        InitializeComponent()

        ' Add any initialization after the InitializeComponent() call.

    End Sub
#End Region
   
#Region "baseclass Overrides"
    Public Overrides Sub RegisterNavControl(ByVal navCtrl As Navigator)
        Me.mNavigator = DirectCast(navCtrl, HCAHPSMngrNavigator)
    End Sub
    Public Overrides Function AllowInactivate() As Boolean
        Return True
    End Function
#End Region

#Region " Event Handlers "    
    ''' <summary>When use selects a date, add it to the list of selected dates for proportion calculation times.</summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub cmdAddReCalcDate_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdAddReCalcDate.Click
        Dim dte As String = Me.cboPropCalcMonth.SelectedValue.ToString
        Dim blnValid As Boolean = True
        Dim msg As String = String.Empty

        For Each obj As Object In Me.lstRecalcDates.Items
            Dim temp As String = DirectCast(obj, System.String)
            If dte = temp Then
                blnValid = False
                msg = "The month you have chosen already exists in the list."
                Exit For
            End If
        Next

        If blnValid Then
            Me.lstRecalcDates.Items.Add(dte)
            ResortCalcList()
        Else
            MessageBox.Show(msg)
        End If
    End Sub

    ''' <summary>Removes proportion calculation dates when from selected list of dates.</summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub cmdRemovePropCalcDate_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdRemovePropCalcDate.Click
        If Me.lstRecalcDates.Items.Count = 0 Then
            MessageBox.Show("There are no months to remove.")
        ElseIf Me.lstRecalcDates.SelectedItems.Count = 0 Then
            MessageBox.Show("There are no selected months to remove.")
        Else
            Dim lst As List(Of Integer) = New List(Of Integer)
            For Each i As Integer In Me.lstRecalcDates.SelectedIndices
                lst.Add(i)
            Next
            Dim blnFound As Boolean = False
            For i As Integer = (Me.lstRecalcDates.Items.Count - 1) To 0 Step -1
                For Each item As Integer In lst
                    If i = item Then
                        blnFound = True
                        Exit For
                    End If
                Next
                If blnFound Then
                    Me.lstRecalcDates.Items.RemoveAt(i)
                    blnFound = False
                End If
            Next

        End If
    End Sub

    ''' <summary>Call method to Populate the fields on this section</summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub HCAHPSMngrSection_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        Dim ar() As String = {"January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"}
        months = New List(Of String)
        months.AddRange(ar)
        Me.cboPropCalcMonth.DataSource = months
        InitHCAHPSSection()
    End Sub

    ''' <summary>Clears the section inputs and repopulates from the database.</summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub cmdCancel_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdCancel.Click
        If MessageBox.Show("Are you sure you want to cancel?", "Cancel Update", MessageBoxButtons.OKCancel, MessageBoxIcon.Question) = DialogResult.OK Then
            InitHCAHPSSection()
        End If
    End Sub
#End Region

#Region " Private methods "
    Private Function ConvertToLongMonth(ByVal mm As Integer) As String
        Return months(mm - 1)
    End Function
    Private Sub ResortCalcList()
        Dim lstItems As List(Of Integer)
        lstItems = New List(Of Integer)
        For i As Integer = 0 To Me.lstRecalcDates.Items.Count - 1
            lstItems.Add(CDate(DirectCast(Me.lstRecalcDates.Items(i), String) & "1, 2008").Month)            
        Next
        lstItems.Sort()
        Me.lstRecalcDates.Items.Clear()
        For Each i As Integer In lstItems
            Me.lstRecalcDates.Items.Add(ConvertToLongMonth(i))
        Next
    End Sub
    ''' <summary>Populates the fields on this section with properties for the Medicare Global Default objects.</summary>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Sub InitHCAHPSSection()
        Dim mMedicareGlobalDefaultcollection As MedicareGlobalCalculationDefaultCollection = MedicareGlobalCalculationDefault.GetAll        

        If mMedicareGlobalDefaultcollection.Count = 0 Then
            Me.mMedicareGlobalDefault = MedicareGlobalCalculationDefault.NewMedicareGlobalCalculationDefault
        Else
            Me.mMedicareGlobalDefault = mMedicareGlobalDefaultcollection(0)
        End If
        txtAnnualReturnRate.DataBindings.Clear()
        Me.txtResponseRate.DataBindings.Clear()
        Me.txtPropCalcThreshold.DataBindings.Clear()
        Me.txtInEligibleRate.DataBindings.Clear()
        Me.txtFocusCensus.DataBindings.Clear()        
        Me.txtAnnualReturnRate.DataBindings.Add("Text", Me.mMedicareGlobalDefault, "AnnualReturnTarget")
        Me.txtResponseRate.DataBindings.Add("Text", Me.mMedicareGlobalDefault, "RespRateDisplay")
        Me.txtPropCalcThreshold.DataBindings.Add("Text", Me.mMedicareGlobalDefault, "ProportionChangeThresholdDisplay")
        Me.txtInEligibleRate.DataBindings.Add("Text", Me.mMedicareGlobalDefault, "IneligibleRateDisplay")
        Me.txtFocusCensus.DataBindings.Add("Text", Me.mMedicareGlobalDefault, "ForceCensusSamplePercentageDisplay")
        Me.ErrorProvider1.DataSource = Me.mMedicareGlobalDefault

        lstRecalcDates.Items.Clear()
        For Each item As MedicareGlobalCalcDate In Me.mMedicareGlobalDefault.MedicareCalcDateCollection
            Me.lstRecalcDates.Items.Add(ConvertToLongMonth(item.ReCalcMonth))
        Next
        ResortCalcList()
    End Sub

    ''' <summary>Validates and Updates the medicare global object and calc dates.</summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub cmdApply_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdApply.Click
        Me.mMedicareGlobalDefault.MedicareCalcDateCollection.Clear()
        For Each item As Object In Me.lstRecalcDates.Items
            Dim dte As Date = CDate(CStr(item) & "1, 2008")
            Me.mMedicareGlobalDefault.MedicareCalcDateCollection.Add(MedicareGlobalCalcDate.NewMedicareGlobalCalcDate(Me.mMedicareGlobalDefault.MedicareGlobalCalculationDefaultId, dte.Month))
        Next
        Dim blnValid As Boolean = Me.mMedicareGlobalDefault.ValidateAll
        If blnValid Then
            Me.mMedicareGlobalDefault.Save()
            InitHCAHPSSection()
            MessageBox.Show("Changes have been saved.", "Save Successful", MessageBoxButtons.OK, MessageBoxIcon.Asterisk)
        Else
            MessageBox.Show("The data you have entered is not valid.  Save will be aborted.", "Validation Errors have Occured", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End If
    End Sub
#End Region

End Class
