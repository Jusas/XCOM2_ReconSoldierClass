class ReconOperator_MarksmanSquadsightPenalty_Effect extends X2Effect_Persistent config(GameData_WeaponData);

var config int RECON_MARKSMAN_SQUADSIGHT_PENALTY;
var localized string LocFriendlyName;


function GetToHitModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
	local ShotModifierInfo ShotInfo;
	local array<StateObjectReference> VisibleUnits;
	local StateObjectReference UnitRef;

	class'X2TacticalVisibilityHelpers'.static.GetAllSquadsightEnemiesForUnit(Attacker.ObjectID, VisibleUnits);

	foreach VisibleUnits(UnitRef)
	{
		if(Target.ObjectID == UnitRef.ObjectID)
		{
			`Log("[ReconOperator]-> Target " $ Target.GetFullName() $ " is a squadsight target, applying marksman SS penalty");
			ShotInfo.ModType = eHit_Success;
			ShotInfo.Value = default.RECON_MARKSMAN_SQUADSIGHT_PENALTY;
			ShotInfo.Reason = LocFriendlyName;
			ShotModifiers.AddItem(ShotInfo);
			break;
		}
	}

}

DefaultProperties
{
	DuplicateResponse = eDupe_Ignore
	EffectName = "ReconMarksmanSquadsightPenalty"
}