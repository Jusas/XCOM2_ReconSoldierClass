class ReconOperator_Item_MarksmanRifle extends X2Item config(GameData_WeaponData); 

var config int RECON_MARKSMAN_MAX_RANGE;
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

	Rifles.AddItem(AddMarksmanRifleCV());
	Rifles.AddItem(AddMarksmanRifleMG());
	Rifles.AddItem(AddMarksmanRifleBM());

	return Rifles;
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
	Template.Abilities.AddItem('MarksmanRifleStatBonus');


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
	Template.Abilities.AddItem('MarksmanRifleStatBonus');

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
	Template.Abilities.AddItem('MarksmanRifleStatBonus');

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

defaultproperties
{
	bShouldCreateDifficultyVariants = true
}
