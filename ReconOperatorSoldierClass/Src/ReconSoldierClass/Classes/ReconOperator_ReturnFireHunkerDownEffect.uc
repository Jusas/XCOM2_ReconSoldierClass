class ReconOperator_ReturnFireHunkerDownEffect extends X2Effect_Persistent;

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
	local X2EventManager EventMgr;
	local Object EffectObj;

	EventMgr = `XEVENTMGR;

	EffectObj = EffectGameState;

	EventMgr.RegisterForEvent(EffectObj, 'UnitTakeEffectDamage', static.OnDamageTaken, ELD_OnStateSubmitted, 10);
}

static function EventListenerReturn OnDamageTaken(Object EventData, Object EventSource, XComGameState GameState, Name EventID)
{
	local XComGameState_Unit HitUnit;
	local XComGameState_Unit NewHitUnitState;
	local StateObjectReference ObjectRef;
	local XComGameState_Ability AbilityState;
	local XComGameStateHistory History;
	local XComGameState_Effect EffectState;
	local XComGameState NewGameState;
	local XComGameStateContext_EffectRemoved EffectRemovedState;

	`log("[ReconOperator]-> OnDamageTaken");

	History = `XCOMHISTORY;
	HitUnit = XComGameState_Unit(EventSource);//XComGameState_Unit(History.GetGameStateForObjectID(ApplyEffectParameters.TargetStateObjectRef.ObjectID));	
	foreach HitUnit.AffectedByEffects(ObjectRef)
	{
		EffectState = XComGameState_Effect(History.GetGameStateForObjectID(ObjectRef.ObjectID));
		`log("[ReconOperator]-> Hit unit is affected by effect " $ EffectState.GetX2Effect().EffectName);
		if(EffectState.GetX2Effect().IsA('ReconOperator_ReturnFireEffect'))
		{
			`log("[ReconOperator]-> Got hit, removing effect");
			//NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState(string(GetFuncName()));
			//NewEffectState = XComGameState_Effect(NewGameState.CreateStateObject(EffectState.Class, EffectState.ObjectID));
			//ReturnFireEffect = ReconOperator_ReturnFireEffect(NewEffectState.GetX2Effect());
			//ReturnFireEffect.MaxPointsPerTurn = 0;
			//NewGameState.AddStateObject(NewEffectState);
			//`TACTICALRULES.SubmitGameState(NewGameState);

			EffectRemovedState = class'XComGameStateContext_EffectRemoved'.static.CreateEffectRemovedContext(EffectState);
			NewGameState = History.CreateNewGameState(true, EffectRemovedState);
			EffectState.RemoveEffect(NewGameState, GameState);
			`TACTICALRULES.SubmitGameState(NewGameState);
			break;
		}
	}

	ObjectRef = HitUnit.FindAbility('HunkerDown');
	AbilityState = XComGameState_Ability(History.GetGameStateForObjectID(ObjectRef.ObjectID));
	if (AbilityState != none && AbilityState.CanActivateAbility(HitUnit,,true) == 'AA_Success')
	{
		if (HitUnit.NumActionPoints() == 0)
		{
			NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState(string(GetFuncName()));
			NewHitUnitState = XComGameState_Unit(NewGameState.CreateStateObject(HitUnit.Class, HitUnit.ObjectID));
			//  give the unit an action point so they can activate hunker down
			NewHitUnitState.ActionPoints.AddItem(class'X2CharacterTemplateManager'.default.DeepCoverActionPoint);					
			NewGameState.AddStateObject(NewHitUnitState);
			`TACTICALRULES.SubmitGameState(NewGameState);
		}
		
		return AbilityState.AbilityTriggerEventListener_Self(EventData, EventSource, GameState, EventID);
	}

	return ELR_NoInterrupt;
}
