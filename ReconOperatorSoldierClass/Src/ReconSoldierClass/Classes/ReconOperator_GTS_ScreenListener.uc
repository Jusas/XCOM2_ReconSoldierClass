class ReconOperator_GTS_ScreenListener extends UIStrategyScreenListener;

event OnInit(UIScreen Screen)
{
    if (IsInStrategy())
    {
		AddSoldierUnlockTemplate('OfficerTrainingSchool', 'ReconAdrenalineUnlock');
	}
}

static function AddSoldierUnlockTemplate(name FacilityName, name UnlockGTSName)
{
	local X2FacilityTemplate FacilityTemplate;

	FacilityTemplate = X2FacilityTemplate(class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager().FindStrategyElementTemplate(FacilityName));
	if (FacilityTemplate == none)
		return;

	if (FacilityTemplate.SoldierUnlockTemplates.Find(UnlockGTSName) != INDEX_NONE)
		return;

	// Update the GTS template with the specified soldier unlock
	FacilityTemplate.SoldierUnlockTemplates.AddItem(UnlockGTSName);

	`LOG("[ReconOperator]-> GTS updated");
}
