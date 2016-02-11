Imports System.Drawing.Printing
Imports PS.Framework.BusinessLogic

Public Class Printer
    Public Enum PrintDuplex
        DefaultSetting = 0
        Simplex = 1
        Vertical = 2
        Horizontal = 3
    End Enum
#Region " Private Fields "
    Private mPrinterName As String = Config.Printer
    Private mIsInstalled As Boolean = False
    Private mIsDefaultPrinter As Boolean = False
    Private mValidations As New Validation.ObjectValidations
    Public Const CLASSNAME As String = "Printer"
#End Region
#Region " Properties "
    Public ReadOnly Property PrinterName() As String
        Get
            Return Me.mPrinterName
        End Get
    End Property
    Public ReadOnly Property IsInstalled() As Boolean
        Get
            Return Me.mIsInstalled
        End Get
    End Property
    Public ReadOnly Property IsDefaultPrinter() As Boolean
        Get
            Return Me.mIsDefaultPrinter
        End Get
    End Property
#End Region
#Region " Constructors "
    Private Sub New()        
        Me.mIsInstalled = IsPrinterInstallled()
        If Not Me.IsInstalled Then
            Me.mValidations.Add(New Validation.ObjectValidation(MessageTypes.Print, CommonMethods.VTToString(ValidationTypes.File), CLASSNAME, _
                            "New", "", "Select Printer is not valid."))
        Else
            Me.mIsDefaultPrinter = IsPrinterDefaultPrinter()
            If Not Me.IsDefaultPrinter Then
                Me.mValidations.Add(New Validation.ObjectValidation(MessageTypes.Print, CommonMethods.VTToString(ValidationTypes.File), CLASSNAME, _
                            "New", "", PrinterName & " is not the default printer."))
            End If
        End If
    End Sub
#End Region
#Region " Factory calls "
    Public Shared Function GetPrinter() As Printer
        Return New Printer()
    End Function
#End Region

#Region " Private Methods "
    Private Function IsPrinterInstallled() As Boolean        
        For Each installedPrinter As String In PrinterSettings.InstalledPrinters            
            If (PrinterName.ToUpper = installedPrinter.ToUpper) Then Return True
        Next
        Return False
    End Function
    Private Function IsPrinterDefaultPrinter() As Boolean
        Dim prtDoc As New PrintDocument
        Dim defaultPrinter As String = prtDoc.PrinterSettings.PrinterName
        If PrinterName.ToUpper = defaultPrinter.ToUpper Then
            Return True
        End If
        Return False
    End Function
#End Region




End Class
