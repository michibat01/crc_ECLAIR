ECLAIR 3.11 crc Linux GCC Eclipse CDT Demo
==========================================






This package provides a small demonstration of some ECLAIR capabilities, both
when used from its GUI and when used in batch mode.

The package contains an open-source project written in C.

Please, note that this demo package does not contain ECLAIR 3.11.*: you should
have it already installed somewhere in the system.

The demo assumes that:

- the PATH environment variable has been set accordingly, otherwise
  you should edit ECLAIR/eclair_settings.sh (ECLAIR_PATH variable)

The demo can be easily adapted or extended to different eclipse CDT based
projects, to do that you need to:

1) Edit settings.sh (WORKSPACE_DIR and ECLIPSE variables)

2) Edit ECLAIR/eclair_settings.sh (TOOLCHAIN_DIR and the intercepted toolchain
variables)

3) Launch the eclair_gui and edit `Toolchain' step accordingly

All scripts and ecl files are fully documented with comments.

GUI Use
-------

To launch the ECLAIR GUI, do the following from the demo root directory:

$ eclair_gui crc.ecs

Depending on your Unix desktop software, it may be possible to associate the
filename extension `.ecs' (mnemonic for "ECLAIR settings") to the `eclair_gui'
application.  If you do that, then the easiest way to launch the ECLAIR GUI is
to double-click on file `crc.ecs'.

In the GUI you can explore the various sections to get a feeling of what you can
configure and how.  If you are in a hurry, just go to the `Run' step and click
on the `> Run' button.  When the analysis is finished, close the message window
informing you of this fact, then go to the `View' step and click on `View', to
see the detailed reports, or `Browse' to see the `metrics', `txt', `reports'
and `odt' directories and a directory called `run...' containing various log
files and the configuration used for the specific run.

In the `metrics' directory you will find the computer HIS metrics in a format
suitable for use with Microsoft Excel, LibreOffice Calc, and OpenOffice.org
Calc.

With LibreOffice Calc (or the equivalent OpenOffice.org Calc) open the file
`pivot.ods' making sure macros are enabled. If asked whether to update the links
to other files, do accept. The "Threshold" sheet, containing examples of
thresholds for some metrics, will be displayed: please make sure you set the
thresholds according to your needs and coding standards.  Then click on the
"Pivot" sheet tab, click on cell A1, containing "File" on a blue background, and
select file `HIS_metrics.txt` in the current directory. Then click on cell B2
and select "function", "unit" or "program" to see the values for metrics defined
for that scope. The procedure is the same for Microsoft Excel: just open
`pivot.xlsm' instead of `pivot.ods'. Please note that the pivot tables provided
with this demo are just examples: feel free to adapt them to meet your needs.

In the `txt' directory you will find various summaries in pure text format.

In the directory `odt' you will find a printable summary report in OpenOffice
format.  To see that open `book.odt', then to build the summary click on:
Tools -> Update -> Update All.

In the `reports' directory you will find two spreadsheet files containing a
summary report, one in a format suitable for use with Microsoft Excel, the other
in a format suitable for the use with LibreOffice Calc, and OpenOffice.org Calc.

With LibreOffice Calc (or the equivalent OpenOffice.org Calc) open the file
`reports.ods' making sure macros are enabled. If asked whether to update the
links to other files, accept. Then click on the "pivot" sheet tab, click on cell
A1, containing "File" on a blue background, and select file `reports.txt` in
the current directory. Click on cell B1 to wrap the text in every cell.
Use the cells A3 and B3 to show more or less details. The procedure is
the same for Microsoft Excel: just open `reports.xlsm' instead of `reports.ods'.

It is possible to use the GUI in headless mode.  For example, in order to
instruct ECLAIR to perform an analysis and then browse the results, one can do
the following:

# The following command performs the analysis specified
# for the `CRC_32' configuration of `crc.ecs'.
$ eclair_gui --headless --run CRC_32 crc.ecs

# Interactive mode now: click `View' and see the results.
$ eclair_gui crc.ecs.

Batch Use: Analysis with Respect to a Coding Standard
-----------------------------------------------------

For the analysis with respect to the coding standard defined by the
configuration file in `ECLAIR/analyze_<RULESET>.ecl':

$ cd ECLAIR

$ ./analyze.sh <RULESET> <PROJECT> [<BUILD_CONFIG>]

Where:

- <RULESET> is either MC3 or HIS

- <PROJECT> is the project name (crc)

- optional <BUILD_CONFIG> is either Debug or Release (default Release)

This command will perform a cascade process:

1) It will clean the project

2) It will perform a build and an ECLAIR analysis on the project

3) It will open a web browser (or reuse an already-opened one) to show
   the detailed reports, as well as a file browser to let you inspect
   the other products of the analysis in a folder named
   `out_<RULESET>'.  There you will find files
   called `ANALYSIS.log' containing ECLAIR diagnostic output, a
   directory `txt' containing various analysis summaries in text
   format, a directory `odt' containing a printable report in
   OpenOffice format and possibly a directory `metrics' containing
   metrics that can be browsed in a spreadsheet.


IDE use:  Analysis with Respect to a Coding Standard
----------------------------------------------------

To open the crc project with an Eclipse based IDE:

1) Launch the eclipse based IDE

2) If you have not already, install the current version of
   ECLAIR plugin for eclipse, as described in the user manual

3) Select `File' -> `Open Projects from File System...'

4) Click on `Directory' and select the `crc' folder.

5) Click on 'Finish`

Before performing an analysis it is recommended to `Enable' the ECLAIR plugin
from the top bar menu.

To analyze the project or a single file of it:

1) Select `Project' -> `Build Configurations' -> `Set Active' -> `ECLAIR ...'
   in the top bar menu.

2) Select `Project' -> `Build Project' in the top bar menu.

To generate metrics for the project:

1) Select `Project' -> `Properties' -> `C/C++ Build` in the top bar menu.

2) Select an ECLAIR build configuration

3) Select `Environment'

4) Change `RULESET' environment to `HIS'

5) Select `Apply and Close'

6) Launch a build on that configuration

The available `Build Configurations' for this demo are:

- ECLAIR
  which runs an incremental analysis (that is, only what is compiled/linked
  is analyzed) of the selected configuration (environment variable `BUILD_CONFIG'
  as set in `C/C++ Build' -> `Environment' in project config);

- ECLAIR_STU
  as above, but analyzing only single translation units
  (i.e., skip analysis of programs and project)

- ECLAIR_FILE
  as above, but analyzing only the current file selected in IDE.

- ECLAIR_FINAL
  as `ECLAIR', but this generates textual reports.

The environment variables in `C/C++ Build' -> `Environment' are:

- ANALYSIS_MODE

  - full
    Full analysis.

  - stu-only
    Single translation units only analysis (i.e., skip analysis of programs and project).

  - single-file
    Single file analysis.

- BUILD_CONFIG
  The eclipse build configuration to be analyzed.

- PROJECT_NAME
  The eclipse project name (it should be identical to project folder name).

- RULESET
  The file used to configure the analysis will be `analysis_${RULESET}.ecl'.

- SELECTED_FILE
  The absolute path of single file to analyze when `ANALYSIS_MODE' is `single-file'

- TEXTUAL_REPORTS
  `true' if textual report should be generated at the end of the analysis.


Package Contents
----------------

ECLAIR-3.11_demo_crc_Linux_GCC_Eclipse_CDT
|-- build.sh
|-- clean.sh
|-- crc
|   `-- src
|       |-- crc.c
|       |-- crc.h
|       |-- main.c
|       |-- reflect.c
|       `-- reflect.h
|-- crc.ecs
|-- ECLAIR
|   |-- analysis_check_rules.ecl
|   |-- analysis__cli.ecl
|   |-- analysis__common.ecl
|   |-- analysis__gui.ecl
|   |-- analysis_HIS.ecl
|   |-- analysis_MC3.ecl
|   |-- analysis__stu.ecl
|   |-- analyze.sh
|   |-- browse.ecl
|   |-- browse.sh
|   |-- changing.ecl
|   |-- eclair_make.sh
|   |-- eclair_settings.sh
|   |-- report_build_reports.ecl
|   |-- report__cli.ecl
|   |-- report__common.ecl
|   |-- report__gui.ecl
|   |-- report__ide.ecl
|   `-- report__textual.ecl
|-- README.txt
`-- settings.sh

3 directories, 29 files
