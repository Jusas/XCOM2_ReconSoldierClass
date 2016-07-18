// An effect that causes the targeted unit's groups to scamper.
class ReconOperator_CauseScamperEffect extends X2Effect_Persistent;

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_Unit TargetUnitState, SourceUnitState;
	local int SourceObjectID;
	local XComGameStateHistory History;
	local XComGameState_AIGroup AIGroupState;
	local array<int> LivingMembers;
	local int LivingMemberID;

	History = `XCOMHISTORY;	
	SourceObjectID = ApplyEffectParameters.SourceStateObjectRef.ObjectID;
	SourceUnitState = XComGameState_Unit(History.GetGameStateForObjectID(SourceObjectID));
	TargetUnitState = XComGameState_Unit(kNewTargetState);

	`log("[ReconOperator]-> CauseScamperEffect: Effect added to " $ TargetUnitState.GetFullName());

	foreach History.IterateByClassType(class'XComGameState_AIGroup', AIGroupState)
	{
		LivingMembers.Length = 0;
		AIGroupState.GetLivingMembers(LivingMembers);
		foreach LivingMembers(LivingMemberID)
		{
			if(TargetUnitState.ObjectID == LivingMemberID)
			{
				`log("[ReconOperator]-> CauseScamperEffect: Target found");
				// TODO: are these conditions enough?
				if(!AIGroupState.bPendingScamper && !AIGroupState.bProcessedScamper)
				{
					`log("[ReconOperator]-> CauseScamperEffect: Target AIGroup not scampered, triggering it");
					AIGroupState.ApplyAlertAbilityToGroup(eAC_TakingFire);
					AIGroupState.InitiateReflexMoveActivate(SourceUnitState, eAC_SeesSpottedUnit);
				}
				else
				{
					`log("[ReconOperator]-> CauseScamperEffect: Target AIGroup already scampering, ignoring");
				}
			}
		}
	}

}