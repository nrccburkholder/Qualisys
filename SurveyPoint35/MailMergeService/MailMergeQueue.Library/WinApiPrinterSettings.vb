Imports System
Imports System.Runtime.InteropServices

Module WinApiPrinterSettings

    <DllImport("kernel32.dll", _
               EntryPoint:="GetLastError", _
               SetLastError:=False, _
               ExactSpelling:=True, _
               CallingConvention:=CallingConvention.StdCall)> _
    Public Function GetLastError() As Int32
    End Function

    <DllImport("winspool.Drv", _
               EntryPoint:="ClosePrinter", _
               SetLastError:=True, _
               ExactSpelling:=True, _
               CallingConvention:=CallingConvention.StdCall)> _
    Public Function ClosePrinter(ByVal hPrinter As IntPtr) As Boolean
    End Function

    <DllImport("winspool.Drv", _
               EntryPoint:="DocumentPropertiesA", _
               SetLastError:=True, _
               ExactSpelling:=True, _
               CallingConvention:=CallingConvention.StdCall)> _
    Public Function DocumentProperties( _
                        ByVal hwnd As IntPtr, _
                        ByVal hPrinter As IntPtr, _
                        <MarshalAs(UnmanagedType.LPStr)> ByVal pDeviceNameg As String, _
                        ByVal pDevModeOutput As IntPtr, _
                        ByRef pDevModeInput As IntPtr, _
                        ByVal fMode As Integer _
                    ) As Integer
    End Function

    <DllImport("winspool.Drv", _
               EntryPoint:="GetPrinterA", _
               SetLastError:=True, _
               ExactSpelling:=True, _
               CallingConvention:=CallingConvention.StdCall)> _
    Public Function GetPrinter( _
                        ByVal hPrinter As IntPtr, _
                        ByVal dwLevel As Int32, _
                        ByVal pPrinter As IntPtr, _
                        ByVal dwBuf As Int32, _
                        ByRef dwNeeded As Int32 _
                    ) As Boolean
    End Function

    Declare Function OpenPrinter Lib "winspool.drv" Alias "OpenPrinterA" ( _
                        ByVal pPrinterName As String, _
                        ByRef phPrinter As IntPtr, _
                        ByRef pDefault As PRINTER_DEFAULTS _
                    ) As Integer

    <DllImport("winspool.Drv", _
               EntryPoint:="SetPrinterA", _
               ExactSpelling:=True, _
               SetLastError:=True)> _
    Public Function SetPrinter( _
                        ByVal hPrinter As IntPtr, _
                        ByVal Level As Integer, _
                        ByVal pPrinter As IntPtr, _
                        ByVal Command As Integer _
                    ) As Boolean
    End Function

    <StructLayout(LayoutKind.Sequential)> _
    Public Structure PRINTER_DEFAULTS
        Public pDatatype As IntPtr
        Public pDevMode As IntPtr
        Public DesiredAccess As Integer
    End Structure

    '<StructLayout(LayoutKind.Sequential)> _
    'Public Structure PRINTER_DEFAULTS
    '    Public pDatatype As String
    '    Public pDevMode As DEVMODE
    '    Public DesiredAccess As Integer
    'End Structure

    <StructLayout(LayoutKind.Sequential)> _
    Public Structure PRINTER_INFO_2
        <MarshalAs(UnmanagedType.LPStr)> Public pServerName As String
        <MarshalAs(UnmanagedType.LPStr)> Public pPrinterName As String
        <MarshalAs(UnmanagedType.LPStr)> Public pShareName As String
        <MarshalAs(UnmanagedType.LPStr)> Public pPortName As String
        <MarshalAs(UnmanagedType.LPStr)> Public pDriverName As String
        <MarshalAs(UnmanagedType.LPStr)> Public pComment As String
        <MarshalAs(UnmanagedType.LPStr)> Public pLocation As String
        Public pDevMode As IntPtr
        <MarshalAs(UnmanagedType.LPStr)> Public pSepFile As String
        <MarshalAs(UnmanagedType.LPStr)> Public pPrintProcessor As String
        <MarshalAs(UnmanagedType.LPStr)> Public pDatatype As String
        <MarshalAs(UnmanagedType.LPStr)> Public pParameters As String
        Public pSecurityDescriptor As IntPtr
        Public Attributes As Int32
        Public Priority As Int32
        Public DefaultPriority As Int32
        Public StartTime As Int32
        Public UntilTime As Int32
        Public Status As Int32
        Public cJobs As Int32
        Public AveragePPM As Int32
    End Structure

    Public Const CCDEVICENAME As Short = 32
    Public Const CCFORMNAME As Short = 32

    <StructLayout(LayoutKind.Sequential)> _
    Public Structure DEVMODE
        <MarshalAs(UnmanagedType.ByValTStr, SizeConst:=CCDEVICENAME)> _
        Public dmDeviceName As String
        Public dmSpecVersion As Short
        Public dmDriverVersion As Short
        Public dmSize As Short
        Public dmDriverExtra As Short
        Public dmFields As Integer

        Public dmOrientation As Short
        Public dmPaperSize As Short
        Public dmPaperLength As Short
        Public dmPaperWidth As Short
        Public dmScale As Short
        Public dmCopies As Short
        Public dmDefaultSource As Short
        Public dmPrintQuality As Short

        Public dmColor As Short
        Public dmDuplex As Short
        Public dmYResolution As Short
        Public dmTTOption As Short
        Public dmCollate As Short

        <MarshalAs(UnmanagedType.ByValTStr, SizeConst:=CCFORMNAME)> _
        Public dmFormName As String

        Public dmUnusedPadding As Short
        Public dmBitsPerPel As Short
        Public dmPelsWidth As Integer
        Public dmPelsHeight As Integer
        Public dmDisplayFlags As Integer
        Public dmDisplayFrequency As Integer
    End Structure

    ''added this whole structure
    '<StructLayout(LayoutKind.Sequential)> Public Structure ACL
    '    Public AclRevision As Byte
    '    Public Sbz1 As Byte
    '    Public AclSize As Integer
    '    Public AceCount As Integer
    '    Public Sbz2 As Integer
    'End Structure

    ''added this whole structure
    '<StructLayout(LayoutKind.Sequential)> Public Structure SECURITY_DESCRIPTOR
    '    Public Revision As Byte
    '    Public Sbz1 As Byte
    '    Public Control As Long
    '    Public Owner As Long
    '    Public Group As Long
    '    Public sACL As ACL
    '    Public Dacl As ACL
    'End Structure

    Public Const DM_DUPLEX As Integer = &H1000&
    Public Const DM_MODIFY As Integer = 8

    Public Const DM_COPY As Integer = 2
    Public Const DM_IN_BUFFER As Integer = 8
    Public Const DM_OUT_BUFFER As Integer = 2
    Public Const PRINTER_ACCESS_ADMINISTER As Integer = &H4
    Public Const PRINTER_ACCESS_USE As Integer = &H8
    Public Const STANDARD_RIGHTS_REQUIRED As Integer = &HF0000

    Public Const PRINTER_ALL_ACCESS As Integer = _
                (STANDARD_RIGHTS_REQUIRED Or PRINTER_ACCESS_ADMINISTER Or PRINTER_ACCESS_USE)

    Public Const CCHDEVICENAME As Integer = 32
    Public Const CCHFORMNAME As Integer = 32

    ' ==================================================================
    ' SetPrinterDuplex
    '
    ' Programmatically set the Duplex flag for the specified printer
    ' driver's default properties.
    '
    ' Returns: True on success, False on error. (An error will also

    ' display a message box. This is done for informational value
    ' only. You should modify the code to support better error
    ' handling in your production application.)
    '
    ' Parameters:
    ' sPrinterName - The name of the printer to be used.
    '
    ' nDuplexSetting - One of the following standard settings:
    ' 1 = None
    ' 2 = Duplex on long edge (book)
    ' 3 = Duplex on short edge (legal)
    '
    ' ==================================================================
    Public Function SetPrinterDuplex( _
                        ByVal sPrinterName As String, _
                        ByVal nDuplexSetting As Printer.PrintDuplex _
                    ) As Boolean

        Dim hPrinter As IntPtr

        Dim pd As PRINTER_DEFAULTS

        Dim pinfo As PRINTER_INFO_2 = New PRINTER_INFO_2
        Dim dm As DEVMODE = New DEVMODE

        Dim ptrDM As IntPtr
        Dim ptrPrinterInfo As IntPtr
        Dim sizeOfDevMode As Integer = 0
        Dim lastError As Integer
        Dim yDevModeData() As Byte
        Dim yPInfoMemory() As Byte
        Dim nBytesNeeded As Integer
        Dim nRet As Integer
        Dim nRetBool As Boolean
        Dim nJunk As Int32

        Try

            If (nDuplexSetting < 1) Or (nDuplexSetting > 3) Then
                Throw New ApplicationException("Error: dwDuplexSetting is incorrect.")
                'Exit Function
            End If

            pd.DesiredAccess = PRINTER_ALL_ACCESS
            nRet = OpenPrinter(sPrinterName, hPrinter, pd)
            If (nRet = 0) Or (hPrinter.ToInt32 = 0) Then
                If Err.LastDllError = 5 Then
                    Throw New ApplicationException("Access denied -- See the article for more info.")
                Else
                    Throw New ApplicationException("Cannot open the printer specified " & _
                    "(make sure the printer name is correct).")
                End If
                'Exit Function
            End If

            nRet = DocumentProperties(IntPtr.Zero, hPrinter, sPrinterName, IntPtr.Zero, IntPtr.Zero, 0)
            If (nRet < 0) Then
                Throw New ApplicationException("Cannot get the size of the DEVMODE structure.")
            End If

            Dim iparg As IntPtr = Marshal.AllocCoTaskMem(nRet + 100)

            nRet = DocumentProperties(IntPtr.Zero, hPrinter, sPrinterName, iparg, IntPtr.Zero, DM_OUT_BUFFER)

            If (nRet < 0) Then
                Throw New ApplicationException("Cannot get the DEVMODE structure.")
            End If

            dm = CType(Marshal.PtrToStructure(iparg, dm.GetType), DEVMODE)

            If Not CBool(dm.dmFields And DM_DUPLEX) Then
                Throw New ApplicationException("You cannot modify the duplex flag for this printer " & _
                "because it does not support duplex or the driver " & _
                "does not support setting it from the Windows API.")
            End If

            dm.dmDuplex = CShort(nDuplexSetting)

            Marshal.StructureToPtr(dm, iparg, True)

            nRet = DocumentProperties(IntPtr.Zero, hPrinter, sPrinterName, pinfo.pDevMode, pinfo.pDevMode, DM_IN_BUFFER Or DM_OUT_BUFFER)

            If (nRet < 0) Then
                Throw New ApplicationException("Unable to set duplex setting to this printer.")
            End If

            GetPrinter(hPrinter, 2, IntPtr.Zero, 0, nBytesNeeded)

            If (nBytesNeeded = 0) Then Return False

            ptrPrinterInfo = Marshal.AllocCoTaskMem(nBytesNeeded + 100)

            nRetBool = GetPrinter(hPrinter, 2, ptrPrinterInfo, nBytesNeeded, nJunk)

            If (Not nRetBool) Then
                Throw New ApplicationException("Unable to get shared printer settings.")
            End If

            pinfo = CType(Marshal.PtrToStructure(ptrPrinterInfo, pinfo.GetType), PRINTER_INFO_2)

            pinfo.pDevMode = iparg
            pinfo.pSecurityDescriptor = IntPtr.Zero
            Marshal.StructureToPtr(pinfo, ptrPrinterInfo, True)

            nRetBool = SetPrinter(hPrinter, 2, ptrPrinterInfo, 0)

            'MsgBox(GetLastError())

            Return nRetBool

        Catch ex As Exception
            Throw ex

        Finally
            If (hPrinter.ToInt32 <> 0) Then Call ClosePrinter(hPrinter)
        End Try

    End Function

End Module
