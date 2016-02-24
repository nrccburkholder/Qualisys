using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using NRCFileConverterLibrary.Common;

namespace NRCFileConverterLibrary.Providers
{

   //delegate void BeginConversion(object obj, ConfigurationArgs args);
   //delegate void Convert(object obj, ConfigurationArgs args);
   //delegate void EndConversion(object obj, ConfigurationArgs args);

    interface IProvider
    {
        #region Events
        /// <summary>
        /// Event raised before Event Conversion Begins.
        /// </summary>
        event EventHandler OnBeginConversion;
        /// <summary>
        /// Event raised to do Initialization.
        /// </summary>
        event EventHandler OnInitialize;
        /// <summary>
        /// Event raised once  Conversion is complete.
        /// </summary>
        event EventHandler OnEndConversion;

        /// <summary>
        /// log/trace utilities subscribe to this event. The processor will notify when a log or a trace needs to be written.
        /// </summary>
        event EventHandler<LogTraceArgs> LogTraceListeners;
        
        #endregion //Events

        #region properties

        string Name { get; set; }
        string FileType { get; set; }
        string InputPath { get; set; }
        string InProcessPath { get; set; }
        string OutPath { get; set; }
        string ArchivePath { get; set; }
        string PrimaryKey { get; set; }

        #endregion //properties

        #region Methods

        /// <summary>
        /// File conversion initiated by this Method.
        /// </summary>
        void Convert();

        /// <summary>
        /// Used to implement provider specfic Validation logic.
        /// </summary>
        void Validate();

        #endregion //Methods
    }
}
