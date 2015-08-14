using System;
using System.Collections.Generic;
//using System.Linq;
using System.Text;
using System.Collections;
using System.Runtime.InteropServices;
using System.Windows.Forms;

namespace NRC.Picker.PCLGenWatchdog
{
    public class FoundWindow
    {
        public IntPtr hWnd;
        public string Title;
        public string Classname;
        public uint ProcessId;
    }

    public class EnumDesktopWindows
    {
        const int WM_COMMAND = 0x111;
        const int IDOK = 1;

        const int MAXTITLE = 255;

        private static List<FoundWindow> foundWindows = new List<FoundWindow>();

        private delegate bool EnumDelegate(IntPtr hWnd, int lParam);

        [DllImport("user32.dll", EntryPoint = "FindWindow", SetLastError = true)]
        static extern IntPtr FindWindowByCaption(IntPtr ZeroOnly, string lpWindowName);

        [DllImport("user32.dll", EntryPoint = "EnumDesktopWindows", ExactSpelling = false, CharSet = CharSet.Auto, SetLastError = true)]
        private static extern bool _EnumDesktopWindows(IntPtr hDesktop, EnumDelegate lpEnumCallbackFunction, IntPtr lParam);

        [DllImport("user32.dll", SetLastError = true, CharSet = CharSet.Auto)]
        static extern int _GetWindowTextLength(IntPtr hWnd);

        [DllImport("user32.dll", EntryPoint = "GetWindowText", ExactSpelling = false, CharSet = CharSet.Auto, SetLastError = true)]
        private static extern int _GetWindowText(IntPtr hWnd, StringBuilder lpWindowText, int nMaxCount);

        [DllImport("user32.dll", EntryPoint = "GetClassName", ExactSpelling = false, CharSet = CharSet.Auto, SetLastError = true)]
        private static extern int _GetClassName(IntPtr hWnd, StringBuilder lpWindowText, int nMaxCount);

        [DllImport("user32.dll")] 
        private static extern uint GetWindowThreadProcessId(IntPtr hWnd, out uint lpdwProcessId);

        [DllImport("user32.dll")]
        static extern int SendMessage(IntPtr HWnd, int msg, int wParam, int IParam);

        [DllImport("User32.dll", EntryPoint = "SetForegroundWindow")]
        private static extern IntPtr SetForegroundWindow(IntPtr hWnd);

        [DllImport("user32.dll")]
        static extern bool CloseWindow(IntPtr hWnd);

        [DllImport("user32.dll")]
        private static extern bool PostMessage(
            IntPtr hWnd, // handle to destination window
            UInt32 Msg, // message
            Int32 wParam, // first message parameter
            Int32 lParam // second message parameter
        );

        private static bool EnumWindowsProc(IntPtr hWnd, int lParam)
        {
            string title = GetWindowText(hWnd);
            string className = GetClassName(hWnd);
            uint processId = GetProcessId(hWnd);

            FoundWindow fw = new FoundWindow();
            fw.hWnd = hWnd;
            fw.Title = title;
            fw.Classname = className;
            fw.ProcessId = processId;

            foundWindows.Add(fw);
            return true;


            //if (title.Equals("error !!"))
            //{
            //    SetForegroundWindow(hWnd);
            //    SendKeys.SendWait("{ENTER}");

            //    // PostMessage(hWnd, IDOK, 0x0, 0x0);

            //    // SendMessage(hWnd, WM_COMMAND, IDOK, 0);
            //    // CloseWindow(hWnd);

            //    // SetForegroundWindow(hWnd);
            //    // SendKeys.Send("{ESC}");
            //}
        }


        public static int GetWindowTextLength(IntPtr hWnd)
        {
            return _GetWindowTextLength(hWnd);
        }

        /// <summary>
        /// Returns the caption of a windows by given HWND identifier.
        /// </summary>
        public static string GetWindowText(IntPtr hWnd)
        {
            StringBuilder title = new StringBuilder(MAXTITLE);
            int titleLength = _GetWindowText(hWnd, title, title.Capacity + 1);
            title.Length = titleLength;

            return title.ToString();
        }

        public static string GetClassName(IntPtr hWnd)
        {
            StringBuilder title = new StringBuilder(MAXTITLE);
            int titleLength = _GetClassName(hWnd, title, title.Capacity + 1);
            title.Length = titleLength;

            return title.ToString();
        }

        public static uint GetProcessId(IntPtr hWnd)
        {
            uint processID = 0;
            uint PID = GetWindowThreadProcessId((IntPtr)hWnd, out processID);

            return processID;
        }

        /// <summary>
        /// Returns the caption of all desktop windows.
        /// </summary>
        public static List<FoundWindow> GetDesktopWindowsCaptions()
        {
            foundWindows.Clear();

            EnumDelegate enumfunc = new EnumDelegate(EnumWindowsProc);
            IntPtr hDesktop = IntPtr.Zero; // current desktop
            bool success = _EnumDesktopWindows(hDesktop, enumfunc, IntPtr.Zero);

            if (success)
            {
                return foundWindows;
            }
            else
            {
                // Get the last Win32 error code
                int errorCode = Marshal.GetLastWin32Error();

                string errorMessage = String.Format("EnumDesktopWindows failed with code {0}.", errorCode);
                throw new Exception(errorMessage);
            }
        }

        public static void DismissDialogs(string dialogCaption, string windowCaption)
        {
            bool isInErrorState = false;

            // find window with the caption
            IntPtr hWnd = FindWindowByCaption(IntPtr.Zero, dialogCaption);
            while (hWnd != IntPtr.Zero)
            {
                isInErrorState = true;

                Console.WriteLine(string.Format("'{0}' window was found.", dialogCaption));

                SetForegroundWindow(hWnd);
                SendKeys.SendWait("{ENTER}");

                System.Threading.Thread.Sleep(1000);

                hWnd = FindWindowByCaption(IntPtr.Zero, dialogCaption);
            }

            if (isInErrorState)
            {
                IntPtr hParentWnd = FindWindowByCaption(IntPtr.Zero, windowCaption);
                if (hParentWnd != IntPtr.Zero)
                {
                    Console.WriteLine(string.Format("'{0}' window was found.", windowCaption));

                    CloseWindow(hParentWnd);
                }
                else
                {
                    Console.WriteLine(string.Format("'{0}' window was NOT found.", windowCaption));
                }
            }
        }
    }
}
