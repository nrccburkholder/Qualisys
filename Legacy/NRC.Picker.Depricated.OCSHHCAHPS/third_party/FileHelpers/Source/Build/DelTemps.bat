@echo off
@cd ..
@rmdir /S /Q "FileHelpers\obj"
@rmdir /S /Q "FileHelpers.Tests\obj" 
@rmdir /S /Q "FileHelpers.Tests\Release" 
@rmdir /S /Q "FileHelpers.Demos\Release"
@rmdir /S /Q "FileHelpers.Demos\obj"
@rmdir /S /Q "FileHelpers.Benchmarks\obj"
@rmdir /S /Q "FileHelpers.Benchmarks\bin"
@rmdir /S /Q "FileHelpers.CodeExamples\Example CSharp\obj"
@rmdir /S /Q "FileHelpers.CodeExamples\Example VbNet\obj"
@rmdir /S /Q "FileHelpers.CodeExamples\Example CSharp - VS 2005\obj"
@rmdir /S /Q "FileHelpers.CodeExamples\Example VbNet - VS 2005\obj"
@rmdir /S /Q "FileHelpers.CodeExamples\Release"
@rmdir /S /Q "FileHelpers.ExcelStorage\bin"
@rmdir /S /Q "FileHelpers.ExcelStorage\obj"
@rmdir /S /Q "FileHelpers.WizardApp\obj"

@rmdir /S /Q "CloverBuild"
@rmdir /S /Q "CloverReport"
@rmdir /S /Q "Release"
@rmdir /S /Q "ReleaseDemo"
@rmdir /S /Q "_ReSharper.FileHelpers"
@del /F /AH /Q "*.suo"
@del /F /Q "FileHelpers.ExcelStorage\FileHelpers.ExcelStorage.xml"
@del /F /Q "FileHelpers\FileHelpers.xml"
@del /F /Q "FileHelpers\FileHelpersPPC.xml"
@del /F /Q "*.user"
@del /F /Q "FileHelpers.CodeExamples\*.suo"
@del /F /Q "Doc\Include\Thumbs.db"
