using NHapi.Base.Parser;
using NHapi.Base;
using NHapi.Base.Log;
using System;
using NHapi.Model.V23.Segment;

using NHapi.Base.Model;

namespace NHapi.Model.V23.Group
{
///<summary>
///Represents the ORM_O01_ORDER Group.  A Group is an ordered collection of message 
/// segments that can repeat together or be optionally in/excluded together.
/// This Group contains the following elements: 
///<ol>
///<li>0: ORC (Common order segment) </li>
///<li>1: ORM_O01_ORDER_DETAIL (a Group object) optional </li>
///<li>2: CTI (Clinical Trial Identification) optional </li>
///<li>3: BLG (Billing Segment) optional </li>
///</ol>
///</summary>
[Serializable]
public class ORM_O01_ORDER : AbstractGroup {

	///<summary> 
	/// Creates a new ORM_O01_ORDER Group.
	///</summary>
	public ORM_O01_ORDER(IGroup parent, IModelClassFactory factory) : base(parent, factory){
	   try {
	      this.add(typeof(ORC), true, false);
	      this.add(typeof(ORM_O01_ORDER_DETAIL), false, false);
	      this.add(typeof(CTI), false, false);
	      this.add(typeof(BLG), false, false);
	   } catch(HL7Exception e) {
	      HapiLogFactory.GetHapiLog(GetType()).Error("Unexpected error creating ORM_O01_ORDER - this is probably a bug in the source code generator.", e);
	   }
	}

	///<summary>
	/// Returns ORC (Common order segment) - creates it if necessary
	///</summary>
	public ORC ORC { 
get{
	   ORC ret = null;
	   try {
	      ret = (ORC)this.GetStructure("ORC");
	   } catch(HL7Exception e) {
	      HapiLogFactory.GetHapiLog(GetType()).Error("Unexpected error accessing data - this is probably a bug in the source code generator.", e);
	      throw new System.Exception("An unexpected error ocurred",e);
	   }
	   return ret;
	}
	}

	///<summary>
	/// Returns ORM_O01_ORDER_DETAIL (a Group object) - creates it if necessary
	///</summary>
	public ORM_O01_ORDER_DETAIL ORDER_DETAIL { 
get{
	   ORM_O01_ORDER_DETAIL ret = null;
	   try {
	      ret = (ORM_O01_ORDER_DETAIL)this.GetStructure("ORDER_DETAIL");
	   } catch(HL7Exception e) {
	      HapiLogFactory.GetHapiLog(GetType()).Error("Unexpected error accessing data - this is probably a bug in the source code generator.", e);
	      throw new System.Exception("An unexpected error ocurred",e);
	   }
	   return ret;
	}
	}

	///<summary>
	/// Returns CTI (Clinical Trial Identification) - creates it if necessary
	///</summary>
	public CTI CTI { 
get{
	   CTI ret = null;
	   try {
	      ret = (CTI)this.GetStructure("CTI");
	   } catch(HL7Exception e) {
	      HapiLogFactory.GetHapiLog(GetType()).Error("Unexpected error accessing data - this is probably a bug in the source code generator.", e);
	      throw new System.Exception("An unexpected error ocurred",e);
	   }
	   return ret;
	}
	}

	///<summary>
	/// Returns BLG (Billing Segment) - creates it if necessary
	///</summary>
	public BLG BLG { 
get{
	   BLG ret = null;
	   try {
	      ret = (BLG)this.GetStructure("BLG");
	   } catch(HL7Exception e) {
	      HapiLogFactory.GetHapiLog(GetType()).Error("Unexpected error accessing data - this is probably a bug in the source code generator.", e);
	      throw new System.Exception("An unexpected error ocurred",e);
	   }
	   return ret;
	}
	}

}
}