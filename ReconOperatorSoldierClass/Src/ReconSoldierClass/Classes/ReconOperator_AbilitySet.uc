// Cheat sheet, all events listed:
// http://pastebin.com/8vbi1t2r

class ReconOperator_AbilitySet extends X2Ability
	dependson (XComGameStateContext_Ability) config(GameData_SoldierSkills); // Configuration in the XComGameData_SoldierSkills.ini

// -----------------------------------------------------------------------------------------------------
// Configuration variables.
// -----------------------------------------------------------------------------------------------------

var config int LIGHTFEET_MOBILITY; // Mobility bonus granted by Light Feet


// -----------------------------------------------------------------------------------------------------
// "Entry point"
// -----------------------------------------------------------------------------------------------------

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	// Fire pistol, Double Tap, Concealment abilities are already defined by the game, so they aren't here.
	// They're simply referred to in the INI file.

	Templates.AddItem( AddLightFeetAbility() );
	Templates.AddItem( AddSituationalAwarenessAbility() );
	Templates.AddItem( AddSituationalAwarenessWatcher() );
	Templates.AddItem( AddSituationalAwarenessReaction() );
	return Templates;

}



// -----------------------------------------------------------------------------------------------------
// Light Feet, giving a bonus to mobility and stealth.
// -----------------------------------------------------------------------------------------------------

static function X2AbilityTemplate AddLightFeetAbility()
{
	local X2AbilityTemplate                 Template;
	local X2Effect_PersistentStatChange		PersistentStatChangeEffect;

	`CREATE_X2ABILITY_TEMPLATE( Template, 'ReconLightFeet' );
	
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_dash";

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	
	// Simple enough, we just add a persistent stat change for eStat_Mobility.
	PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
	PersistentStatChangeEffect.EffectName = 'ReconLightFeet';
	PersistentStatChangeEffect.BuildPersistentEffect(1, true, false);
	PersistentStatChangeEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage,,,Template.AbilitySourceName);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_Mobility, default.LIGHTFEET_MOBILITY);
	PersistentStatChangeEffect.DuplicateResponse = eDupe_Ignore;
	Template.AddTargetEffect(PersistentStatChangeEffect);		

	Template.bCrossClassEligible = true;

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	`log("[ReconOperator]-> Light Feet Ability template created");

	return Template;
}

// -----------------------------------------------------------------------------------------------------
// Situational Awareness ability, which grants free overwatch fire if the operator triggers a pod.
// Followed by two other abilities that this main "dummy" ability refers to.
//
// The structure of this ability is somewhat complex and I've tried to explain it here.
//
// The logic path for the whole ability set:
// 1.   The 'ReconSituationalAwarenessWatcher' ability watches for 'ScamperBegin' events.
// 2.   When the Watcher's listener gets triggered, it finds out if the scamper was instigated by
//      a unit that has the 'ReconSituationalAwareness' ability. If the check passes, 'CausedScamper' 
//      UnitValue is set for the instigator unit.
// 3.   The 'ReconSituationalAwarenessReaction' ability has triggers set for movement and has pretty much
//      overwatch fire settings, plus a custom condition 'ReconOperator_SituationalAwarenessCondition'
//      that checks for the 'CausedScamper' UnitValue in in the shooter. This custom condition
//      also limits the triggering of the ability to one target per turn only. 
//      It does this by temporarily storing the target ObjectID to the Ability's Source Unit, 
//      and all consecutive checks that have the same target ObjectID will pass. Once the effects 
//      are applied, the stored ObjectID is reset to 0, so that no other potential moving target object
//      may trigger this ability (nor can the same object trigger it twice as it moves). The UnitValue 
//      is cleaned up at the beginning of the next turn (eCleanup_BeginTurn) and the ability can again
//      activate on the next turn.
// 4.   When all conditions are fulfilled, the effects get applied. Target gets basic WeaponDamage applied.
// -----------------------------------------------------------------------------------------------------

static function X2AbilityTemplate AddSituationalAwarenessAbility()
{

	local X2AbilityTemplate         Template;

	// It's a pure passive skill, that has the additional ability 'ReconSituationalAwarenessTrigger'
	// and 'ReconSituationalAwarenessReaction' attached to it. The "meat" of the ability is actually
	// in those two abilities.
	// PurePassive creates a dummy persistent effect which displays the 'rapidreaction' icon.
	// Also made available for the AWC training roulette.
	Template = PurePassive('ReconSituationalAwareness', "img:///UILibrary_PerkIcons.UIPerk_rapidreaction", true);
	Template.AdditionalAbilities.AddItem('ReconSituationalAwarenessWatcher');
	Template.AdditionalAbilities.AddItem('ReconSituationalAwarenessReaction');
	
	`log("[ReconOperator]-> ReconSituationalAwareness Ability template created");

	return Template;

}

// -----------------------------------------------------------------------------------------------------
// The Situational Awareness watcher.
// A very bare bones ability that just listens for the 'ScamperBegin' event.
// The listener function then enables the actual reaction (ReconSituationalAwarenessReaction)
// to trigger simply by setting a UnitValue for the scamper instigator, if the instigator has
// the SituationalAwareness ability.
// -----------------------------------------------------------------------------------------------------

static function X2AbilityTemplate AddSituationalAwarenessWatcher()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityTrigger_EventListener    ScamperListener;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'ReconSituationalAwarenessWatcher');

	// Basic conditions.
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AbilityTargetStyle = default.SimpleSingleTarget;
	
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.AbilitySourceName = 'eAbilitySource_Perk';	
	Template.Hostility = eHostility_Offensive;

	// The trigger for this ability is 'ScamperBegin', ie. when the aliens start to scamper.
	// SituationalAwarenessScamperListener then triggers the activation of the Ability.

	ScamperListener = new class'X2AbilityTrigger_EventListener';
	ScamperListener.ListenerData.Deferral = ELD_OnStateSubmitted;
	ScamperListener.ListenerData.EventID = 'ScamperBegin';
	ScamperListener.ListenerData.Filter = eFilter_Unit;
	ScamperListener.ListenerData.EventFn = class'ReconOperator_AbilitySet'.static.SituationalAwarenessScamperListener;
	Template.AbilityTriggers.AddItem(ScamperListener);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	`log("[ReconOperator]-> ReconSituationalAwarenessWatcher Ability template created");

	return Template;
}


// -----------------------------------------------------------------------------------------------------
// The Situational Awareness ability reaction.
// This is where the actual action happens. 
// -----------------------------------------------------------------------------------------------------

static function X2AbilityTemplate AddSituationalAwarenessReaction()
{
	local X2AbilityCost_Ammo				AmmoCost;
	local X2AbilityCost_ActionPoints		ActionPointCost;
	local X2AbilityTrigger_Event			Trigger;
	local X2AbilityTemplate                 Template;
	local X2AbilityToHitCalc_StandardAim    StandardAim;
	local ReconOperator_SituationalAwarenessCondition Condition;
	local X2Effect_SetUnitValueVerbose		ShooterUnitValueEffect;
	local X2Condition_Visibility			TargetVisibilityCondition;
	local X2Effect_Persistent				SATargetEffect;
	local X2Condition_UnitEffectsWithAbilitySource SATargetCondition;
	local X2Effect_Knockback				KnockBackEffect;
	local X2AbilityTarget_Single			SingleTarget;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'ReconSituationalAwarenessReaction');

	// Standard aim, reaction fire penalties apply.
	StandardAim = new class'X2AbilityToHitCalc_StandardAim';
	StandardAim.bReactionFire = true;
	
	// Allow crits to happen. We've surprised the enemy and they're unprotected,
	// a crit might happen.
	StandardAim.bAllowCrit = true;
	Template.AbilityToHitCalc = StandardAim;
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	
	// Single target in weapons range.
	SingleTarget = new class'X2AbilityTarget_Single';
    SingleTarget.OnlyIncludeTargetsInsideWeaponRange = true;
    Template.AbilityTargetStyle = SingleTarget;
	
	// Don't show the icon; the dummy ability icon is already visible anyway.
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.AbilitySourceName = 'eAbilitySource_Perk';	
	Template.Hostility = eHostility_Defensive;

	// Note: you do need to specify this, even when it's free.
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.bFreeCost = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	// Costs one ammo.
	AmmoCost = new class'X2AbilityCost_Ammo';
	AmmoCost.iAmmo = 1;
	Template.AbilityCosts.AddItem(AmmoCost);


	// The Ranger BladeStorm ability worked well as a reference for the following...

	// Triggers on movement
	Trigger = new class'X2AbilityTrigger_Event';
	Trigger.EventObserverClass = class'X2TacticalGameRuleset_MovementObserver';
	Trigger.MethodName = 'InterruptGameState';
	Template.AbilityTriggers.AddItem(Trigger);

	Trigger = new class'X2AbilityTrigger_Event';
	Trigger.EventObserverClass = class'X2TacticalGameRuleset_MovementObserver';
	Trigger.MethodName = 'PostBuildGameState';
	Template.AbilityTriggers.AddItem(Trigger);

	Template.AbilityTargetConditions.AddItem(default.LivingHostileUnitDisallowMindControlProperty);
	TargetVisibilityCondition = new class'X2Condition_Visibility';
	TargetVisibilityCondition.bRequireBasicVisibility = true;
	TargetVisibilityCondition.bDisablePeeksOnMovement = true; //Don't use peek tiles for over watch shots	
	Template.AbilityTargetConditions.AddItem(TargetVisibilityCondition);

	Template.bAllowFreeFireWeaponUpgrade = false;	

	// Allow ammo effects (AP, incendiary, etc) to apply here.
	Template.bAllowAmmoEffects = true;

	// The damage effect.
	Template.AddTargetEffect(new class'X2Effect_ApplyWeaponDamage');

	// Knockback for the ragdoll if the target dies.
	KnockbackEffect = new class'X2Effect_Knockback';
	KnockbackEffect.KnockbackDistance = 2;
	KnockbackEffect.bUseTargetLocation = true;
	Template.AddTargetEffect(KnockbackEffect);
	
	// TESTING
	//Template.AddShooterEffect(new class'ReconOperator_TestEffect');

	// Reset the 'CausedScamper' with this effect. Doesn't matter if the shot was a hit or miss.
	ShooterUnitValueEffect = new class'X2Effect_SetUnitValueVerbose';
	ShooterUnitValueEffect.UnitName = 'CausedScamper';
	ShooterUnitValueEffect.NewValueToSet = 0;
	ShooterUnitValueEffect.CleanupType = eCleanup_BeginTurn;
	ShooterUnitValueEffect.bApplyOnHit = true;
	ShooterUnitValueEffect.bApplyOnMiss = true;	
	Template.AddShooterEffect(ShooterUnitValueEffect);

	// Also reset 'ReconSituationalAwarenessTarget' value, this is used by 'ReconOperator_SituationalAwarenessCondition'
	// to enforce single target. Otherwise this ability would run for all eligible targets and that would be OP.
	ShooterUnitValueEffect = new class'X2Effect_SetUnitValueVerbose';
	ShooterUnitValueEffect.UnitName = 'ReconSituationalAwarenessTarget';
	ShooterUnitValueEffect.NewValueToSet = 0;
	ShooterUnitValueEffect.CleanupType = eCleanup_BeginTurn;
	ShooterUnitValueEffect.bApplyOnHit = true;
	ShooterUnitValueEffect.bApplyOnMiss = true;	
	Template.AddShooterEffect(ShooterUnitValueEffect);


	// Prevent repeatedly hammering on a unit with the above triggers.	
	SATargetEffect = new class'X2Effect_Persistent';
	SATargetEffect.BuildPersistentEffect(1, false, true, true, eGameRule_PlayerTurnEnd);
	SATargetEffect.EffectName = 'ReconSituationalAwarenessTarget';
	SATargetEffect.bApplyOnMiss = true;
	Template.AddTargetEffect(SATargetEffect);

	SATargetCondition = new class'X2Condition_UnitEffectsWithAbilitySource';
	SATargetCondition.AddExcludeEffect('ReconSituationalAwarenessTarget', 'AA_DuplicateEffectIgnored');
	Template.AbilityTargetConditions.AddItem(SATargetCondition);
	
	// Finally:
	// Custom condition: scampering must just have happened, caused by the unit that has this ability.
	// Done by setting a UnitValue 'CausedScampering' inside the 'ScamperBegin' listener.
	Condition = new class'ReconOperator_SituationalAwarenessCondition';
	Template.AbilityTargetConditions.AddItem(Condition);

	// Targeting Method
	//Template.TargetingMethod = class'X2TargetingMethod_OverTheShoulder';
	Template.CinescriptCameraType = "StandardGunFiring";

	// Voice events
	//Template.ActivationSpeech = 'DoubleTap';

	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;	

	Template.bShowActivation = true;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	`log("[ReconOperator]-> ReconSituationalAwarenessReaction Ability template created");

	return Template;
}


// -----------------------------------------------------------------------------------------------------
// Situational Awareness scamper listener, which checks if the scamper instigator has the
// 'ReconSituationalAwareness' ability. If it has, the listener sets the 'CausedScampering'
// UnitValue to 1 for the instigator, and that value is the decisive trigger in the 
// 'ReconSituationalAwarenessReaction' ability.
// -----------------------------------------------------------------------------------------------------


static function EventListenerReturn SituationalAwarenessScamperListener(Object EventData, Object EventSource, XComGameState GameState, Name EventID)
{
	local XComGameState NewGameState;
	local XComGameStateHistory History;
	local XComGameState_Ability ReactionAbilityState;
	local StateObjectReference ReactionAbilityRef;
	local StateObjectReference AbilityRef;	
	local XComGameStateContext_RevealAI RevealContext;
	local XComGameState_Unit Instigator;
	local XComGameState_Unit UnitState;
	local UnitValue UnitVal;
	local bool HasUnitValSet;


	`log("[ReconOperator]-> SCAMPERLISTENER: Entered");

	History = `XCOMHISTORY;
	RevealContext = XComGameStateContext_RevealAI(GameState.GetContext());
	Instigator = XComGameState_Unit(History.GetGameStateForObjectID(RevealContext.CausedRevealUnit_ObjectID));

	if(Instigator == none)
	{
		`log("[ReconOperator]-> SCAMPERLISTENER: Instigator == none");
		return ELR_NoInterrupt;
	}
	
	`log("[ReconOperator]-> SCAMPERLISTENER: Instigator is " $ Instigator.GetFirstName() $ " " $ Instigator.GetLastName());

	AbilityRef = Instigator.FindAbility('ReconSituationalAwareness');
	if(AbilityRef.ObjectID == 0)
	{
		`log("[ReconOperator]-> SCAMPERLISTENER: Instigator doesn't have ReconSituationalAwareness ability");
		return ELR_NoInterrupt;
	}

	ReactionAbilityRef = Instigator.FindAbility('ReconSituationalAwarenessReaction');
	ReactionAbilityState = XComGameState_Ability(History.GetGameStateForObjectID(ReactionAbilityRef.ObjectID));
	if (ReactionAbilityState == none)
	{
		`log("[ReconOperator]-> SCAMPERLISTENER: Instigator doesn't have ReconSituationalAwarenessReaction ability");
		return ELR_NoInterrupt;
	}
	
	HasUnitValSet = Instigator.GetUnitValue('CausedScampering', UnitVal);
	if(!HasUnitValSet)
	{
		NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState(string(GetFuncName()));
		UnitState = XComGameState_Unit(NewGameState.CreateStateObject(Instigator.Class, Instigator.ObjectID));
		UnitState.SetUnitFloatValue('CausedScampering', 1, eCleanup_BeginTurn);
		NewGameState.AddStateObject(UnitState);
		`TACTICALRULES.SubmitGameState(NewGameState);
		`log("[ReconOperator]-> SCAMPERLISTENER: OK passed, CausedScampering set to 1");
	}
	else
	{
		if(UnitVal.fValue > 0)
		{
			`log("[ReconOperator]-> SCAMPERLISTENER: OK passed, CausedScampering is already 1, not setting it again.");
		}
		else
		{
			NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState(string(GetFuncName()));
			UnitState = XComGameState_Unit(NewGameState.CreateStateObject(Instigator.Class, Instigator.ObjectID));
			UnitState.SetUnitFloatValue('CausedScampering', 1, eCleanup_BeginTurn);
			NewGameState.AddStateObject(UnitState);
			`TACTICALRULES.SubmitGameState(NewGameState);
			`log("[ReconOperator]-> SCAMPERLISTENER: OK passed, CausedScampering was previously 0, now set to 1");
		}
	}
	

	return ELR_NoInterrupt;
}





