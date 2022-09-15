class MZ_Cooldown_ModifiedByBonusAbility extends X2AbilityCooldown;

struct BonusCooldown
{
	var name AbilityName;
	var int Bonus;
};

var array<BonusCooldown> BonusCooldowns;

function AddBonusCooldown(name AbilityName, int Bonus)
{
	local BonusCooldown BonusCone;

	BonusCone.AbilityName = AbilityName;
	BonusCone.Bonus = Bonus;
	BonusCooldowns.AddItem(BonusCone);
}

simulated function int GetNumTurns(XComGameState_Ability kAbility, XComGameState_BaseObject AffectState, XComGameState_Item AffectWeapon, XComGameState NewGameState)
{
	local BonusCooldown CheckBonusCooldown;
	local int CDValue;

	CDValue = iNumTurns;

	foreach BonusCooldowns(CheckBonusCooldown)
	{
		if (XComGameState_Unit(AffectState).HasSoldierAbility(CheckBonusCooldown.AbilityName))
		{
			CDValue += CheckBonusCooldown.Bonus;
		}
	}

	return CDValue;
}

DefaultProperties
{
	iNumTurns = 2;
}