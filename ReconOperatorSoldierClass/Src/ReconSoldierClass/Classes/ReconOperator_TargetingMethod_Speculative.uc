class ReconOperator_TargetingMethod_Speculative extends X2TargetingMethod_Grenade;

var vector NewTargetLocation;
var bool bIsValidTargetLocation;
var bool bWasBlocked;

static function bool UseGrenadePath() { return false; }


function Update(float DeltaTime)
{
	local XComWorldData World;
	local VoxelRaytraceCheckResult Raytrace;
	local array<Actor> CurrentlyMarkedTargets;
	local int Direction, CanSeeFromDefault;
	local UnitPeekSide PeekSide;
	local int OutRequiresLean;
	local TTile BlockedTile, PeekTile, UnitTile;
	local bool GoodView;
	local CachedCoverAndPeekData PeekData;
	local array<TTile> Tiles;
	local vector TempTargetLocation;
	local array<Vector> TargetLocs;
	
	TempTargetLocation = Cursor.GetCursorFeetLocation();
	TargetLocs.Length = 0;
	TargetLocs.AddItem(TempTargetLocation);

	if( TempTargetLocation != CachedTargetLocation )
	{
		World = `XWORLD;
		GoodView = false;
		bWasBlocked = false;

		if( World.VoxelRaytrace_Locations(FiringUnit.Location, TempTargetLocation, Raytrace) )
		{
			BlockedTile = Raytrace.BlockedTile; 
			//`log("[ReconOperator]-> Blocked == true, TraceBlockedActor" $ Raytrace.TraceBlockedActor.Tag);
			bWasBlocked = true;

			//  check left and right peeks
			FiringUnit.GetDirectionInfoForPosition(TempTargetLocation, Direction, PeekSide, CanSeeFromDefault, OutRequiresLean, true);

			if (PeekSide != eNoPeek)
			{
				UnitTile = World.GetTileCoordinatesFromPosition(FiringUnit.Location);
				PeekData = World.GetCachedCoverAndPeekData(UnitTile);
				if (PeekSide == ePeekLeft)
					PeekTile = PeekData.CoverDirectionInfo[Direction].LeftPeek.PeekTile;
				else
					PeekTile = PeekData.CoverDirectionInfo[Direction].RightPeek.PeekTile;

				if (!World.VoxelRaytrace_Tiles(UnitTile, PeekTile, Raytrace))
					GoodView = true;
				else
					BlockedTile = Raytrace.BlockedTile;
			}				
		}		
		else
		{
			GoodView = true;
		}

		bIsValidTargetLocation = ValidateTargetLocations(TargetLocs) == 'AA_Success';

		if( !GoodView && bIsValidTargetLocation && !CanPierce() )
		{
			TempTargetLocation = World.GetPositionFromTileCoordinates(BlockedTile);
			Cursor.CursorSetLocation(TempTargetLocation);
			NewTargetLocation = TempTargetLocation;
			//`SHAPEMGR.DrawSphere(LastTargetLocation, vect(25,25,25), MakeLinearColor(1,0,0,1), false);
		}
		else //if(bIsValidTargetLocation)
		{
			NewTargetLocation = TempTargetLocation;
			Cursor.CursorSetLocation(TempTargetLocation);
		}

		GetTargetedActors(NewTargetLocation, CurrentlyMarkedTargets, Tiles);
		CheckForFriendlyUnit(CurrentlyMarkedTargets);	
		MarkTargetedActors(CurrentlyMarkedTargets, (!AbilityIsOffensive) ? FiringUnit.GetTeam() : eTeam_None );
		if(!bIsValidTargetLocation)
		{
			ExplosionEmitter.SetHidden(true);
			Tiles.Length = 0;
		}
		else
		{
			ExplosionEmitter.SetHidden(false);
		}
		DrawSplashRadius();
		DrawAOETiles(Tiles);
	}

	super.UpdateTargetLocation(DeltaTime);
}


simulated protected function DrawSplashRadius()
{
	local Vector Center;
	local float Radius;
	local LinearColor CylinderColor;

	Center = GetSplashRadiusCenter();
	Radius = Ability.GetAbilityRadius();
	
	// Does this even work?
	if (bIsValidTargetLocation) 
	{
		CylinderColor = MakeLinearColor(1, 0.2, 0.2, 0.2);
	}
	else 
	{
		CylinderColor = MakeLinearColor(0.2, 0.8, 1, 0.2);
	}
	

	if(ExplosionEmitter != none)
	{
		//`log("DRAWSPLASHRADIUS EXPLOSIONEMITTER");
		ExplosionEmitter.SetLocation(Center); // Set initial location of emitter
		ExplosionEmitter.SetDrawScale(Radius / 48.0f);
		ExplosionEmitter.SetRotation( rot(0,0,1) );

		if( !ExplosionEmitter.ParticleSystemComponent.bIsActive )
		{
			ExplosionEmitter.ParticleSystemComponent.ActivateSystem();			
		}

		ExplosionEmitter.ParticleSystemComponent.SetMICVectorParameter(0, Name("RadiusColor"), CylinderColor);
		ExplosionEmitter.ParticleSystemComponent.SetMICVectorParameter(1, Name("RadiusColor"), CylinderColor);
	}
}

function bool CanPierce()
{
	local StateObjectReference EffectRef;
	local XComGameState_Effect EffectState;
	local X2Effect_Persistent EffectTemplate;
	local XComGameStateHistory History;
	local EffectAppliedData Temp;
	local int Pierce;

	Pierce = 0;
	History = `XCOMHISTORY;

	foreach UnitState.AffectedByEffects(EffectRef)
	{
		EffectState = XComGameState_Effect(History.GetGameStateForObjectID(EffectRef.ObjectID));
		EffectTemplate = EffectState.GetX2Effect();
		Pierce = EffectTemplate.GetExtraArmorPiercing(EffectState, UnitState, none, Ability, Temp);
		if(Pierce > 0)
		{
			//`log("[ReconOperator]-> CanPierce == true");
			return true;
		}
	}
	return false;
}

function name ValidateTargetLocations(const array<Vector> TargetLocations)
{
	local TTile TestLoc;
	local TTile UnitLoc;
	local float Range;

	if (TargetLocations.Length == 1)
	{
		if (bRestrictToSquadsightRange)
		{
			TestLoc = `XWORLD.GetTileCoordinatesFromPosition(TargetLocations[0]);
			UnitLoc = UnitState.TileLocation;

			Range = UnitState.GetMyTemplate().CharacterBaseStats[eStat_SightRadius] + 3;
			
			if(class'X2TacticalVisibilityHelpers'.static.CanSquadSeeLocation(AssociatedPlayerState.ObjectID, TestLoc))
			{
				//`log("[ReconOperator]-> ValidateTargetLocations: Squad can see the location");
				return 'AA_Success';
			}

			if(class'Helpers'.static.IsTileInRange(TestLoc, UnitLoc, Range * Range))
			{
				//`log("[ReconOperator]-> ValidateTargetLocations: Tile is in range");
				if(bWasBlocked)
				{
					if(CanPierce())
					{
						//`log("[ReconOperator]-> ValidateTargetLocations: Target location is within range and armor piercing is available");
						return 'AA_Success';
					}
				}
				else
				{
					//`log("[ReconOperator]-> ValidateTargetLocations: Target location is within range not blocked");
					return 'AA_Success';
				}				
			}

		}
		//`log("[ReconOperator]-> ValidateTargetLocations: Invalid target location");
		return 'AA_NoTargets';
	}
	return 'AA_NoTargets';
}

simulated protected function Vector GetSplashRadiusCenter()
{
	return NewTargetLocation;
}

function GetTargetLocations(out array<Vector> TargetLocations)
{
	TargetLocations.Length = 0;
	TargetLocations.AddItem(NewTargetLocation);
}