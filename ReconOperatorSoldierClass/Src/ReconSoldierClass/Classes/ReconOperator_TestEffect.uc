class ReconOperator_TestEffect extends X2Effect config(GameCore);

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_Unit TargetUnit;
	TargetUnit = XComGameState_Unit(kNewTargetState);

	`log("[ReconOperator]-> SituationalAwareness Shooter is " $ TargetUnit.GetFirstName() $ " " $ TargetUnit.GetLastName());
	super.OnEffectAdded(ApplyEffectParameters, kNewTargetState, NewGameState, NewEffectState);
}
