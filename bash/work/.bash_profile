export APPS_HOME_DIR="/c/Users/rop61488/projects/busapps"
export ICAT_HOME_DIR="~/projects/icat"

export DEV_LOGS="\\\\fitbawebdev\\d$\\payara\\domains\\domain1\\logs"
export PROD_LOGS="\\\\fitbaweb1\\d$\\payara\\domains\\domain1\\logs"

export CDPATH=".:$APPS_HOME_DIR:$ICAT_HOME_DIR"

export INGEST_XMLS_DIR="/c/fbs/other/IngestExternalXmls"

alias python="winpty python.exe"

alias nunit="nunit3-console.exe"

alias apps="cd $APPS_HOME_DIR"
alias fbs="cd /c/FBS/Apps"

alias update_wsdl='py $APPS_HOME_DIR/internal-scripts/wsdl-updater/wsdl_updater.py'
alias search_code="grep -rI --exclude={\*.wsdl,Reference.cs,Reference1.cs,\*.html,\*.class,\*.xml,\*.xsd,\*.designer.cs} --exclude-dir={bin,obj,.git}"
