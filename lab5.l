/*
 * Lab5
 * Michelle Cormier
 * Purpose: 
 * Date: 03/08/2021
 * Input: Code using the semantic rules of DECAF, a stripped down version of JAVA. 
 * Output: A Tokenized form of the code, sent to YACC.
 * Assumptions: 
 */ 

%{

int mydebug = 1;

#include "y.tab.h"
#include <stdio.h>
#include <ctype.h>
#include <stdlib.h>

int yylineno;


int HexToInt( char* hexString) {

	char *hexPointer;
	int numberLength = 0;
	int hexValue = 0;
	
	for( hexPointer = hexString; *hexPointer != '\0'; hexPointer++ ) {
		numberLength++;
	}
	
	int i = numberLength - 2;
	int powerValue = 1;
	
	for( hexPointer = hexString; *hexPointer != '\0'; hexPointer++ ) {
	
		switch( *hexPointer ) {
		
			case '1' :
			case '2' :
			case '3' :
			case '4' :
			case '5' :
			case '6' :
			case '7' :
			case '8' :
			case '9' :
				for( int p = 1; p < i ; p++ ){ powerValue = powerValue * 16; }
				hexValue = hexValue + atoi( ( const char* ) hexPointer ) * powerValue;
				i--;
				powerValue = 1;
				break;
			case 'a' :
			case 'A' :
				for( int p = 1; p < i ; p++ ){ powerValue = powerValue * 16; }
				hexValue = hexValue + 10 * powerValue;
				i--;
				powerValue = 1;
				break;
			case 'b' :
			case 'B' :
				for( int p = 1; p < i ; p++ ){ powerValue = powerValue * 16; }
				hexValue = hexValue + 11 * powerValue; 
				i--;
				powerValue = 1;
				break;
			case 'c' :
			case 'C' :
				for( int p = 1; p < i ; p++ ){ powerValue = powerValue * 16; }
				hexValue = hexValue + 12 * powerValue; 
				i--;
				powerValue = 1;
				break;
			case 'd' :
			case 'D' :
				for( int p = 1; p < i ; p++ ){ powerValue = powerValue * 16; }
				hexValue = hexValue + 13 * powerValue; 
				i--;
				powerValue = 1;
				break;
			case 'e' :
			case 'E' :
				for( int p = 1; p < i ; p++ ){ powerValue = powerValue * 16; }
				hexValue = hexValue + 14 * powerValue; 
				i--;
				powerValue = 1;
				break;
			case 'f' :
			case 'F' :
				for( int p = 1; p < i ; p++ ){ powerValue = powerValue * 16; }
				hexValue = hexValue + 15 * powerValue; 
				i--;
				powerValue = 1;
				break;
				
		}
	}
	return( hexValue );
}

%}

%%

"&&"	{ return( T_AND ); }
"="		{ return( T_ASSIGN ); }
"bool" 	{ return( T_BOOLTYPE); }
"break" 	{ return( T_BREAK ); }
"continue" 	{ return( T_CONTINUE ); }
\. 	{ return( T_DOT ); }
"else" 	{ return( T_ELSE ); }
"==" 	{ return( T_EQ ); }
"extern" 	{ 
				if( mydebug) fprintf( stderr, "Extern found\n" );
				return( T_EXTERN ); 
			}
"false" 	{ return( T_FALSE ); }
"for" 	{ return( T_FOR ); }
"func" 	{ 
			if( mydebug) fprintf( stderr, "Func found\n" );
			return( T_FUNC ); 
		}
">=" 	{ return( T_GEQ ); }
">" 	{ return( T_GT ); }
"if" 	{ return( T_IF ); }
"int" 	{ 
			if( mydebug) fprintf( stderr, "Int Type found\n" );
			return( T_INTTYPE );
		}
"<<" 	{ return( T_LEFTSHIFT ); }
"<=" 	{ return( T_LEQ ); }
"!=" 	{ return( T_NEQ ); }
"null" 	{ return( T_NULL ); }
"||" 	{ return( T_OR ); }
"package" 	{
				if( mydebug) fprintf( stderr, "Package found\n" );
				return( T_PACKAGE );
			}
"return" 	{ return( T_RETURN ); }
">>" 	{ return( T_RIGHTSHIFT ); }
"string" 	{ return( T_STRINGTYPE ); }
"true" 	{ return( T_TRUE ); }
"var" 	{
			if( mydebug) fprintf( stderr, "Var found\n" );
			return( T_VAR );
		}
"void" 	{ return( T_VOID ); }
"while" 	{ return( T_WHILE ); }

\'.\' 	{ 
			yylval.value = yytext[ 1 ]; 
			return( T_CHARCONSTANT ); 
		}
\".*\" 	{ 
			yylval.string = strdup( yytext );
			return( T_STRINGCONSTANT );
		}
\/\/.*[\n] { /* Comments, just ignore this */ 
				if( mydebug) fprintf( stderr, "Comment found: %s\n", strdup( yytext ) ); 
			 }
[a-zA-Z][a-zA-Z0-9_]* 	{
			if( mydebug) fprintf( stderr, "String Identifier found: %s\n", strdup( yytext ) );
			yylval.string = strdup( yytext );
			return( T_ID );	
		}
[0-9][0-9]*		{ 
			if( mydebug ) fprintf( stderr, "Digit found: %d\n", atoi( ( const char* ) yytext ) );
			yylval.value = atoi( ( const char* ) yytext );
			return( T_INTCONSTANT );
		}
[0-9]+\.[0-9]*	{ 
			if( mydebug ) fprintf( stderr, "Decimel found\n" );
			yylval.value = atoi( ( const char* ) yytext );
			return( T_INTCONSTANT );
		}
0[xX][0-9a-fA-F]+  { 
			if( mydebug ) fprintf( stderr, "Hexadecimel found\n" );
			yylval.value = HexToInt( ( char* ) yytext );
			return( T_INTCONSTANT );
		}
[ \t ] { if( mydebug) fprintf( stderr, "Whitespace found\n" ); }
[()\[\]{}=\-+*/%;,] 	{   
			if( mydebug ) fprintf( stderr, "Return a token %c\n", *yytext ); 
            return ( *yytext );
        }     
\n 		{ 
			if( mydebug ) fprintf( stderr, "Carriage return %c\n", *yytext ); 
			yylineno++;
            //return ( *yytext ); 
        }

%%

int yywrap( void )
{ return 1; }


