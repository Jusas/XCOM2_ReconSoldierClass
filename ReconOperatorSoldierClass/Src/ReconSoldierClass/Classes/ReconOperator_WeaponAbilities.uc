
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
	local X2AbilityTemplate                 Template;	
	local X2Effect_PersistentStatChange		StatChangeEffect;
	local X2Effect_Persistent		BaseEffect;
	local X2Condition_UnitDoesNotHaveAbility AbilityMissingCondition;
	local X2Effect_Squadsight SquadsightEffect;
	local X2Condition_AbilityProperty HasAbilityCondition;
	local X2Condition_UnitValue ValueCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MarksmanRifleStatBonus');
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_honor_b"; // TODO change

	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bDisplayInUITacticalText = false;
	
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	// A dummy effect just to show the display info.
	BaseEffect = new class'X2Effect_Persistent';
	BaseEffect.BuildPersistentEffect(1, true, false, false);
	BaseEffect.EffectName = 'ReconMarksmanRifle_StatEffect';
	BaseEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage,,,Template.AbilitySourceName);
	Template.AddTargetEffect(BaseEffect);
	
	// The weapon adds a conditional squadsight (the conditions are set further below).
	SquadsightEffect = new class'X2Effect_Squadsight';
	SquadsightEffect.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnEnd);
	Template.AddTargetEffect(SquadsightEffect);

	// Add a stat effect, the move penalty.
	StatChangeEffect = new class'X2Effect_PersistentStatChange';
	StatChangeEffect.EffectName = 'ReconMarksmanRifle_MovementAccuracyPenalty';
	StatChangeEffect.SetDisplayInfo(ePerkBuff_Penalty, "Marksman Rifle", "Moving penalty applies", Template.IconImage,,,Template.AbilitySourceName);
	StatChangeEffect.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnEnd);
	StatChangeEffect.AddPersistentStatChange(eStat_Offense, class'ReconOperator_Item_MarksmanRifle'.default.RECON_MARKSMAN_MOVE_PENALTY);
	

	// The conditions:
	// DO WE NEED ABILITY TRIGGERS?
	// Check for the ability "ReconMarksmanSpecializationAbility", if the target has it, don't apply.
	AbilityMissingCondition = new class'X2Condition_UnitDoesNotHaveAbility';
	AbilityMissingCondition.OwnerDoesNotHaveSoldierAbility = 'ReconMarksmanSpecialization';
	StatChangeEffect.TargetConditions.AddItem(AbilityMissingCondition);

	// Check that the unit has moved this turn. If it has, and the above condition succeeds, apply effect.
	// TODO: Does this work?
	ValueCondition = new class'X2Condition_UnitValue';
	ValueCondition.AddCheckValue('MovesThisTurn', 1, eCheck_GreaterThanOrEqual);
	StatChangeEffect.TargetConditions.AddItem(ValueCondition);

	// Squadsight condition: the weapon gives the soldier squadsight if it has the 'ReconMarksmanSpecializationAbility'.
	HasAbilityCondition = new class'X2Condition_AbilityProperty';
	HasAbilityCondition.OwnerHasSoldierAbilities.AddItem('ReconMarksmanSpecialization');
	SquadsightEffect.TargetConditions.AddItem(HasAbilityCondition);

	Template.AddTargetEffect(StatChangeEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;	
}
