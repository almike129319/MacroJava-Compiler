%{
    #include <bits/stdc++.h>
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
	#include <map>
	#include <vector>
    using namespace std;
    void yyerror(const char *);
    int yylex(void);
	extern int yydebug;
	
	string unused_str = "aaaaabbbccccc";

	string give_unused(){
		
		for(char & c : unused_str){
			if((c- 'a') + 1 < 26 ){ 
				c = c + 1;
				break;
			}
		}
		return unused_str;
	}

	class macro{
		public:
		vector<string> args;
		string body;
		bool is_statement;
	};

	map<string, macro *> macros;

	bool valid_char(char c){
		if( c - 'A' >=0 and c - 'A' <= 25) return true;
		else if(c - 'a' >=0 and c - 'a' <= 25) return true;
		else if (c -'0' >= 0 and c - '0' <= 9) return true;

		return false;
	}

	// struct arg_list * curr_arg_list = new arg_list();
	vector<string> split_by_comma(string str){
		vector<string> res;
		string curr = "";
		// cout<<"to_split :"<<str<<'\n';
		for(char c : str){
			if(c == ' ') continue;
			if(c ==','){
				if(!curr.empty()) res.push_back(curr);
				curr = "";
			}
			else curr += c;
		}
		if(!curr.empty()) res.push_back(curr);
		// cout<<"splitted:\n";
		// for(string str : res){
		// 	cout<<str<<' ';
		// }
		// cout<<'\n';
		return res;
	}
	string last_token(string &body){
		int n = body.size();
		int i = n-1;
		while(i>=0 and body[i] == ' ') i--;

		if(i<0) return "";
		if(body[i] == '.') return ".";
		int end = i;
		while(i>=0 and body[i] != ' ') i--;

		int start = i+1;
		return body.substr(start,end - start +1);
	}

	string modify_body(string &macro_name,string &passed_args_list){

		char * error = strdup(("macro_not_found"));
		if(macros.find(macro_name) == macros.end()) yyerror(error);
		
		macro * m = macros[macro_name];
		vector<string> real_args = m->args;
		string real_body = m->body;
		bool is_statement = m->is_statement;

		vector<string> passed_args = split_by_comma(passed_args_list);

		error = strdup("real and passed size not matched");
		if(real_args.size() != passed_args.size()) {
			// cout<<macro_name<<'\n';
			// cout<<real_args.size()<<'\n';
			// cout<<passed_args.size()<<'\n';
			// cout<<passed_args_list<<'\n';
			// yyerror(error);
		}
		
		int i = 0, j = 0, n = real_body.size();
		string final_body = "",curr = "";

		
		// cout<<macro_name<<'\n';
		// cout<<"passed_args:"<<passed_args_list<<'\n';
		
		// cout<<"real_body:"<<real_body<<' '<<'\n';
		
		// cout<<"real_args:";
		// for(string str :real_args)
		// 	cout<<str;
		// cout<<'\n';

		string prev_token = "";

		while(i < n){
			char c = real_body[i];
			prev_token = last_token(final_body);
			

			if(!valid_char(c)){
				// cout<<"not slides ";
				if(!curr.empty()){
					for(int k =0;k < real_args.size();k++){
						if(real_args[k] == curr){
							if(prev_token != "new" && prev_token != ".") curr = "(" + passed_args[k] + ")";
							else curr = passed_args[k];
							break;
						}
					}
					final_body += curr;
					curr = "";
				}
				final_body.push_back(c);
				i++;
			}
			else{
				curr += c;
				i++;
			}
			// cout<<curr<<' '<<i<<' '<<j<<'\n';
		}
		// 
		for(int k =0;k < real_args.size();k++){
			if(real_args[k] == curr){
				if(prev_token != "new" && prev_token != ".") curr = "(" + passed_args[k] + ")";
				else curr = passed_args[k];
				break;
			}
		}

		final_body += curr;
		// cout<<"final_body:"<<final_body<<'\n';
		return final_body;
	}
	
	string modify_exp(string var,string real_exp){
		int i = 0, j = 0, n = real_exp.size();
		string final_body = "",curr = "";
		
		string unused = give_unused();

		while(i<n){
			char c = real_exp[i];
			// cout<<c<<' '<<curr<<' ';

			if(!valid_char(c)){
				if(!curr.empty()){
					if(curr == var) curr = unused;
					final_body += curr;
					curr = "";
				}
				final_body.push_back(c);
			}
			else{
				curr += c;
			}
			i++;
			// 
		}
		if(curr == var) curr = unused;
		final_body += curr;
		return final_body;
	}

%}

%debug

%union {
	char * str;
}

%token <str> IDENTIFIER INTEGER_LITERAL
%token <str> HASH DEFINE MAIN CLASS EXTENDS PUBLIC STATIC VOID INT STRING BOOLEAN TRUE FALSE IF ELSE DO WHILE RETURN PRINT NEW THIS LENGTH FUNCTION
%token <str> EQ NEQ LEQ AND OR PLUS MINUS MUL DIV NOT GT LT 
%token <str> CURLY_OPEN CURLY_CLOSE PAREN_OPEN PAREN_CLOSE SQUARE_OPEN SQUARE_CLOSE
%token <str> DOT COMMA SEMICOLON LAMBDA_ARROW IMPORTFUNCTION


%type <str> Goal mainclass typedecl type_iden method_decl param_decl printexp 
%type <str> exp primary_exp statement statements type 
%type <str> macro_definitions macro_def_exp macro_def_statement
%type <str> macro_arg_list call_macro_exp import_func



%%
Goal : import_func macro_definitions mainclass typedecl
		{
		cout<<$1<<'\n'<< $3 <<'\n'<< $4 <<'\n';
		}

import_func :
		 IMPORTFUNCTION {$$ = strdup("import java.util.function.Function;");}
		|/*epsilon*/ {$$ = strdup("");}
mainclass : 
	CLASS IDENTIFIER CURLY_OPEN 
		PUBLIC STATIC VOID MAIN PAREN_OPEN STRING SQUARE_OPEN SQUARE_CLOSE IDENTIFIER PAREN_CLOSE CURLY_OPEN 
			printexp 
		CURLY_CLOSE
	CURLY_CLOSE
		{ 
			$$ = strdup(
				("class " + string($2) +
				 " {\n\tpublic static void main (String [] " + string($12) +
					 ") {\n\t"  + string($15) + "\n}\n}"
				 ).c_str()
				);
		}

printexp :
	PRINT PAREN_OPEN exp PAREN_CLOSE SEMICOLON 
		{ 
			$$ = strdup(("System.out.println( " + string($3) + " );\n").c_str());
		}

typedecl :
	CLASS IDENTIFIER CURLY_OPEN type_iden method_decl CURLY_CLOSE typedecl 
		{
			$$ = strdup(
				("class " + string($2) +
				 "{\n\t" + string($4) + "\t" + string($5) + "\t\n}\n" + string($7)).c_str());
		}
	| CLASS IDENTIFIER EXTENDS IDENTIFIER CURLY_OPEN type_iden method_decl CURLY_CLOSE typedecl 
		  { 
			$$ = strdup(
				("class " + string($2) + " extends " + string($4) +
				 " {\n\t" + string($6) + "\t" + string($7) + "\t\n}\n" +string($9)
				 ).c_str()
				);
		  }
	| /* epsilon */ { $$ = strdup(""); }


type_iden :
		/* epsilon */ { $$ = strdup(""); }
	  	| type_iden type IDENTIFIER SEMICOLON 
		  { 
			$$ = strdup((string($1) + string($2) + " " + string($3) + ";\n" ).c_str());
		  }

/* variabe_decl : */
		
		
method_decl :
	   	PUBLIC type IDENTIFIER PAREN_OPEN param_decl PAREN_CLOSE CURLY_OPEN type_iden statements RETURN exp SEMICOLON CURLY_CLOSE method_decl
		{
			$$ = strdup((
				"public "+ string($2) + " " + string($3) + "( " + string($5) + " ){\n\t"
					+ string($type_iden) + "\n\t" + string($statements) +
					"\nreturn " + string($exp) + ";\n}\n" + string($14)
			).c_str());
		}
		| /* epsilon */ { $$ = strdup(""); }


param_decl :
	  	type IDENTIFIER COMMA param_decl 
			{
				$$ = strdup((
					string($1) + " " + string($2) + ", " + string($4)
				).c_str());
			}
	  	| type IDENTIFIER{
			$$ = strdup((string($1) + " " + string($2)).c_str());
		}
	  	| /* epsilon */ { $$ = strdup(""); }

type :
	INT SQUARE_OPEN SQUARE_CLOSE { $$ = strdup("int[ ] ");  }
	| INT { $$ = strdup(" int "); }
	| BOOLEAN { $$ = strdup(" boolean "); }
	| IDENTIFIER { $$ = strdup((string($1) + " ").c_str()); }
	| FUNCTION LT IDENTIFIER COMMA IDENTIFIER GT
		{
			$$ = strdup(("Function<" + string($3) + " , " + string($5) + ">" ).c_str());
		}

statements :
	  	statement statements   
		{
			$$ = strdup((
				string($1) + string($2)
			).c_str()); 
		}
	  	| /* epsilon */ {$$ = strdup(""); }

statement :
	  	CURLY_OPEN statements CURLY_CLOSE {$$ = strdup(("{\n\t" + string($2) + "\t\n}").c_str());}
	  	
		| printexp {$$ = strdup($1);}
	  	
		| IDENTIFIER EQ exp SEMICOLON {$$ = strdup((string($1) + " = " + string($3) + ";\n").c_str());}
		
		| IDENTIFIER SQUARE_OPEN exp SQUARE_CLOSE EQ exp SEMICOLON 
			{$$ = strdup((string($1) + "[ " + string($3) + " ] = " + string($6) + ";\n").c_str());}
		/* | matched_if
		| unmatched_if */
		| IF PAREN_OPEN exp PAREN_CLOSE statement ELSE statement
			{ $$ = strdup(("if( " + string($3) + " )\n\t" + string($5) + "\nelse\n\t" + string($7)).c_str()); }
		
		| IF PAREN_OPEN exp PAREN_CLOSE statement
			{ $$ = strdup(("if( " + string($3) + " )\n\t" + string($5)).c_str()); }
		
		| WHILE PAREN_OPEN exp PAREN_CLOSE statement
			{ $$ = strdup(("while( " + string($3) + " )\n\t" + string($5)).c_str()); }
		
		| DO statement WHILE PAREN_OPEN exp PAREN_CLOSE SEMICOLON
			{ $$ = strdup(("do " + string($2) + " \nwhile( " + string($5) + " );").c_str()); }
		
		/*macro statements*/
		| IDENTIFIER PAREN_OPEN macro_arg_list PAREN_CLOSE SEMICOLON 
			{
				string macro_name = string($1);
				if(macros.find(macro_name) == macros.end() ||!macros[macro_name]->is_statement){
					yyerror("");
				}
				string passed_args_list = string($3);
				string final_body = modify_body(macro_name,passed_args_list);
				// cout<<"stat "<<macro_name<<' '<<final_body<<'\n';
				$$ = strdup((
					 final_body
				).c_str());

			}

/* matched_if : 
		|	IF PAREN_OPEN exp PAREN_CLOSE matched_if ELSE  */


exp :
		primary_exp AND primary_exp{ $$ = strdup((string($1) + " && " +string($3)).c_str()); }
		| primary_exp OR primary_exp { $$ = strdup((string($1)+ " || " +string($3)).c_str()); }
		| primary_exp NEQ primary_exp { $$ = strdup((string($1)+ " != " +string($3)).c_str()); }
		| primary_exp LEQ primary_exp { $$ = strdup((string($1)+ " <= " +string($3)).c_str()); }
		| primary_exp PLUS primary_exp { $$ = strdup((string($1)+ " + " +string($3)).c_str()); }
		| primary_exp MINUS primary_exp	{ $$ = strdup((string($1)+ " - " +string($3)).c_str()); }
		| primary_exp MUL primary_exp	{ $$ = strdup((string($1)+ " * " +string($3)).c_str()); }
		| primary_exp DIV primary_exp	{ $$ = strdup((string($1)+ " / " +string($3)).c_str()); }
		| primary_exp SQUARE_OPEN primary_exp SQUARE_CLOSE
			{ $$ = strdup((string($1) + "[" + string($3) + "] ").c_str()); }
		| primary_exp DOT LENGTH { $$ = strdup((string($1) + ".length").c_str()); }
		| primary_exp { $$ = strdup($1); }

		| primary_exp DOT IDENTIFIER PAREN_OPEN macro_arg_list PAREN_CLOSE /*function call*/
			{ $$ = strdup((string($1) + "." + string($3) + "(" + string($5) + ") ").c_str()); }
		
		| call_macro_exp{ $$ = strdup( $1 );} 
		
		| PAREN_OPEN IDENTIFIER LAMBDA_ARROW exp  /*lambdas*/
			{ 
				
				string final_body = modify_exp(string($2), string($4));
				string var = unused_str;
				$$ = strdup(("(" + var + ")->" + final_body).c_str()); 
				
			}


call_macro_exp : 

		IDENTIFIER PAREN_OPEN macro_arg_list PAREN_CLOSE /*macros*/
			{
				string macro_name = string($1);
				
				if(macros.find(macro_name) == macros.end() || macros[macro_name]->is_statement){
					yyerror("");
				}
				string passed_args_list = string($3);
				// cout<<"came to macro_exp expansion\n";
				string final_body = modify_body(macro_name,passed_args_list);
				// cout<<final_body<<'\n';
				// cout<<macro_name<<' '<<final_body<<'\n';
				
				$$ = strdup((
					"(" + final_body + ")"
				).c_str());
				
			}
			
primary_exp :
		INTEGER_LITERAL { $$ = strdup($1); }
		| TRUE {$$ = strdup("true");} 
		| FALSE {$$ = strdup("false");}
		| IDENTIFIER{ $$ = strdup($1); }
		| THIS { $$ = strdup("this"); }
		| NEW INT SQUARE_OPEN exp SQUARE_CLOSE 
			{ $$ = strdup(("new int[" + string($4) + "]").c_str()); }
		| NEW IDENTIFIER PAREN_OPEN PAREN_CLOSE 
			{ $$ = strdup(("new " + string($2) + "( )").c_str()); }
		| NOT exp { $$ = strdup(("!" + string($2)).c_str()); }
		| PAREN_OPEN exp PAREN_CLOSE { $$ = strdup(("(" + string($2) + ")").c_str()); }



macro_definitions :
		macro_def_exp macro_definitions 
			{
				// cout<<"macro_def\n";
				$$ = strdup((string($1) + string($2)).c_str());
			}
		|macro_def_statement macro_definitions 
			{
				// cout<<"macro_state\n";
				$$ = strdup((string($1) + string($2)).c_str());
			}
		| /*epsilon*/ { $$ = strdup("");}


macro_def_statement: 
		HASH DEFINE IDENTIFIER PAREN_OPEN macro_arg_list PAREN_CLOSE CURLY_OPEN statements CURLY_CLOSE
		{
			$$ = strdup((
				"#define " + string($3) + "( " + string($5) + " ) {\n\t" + string($8) + "}\n"  
			).c_str());

			if(macros.find(string($3)) != macros.end()) yyerror($1);
			macro * a = new macro();
			a->args = split_by_comma(string($5));
			a->body = string($8);
			a->is_statement = true;
			
			macros[string($3)] = a;
		}

macro_def_exp :
		HASH DEFINE IDENTIFIER PAREN_OPEN macro_arg_list PAREN_CLOSE PAREN_OPEN exp PAREN_CLOSE
		{
			$$ = strdup((
				"#define " + string($3) + "( " + string($5) + " ) ( " + string($8) + " )\n"  
			).c_str());
			
			macro * a = new macro();
			a->args = split_by_comma(string($5));
			a->body = string($8);
			a->is_statement = false;
			
			macros[string($3)] = a;
		}

macro_arg_list :
		exp {
				$$ = strdup($1); 
			}
	  	| macro_arg_list COMMA exp { 
			$$ = strdup((string($1) + "," + string($3)).c_str()); 
		}
	  	| /*epsilon*/ { 
			// cout<<"e\n";
			$$ = strdup("");
		 }

%%


void yyerror(const char * s) {

    printf("// Failed to parse macrojava code.\n");
    exit(1);
}

int main(int argc, char **argv) {
    /* if (argc >= 2  && strcmp(argv[1], "--bold") == 0) {
    	bold = true;
    } */

    // printf("\e[1mhello\e[0m\n");
	yydebug = 1;
    yyparse();
}
