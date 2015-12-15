using Microsoft.VisualBasic;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Diagnostics;

namespace NRC.Miscellaneous.TableWriters
{
	/// <summary>
	/// This class parses each Field that will be writen to the database
	/// </summary>
	/// <remarks>
	/// This class parses each Field that will be writen to the database.
	/// 
	/// There is some basic validation done within this class to make sure the values passed to this class don't break the SQL statements that will be passed to SQL server.
	/// 
	/// If there is any modification to the data made by this class a warning will be available within the warnings property
	/// </remarks>
	public class TableItem
	{

		private string _sColumnName;
		private string _sFormatType;
		private Type _tFieldType;
		//Private _sRawValue As String = String.Empty
		private string[] _sWarnings = new string[1];
		private int iLength;
		private bool _bIsNull = true;
		private bool _bShowAllExceptions = false;
		private Collection _colTranslation = new Collection();
		private object _oValue;
		//Private _bStringValidations As Boolean

		//require column name, type, and the raw value as input to the constructer
		public TableItem(string ColumnName, string Format, int Length = 0)
		{
			string sFormatType = null;

			this._sColumnName = ColumnName.ToUpper();
			_sFormatType = Format.ToUpper();
			sFormatType = _sFormatType;

			if (sFormatType.Contains("CHAR") || sFormatType.Contains("TEXT") || sFormatType.Contains("STRING")) {
				_tFieldType = Type.GetType("System.String", false, false);
			} else if (sFormatType.Contains("INT")) {
				_tFieldType = Type.GetType("System.Int64", false, false);

			} else if (sFormatType == "DOUBLE" || sFormatType == "FLOAT" || sFormatType == "SINGLE") {
				_tFieldType = Type.GetType("System.Double", false, false);
			} else if (sFormatType.Contains("DATE")) {
				_tFieldType = Type.GetType("System.DateTime", false, false);
			} else if (sFormatType == "BIT" || sFormatType == "BOOLEAN") {
				_tFieldType = Type.GetType("System.Boolean", false, false);
			} else if (sFormatType == "UNIQUEIDENTIFIER" || sFormatType == "GUID") {
				_tFieldType = Type.GetType("System.Guid", false, false);
			} else {
				_tFieldType = Type.GetType("System." + sFormatType, false, false);
			}

			if (_tFieldType == null) {
				throw new Exception("The type " + sFormatType + " is not supported by the Table Item object. Please use a supported Format type");
			}

			this.iLength = Length;

			Array.Resize(ref _sWarnings, 0);

		}

		public TableItem(string ColumnName, Type Format, int Length = 0)
		{
			this._sColumnName = ColumnName.ToUpper();
			_tFieldType = Format;

			this.iLength = Length;

			Array.Resize(ref _sWarnings, 0);
		}

		/// <summary>
		/// Name of the column to be inserted into the table
		/// </summary>
		public string ColumnName {
			get { return _sColumnName; }
		}

		public object DBValue {
			get {
				if (_bIsNull || _oValue == null) {
					return DBNull.Value;
				} else {
					return _oValue;
				}
			}
		}

		/// <summary>
		/// Column type in the table
		/// </summary>
		public string FormatType {
			get { return _sFormatType; }
		}

		/// <summary>
		/// Gets any warning generated when parsing a value
		/// </summary>
		public string Warnings {
			get {
				string sResult = string.Empty;
				string Warning = null;

				foreach (string Warning_loopVariable in _sWarnings) {
					Warning = Warning_loopVariable;
					sResult = sResult + Warning + Environment.NewLine;
				}

				return sResult;
			}
		}

		/// <summary>
		/// Value formated for table insertion
		/// </summary>
		public string Value {
			get {
				//insert null into the database when we have no value
				if (this.IsNull()) {
					return "NULL";
				}

				//strings and dates require single qoutes in T-Sql
				switch (this.FormatType) {
					case "STRING":
					case "DATE":
					case "DATETIME":
					case "VARCHAR":
					case "CHAR":
					case "TEXT":
					case "NVARCHAR":
						return "'" + _oValue.ToString().Replace ("\'", "''") + "'";
					case "INTEGER":
					case "INT":
					case "SMALLINT":
					case "DOUBLE":
					case "FLOAT":
					case "BIT":
					case "BOOLEAN":
						return _oValue.ToString();
					default:
						return _oValue.ToString();
					//    Throw New System.Exception("Invalid type specified for the interpreter's SLWritable item")
				}
			}
		}


		/// <summary>
		/// Value without any formatting
		/// </summary>
		public string RawValue {
			get {
				if (!_bIsNull) {
					return _oValue.ToString();
				} else {
					return "";
				}
			}
		}

		private void SetDBValue(object NewValue)
		{
			_oValue = NewValue;
			_bIsNull = false;
		}

		/// <summary>
		/// Sets the value that will be writen to the database
		/// </summary>
		public void SetValue(object NewValue)
		{
			//Dim Value As String

			if (!object.ReferenceEquals(NewValue.GetType(), _tFieldType)) {
				try {
					SetDBValue(System.Convert.ChangeType(NewValue, _tFieldType));
				} catch {
					if (_bShowAllExceptions) {
						throw;
					} else {
						Array.Resize(ref _sWarnings, _sWarnings.Length + 1);
						_sWarnings[_sWarnings.Length - 1] = "Value '" + Convert.ToString(NewValue) + "' for " + _sColumnName + " is not a valid " + _tFieldType.Name + ". Value has been ignored";
					}
				}
				return;
			} else if (_tFieldType != null) {
				if (_tFieldType.Name.ToUpper() == "STRING") {
					string ParsedValue = null;
					ParsedValue = Convert.ToString(NewValue).Trim();

					if (_colTranslation.Count > 0) {
						if (_colTranslation.Contains(ParsedValue.ToUpper())) {
							SetDBValue(_colTranslation[ParsedValue.ToUpper()].ToString());
						}
					} else if (ParsedValue.Length > iLength && iLength >= 0) {
						if (_bShowAllExceptions) {
							throw new Exception("Value '" + ParsedValue + "' for " + _sColumnName + " is " + (iLength - ParsedValue.Length).ToString() + " characters longer than the field in the database.");
						} else {
							SetDBValue(ParsedValue.Substring(0, iLength));
							Array.Resize(ref _sWarnings, _sWarnings.Length + 1);
							_sWarnings[_sWarnings.Length - 1] = "Value '" + ParsedValue + "' for " + _sColumnName + " is " + (iLength - ParsedValue.Length).ToString() + " characters longer than the field in the database. The last characters have been dropped";
						}
					} else {
						SetDBValue(ParsedValue);
					}

					return;
				}
			}

			//Assumes that the value passed to this method is fine to be used as Query parameter
			//If there is an exception when writing to the database
			//add code above to handle the new exception
			SetDBValue(NewValue);
		}

		/// <summary>
		/// Defines if the class should throw exceptions or just store the warnings in the warnings property
		/// </summary>
		public bool ShowAllExceptions {
			get { return _bShowAllExceptions; }
			set { _bShowAllExceptions = value; }
		}

		/// <summary>
		/// Clears the value, warnings, and filled flag for this item
		/// </summary>
		public void Clear()
		{
			Array.Resize(ref _sWarnings, 0);
			//_sRawValue = String.Empty
			_bIsNull = true;
		}

		/// <summary>
		/// Shows if a value has been filled in this item
		/// </summary>
		/// <remarks>This flag will be cleared when the clear method is called</remarks>
		/// <returns>Boolean</returns>
		public bool IsNull()
		{
			return _bIsNull;
		}

		public int Length {
			get { return iLength; }
			set { iLength = value; }
		}

		/// <summary>
		/// Adds a translation mapping for value translations
		/// </summary>
		/// <remarks>
		/// If there are no translations provided for an specific field, all the values will be allowed.
		/// 
		/// If there are translations, only the translated values will be allowed.
		/// </remarks>
		public void AddValueTranslation(string ValueToUse, string ValueAlias)
		{
			//ValueToUse = ValueToUse;
			ValueAlias = ValueAlias.ToUpper();
			if (!_colTranslation.Contains(ValueAlias)) {
				_colTranslation.Add(ValueToUse, ValueAlias);
			} else {
				throw new System.Exception("Alias name '" + ValueAlias + "' already exists in the translation list for Field " + this.ColumnName + ". Please use a different Alias");
			}
		}

	}
}
