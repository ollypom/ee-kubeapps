#!/bin/bash

kubectl create secret generic mysql-pass --from-literal=password=secretstuff
