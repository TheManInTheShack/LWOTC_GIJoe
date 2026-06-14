class X2AbilityTemplate_ShadowPatcher extends X2AbilityTemplate;

static function PatchShadow(X2AbilityTemplateManager TemplateManager, name AbilityName) {
	local int i;
	local X2AbilityTemplate Template;
	local X2Effect_AdditionalAnimSets AnimSetEffect;
	local X2Effect_AdditionalAnimSets NewAnimSetEffect;		

	Template = TemplateManager.FindAbilityTemplate(AbilityName);

	for(i=0;i<Template.AbilityTargetEffects.Length;i++) {
		AnimSetEffect = X2Effect_AdditionalAnimSets(Template.AbilityTargetEffects[i]);
		if (AnimSetEffect != none) {
			if (AnimSetEffect.EffectName == 'ShadowAnims') {
				NewAnimSetEffect =  new class'X2Effect_AdditionalAnimSets';
				NewAnimSetEffect.EffectName = 'ShadowAnims';
				NewAnimSetEffect.DuplicateResponse = eDupe_Ignore;
				NewAnimSetEffect.BuildPersistentEffect(1, true, true, false, eGameRule_PlayerTurnEnd);
				NewAnimSetEffect.bRemoveWhenTargetConcealmentBroken = true;
				NewAnimSetEffect.AddAnimSetWithPath("MFSC_Reaper.Anims.AS_MFSC_ReaperShadow");

				Template.AbilityTargetEffects[i] = NewAnimSetEffect;

				`log("ShadowAnims patched for " $ AbilityName);
			}
		}
	}
	
}