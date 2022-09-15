class MZ_Effect_FondFarewell extends X2Effect_Persistent;

function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState)
{
	local X2AbilityTemplate			MyTemplate;
	local XComGameState_Item		WeaponState;
	local int						i;
	local X2AbilityCost_Ammo		AmmoCost;
	local MZ_Cost_AmmoPerTarget		MZAmmoCost;

	WeaponState = AbilityState.GetSourceWeapon();
	if ( WeaponState == none || WeaponState.HasInfiniteAmmo() || Attacker.GetPrimaryWeapon().ObjectID != WeaponState.ObjectID) { return 0; }

	MyTemplate = AbilityState.GetMyTemplate();

	if ( NewGameState != none && IsLastTarget(AppliedData))
	{
		for (i = 0; i < MyTemplate.AbilityCosts.Length; ++i)
		{
			AmmoCost = X2AbilityCost_Ammo( MyTemplate.AbilityCosts[i] );
			if ( AmmoCost == none || AmmoCost.bFreeCost ) { continue; }

			if ( AmmoCost.bConsumeAllAmmo || AmmoCost.iAmmo == WeaponState.Ammo)
			{
				return WeaponState.GetClipSize();
			}
		
			MZAmmoCost = MZ_Cost_AmmoPerTarget( MyTemplate.AbilityCosts[i] );
			//get a target count somehow and then
			if ( MZAmmoCost.AmmoPerTarget * AppliedData.AbilityInputContext.MultiTargets.Length + MZAmmoCost.iAmmo == WeaponState.Ammo)
			{
				return WeaponState.GetClipSize();
			}
		}
	}

	//also, need to make sure to apply only to the last shot!

	return 0;
}

function bool IsLastTarget(EffectAppliedData AppliedData)
{
	local array<StateObjectReference> AbilityTargets;
	local array<StateObjectReference> UnitAbilityTargets;
	local StateObjectReference AbilityTarget;
	local XComGameStateHistory History;
	local XComGameState_Unit	UnitState;
	
	History = `XCOMHISTORY;

	AbilityTargets = AppliedData.AbilityInputContext.MultiTargets;
	if ( AbilityTargets.Length == 0 ) { return true; }

	//burst fire will either apply to all hits, or none of the hits. I've opted for none.
	If ( AppliedData.TargetStateObjectRef.ObjectID == AppliedData.AbilityInputContext.PrimaryTarget.ObjectID ) { return false; }
	//UnitAbilityTargets.AddItem(AppliedData.AbilityInputContext.PrimaryTarget);

	foreach AbilityTargets(AbilityTarget)
	{
		UnitState = XComGameState_Unit(History.GetGameStateForObjectID(AbilityTarget.ObjectID));
		if (UnitState != None)
		{
			UnitAbilityTargets.AddItem(AbilityTarget);
		}
	}

	return UnitAbilityTargets[UnitAbilityTargets.Length - 1].ObjectID == AppliedData.TargetStateObjectRef.ObjectID;
}