class X2Effect_ReduceExplosiveDamage extends X2Effect_PersistentAOE;

var float ExplosiveDamageReduction;

function int GetDefendingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, X2Effect_ApplyWeaponDamage WeaponDamageEffect, optional XComGameState NewGameState)
{
    local XComGameState_Unit TargetUnit;
    local int DamageMod;
    local bool Explosives;
    local XComGameState_Item SourceWeapon;
    local X2WeaponTemplate WeaponTemplate;

    TargetUnit = XComGameState_Unit(TargetDamageable);
	if (TargetUnit != none && !IsEffectCurrentlyRelevant(EffectState, TargetUnit))
    {
        return 0;
    }

    SourceWeapon = AbilityState.GetSourceWeapon();
    if (SourceWeapon != none)
        WeaponTemplate = X2WeaponTemplate(SourceWeapon.GetMyTemplate());

    Explosives = false;
    if (WeaponDamageEffect.bExplosiveDamage)
        Explosives = true;
    if (WeaponDamageEffect.EffectDamageValue.DamageType == 'Explosion')
        Explosives = true;
    if (WeaponDamageEffect.DamageTypes.Find('Explosion') != -1)
        Explosives = true;
    if (WeaponDamageEffect.EffectDamageValue.DamageType == 'BlazingPinions')
        Explosives = true;
    if (WeaponDamageEffect.DamageTypes.Find('BlazingPinions') != -1)
        Explosives = true;
    if (WeaponTemplate != none && WeaponTemplate.DamageTypeTemplateName == 'Explosion')
        Explosives = true;
    if (WeaponTemplate != none && WeaponTemplate.DamageTypeTemplateName == 'BlazingPinions')
        Explosives = true;

    if(Explosives)
    {
        DamageMod = -int(float(CurrentDamage) * ExplosiveDamageReduction);
    }

    return DamageMod;
}

DefaultProperties
{
	EffectName="ReduceExplosiveDamageAOE"
}

