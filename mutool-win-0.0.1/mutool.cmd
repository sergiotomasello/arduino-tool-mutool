::
:: Merge and Upload Tool for Arduino Core nRF52 boards
::
:: Copyright (c) 2017, Arduino Srl <swdev@arduino.org>
::
:: @author Sergio Tomasello <sergio@arduino.org>
:: @author Arturo Rinaldi <arturo@arduino.org>
:: @licence MIT License
::
:: Usage:
:: mutool -u <path-to-openocd-bin> -s <path-to-openocd-scripts> -t <path-to-openocd-board-script-file> -m <path-to-mergehex-bin> -f <[files-to-merges]>
::

@ECHO OFF

:GETOPTS
	if /I (%1)==() goto HELP
	if /I %1 == -h goto HELP
	if /I %1 == -u set OPENOCD_BIN=%2& shift
	if /I %1 == -s set OPENOCD_SCRIPT_PATH=%2& shift
	if /I %1 == -t set OPENOCD_VARIANT_SCRIPT=%2& shift
	if /I %1 == -m set MERGE_TOOL=%2& shift
	if /I %1 == -f set FILE_1=%2& set FILE_2=%3& set FILE_3=%4& shift
	shift
	if not (%1)==() goto GETOPTS
	GOTO FLASH

:HELP
	@ECHO OFF
	ECHO.
	ECHO Merge and Upload Tool for Arduino Core nRF52 boards
	ECHO.
	ECHO "USAGE : mutool.cmd -u <path-to-openocd-bin> -s <path-to-openocd-scripts> -t <path-to-openocd-board-script-file> -m <path-to-mergehex-bin> -f <[files-to-merges]>"
	ECHO.
	ECHO 	-u OpenOCD binary
	ECHO 	-s script file path
	ECHO 	-t OpenOCD board variant
	ECHO 	-m merge tool
	ECHO 	-f file(s) to merge and then upload
	ECHO.

	Exit /b 1

:FLASH
	set OUTPUT_FILE=%TEMP%\output.hex

	%MERGE_TOOL% --merge %FILE_1% %FILE_2% %FILE_3% --output %OUTPUT_FILE% --quiet

	ECHO.
	ECHO "uploading..."
	ECHO.

	"%OPENOCD_BIN%" -s "%OPENOCD_SCRIPT_PATH%" -f "%OPENOCD_VARIANT_SCRIPT%" -c "program %OUPUT_FILE% verify reset exit"
