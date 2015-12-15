using Microsoft.VisualBasic;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Diagnostics;

namespace NRC.Miscellaneous.TableWriters
{
	/// ********************************************************************'
	/// Created by: Elibad
	/// Created Date: 2008/06/01
	/// *********************************************************************
	/// <summary>
	/// This class is the base for any UJK table writer
	/// </summary>
	/// <remarks>
	/// All the SQL code is delegated to any database implementation of this class
	/// 
	/// Any table writer that needs this type of structure should derive from this class and implement the code necesary to write to an specific type of database.
	/// </remarks>
	public abstract class TableWriter_UJK : TableWriter
	{

		/// <summary>
		/// Generates the SQL to retrieve an UJK value using the fields specified in the list
		/// </summary>
		protected abstract string RetrievePK(KeyValuePair<string, string[]> UIDEntry);

		private string _sSourceAgencyName;
		//Protected MustOverride Function SelectUJK_SQL() As String

		/// <summary>
		/// Retrieves the UJK from a different table and assings the key to the specified field in the current table
		/// </summary>
		/// <param name="SourceID">Key value of the record in the table in the source database</param>
		/// <param name="TableName">Name of the table where the UJK will be retrieved</param>
		public abstract bool PopulateForeignUJK(string SourceID, string TableName);


		/// <summary>
		/// Name of the main agency the information belongs to
		/// </summary>
		public string SourceAgencyName {
			get { return _sSourceAgencyName; }
			set { _sSourceAgencyName = value; }
		}

		/// <summary>
		/// Retrieves the Primary Key from the table if the record already exists
		/// </summary>
		/// ***************************************************************************************
		///   This method checks weather the record will update table or be inserted into it.    *
		///   It also stores the UJK if for the record to updated if it finds one.               *
		///   Input strID: The value for the ID field (passed in through the write method)       *
		///   Output: True  - when the idd is in the table                                       *
		///           False - when the id is not in the table                                    *
		/// ***************************************************************************************
		protected override string RetrievePK()
		{

			//Dim strSQL As String
			//Dim cmd As Data.Common.DbCommand
			string sResult = null;

			this.OpenConnection();

			//cmd = Me._DBConn.CreateCommand()

			if (_colRecordUID.Count > 0) {
				foreach (KeyValuePair<string, string[]> UIDEntry in _colRecordUID) {
					sResult = this.RetrievePK(UIDEntry);

					if (!string.IsNullOrEmpty(sResult)) {
						return sResult;
					}
				}
				//Else
				//    strSQL = Me.SelectUJK_SQL()

				//    If strSQL = String.Empty Then
				//        Return String.Empty
				//    End If

				//    cmd.CommandText = strSQL

				//    Return CType(Me.SQLRunner.ExecuteScalar(cmd), String)
			}

			return string.Empty;
		}

		public TableWriter_UJK(string TableName, string UJKFieldName = "") : base(TableName)
		{

			if (UJKFieldName == string.Empty) {
				_sPKFieldName = TableName + "_UJK";
			} else {
				_sPKFieldName = UJKFieldName;
			}
		}

		protected override string GeneratePKValue()
		{
			if ((this.Item(this.PKFieldName)).FormatType.ToUpper().Contains("GUID")) {
				return System.Guid.NewGuid().ToString();
			} else if ((this.Item(this.PKFieldName)).FormatType.ToUpper().Contains("CHAR")) {
				return UJK_Generator.GenerateUJK();
			}

			return "";
		}

	}
}

