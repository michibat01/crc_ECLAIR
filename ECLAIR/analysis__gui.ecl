# This file must not be renamed: it is referenced by analysis_check_rules.ecl.
#
# The aim of this file is to define the ECLAIR configuration common to all
# GUI-driven analyses.
#
# The essential portions of this file are marked with "# NEEDED":
# they may be adapted of course.

# NEEDED: load the ECLAIR settings common to all (GUI-driven, CLI-driven or
# IDE-driven) analyses.
-eval_file=analysis__common.ecl
