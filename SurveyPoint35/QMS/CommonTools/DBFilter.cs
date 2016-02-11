using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Collections;
using System.Text;

namespace DataAccess
{
    /// <summary>
    /// Class for building SQL Where clause.
    /// </summary>
    public class DBFilter
    {

        private bool _bJoinClausesWithAnds = true;
        private System.Collections.ArrayList _alFilter = new System.Collections.ArrayList();

        public DBFilter()
        {
        }

        /// <summary>
        /// DBFilter Constructor
        /// </summary>
        /// <param name="joinClausesWithANDS">If true, filters will be joined by ANDs. Otherwise, filters will be joined by ORs.</param>
        public DBFilter(bool joinClausesWithANDS)
        {
            _bJoinClausesWithAnds = joinClausesWithANDS;
        }

        /// <summary>
        /// If true, filters will be joined by ANDs. Otherwise, filters will be joined by ORs.
        /// </summary>
        public bool JoinClausesWithAnds
        {
            get
            {
                return _bJoinClausesWithAnds;
            }
            set
            {
                _bJoinClausesWithAnds = value;
            }
        }

        /// <summary>
        /// Returns true if no filters exist
        /// </summary>
        public bool IsEmpty
        {
            get
            {
                return (_alFilter.Count == 0);
            }
        }

        /// <summary>
        /// Appends filter text to a string builder
        /// </summary>
        /// <param name="sSql">The StringBuilder object holding WHERE clause</param>
        /// <param name="sFilter">filter clause to append</param>
        private void AppendSelectFilter(ref StringBuilder sSql, string sFilter)
        {
            if (sSql.Length > 0)
                if (_bJoinClausesWithAnds)
                    sSql.AppendFormat(" AND {0}", sFilter);
                else
                    sSql.AppendFormat(" OR {0}", sFilter);
            else
                sSql.Append(sFilter);

        }

        /// <summary>
        /// Appends filter text from a DBFilter class to a string builder
        /// </summary>
        /// <param name="sSql">The StringBuilder object holding WHERE clause</param>
        /// <param name="oFilter">DBfilter object to generate WHERE clause for appending</param>
        private void AppendSelectFilter(ref StringBuilder sSql, DBFilter oFilter)
        {
            string sDbFilterSql = oFilter.GenerateRestrictionClause();

            if (sDbFilterSql.Length > 0)
                if (sSql.Length > 0)
                    if (_bJoinClausesWithAnds)
                        sSql.AppendFormat(" AND {0}", sDbFilterSql);
                    else
                        sSql.AppendFormat(" OR {0}", sDbFilterSql);
                else
                    sSql.Append(sDbFilterSql);
        }

        /// <summary>
        /// Add a string equality filter
        /// </summary>
        /// <param name="sColName">Database table column name to filter</param>
        /// <param name="sFilterValue">column filter value</param>
        /// <returns>filter clause</returns>
        private static string StringEqualitySelectFilter(string sColName, string sFilterValue)
        {
            return String.Format("({0} = '{1}')", sColName, sFilterValue.Replace("'", "''"));
        }

        /// <summary>
        /// Add a string like filter
        /// </summary>
        /// <param name="sColName">Database table column name to filter</param>
        /// <param name="sFilterValue">column filter value</param>
        /// <returns>filter clause</returns>
        private static string StringLikeSelectFilter(string sColName, string sFilterValue)
        {
            return String.Format("({0} LIKE '{1}')", sColName, sFilterValue.Replace("'", "''"));
        }

        /// <summary>
        /// Add an equality filter
        /// </summary>
        /// <param name="sColName">Database table column name to filter</param>
        /// <param name="sFilterValue">column filter value</param>
        /// <returns>filter clause</returns>
        private static string EqualitySelectFilter(string sColName, string sFilterValue)
        {
            return String.Format("({0} = {1})", sColName, sFilterValue);
        }

        /// <summary>
        /// Add a numeric equality filter
        /// </summary>
        /// <param name="sColName">Database table column name to filter</param>
        /// <param name="sFilterValue">column filter value</param>
        public void AddSelectNumericFilter(string sColName, string sFilterValue)
        {
            _alFilter.Add(EqualitySelectFilter(sColName, sFilterValue));
        }

        /// <summary>
        /// Add a string filter
        /// </summary>
        /// <param name="sColName">Database table column name to filter</param>
        /// <param name="sFilterValue">column filter value</param>
        /// <param name="bUserLikeCompare">If true, LIKE compare.</param>
        public void AddSelectStringFilter(string sColName, string sFilterValue, bool bUseLikeCompare)
        {
            if (bUseLikeCompare)
                _alFilter.Add(StringLikeSelectFilter(sColName, sFilterValue));
            else
                _alFilter.Add(StringEqualitySelectFilter(sColName, sFilterValue));
        }

        /// <summary>
        /// Add a string equality filter
        /// </summary>
        /// <param name="sColName"></param>
        /// <param name="sFilterValue"></param>
        public void AddSelectStringFilter(string sColName, string sFilterValue)
        {
            AddSelectStringFilter(sColName, sFilterValue, false);
        }

        /// <summary>
        /// Add custom filter
        /// </summary>
        /// <param name="sCustomFilter">Custom SQL filter statement</param>
        public void AddCustomFilter(string sCustomFilter)
        {
            _alFilter.Add(sCustomFilter);
        }

        /// <summary>
        /// Add a filter group
        /// </summary>
        /// <param name="filter">The DBfilter object containing the filter</param>
        public void AddFilterGroup(DBFilter filter)
        {
            _alFilter.Add(filter);
        }

        /// <summary>
        /// Add a null comparison filter
        /// </summary>
        /// <param name="sColName">Database table column name to filter</param>
        public void AddNullFilter(string sColName)
        {
            _alFilter.Add(String.Format("({0} IS NULL)", sColName));
        }

        /// <summary>
        /// Add a not null comparison filter
        /// </summary>
        /// <param name="sColName">Database table column name to filter</param>
        public void AddNotNullFilter(string sColName)
        {
            _alFilter.Add(String.Format("({0} IS NOT NULL)", sColName));
        }

        /// <summary>
        /// Add a datetime filter
        /// </summary>
        /// <param name="sColName">Database table column name to filter</param>
        /// <param name="sFilterValue">Date filter value</param>
        /// <param name="compareOperation">Type of comparison</param>
        public void AddSelectDateFilter(string sColName, string sFilterValue, ComparisonTypes.ComparisonTypesEnum compareOperation)
        {
            _alFilter.Add(String.Format("({0} {2} '{1}')", sColName, sFilterValue, ComparisonTypes.GetOperatorAsString(compareOperation)));
        }

        /// <summary>
        /// Generates the SQL WHERE statement without the WHERE keyword
        /// </summary>
        /// <returns>string of SQL WHERE statement without the WHERE keyword</returns>
        public string GenerateRestrictionClause()
        {
            StringBuilder sbSql = new StringBuilder();

            if (_alFilter.Count > 0)
            {
                foreach (Object oClause in _alFilter)
                {
                    if (oClause is string)
                        AppendSelectFilter(ref sbSql, oClause.ToString());
                    else if (oClause is DBFilter)
                        AppendSelectFilter(ref sbSql, (DBFilter)oClause);
                }
            }

            return sbSql.ToString();

        }

        /// <summary>
        /// Generates the SQL WHERE statement with the WHERE keyword
        /// </summary>
        /// <returns>string of SQL WHERE statement with the WHERE keyword</returns>
        public string GenerateWhereClause()
        {
            if (_alFilter.Count > 0)
                return String.Format("WHERE {0}", GenerateRestrictionClause());
            else
                return "";
        }

    }

    /// <summary>
    /// ComparsionTypes class holding SQL comparison types
    /// </summary>
    public class ComparisonTypes
    {
        public ComparisonTypes()
        {
        }

        /// <summary>
        /// Enumerator of comparison types
        /// </summary>
        public enum ComparisonTypesEnum : int
        {
            Equal = 1,
            NotEqual = 2,
            GreaterThan = 3,
            LessThan = 4,
            GreaterThanOrEqual = 5,
            LessThanOrEqual = 6
        }

        /// <summary>
        /// String comparison operators
        /// </summary>
        /// <param name="operation">Comparison type</param>
        /// <returns>Returns string comparison operator</returns>
        public static string GetOperatorAsString(ComparisonTypesEnum operation)
        {
            switch (operation)
            {
                case ComparisonTypesEnum.Equal:
                    return "=";
                case ComparisonTypesEnum.GreaterThan:
                    return ">";
                case ComparisonTypesEnum.GreaterThanOrEqual:
                    return ">=";
                case ComparisonTypesEnum.LessThan:
                    return "<";
                case ComparisonTypesEnum.LessThanOrEqual:
                    return "<=";
                case ComparisonTypesEnum.NotEqual:
                    return "<>";
                default:
                    return "";
            }

        }

        /// <summary>
        /// Test comparison of 2 objects
        /// </summary>
        /// <param name="operation">Type of comparison to make</param>
        /// <param name="obj1">First object being compared</param>
        /// <param name="obj2">Second object being compared</param>
        /// <returns>Whether comparison is true</returns>
        public static bool DoComparision(ComparisonTypesEnum operation, IComparable obj1, IComparable obj2)
        {
            int result = obj1.CompareTo(obj2);

            switch (operation)
            {
                case ComparisonTypesEnum.Equal:
                    return (result == 0);
                case ComparisonTypesEnum.GreaterThan:
                    return (result > 0);
                case ComparisonTypesEnum.GreaterThanOrEqual:
                    return (result >= 0);
                case ComparisonTypesEnum.LessThan:
                    return (result < 0);
                case ComparisonTypesEnum.LessThanOrEqual:
                    return (result <= 0);
                case ComparisonTypesEnum.NotEqual:
                    return (result != 0);
                default:
                    return false;
            }
        }
    }
}
