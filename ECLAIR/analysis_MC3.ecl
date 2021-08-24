# This file must be named analyze_<RULESET>.ecl, where <RULESET> is the first
# argument of analyze.sh.
#
# The aim of this file is to define the analysis configuration for <RULESET>.
#
# The essential portions of this file are marked with "# NEEDED":
# they may be adapted of course.

# NEEDED: load ECLAIR settings common to all (CLI-driven or IDE-driven) analyses.
-eval_file=analysis__cli.ecl

# Enable MISRA C:2012 Revision 1 Amendment 2 guidelines' checkers.
-enable=MC3R1
