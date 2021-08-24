# eclair_report

# This file must not be renamed: it is referenced by analyze.sh.
#
# The aim of this file is to define the ECLAIR report configuration common
# to all CLI-based analyses.
#
# The essential portions of this file are marked with "# NEEDED":
# they may be adapted of course.

# NEEDED: set the variable for the output directory from the environment
# variable.
setq(output_dir,getenv("ECLAIR_OUTPUT_DIR"))

# NEEDED: set the variable for the ECLAIR project database from the environment
# variable.
setq(ecd_file,getenv("ECLAIR_PROJECT_ECD"))

create_db(ecd_file)

load()

# NEEDED: load the eclair_report settings common to all (GUI-driven,
# CLI-driven or IDE-driven) analyses.
eval_file("report__common.ecl")

# NEEDED: load the eclair_report settings to generate textual reports.
eval_file("report__textual.ecl")
