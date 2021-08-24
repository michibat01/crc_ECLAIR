# eclair_report

# This file must not be renamed: it is referenced by eclair-make.sh
#
# The aim of this file is to define the eclair_report configuration
# common to IDE analyses.

quiet()

# NEEDED: set the variable for the binary output directory from the environment
# variable.
setq(data_dir,getenv("ECLAIR_DATA_DIR"))

# NEEDED: set the variable for the ECLAIR project database from the environment
# variable.
setq(ecd_file,getenv("ECLAIR_PROJECT_ECD"))

# NEEDED: set the variable for the output directory from the environment
# variable.
setq(output_dir,getenv("ECLAIR_OUTPUT_DIR"))

if(file_exists(ecd_file),
   db(ecd_file),
 create_db(ecd_file))

server_root("")
server("changing")

setq(loaded_dir,join_paths(data_dir,"loaded"))
make_dirs(loaded_dir)

# NEEDED: generate the ecd from frame files
strings_map("load_ecb",500,"",".+\\.ecb",0,setq(ecb,join_paths(data_dir,$0)),load(ecb),rename(ecb,join_paths(loaded_dir,$0)))
strings_map("load_ecb",500,"",".*",0)

map_strings("load_ecb", dir_entries(data_dir))

# NEEDED: load the eclair_report settings common to all (GUI-driven,
# CLI-driven or IDE-driven) analyses.
eval_file("report__common.ecl")

if(string_equal(or(getenv("TEXTUAL_REPORTS"),"false"),"true")
   eval_file("report__textual.ecl"))

# Open the browser if ECLAIR report server is running.
browser()

server("changed")

