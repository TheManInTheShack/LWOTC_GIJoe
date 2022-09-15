class X2EventListener_GremlinStealthFix extends X2EventListener;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem( AddListeners() );

	return Templates;
}

static protected function X2EventListenerTemplate AddListeners()
{
	local X2EventListenerTemplate Template;

	`CREATE_X2TEMPLATE(class'X2EventListenerTemplate', Template, 'GremlinStealthFixListener');
	Template.AddEvent('SquadConcealmentBroken', UpdateGremlinConcealment_Player);
	Template.AddEvent('UnitConcealmentEntered', UpdateGremlinConcealment_Unit);
	Template.AddEvent('UnitConcealmentBroken', UpdateGremlinConcealment_Unit);

	return Template;
}

static function UpdateGremlinConcealment(XComGameState_Unit SourceUnit, XComGameState NewGameState, Name EventID)
{
	local array<XComGameState_Unit> AttachedUnits;
	local XComGameState_Unit AttachedUnit, NewAttachedUnit;
	local bool bConcealed;

	SourceUnit.GetAttachedUnits(AttachedUnits);

	bConcealed = SourceUnit.IsIndividuallyConcealed();
	if (EventID == 'UnitConcealmentEntered')
		bConcealed = true;
	else if (EventID == 'UnitConcealmentBroken')
		bConcealed = false;

	foreach AttachedUnits(AttachedUnit)
	{
		NewAttachedUnit = XComGameState_Unit(NewGameState.ModifyStateObject(class'XComGameState_Unit', AttachedUnit.ObjectID));
		NewAttachedUnit.SetIndividualConcealment(bConcealed, NewGameState);
	}
}

static function EventListenerReturn UpdateGremlinConcealment_Unit(Object EventData, Object EventSource, XComGameState GameState, Name EventID, object CallbackData)
{
	local XComGameState NewGameState;
	local XComGameState_Unit SourceUnit;
	local bool bSubmitState;

	if (GameState.bReadOnly)
	{
		NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("UpdateGremlinConcealment_Unit");
		bSubmitState = true;
	}
	else
	{
		NewGameState = GameState;
	}

	SourceUnit = XComGameState_Unit(EventData);
	if (SourceUnit != none)
	{
		UpdateGremlinConcealment(SourceUnit, NewGameState, EventID);
	}

	if (bSubmitState)
	{
		if( NewGameState.GetNumGameStateObjects() > 0 )
		{
			`TACTICALRULES.SubmitGameState(NewGameState);
		}
		else
		{
			`XCOMHISTORY.CleanupPendingGameState(NewGameState);
		}
	}

	return ELR_NoInterrupt;
}

static function EventListenerReturn UpdateGremlinConcealment_Player(Object EventData, Object EventSource, XComGameState GameState, Name EventID, object CallbackData)
{
	local XComGameState NewGameState;
	local XComGameState_Unit SourceUnit;
	local bool bSubmitState;

	if (GameState.bReadOnly)
	{
		NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("UpdateGremlinConcealment_Player");
		bSubmitState = true;
	}
	else
	{
		NewGameState = GameState;
	}

	foreach `XCOMHISTORY.IterateByClassType(class'XComGameState_Unit', SourceUnit)
	{
		UpdateGremlinConcealment(SourceUnit, NewGameState, EventID);
	}

	if (bSubmitState)
	{
		if( NewGameState.GetNumGameStateObjects() > 0 )
		{
			`TACTICALRULES.SubmitGameState(NewGameState);
		}
		else
		{
			`XCOMHISTORY.CleanupPendingGameState(NewGameState);
		}
	}

	return ELR_NoInterrupt;
}
