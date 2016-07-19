class ReconOperator_BringEmOn_Effect extends X2Effect_Persistent;

var int BonusDmg; // how many visible enemies are required per step
var int VisibleEnemiesPerBonusStep; // how big of a damage bonus per step

function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState)
{ 
	local int NumEnemiesVisible;
	local int Multiplier;

	NumEnemiesVisible = Attacker.GetNumVisibleEnemyUnits();

	Multiplier = NumEnemiesVisible / VisibleEnemiesPerBonusStep;

	if (AbilityState.SourceWeapon == EffectState.ApplyEffectParameters.ItemStateObjectRef)
	{
		`log("[ReconOperator]-> BringEmOn: Bonus damage is " $ (Multiplier * BonusDmg) $ " (" $ Multiplier $ " x " $ BonusDmg $ ")");
		return Multiplier * BonusDmg;
	}

	return 0; 
}