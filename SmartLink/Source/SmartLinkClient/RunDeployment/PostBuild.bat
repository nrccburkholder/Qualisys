REM MSBuild doesn't define DevEnvDir (but via visual studio it does) so hardcode path to devenv here:
REM I'm not reusing DevEnvDir because that confuses things since visual studio does define it


REM DevEnv needs to be changed if you are building on an x86 machine.  USE:
REM SET DevEnv=C:\Program Files\Microsoft Visual Studio 10.0\Common7\IDE\
SET DevEnv=C:\Program Files (x86)\Microsoft Visual Studio 14.0\Common7\IDE\
SET SolutionPath=%1
SET SolutionDir=%2

"%DevEnv%devenv.com" %SolutionPath% /build "Release" /project "Deployment"
IF EXIST %SolutionDir%bin\Release\ GOTO :skip
mkdir %SolutionDir%bin\Release\
:skip

copy %SolutionDir%Deployment\Release\*.msi %SolutionDir%bin\Release\

EXIT /B 0