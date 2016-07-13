// Incredibly unintuitive, but:
// This was a necessary step because apparently sometimes at least the Tactical combat in debug
// mode does simply not register the listeners.

class ReconOperator_ScamperWatchEffect extends X2Effect_Persistent
	config(GameData_SoldierSkills);

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
	local X2EventManager EventMgr;
	local Object EffectObj;

	EventMgr = `XEVENTMGR;

	EffectObj = EffectGameState;
	`log("[ReconOperator]-> Registering for event ScamperBegin");
	EventMgr.RegisterForEvent(EffectObj, 'ScamperBegin', class'ReconOperator_AbilitySet'.static.SituationalAwarenessScamperListener, ELD_OnStateSubmitted);
}
