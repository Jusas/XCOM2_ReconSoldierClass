class X2DownloadableContentInfo_ReconSoldierClass extends X2DownloadableContentInfo;

var array<name> ReconWeaponTemplateNames;

static event OnPostTemplatesCreated()
{
	local X2AbilityTemplateManager AbilityTemplateMgr;
	local X2AbilityTemplate LWTemplate;

	`Log("[ReconOperator]-> OnPostTemplatesCreated");
	AbilityTemplateMgr = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
	LWTemplate = AbilityTemplateMgr.FindAbilityTemplate('Suppression_LW');
	if(LWTemplate != none)
	{
		`Log("[ReconOperator]-> LW PerkPack seems to be installed");
	}
	else 
	{
		`Log("[ReconOperator]-> LW PerkPack does NOT seem to be installed");
	}
	
}

static event OnLoadedSavedGameToStrategy()
{
	local XComGameState NewGameState;
	local XComGameStateHistory History;
	local XComGameState_HeadquartersXCom OldXComHQ;
	local XComGameState_HeadquartersXCom XComHQ;
	local X2ItemTemplate LWItemTemplate;
	local array<name> WeaponNames;
	local name WeaponName;
	local bool UpdatedWeapons;
	

	local X2AbilityTemplateManager AbilityTemplateMgr;
	local X2AbilityTemplate LWTemplate;


	UpdatedWeapons = false;

	History = `XCOMHISTORY;
	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Updating HQ Storage to add new Recon class weapons");
	OldXComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
	XComHQ = XComGameState_HeadquartersXCom(NewGameState.CreateStateObject(class'XComGameState_HeadquartersXCom', OldXComHQ.ObjectID));
	NewGameState.AddStateObject(XComHQ);

	`Log("[ReconOperator]-> OnLoadedSavedGameToStrategy");

	`Log("[ReconOperator]-> Updating weapons that came with the mod to the saved game XCOMHQ");

	WeaponNames = default.ReconWeaponTemplateNames;
	foreach WeaponNames(WeaponName)
	{
		if(UpdateWeaponToInventory(WeaponName, OldXComHQ, XComHQ, NewGameState, History))
		{
			UpdatedWeapons = true;
		}
	}

	if(UpdatedWeapons)
	{
		History.AddGameStateToHistory(NewGameState);
	}
	else
	{
		History.CleanupPendingGameState(NewGameState);
	}

	// Check if LWPerkPack is installed. If true, add additional skills to the recon soldier class template.
	// Not exactly a foolproof check, just trying to see if one of the LW ability templates can be found.


	AbilityTemplateMgr = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
	LWTemplate = AbilityTemplateMgr.FindAbilityTemplate('Suppression_LW');
	if(LWTemplate != none)
	{
		`Log("[ReconOperator]-> LW PerkPack seems to be installed");
	}
	else 
	{
		`Log("[ReconOperator]-> LW PerkPack does NOT seem to be installed");
	}
	
	`Log("[ReconOperator]-> OnLoadedSavedGame complete");

}

static function bool UpdateWeaponToInventory(name WeaponName, XComGameState_HeadquartersXCom OldXComHQ, XComGameState_HeadquartersXCom XComHQ, XComGameState GameState, XComGameStateHistory History)
{
	local X2ItemTemplateManager ItemTemplateMgr;
	local X2ItemTemplate ItemTemplate;
	local XComGameState_Item NewItemState;
	local array<X2SchematicTemplate> HQSchematics;
	local X2SchematicTemplate Schematic;
	local name CreatorSchematicName;
	local bool DidAddWeaponToInventory;

	local StateObjectReference TechRef;
	local XComGameState_Tech TechState;

	local array<StateObjectReference> NewResearch;
	local array<StateObjectReference> NewProvingGroundProjects;
	local array<X2ItemTemplate> NewItems;
	local array<X2FacilityTemplate> NewFacilities;
	local array<X2FacilityUpgradeTemplate> NewUpgrades;
	local array<StateObjectReference> NewInstantResearch;
	local X2ItemTemplate TechItemTemplate;




	DidAddWeaponToInventory = false;

	HQSchematics = OldXComHQ.GetPurchasedSchematics();
	ItemTemplateMgr = class'X2ItemTemplateManager'.static.GetItemTemplateManager();
	ItemTemplate = ItemTemplateMgr.FindItemTemplate(WeaponName);

	if(ItemTemplate != none)
	{		
		if (!OldXComHQ.HasItem(ItemTemplate))
		{
			`Log("[ReconOperator]-> Weapon " $ WeaponName $ " not in XCOMHQ inventory, checking if we should add it");
			// No need to check for existing schematics on tier 0 weapons.
			if(ItemTemplate.Tier == 0)
			{
				`Log("[ReconOperator]-> Adding tier 0 missing weapon " $ WeaponName $ " to inventory");
				NewItemState = ItemTemplate.CreateInstanceFromTemplate(GameState);
				GameState.AddStateObject(NewItemState);
				XComHQ.AddItemToHQInventory(NewItemState);
				DidAddWeaponToInventory = true;
			}
			else
			{
				// Higher tier, must check if the schematic exists in the inventory.
				CreatorSchematicName = ItemTemplate.CreatorTemplateName;
				foreach HQSchematics(Schematic)
				{
					`Log("[ReconOperator]-> Schematic found: " $ Schematic.DataName);
					if(Schematic.DataName == CreatorSchematicName)
					{
						`Log("[ReconOperator]-> Required schematic " $ CreatorSchematicName $ " for weapon " $ WeaponName $ " found from inventory, adding the weapon also to inventory");
						NewItemState = ItemTemplate.CreateInstanceFromTemplate(GameState);
						GameState.AddStateObject(NewItemState);
						XComHQ.AddItemToHQInventory(NewItemState);
						DidAddWeaponToInventory = true;				
						break;
					}
				}
				/*if(!DidAddWeaponToInventory)
				{
					// Well, let's try techs then.
					foreach OldXComHQ.TechsResearched(TechRef)
					{
						TechState = XComGameState_Tech(History.GetGameStateForObjectID(TechRef.ObjectID));						
						`Log("[ReconOperator]-> Iterating tech " $ TechState.GetMyTemplateName());

						TechState.GetMyTemplate().GetUnlocks(NewResearch, NewProvingGroundProjects, NewItems, NewFacilities, NewUpgrades, NewInstantResearch);
						foreach NewItems(TechItemTemplate)
						{
							`Log("[ReconOperator]-> Iterating tech unlock " $ TechItemTemplate.DataName);
							TechItemTemplate.
							if(ItemTemplate.DataName == TechItemTemplate.DataName)
							{
								//`Log("[ReconOperator]-> Researched tech " $ TechState.GetMyTemplateName() $ " contains the weapon template " $ WeaponName $ " in its unlock items list");
								`Log("[ReconOperator]-> Match for " $ WeaponName $ " in unlock items list");
								NewItemState = ItemTemplate.CreateInstanceFromTemplate(GameState);
								GameState.AddStateObject(NewItemState);
								XComHQ.AddItemToHQInventory(NewItemState);
								DidAddWeaponToInventory = true;				
								break;
							}
						}
						
						
					}*/

				if(!DidAddWeaponToInventory)
					`Log("[ReconOperator]-> The weapon " $ WeaponName $ " does not have the required schematic " $ CreatorSchematicName $ " in the XCOMHQ inventory, skipping it");
				
				
			}
			
		} else {
			`Log("[ReconOperator]-> Weapon " $ WeaponName $ " already in inventory, skipping");
			DidAddWeaponToInventory = false;
		}
	}

	return DidAddWeaponToInventory;
}

static event InstallNewCampaign(XComGameState StartState)
{}

defaultproperties
{	
	ReconWeaponTemplateNames(0)="ReconCarbine_CV"
	ReconWeaponTemplateNames(1)="ReconCarbine_MG"
	ReconWeaponTemplateNames(2)="ReconCarbine_BM"
	ReconWeaponTemplateNames(3)="ReconMarksmanRifle_CV"
	ReconWeaponTemplateNames(4)="ReconMarksmanRifle_MG"
	ReconWeaponTemplateNames(5)="ReconMarksmanRifle_BM"
}