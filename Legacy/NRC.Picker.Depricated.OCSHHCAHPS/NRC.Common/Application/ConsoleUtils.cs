using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Principal;
using System.Text;

namespace NRC.Common.Application
{
    public abstract class ConsoleUtils
    {
        public static string ReadPassword()
        {
            StringBuilder ret = new StringBuilder();
            while (true)
            {
                ConsoleKeyInfo key = Console.ReadKey(true);
                if (key.Key == ConsoleKey.Enter)
                {
                    return ret.ToString();
                }
                else if (key.Key == ConsoleKey.Backspace)
                {
                    if (ret.Length > 0)
                    {
                        ret.Remove(ret.Length - 1, 1);
                    }
                }
                else if (key.KeyChar >= 0x20 && key.KeyChar < 0x7f)
                {
                    ret.Append(key.KeyChar);
                }
                else if (key.Key == ConsoleKey.Escape || (key.Modifiers == ConsoleModifiers.Control && (key.Key == ConsoleKey.C || key.Key == ConsoleKey.Z)))
                {
                    return "";
                }
            }
        }

        // TODO: pull this into another class later, since you might want this from non-console apps
        // http://en.csharp-online.net/Check_if_principal_is_Administrator
        public static bool IsAdministrator()
        {
            WindowsIdentity identity = WindowsIdentity.GetCurrent();
            WindowsPrincipal principal = new WindowsPrincipal(identity);
            return principal.IsInRole(WindowsBuiltInRole.Administrator);
        }
    }
}
