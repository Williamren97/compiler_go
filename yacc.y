%{
#define Trace(t)        printf(t)
#include <stdlib.h>
#include <stdio.h>
int yylex();
int yyerror(char *s);
%}
//add my type to pass the value from lex

%union 
{
    struct
    {
        char *name;
        int  val;
        char toktype;
    }Token;
}

// %union 
// {
//     char    *name;
//     int     val;
// }
%type<Token.name> ID
// %type<name> STR
// %type<name> REAL
// %type<val> NUMBER


/* tokens */
/* tokens */
%token BOOL
%token BREAK
%token CASE
%token CONST
%token CONTINUE
%token DEFAULT
%token ELSE
%token FALSE
%token FOR
%token FUNC
%token GO
%token IF
%token IMPORT
%token INT
%token NIL
%token PRINT
%token PRINTLN
%token REAL
%token RETURN
%token STRING
%token STRUCT
%token SWITCH
%token TRUE
%token TYPE
%token VAR
%token VOID
%token WHILE
%token READ

%token LESS_EQUAL
%token GREAT_EQUAL
%token EQUAL
%token NOT_EQUAL
%token AND
%token ADD_ASSIGNMENT
%token SUB_ASSIGNMENT
%token MUL_ASSIGNMENT
%token DIV_ASSIGNMENT
%token NUMBER
%token STR
%token ID
%token REAL_NUMBER
%start program
%left '+' '-' '*' '/' '%' '^'
%left '<' '>' LESS_EQUAL GREAT_EQUAL EQUAL NOT_EQUAL
%left '!' '&' '|'
%nonassoc UMINUS


%%
    primitive_type: STRING | INT | BOOL | REAL;
    primitive: STR | NUMBER | REAL_NUMBER | bool_type;
    bool_type: TRUE | FALSE;
    op_order2: '^' ;
    op_order3: '*' | '/' | '%' ;
    op_order4: '+' | '-' ;
    op_order5: '<' | '>' | LESS_EQUAL | GREAT_EQUAL | EQUAL | NOT_EQUAL;
    op_order6: '!' ;
    op_order7: '&' ;
    op_order8: '|' ;

    
    program: //start program
        statements{Trace("Reducing to program\n");};
    statements: //statements can be a one statement or statements
        statement | statement statements;
    statement: 
        declared { Trace("declare id \n");}|
        simple_statement { Trace("simple statement\n");}|
        compound |
        func_invoke |   
        condition |   
        for_loop |
        go;      

    func_declared: // can provide function declared, support void type
        FUNC primitive_type ID '(' ')' compound|
        FUNC primitive_type ID '(' formal_args ')' compound|
        FUNC VOID ID '(' ')' compound|
        FUNC VOID ID '(' formal_args ')' compound;
    formal_args: // like  int a, int b, .... 
        primitive_type ID|
        primitive_type ID ',' formal_args;
    declared: // variable or function declartd
        func_declared | 
        identifier_declared ;
    identifier_list:          // identifier list can pass one or more id
        ID ',' identifier_list { printf("\t id , identifier_list || id = %s\n", $1); }|
        ID     { printf("\t id in identifier_list || id = %s\n", $1); };
    identifier_declared:  //declare the type of id and type check
        VAR identifier_list primitive_type { Trace("identifier_declared non \n");}|
        VAR identifier_list INT '=' NUMBER {Trace("identifier_declared INT \n");}|
        VAR identifier_list BOOL '=' bool_type {Trace("identifier_declared BOOL \n");}|
        VAR identifier_list STRING '=' STR {Trace("identifier_declared STR \n");}|
        VAR identifier_list REAL '=' REAL_NUMBER {Trace("identifier_declared REAL \n");}|
        VAR identifier_list '[' NUMBER ']' primitive_type {Trace("identifier_declared array \n");}|//array declaration
        CONST identifier_list '=' primitive {Trace("CONST \n");};
    simple_statement: //include varialbe or array assign and function call
        ID '=' expression { printf("\t id = expression || id = %s\n", $1);}|
        ID '[' NUMBER ']''=' expression {

        }|
        PRINT expression |
        PRINTLN expression |
        READ ID   {  printf("\t Read id || id = %s\n", $2);}|
        RETURN expression|
        RETURN ;
    expression: // math experssion and boolean expression
        ID |
        primitive |
        expression op_order4 expression | 
        expression op_order3 expression | 
        expression op_order2 expression | 
        '-' expression %prec UMINUS  |
        '(' expression ')';
    bool_exp:
        expression {Trace("exp \n");}|
        '(' bool_exp ')'|
        '!' bool_exp {Trace("!bool_exp \n");}|
        bool_exp op_order8 bool_exp | 
        bool_exp op_order7 bool_exp | 
        bool_exp op_order6 bool_exp | 
        bool_exp op_order5 bool_exp ;
        


    compound:
        '{' '}'|
        '{' statements '}';
    func_invoke:
        ID '(' identifier_list ')';
    condition:
        IF '(' bool_exp ')' statement|
        IF '(' bool_exp ')' statement ELSE statement;
    for_loop:
        FOR '(' bool_exp ')' simple_statement|
        FOR '(' bool_exp ')' compound|
        FOR '(' statement ';' bool_exp ')' simple_statement|
        FOR '(' statement ';' bool_exp ')' compound|
        FOR '(' bool_exp ';' statement ')' simple_statement|
        FOR '(' bool_exp ';' statement ')' compound|
        FOR '(' statement ';' bool_exp ';' statement ')' simple_statement|
        FOR '(' statement ';' bool_exp ';' statement ')' compound;
    go:
        GO ID '(' identifier_list ')';

        
%%

int yyerror(char *s)
{
    
    // printf("%d:  %s:  \n", linenum, s);
    printf("666:  %s:  \n", s);

    return 0;
    // char *msg;
    // {
    //     fprintf(stderr, "%s\n", msg);
    // }
}

int main(int argc, char const *argv[])
{
    // currentSTE = st.create();
    // yylex(); 
    /* code */
    // show symbol table
    // st.dump(&currentSTE);
    // return 0;
    yyparse();
}