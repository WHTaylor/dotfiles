function start_payara {
    asadmin start-domain --debug --domaindir "$PAYARA_DOMAINS_DIR" "domain$1"
}

function stop_payara {
    asadmin stop-domain --domaindir "$PAYARA_DOMAINS_DIR" "domain$1"
}

function find_deploy_target {
    local source_dir;
    local target_ext="war";
    case $1 in
        users-services) source_dir="$APPS_HOME_FOLDER/users/users";;
        users-frontend) source_dir="$APPS_HOME_FOLDER/users/users";;
        schedule)       source_dir="$APPS_HOME_FOLDER/Schedule/SchedulePackage";;
        visits)         source_dir="$APPS_HOME_FOLDER/Visits/VisitsPackage";;
        proposal-lookup)source_dir="$APPS_HOME_FOLDER/Schedule/proposal-lookup";;
        *)              return -1;;
    esac
    echo $(find $source_dir -wholename $source_dir/*/target/$1*.$target_ext);
}

function deploy {
    local app_name=$(find_deploy_target $1)
    if [ -z $app_name ]; then
        echo "Application has not been built or does not exist"
        return -1;
    fi
    asadmin deploy $app_name;
}

function undeploy {
    local app_name=$(asadmin list-applications | grep $1 | cut -d ' ' -f1)
    if [ -z $app_name ]; then
        echo "No app with matching name deployed";
        return -1;
    fi

    asadmin undeploy $app_name;
}

# Go up n directories, where n is:
#  - The first argument if it's an integer, otherwise
#  - The length of the first argument
function up {
    if [ $# -eq 0 ]; then
        return 0;
    fi;

    local n;
    if [[ $1 =~ ^[0-9]+$ ]]; then
        n=$1;
    else
        n=${#1};
    fi;

    local old=$PWD;
    for ((i=0; i<$n; i++)); do
        cd ..;
    done;
    export OLDPWD=$old;
}
