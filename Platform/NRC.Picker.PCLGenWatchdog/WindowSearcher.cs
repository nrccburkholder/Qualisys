using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.InteropServices;


namespace NRC.Picker.PCLGenWatchdog
{

    public class WndSearcher
    {

        const UInt32 WM_SETTEXT = 12;
        const UInt32 WM_GETTEXT = 13; // 0x000D
        const UInt32 WM_GETTEXTLENGTH = 14; // 0x000E


        private static List<string> classes = new List<string>();

        private delegate bool EnumWindowsProc(IntPtr hWnd, ref SearchData data);

        [DllImport("user32.dll")]
        [return: MarshalAs(UnmanagedType.Bool)]
        private static extern bool EnumWindows(EnumWindowsProc lpEnumFunc, ref SearchData data);

        [DllImport("user32.dll", SetLastError = true, CharSet = CharSet.Auto)]
        public static extern int GetClassName(IntPtr hWnd, StringBuilder lpClassName, int nMaxCount);

        [DllImport("user32.dll", CharSet = CharSet.Auto, SetLastError = true)]
        public static extern int GetWindowText(IntPtr hWnd, StringBuilder lpString, int nMaxCount);

        [DllImport("user32.dll", SetLastError = true, CharSet = CharSet.Auto)]
        static extern int GetWindowTextLength(IntPtr hWnd);

        [DllImport("user32.dll", EntryPoint = "SendMessage", CharSet = CharSet.Auto, SetLastError = false)]
        static extern int SendMessageByString(IntPtr hWnd, UInt32 Msg, int wParam, StringBuilder lParam);

        [DllImport("user32.dll", CharSet = CharSet.Auto)]
        public static extern IntPtr SendMessage(IntPtr hWnd, UInt32 Msg, IntPtr wParam, IntPtr lParam);

        //[DllImport("user32.dll", EntryPoint = "SendMessageW")]
        //public static extern IntPtr SendMessageByString(IntPtr hWnd, UInt32 Msg, int wParam, StringBuilder lParam);
        //[DllImport("user32.dll", CharSet = CharSet.Unicode, EntryPoint = "SendMessageW")]
        //public static extern IntPtr SendMessageByString(IntPtr hWnd, UInt32 Msg, IntPtr wParam, String lParam);  

        public static bool TfrmPCLGenerationWindowExists()
        {
            IntPtr hWndParent = SearchForWindow("TfrmPCLGeneration", "PCL Generation");

            if (hWndParent.Equals(IntPtr.Zero))
            {
                return false;
            }

            return true;
        }

        public static string GetTMemoText()
        {
            IntPtr hWndParent = SearchForWindow("TfrmPCLGeneration", "PCL Generation");

            if (hWndParent.Equals(IntPtr.Zero))
            {
                throw new Exception("could not find TfrmPCLGeneration window");
            }

            List<IntPtr> childWindows = ChildWindowSearcher.GetChildWindows(hWndParent);
            foreach (var v in childWindows)
            {
                StringBuilder sb = new StringBuilder(1024);
                GetClassName(v, sb, sb.Capacity);
                if (sb.ToString().Equals("TMemo"))
                {
                    //int length = GetWindowTextLength(v);
                    //StringBuilder sb1 = new StringBuilder(1024);
                    //GetWindowText(v, sb1, sb1.Capacity);
                    int length;
                    StringBuilder sb1;
                    length = SendMessage(v, WM_GETTEXTLENGTH, IntPtr.Zero, IntPtr.Zero).ToInt32();

                    sb1 = new StringBuilder(length+2);
                    SendMessageByString(v, WM_GETTEXT, sb1.Capacity-1, sb1); 

                    return sb1.ToString();
                }
            }

            return string.Empty;
        }

        public static IntPtr SearchForWindow(string wndclass, string title)
        {
            SearchData sd = new SearchData { Wndclass = wndclass, Title = title };
            EnumWindows(new EnumWindowsProc(EnumProc), ref sd);
            return sd.hWnd;
        }

        public static bool EnumProc(IntPtr hWnd, ref SearchData data)
        {
            // Check classname and title 
            // This is different from FindWindow() in that the code below allows partial matches
            StringBuilder sb = new StringBuilder(1024);
            GetClassName(hWnd, sb, sb.Capacity);

            classes.Add(sb.ToString());

            if (sb.ToString().StartsWith(data.Wndclass))
            {
                sb = new StringBuilder(1024);
                GetWindowText(hWnd, sb, sb.Capacity);
                if (sb.ToString().StartsWith(data.Title))
                {
                    data.hWnd = hWnd;
                    return false;    // Found the wnd, halt enumeration
                }
            }
            return true;
        }

        public class SearchData
        {
            // You can put any vars in here...
            public string Wndclass;
            public string Title;
            public IntPtr hWnd;
        }

    }

    public class ChildWindowSearcher
    {
        [DllImport("user32")]
        [return: MarshalAs(UnmanagedType.Bool)]
        public static extern bool EnumChildWindows(IntPtr window, EnumWindowProc callback, IntPtr i);

        /// <summary>
        /// Returns a list of child windows
        /// </summary>
        /// <param name="parent">Parent of the windows to return</param>
        /// <returns>List of child windows</returns>
        public static List<IntPtr> GetChildWindows(IntPtr parent)
        {
            List<IntPtr> result = new List<IntPtr>();
            GCHandle listHandle = GCHandle.Alloc(result);
            try
            {
                EnumWindowProc childProc = new EnumWindowProc(EnumWindow);
                EnumChildWindows(parent, childProc, GCHandle.ToIntPtr(listHandle));
            }
            finally
            {
                if (listHandle.IsAllocated)
                    listHandle.Free();
            }
            return result;
        }

        /// <summary>
        /// Callback method to be used when enumerating windows.
        /// </summary>
        /// <param name="handle">Handle of the next window</param>
        /// <param name="pointer">Pointer to a GCHandle that holds a reference to the list to fill</param>
        /// <returns>True to continue the enumeration, false to bail</returns>
        private static bool EnumWindow(IntPtr handle, IntPtr pointer)
        {
            GCHandle gch = GCHandle.FromIntPtr(pointer);
            List<IntPtr> list = gch.Target as List<IntPtr>;
            if (list == null)
            {
                throw new InvalidCastException("GCHandle Target could not be cast as List<IntPtr>");
            }
            list.Add(handle);
            //  You can modify this to check to see if you want to cancel the operation, then return a null here
            return true;
        }

        /// <summary>
        /// Delegate for the EnumChildWindows method
        /// </summary>
        /// <param name="hWnd">Window handle</param>
        /// <param name="parameter">Caller-defined variable; we use it for a pointer to our list</param>
        /// <returns>True to continue enumerating, false to bail.</returns>
        public delegate bool EnumWindowProc(IntPtr hWnd, IntPtr parameter);

    }
}
