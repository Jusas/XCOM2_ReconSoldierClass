class ReconOperator_SurvivorArmorEffect extends X2Effect_BonusArmor config(GameData_Effects);

var config int RECON_SURVIVOR_ARMOR_CHANCE;
var config int RECON_SURVIVOR_ARMOR_MITIGATION;

function int GetArmorChance(XComGameState_Effect EffectState, XComGameState_Unit UnitState)
{
	return default.RECON_SURVIVOR_ARMOR_CHANCE; 
}

function int GetArmorMitigation(XComGameState_Effect EffectState, XComGameState_Unit UnitState) 
{
	return default.RECON_SURVIVOR_ARMOR_MITIGATION;
}
