class X2EventListener_KillTracker extends X2EventListener;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem( AddListeners() );

	return Templates;
}

static protected function X2EventListenerTemplate AddListeners()
{
	local X2EventListenerTemplate Template;

	`CREATE_X2TEMPLATE(class'X2EventListenerTemplate', Template, 'KillTrackerListener');
	Template.AddEvent('KillMail', OnKillMail);

	return Template;
}

static function EventListenerReturn OnKillMail(Object EventData, Object EventSource, XComGameState GameState, Name InEventID, object CallbackData)
{
	local XComGameState_Unit UnitState;
	local XComGameState_KillTracker Tracker;
	local XComGameState NewGameState;

	// `Log("OnKillMail: EventData =" @ EventData);
	// `Log("OnKillMail: EventSource =" @ EventSource);

	UnitState = XComGameState_Unit(EventSource);
	if (UnitState == none)
		return ELR_NoInterrupt;

	Tracker = class'XComGameState_KillTracker'.static.GetKillTracker();

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Shadow Ops: Update Kill Tracker");
	Tracker = XComGameState_KillTracker(NewGameState.ModifyStateObject(class'XComGameState_KillTracker', tracker.ObjectID));
	Tracker.UpdateKills(UnitState);
	`GAMERULES.SubmitGameState(NewGameState);

	return ELR_NoInterrupt;
}