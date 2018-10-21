/* A Bison parser, made by GNU Bison 2.3.  */

/* Skeleton interface for Bison's Yacc-like parsers in C

   Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
   Free Software Foundation, Inc.

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2, or (at your option)
   any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 51 Franklin Street, Fifth Floor,
   Boston, MA 02110-1301, USA.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     INTEGER = 258,
     REAL = 259,
     IDENTIFIER = 260,
     TYPE_REAL = 261,
     TYPE_INTEGER = 262,
     VAR = 263,
     ADD = 264,
     SUB = 265,
     MUL = 266,
     DIV = 267,
     OP = 268,
     CP = 269,
     ASSIGN_OP = 270,
     COMMA = 271,
     COLON = 272,
     EOL = 273,
     EOF_TOKEN = 274,
     IF = 275,
     THEN = 276,
     ELSE = 277,
     WHILE = 278,
     BEGIN_TOKEN = 279,
     END_TOKEN = 280,
     PROGRAM = 281,
     WRITELN = 282
   };
#endif
/* Tokens.  */
#define INTEGER 258
#define REAL 259
#define IDENTIFIER 260
#define TYPE_REAL 261
#define TYPE_INTEGER 262
#define VAR 263
#define ADD 264
#define SUB 265
#define MUL 266
#define DIV 267
#define OP 268
#define CP 269
#define ASSIGN_OP 270
#define COMMA 271
#define COLON 272
#define EOL 273
#define EOF_TOKEN 274
#define IF 275
#define THEN 276
#define ELSE 277
#define WHILE 278
#define BEGIN_TOKEN 279
#define END_TOKEN 280
#define PROGRAM 281
#define WRITELN 282




#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
#line 14 "test.y"
{
	int integer_val;
  double real_val;
	char *string_val;
}
/* Line 1529 of yacc.c.  */
#line 109 "test.tab.h"
	YYSTYPE;
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
# define YYSTYPE_IS_TRIVIAL 1
#endif

extern YYSTYPE yylval;

