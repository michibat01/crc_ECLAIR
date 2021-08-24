# eclair_report

# This file must not be renamed: it is referenced by report__cli.ecl,
# report__gui.ecl and eclair_make.sh.
#
# The aim of this file is to define the eclair_report configuration
# to generate textual reports.

# Output report summaries in ODT format.
-summary_odt=join_paths(output_dir,"odt")
# Output report summaries in ODT format.
-summary_doc=join_paths(output_dir,"doc")
# Output report summaries in pure text format.
-summary_txt=join_paths(output_dir,"txt")
# Output metrics for use with spreadsheet applications (if enabled).
-metrics_tab=join_paths(output_dir,"metrics")
# Output reports for use with spreadsheet applications
-reports_tab=join_paths(output_dir,"reports")

