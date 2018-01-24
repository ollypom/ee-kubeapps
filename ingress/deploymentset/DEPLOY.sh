#!/bin/bash

echo "Label Manager Nodes"
ukp label nodes ip-172-31-16-8 opnoderole=loadbalancer

echo "Deploying all the yaml"
ukp apply -f .
