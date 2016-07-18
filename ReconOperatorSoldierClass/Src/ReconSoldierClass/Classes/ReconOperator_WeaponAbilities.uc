
class ReconOperator_WeaponAbilities extends X2Ability
	dependson (XComGameStateContext_Ability) config(GameData_WeaponData); // Configuration in the XComGameData_WeaponData.ini


// -----------------------------------------------------------------------------------------------------
// "Entry point"
// -----------------------------------------------------------------------------------------------------

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem( AddCarbineBonusAbility() );
	Templates.AddItem( AddMarksmanRifleBonusAbility() );
	Templates.AddItem( AddMarksmanMovementEffectsAbility() );

	return Templates;

}


// -----------------------------------------------------------------------------------------------------
// Recon Carbine bonus abilities
// -----------------------------------------------------------------------------------------------------

static function X2AbilityTemplate AddCarbineBonusAbility()
{
	local X2AbilityTemplate                 Template;	
	local X2Effect_PersistentStatChange		PersistentStatChangeEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'ReconCarbineStatBonus');
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_dash"; 

	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bDisplayInUITacticalText = false;
	
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	
	// Bonus to Mobility
	PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
	PersistentStatChangeEffect.EffectName = 'ReconCarbineMobilityBonus';
	PersistentStatChangeEffect.BuildPersistentEffect(1, true, false, false);
	PersistentStatChangeEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_Mobility, class'ReconOperator_Item_Carbine'.default.RECON_CARBINE_MOBILITY_BONUS);
	Template.AddTargetEffect(PersistentStatChangeEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;	
}

// -----------------------------------------------------------------------------------------------------
// Marksman Rifle bonus abilities
// -----------------------------------------------------------------------------------------------------

static function X2AbilityTemplate AddMarksmanRifleBonusAbility()
{
	local X2AbilityTemplate Template;
	local X2Effect_Squadsight SquadsightEffect;
	local X2Condition_AbilityProperty HasAbilityCondition;


	`CREATE_X2ABILITY_TEMPLATE(Template, 'ReconMarksmanRifleBonus');
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_squadsight";

	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bDisplayInUITacticalText = false;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	Template.AdditionalAbilities.AddItem('ReconMarksmanMovementEffects');
	
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	
	// A dummy effect just to show the display info.
	//BaseEffect = new class'X2Effect_Persistent';
	//BaseEffect.BuildPersistentEffect(1, true, false, false);
	//BaseEffect.EffectName = 'ReconMarksmanRifle_StatEffect';
	//BaseEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage,,,Template.AbilitySourceName);
	//Template.AddTargetEffect(BaseEffect);
	
	// The weapon adds a conditional squadsight (the conditions are set further below).
	SquadsightEffect = new class'X2Effect_Squadsight';
	SquadsightEffect.BuildPersistentEffect(1, true, true, true);
	SquadsightEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage,,,Template.AbilitySourceName);
	Template.AddTargetEffect(SquadsightEffect);

	// Squadsight condition: the weapon gives the soldier squadsight if it has the 'ReconMarksmanSpecializationAbility'.
	HasAbilityCondition = new class'X2Condition_AbilityProperty';
	HasAbilityCondition.OwnerHasSoldierAbilities.AddItem('ReconMarksmanSpecialization');
	SquadsightEffect.TargetConditions.AddItem(HasAbilityCondition);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;	
}


static function X2AbilityTemplate AddMarksmanMovementEffectsAbility()
{
	local X2AbilityTemplate                 Template;	
	local X2Effect_PersistentStatChange		StatChangeEffect;
	local ReconOperator_Condition_UnitDoesNotHaveAbility AbilityMissingCondition;
	local X2Condition_UnitValue ValueCondition;
	local X2AbilityTrigger_EventListener MoveFinishedListener;


	`CREATE_X2ABILITY_TEMPLATE(Template, 'ReconMarksmanMovementEffects');
	Template.IconImage = "img:///UILibrary_ReconOperator.UIPerk_marksman_move_penalty";

	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bDisplayInUITacticalText = false;
		
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;

	// Trigger when the unit moves, provided that the conditions are met.
	MoveFinishedListener = new class'X2AbilityTrigger_EventListener';
	MoveFinishedListener.ListenerData.Deferral = ELD_OnStateSubmitted;
	MoveFinishedListener.ListenerData.EventID = 'UnitMoveFinished';
	MoveFinishedListener.ListenerData.Filter = eFilter_Unit;
	MoveFinishedListener.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
	Template.AbilityTriggers.AddItem(MoveFinishedListener);
	
	// Add a stat effect, the move penalty.
	StatChangeEffect = new class'X2Effect_PersistentStatChange';
	StatChangeEffect.EffectName = 'ReconMarksmanRifle_MovementAccuracyPenalty';
	StatChangeEffect.SetDisplayInfo(ePerkBuff_Penalty, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage,,,Template.AbilitySourceName);
	StatChangeEffect.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnBegin);
	StatChangeEffect.AddPersistentStatChange(eStat_Offense, class'ReconOperator_Item_MarksmanRifle'.default.RECON_MARKSMAN_MOVE_PENALTY);
	Template.AddTargetEffect(StatChangeEffect);

	// The conditions:
	// Check for the ability "ReconMarksmanSpecialization", if the target has it, don't apply.
	AbilityMissingCondition = new class'ReconOperator_Condition_UnitDoesNotHaveAbility';
	AbilityMissingCondition.OwnerDoesNotHaveSoldierAbility = 'ReconMarksmanSpecialization';
	StatChangeEffect.TargetConditions.AddItem(AbilityMissingCondition);

	// Check that the unit has moved this turn. If it has, and the above condition succeeds, apply effect.
	ValueCondition = new class'X2Condition_UnitValue';
	ValueCondition.AddCheckValue('MovesThisTurn', 1, eCheck_GreaterThanOrEqual);
	StatChangeEffect.TargetConditions.AddItem(ValueCondition);


	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;	
}
