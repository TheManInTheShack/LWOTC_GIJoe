class MZ_Damage_ByChillTier extends X2Effect_ApplyWeaponDamage;

var name T0Tag, T1Tag, T2Tag, T3Tag;

function WeaponDamageValue GetBonusEffectDamageValue(XComGameState_Ability AbilityState, XComGameState_Unit SourceUnit, XComGameState_Item SourceWeapon, StateObjectReference TargetRef)
{
	local XComGameState_Unit			TargetState;
	local XComGameStateHistory			History;
	local XComGameState_BaseObject		Target;
	local WeaponDamageValue				MineDamage;

	History = `XCOMHISTORY;
	Target = History.GetGameStateForObjectID( TargetRef.ObjectID );

	TargetState = XComGameState_Unit(Target);

	if (TargetState != none)
	{
		if ( TargetState.AffectedByEffectNames.Find('Freeze') != INDEX_NONE )
		{
			AbilityState.GetSourceWeapon().GetWeaponDamageValue( Target, T3Tag, MineDamage);
		}
		else if ( TargetState.AffectedByEffectNames.Find('MZBitterChill') != INDEX_NONE )
		{
			AbilityState.GetSourceWeapon().GetWeaponDamageValue( Target, T2Tag, MineDamage);
		}
		else if ( TargetState.AffectedByEffectNames.Find('MZChill') != INDEX_NONE || TargetState.AffectedByEffectNames.Find('Chilled') != INDEX_NONE)
		{
			AbilityState.GetSourceWeapon().GetWeaponDamageValue( Target, T1Tag, MineDamage);
		}
		else
		{
			AbilityState.GetSourceWeapon().GetWeaponDamageValue( Target, T0Tag, MineDamage);
		}
	}
	else
	{
		AbilityState.GetSourceWeapon().GetWeaponDamageValue( Target, T0Tag, MineDamage);
	}

	return MineDamage;
}

DefaultProperties
{
	bExplosiveDamage = false
	bIgnoreBaseDamage = true
}