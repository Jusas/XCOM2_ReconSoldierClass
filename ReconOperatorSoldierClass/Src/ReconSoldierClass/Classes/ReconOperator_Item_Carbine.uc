class ReconOperator_Item_Carbine extends X2Item config(GameData_WeaponData); 

var config array<int> RECON_CARBINE_CONVENTIONAL_RANGE;
var config array<int> RECON_CARBINE_MAGNETIC_RANGE;
var config array<int> RECON_CARBINE_BEAM_RANGE;

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

	Carbines.AddItem(AddCarbineCV());
	Carbines.AddItem(AddCarbineMG());
	Carbines.AddItem(AddCarbineBM());

	return Carbines;
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
	Template.strImage = "img:///UILibrary_Common.ConvAssaultRifle.ConvAssault_Base";
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

	//Damage = class'ReconOperator_AbilitySet'.default.RECON_CARBINE_CONVENTIONAL_BASEDAMAGE;
	//MinDamage = Damage.Damage - Damage.Spread;
	//MaxDamage = Damage.Damage + Damage.Spread;
	Template.SetUIStatMarkup(class'XLocalizedData'.default.MobilityLabel, eStat_Mobility, class'ReconOperator_AbilitySet'.default.RECON_CARBINE_MOBILITY_BONUS);
	//Template.SetUIStatMarkup(class'XLocalizedData'.default.DamageLabel, eStat_Mobility, class'ReconOperator_AbilitySet'.default.RECON_CARBINE_MOBILITY_BONUS);

	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "WP_AssaultRifle_CV.WP_AssaultRifle_CV";

	Template.UIArmoryCameraPointTag = 'UIPawnLocation_WeaponUpgrade_AssaultRifle';
	Template.AddDefaultAttachment('Mag', "ConvAssaultRifle.Meshes.SM_ConvAssaultRifle_MagA", , "img:///UILibrary_Common.ConvAssaultRifle.ConvAssault_MagA");
	Template.AddDefaultAttachment('Optic', "ConvAssaultRifle.Meshes.SM_ConvAssaultRifle_OpticA", , "img:///UILibrary_Common.ConvAssaultRifle.ConvAssault_OpticA");
	Template.AddDefaultAttachment('Reargrip', "ConvAssaultRifle.Meshes.SM_ConvAssaultRifle_ReargripA", , "img:///UILibrary_Common.ConvAssaultRifle.ConvAssault_ReargripA");
	Template.AddDefaultAttachment('Stock', "ConvAssaultRifle.Meshes.SM_ConvAssaultRifle_StockA", , "img:///UILibrary_Common.ConvAssaultRifle.ConvAssault_StockA");
	Template.AddDefaultAttachment('Trigger', "ConvAssaultRifle.Meshes.SM_ConvAssaultRifle_TriggerA", , "img:///UILibrary_Common.ConvAssaultRifle.ConvAssault_TriggerA");
	Template.AddDefaultAttachment('Light', "ConvAttachments.Meshes.SM_ConvFlashLight", , "img:///UILibrary_Common.ConvAssaultRifle.ConvAssault_LightA");

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
	Template.strImage = "img:///UILibrary_Common.UI_MagAssaultRifle.MagAssaultRifle_Base";
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

	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "WP_AssaultRifle_MG.WP_AssaultRifle_MG";

	Template.UIArmoryCameraPointTag = 'UIPawnLocation_WeaponUpgrade_AssaultRifle';
	Template.AddDefaultAttachment('Mag', "MagAssaultRifle.Meshes.SM_MagAssaultRifle_MagA", , "img:///UILibrary_Common.UI_MagAssaultRifle.MagAssaultRifle_MagA");
	Template.AddDefaultAttachment('Suppressor', "MagAssaultRifle.Meshes.SM_MagAssaultRifle_SuppressorA", , "img:///UILibrary_Common.UI_MagAssaultRifle.MagAssaultRifle_SupressorA");
	Template.AddDefaultAttachment('Reargrip', "MagAssaultRifle.Meshes.SM_MagAssaultRifle_ReargripA", , /* included with TriggerA */);
	Template.AddDefaultAttachment('Stock', "MagAssaultRifle.Meshes.SM_MagAssaultRifle_StockA", , "img:///UILibrary_Common.UI_MagAssaultRifle.MagAssaultRifle_StockA");
	Template.AddDefaultAttachment('Trigger', "MagAssaultRifle.Meshes.SM_MagAssaultRifle_TriggerA", , "img:///UILibrary_Common.UI_MagAssaultRifle.MagAssaultRifle_TriggerA");
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
	Template.strImage = "img:///UILibrary_Common.UI_BeamAssaultRifle.BeamAssaultRifle_Base";
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

	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "WP_AssaultRifle_MG.WP_AssaultRifle_MG";

	Template.UIArmoryCameraPointTag = 'UIPawnLocation_WeaponUpgrade_AssaultRifle';
	Template.AddDefaultAttachment('Mag', "MagAssaultRifle.Meshes.SM_MagAssaultRifle_MagA", , "img:///UILibrary_Common.UI_MagAssaultRifle.MagAssaultRifle_MagA");
	Template.AddDefaultAttachment('Suppressor', "MagAssaultRifle.Meshes.SM_MagAssaultRifle_SuppressorA", , "img:///UILibrary_Common.UI_MagAssaultRifle.MagAssaultRifle_SupressorA");
	Template.AddDefaultAttachment('Reargrip', "MagAssaultRifle.Meshes.SM_MagAssaultRifle_ReargripA", , /* included with TriggerA */);
	Template.AddDefaultAttachment('Stock', "MagAssaultRifle.Meshes.SM_MagAssaultRifle_StockA", , "img:///UILibrary_Common.UI_MagAssaultRifle.MagAssaultRifle_StockA");
	Template.AddDefaultAttachment('Trigger', "MagAssaultRifle.Meshes.SM_MagAssaultRifle_TriggerA", , "img:///UILibrary_Common.UI_MagAssaultRifle.MagAssaultRifle_TriggerA");
	Template.AddDefaultAttachment('Light', "ConvAttachments.Meshes.SM_ConvFlashLight");

	Template.iPhysicsImpulse = 5;
	Template.StartingItem = false;
	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;
	
	Template.DamageTypeTemplateName = 'Projectile_BeamXCom';
	return Template;
}

defaultproperties
{
	bShouldCreateDifficultyVariants = true
}
