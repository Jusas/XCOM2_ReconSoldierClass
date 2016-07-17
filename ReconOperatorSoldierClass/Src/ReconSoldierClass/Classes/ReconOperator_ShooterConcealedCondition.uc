// -----------------------------------------------------------------------------------------------------

// -----------------------------------------------------------------------------------------------------

class ReconOperator_ShooterConcealedCondition extends X2Condition;

event name CallMeetsConditionWithSource(XComGameState_BaseObject kTarget, XComGameState_BaseObject kSource) 
{
	local XComGameState_Unit SourceUnit, TargetUnit;
	
	SourceUnit = XComGameState_Unit(kSource);
	TargetUnit = XComGameState_Unit(kTarget);
	
	if (SourceUnit == none || TargetUnit == none)
	{
		`log("[ReconOperator]-> ReconOperator_ShooterConcealedCondition: No source/target unit, FAIL");
		return 'AA_NotAUnit';
	}

	if(SourceUnit.IsConcealed())
	{
		`log("[ReconOperator]-> ReconOperator_ShooterConcealedCondition: Shooter is concealed, PASS.");
		return 'AA_Success'; 	
	}

	`log("[ReconOperator]-> ReconOperator_ShooterConcealedCondition: Shooter is NOT concealed, FAIL.");
	return 'AA_NotAUnit';
}
