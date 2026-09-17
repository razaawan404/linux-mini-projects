#!/usr/bin/env bash

while getopts ":f:t:" as opts
do

	case "$opts" in

		f) log_file="$OPTARG" ;;
		t) 
