/* Meaning of some macros:
* T4: Plutonium - Generic
* T4MP: Plutonium - Multiplayer only
* T4SP: Plutonium - Singleplayer only
* IW4MP: Multiplayer only
* IW4SP: Singleplayer only
* IW4: Generic
* IW5x: Reserved
* IW5: Plutonium
* TOOL: GSC-Tool mode
* Usage with a C++20 (or a later standard) compliant preprocessor may be required.
* /Zc:preprocessor is required with the MSVC compiler.
*/

#ifdef IW4
	#ifndef IW4MP
		#define IW4MP
	#endif
	#ifndef IW4SP
		#define IW4SP
	#endif
#endif

#define TRUE 1
#define FALSE 0

#define ZERO_VEC3 ( 0, 0, 0 )

#define TEMP_DVAR "temp_dvar_util"

#if defined(T4SP)
	#define CLIENT_FIELD_NAME playername
#else
	#define CLIENT_FIELD_NAME name
#endif

#define GENERIC_INIT \
	init() \
	{ \
		thread onPlayerConnect(); \
	}

#define GENERIC_COROUTINE_END \
	level endon( "game_ended" ); \
	self endon( "disconnect" );

/* Captures a "connected" event. Perform your action(s) using the "player" variable */
#define _ON_PLAYER_CNCT_BEGIN onPlayerConnect() \
	{ \
		while ( true ) \
		{ \
			level waittill( "connected", player );

#define _ON_PLAYER_CNCT_END \
		} \
	}

/* IW4x MP has printConsole Built-in. __VA_OPT__ requires C++20 compliant preprocessor */
/* Do not use the + to concatenate strings, let the GSC VM do it for you */
/* Other clients will have print available */
#if defined(IW4MP)
	#define PRINT_FUNC printConsole
#else
	#define PRINT_FUNC print
#endif

#ifdef _UTILITY_DEBUG
	#define _VERIFY(cond, msg) \
		assertEx( cond, msg )

	#define DEBUG_PRINT(msg) \
		PRINT_FUNC( msg )
#else
	/* The following are "empty" defines with gsc-tool  */
	#define _VERIFY(cond, msg)
	#define DEBUG_PRINT(msg)
#endif

/* Use Cbuf. Should use the + to concatenate strings before using this */
#if defined(IW5) || defined(IW5x) || defined(T4)
	#define CBUF_ADD_TEXT(format) cmdExec( format )
#elif defined(IW6x) || defined(S1x)
	#define CBUF_ADD_TEXT(format) executeCommand( format )
#elif defined(IW4MP)
	#define CBUF_ADD_TEXT(format) exec( format )
#elif defined(IW4SP)
	#define CBUF_ADD_TEXT(format) addDebugCommand( format )
#else
	#error CBUF_ADD_TEXT is not defined
#endif

#if defined(IW4MP) || defined(IW4SP) || defined(IW5) || defined(IW5x) || defined(IW6x) || defined(S1x)
	#define FLOAT(num) float( num )
#else
	#define FLOAT(num) getDvarFloat( TEMP_DVAR, 0.0 )
#endif

#if defined(IW4MP)
	#define NOCLIP(ent) ent noclip()
#else /* All clients should have it but require the following */
	#define NOCLIP(ent) \
		setDvar( "sv_cheats", 1 ); \
		ent noclip(); \
		setDvar( "sv_cheats", 0 );
#endif

#if defined(IW4MP)
	#define UFO(ent) ent ufo()
#else /* All clients should have it but require the following */
	#define UFO(ent) \
		setDvar( "sv_cheats", 1 ); \
		ent ufo(); \
		setDvar( "sv_cheats", 0 );
#endif

#define WAIT_CNT(ent) level waittill ( "connected", ent )

#define WAIT_END(ent, msg) ent waittillmatch( msg, "end" )

/* defined in common_scripts\utility */
#if !defined(TOOL)
	#define WAIT_ANY_RET(ent, ...) ent waittill_any_return( __VA_ARGS__ )
#endif

#if !defined(TOOL)
	#define PLAYER_NOTIFY_CMD(ent, str, action) ent notifyOnPlayerCommand( str, action )
#endif

/* Tweak as necessary. Can be return, continue or break  */
#define CHK_ACTION continue

#if (defined(IW4MP) || defined(IW5x) || defined(IW5)) && !defined(TOOL)
#define BOT_CHK(ent) \
	if ( ent isTestClient() ) \
	{ \
		DEBUG_PRINT( ent.CLIENT_FIELD_NAME + " is a bot\n" ); \
		CHK_ACTION; \
	}
#else /* Valid for other clients. You should wait some frames to allow Bot Warfare to set these values */
#define BOT_CHK(ent) \
	if ( isDefined( ent.pers["isBot"] ) && ent.pers["isBot"] ) \
	{ \
		DEBUG_PRINT( ent.CLIENT_FIELD_NAME + " is a bot\n" ); \
		CHK_ACTION; \
	}
#endif

#define DEFINE_CHK(x) \
	if ( !isDefined( (x) ) ) \
	{ \
		CHK_ACTION; \
	}
