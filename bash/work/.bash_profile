export APPS_HOME_DIR="/c/Users/rop61488/Documents/Apps"
export PAYARA_DOMAINS_DIR="C:\\payara\\domains"
export DEV_LOGS="\\\\fitbawebdev\\d$\\payara\\domains\\domain1\\logs"
export PROD_LOGS="\\\\fitbaweb1\\d$\\payara\\domains\\domain1\\logs"
export LOCAL_LOGS="$PAYARA_DOMAINS_DIR/domain1/logs"
export ICAT_HOME_DIR="~/projects/isis-icat"

export PATH="$PATH:/c/payara/installations/payara-4.1.2.181/payara41/bin:/usr/local/bin/nunit-3.12/net35"
export CDPATH=".:$APPS_HOME_DIR:$ICAT_HOME_DIR"

alias python="winpty python.exe"

alias nunit="nunit3-console.exe"

alias apps="cd $APPS_HOME_DIR"
alias fbs="cd /c/FBS/Apps"

alias mvnci="mvn clean install -DskipTests -Dmaven.javadoc.skip=true"
alias mvni="mvn install -DskipTests -Dmaven.javadoc.skip=true"
alias bgb='mvnci &> ~/build &'

alias update_wsdl='py $APPS_HOME_DIR/ISISBusApps/Tools/WsdlUpdater/wsdl_updater.py'
alias search_code="grep -rI --exclude={\*.wsdl,Reference.cs,Reference1.cs,\*.html,\*.class,\*.xml,\*.xsd,\*.designer.cs} --exclude-dir={bin,obj,.git}"

alias morning="start_payara 1 & docker start oracleXE"

# Mount main working directory as w. Will change over time
[[ -d /w ]] || subst W: C:/Users/rop61488/projects/work/LiveIngestEndToEndTests
