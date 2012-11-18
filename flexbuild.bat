set WORKSPACE=%cd%
"C:\Program Files (x86)\Adobe\Adobe Flash Builder 4.6\FlashBuilderC.exe" ^
    --launcher.suppressErrors ^
    -noSplash ^
    -application org.eclipse.ant.core.antRunner ^
    -data "%WORKSPACE%" ^
    -file "%cd%\flexbuild.xml"
