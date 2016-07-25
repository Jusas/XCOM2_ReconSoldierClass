class ReconOperator_Item_Carbine extends X2Item config(GameData_WeaponData); 

var config array<int> RECON_CARBINE_CONVENTIONAL_RANGE;
var config array<int> RECON_CARBINE_MAGNETIC_RANGE;
var config array<int> RECON_CARBINE_BEAM_RANGE;

var config int RECON_CARBINE_MOBILITY_BONUS; // Mobility bonus given by the Carbine weapon

var config int RECON_CARBINE_CONVENTIONAL_AIM;
var config int RECON_CARBINE_CONVENTIONAL_CRITCHANCE;
var config int RECON_CARBINE_CONVENTIONAL_ICLIPSIZE;
var config int RECON_CARBINE_CONVENTIONAL_ISOUNDRANGE;
var config int RECON_CARBINE_CONVENTIONAL_IENVIRONMENTDAMAGE;
var config int RECON_CARBINE_CONVENTIONAL_ISUPPLIES;
var config int RECON_CARBINE_CONVENTIONAL_TRADINGPOSTVALUE;
var config int RECON_CARBINE_CONVENTIONAL_IPOINTS;

var config int RECON_CARBINE_MAGNETIC_AIM;
var config int RECON_CARBINE_MAGNETIC_CRITCHANCE;
var config int RECON_CARBINE_MAGNETIC_ICLIPSIZE;
var config int RECON_CARBINE_MAGNETIC_ISOUNDRANGE;
var config int RECON_CARBINE_MAGNETIC_IENVIRONMENTDAMAGE;
var config int RECON_CARBINE_MAGNETIC_ISUPPLIES;
var config int RECON_CARBINE_MAGNETIC_TRADINGPOSTVALUE;
var config int RECON_CARBINE_MAGNETIC_IPOINTS;

var config int RECON_CARBINE_BEAM_AIM;
var config int RECON_CARBINE_BEAM_CRITCHANCE;
var config int RECON_CARBINE_BEAM_ICLIPSIZE;
var config int RECON_CARBINE_BEAM_ISOUNDRANGE;
var config int RECON_CARBINE_BEAM_IENVIRONMENTDAMAGE;
var config int RECON_CARBINE_BEAM_ISUPPLIES;
var config int RECON_CARBINE_BEAM_TRADINGPOSTVALUE;
var config int RECON_CARBINE_BEAM_IPOINTS;

var config WeaponDamageValue RECON_CARBINE_CONVENTIONAL_BASEDAMAGE;
var config WeaponDamageValue RECON_CARBINE_MAGNETIC_BASEDAMAGE;
var config WeaponDamageValue RECON_CARBINE_BEAM_BASEDAMAGE;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Carbines;
	local X2ItemTemplateManager ItemTemplateManager;

	Carbines.AddItem(AddCarbineCV());
	Carbines.AddItem(AddCarbineMG());
	Carbines.AddItem(AddCarbineBM());


	//get access to item template manager to update existing upgrades
	ItemTemplateManager = class'X2ItemTemplateManager'.static.GetItemTemplateManager();

	if (ItemTemplateManager == none) 
	{
		`Redscreen("[ReconOperator]-> Item_Carbine.CreateTemplates: failed to retrieve ItemTemplateManager to configure upgrades");
		return Carbines;
	}

	SetWeaponSchematics(ItemTemplateManager);

	//add weapon to the DefaultUpgrades Templates so that upgrades work with new weapon
	//this doesn't make the upgrade available, it merely configures the art
	AddCritUpgrade(ItemTemplateManager, 'CritUpgrade_Bsc');
	AddCritUpgrade(ItemTemplateManager, 'CritUpgrade_Adv');
	AddCritUpgrade(ItemTemplateManager, 'CritUpgrade_Sup');

	AddAimBonusUpgrade(ItemTemplateManager, 'AimUpgrade_Bsc');
	AddAimBonusUpgrade(ItemTemplateManager, 'AimUpgrade_Adv');
	AddAimBonusUpgrade(ItemTemplateManager, 'AimUpgrade_Sup');

	AddClipSizeBonusUpgrade(ItemTemplateManager, 'ClipSizeUpgrade_Bsc');
	AddClipSizeBonusUpgrade(ItemTemplateManager, 'ClipSizeUpgrade_Adv');
	AddClipSizeBonusUpgrade(ItemTemplateManager, 'ClipSizeUpgrade_Sup');

	AddFreeFireBonusUpgrade(ItemTemplateManager, 'FreeFireUpgrade_Bsc');
	AddFreeFireBonusUpgrade(ItemTemplateManager, 'FreeFireUpgrade_Adv');
	AddFreeFireBonusUpgrade(ItemTemplateManager, 'FreeFireUpgrade_Sup');

	AddReloadUpgrade(ItemTemplateManager, 'ReloadUpgrade_Bsc');
	AddReloadUpgrade(ItemTemplateManager, 'ReloadUpgrade_Adv');
	AddReloadUpgrade(ItemTemplateManager, 'ReloadUpgrade_Sup');

	AddMissDamageUpgrade(ItemTemplateManager, 'MissDamageUpgrade_Bsc');
	AddMissDamageUpgrade(ItemTemplateManager, 'MissDamageUpgrade_Adv');
	AddMissDamageUpgrade(ItemTemplateManager, 'MissDamageUpgrade_Sup');

	AddFreeKillUpgrade(ItemTemplateManager, 'FreeKillUpgrade_Bsc');
	AddFreeKillUpgrade(ItemTemplateManager, 'FreeKillUpgrade_Adv');
	AddFreeKillUpgrade(ItemTemplateManager, 'FreeKillUpgrade_Sup');



	return Carbines;
}

// Piggybacking the rifle schematics.
static function SetWeaponSchematics(X2ItemTemplateManager ItemTemplateManager)
{
	local X2SchematicTemplate Template;

	Template = X2SchematicTemplate(ItemTemplateManager.FindItemTemplate('AssaultRifle_MG_Schematic'));
	if(Template == none) 
	{
		`Redscreen("[ReconOperator]-> Item_Carbine: Failed to find schematic template AssaultRifle_MG_Schematic");
		return;
	}

	Template.ItemsToUpgrade.AddItem('ReconCarbine_CV');
	
	Template = X2SchematicTemplate(ItemTemplateManager.FindItemTemplate('AssaultRifle_BM_Schematic'));
	if(Template == none) 
	{
		`Redscreen("[ReconOperator]-> Item_Carbine: Failed to find schematic template AssaultRifle_BM_Schematic");
		return;
	}	
	
	Template.ItemsToUpgrade.AddItem('ReconCarbine_MG');
	
}

static function X2DataTemplate AddCarbineCV()
{
	local X2WeaponTemplate Template;
	//local WeaponDamageValue Damage;
	//local int MinDamage;
	//local int MaxDamage;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'ReconCarbine_CV');

	Template.WeaponPanelImage = "_ConventionalRifle";
	Template.EquipSound = "Conventional_Weapon_Equip";

	Template.ItemCat = 'weapon';

	// Rifle category, we want to enable this weapon for all classes that can use a rifle.
	// We'll also want to piggyback the standard rifle research.
	
	Template.WeaponCat = 'rifle';
	Template.WeaponTech = 'conventional';
	Template.strImage = "img:///UILibrary_ReconOperatorWeapons.ConvReconCarbine.ConvReconCarbine_Base";
	Template.Tier = 0;

	Template.RangeAccuracy = class'ReconOperator_Item_Carbine'.default.RECON_CARBINE_CONVENTIONAL_RANGE;
	Template.BaseDamage = class'ReconOperator_Item_Carbine'.default.RECON_CARBINE_CONVENTIONAL_BASEDAMAGE;
	Template.Aim = class'ReconOperator_Item_Carbine'.default.RECON_CARBINE_CONVENTIONAL_AIM;
	Template.CritChance = class'ReconOperator_Item_Carbine'.default.RECON_CARBINE_CONVENTIONAL_CRITCHANCE;
	Template.iClipSize = class'ReconOperator_Item_Carbine'.default.RECON_CARBINE_CONVENTIONAL_ICLIPSIZE;
	Template.iSoundRange = class'ReconOperator_Item_Carbine'.default.RECON_CARBINE_CONVENTIONAL_ISOUNDRANGE;
	Template.iEnvironmentDamage = class'ReconOperator_Item_Carbine'.default.RECON_CARBINE_CONVENTIONAL_IENVIRONMENTDAMAGE;
	Template.NumUpgradeSlots = 1;
	Template.InventorySlot = eInvSlot_PrimaryWeapon;

	Template.Abilities.AddItem('StandardShot');	
	Template.Abilities.AddItem('Overwatch');	
	Template.Abilities.AddItem('OverwatchShot');
	Template.Abilities.AddItem('Reload');
	Template.Abilities.AddItem('HotLoadAmmo');
	Template.Abilities.AddItem('ReconCarbineStatBonus');

	Template.SetUIStatMarkup(class'XLocalizedData'.default.MobilityLabel, eStat_Mobility, class'ReconOperator_Item_Carbine'.default.RECON_CARBINE_MOBILITY_BONUS);

	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "WP_AssaultRifle_CV.WP_AssaultRifle_CV";

	Template.UIArmoryCameraPointTag = 'UIPawnLocation_WeaponUpgrade_AssaultRifle';
	Template.AddDefaultAttachment('Mag', "ConvAssaultRifle.Meshes.SM_ConvAssaultRifle_MagA", , "img:///UILibrary_ReconOperatorWeapons.ConvReconCarbine.ConvReconCarbine_MagA");
	Template.AddDefaultAttachment('Optic', "ConvAssaultRifle.Meshes.SM_ConvAssaultRifle_OpticA", , "img:///UILibrary_ReconOperatorWeapons.ConvReconCarbine.ConvReconCarbine_OpticA");
	Template.AddDefaultAttachment('Reargrip', "ConvAssaultRifle.Meshes.SM_ConvAssaultRifle_ReargripA", , "img:///UILibrary_ReconOperatorWeapons.ConvReconCarbine.ConvReconCarbine_ReargripA");
	Template.AddDefaultAttachment('Stock', "ConvAssaultRifle.Meshes.SM_ConvAssaultRifle_StockA", , "img:///UILibrary_ReconOperatorWeapons.ConvReconCarbine.ConvReconCarbine_StockA");
	Template.AddDefaultAttachment('Trigger', "ConvAssaultRifle.Meshes.SM_ConvAssaultRifle_TriggerA", , "img:///UILibrary_ReconOperatorWeapons.ConvReconCarbine.ConvReconCarbine_TriggerA");
	Template.AddDefaultAttachment('Light', "ConvAttachments.Meshes.SM_ConvFlashLight");

	Template.iPhysicsImpulse = 5;
	Template.StartingItem = true;
	Template.bInfiniteItem = true;
	Template.CanBeBuilt = false;	
	Template.UpgradeItem = 'ReconCarbine_MG';

	Template.fKnockbackDamageAmount = 5.0f;
	Template.fKnockbackDamageRadius = 0.0f;

	Template.DamageTypeTemplateName = 'Projectile_Conventional';

	return Template;
}

static function X2DataTemplate AddCarbineMG()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'ReconCarbine_MG');

	Template.WeaponPanelImage = "_MagneticRifle";
	Template.EquipSound = "Magnetic_Weapon_Equip";

	Template.ItemCat = 'weapon';

	// Rifle category, we want to enable this weapon for all classes that can use a rifle.
	// We'll also want to piggyback the standard rifle research.
	
	Template.WeaponCat = 'rifle';
	Template.WeaponTech = 'magnetic';
	Template.strImage = "img:///UILibrary_ReconOperatorWeapons.UI_ReconMagCarbine.ReconMagCarbine_Base";
	Template.Tier = 2;
	Template.CreatorTemplateName = 'AssaultRifle_MG_Schematic'; // piggybacking rifle research schematics
	Template.BaseItem = 'ReconCarbine_CV';

	Template.RangeAccuracy = class'ReconOperator_Item_Carbine'.default.RECON_CARBINE_MAGNETIC_RANGE;
	Template.BaseDamage = class'ReconOperator_Item_Carbine'.default.RECON_CARBINE_MAGNETIC_BASEDAMAGE;
	Template.Aim = class'ReconOperator_Item_Carbine'.default.RECON_CARBINE_MAGNETIC_AIM;
	Template.CritChance = class'ReconOperator_Item_Carbine'.default.RECON_CARBINE_MAGNETIC_CRITCHANCE;
	Template.iClipSize = class'ReconOperator_Item_Carbine'.default.RECON_CARBINE_MAGNETIC_ICLIPSIZE;
	Template.iSoundRange = class'ReconOperator_Item_Carbine'.default.RECON_CARBINE_MAGNETIC_ISOUNDRANGE;
	Template.iEnvironmentDamage = class'ReconOperator_Item_Carbine'.default.RECON_CARBINE_MAGNETIC_IENVIRONMENTDAMAGE;
	Template.NumUpgradeSlots = 2;
	Template.InventorySlot = eInvSlot_PrimaryWeapon;

	Template.Abilities.AddItem('StandardShot');	
	Template.Abilities.AddItem('Overwatch');	
	Template.Abilities.AddItem('OverwatchShot');
	Template.Abilities.AddItem('Reload');
	Template.Abilities.AddItem('HotLoadAmmo');
	Template.Abilities.AddItem('ReconCarbineStatBonus');

	Template.SetUIStatMarkup(class'XLocalizedData'.default.MobilityLabel, eStat_Mobility, class'ReconOperator_Item_Carbine'.default.RECON_CARBINE_MOBILITY_BONUS);

	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "WP_AssaultRifle_MG.WP_AssaultRifle_MG";

	Template.UIArmoryCameraPointTag = 'UIPawnLocation_WeaponUpgrade_AssaultRifle';
	Template.AddDefaultAttachment('Mag', "MagAssaultRifle.Meshes.SM_MagAssaultRifle_MagA", , "img:///UILibrary_ReconOperatorWeapons.UI_ReconMagCarbine.ReconMagCarbine_MagA");
	Template.AddDefaultAttachment('Suppressor', "MagAssaultRifle.Meshes.SM_MagAssaultRifle_SuppressorA", , "img:///UILibrary_ReconOperatorWeapons.UI_ReconMagCarbine.ReconMagCarbine_SupressorA");
	Template.AddDefaultAttachment('Reargrip', "MagAssaultRifle.Meshes.SM_MagAssaultRifle_ReargripA", , /* included with TriggerA */);
	Template.AddDefaultAttachment('Stock', "MagAssaultRifle.Meshes.SM_MagAssaultRifle_StockA", , "img:///UILibrary_ReconOperatorWeapons.UI_ReconMagCarbine.ReconMagCarbine_StockA");
	Template.AddDefaultAttachment('Trigger', "MagAssaultRifle.Meshes.SM_MagAssaultRifle_TriggerA", , "img:///UILibrary_ReconOperatorWeapons.UI_ReconMagCarbine.ReconMagCarbine_TriggerA");
	Template.AddDefaultAttachment('Light', "ConvAttachments.Meshes.SM_ConvFlashLight");

	Template.iPhysicsImpulse = 5;
	Template.StartingItem = false;
	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;	
	Template.UpgradeItem = 'ReconCarbine_BM';

	Template.fKnockbackDamageAmount = 5.0f;
	Template.fKnockbackDamageRadius = 0.0f;

	Template.DamageTypeTemplateName = 'Projectile_MagXCom';
	return Template;
}


static function X2DataTemplate AddCarbineBM()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'ReconCarbine_BM');

	Template.WeaponPanelImage = "_BeamRifle";
	Template.EquipSound = "Beam_Weapon_Equip";

	Template.ItemCat = 'weapon';

	// Rifle category, we want to enable this weapon for all classes that can use a rifle.
	// We'll also want to piggyback the standard rifle research.
	
	Template.WeaponCat = 'rifle';
	Template.WeaponTech = 'beam';
	Template.strImage = "img:///UILibrary_ReconOperatorWeapons.UI_ReconBeamCarbine.ReconBeamCarbine_Base";
	Template.Tier = 2;
	Template.CreatorTemplateName = 'AssaultRifle_BM_Schematic';
	Template.BaseItem = 'ReconCarbine_MG';

	Template.RangeAccuracy = class'ReconOperator_Item_Carbine'.default.RECON_CARBINE_BEAM_RANGE;
	Template.BaseDamage = class'ReconOperator_Item_Carbine'.default.RECON_CARBINE_BEAM_BASEDAMAGE;
	Template.Aim = class'ReconOperator_Item_Carbine'.default.RECON_CARBINE_BEAM_AIM;
	Template.CritChance = class'ReconOperator_Item_Carbine'.default.RECON_CARBINE_BEAM_CRITCHANCE;
	Template.iClipSize = class'ReconOperator_Item_Carbine'.default.RECON_CARBINE_BEAM_ICLIPSIZE;
	Template.iSoundRange = class'ReconOperator_Item_Carbine'.default.RECON_CARBINE_BEAM_ISOUNDRANGE;
	Template.iEnvironmentDamage = class'ReconOperator_Item_Carbine'.default.RECON_CARBINE_BEAM_IENVIRONMENTDAMAGE;
	Template.NumUpgradeSlots = 2;
	Template.InventorySlot = eInvSlot_PrimaryWeapon;

	Template.Abilities.AddItem('StandardShot');	
	Template.Abilities.AddItem('Overwatch');	
	Template.Abilities.AddItem('OverwatchShot');
	Template.Abilities.AddItem('Reload');
	Template.Abilities.AddItem('HotLoadAmmo');
	Template.Abilities.AddItem('ReconCarbineStatBonus');

	Template.SetUIStatMarkup(class'XLocalizedData'.default.MobilityLabel, eStat_Mobility, class'ReconOperator_Item_Carbine'.default.RECON_CARBINE_MOBILITY_BONUS);

	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "WP_AssaultRifle_BM.WP_AssaultRifle_BM";
	Template.UIArmoryCameraPointTag = 'UIPawnLocation_WeaponUpgrade_AssaultRifle';
	Template.AddDefaultAttachment('Mag', "BeamAssaultRifle.Meshes.SM_BeamAssaultRifle_MagA", , "img:///UILibrary_ReconOperatorWeapons.UI_ReconBeamCarbine.ReconBeamCarbine_MagA");
	Template.AddDefaultAttachment('Suppressor', "BeamAssaultRifle.Meshes.SM_BeamAssaultRifle_SuppressorA", , "img:///UILibrary_ReconOperatorWeapons.UI_ReconBeamCarbine.ReconBeamCarbine_SupressorA");
	Template.AddDefaultAttachment('Core', "BeamAssaultRifle.Meshes.SM_BeamAssaultRifle_CoreA", , "img:///UILibrary_ReconOperatorWeapons.UI_ReconBeamCarbine.ReconBeamCarbine_CoreA");
	Template.AddDefaultAttachment('HeatSink', "BeamAssaultRifle.Meshes.SM_BeamAssaultRifle_HeatSinkA", , "img:///UILibrary_ReconOperatorWeapons.UI_ReconBeamCarbine.ReconBeamCarbine_HeatsinkA");
	Template.AddDefaultAttachment('Light', "BeamAttachments.Meshes.BeamFlashLight");


	Template.iPhysicsImpulse = 5;
	Template.StartingItem = false;
	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;
	
	Template.DamageTypeTemplateName = 'Projectile_BeamXCom';
	return Template;
}






static function AddCritUpgrade(X2ItemTemplateManager ItemTemplateManager, Name TemplateName)
{
	local X2WeaponUpgradeTemplate Template;

	Template = X2WeaponUpgradeTemplate(ItemTemplateManager.FindItemTemplate(TemplateName));
	if(Template == none) 
	{
		`Redscreen("[ReconOperator]-> Item_Carbine: Failed to find upgrade template " $ string(TemplateName));
		return;
	}
	
	//Parameters are : 	AttachSocket, UIArmoryCameraPointTag, MeshName, ProjectileName, MatchWeaponTemplate, AttachToPawn, IconName, InventoryIconName, InventoryCategoryIcon, ValidateAttachmentFn  
	Template.AddUpgradeAttachment('Optic', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Optic', "ConvAssaultRifle.Meshes.SM_ConvAssaultRifle_OpticB", "", 'ReconCarbine_CV', , "img:///UILibrary_ReconOperatorWeapons.ConvReconCarbine.ConvReconCarbine_OpticB", "img:///UILibrary_StrategyImages.X2InventoryIcons.ConvAssault_OpticB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_scope");
	Template.AddUpgradeAttachment('Optic', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Optic', "MagAssaultRifle.Meshes.SM_MagAssaultRifle_OpticB", "", 'ReconCarbine_MG', , "img:///UILibrary_ReconOperatorWeapons.UI_ReconMagCarbine.ReconMagCarbine_OpticB", "img:///UILibrary_StrategyImages.X2InventoryIcons.MagAssaultRifle_OpticB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_scope");
	Template.AddUpgradeAttachment('Optic', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Optic', "BeamAssaultRifle.Meshes.SM_BeamAssaultRifle_OpticB", "", 'ReconCarbine_BM', , "img:///UILibrary_ReconOperatorWeapons.UI_ReconBeamCarbine.ReconBeamCarbine_OpticB", "img:///UILibrary_StrategyImages.X2InventoryIcons.BeamAssaultRifle_OpticA_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_scope");
}

static function AddAimBonusUpgrade(X2ItemTemplateManager ItemTemplateManager, Name TemplateName)
{
	local X2WeaponUpgradeTemplate Template;

	Template = X2WeaponUpgradeTemplate(ItemTemplateManager.FindItemTemplate(TemplateName));
	if(Template == none) 
	{
		`Redscreen("[ReconOperator]-> Item_Carbine: Failed to find upgrade template " $ string(TemplateName));
		return;
	}
	
	//Parameters are : 	AttachSocket, UIArmoryCameraPointTag, MeshName, ProjectileName, MatchWeaponTemplate, AttachToPawn, IconName, InventoryIconName, InventoryCategoryIcon, ValidateAttachmentFn
	Template.AddUpgradeAttachment('Optic', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Optic', "ConvAssaultRifle.Meshes.SM_ConvAssaultRifle_OpticC", "", 'ReconCarbine_CV', , "img:///UILibrary_ReconOperatorWeapons.ConvReconCarbine.ConvReconCarbine_OpticC", "img:///UILibrary_StrategyImages.X2InventoryIcons.ConvAssault_OpticC_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_scope");
	Template.AddUpgradeAttachment('Optic', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Optic', "MagAssaultRifle.Meshes.SM_MagAssaultRifle_OpticC", "", 'ReconCarbine_MG', , "img:///UILibrary_ReconOperatorWeapons.UI_ReconMagCarbine.ReconMagCarbine_OpticC", "img:///UILibrary_StrategyImages.X2InventoryIcons.MagAssaultRifle_OpticC_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_scope");
	Template.AddUpgradeAttachment('Optic', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Optic', "BeamAssaultRifle.Meshes.SM_BeamAssaultRifle_OpticC", "", 'ReconCarbine_BM', , "img:///UILibrary_ReconOperatorWeapons.UI_ReconBeamCarbine.ReconBeamCarbine_OpticB", "img:///UILibrary_StrategyImages.X2InventoryIcons.BeamAssaultRifle_OpticB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_scope");

}

static function AddClipSizeBonusUpgrade(X2ItemTemplateManager ItemTemplateManager, Name TemplateName)
{
	local X2WeaponUpgradeTemplate Template;

	Template = X2WeaponUpgradeTemplate(ItemTemplateManager.FindItemTemplate(TemplateName));
	if(Template == none) 
	{
		`Redscreen("[ReconOperator]-> Item_Carbine: Failed to find upgrade template " $ string(TemplateName));
		return;
	}

	//Parameters are : 	AttachSocket, UIArmoryCameraPointTag, MeshName, ProjectileName, MatchWeaponTemplate, AttachToPawn, IconName, InventoryIconName, InventoryCategoryIcon, ValidateAttachmentFn
	Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Mag', "ConvAssaultRifle.Meshes.SM_ConvAssaultRifle_MagB", "", 'ReconCarbine_CV', , "img:///UILibrary_ReconOperatorWeapons.ConvReconCarbine.ConvReconCarbine_MagB", "img:///UILibrary_StrategyImages.X2InventoryIcons.ConvAssault_MagB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip", class'X2Item_DefaultUpgrades'.static.NoReloadUpgradePresent);
	Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Mag', "MagAssaultRifle.Meshes.SM_MagAssaultRifle_MagB", "", 'ReconCarbine_MG', , "img:///UILibrary_ReconOperatorWeapons.UI_ReconMagCarbine.ReconMagCarbine_MagB", "img:///UILibrary_StrategyImages.X2InventoryIcons.MagAssaultRifle_MagB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip", class'X2Item_DefaultUpgrades'.static.NoReloadUpgradePresent);
	Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Mag', "BeamAssaultRifle.Meshes.SM_BeamAssaultRifle_MagB", "", 'ReconCarbine_BM', , "img:///UILibrary_ReconOperatorWeapons.UI_ReconBeamCarbine.ReconBeamCarbine_MagB", "img:///UILibrary_StrategyImages.X2InventoryIcons.BeamAssaultRifle_MagB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip");

}

static function AddFreeFireBonusUpgrade(X2ItemTemplateManager ItemTemplateManager, Name TemplateName)
{
	local X2WeaponUpgradeTemplate Template;

	Template = X2WeaponUpgradeTemplate(ItemTemplateManager.FindItemTemplate(TemplateName));
	if(Template == none) 
	{
		`Redscreen("[ReconOperator]-> Item_Carbine: Failed to find upgrade template " $ string(TemplateName));
		return;
	}
	// TODO : update placeholder AR references to SMG references
	//Parameters are : 	AttachSocket, UIArmoryCameraPointTag, MeshName, ProjectileName, MatchWeaponTemplate, AttachToPawn, IconName, InventoryIconName, InventoryCategoryIcon, ValidateAttachmentFn
	//Template.AddUpgradeAttachment('Reargrip', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Mag', "ConvAttachments.Meshes.SM_ConvReargripB", "", 'SMG_CV', , "img:///UILibrary_Common.ConvAssaultRifle.ConvAssault_ReargripA", "img:///UILibrary_StrategyImages.X2InventoryIcons.ConvAssault_ReargripB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_trigger");
	//Template.AddUpgradeAttachment('Reargrip', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Mag', "MagAttachments.Meshes.SM_MagReargripB", "", 'SMG_MG', , "img:///UILibrary_Common.UI_MagAssaultRifle.MagAssaultRifle_TriggerB", "img:///UILibrary_StrategyImages.X2InventoryIcons.MagAssaultRifle_TriggerB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_trigger");
	//Template.AddUpgradeAttachment('Core', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Optic', "BeamAssaultRifle.Meshes.SM_BeamAssaultRifle_CoreB", "", 'SMG_BM', , "img:///UILibrary_Common.UI_BeamAssaultRifle.BeamAssaultRifle_CoreB", "img:///UILibrary_StrategyImages.X2InventoryIcons.BeamAssaultRifle_CoreB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_trigger");
	//Template.AddUpgradeAttachment('Core_Teeth', '', "BeamAssaultRifle.Meshes.SM_BeamAssaultRifle_TeethA", "", 'SMG_BM', , "img:///UILibrary_Common.UI_BeamAssaultRifle.BeamAssaultRifle_Teeth", "img:///UILibrary_StrategyImages.X2InventoryIcons.BeamAssaultRifle_Teeth_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_trigger");

	//Template.AddUpgradeAttachment('Trigger', '', "ConvAttachments.Meshes.SM_ConvTriggerB", "", 'SMG_CV');
	//Template.AddUpgradeAttachment('Trigger', '', "MagAttachments.Meshes.SM_MagTriggerB", "", 'SMG_MG');

	// NEW FreeFire UPGRADE CONFIGURATION
	//Parameters are : 	AttachSocket, UIArmoryCameraPointTag, MeshName, ProjectileName, MatchWeaponTemplate, AttachToPawn, IconName, InventoryIconName, InventoryCategoryIcon, ValidateAttachmentFn
	Template.AddUpgradeAttachment('Trigger', '', "ConvAttachments.Meshes.SM_ConvTriggerB", "", 'ReconCarbine_CV', , "img:///UILibrary_ReconOperatorWeapons.ConvReconCarbine.ConvReconCarbine_TriggerA", "img:///UILibrary_StrategyImages.X2InventoryIcons.ConvAssault_ReargripB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_trigger"); // use conventional trigger attachment
	Template.AddUpgradeAttachment('Reargrip', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Mag', "MagAttachments.Meshes.SM_MagReargripB", "", 'ReconCarbine_MG', , "img:///UILibrary_ReconOperatorWeapons.UI_ReconMagCarbine.ReconMagCarbine_TriggerB", "img:///UILibrary_StrategyImages.X2InventoryIcons.MagAssaultRifle_TriggerB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_trigger");
	Template.AddUpgradeAttachment('Core', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Optic', "BeamAssaultRifle.Meshes.SM_BeamAssaultRifle_CoreB", "", 'ReconCarbine_BM', , "img:///UILibrary_ReconOperatorWeapons.UI_ReconBeamCarbine.ReconBeamCarbine_CoreB", "img:///UILibrary_StrategyImages.X2InventoryIcons.BeamAssaultRifle_CoreB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_trigger");
	Template.AddUpgradeAttachment('Core_Teeth', '', "BeamAssaultRifle.Meshes.SM_BeamAssaultRifle_TeethA", "", 'ReconCarbine_BM', , "img:///UILibrary_ReconOperatorWeapons.UI_ReconBeamCarbine.ReconBeamCarbine_TeethA", "img:///UILibrary_StrategyImages.X2InventoryIcons.BeamAssaultRifle_Teeth_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_trigger");

	Template.AddUpgradeAttachment('Trigger', '', "MagAttachments.Meshes.SM_MagTriggerB", "", 'ReconCarbine_MG');

} 

static function AddReloadUpgrade(X2ItemTemplateManager ItemTemplateManager, Name TemplateName)
{
	local X2WeaponUpgradeTemplate Template;

	Template = X2WeaponUpgradeTemplate(ItemTemplateManager.FindItemTemplate(TemplateName));
	if(Template == none) 
	{
		`Redscreen("[ReconOperator]-> Item_Carbine: Failed to find upgrade template " $ string(TemplateName));
		return;
	}
	// TODO : update placeholder AR references to SMG references
	//Parameters are : 	AttachSocket, UIArmoryCameraPointTag, MeshName, ProjectileName, MatchWeaponTemplate, AttachToPawn, IconName, InventoryIconName, InventoryCategoryIcon, ValidateAttachmentFn
	Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Mag', "ConvAssaultRifle.Meshes.SM_ConvAssaultRifle_MagC", "", 'ReconCarbine_CV', , "img:///UILibrary_ReconOperatorWeapons.ConvReconCarbine.ConvReconCarbine_MagC", "img:///UILibrary_StrategyImages.X2InventoryIcons.ConvAssault_MagC_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip", class'X2Item_DefaultUpgrades'.static.NoClipSizeUpgradePresent);
	Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Mag', "ConvAssaultRifle.Meshes.SM_ConvAssaultRifle_MagD", "", 'ReconCarbine_CV', , "img:///UILibrary_ReconOperatorWeapons.ConvReconCarbine.ConvReconCarbine_MagD", "img:///UILibrary_StrategyImages.X2InventoryIcons.MagAssaultRifle_MagD_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip", class'X2Item_DefaultUpgrades'.static.ClipSizeUpgradePresent);
	Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Mag', "MagAssaultRifle.Meshes.SM_MagAssaultRifle_MagC", "", 'ReconCarbine_MG', , "img:///UILibrary_ReconOperatorWeapons.UI_ReconMagCarbine.ReconMagCarbine_MagC", "img:///UILibrary_StrategyImages.X2InventoryIcons.MagAssaultRifle_MagC_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip", class'X2Item_DefaultUpgrades'.static.NoClipSizeUpgradePresent);
	Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Mag', "MagAssaultRifle.Meshes.SM_MagAssaultRifle_MagD", "", 'ReconCarbine_MG', , "img:///UILibrary_ReconOperatorWeapons.UI_ReconMagCarbine.ReconMagCarbine_MagD", "img:///UILibrary_StrategyImages.X2InventoryIcons.MagAssaultRifle_MagD_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip", class'X2Item_DefaultUpgrades'.static.ClipSizeUpgradePresent);
	Template.AddUpgradeAttachment('AutoLoader', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Mag', "BeamAssaultRifle.Meshes.SM_BeamAssaultRifle_MagC", "", 'ReconCarbine_BM', , "img:///UILibrary_ReconOperatorWeapons.UI_ReconBeamCarbine.ReconBeamCarbine_AutoLoader", "img:///UILibrary_StrategyImages.X2InventoryIcons.BeamAssaultRifle_AutoLoader_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip");

	// NEW Reload UPGRADE CONFIGURATION  
	//Parameters are : 	AttachSocket, UIArmoryCameraPointTag, MeshName, ProjectileName, MatchWeaponTemplate, AttachToPawn, IconName, InventoryIconName, InventoryCategoryIcon, ValidateAttachmentFn 
	//Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Optic', "LWSMG_CV.Meshes.SK_LWConvSMG_MagC", "", 'SMG_CV', , "img:///UILibrary_SMG.conventional.LWConvSMG_MagC", "img:///UILibrary_SMG.conventional.LWConvSMG_MagC_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip", class'X2Item_DefaultUpgrades'.static.NoClipSizeUpgradePresent);
	//Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Optic', "LWSMG_CV.Meshes.SK_LWConvSMG_MagD", "", 'SMG_CV', , "img:///UILibrary_SMG.conventional.LWConvSMG_MagD", "img:///UILibrary_SMG.conventional.LWConvSMG_MagD_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip", class'X2Item_DefaultUpgrades'.static.ClipSizeUpgradePresent);
	//Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Mag', "MagAssaultRifle.Meshes.SM_MagAssaultRifle_MagC", "", 'SMG_MG', , "img:///UILibrary_SMG.magnetic.LWMagSMG_MagC", "img:///UILibrary_StrategyImages.X2InventoryIcons.MagAssaultRifle_MagC_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip", class'X2Item_DefaultUpgrades'.static.NoClipSizeUpgradePresent);
	//Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Mag', "MagAssaultRifle.Meshes.SM_MagAssaultRifle_MagD", "", 'SMG_MG', , "img:///UILibrary_SMG.magnetic.LWMagSMG_MagD", "img:///UILibrary_StrategyImages.X2InventoryIcons.MagAssaultRifle_MagD_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip", class'X2Item_DefaultUpgrades'.static.ClipSizeUpgradePresent);
	//Template.AddUpgradeAttachment('AutoLoader', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Mag', "BeamAssaultRifle.Meshes.SM_BeamAssaultRifle_MagC", "", 'SMG_BM', , "img:///UILibrary_SMG.Beam.LWBeamSMG_MagC", "img:///UILibrary_StrategyImages.X2InventoryIcons.BeamAssaultRifle_AutoLoader_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip");
}

static function AddMissDamageUpgrade(X2ItemTemplateManager ItemTemplateManager, Name TemplateName)
{
	local X2WeaponUpgradeTemplate Template;

	Template = X2WeaponUpgradeTemplate(ItemTemplateManager.FindItemTemplate(TemplateName));
	if(Template == none) 
	{
		`Redscreen("[ReconOperator]-> Item_Carbine: Failed to find upgrade template " $ string(TemplateName));
		return;
	}
	// TODO : update placeholder AR references to SMG references
	//Parameters are : 	AttachSocket, UIArmoryCameraPointTag, MeshName, ProjectileName, MatchWeaponTemplate, AttachToPawn, IconName, InventoryIconName, InventoryCategoryIcon, ValidateAttachmentFn
	//Template.AddUpgradeAttachment('Stock', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Stock', "ConvAssaultRifle.Meshes.SM_ConvAssaultRifle_StockB", "", 'SMG_CV', , "img:///UILibrary_Common.ConvAssaultRifle.ConvAssault_StockB", "img:///UILibrary_StrategyImages.X2InventoryIcons.ConvAssault_StockB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_stock");
	//Template.AddUpgradeAttachment('Stock', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Stock', "MagAssaultRifle.Meshes.SM_MagAssaultRifle_StockB", "", 'SMG_MG', , "img:///UILibrary_Common.UI_MagAssaultRifle.MagAssaultRifle_StockB", "img:///UILibrary_StrategyImages.X2InventoryIcons.MagAssaultRifle_StockB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_stock");
	//Template.AddUpgradeAttachment('HeatSink', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Stock', "BeamAssaultRifle.Meshes.SM_BeamAssaultRifle_HeatsinkB", "", 'SMG_BM', , "img:///UILibrary_Common.UI_BeamAssaultRifle.BeamAssaultRifle_HeatsinkB", "img:///UILibrary_StrategyImages.X2InventoryIcons.BeamAssaultRifle_HeatsinkB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_stock");
	
	//Template.AddUpgradeAttachment('Crossbar', '', "ConvAttachments.Meshes.SM_ConvCrossbar", "", 'SMG_CV', , "img:///UILibrary_Common.ConvAssaultRifle.ConvAssault_CrossbarA", , , class'X2Item_DefaultUpgrades'.static.FreeFireUpgradePresent);
	//Template.AddUpgradeAttachment('Crossbar', '', "MagAttachments.Meshes.SM_MagCrossbar", "", 'SMG_MG', , "img:///UILibrary_Common.UI_MagAssaultRifle.MagAssaultRifle_Crossbar", , , class'X2Item_DefaultUpgrades'.static.FreeFireUpgradePresent);

	// NEW MissDamage UPGRADE CONFIGURATION
	//Parameters are : 	AttachSocket, UIArmoryCameraPointTag, MeshName, ProjectileName, MatchWeaponTemplate, AttachToPawn, IconName, InventoryIconName, InventoryCategoryIcon, ValidateAttachmentFn  
	//Template.AddUpgradeAttachment('Stock', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Stock', "LWSMG_CV.Meshes.SM_LWConvSMG_StockB", "", 'SMG_CV', , "img:///UILibrary_SMG.conventional.LWConvSMG_StockB", "img:///UILibrary_SMG.conventional.LWConvSMG_StockB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_stock");
	Template.AddUpgradeAttachment('Stock', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Stock', "ConvAssaultRifle.Meshes.SM_ConvAssaultRifle_StockB", "", 'ReconCarbine_CV', , "img:///UILibrary_ReconOperatorWeapons.ConvReconCarbine.ConvReconCarbine_StockB", "img:///UILibrary_StrategyImages.X2InventoryIcons.ConvAssault_StockB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_stock");
	Template.AddUpgradeAttachment('Stock', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Stock', "MagAssaultRifle.Meshes.SM_MagAssaultRifle_StockB", "", 'ReconCarbine_MG', , "img:///UILibrary_ReconOperatorWeapons.UI_ReconMagCarbine.ReconMagCarbine_StockB", "img:///UILibrary_StrategyImages.X2InventoryIcons.MagAssaultRifle_StockB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_stock");
	Template.AddUpgradeAttachment('HeatSink', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Optic', "BeamAssaultRifle.Meshes.SM_BeamAssaultRifle_HeatsinkB", "", 'ReconCarbine_BM', , "img:///UILibrary_ReconOperatorWeapons.UI_ReconBeamCarbine.ReconBeamCarbine_HeatsinkB", "img:///UILibrary_StrategyImages.X2InventoryIcons.BeamSniper_HeatsinkB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_stock");
	
	//Template.AddUpgradeAttachment('Crossbar', '', "ConvAttachments.Meshes.SM_ConvCrossbar", "", 'SMG_CV', , "img:///UILibrary_Common.ConvAssaultRifle.ConvAssault_CrossbarA", , , class'X2Item_DefaultUpgrades'.static.FreeFireUpgradePresent);
	Template.AddUpgradeAttachment('Crossbar', '', "MagAttachments.Meshes.SM_MagCrossbar", "", 'ReconCarbine_MG', , "img:///UILibrary_ReconOperatorWeapons.ConvReconCarbine.ConvReconCarbine_Crossbar", , , class'X2Item_DefaultUpgrades'.static.FreeFireUpgradePresent);
} 

static function AddFreeKillUpgrade(X2ItemTemplateManager ItemTemplateManager, Name TemplateName)
{
	local X2WeaponUpgradeTemplate Template;

	Template = X2WeaponUpgradeTemplate(ItemTemplateManager.FindItemTemplate(TemplateName));
	if(Template == none) 
	{
		`Redscreen("[ReconOperator]-> Item_Carbine: Failed to find upgrade template " $ string(TemplateName));
		return;
	}
	// TODO : update placeholder AR references to SMG references
	//Parameters are : 	AttachSocket, UIArmoryCameraPointTag, MeshName, ProjectileName, MatchWeaponTemplate, AttachToPawn, IconName, InventoryIconName, InventoryCategoryIcon, ValidateAttachmentFn
	//Template.AddUpgradeAttachment('Suppressor', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Suppressor', "ConvAssaultRifle.Meshes.SM_ConvAssaultRifle_SuppressorB", "", 'SMG_CV', , "img:///UILibrary_Common.ConvAssaultRifle.ConvAssault_SuppressorB", "img:///UILibrary_StrategyImages.X2InventoryIcons.ConvAssault_SuppressorB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_barrel");
	//Template.AddUpgradeAttachment('Suppressor', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Suppressor', "MagAssaultRifle.Meshes.SM_MagAssaultRifle_SuppressorB", "", 'SMG_MG', , "img:///UILibrary_Common.UI_MagAssaultRifle.MagAssaultRifle_SupressorB", "img:///UILibrary_StrategyImages.X2InventoryIcons.MagAssaultRifle_SupressorB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_barrel");
	//Template.AddUpgradeAttachment('Suppressor', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Suppressor', "BeamAssaultRifle.Meshes.SM_BeamAssaultRifle_SuppressorB", "", 'SMG_BM', , "img:///UILibrary_Common.UI_BeamAssaultRifle.BeamAssaultRifle_SupressorB", "img:///UILibrary_StrategyImages.X2InventoryIcons.BeamAssaultRifle_SupressorB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_barrel");

	// NEW FreeKill UPGRADE CONFIGURATION
	//Parameters are : 	AttachSocket, UIArmoryCameraPointTag, MeshName, ProjectileName, MatchWeaponTemplate, AttachToPawn, IconName, InventoryIconName, InventoryCategoryIcon, ValidateAttachmentFn
	Template.AddUpgradeAttachment('Suppressor', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Suppressor', "ConvAssaultRifle.Meshes.SM_ConvAssaultRifle_SuppressorB", "", 'ReconCarbine_CV', , "img:///UILibrary_ReconOperatorWeapons.ConvReconCarbine.ConvReconCarbine_SuppressorB", "img:///UILibrary_StrategyImages.X2InventoryIcons.ConvAssault_SuppressorB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_barrel");
	Template.AddUpgradeAttachment('Suppressor', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Suppressor', "MagAssaultRifle.Meshes.SM_MagAssaultRifle_SuppressorB", "", 'ReconCarbine_MG', , "img:///UILibrary_ReconOperatorWeapons.UI_ReconMagCarbine.ReconMagCarbine_SupressorB", "img:///UILibrary_StrategyImages.X2InventoryIcons.MagShotgun_SuppressorB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_barrel");
	Template.AddUpgradeAttachment('Suppressor', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Suppressor', "BeamAssaultRifle.Meshes.SM_BeamAssaultRifle_SuppressorB", "", 'ReconCarbine_BM', , "img:///UILibrary_ReconOperatorWeapons.UI_ReconBeamCarbine.ReconBeamCarbine_SupressorB", "img:///UILibrary_StrategyImages.X2InventoryIcons.BeamAssaultRifle_SupressorB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_barrel");  
} 





defaultproperties
{
	bShouldCreateDifficultyVariants = true
}
