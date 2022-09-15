class X2Effect_DamageImmune extends X2Effect_Persistent;

function bool ProvidesDamageImmunity(XComGameState_Effect EffectState, name DamageType)
{
	return true;
}