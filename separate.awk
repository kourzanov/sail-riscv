#!/usr/bin/env -S gawk -f
BEGIN { if (!Prefix) Prefix="x"; map["model_"]=Prefix "ext_"; map[Prefix "PC"]="zPC"}
/sail_rts_set_coverage_file/ { next }
{ $0=gensub(/kind_z/,"kind_" Prefix,"g",gensub(/\<zast\>/,Prefix "ast","g",gensub(/z([A-Z])/,Prefix "\\1","g",gensub(/(struct|enum) z/,"\\1 " Prefix,"g",$0)))) }
/^typedef/               { s=substr($4,1,length($4)-1); gsub(/^z/,Prefix,$4); map[s]=substr($4,1,length($4)-1) 
			   e = 1; n = 0 }
/^(struct|enum)/ { if (NF==3 && match($0,/;$/)) $0="static " $0;
	           else  { e = 1; n = 0 }
	         }
/^\/\/ register/ { reg = 1 }
/^[^/]/ && reg { reg = 0; if ($0 !~ /zpxsat/) $0="extern " gensub(/static /,"","g",$0) }
/^(sail_int|lbits)/ { $0=(reg ? "extern" : "static") " " $0; reg = 0 }
/void model_pre_exit/ { $0="static " $0 }
/^(static|extern)/ { if (reg) gsub(/^static/,"extern"); reg = 0; b = 1; n = 0; }
match($0,/^static void (CREATE|KILL)\(([^)]+)\)/,c) && c[2]==Prefix "ast"  { gsub(/^static /,"") }
match($0,/^static void ([a-z])ext_decode/,c) && c[1]==Prefix  {
	if ($0 ~ /;$/) next; gsub(/^static /,"") }
match($0,/^static void ([a-z])print_insn/,c) && c[1]==Prefix  {
	if ($0 ~ /;$/) next; gsub(/^static /,"") }
match($0,/^static enum ([a-z])Retired ([a-z])execute/,c) && c[1]==Prefix && c[2]==Prefix {
	if ($0 ~ /;$/) next; gsub(/^static /,"") }
/^static void model_(init|fini)/ { gsub(/^static /,""); m=1 }
  { for (x in map) { gsub(x,map[x]) } }
b { n++
    b+=split($0,a,"{")-split($0,a,"}")
  }
/(setup_rts|cleanup_rts|current_exception|have_exception|throw_location)/ && m { next }
/(current_exception|have_exception|throw_location)/ && !b { s="extern"; for (i=1; i <= NF && $i != "="; i++) s=s " " $i; $0=s ";" }
e { n++
    e+=split($0,a,"{")-split($0,a,"}")
  }
b { if(Body) print
    if (n==1 && b==1 && split($0,a,";")>1) b = m = 0
    if (b==1 && n>1) { b = m = 0 }
    next
  }
e { if($0 !~ /current_exception/ && Header) print
    if (n==1 && e==1 && split($0,a,";")>1) e = 0
    if (e==1 && n>1) { e = 0 }
    next
  }
Body {print}
END { if (Header) {
  printf "void KILL(%sast)(struct %sast *op);\n",Prefix, Prefix
  printf "void CREATE(%sast)(struct %sast *op);\n",Prefix,Prefix
  printf "void %sext_decode(struct %sast *rop, uint64_t);\n",Prefix,Prefix
  printf "void %sext_init(void);\n",Prefix
  printf "void %sext_fini(void);\n",Prefix
  printf "enum %sRetired %sexecute(struct %sast);\n",Prefix,Prefix,Prefix
  printf "void %sprint_insn(sail_string *rop, struct %sast);\n",Prefix,Prefix
  #printf "size_t get_ast_size(void);\n"
  #printf "bool illegal_or_not(struct %sast *ast);\n",Prefix
} if(Body){
printf "size_t %sast_get_size(void){\n\tstruct %sast ast;\n\treturn sizeof(ast);\n}\n", Prefix, Prefix
printf "bool %sast_is_legal(struct %sast *ast){\n\tif(ast->kind != Kind_%sILLEGAL && ast->kind != Kind_%sC_ILLEGAL) {\n\t\treturn 1;\n\t}\n\treturn 0;\n}\n", Prefix, Prefix, Prefix, Prefix
printf "void %sast_apply_print(sail_string *s, struct %sast *ast){\n\t%sprint_insn(s, *ast);\n}\n", Prefix, Prefix, Prefix
printf "enum %sRetired %sast_apply_execute(struct %sast *ast){\n\treturn %sexecute(*ast);\n}\n", Prefix, Prefix, Prefix, Prefix
}}
