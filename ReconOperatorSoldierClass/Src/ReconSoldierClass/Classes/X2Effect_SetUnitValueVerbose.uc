class X2Effect_SetUnitValueVerbose extends X2Effect;

var name UnitName;
var float NewValueToSet;
var EUnitValueCleanup CleanupType;

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_Unit TargetUnitState;

	TargetUnitState = XComGameState_Unit(kNewTargetState);
	TargetUnitState.SetUnitFloatValue(UnitName, NewValueToSet, CleanupType);
	`log("VERBOSE: Set the value " $ UnitName $ " to " $ NewValueToSet $ " for unit " $ TargetUnitState.GetFullName());
}