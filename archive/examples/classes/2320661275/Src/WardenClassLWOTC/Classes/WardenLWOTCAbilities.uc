class WardenLWOTCAbilities extends X2Ability;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(WardenRelocate());
	Templates.AddItem(WardenSpacialSurfer());

	return Templates;
}

static function X2AbilityTemplate WardenRelocate()
{

	local X2AbilityTemplate										Template;

	Template = PurePassive('WardenRelocate', "img:///UILibrary_MZChimeraIcons.Ability_Relocate",, 'eAbilitySource_Perk');
	Template.AdditionalAbilities.AddItem('MZTransposition');

		return Template;
}

static function X2AbilityTemplate WardenSpacialSurfer()
{

	local X2AbilityTemplate										Template;

	Template = PurePassive('WardenSpacialSurfer', "img:///UILibrary_PerkIcons.UIPerk_codex_teleport",, 'eAbilitySource_Perk');
	Template.AdditionalAbilities.AddItem('MZTeleport');

		return Template;
}