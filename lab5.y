%{
/*
 * Lab5
 * Michelle Cormier
 * Purpose: 
 * Date: 03/08/2021
 * Input: Tokenized input from the console coming from lex
 * Output: If the code is syntactically correct, then nothing. Otherwise, a variety
 *	of error reports.
 * Assumptions: Input from lex will be valid tokens for yacc's syntax rules.
 */ 

int yylex(); /* Method declaration for yylex() to get rid of that warning */
int yylineno;
%}

%{

/* Begin Specs */
	
#include <stdio.h>
#include <ctype.h>
#include <stdlib.h>

void yyerror( s )  /* Called by yyparse on error */
     char *s;
{
  printf ( "%s on line %d\n", s, yylineno );
}


%}

%start Program

%union
{
	int value;
	char* string;
}

%token T_AND
%token T_ASSIGN
%token T_BOOLTYPE
%token T_BREAK
%token T_CHARCONSTANT
%token T_CONTINUE
%token T_DOT
%token T_ELSE
%token T_EQ
%token T_EXTERN
%token T_FALSE
%token T_FOR
%token T_FUNC
%token T_GEQ
%token T_GT
%token T_ID
%token T_IF
%token T_INTCONSTANT
%token T_INTTYPE
%token T_LEFTSHIFT
%token T_LEQ
%token T_NEQ
%token T_NULL
%token T_OR
%token T_PACKAGE
%token T_RETURN
%token T_RIGHTSHIFT
%token T_STRINGCONSTANT
%token T_STRINGTYPE
%token T_TRUE
%token T_VAR
%token T_VOID
%token T_WHILE

%left '+' '-'
%left '*' '/'


%%	/* End Specs, Begin Production Rules */

Program     : Externs T_PACKAGE T_ID '{' FieldDecls MethodDecls '}'
		    ;
		
Externs     : /* empty */ 
			| ExternDefn Externs
			;
			
ExternDefn  : T_EXTERN T_FUNC T_ID '(' ExternTypeList ')' MethodType ';' 
			;

ExternTypeList : /* empty */
			   | FullExternTypeList
			   ;
			   
FullExternTypeList : ExternType
				   | ExternType ',' ExternTypeList

FieldDecls 	: /* empty */
			| FieldDecl FieldDecls
			;
			
FieldDecl  	: T_VAR T_ID Type ';'
			;
			
FieldDecl  	: T_VAR T_ID  ArrayType ';'
			;

FieldDecl  	: T_VAR T_ID Type '=' Constant ';'

MethodDecls : /* empty */
			| MethodDecl MethodDecls
			;
			
MethodDecl  : T_FUNC T_ID '(' MethodTypeList ')' MethodType Block
			;

MethodTypeList  : /* empty */
				| FullMethodTypeList
				;
			
FullMethodTypeList : T_ID Type
				   | T_ID Type ',' MethodTypeList
				   ;

Block       : '{' VarDecls Statements '}'
			;

VarDecls    : /* empty */
	 		| VarDecl VarDecls
	 		;
	 		
VarDecl     : T_VAR T_ID Type ';'
			;
			
VarDecl 	: T_VAR T_ID ArrayType ';'
			;

Statements 	: /* empty */ 
			| Statement Statements
			;
			
Statement 	: Block
			;
			
Statement 	: Assign ';'
			;
			
Assign    	: Lvalue T_ASSIGN Expr
			| Lvalue T_ASSIGN Expr ',' Assign
			;
			
Lvalue    	: T_ID 
			| T_ID '[' Expr ']'
			;
			
Statement  	: MethodCall ';'
			;
			
MethodCall 	: T_ID '(' MethodCallList ')'
			;
			
MethodCallList : /* empty */
			   | FullMethodCallList
			   ;
			   
FullMethodCallList : MethodArg
				   | MethodArg ',' MethodCallList
				   ;

MethodArg  	: Expr
			| T_STRINGCONSTANT
			;
			
Statement 	: T_IF '(' Expr ')' Block 
			;

Statement 	: T_IF '(' Expr ')' Block T_ELSE Block 
			;
			
Statement 	: T_WHILE '(' Expr ')' Block
			;
			
Statement 	: T_FOR '(' Assign ';' Expr ';' Assign ')' Block
			;

Statement 	: T_RETURN ';'
			| T_RETURN '(' Expr ')' ';'
			;
			
Statement 	: T_BREAK ';'
			;
			
Statement 	: T_CONTINUE ';'
			;


Expr : Simpleexpression
Simpleexpression : Additiveexpression
                 | Simpleexpression Relop Additiveexpression
                 ;
Relop : T_LEQ | '<' | T_GT | T_GEQ | T_EQ |  T_NEQ
      ;
Additiveexpression : Term
                   | Additiveexpression Addop Term
                   ;
Addop : '+' | '-'
      ;
Term : Factor
     | Term Multop Factor
     ;
Multop : '*' | '/'  | T_AND | T_OR | T_LEFTSHIFT | T_RIGHTSHIFT
       ;
Factor : T_ID
     | MethodCall
     | T_ID '[' Expr ']'
     | Constant
     | '(' Expr ')'
     | '!' Factor
     | '-' Factor
     ;



ExternType 	: T_STRINGTYPE
			| Type
			;
			
Type 		: T_INTTYPE
			| T_BOOLTYPE
			;
			
MethodType 	: T_VOID
			| Type
			;
			
BoolConstant : T_TRUE
			 | T_FALSE
			 ;
			 
ArrayType 	: '[' T_INTCONSTANT ']' Type
			;

Constant 	: T_INTCONSTANT 
			| BoolConstant 
			;

%%	/* end of rules, start of program */

int main()
{ 

	yyparse();
	
}
