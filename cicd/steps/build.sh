#!/usr/bin/env bash

WORKSPACE_DIR=$PWD

echo $WORKSPACE_DIR
echo $DRONE_BUILD_KEY

if [[ $DRONE_BUILD_KEY == "pipeline_1" ]]
then
    echo "pipeline_1->build started!"
    echo "pipeline_1->build finished!"
elif [[ $DRONE_BUILD_KEY == "pipeline_2" ]]
then
    echo "pipeline_2->build started!"
    echo "pipeline_2->build finished!"
else
    echo "Pipeline $DRONE_BUILD_KEY did nothing in this step"
fi