Imports System.Drawing
Imports System.Windows.Forms
Namespace WinForms
    Public Class ScreenScraper


#Region " Win API Methods "
        <System.Runtime.InteropServices.DllImportAttribute("gdi32.dll")> _
        Private Shared Function BitBlt( _
                        ByVal hdcDest As IntPtr, _
                        ByVal nXDest As Integer, _
                        ByVal nYDest As Integer, _
                        ByVal nWidth As Integer, _
                        ByVal nHeight As Integer, _
                        ByVal hdcSrc As IntPtr, _
                        ByVal nXSrc As Integer, _
                        ByVal nYSrc As Integer, _
                        ByVal dwRop As Integer _
                    ) As Boolean
        End Function

        <System.Runtime.InteropServices.DllImportAttribute("gdi32.dll")> _
        Private Shared Function CreateDC( _
                        ByVal lpszDriver As String, _
                        ByVal lpszDevice As String, _
                        ByVal lpszOutput As String, _
                        ByVal lpInitData As IntPtr _
                    ) As IntPtr
        End Function

        <System.Runtime.InteropServices.DllImportAttribute("User32.dll")> _
        Private Shared Function GetDC(ByVal hWnd As IntPtr) As IntPtr
        End Function

        <System.Runtime.InteropServices.DllImportAttribute("User32.dll")> _
        Private Shared Function ReleaseDC(ByVal hWnd As IntPtr, ByVal hDC As IntPtr) As Integer
        End Function

#End Region

        Public Shared Function CaptureScreen() As Bitmap
            Dim desktopDC As IntPtr = GetDC(IntPtr.Zero)
            Dim bmp As New Bitmap(SystemInformation.VirtualScreen.Width, SystemInformation.VirtualScreen.Height)
            Dim g As Graphics = Graphics.FromImage(bmp)
            Dim bmpDC As IntPtr = g.GetHdc

            BitBlt(bmpDC, 0, 0, bmp.Width, bmp.Height, desktopDC, 0, 0, 13369376)
            ReleaseDC(IntPtr.Zero, desktopDC)
            g.ReleaseHdc(bmpDC)

            g.Dispose()

            Return bmp
        End Function

        Public Shared Function CaptureControl(ByVal ctrl As Control) As Bitmap
            Dim srcDC As IntPtr = GetDC(ctrl.Handle)
            Dim bmp As New Bitmap(ctrl.Width, ctrl.Height)
            Dim g As Graphics = Graphics.FromImage(bmp)
            Dim bmpDC As IntPtr = g.GetHdc

            BitBlt(bmpDC, 0, 0, bmp.Width, bmp.Height, srcDC, 0, 0, 13369376)
            ReleaseDC(ctrl.Handle, srcDC)
            g.ReleaseHdc(bmpDC)

            g.Dispose()

            Return bmp
        End Function

        ''' -----------------------------------------------------------------------------
        ''' <summary>
        ''' Captures current screen pixels and stores them to a Bitmap object
        ''' </summary>
        ''' <returns>returns a Bitmap object of the screen capture</returns>
        ''' <remarks>
        ''' </remarks>
        ''' <history>
        ''' 	[JCamp]	7/7/2004	Created
        ''' </history>
        ''' -----------------------------------------------------------------------------
        Public Shared Function PerformCapture() As Bitmap
            Dim ptr1 As IntPtr = CreateDC("DISPLAY", Nothing, Nothing, New IntPtr)
            Dim graphics1 As Graphics = Graphics.FromHdc(ptr1)
            Dim rectangle1 As Rectangle
            Dim img As Bitmap

            rectangle1 = Screen.PrimaryScreen.Bounds
            img = New Bitmap(rectangle1.Width, rectangle1.Height, graphics1)

            Dim graphics2 As Graphics = Graphics.FromImage(img)
            ptr1 = graphics1.GetHdc
            Dim ptr2 As IntPtr = graphics2.GetHdc
            rectangle1 = Screen.PrimaryScreen.Bounds
            rectangle1 = Screen.PrimaryScreen.Bounds
            BitBlt(ptr2, 0, 0, rectangle1.Width, rectangle1.Height, ptr1, 0, 0, 13369376)
            graphics1.ReleaseHdc(ptr1)
            graphics2.ReleaseHdc(ptr2)

            Return img
        End Function
    End Class

End Namespace
