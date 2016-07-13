// Ensure the target unit does NOT have an ability.

class X2Condition_UnitDoesNotHaveAbility extends X2Condition;

var name OwnerDoesNotHaveSoldierAbility;

event name CallMeetsCondition(XComGameState_BaseObject kTarget) { 

	local XComGameState_Unit TargetUnit;
	local StateObjectReference AbilityRef;

	TargetUnit = XComGameState_Unit(kTarget);
	AbilityRef = TargetUnit.FindAbility(OwnerDoesNotHaveSoldierAbility);
	if(AbilityRef.ObjectID == 0)
	{
		return 'AA_Success';
	}

	return 'AA_Failure';
	
}