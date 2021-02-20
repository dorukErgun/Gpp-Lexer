%{  
    /*This variable is used to determine close quotes or open*/
    int is_OP_OC = 0;
		FILE *fp;
%} 

%%
"and" {fprintf(fp, "KW_AND\n");}
"or" {fprintf(fp, "KW_OR\n");}
"not" {fprintf(fp, "KW_NOT\n");}
"equal" {fprintf(fp, "KW_EQUAL\n");}
"less" {fprintf(fp, "KW_LESS\n");}
"nil" {fprintf(fp, "KW_NIL\n");}
"list" {fprintf(fp, "KW_LIST\n");}
"append" {fprintf(fp, "KW_APPEND\n");}
"concat" {fprintf(fp, "KW_CONCAT\n");}
"set" {fprintf(fp, "KW_SET\n");}
"deffun" {fprintf(fp, "KW_DEFFUN\n");}
"for" {fprintf(fp, "KW_FOR\n");}
"if" {fprintf(fp, "KW_IF\n");}
"exit" {fprintf(fp, "KW_EXIT\n");}
"load" {fprintf(fp, "KW_LOAD\n");}
"disp" {fprintf(fp, "KW_DISP\n");}
"true" {fprintf(fp, "KW_TRUE\n");}
"false" {fprintf(fp, "KW_FALSE\n");}

"+" {fprintf(fp, "OP_PLUS\n");} 
"-" {fprintf(fp, "OP_MINUS\n");} 
"/" {fprintf(fp, "OP_DIV\n");} 
"*" {fprintf(fp, "OP_MULT\n");}  
"(" {fprintf(fp, "OP_OP\n");} 
")" {fprintf(fp, "OP_CP\n");} 
"**" {fprintf(fp, "OP_DBLMULT\n");} 
"," {fprintf(fp, "OP_COMMA\n");}
["] { 
        if(is_OP_OC == 0){
            is_OP_OC = 1;
            fprintf(fp, "OP_OC\n");
        }
        else{
            is_OP_OC = 0;
            fprintf(fp, "OP_CC\n"); 
        }
}

";;".* {fprintf(fp, "COMMENT\n");}
[ \t\n\r] {/**/}
"\n\n" {return 0;}


"0" {fprintf(fp, "VALUE\n");}
[1-9][0-9]* {fprintf(fp, "VALUE\n");}
[a-zA-Z_][a-zA-Z0-9_]* {fprintf(fp, "IDENTIFIER\n");}
[0-9][a-zA-Z0-9_]* {fprintf(fp, "SYNTAX ERROR - Identifiers cant have leading zeros.\n");}

. {fprintf(fp, "SYNTAX ERROR %s cannot be tokenized.\n",yytext);}

%%

int yywrap(){} 
int main(int argc, char const *argv[]){


	fp = fopen("parsed_cpp.txt", "w+");
	
	yyin = NULL;
	if(argc > 0){
		yyin = fopen(argv[1],"r");
		yylex();
	}
	else{
		yyin = stdin;
		while(1){
		yylex();
		}
	}

	fclose(fp);
	return 0;
}