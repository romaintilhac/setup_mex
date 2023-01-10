:: This script installs the Fortran compilers ifort and ifx provided in Intel OneAPI.
:: See https://github.com/oneapi-src/oneapi-ci
:: https://github.com/oneapi-src/oneapi-ci/blob/master/scripts/install_windows.bat
::
:: OneAPI version: 2023.0.0
::
:: Zaikun Zhang (www.zhangzk.net), January 9, 2023

:: URL for the offline installer of Intel OneAPI Fortran compiler. See
:: https://www.intel.com/content/www/us/en/developer/articles/tool/oneapi-standalone-components.html
set URL=https://registrationcenter-download.intel.com/akdlm/irc_nas/19107/w_fortran-compiler_p_2023.0.0.25579_offline.exe

:: Component to install.
set COMPONENTS=intel.oneapi.win.ifort-compiler

:: Download the installer. curl is included by default in Windows since Windows 10, version 1803.
cd %Temp%
curl.exe --output webimage.exe --url %URL% --retry 5 --retry-delay 5
start /b /wait webimage.exe -s -x -f webimage_extracted --log extract.log
del webimage.exe

:: Install the compiler.
webimage_extracted\bootstrapper.exe -s --action install --components=%COMPONENTS% --eula=accept -p=NEED_VS2017_INTEGRATION=0 -p=NEED_VS2019_INTEGRATION=0 -p=NEED_VS2022_INTEGRATION=0 --log-dir=.
set installer_exit_code=%ERRORLEVEL%

:: Run the script that sets the environment variables.
call "C:\Program Files (x86)\Intel\oneAPI\setvars.bat"

:: Show the result of the installation.
echo The latest ifort installed is:
ifort.exe /help
echo The path to ifort is:
where ifort.exe
echo The latest ifx installed is:
ifx.exe /help
echo The path to ifx is:
where ifx.exe

:: Remove the installer.
del webimage.exe
rd /s/q "webimage_extracted"

:: Exit with the installer exit code.
exit /b %installer_exit_code%
