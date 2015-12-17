using Microsoft.VisualBasic;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
using System.Diagnostics;
using Utilities;

namespace NRC.Miscellaneous.TableWriters
{
	/// <summary>
	/// Table driven table writter
	/// </summary>
	/// <remarks>Table driven table writter</remarks>
	public sealed class TW_TableWriter_MSSQLGeneric : TableWriter_UJK
	{

		//The fields listed in this collection are special cases when creating the Main SQL statements

		private Collection _colIgnoreFields = new Collection();

		public TW_TableWriter_MSSQLGeneric(string TableName, bool WriteNulls = true) : base(TableName, "")
		{
			this.WriteNulls = WriteNulls;
			this.DBFactory = System.Data.SqlClient.SqlClientFactory.Instance;

			//The following fields are special cases for the UPDATE Statement
			Collection colIgnoreList = new Collection();
			_colIgnoreFields.Add(colIgnoreList, "UPDATE");

			colIgnoreList.Add("", "CREATEDATE");
			colIgnoreList.Add("", "MODDATE");
			colIgnoreList.Add("", TableName.ToUpper() + "_UJK");
			colIgnoreList.Add("", "SOURCEAGENCYNAME");
			colIgnoreList.Add("", TableName.ToUpper() + "_SOURCEID");
			colIgnoreList.Add("", "FILLMISSINGUJKRETRYCOUNT");

			//The following fields are special cases for the INSERT Statement
			colIgnoreList = new Collection();
			_colIgnoreFields.Add(colIgnoreList, "INSERT");

			colIgnoreList.Add("", "CREATEDATE");
			colIgnoreList.Add("", "MODDATE");
			colIgnoreList.Add("", TableName.ToUpper() + "_UJK");
			colIgnoreList.Add("", "FILLMISSINGUJKRETRYCOUNT");
		}

		public System.Type GetSqlType(string sType)
		{
			System.Type tResult = null;
			string sqlType = sType.ToUpper().Trim();

			if ("BINARY, IMAGE, TIMESTAMP, VARBINARY".Contains(sqlType)) {
				tResult = Type.GetType("System.Data.SqlTypes.SqlBinary", false, false);
			} else if ("BIT".Contains(sqlType)) {
				tResult = Type.GetType("System.Data.SqlTypes.SqlBoolean", false, false);
			} else if ("TINYINT".Contains(sqlType)) {
				tResult = Type.GetType("System.Data.SqlTypes.SqlByte", false, false);
			} else if ("DATETIME, SMALLDATETIME".Contains(sqlType)) {
				tResult = Type.GetType("System.Data.SqlTypes.SqlDateTime", false, false);
			} else if ("DECIMAL".Contains(sqlType)) {
				tResult = Type.GetType("System.Data.SqlTypes.SqlDecimal", false, false);
			} else if ("FLOAT".Contains(sqlType)) {
				tResult = Type.GetType("System.Data.SqlTypes.SqlDouble", false, false);
			} else if ("UNIQUEIDENTIFIER".Contains(sqlType)) {
				tResult = Type.GetType("System.Data.SqlTypes.SqlGuid", false, false);
			} else if ("SMALLINT".Contains(sqlType)) {
				tResult = Type.GetType("System.Data.SqlTypes.SqlInt16", false, false);
			} else if ("INT".Contains(sqlType)) {
				tResult = Type.GetType("System.Data.SqlTypes.SqlInt32", false, false);
			} else if ("BIGINT".Contains(sqlType)) {
				tResult = Type.GetType("System.Data.SqlTypes.SqlInt64", false, false);
			} else if ("MONEY, SMALLMONEY".Contains(sqlType)) {
				tResult = Type.GetType("System.Data.SqlTypes.SqlMoney", false, false);
			} else if ("REAL".Contains(sqlType)) {
				tResult = Type.GetType("System.Data.SqlTypes.SqlSingle", false, false);
			} else if ("CHAR, NCHAR, TEXT, NTEXT, NVARCHAR, VARCHAR".Contains(sqlType)) {
				tResult = Type.GetType("System.Data.SqlTypes.SqlString", false, false);
			} else if ("XML".Contains(sqlType)) {
				tResult = Type.GetType("System.Data.SqlTypes.SqlXml", false, false);
			}

			return tResult;
		}


		public override void CreateElementsCollection()
		{
			TableItem TempItem = default(TableItem);
			DbDataReader dReader = null;
			DbCommand dCmd = null;
			DbConnection Conn = null;
			//Type tNewType = null;
			string sQueryResult = "";

			try {
				Conn = this.DBFactory.CreateConnection();
				Conn.ConnectionString = this.DBConnectionString;
				Conn.Open();

				dCmd = Database.CreateCommand(Conn);

				dCmd.CommandText = "SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = '" + this.TableName + "'";

				sQueryResult = Convert.ToString(DBCommandExecuteScalar(dCmd));

				if (sQueryResult == null || !(sQueryResult == this.TableName)) {
					throw new System.Exception("The table " + this.TableName + "does not exist in the database");
				}

			} catch (Exception ex) {
				ex.Data["TW_TableWriter_MSSQLGeneric::CreateElementsCollection::Position"] = "Testing for table Existence";
				throw;
			} finally {
				if (dReader != null) {
					dReader.Close();
				}
			}

			try {
				if (Conn.State != ConnectionState.Open) {
					Conn.Open();
				}
				if (dCmd == null) {
					dCmd = Database.CreateCommand(Conn);
				}

				dCmd.CommandText = "SELECT *" + Environment.NewLine + "FROM INFORMATION_SCHEMA.COLUMNS" + Environment.NewLine + "WHERE TABLE_NAME = '" + this.TableName + "'" + Environment.NewLine + "ORDER BY ORDINAL_POSITION";

				dReader = DBCommandExecuteReader(dCmd);

				while (dReader.Read()) {
					//tNewType = GetSqlType(CStr(dReader("DATA_TYPE")))

					if (dReader["CHARACTER_MAXIMUM_LENGTH"].ToString() != string.Empty) {
						TempItem = new TableItem(dReader["COLUMN_NAME"].ToString(), Convert.ToString(dReader["DATA_TYPE"]), Convert.ToInt32(dReader["CHARACTER_MAXIMUM_LENGTH"].ToString()));
					} else {
						TempItem = new TableItem(dReader["COLUMN_NAME"].ToString(), Convert.ToString(dReader["DATA_TYPE"]));
						//dReader("DATA_TYPE").ToString
					}

					this.AddItem(TempItem);
				}
			} catch (Exception ex) {
				ex.Data["TW_TableWriter_MSSQLGeneric::CreateElementsCollection::Position"] = "Creating field collection";
				throw;
			} finally {
				if (dReader != null) {
					dReader.Close();
				}
			}

			try {
				string sKeyName = string.Empty;
				string[] sFieldList = new string[1];

				if (Conn.State != ConnectionState.Open) {
					Conn.Open();
				}
				if (dCmd == null) {
					dCmd = Database.CreateCommand(Conn);
				}

				dCmd.CommandText = "SELECT   tc.TABLE_NAME" + Environment.NewLine + "       , tc.CONSTRAINT_NAME" + Environment.NewLine + "       , tc.CONSTRAINT_TYPE" + Environment.NewLine + "       , cu.COLUMN_NAME" + Environment.NewLine + "FROM     INFORMATION_SCHEMA.TABLE_CONSTRAINTS tc" + Environment.NewLine + "INNER JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE cu" + Environment.NewLine + "         ON tc.CONSTRAINT_NAME = cu.CONSTRAINT_NAME" + Environment.NewLine + "WHERE    CONSTRAINT_TYPE = 'PRIMARY KEY'" + Environment.NewLine + "\tAND tc.TABLE_NAME = '" + this.TableName + "'" + Environment.NewLine + "ORDER BY tc.CONSTRAINT_NAME" + Environment.NewLine + "       , cu.ORDINAL_POSITION" + Environment.NewLine;

				dReader = DBCommandExecuteReader(dCmd);

				Array.Resize(ref sFieldList, 0);

				while (dReader.Read()) {
					//Grab first key name
					if (string.IsNullOrEmpty(sKeyName)) {
						sKeyName = dReader["CONSTRAINT_NAME"].ToString();
						if (dReader["CONSTRAINT_TYPE"].ToString().ToUpper() == "PRIMARY KEY" && !sKeyName.ToUpper().StartsWith("PK_")) {
							sKeyName = "PK_" + sKeyName;
						}
					}

					Array.Resize(ref sFieldList, sFieldList.Length + 1);
					sFieldList[sFieldList.Length - 1] = dReader["COLUMN_NAME"].ToString();
				}

				if (sFieldList.Length > 0) {
					this.AddUniqueIdentifier(sKeyName, sFieldList);
				}
			} catch (Exception ex) {
				ex.Data["TW_TableWriter_MSSQLGeneric::CreateElementsCollection::Position"] = "Adding PK field name to unique identifiers collection";
				throw;
			} finally {
				if (dReader != null) {
					dReader.Close();
				}
			}

			try {
				if (Conn.State != ConnectionState.Open) {
					Conn.Open();
				}
				if (dCmd == null) {
					dCmd = Database.CreateCommand(Conn);
				}

				dCmd.CommandText = "IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'tblDBKeyGroup')" + Environment.NewLine + Environment.NewLine + "SELECT *" + Environment.NewLine + Environment.NewLine + "FROM tblDBKeyGroup" + Environment.NewLine + Environment.NewLine + "WHERE TABLENAME = '" + this.TableName + "'" + Environment.NewLine + Environment.NewLine + "ORDER BY KeyGroupOrder";

				dReader = DBCommandExecuteReader(dCmd);

				while (dReader.Read()) {
					this.AddUniqueIdentifier(dReader["KeyName"].ToString(), dReader["KeyFieldNames"].ToString().Split(','));
				}
			} catch (Exception ex) {
				ex.Data["TW_TableWriter_MSSQLGeneric::CreateElementsCollection::Position"] = "Adding user defined key groups to the collection";
				throw;
			} finally {
				if (dReader != null) {
					dReader.Close();
				}
				if (dCmd != null) {
					dCmd.Dispose();
				}
				if (Conn.State == ConnectionState.Open) {
					Conn.Close();
				}
			}

		}


		protected override void AddExtraTranslations()
		{
		}


		protected override string RetrievePK(KeyValuePair<string, string[]> UIDEntry)
		{
			string sWhereClause = "";
			string sSQL = null;
			DbCommand dbCMD = null;
			string sResult = null;

			if (_colDBCommands.Contains(UIDEntry.Key)) {
                dbCMD = (DbCommand)_colDBCommands[UIDEntry.Key];
			} else {
				if (UIDEntry.Value.Length == 0) {
					return string.Empty;
				}

                dbCMD = Database.CreateCommand(_DBConn);

				foreach (string sField in UIDEntry.Value) {
					string sfld = sField.Trim();
                    sWhereClause += "AND " + sfld + " = @" + sfld + Environment.NewLine;
                    dbCMD.Parameters.Add(new System.Data.SqlClient.SqlParameter("@" + sfld, (SqlDbType)System.Enum.Parse(typeof(SqlDbType), this.Item(sfld).FormatType, true), this.Item(sfld).Length));
				}

				sSQL = "SELECT TOP 1 " + this.PKFieldName + Environment.NewLine + Environment.NewLine + "FROM " + this.TableName + Environment.NewLine + Environment.NewLine + "WHERE " + sWhereClause.Substring(4);

				dbCMD.CommandText = sSQL;
				dbCMD.Prepare();

				_colDBCommands.Add(dbCMD, UIDEntry.Key);
			}


			foreach (string sField in UIDEntry.Value) {
				var sfld = sField.Trim();

                if (!string.IsNullOrWhiteSpace(sfld))
                {
                    dbCMD.Parameters["@" + sfld].Value = this.Item(sfld).DBValue;
				} else {
					return string.Empty;
				}
			}

			sResult = Convert.ToString(this.SQLRunner.ExecuteScalar(dbCMD));
			if (sResult == null) {
				return string.Empty;
			} else {
				return sResult;
			}
		}

		//****************************************************************************************
		//   This method creates the sql from the collection passed in from the Write     *
		//   method.                                                                             *
		//   Output: The update sql statement as a string.                                       *
		//****************************************************************************************

		protected override void CreateMainSQL()
		{
			Collection colIgnoreFields = null;
			string strSQL = null;
			DbCommand dbCMD = null;

			strSQL = "UPDATE " + this.TableName + " WITH (ROWLOCK) " + Environment.NewLine + "SET" + Environment.NewLine;

			if (_colDBCommands.Contains("UPDATE")) {
				dbCMD = (DbCommand)_colDBCommands["UPDATE"];
				dbCMD.Parameters.Clear();
			} else {
                dbCMD = Database.CreateCommand(_DBConn);
				_colDBCommands.Add(dbCMD, "UPDATE");
			}

			try {
				bool bFirst = true;

				dbCMD.Parameters.Add(new System.Data.SqlClient.SqlParameter("@" + this.PKFieldName, (SqlDbType)System.Enum.Parse(typeof(SqlDbType), this.Item(this.PKFieldName).FormatType, true), this.Item(this.PKFieldName).Length));

				colIgnoreFields = (Collection)_colIgnoreFields["UPDATE"];

				foreach (TableItem field in _colElements) {
					if ((field != null || this.WriteNulls) && !colIgnoreFields.Contains(field.ColumnName.ToUpper()) && !dbCMD.Parameters.Contains("@" + field.ColumnName)) {
						if (bFirst) {
							strSQL += "   " + field.ColumnName + " = @" + field.ColumnName + Environment.NewLine;
							bFirst = false;
						} else {
							strSQL += "   , " + field.ColumnName + " = @" + field.ColumnName + Environment.NewLine;
						}
						dbCMD.Parameters.Add(new System.Data.SqlClient.SqlParameter("@" + field.ColumnName, (SqlDbType)System.Enum.Parse(typeof(SqlDbType), field.FormatType, true), field.Length));
					}
				}
			} catch (Exception ex) {
				ex.Data["TW_TableWriter_MSSQLGeneric::CreatemainSQL::Position"] = "Error occurred when creating the UPDATE statement.";
				throw;
				//New System.Exception("Error Occurred [" & ex.Message & "] when creating the UPDATE statement.", ex)
			}

			if (this.Contains("FillMissingUJKRetryCount")) {
				//There is no need to add parameter for @MissingUJKCount at this point
				//because it already exists
				strSQL += "   , FillMissingUJKRetryCount = CASE WHEN @MissingUJKCount <> 0 THEN FillMissingUJKRetryCount + 1 ELSE FillMissingUJKRetryCount END" + Environment.NewLine;
			}

			if (this.Contains("ModDate")) {
				strSQL += "   , ModDate = getdate()" + Environment.NewLine;
			}

			strSQL += " WHERE " + this.PKFieldName + " = @" + this.PKFieldName + Environment.NewLine;

			if (this.Contains("SourceModDate")) {
				//There is no need to add parameter for @SourceModDate at this point
				//because it already exists
				strSQL += "     AND (SourceModDate >= @SourceModDate OR SourceModDate IS NULL)";
			}

			dbCMD.CommandText = strSQL;
			dbCMD.Prepare();

			string sColumns = null;
			string sValues = null;

			if (_colDBCommands.Contains("INSERT")) {
				dbCMD = (DbCommand)_colDBCommands["INSERT"];
				dbCMD.Parameters.Clear();
			} else {
                dbCMD = Database.CreateCommand(_DBConn);
				_colDBCommands.Add(dbCMD, "INSERT");
			}

			try {
				//these variables hold the sql for colums and values part of the insert statement
				sColumns = "   " + this.PKFieldName + Environment.NewLine;
				sValues = "   @" + this.PKFieldName + Environment.NewLine;
				dbCMD.Parameters.Add(new System.Data.SqlClient.SqlParameter("@" + this.PKFieldName, (SqlDbType)System.Enum.Parse(typeof(SqlDbType), this.Item(this.PKFieldName).FormatType, true), this.Item(this.PKFieldName).Length));

				if (this.Contains("CreateDate")) {
					sColumns += "   , CreateDate" + Environment.NewLine;
					sValues += "   , getdate()" + Environment.NewLine;
				}

				if (this.Contains("ModDate")) {
					sColumns += "   , ModDate" + Environment.NewLine;
					sValues += "   , getdate()" + Environment.NewLine;
				}


				colIgnoreFields = (Collection)_colIgnoreFields["INSERT"];

				//fill in columns with the column names and values from the collection
				foreach (TableItem field in _colElements) {
					if ((field != null || this.WriteNulls) && !colIgnoreFields.Contains(field.ColumnName.ToUpper()) && !dbCMD.Parameters.Contains("@" + field.ColumnName)) {
						sColumns += "   , " + field.ColumnName + Environment.NewLine;
						sValues += "   , @" + field.ColumnName + Environment.NewLine;
						dbCMD.Parameters.Add(new System.Data.SqlClient.SqlParameter("@" + field.ColumnName, (SqlDbType)System.Enum.Parse(typeof(SqlDbType), field.FormatType, true), field.Length));
					}
				}

				strSQL = "INSERT INTO " + this.TableName + Environment.NewLine + "(" + sColumns + ")" + Environment.NewLine + "VALUES " + "(" + sValues + ")";


				dbCMD.CommandText = strSQL;
				dbCMD.Prepare();
			} catch (Exception ex) {
				ex.Data["TW_TableWriter_MSSQLGeneric::CreatemainSQL::Position"] = "Error occurred when creating the INSERT statement.";
				throw;
				//New System.Exception("Error Occurred [" & ex.Message & "] when creating the INSERT statement.", ex)
			}

		}

		/// <summary>
		/// Retrieves the UJK from a separated table and assings the key to the specified field in the current table
		/// </summary>
		/// <param name="SourceID">Key value of the record in the table in the source database</param>
		/// <param name="TableName">Name of the table where the UJK will be retrieved</param>
		public override bool PopulateForeignUJK(string SourceID, string TableName)
		{

			string strSQL = null;
			DbCommand dbCMD = null;
			//Dim sAgencyName As String = Me.SourceAgencyName
			object objScalar = null;
			string sCMDName = null;

			//open the connection if it is closed
			this.OpenConnection();

			try {
				if (!this.Contains(TableName + "_UJK")) {
					return true;
				}

				sCMDName = TableName.ToUpper() + "_FIND_PK";

				if (_colDBCommands.Contains(sCMDName)) {
					dbCMD = (DbCommand)_colDBCommands[sCMDName];
				} else {
					strSQL = "SELECT " + TableName + "_UJK" + Environment.NewLine + "FROM " + TableName + " (NOLOCK)" + Environment.NewLine + "WHERE SourceAgencyName = @SourceAgencyName" + Environment.NewLine + "   AND " + TableName + "_SourceID = @SourceID";

                    dbCMD = Database.CreateCommand(_DBConn);
					dbCMD.CommandText = strSQL;
					dbCMD.Parameters.Add(new System.Data.SqlClient.SqlParameter("@SourceAgencyName", SqlDbType.VarChar, this.Item("SourceAgencyName").Length));
					dbCMD.Parameters.Add(new System.Data.SqlClient.SqlParameter("@SourceID", SqlDbType.VarChar, this.Item(TableName + "_SourceID").Length));

					dbCMD.Prepare();

					_colDBCommands.Add(dbCMD, sCMDName);
				}

				dbCMD.Parameters["@SourceID"].Value = SourceID;
				dbCMD.Parameters["@SourceAgencyName"].Value = this.SourceAgencyName;

				objScalar = this.SQLRunner.ExecuteScalar(dbCMD);
				if (objScalar != null) {
					SetValue(TableName + "_UJK", Convert.ToString(objScalar));
					return true;
				} else {
					//We will return false only when the foreign field exists 
					//and the query is unable to retrieve the UJK value
					return false;
				}

			} catch (Exception ex) {
				throw new System.Exception("Failure executing sql stament [" + dbCMD.CommandText + "]. ", ex);
			}
		}

		protected override void ComputeCalculatedItems()
		{
			base.ComputeCalculatedItems();

			if (!this.ShowAllExceptions && this.Contains("ETLWarnings") && this.Warnings.Length > 0) {
				this.SetValue("ETLWarnings", this.Warnings);
			}

			if (!this.ShowAllExceptions && this.Contains("Warnings") && this.Warnings.Length > 0) {
				this.SetValue("Warnings", this.Warnings);
			}

			if (this.Contains("SourceAgencyName")) {
				this.SetValue("SourceAgencyName", this.SourceAgencyName);
			}

			if (this.Contains("InactiveRecordFlag") && this.Item("InactiveRecordFlag") == null) {
				this.SetValue("InactiveRecordFlag", false);
			}

		}

        //protected override void Finalize()
        //{
        //    base.Finalize();
        //}
	}


}

