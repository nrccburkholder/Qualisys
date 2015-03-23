using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace NRC.Picker.PCLGenWatchdog
{
    public class LogWindowTextReader
    {
        private string _tMemoText;
        public string tMemoText
        {
            get { return this._tMemoText; }

        }

        public void ReadLogWindow()
        {
            _tMemoText = "[nothing]";
            _tMemoText = WndSearcher.GetTMemoText();
            if (!string.IsNullOrEmpty(_tMemoText))
            {
                _tMemoText = _tMemoText.ToLower();
            }
        }
    }
}
