class ReconOperator_AbilityToHitCalc_ReconPinpointAccuracy extends X2AbilityToHitCalc_StandardAim config(GameData_Effects);

var localized string PinpointAccuracyFriendlyName;
var config float RECON_PINPOINTSHOT_COVER_REDUCTION_BONUS;

enum EEnemyCoverType
{
	eCoverType_High,
	eCoverType_Low,
	eCoverType_None
};

function int GetEnemyCoverValue()
{
	local ShotModifierInfo ModifierInfo;
	local int CoverValue;
	local int AngleReduction;

	CoverValue = 0;
	AngleReduction = 0;

	foreach m_ShotBreakdown.Modifiers(ModifierInfo)
	{
		if(ModifierInfo.ModType == eHit_Success)
		{
			if(ModifierInfo.Reason == class'XLocalizedData'.default.AngleToTargetCover)
			{
				AngleReduction = Abs(ModifierInfo.Value);
			}
			if(ModifierInfo.Reason == class'XLocalizedData'.default.TargetLowCover)
			{
				CoverValue = Abs(ModifierInfo.Value);
			}
			if(ModifierInfo.Reason == class'XLocalizedData'.default.TargetHighCover)
			{
				CoverValue = Abs(ModifierInfo.Value);
			}
		}
	}

	`log("[ReconOperator]-> GetEnemyCoverValue: Cover value is " $ CoverValue $ ", AngleReduction is " $ AngleReduction);
	return CoverValue - AngleReduction;
}



protected function FinalizeHitChance()
{
	local int CoverValue;

	CoverValue = GetEnemyCoverValue();
	if(CoverValue > 0)
	{		
		`log("[ReconOperator]-> FinalizeHitChance: Cover value is " $ CoverValue $ ", Reduction bonus is " $ RECON_PINPOINTSHOT_COVER_REDUCTION_BONUS);
		//`log("[ReconOperator]-> FinalizeHitChance: PinpointAccuracyFriendlyName is " $ PinpointAccuracyFriendlyName);
		AddModifier(CoverValue * RECON_PINPOINTSHOT_COVER_REDUCTION_BONUS, PinpointAccuracyFriendlyName);
	}

	super.FinalizeHitChance();
}

/*
protected function int GetHitChance(XComGameState_Ability kAbility, AvailableTarget kTarget, optional bool bDebugLog=false)
{
	local int CoverValue;
	
	super.GetHitChance(kAbility, kTarget, bDebugLog);
	CoverValue = GetEnemyCoverValue();

	`log("[ReconOperator]-> GetHitChance entered");

	if(CoverValue > 0)
	{		
		`log("[ReconOperator]-> GetHitChance: Cover value is " $ CoverValue $ ", Reduction bonus is " $ RECON_PINPOINTSHOT_COVER_REDUCTION_BONUS);
		`log("[ReconOperator]-> GetHitChance: PinpointAccuracyFriendlyName is " $ PinpointAccuracyFriendlyName);
		AddModifier(CoverValue * RECON_PINPOINTSHOT_COVER_REDUCTION_BONUS, PinpointAccuracyFriendlyName);
		FinalizeHitChance();
	}

	return m_ShotBreakdown.FinalHitChance;
}
*/