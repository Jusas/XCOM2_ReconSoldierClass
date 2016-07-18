// Ensure the target unit does NOT have an ability.

class ReconOperator_Condition_UnitDoesNotHaveAbility extends X2Condition;

var name OwnerDoesNotHaveSoldierAbility;

event name CallMeetsCondition(XComGameState_BaseObject kTarget) { 

	local XComGameState_Unit TargetUnit;
	local StateObjectReference AbilityRef;

	TargetUnit = XComGameState_Unit(kTarget);
	AbilityRef = TargetUnit.FindAbility(OwnerDoesNotHaveSoldierAbility);
	if(AbilityRef.ObjectID == 0)
	{
		`log("[ReconOperator]-> Unit " $ TargetUnit.GetFullName() $ " does not have ability " $ OwnerDoesNotHaveSoldierAbility $ ", AA_SUCCESS");
		return 'AA_Success';
	}

	`log("[ReconOperator]-> Unit " $ TargetUnit.GetFullName() $ " does really have the ability " $ OwnerDoesNotHaveSoldierAbility $ ", AA_FAIL");
	return 'AA_NotAUnit';
	
}