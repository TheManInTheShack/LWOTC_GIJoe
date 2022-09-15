class MZ_Effect_ApplyCurseToWorld extends X2Effect_ApplyPoisonToWorld config(MZPerkWeapons);

var config string	CurseParticleSystem;
//var array<X2Effect>	BonusTileEnteredEffects;

event array<X2Effect> GetTileEnteredEffects()
{
	local array<X2Effect>	TileEnteredEffectsUncached;

	TileEnteredEffectsUncached.AddItem(class'MZ_Effect_BloodCurse'.static.CreateBloodCurse());

	return TileEnteredEffectsUncached;
}
event array<ParticleSystem> GetParticleSystem_Fill()
{
	local array<ParticleSystem> ParticleSystems;
	ParticleSystems.AddItem( none );
	ParticleSystems.AddItem(ParticleSystem(DynamicLoadObject(CurseParticleSystem, class'ParticleSystem')));
	return ParticleSystems;
}

static simulated function int GetTileDataDynamicFlagValue() { return 16; }  //TileDataContainsPoison

defaultproperties
{
	bCenterTile = false;
	DamageTypes.Add("Psi");
}