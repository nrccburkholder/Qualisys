using System;
using NHapi.Base;
using NHapi.Base.Parser;
using NHapi.Base.Model;
using NHapi.Model.V22.Datatype;
using NHapi.Base.Log;

namespace NHapi.Model.V22.Segment{

///<summary>
/// Represents an HL7 MFA message segment. 
/// This segment has the following fields:<ol>
///<li>MFA-1: Record-level event code (ID)</li>
///<li>MFA-2: MFN control ID (ST)</li>
///<li>MFA-3: Event completion date / time (TS)</li>
///<li>MFA-4: Error return code and/or text (CE)</li>
///<li>MFA-5: Primary key value (CE)</li>
///</ol>
/// The get...() methods return data from individual fields.  These methods 
/// do not throw exceptions and may therefore have to handle exceptions internally.  
/// If an exception is handled internally, it is logged and null is returned.  
/// This is not expected to happen - if it does happen this indicates not so much 
/// an exceptional circumstance as a bug in the code for this class.
///</summary>
[Serializable]
public class MFA : AbstractSegment  {

  /**
   * Creates a MFA (MASTER FILE ACKNOWLEDGEMENT) segment object that belongs to the given 
   * message.  
   */
	public MFA(IGroup parent, IModelClassFactory factory) : base(parent,factory) {
	IMessage message = Message;
    try {
       this.add(typeof(ID), true, 1, 3, new System.Object[]{message, 180}, "Record-level event code");
       this.add(typeof(ST), false, 1, 20, new System.Object[]{message}, "MFN control ID");
       this.add(typeof(TS), false, 1, 26, new System.Object[]{message}, "Event completion date / time");
       this.add(typeof(CE), true, 1, 60, new System.Object[]{message}, "Error return code and/or text");
       this.add(typeof(CE), true, 0, 60, new System.Object[]{message}, "Primary key value");
    } catch (HL7Exception he) {
        HapiLogFactory.GetHapiLog(GetType()).Error("Can't instantiate " + GetType().Name, he);
    }
  }

	///<summary>
	/// Returns Record-level event code(MFA-1).
	///</summary>
	public ID RecordLevelEventCode
	{
		get{
			ID ret = null;
			try
			{
			IType t = this.GetField(1, 0);
				ret = (ID)t;
			}
			 catch (HL7Exception he) {
			HapiLogFactory.GetHapiLog(GetType()).Error("Unexpected problem obtaining field value.  This is a bug.", he);
				throw new System.Exception("An unexpected error ocurred", he);
		} catch (System.Exception ex) {
			HapiLogFactory.GetHapiLog(GetType()).Error("Unexpected problem obtaining field value.  This is a bug.", ex);
				throw new System.Exception("An unexpected error ocurred", ex);
    }
			return ret;
	}
  }

	///<summary>
	/// Returns MFN control ID(MFA-2).
	///</summary>
	public ST MFNControlID
	{
		get{
			ST ret = null;
			try
			{
			IType t = this.GetField(2, 0);
				ret = (ST)t;
			}
			 catch (HL7Exception he) {
			HapiLogFactory.GetHapiLog(GetType()).Error("Unexpected problem obtaining field value.  This is a bug.", he);
				throw new System.Exception("An unexpected error ocurred", he);
		} catch (System.Exception ex) {
			HapiLogFactory.GetHapiLog(GetType()).Error("Unexpected problem obtaining field value.  This is a bug.", ex);
				throw new System.Exception("An unexpected error ocurred", ex);
    }
			return ret;
	}
  }

	///<summary>
	/// Returns Event completion date / time(MFA-3).
	///</summary>
	public TS EventCompletionDateTime
	{
		get{
			TS ret = null;
			try
			{
			IType t = this.GetField(3, 0);
				ret = (TS)t;
			}
			 catch (HL7Exception he) {
			HapiLogFactory.GetHapiLog(GetType()).Error("Unexpected problem obtaining field value.  This is a bug.", he);
				throw new System.Exception("An unexpected error ocurred", he);
		} catch (System.Exception ex) {
			HapiLogFactory.GetHapiLog(GetType()).Error("Unexpected problem obtaining field value.  This is a bug.", ex);
				throw new System.Exception("An unexpected error ocurred", ex);
    }
			return ret;
	}
  }

	///<summary>
	/// Returns Error return code and/or text(MFA-4).
	///</summary>
	public CE ErrorReturnCodeAndOrText
	{
		get{
			CE ret = null;
			try
			{
			IType t = this.GetField(4, 0);
				ret = (CE)t;
			}
			 catch (HL7Exception he) {
			HapiLogFactory.GetHapiLog(GetType()).Error("Unexpected problem obtaining field value.  This is a bug.", he);
				throw new System.Exception("An unexpected error ocurred", he);
		} catch (System.Exception ex) {
			HapiLogFactory.GetHapiLog(GetType()).Error("Unexpected problem obtaining field value.  This is a bug.", ex);
				throw new System.Exception("An unexpected error ocurred", ex);
    }
			return ret;
	}
  }

	///<summary>
	/// Returns a single repetition of Primary key value(MFA-5).
	/// throws HL7Exception if the repetition number is invalid.
	/// <param name="rep">The repetition number (this is a repeating field)</param>
	///</summary>
	public CE GetPrimaryKeyValue(int rep)
	{
			CE ret = null;
			try
			{
			IType t = this.GetField(5, rep);
				ret = (CE)t;
		} catch (System.Exception ex) {
			HapiLogFactory.GetHapiLog(GetType()).Error("Unexpected problem obtaining field value.  This is a bug.", ex);
				throw new System.Exception("An unexpected error ocurred", ex);
    }
			return ret;
  }

  ///<summary>
  /// Returns all repetitions of Primary key value (MFA-5).
   ///</summary>
  public CE[] GetPrimaryKeyValue() {
     CE[] ret = null;
    try {
        IType[] t = this.GetField(5);  
        ret = new CE[t.Length];
        for (int i = 0; i < ret.Length; i++) {
            ret[i] = (CE)t[i];
        }
    } catch (HL7Exception he) {
        HapiLogFactory.GetHapiLog(this.GetType()).Error("Unexpected problem obtaining field value.  This is a bug.", he);
        throw new System.Exception("An unexpected error ocurred", he);
    } catch (System.Exception cce) {
        HapiLogFactory.GetHapiLog(GetType()).Error("Unexpected problem obtaining field value.  This is a bug.", cce);
        throw new System.Exception("An unexpected error ocurred", cce);
  }
 return ret;
}

  ///<summary>
  /// Returns the total repetitions of Primary key value (MFA-5).
   ///</summary>
  public int PrimaryKeyValueRepetitionsUsed
{
get{
    try {
	return GetTotalFieldRepetitionsUsed(5);
    }
catch (HL7Exception he) {
        HapiLogFactory.GetHapiLog(this.GetType()).Error("Unexpected problem obtaining field value.  This is a bug.", he);
        throw new System.Exception("An unexpected error ocurred", he);
} catch (System.Exception cce) {
        HapiLogFactory.GetHapiLog(GetType()).Error("Unexpected problem obtaining field value.  This is a bug.", cce);
        throw new System.Exception("An unexpected error ocurred", cce);
}
}
}

}}