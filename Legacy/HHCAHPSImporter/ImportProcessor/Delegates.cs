using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace HHCAHPSImporter.ImportProcessor
{
    public delegate void InfoEventHandler(string message);
    public delegate void ErrorEventHandler(string message, Exception ex);
}
