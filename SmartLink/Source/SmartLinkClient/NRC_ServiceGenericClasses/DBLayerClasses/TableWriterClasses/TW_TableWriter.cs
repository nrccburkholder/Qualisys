using Microsoft.VisualBasic;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
using System.Diagnostics;

namespace NRC.Miscellaneous.TableWriters
{
	/// Created by: Elibad
	/// Created Date: 2008/06/01
	/// <summary>
	/// This class is the base for any table writer.
	/// </summary>
	/// <remarks>
	/// This class is the base for any table writer it provides the basic functionality that can be used to create a table writer specialized to an specific table
	/// 
	/// This class stores a collection of TableItems that are the valid fields for an specific table
	/// </remarks>
	public abstract class TableWriter
	{
		private string _sTableName;
		private string[] _sTranslationKeys = new string[1];
		private bool _bWriteNulls;
		private string _sDBSourceName;
		private bool _bShowAllExceptions = false;
		private DbProviderFactory _DBFactory;
		private Miscellaneous.Stubborn_SQL_Runner _SQLRunner;
		private string _sDBConnectionType;
		private string _sDBConnectionString;
		private int _iRowsAffected;

		protected string _sPKFieldName;

		#region "Protected"
		//Protected _DBUpdateCommand As Common.DbCommand
		//Protected _DBInsertCommand As Common.DbCommand

		/// <summary>
		/// Stores the main connection object that can be reused during the life of an instance of this class
		/// </summary>

		protected DbConnection _DBConn;
		/// <summary>
		/// This collection stores all the field elements for the table
		/// </summary>
		protected Collection _colElements = new Collection();
		/// <summary>
		/// This collection stores the mapping information for each field in the table
		/// </summary>
		protected Dictionary<string, string> _colTranslation = new Dictionary<string, string>();
		/// <summary>
		/// This collection stores all the different ways a record can be uniquely identified
		/// </summary>
			//New Collection
		protected Dictionary<string, string[]> _colRecordUID = new Dictionary<string, string[]>();


		protected Collection _colDBCommands = new Collection();
		/// <summary>
		/// This variable stores the Last primary key used
		/// </summary>
		/// <remarks>This variable is protected to allow any child class to write to this variable with the proper information if necesary.</remarks>

		protected string _sLastPrimaryKey;
		//Protected MustOverride Function GenerateSQL() As String

		protected abstract string RetrievePK();

		protected abstract string GeneratePKValue();

		protected abstract void CreateMainSQL();

		/// <summary>
		/// Space to create extra translations that an specific table writer can use
		/// </summary>
		protected abstract void AddExtraTranslations();

		/// <summary>
		/// Computes any item that needs to be calculated before writing the data to the database
		/// </summary>
		/// <remarks>This method will be defined in the different implementations of table writers</remarks>

		protected virtual void ComputeCalculatedItems()
		{
		}

		protected TableWriter(string TableName)
		{
			_sTableName = TableName;

			Array.Resize(ref _sTranslationKeys, 0);
		}


		/// <summary>
		/// Adds an element to the colection of items that will be writen to the table in the database
		/// </summary>
		protected void AddItem(TableItem Item)
		{
			if (!_colElements.Contains(Item.ColumnName)) {
				Item.ShowAllExceptions = _bShowAllExceptions;
				_colElements.Add(Item, Item.ColumnName.ToUpper());
				AddFieldMapping(Item.ColumnName, Item.ColumnName);
			} else {
				throw new System.Exception("ColumnName already exists. Please make sure the column name does no exist");
			}
		}

		/// <summary>
		/// Adds the information about the groups of fields that can uniquely identified a record
		/// </summary>
		protected void AddUniqueIdentifier(string Name, string[] FieldNames)
		{
			string sErrMessage = "";

			if (!_colRecordUID.ContainsKey(Name)) {
				if (FieldNames.Length == 1 && Name.ToUpper().StartsWith("PK_")) {
					this._sPKFieldName = FieldNames[0];
				}
				foreach (string sField in FieldNames) {
                    string sf = sField.Trim().ToUpper();
                    if (!_colElements.Contains(sf))
                    {
                        sErrMessage += "The field '" + sf + "' does not exists in the table " + this.TableName + ". " + Environment.NewLine;
					}
				}
				if (string.IsNullOrEmpty(sErrMessage)) {
					_colRecordUID.Add(Name, FieldNames);
				} else {
					sErrMessage += "Please update the table tblDBKeyGroup to reflect the structural changes in the database" + Environment.NewLine;
					throw new System.Exception(sErrMessage);
				}
			} else {
				throw new System.Exception("Record unique identifier already exists, make sure the unique identifier does not exist");
			}
		}

		/// <summary>
		/// Calls the ADO AccessLayer class
		/// </summary>
		protected object DBCommandExecuteScalar(DbCommand DBCommandObject)
		{
			return ADO_AccessLayer.DBCommandExecuteScalar(DBCommandObject);
		}

		/// <summary>
		/// Calls the ADO AccessLayer class
		/// </summary>
		protected DbDataReader DBCommandExecuteReader(DbCommand DBCommandObject)
		{
			return ADO_AccessLayer.DBCommandExecuteReader(DBCommandObject);
		}

		/// <summary>
		/// Calls the ADO AccessLayer class
		/// </summary>
		/// <returns>Integer</returns>
		protected int DBCommandExecuteNonQuery(DbCommand DBCommandObject)
		{
			return ADO_AccessLayer.DBCommandExecuteNonQuery(DBCommandObject);
		}

		/// <summary>
		/// DBFactory object used to create all the database objects
		/// </summary>
		protected DbProviderFactory DBFactory {
			get { return _DBFactory; }
			set {
				_DBFactory = value;
				if (_DBConn == null) {
					_DBConn = _DBFactory.CreateConnection();
				}
			}
		}


		#endregion

		#region "Public"
		/// <summary>
		/// Space to define the colection of Elements that will be writen to the database
		/// </summary>
		/// <remarks>
		/// These element list should match to the fields in the table that the table writer will be writing to.
		/// </remarks>
		public abstract void CreateElementsCollection();

		/// <summary>
		/// The Field name of the UJK field
		/// </summary>
		public string PKFieldName {
			get { return _sPKFieldName; }
		}


		public void OpenConnection()
		{
			if (_DBConn.State != ConnectionState.Open) {
				_DBConn.Open();
			}
		}

		public void CloseConnection()
		{
			if (_DBConn != null) {
				if (_DBConn.State == ConnectionState.Open) {
					_DBConn.Close();
				}
			}

			foreach (DbCommand cmd in _colDBCommands) {
				cmd.Dispose();
			}

			_colDBCommands.Clear();

		}

		/// <summary>
		/// Defines the Connection string that will be used to connect to the database
		/// </summary>
		public string DBConnectionString {
			get { return _sDBConnectionString; }
			set {
				_sDBConnectionString = value;

				if (_DBConn != null) {
					bool bConWasOpen = false;
					if (_DBConn.State == ConnectionState.Open) {
						_DBConn.Close();
						bConWasOpen = true;
					}
					_DBConn.ConnectionString = value;

					if (bConWasOpen) {
						_DBConn.Open();
					}

				}

			}
		}

		/// <summary>
		/// Defines the type of connection string format
		/// </summary>
		public string DBConnectionType {
			get { return _sDBConnectionType; }
			set {
				if (value.ToUpper().Contains("SQL")) {
					this.DBFactory = System.Data.SqlClient.SqlClientFactory.Instance;
				} else if (value.ToUpper().Contains("OLEDB")) {
					this.DBFactory = System.Data.OleDb.OleDbFactory.Instance;
				} else if (value.ToUpper().Contains("ODBC")) {
					this.DBFactory = System.Data.Odbc.OdbcFactory.Instance;
				} else {
					throw new System.Exception("DBConnectionType not supported. Please use a different Connection type");
				}

				_sDBConnectionType = value;
			}
		}

		/// <summary>
		/// Creates values for key fields and writes a collection of SLWritable objects to a given table in the smartlink database
		/// </summary>

		//Dim strSQL As String
		//Dim colIgnore As Collection
		string static_Write_sActiveFields;
		public void Write()
		{
			DbCommand myCMD = null;
			string sPKValue = "";

			if (_colElements == null || _colElements.Count <= 0) {
				this.CreateElementsCollection();
				this.AddExtraTranslations();
			}

			_iRowsAffected = 0;
			ComputeCalculatedItems();

			if (_DBConn.State != ConnectionState.Open) {
				_DBConn.Open();
			}

			if (!_colDBCommands.Contains("INSERT")) {
				this.CreateMainSQL();
				static_Write_sActiveFields = GetActiveFieldList();
			}

			if (!this.WriteNulls && static_Write_sActiveFields != GetActiveFieldList()) {
				this.CreateMainSQL();
				static_Write_sActiveFields = GetActiveFieldList();
			}

			sPKValue = this.RetrievePK();

			if (!string.IsNullOrEmpty(sPKValue)) {
				myCMD = (DbCommand)_colDBCommands["UPDATE"];
			} else {
                myCMD = (DbCommand)_colDBCommands["INSERT"];
				sPKValue = this.GeneratePKValue();
			}

			_sLastPrimaryKey = sPKValue;

			this.SetValue(this.PKFieldName, sPKValue);

			foreach (DbParameter dbParam in myCMD.Parameters) {
                
				dbParam.Value = this.Item(dbParam.ParameterName.Substring(1)).DBValue;
			}

			//For Each Field As TableItem In _colElements
			//    If Me.WriteNulls OrElse Field.IsFilled Then
			//        myCMD.Parameters.Add(Field.DBParameter)
			//    End If
			//Next

			_iRowsAffected = this.SQLRunner.ExecuteNonQuery(myCMD);
		}

		private string GetActiveFieldList()
		{
			string sResult = "";
			int iFieldPosition = 0;
			foreach (TableItem Field in _colElements) {
				iFieldPosition += 1;
				if (Field != null) {
					if (string.IsNullOrEmpty(sResult)) {
						sResult = iFieldPosition.ToString();
					} else {
						sResult += ", " + iFieldPosition.ToString();
					}
				}
			}
			return sResult;
		}

		/// <summary>
		/// Retrieves the Number of rows that were affected for the write method
		/// </summary>
		/// <value>Returns 1 or 0</value>
		public int RowsAffected {
			get { return _iRowsAffected; }
		}

		/// <summary>
		/// Adds a translation mapping to identify a table column using an alias
		/// </summary>
		public void AddFieldMapping(string ColumnName, string AliasName)
		{
			ColumnName = ColumnName.ToUpper();
			AliasName = AliasName.ToUpper();

			if (_colElements == null || _colElements.Count <= 0) {
				this.CreateElementsCollection();
				this.AddExtraTranslations();
			}

			if (_colElements.Contains(ColumnName)) {
				if (_colTranslation.ContainsValue(ColumnName)) {
					//Throw New System.Exception("There is already another Alias pointing to this column." & vbCrLf _
					//    & "Table: " & Me.TableName & vbCrLf _
					//    & "Column Name: " & ColumnName & vbCrLf _
					//    & "Alias: " & AliasName)
					foreach (KeyValuePair<string, string> kpFieldMapping in _colTranslation) {
						if (kpFieldMapping.Value == ColumnName) {
							_colTranslation.Remove(kpFieldMapping.Key);
							break; // TODO: might not be correct. Was : Exit For
						}
					}
				}
				if (_colTranslation.ContainsKey(AliasName)) {
					ColumnName = ColumnName.Trim() + ", " + _colTranslation[AliasName].ToString().Trim();
					_colTranslation.Remove(AliasName);
				}

				//_colTranslation.Add(ColumnName, AliasName) 'Collection Add method receives the Key as the second parameter
				_colTranslation.Add(AliasName, ColumnName);
				//Dictionary Add method receives the Key as teh first parameter
				Array.Resize(ref _sTranslationKeys, _sTranslationKeys.Length + 1);
				_sTranslationKeys[_sTranslationKeys.Length - 1] = AliasName;
			} else {
				throw new System.Exception("Column name '" + ColumnName + "' does not exist. Please use a valid column name");
			}
		}

		/// <summary>
		/// Adds the translation mapping for how some values will be translated for an specific field
		/// </summary>
		public void AddValueTranslation(string ColumnName, string ValueToUse, string ValueAlias)
		{
			ColumnName = ColumnName.ToUpper();
			ValueAlias = ValueAlias.ToUpper();

			if (_colElements == null || _colElements.Count <= 0) {
				this.CreateElementsCollection();
				this.AddExtraTranslations();
			}

			if (_colElements.Contains(ColumnName)) {
				((TableItem)_colElements[ColumnName]).AddValueTranslation(ValueToUse, ValueAlias);
			} else {
				throw new System.Exception("Column name '" + ColumnName + "' does not exist. Please use a valid column name");
			}
		}

		/// <summary>
		/// Retrieves the Primary key value of the last record written to the database
		/// </summary>
		public string LastPrimaryKey {
			get { return _sLastPrimaryKey; }
		}

		/// <summary>
		/// Sets the value to be written to the database
		/// </summary>
		public void SetValue(string Field, object Value)
		{
			Field = Field.ToUpper();

			if (_colElements == null || _colElements.Count <= 0) {
				this.CreateElementsCollection();
				this.AddExtraTranslations();
			}

			if (_colTranslation.ContainsKey(Field) && Value != null) {
				if (_colTranslation[Field].ToString().IndexOf(",") >= 0) {
					foreach (string sColumn in _colTranslation[Field].ToString().Split(',')) {
						string sCol = sColumn.Trim().ToUpper();
                        if (_colElements.Contains(sCol))
                        {
                            ((TableItem)_colElements[sCol]).SetValue(Value);
						}
					}
				} else {
					((TableItem)_colElements[_colTranslation[Field].ToString()]).SetValue(Value);
				}

				//If _colElements.Contains(_colTranslation.Item(Field).ToString) And Value IsNot Nothing Then
				//    Dim TempItem As TableItem = Nothing

				//    TempItem = CType(_colElements.Item(_colTranslation.Item(Field).ToString), TableItem)
				//    TempItem.SetValue(Value)
				//End If
			}
		}

		/// <summary>
		/// Sets the value to be written to the database
		/// </summary>
		public void SetValue(string Field, string Value)
		{
			Field = Field.ToUpper();

			if (_colElements == null || _colElements.Count <= 0) {
				this.CreateElementsCollection();
				this.AddExtraTranslations();
			}

			if (_colTranslation.ContainsKey(Field) && Value != null) {
				if (_colTranslation[Field].ToString().IndexOf(",") >= 0) {
					foreach (string sColumn in _colTranslation[Field].ToString().Split(',')) {
						var sCol = sColumn.Trim().ToUpper();
                        if (_colElements.Contains(sCol))
                        {
                            ((TableItem)_colElements[sCol]).SetValue(Value);
						}
					}
				} else {
					((TableItem)_colElements[_colTranslation[Field].ToString()]).SetValue(Value);
				}

				//If _colElements.Contains(_colTranslation.Item(Field).ToString) And Value IsNot Nothing Then
				//    Dim TempItem As TableItem = Nothing

				//    TempItem = CType(_colElements.Item(_colTranslation.Item(Field).ToString), TableItem)
				//    TempItem.SetValue(Value)
				//End If
			}
		}

		/// <summary>
		/// Array of strings with all the translation mapping information the table writer will be using
		/// </summary>
		/// Public ReadOnly Property SLCollection() As Collection
		///   Get
		///       Return _colElements
		///   End Get
		/// End Property

		public string[] TranslationKeys {
			get { return _sTranslationKeys; }
		}

		/// <summary>
		/// Name of the source database
		/// </summary>
		/// Public Property DBRetryCount() As Integer
		///    Get
		///        Return _iDBRetryCount
		///    End Get
		///    Set(ByVal value As Integer)
		///        _iDBRetryCount = value
		///    End Set
		/// End Property
		/// Public Property DBRetryInterval() As Integer
		///    Get
		///        Return _iDBRetryInterval
		///    End Get
		///    Set(ByVal value As Integer)
		///        _iDBRetryInterval = value
		///    End Set
		/// End Property

		public string DBSourceName {
			get { return _sDBSourceName; }
			set { _sDBSourceName = value; }
		}

		/// <summary>
		/// Name of the table where the data will be writen to
		/// </summary>
		public string TableName {
			get { return _sTableName; }
		}

		/// <summary>
		/// Defines if the class will throw all exceptions
		/// </summary>
		/// <remarks>If this is false then all the exception messages will be stored in the Warnings property</remarks>
		public bool ShowAllExceptions {
			get { return _bShowAllExceptions; }
			set {
				_bShowAllExceptions = value;
				if (_colElements.Count > 0) {
					foreach (TableItem FieldItem in _colElements) {
						FieldItem.ShowAllExceptions = _bShowAllExceptions;
					}
				}
			}
		}

		/// <summary>
		/// This class executes any SQL code that we need to try executing until sucess
		/// </summary>
		public Miscellaneous.Stubborn_SQL_Runner SQLRunner {
			get { return this._SQLRunner; }
			set { this._SQLRunner = value; }
		}

		/// <summary>
		/// Gets the Warnings comming from each field parsed by the table writer
		/// </summary>
		public string Warnings {
			get {
				string sResult = string.Empty;

				foreach (TableItem Field in _colElements) {
					sResult = sResult + Field.Warnings;
				}

				return sResult;
			}
		}

		/// <summary>
		/// Defines whether the Null values should be writen to the database
		/// </summary>
		public bool WriteNulls {
			get { return _bWriteNulls; }
			set { _bWriteNulls = value; }
		}

		/// <summary>
		/// Clears the values, warnings, and filled flag of all the fields inside the table writer
		/// </summary>
		public void ClearValues()
		{
			foreach (TableItem Field in _colElements) {
				Field.Clear();
			}
		}

		/// <summary>
		/// Identifies if the table writer contains an specific field
		/// </summary>
		/// <returns>Boolean</returns>
		public bool Contains(string FieldName)
		{
			return _colElements.Contains(FieldName);
		}

		/// <summary>
		/// Retrieves a table item object for an specific field
		/// </summary>
		public TableItem Item(string FieldName)
        {
            if (_colElements.Contains(FieldName))
            {
                return (TableItem)_colElements[FieldName];
			} else {
				string sMessage = "";
				if (_colElements.Count == 0) {
					sMessage = "The field collection is empty";
				} else {
                    sMessage = "The field " + FieldName + " does not exist in the field collection for table " + this.TableName;
				}
				throw new Exception(sMessage);
			}
		}


		#endregion

		#region "Private Methods"


		#endregion

	}

}

