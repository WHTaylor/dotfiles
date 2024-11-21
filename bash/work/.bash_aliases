alias set-java-8="export JAVA_HOME=\"/c/Program Files/Eclipse Adoptium/jdk-8.0.432.6-hotspot/\""
alias set-java-17="export JAVA_HOME=\"/c/Program Files/Eclipse Adoptium/jdk-17.0.13.11-hotspot/\""
alias set-java-21="export JAVA_HOME=\"/c/Program Files/Eclipse Adoptium/jdk-21.0.5.11-hotspot/\""

alias python="winpty python.exe"

alias nunit="nunit3-console.exe"

alias apps="cd $APPS_HOME_DIR"
alias fbs="cd /c/FBS/Apps"

alias update_wsdl='py $APPS_HOME_DIR/internal-scripts/wsdl-updater/wsdl_updater.py'
alias search_code="grep -rI --exclude={\*.wsdl,Reference.cs,Reference1.cs,\*.html,\*.class,\*.xml,\*.xsd,\*.designer.cs} --exclude-dir={bin,obj,.git}"
