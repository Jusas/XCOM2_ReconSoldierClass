// Renamed this to Fighting Spirit in the strings to not have it mixed up with Bring Em On in LW. 
// Not sure if it's the same effect but I recall it being similar.
class ReconOperator_BringEmOn_Effect extends X2Effect_Persistent;

var int BonusDmg; // how many visible enemies are required per step
var int VisibleEnemiesPerBonusStep; // how big of a damage bonus per step

function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState)
{ 
	local int NumEnemiesVisible;
	local int Multiplier;
	local int CritMultiplier;
	local array<StateObjectReference> SquadSightEnemiesvisible;

	CritMultiplier = 1;
	NumEnemiesVisible = Attacker.GetNumVisibleEnemyUnits();

	if(Attacker.HasSquadsight())
	{
		class'X2TacticalVisibilityHelpers'.static.GetAllSquadsightEnemiesForUnit(Attacker.ObjectID, SquadSightEnemiesvisible);
		NumEnemiesVisible += SquadSightEnemiesvisible.length;
	}

	Multiplier = NumEnemiesVisible / VisibleEnemiesPerBonusStep;

	if (AbilityState.SourceWeapon == EffectState.ApplyEffectParameters.ItemStateObjectRef)
	{
		
		if(AppliedData.AbilityResultContext.HitResult == eHit_Crit)
			CritMultiplier = 2;

		`log("[ReconOperator]-> BringEmOn: Bonus damage is " $ (Multiplier * BonusDmg) $ " (" $ Multiplier $ " x " $ BonusDmg $ ")");
		return Multiplier * BonusDmg * CritMultiplier;
	}

	return 0; 
}