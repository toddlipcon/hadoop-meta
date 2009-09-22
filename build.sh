#!/bin/bash
set -e -x

if [ "$1" == "--clean" ]; then
  CLEAN=clean
else
  CLEAN=
fi

BINDIR=$(dirname $0)

#Set homes for the sub-projects
COMMON_HOME=$BINDIR/hadoop-common
HDFS_HOME=$BINDIR/hadoop-hdfs
MAPREDUCE_HOME=$BINDIR/hadoop-mapreduce

#Compile each sub-project
#Change the ant command if necessary
pushd $COMMON_HOME
ant $CLEAN jar jar-test
popd

cp $COMMON_HOME/build/*jar $HDFS_HOME/lib
cp $COMMON_HOME/build/*jar $MAPREDUCE_HOME/lib

pushd $HDFS_HOME
ant $CLEAN jar jar-test
popd

cp $HDFS_HOME/build/*jar $MAPREDUCE_HOME/lib

pushd $MAPREDUCE_HOME
ant $CLEAN compile-mapred-test jar tools examples
popd
#Copy everything to common
cp -R $HDFS_HOME/build/* $MAPREDUCE_HOME/build/* $COMMON_HOME/build
