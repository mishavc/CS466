##
# Michelle Cormier
# Lab 5
# Date: March 8, 2021
# Purpose: Make file for Lab 5
##

all:	lab5

lab5:	lab5.l lab5.y
	yacc -d lab5.y
	lex lab5.l
	gcc -o lab5 lex.yy.c y.tab.c