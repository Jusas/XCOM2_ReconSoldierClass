class ReconOperator_ReturnFireEffect extends X2Effect_CoveringFire;

DefaultProperties
{
	EffectName = "ReconReturnFire"
	DuplicateResponse = eDupe_Ignore
	AbilityToActivate = "ReconStandardReturnFire"
	GrantActionPoint = "returnfire"
	MaxPointsPerTurn = 3
	bDirectAttackOnly = false
	bPreEmptiveFire = false
	bOnlyDuringEnemyTurn = true
}