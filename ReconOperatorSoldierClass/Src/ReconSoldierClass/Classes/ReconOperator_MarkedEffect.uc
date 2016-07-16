// Basically a copy of the X2Effect_Marked (with some stuff brought in from
// X2StatusEffects class), but with my own modifiable variables.

class ReconOperator_MarkedEffect extends X2Effect_Persistent
	config(GameData_Effects);

var config int RECON_MARKED_ACCURACY_CHANCE_BONUS;
var config int RECON_MARKED_CRIT_CHANCE_BONUS;
var config int RECON_MARKED_CRIT_DAMAGE_BONUS;

var localized string MarkedFriendlyName;
var localized string MarkedFriendlyDesc;
var localized string MarkedEffectLostString;
var localized string MarkedEffectTickedString;
var localized string MarkedEffectAcquiredString;

function int GetDefendingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, 
										const out EffectAppliedData AppliedData, const int CurrentDamage, X2Effect_ApplyWeaponDamage WeaponDamageEffect)
{
	// This unit takes extra crit damage
	if (AppliedData.AbilityResultContext.HitResult == eHit_Crit)
	{
		return default.RECON_MARKED_CRIT_DAMAGE_BONUS;
	}
	return 0;
}

function GetToHitAsTargetModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
	local ShotModifierInfo AccuracyInfo, CritInfo;

	AccuracyInfo.ModType = eHit_Success;
	AccuracyInfo.Value = default.RECON_MARKED_ACCURACY_CHANCE_BONUS;
	AccuracyInfo.Reason = default.MarkedFriendlyName;
	ShotModifiers.AddItem(AccuracyInfo);

	CritInfo.ModType = eHit_Crit;
	CritInfo.Value = default.RECON_MARKED_CRIT_CHANCE_BONUS;
	CritInfo.Reason = default.MarkedFriendlyName;
	ShotModifiers.AddItem(CritInfo);
}

simulated function AddX2ActionsForVisualization_Tick(XComGameState VisualizeGameState, out VisualizationTrack BuildTrack, const int TickIndex, XComGameState_Effect EffectState)
{
	local X2Action_PlaySoundAndFlyOver SoundAndFlyOver;
	
	SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTrack(BuildTrack, VisualizeGameState.GetContext()));
	SoundAndFlyOver.SetSoundAndFlyOverParameters(None, default.MarkedFriendlyName, '', eColor_Bad);
}

static function ReconOperator_MarkedEffect CreateMarkedEffect()
{
	local ReconOperator_MarkedEffect PersistentEffect;

	PersistentEffect = new class 'ReconOperator_MarkedEffect';
	PersistentEffect.EffectName = 'ReconMarkedTarget';
	PersistentEffect.DuplicateResponse = eDupe_Ignore;
	PersistentEffect.BuildPersistentEffect(2, false, true,,eGameRule_PlayerTurnEnd);
	PersistentEffect.SetDisplayInfo(ePerkBuff_Penalty, default.MarkedFriendlyName, default.MarkedFriendlyDesc, "img:///UILibrary_ReconOperator.UIPerk_reconnoitered");
	PersistentEffect.VisualizationFn = MarkedVisualization;
	PersistentEffect.EffectTickedVisualizationFn = MarkedVisualizationTicked;
	PersistentEffect.EffectRemovedVisualizationFn = MarkedVisualizationRemoved;
	PersistentEffect.bRemoveWhenTargetDies = true;

	return PersistentEffect;
}

static function MarkedVisualization(XComGameState VisualizeGameState, out VisualizationTrack BuildTrack, const name EffectApplyResult)
{
	if( EffectApplyResult != 'AA_Success' )
	{
		return;
	}
	if (XComGameState_Unit(BuildTrack.StateObject_NewState) == none)
		return;

	class'X2StatusEffects'.static.AddEffectSoundAndFlyOverToTrack(BuildTrack, VisualizeGameState.GetContext(), default.MarkedFriendlyName, '', eColor_Bad, class'UIUtilities_Image'.const.UnitStatus_Marked);
	class'X2StatusEffects'.static.AddEffectMessageToTrack(BuildTrack, default.MarkedEffectAcquiredString, VisualizeGameState.GetContext());
	class'X2StatusEffects'.static.UpdateUnitFlag(BuildTrack, VisualizeGameState.GetContext());
}

static function MarkedVisualizationTicked(XComGameState VisualizeGameState, out VisualizationTrack BuildTrack, const name EffectApplyResult)
{
	local XComGameState_Unit UnitState;

	UnitState = XComGameState_Unit(BuildTrack.StateObject_NewState);
	if (UnitState == none)
		return;

	// dead units should not be reported
	if( !UnitState.IsAlive() )
	{
		return;
	}

	class'X2StatusEffects'.static.AddEffectSoundAndFlyOverToTrack(BuildTrack, VisualizeGameState.GetContext(), default.MarkedFriendlyName, '', eColor_Bad, class'UIUtilities_Image'.const.UnitStatus_Marked);
	class'X2StatusEffects'.static.AddEffectMessageToTrack(BuildTrack, default.MarkedEffectTickedString, VisualizeGameState.GetContext());
	class'X2StatusEffects'.static.UpdateUnitFlag(BuildTrack, VisualizeGameState.GetContext());
}

static function MarkedVisualizationRemoved(XComGameState VisualizeGameState, out VisualizationTrack BuildTrack, const name EffectApplyResult)
{
	local XComGameState_Unit UnitState;

	UnitState = XComGameState_Unit(BuildTrack.StateObject_NewState);
	if (UnitState == none)
		return;

	// dead units should not be reported
	if( !UnitState.IsAlive() )
	{
		return;
	}

	class'X2StatusEffects'.static.AddEffectMessageToTrack(BuildTrack, default.MarkedEffectLostString, VisualizeGameState.GetContext());
	class'X2StatusEffects'.static.UpdateUnitFlag(BuildTrack, VisualizeGameState.GetContext());
}
