using Microsoft.VisualBasic;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Diagnostics;
//This class adds a Path property to the exception class and can be used to
//track invalid directories or file paths..
namespace NRC.Miscellaneous
{

	public class Exception_PathNotFound : Exception
	{


		private string _strPath;
		public string Path {
			get { return _strPath; }
			set { _strPath = value; }
		}

		public Exception_PathNotFound(string Path) : base("An exception occurred when trying access this path: " + Path)
		{
			this._strPath = Path;
		}

		public Exception_PathNotFound(string Path, Exception Inner) : base("An exception occurred when trying access this path: " + Path, Inner)
		{
			this._strPath = Path;
		}

	}

}
