// -----------------------------------------------------------------------------------------------------
// A condition to check that the source unit has the UnitValue 'CausedScampering' set to 1
// and that the unit has not yet shot at a target by checking the 'ReconSituationalAwarenessTarget'
// UnitValue.
// -----------------------------------------------------------------------------------------------------

class ReconOperator_SituationalAwarenessCondition extends X2Condition;

event name CallMeetsConditionWithSource(XComGameState_BaseObject kTarget, XComGameState_BaseObject kSource) 
{
	local XComGameState_Unit SourceUnit, TargetUnit;
	local float TargetValueFloat;
	local UnitValue ScamperValue;
	local UnitValue TargetValue;

	SourceUnit = XComGameState_Unit(kSource);
	TargetUnit = XComGameState_Unit(kTarget);
	
	

	if (SourceUnit == none || TargetUnit == none)
	{
		`log("[ReconOperator]-> SituationalAwarenessCondition.CallMeetsConditionWithSource: AA_NotAUnit");
		return 'AA_NotAUnit';
	}

	if(SourceUnit.GetUnitValue('CausedScampering', ScamperValue))
	{
		`log("[ReconOperator]-> SituationalAwarenessCondition.CallMeetsConditionWithSource: CausedScampering");
		if(ScamperValue.fValue > 0)
		{
			if(!SourceUnit.GetUnitValue('ReconSituationalAwarenessTarget', TargetValue))
			{
				TargetValueFloat = TargetUnit.ObjectID;
				SourceUnit.SetUnitFloatValue('ReconSituationalAwarenessTarget', TargetValueFloat);
			}
			else
			{
				TargetValueFloat = TargetUnit.ObjectID;
				if(TargetValue.fValue != TargetValueFloat)
				{
					`log("[ReconOperator]-> SituationalAwarenessCondition.CallMeetsConditionWithSource: Another target already set. AA_NotAUnit");
					return 'AA_NotAUnit';
				}
			}
			`log("[ReconOperator]-> SituationalAwarenessCondition.CallMeetsConditionWithSource: AA_Success");
			return 'AA_Success'; 
		}
	}

	`log("[ReconOperator]-> SituationalAwarenessCondition.CallMeetsConditionWithSource: AA_HasNotCausedScampering");
	return 'AA_HasNotCausedScampering';
	
}
