#!/bin/bash
#
#
# Env variables:
#
# SCENARIOS_ROOT - path where scale-scenarios repo is mounted
# RALLY_SCENARIOS - scenarios to run, file or directory (scenarios root relatively)
# RALLY_TASK_ARGS - argument file that is used for throttling settings
# KUBECONFIG - path where kubeconfig file is mounted (required for rally create env)


SCENARIOS_ROOT=${SCENARIOS_ROOT:-/scale-scenarios}
RALLY_TASK_ARGS=${RALLY_TASK_ARGS:-job-params-light.yaml}


if [[ -z $RALLY_SCENARIOS ]]
then
  echo "Please provide which scenarios to run"
  exit 1
fi

scenarios_dir="${SCENARIOS_ROOT}/${RALLY_SCENARIOS}"

if [[ ! -d $scenarios_dir ]] && [[ ! -f $scenarios_dir ]]
  then
  echo "No such file or directory $scenarios_dir"
  exit 1
fi

# create and check rally env
(rally env create --name k8s --from-sysenv && rally env check) || exit 1

# run scenarios
err_flag=
for scen in $(find $scenarios_dir -type f)
do
  rally task start $scen --task-args-file ${SCENARIOS_ROOT}/$RALLY_TASK_ARGS || \
    err_flag=1
done

# report results
date=$(date +%d%m%Y-%H%M%S)
rally task report --deployment k8s --out /rally-reports/rally-${date}.html
rally task report --deployment k8s --json --out /rally-reports/rally-${date}.json

if [[ -n $err_flag ]]
then
  echo "Some of the scenarios failed"
  exit 1
fi
