# eclair_report

# This file must not be renamed: it is referenced by report_*.ecs.
#
# The aim of this file is to define the eclair_report configuration
# common to all GUI-driven analyses.
#
# The essential portions of this file are marked with "# NEEDED":
# they may be adapted of course.

# NEEDED: load the eclair_report settings common to all (GUI-driven,
# CLI-driven or IDE-driven) analyses.
-eval_file=report__common.ecl

# NEEDED: load the eclair_report settings to generate textual reports.
-eval_file=report__textual.ecl
