// There's one annoying problem that keeps me awake.
// Since the CoveringFire effect triggers on AbilityActivated and the HunkerDown effect
// on TakeDamage, we always run the CoveringFire code first, always triggering the effect.
// The desired effect would be to not run the CoveringFire code whenever we don't get hit, but since
// we get the hit information afterwards, it can't work that way.
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