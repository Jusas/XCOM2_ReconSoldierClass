class ReconOperator_Item_MarksmanRifle extends X2Item config(GameData_WeaponData); 

var config int RECON_MARKSMAN_SQUADSIGHT_PENALTY;
var config int RECON_MARKSMAN_MOVE_PENALTY;

var config array<int> RECON_MARKSMAN_CONVENTIONAL_RANGE;
var config array<int> RECON_MARKSMAN_MAGNETIC_RANGE;
var config array<int> RECON_MARKSMAN_BEAM_RANGE;

var config int RECON_MARKSMAN_CONVENTIONAL_AIM;
var config int RECON_MARKSMAN_CONVENTIONAL_CRITCHANCE;
var config int RECON_MARKSMAN_CONVENTIONAL_ICLIPSIZE;
var config int RECON_MARKSMAN_CONVENTIONAL_ISOUNDRANGE;
var config int RECON_MARKSMAN_CONVENTIONAL_IENVIRONMENTDAMAGE;
var config int RECON_MARKSMAN_CONVENTIONAL_ISUPPLIES;
var config int RECON_MARKSMAN_CONVENTIONAL_TRADINGPOSTVALUE;
var config int RECON_MARKSMAN_CONVENTIONAL_IPOINTS;

var config int RECON_MARKSMAN_MAGNETIC_AIM;
var config int RECON_MARKSMAN_MAGNETIC_CRITCHANCE;
var config int RECON_MARKSMAN_MAGNETIC_ICLIPSIZE;
var config int RECON_MARKSMAN_MAGNETIC_ISOUNDRANGE;
var config int RECON_MARKSMAN_MAGNETIC_IENVIRONMENTDAMAGE;
var config int RECON_MARKSMAN_MAGNETIC_ISUPPLIES;
var config int RECON_MARKSMAN_MAGNETIC_TRADINGPOSTVALUE;
var config int RECON_MARKSMAN_MAGNETIC_IPOINTS;

var config int RECON_MARKSMAN_BEAM_AIM;
var config int RECON_MARKSMAN_BEAM_CRITCHANCE;
var config int RECON_MARKSMAN_BEAM_ICLIPSIZE;
var config int RECON_MARKSMAN_BEAM_ISOUNDRANGE;
var config int RECON_MARKSMAN_BEAM_IENVIRONMENTDAMAGE;
var config int RECON_MARKSMAN_BEAM_ISUPPLIES;
var config int RECON_MARKSMAN_BEAM_TRADINGPOSTVALUE;
var config int RECON_MARKSMAN_BEAM_IPOINTS;

var config WeaponDamageValue RECON_MARKSMAN_CONVENTIONAL_BASEDAMAGE;
var config WeaponDamageValue RECON_MARKSMAN_MAGNETIC_BASEDAMAGE;
var config WeaponDamageValue RECON_MARKSMAN_BEAM_BASEDAMAGE;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Rifles;
	local X2ItemTemplateManager ItemTemplateManager;

	Rifles.AddItem(AddMarksmanRifleCV());
	Rifles.AddItem(AddMarksmanRifleMG());
	Rifles.AddItem(AddMarksmanRifleBM());

	//get access to item template manager to update existing upgrades
	ItemTemplateManager = class'X2ItemTemplateManager'.static.GetItemTemplateManager();

	if (ItemTemplateManager == none) 
	{
		`Redscreen("[ReconOperator]-> Item_MarksmanRifle.CreateTemplates: failed to retrieve ItemTemplateManager to configure upgrades");
		return Rifles;
	}

	SetWeaponSchematics(ItemTemplateManager);

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

	return Rifles;
}


// Piggybacking the sniper rifle schematics.
// The weapons are in the 'rifle' category but take their upgrades from sniper weapons
// (having advanced optics and all, makes more sense).
static function SetWeaponSchematics(X2ItemTemplateManager ItemTemplateManager)
{
	local X2SchematicTemplate Template;

	Template = X2SchematicTemplate(ItemTemplateManager.FindItemTemplate('SniperRifle_MG_Schematic'));
	if(Template == none) 
	{
		`Redscreen("[ReconOperator]-> Item_MarksmanRifle: Failed to find schematic template SniperRifle_MG_Schematic");
		return;
	}

	Template.ItemsToUpgrade.AddItem('ReconMarksmanRifle_CV');
	
	Template = X2SchematicTemplate(ItemTemplateManager.FindItemTemplate('SniperRifle_BM_Schematic'));
	if(Template == none) 
	{
		`Redscreen("[ReconOperator]-> Item_MarksmanRifle: Failed to find schematic template SniperRifle_BM_Schematic");
		return;
	}	
	
	Template.ItemsToUpgrade.AddItem('ReconMarksmanRifle_MG');
	
}


static function X2DataTemplate AddMarksmanRifleCV()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'ReconMarksmanRifle_CV');

	Template.WeaponPanelImage = "_ConventionalSniperRifle";
	Template.EquipSound = "Conventional_Weapon_Equip";

	Template.ItemCat = 'weapon';

	// Rifle category, we want to enable this weapon for all classes that can use a rifle.
	// We'll also want to piggyback the standard rifle research.
	
	Template.WeaponCat = 'rifle';
	Template.WeaponTech = 'conventional';
	Template.strImage = "img:///UILibrary_Common.ConvSniper.ConvSniper_Base";
	Template.Tier = 0;

	Template.RangeAccuracy = class'ReconOperator_Item_MarksmanRifle'.default.RECON_MARKSMAN_CONVENTIONAL_RANGE;
	Template.BaseDamage = class'ReconOperator_Item_MarksmanRifle'.default.RECON_MARKSMAN_CONVENTIONAL_BASEDAMAGE;
	Template.Aim = class'ReconOperator_Item_MarksmanRifle'.default.RECON_MARKSMAN_CONVENTIONAL_AIM;
	Template.CritChance = class'ReconOperator_Item_MarksmanRifle'.default.RECON_MARKSMAN_CONVENTIONAL_CRITCHANCE;
	Template.iClipSize = class'ReconOperator_Item_MarksmanRifle'.default.RECON_MARKSMAN_CONVENTIONAL_ICLIPSIZE;
	Template.iSoundRange = class'ReconOperator_Item_MarksmanRifle'.default.RECON_MARKSMAN_CONVENTIONAL_ISOUNDRANGE;
	Template.iEnvironmentDamage = class'ReconOperator_Item_MarksmanRifle'.default.RECON_MARKSMAN_CONVENTIONAL_IENVIRONMENTDAMAGE;
	//Template.iRange = class'ReconOperator_Item_MarksmanRifle'.default.RECON_MARKSMAN_MAX_RANGE;
	Template.NumUpgradeSlots = 1;
	Template.InventorySlot = eInvSlot_PrimaryWeapon;

	Template.Abilities.AddItem('StandardShot');	
	Template.Abilities.AddItem('Overwatch');	
	Template.Abilities.AddItem('OverwatchShot');
	Template.Abilities.AddItem('Reload');
	Template.Abilities.AddItem('HotLoadAmmo');
	Template.Abilities.AddItem('ReconMarksmanRifleBonus');


	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "WP_SniperRifle_CV.WP_SniperRifle_CV";
	Template.UIArmoryCameraPointTag = 'UIPawnLocation_WeaponUpgrade_Sniper';
	Template.AddDefaultAttachment('Mag', "ConvSniper.Meshes.SM_ConvSniper_MagA", , "img:///UILibrary_Common.ConvSniper.ConvSniper_MagA");
	Template.AddDefaultAttachment('Optic', "ConvSniper.Meshes.SM_ConvSniper_OpticA", , "img:///UILibrary_Common.ConvSniper.ConvSniper_OpticA");
	Template.AddDefaultAttachment('Reargrip', "ConvSniper.Meshes.SM_ConvSniper_ReargripA" /*REARGRIP INCLUDED IN TRIGGER IMAGE*/);
	Template.AddDefaultAttachment('Stock', "ConvSniper.Meshes.SM_ConvSniper_StockA", , "img:///UILibrary_Common.ConvSniper.ConvSniper_StockA");
	Template.AddDefaultAttachment('Suppressor', "ConvSniper.Meshes.SM_ConvSniper_SuppressorA", , "img:///UILibrary_Common.ConvSniper.ConvSniper_SuppressorA");
	Template.AddDefaultAttachment('Trigger', "ConvSniper.Meshes.SM_ConvSniper_TriggerA", , "img:///UILibrary_Common.ConvSniper.ConvSniper_TriggerA");
	Template.AddDefaultAttachment('Light', "ConvAttachments.Meshes.SM_ConvFlashLight");

	Template.iPhysicsImpulse = 5;
	Template.StartingItem = true;
	Template.bInfiniteItem = true;
	Template.CanBeBuilt = false;	
	Template.UpgradeItem = 'ReconMarksmanRifle_MG';
	
	Template.fKnockbackDamageAmount = 5.0f;
	Template.fKnockbackDamageRadius = 0.0f;

	Template.DamageTypeTemplateName = 'Projectile_Conventional';

	return Template;
}

static function X2DataTemplate AddMarksmanRifleMG()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'ReconMarksmanRifle_MG');

	Template.WeaponPanelImage = "_MagneticSniperRifle";
	Template.EquipSound = "Magnetic_Weapon_Equip";

	Template.ItemCat = 'weapon';

	// Rifle category, we want to enable this weapon for all classes that can use a rifle.
	// We'll also want to piggyback the standard rifle research.
	
	Template.WeaponCat = 'rifle';
	Template.WeaponTech = 'magnetic';
	Template.strImage = "img:///UILibrary_Common.UI_MagSniper.MagSniper_Base";
	Template.Tier = 2;
	Template.CreatorTemplateName = 'AssaultRifle_MG_Schematic'; // piggybacking rifle research schematics
	Template.BaseItem = 'ReconMarksmanRifle_CV';
	//Template.Requirements.RequiredTechs.AddItem('MagnetizedWeapons');

	Template.RangeAccuracy = class'ReconOperator_Item_MarksmanRifle'.default.RECON_MARKSMAN_MAGNETIC_RANGE;
	Template.BaseDamage = class'ReconOperator_Item_MarksmanRifle'.default.RECON_MARKSMAN_MAGNETIC_BASEDAMAGE;
	Template.Aim = class'ReconOperator_Item_MarksmanRifle'.default.RECON_MARKSMAN_MAGNETIC_AIM;
	Template.CritChance = class'ReconOperator_Item_MarksmanRifle'.default.RECON_MARKSMAN_MAGNETIC_CRITCHANCE;
	Template.iClipSize = class'ReconOperator_Item_MarksmanRifle'.default.RECON_MARKSMAN_MAGNETIC_ICLIPSIZE;
	Template.iSoundRange = class'ReconOperator_Item_MarksmanRifle'.default.RECON_MARKSMAN_MAGNETIC_ISOUNDRANGE;
	Template.iEnvironmentDamage = class'ReconOperator_Item_MarksmanRifle'.default.RECON_MARKSMAN_MAGNETIC_IENVIRONMENTDAMAGE;
	//Template.iRange = class'ReconOperator_Item_MarksmanRifle'.default.RECON_MARKSMAN_MAX_RANGE;
	Template.NumUpgradeSlots = 2;
	Template.InventorySlot = eInvSlot_PrimaryWeapon;

	Template.Abilities.AddItem('StandardShot');	
	Template.Abilities.AddItem('Overwatch');	
	Template.Abilities.AddItem('OverwatchShot');
	Template.Abilities.AddItem('Reload');
	Template.Abilities.AddItem('HotLoadAmmo');
	Template.Abilities.AddItem('ReconMarksmanRifleBonus');

	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "WP_SniperRifle_MG.WP_SniperRifle_MG";
	Template.UIArmoryCameraPointTag = 'UIPawnLocation_WeaponUpgrade_Sniper';
	Template.AddDefaultAttachment('Mag', "MagSniper.Meshes.SM_MagSniper_MagA", , "img:///UILibrary_Common.UI_MagSniper.MagSniper_MagA");
	Template.AddDefaultAttachment('Optic', "MagSniper.Meshes.SM_MagSniper_OpticA", , "img:///UILibrary_Common.UI_MagSniper.MagSniper_OpticA");
	Template.AddDefaultAttachment('Reargrip',   "MagSniper.Meshes.SM_MagSniper_ReargripA" /* image included in TriggerA */);
	Template.AddDefaultAttachment('Stock', "MagSniper.Meshes.SM_MagSniper_StockA", , "img:///UILibrary_Common.UI_MagSniper.MagSniper_StockA");
	Template.AddDefaultAttachment('Suppressor', "MagSniper.Meshes.SM_MagSniper_SuppressorA", , "img:///UILibrary_Common.UI_MagSniper.MagSniper_SuppressorA");
	Template.AddDefaultAttachment('Trigger', "MagSniper.Meshes.SM_MagSniper_TriggerA", , "img:///UILibrary_Common.UI_MagSniper.MagSniper_TriggerA");
	Template.AddDefaultAttachment('Light', "ConvAttachments.Meshes.SM_ConvFlashLight");

	Template.iPhysicsImpulse = 5;
	Template.StartingItem = false;
	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;	
	Template.UpgradeItem = 'ReconMarksmanRifle_BM';

	Template.fKnockbackDamageAmount = 5.0f;
	Template.fKnockbackDamageRadius = 0.0f;

	Template.DamageTypeTemplateName = 'Projectile_MagXCom';
	return Template;
}


static function X2DataTemplate AddMarksmanRifleBM()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'ReconMarksmanRifle_BM');

	Template.WeaponPanelImage = "_BeamSniperRifle";
	Template.EquipSound = "Beam_Weapon_Equip";

	Template.ItemCat = 'weapon';

	// Rifle category, we want to enable this weapon for all classes that can use a rifle.
	// We'll also want to piggyback the standard rifle research.
	
	Template.WeaponCat = 'rifle';
	Template.WeaponTech = 'beam';
	Template.strImage = "img:///UILibrary_Common.UI_BeamSniper.BeamSniper_Base";
	Template.Tier = 2;
	Template.CreatorTemplateName = 'AssaultRifle_BM_Schematic';
	Template.BaseItem = 'MarksmanRifle_MG';

	Template.RangeAccuracy = class'ReconOperator_Item_MarksmanRifle'.default.RECON_MARKSMAN_BEAM_RANGE;
	Template.BaseDamage = class'ReconOperator_Item_MarksmanRifle'.default.RECON_MARKSMAN_BEAM_BASEDAMAGE;
	Template.Aim = class'ReconOperator_Item_MarksmanRifle'.default.RECON_MARKSMAN_BEAM_AIM;
	Template.CritChance = class'ReconOperator_Item_MarksmanRifle'.default.RECON_MARKSMAN_BEAM_CRITCHANCE;
	Template.iClipSize = class'ReconOperator_Item_MarksmanRifle'.default.RECON_MARKSMAN_BEAM_ICLIPSIZE;
	Template.iSoundRange = class'ReconOperator_Item_MarksmanRifle'.default.RECON_MARKSMAN_BEAM_ISOUNDRANGE;
	Template.iEnvironmentDamage = class'ReconOperator_Item_MarksmanRifle'.default.RECON_MARKSMAN_BEAM_IENVIRONMENTDAMAGE;
	//Template.iRange = class'ReconOperator_Item_MarksmanRifle'.default.RECON_MARKSMAN_MAX_RANGE;
	Template.NumUpgradeSlots = 2;
	Template.InventorySlot = eInvSlot_PrimaryWeapon;

	Template.Abilities.AddItem('StandardShot');	
	Template.Abilities.AddItem('Overwatch');	
	Template.Abilities.AddItem('OverwatchShot');
	Template.Abilities.AddItem('Reload');
	Template.Abilities.AddItem('HotLoadAmmo');
	Template.Abilities.AddItem('ReconMarksmanRifleBonus');

	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "WP_SniperRifle_BM.WP_SniperRifle_BM";
	Template.UIArmoryCameraPointTag = 'UIPawnLocation_WeaponUpgrade_Sniper';
	Template.AddDefaultAttachment('Optic', "BeamSniper.Meshes.SM_BeamSniper_OpticA", , "img:///UILibrary_Common.UI_BeamSniper.BeamSniper_OpticA");
	Template.AddDefaultAttachment('Mag', "BeamSniper.Meshes.SM_BeamSniper_MagA", , "img:///UILibrary_Common.UI_BeamSniper.BeamSniper_MagA");
	Template.AddDefaultAttachment('Suppressor', "BeamSniper.Meshes.SM_BeamSniper_SuppressorA", , "img:///UILibrary_Common.UI_BeamSniper.BeamSniper_SupressorA");
	Template.AddDefaultAttachment('Core', "BeamSniper.Meshes.SM_BeamSniper_CoreA", , "img:///UILibrary_Common.UI_BeamSniper.BeamSniper_CoreA");
	Template.AddDefaultAttachment('HeatSink', "BeamSniper.Meshes.SM_BeamSniper_HeatSinkA", , "img:///UILibrary_Common.UI_BeamSniper.BeamSniper_HeatsinkA");
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
		`Redscreen("[ReconOperator]-> Item_MarksmanRifle: Failed to find upgrade template " $ string(TemplateName));
		return;
	}
	Template.AddUpgradeAttachment('Optic', 'UIPawnLocation_WeaponUpgrade_Sniper_Optic', "ConvSniper.Meshes.SM_ConvSniper_OpticB", "", 'ReconMarksmanRifle_CV', , "img:///UILibrary_Common.ConvSniper.ConvSniper_OpticB", "img:///UILibrary_StrategyImages.X2InventoryIcons.ConvSniper_OpticB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_scope");
	Template.AddUpgradeAttachment('Optic', 'UIPawnLocation_WeaponUpgrade_Sniper_Optic', "MagSniper.Meshes.SM_MagSniper_OpticB", "", 'ReconMarksmanRifle_MG', , "img:///UILibrary_Common.UI_MagSniper.MagSniper_OpticB", "img:///UILibrary_StrategyImages.X2InventoryIcons.MagSniper_OpticB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_scope");
	Template.AddUpgradeAttachment('Optic', 'UIPawnLocation_WeaponUpgrade_Sniper_Optic', "BeamSniper.Meshes.SM_BeamSniper_OpticB", "", 'ReconMarksmanRifle_BM', , "img:///UILibrary_Common.UI_BeamSniper.BeamSniper_OpticB", "img:///UILibrary_StrategyImages.X2InventoryIcons.BeamSniper_OpticB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_scope");

}


static function AddAimBonusUpgrade(X2ItemTemplateManager ItemTemplateManager, Name TemplateName)
{
	local X2WeaponUpgradeTemplate Template;

	Template = X2WeaponUpgradeTemplate(ItemTemplateManager.FindItemTemplate(TemplateName));
	if(Template == none) 
	{
		`Redscreen("[ReconOperator]-> Item_MarksmanRifle: Failed to find upgrade template " $ string(TemplateName));
		return;
	}

	Template.AddUpgradeAttachment('Optic', 'UIPawnLocation_WeaponUpgrade_Sniper_Optic', "ConvSniper.Meshes.SM_ConvSniper_OpticC", "", 'ReconMarksmanRifle_CV', , "img:///UILibrary_Common.ConvSniper.ConvSniper_OpticC", "img:///UILibrary_StrategyImages.X2InventoryIcons.ConvSniper_OpticC_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_scope");
	Template.AddUpgradeAttachment('Optic', 'UIPawnLocation_WeaponUpgrade_Sniper_Optic', "MagSniper.Meshes.SM_MagSniper_OpticC", "", 'ReconMarksmanRifle_MG', , "img:///UILibrary_Common.UI_MagSniper.MagSniper_OpticC", "img:///UILibrary_StrategyImages.X2InventoryIcons.MagSniper_OpticC_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_scope");
	Template.AddUpgradeAttachment('Optic', 'UIPawnLocation_WeaponUpgrade_Sniper_Optic', "BeamSniper.Meshes.SM_BeamSniper_OpticC", "", 'ReconMarksmanRifle_BM', , "img:///UILibrary_Common.UI_BeamSniper.BeamSniper_OpticC", "img:///UILibrary_StrategyImages.X2InventoryIcons.BeamSniper_OpticC_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_scope");

}



static function AddClipSizeBonusUpgrade(X2ItemTemplateManager ItemTemplateManager, Name TemplateName)
{
	local X2WeaponUpgradeTemplate Template;

	Template = X2WeaponUpgradeTemplate(ItemTemplateManager.FindItemTemplate(TemplateName));
	if(Template == none) 
	{
		`Redscreen("[ReconOperator]-> Item_MarksmanRifle: Failed to find upgrade template " $ string(TemplateName));
		return;
	}

	Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_Sniper_Mag', "ConvSniper.Meshes.SM_ConvSniper_MagB", "", 'ReconMarksmanRifle_CV', , "img:///UILibrary_Common.ConvSniper.ConvSniper_MagB", "img:///UILibrary_StrategyImages.X2InventoryIcons.ConvSniper_MagB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip", class'X2Item_DefaultUpgrades'.static.NoReloadUpgradePresent);
	Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_Sniper_Mag', "MagSniper.Meshes.SM_MagSniper_MagB", "", 'ReconMarksmanRifle_MG', , "img:///UILibrary_Common.UI_MagSniper.MagSniper_MagB", "img:///UILibrary_StrategyImages.X2InventoryIcons.MagSniper_MagB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip", class'X2Item_DefaultUpgrades'.static.NoReloadUpgradePresent);
	Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_Sniper_Mag', "BeamSniper.Meshes.SM_BeamSniper_MagB", "", 'ReconMarksmanRifle_BM', , "img:///UILibrary_Common.UI_BeamSniper.BeamSniper_MagB", "img:///UILibrary_StrategyImages.X2InventoryIcons.BeamSniper_MagB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip");

}

static function AddFreeFireBonusUpgrade(X2ItemTemplateManager ItemTemplateManager, Name TemplateName)
{
	local X2WeaponUpgradeTemplate Template;

	Template = X2WeaponUpgradeTemplate(ItemTemplateManager.FindItemTemplate(TemplateName));
	if(Template == none) 
	{
		`Redscreen("[ReconOperator]-> Item_MarksmanRifle: Failed to find upgrade template " $ string(TemplateName));
		return;
	}
	

	Template.AddUpgradeAttachment('Reargrip', 'UIPawnLocation_WeaponUpgrade_Sniper_Mag', "ConvAttachments.Meshes.SM_ConvReargripB", "", 'ReconMarksmanRifle_CV', , "img:///UILibrary_Common.ConvSniper.ConvSniper_TriggerB", "img:///UILibrary_StrategyImages.X2InventoryIcons.ConvSniper_TriggerB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_trigger");
	Template.AddUpgradeAttachment('Reargrip', 'UIPawnLocation_WeaponUpgrade_Sniper_Mag', "MagSniper.Meshes.SM_MagSniper_ReargripB", "", 'ReconMarksmanRifle_MG', , "img:///UILibrary_Common.UI_MagSniper.MagSniper_TriggerB", "img:///UILibrary_StrategyImages.X2InventoryIcons.MagSniper_TriggerB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_trigger");
	Template.AddUpgradeAttachment('Core', 'UIPawnLocation_WeaponUpgrade_Sniper_Optic', "BeamSniper.Meshes.SM_BeamSniper_CoreB", "", 'ReconMarksmanRifle_BM', , "img:///UILibrary_Common.UI_BeamSniper.BeamSniper_CoreB", "img:///UILibrary_StrategyImages.X2InventoryIcons.BeamSniper_CoreB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_trigger");
	Template.AddUpgradeAttachment('Core_Teeth', '', "BeamSniper.Meshes.SM_BeamSniper_TeethA", "", 'ReconMarksmanRifle_BM', , "img:///UILibrary_Common.UI_BeamSniper.BeamSniper_Teeth", "img:///UILibrary_StrategyImages.X2InventoryIcons.BeamSniper_Teeth_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_trigger");

	Template.AddUpgradeAttachment('Trigger', '', "ConvAttachments.Meshes.SM_ConvTriggerB", "", 'ReconMarksmanRifle_CV');
	Template.AddUpgradeAttachment('Trigger', '', "MagAttachments.Meshes.SM_MagTriggerB", "", 'ReconMarksmanRifle_MG');

} 

static function AddReloadUpgrade(X2ItemTemplateManager ItemTemplateManager, Name TemplateName)
{
	local X2WeaponUpgradeTemplate Template;

	Template = X2WeaponUpgradeTemplate(ItemTemplateManager.FindItemTemplate(TemplateName));
	if(Template == none) 
	{
		`Redscreen("[ReconOperator]-> Item_MarksmanRifle: Failed to find upgrade template " $ string(TemplateName));
		return;
	}
	
	Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_Sniper_Mag', "ConvSniper.Meshes.SM_ConvSniper_MagC", "", 'ReconMarksmanRifle_CV', , "img:///UILibrary_Common.ConvSniper.ConvSniper_MagC", "img:///UILibrary_StrategyImages.X2InventoryIcons.ConvSniper_MagC_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip", class'X2Item_DefaultUpgrades'.static.NoClipSizeUpgradePresent);
	Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_Sniper_Mag', "ConvSniper.Meshes.SM_ConvSniper_MagD", "", 'ReconMarksmanRifle_CV', , "img:///UILibrary_Common.ConvSniper.ConvSniper_MagD", "img:///UILibrary_StrategyImages.X2InventoryIcons.ConvSniper_MagD_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip", class'X2Item_DefaultUpgrades'.static.ClipSizeUpgradePresent);
	Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_Sniper_Mag', "MagSniper.Meshes.SM_MagSniper_MagC", "", 'ReconMarksmanRifle_MG', , "img:///UILibrary_Common.UI_MagSniper.MagSniper_MagC", "img:///UILibrary_StrategyImages.X2InventoryIcons.MagSniper_MagC_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip", class'X2Item_DefaultUpgrades'.static.NoClipSizeUpgradePresent);
	Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_Sniper_Mag', "MagSniper.Meshes.SM_MagSniper_MagD", "", 'ReconMarksmanRifle_MG', , "img:///UILibrary_Common.UI_MagSniper.MagSniper_MagD", "img:///UILibrary_StrategyImages.X2InventoryIcons.MagSniper_MagD_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip", class'X2Item_DefaultUpgrades'.static.ClipSizeUpgradePresent);
	Template.AddUpgradeAttachment('AutoLoader', 'UIPawnLocation_WeaponUpgrade_Sniper_Mag', "BeamSniper.Meshes.SM_BeamSniper_MagC", "", 'ReconMarksmanRifle_BM', , "img:///UILibrary_Common.UI_BeamSniper.BeamSniper_AutoLoader", "img:///UILibrary_StrategyImages.X2InventoryIcons.BeamSniper_AutoLoader_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip");

}


static function AddMissDamageUpgrade(X2ItemTemplateManager ItemTemplateManager, Name TemplateName)
{
	local X2WeaponUpgradeTemplate Template;

	Template = X2WeaponUpgradeTemplate(ItemTemplateManager.FindItemTemplate(TemplateName));
	if(Template == none) 
	{
		`Redscreen("[ReconOperator]-> Item_MarksmanRifle: Failed to find upgrade template " $ string(TemplateName));
		return;
	}

	Template.AddUpgradeAttachment('Stock', 'UIPawnLocation_WeaponUpgrade_Sniper_Stock', "ConvSniper.Meshes.SM_ConvSniper_StockB", "", 'ReconMarksmanRifle_CV', , "img:///UILibrary_Common.ConvSniper.ConvSniper_StockB", "img:///UILibrary_StrategyImages.X2InventoryIcons.ConvSniper_StockB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_stock");
	Template.AddUpgradeAttachment('Stock', 'UIPawnLocation_WeaponUpgrade_Sniper_Stock', "MagSniper.Meshes.SM_MagSniper_StockB", "", 'ReconMarksmanRifle_MG', , "img:///UILibrary_Common.UI_MagSniper.MagSniper_StockB", "img:///UILibrary_StrategyImages.X2InventoryIcons.MagSniper_StockB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_stock");
	Template.AddUpgradeAttachment('HeatSink', 'UIPawnLocation_WeaponUpgrade_Sniper_Stock', "BeamSniper.Meshes.SM_BeamSniper_HeatsinkB", "", 'ReconMarksmanRifle_BM', , "img:///UILibrary_Common.UI_BeamSniper.BeamSniper_HeatsinkB", "img:///UILibrary_StrategyImages.X2InventoryIcons.BeamSniper_HeatsinkB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_stock");

	Template.AddUpgradeAttachment('Crossbar', '', "ConvAttachments.Meshes.SM_ConvCrossbar", "", 'ReconMarksmanRifle_CV', , "img:///UILibrary_Common.ConvAssaultRifle.ConvAssault_CrossbarA", , , class'X2Item_DefaultUpgrades'.static.FreeFireUpgradePresent);
	Template.AddUpgradeAttachment('Crossbar', '', "MagAttachments.Meshes.SM_MagCrossbar", "", 'ReconMarksmanRifle_MG', , "img:///UILibrary_Common.UI_MagSniper.MagSniper_Crossbar", , , class'X2Item_DefaultUpgrades'.static.FreeFireUpgradePresent);

} 


static function AddFreeKillUpgrade(X2ItemTemplateManager ItemTemplateManager, Name TemplateName)
{
	local X2WeaponUpgradeTemplate Template;

	Template = X2WeaponUpgradeTemplate(ItemTemplateManager.FindItemTemplate(TemplateName));
	if(Template == none) 
	{
		`Redscreen("[ReconOperator]-> Item_MarksmanRifle: Failed to find upgrade template " $ string(TemplateName));
		return;
	}


	Template.AddUpgradeAttachment('Suppressor', 'UIPawnLocation_WeaponUpgrade_Sniper_Suppressor', "ConvSniper.Meshes.SM_ConvSniper_SuppressorB", "", 'ReconMarksmanRifle_CV', , "img:///UILibrary_Common.ConvSniper.ConvSniper_SuppressorB", "img:///UILibrary_StrategyImages.X2InventoryIcons.ConvSniper_SuppressorB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_barrel");
	Template.AddUpgradeAttachment('Suppressor', 'UIPawnLocation_WeaponUpgrade_Sniper_Suppressor', "MagSniper.Meshes.SM_MagSniper_SuppressorB", "", 'ReconMarksmanRifle_MG', , "img:///UILibrary_Common.UI_MagSniper.MagSniper_SuppressorB", "img:///UILibrary_StrategyImages.X2InventoryIcons.MagSniper_SuppressorB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_barrel");
	Template.AddUpgradeAttachment('Suppressor', 'UIPawnLocation_WeaponUpgrade_Sniper_Suppressor', "BeamSniper.Meshes.SM_BeamSniper_SuppressorB", "", 'ReconMarksmanRifle_BM', , "img:///UILibrary_Common.UI_BeamSniper.BeamSniper_SupressorB", "img:///UILibrary_StrategyImages.X2InventoryIcons.BeamSniper_SupressorB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_barrel");

} 








defaultproperties
{
	bShouldCreateDifficultyVariants = true
}
