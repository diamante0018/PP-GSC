/* Meaning of some macros:
* IW5: Plutonium
* T4: Plutonium
* IW5x: Reserved
* IW4MP: Multiplayer only
* IW4SP: Singleplayer only
* IW4: Generic
* TOOL: GSC-Tool mode
* Usage with a C++20 (or a later standard) compliant preprocessor may be required.
* /Zc:preprocessor is required with the MSVC compiler.
*/

#define TRUE 1
#define FALSE 0

#define ZERO_VEC3 ( 0, 0, 0 )

#define TEMP_DVAR "temp_dvar_util"

#define GENERIC_INIT \
	init() \
	{ \
		thread onPlayerConnect(); \
	}

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
/* Other clients will have print avaiable */
#if !defined(TOOL)
	#if defined(IW4MP)
		#define PRINT(format, ...) printConsole( format __VA_OPT__(,) __VA_ARGS__ )
	#else
		#define PRINT(format, ...) print( format __VA_OPT__(,) __VA_ARGS__ )
	#endif
#endif

/* Use Cbuf. Should use the + to concatenate strings prior to using this */
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

/* defined in common_scripts\iw4x_utility */
#if defined(IW4MP)
	#define NOCLIP(ent) noclip( ent )
#else /* All clients should have it */
	#define NOCLIP(ent) ent noclip()
#endif

/* defined in common_scripts\iw4x_utility */
#if defined(IW4MP)
	#define UFO(ent) ufo( ent )
#else /* All clients should have it */
	#define UFO(ent) ent ufo()
#endif

#define WAIT_CNT(ent) level waittill ( "connected", ent )

#define WAIT_END(ent, msg) ent waittillmatch( msg, "end" )

/* defined in common_scripts\utility */
#if !defined(TOOL)
	#define WAIT_ANY_RET(ent, ...) ent waittill_any_return( __VA_ARGS__ )
#endif

#define PLAYER_NOTIFY_CMD(ent, str, action) ent notifyOnPlayerCommand( str, action )

/* Tweak as necessary. Can be return, continue or break  */
#define CHK_ACTION continue

#if defined(IW4MP) || defined(IW5x)
#define BOT_CHK(ent) \
	if ( ent isTestClient() ) \
	{ \
		CHK_ACTION; \
	}
#else /* Valid for other clients */
#define BOT_CHK(ent) \
	if ( isDefined( ent.pers["isBot"] ) && ent.pers["isBot"] ) \
	{ \
		CHK_ACTION; \
	}
#endif

#define DEFINE_CHK(x) \
	if ( !isDefined( (x) ) ) \
	{ \
		CHK_ACTION; \
	}
