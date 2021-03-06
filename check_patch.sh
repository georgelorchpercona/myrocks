#!/bin/bash

# check patch
# finds the next unapplied/observed patch in the sequence and does a
# git apply --check <patch>

function check_string()
{
    grep -n "$2" $1
    if [ $? -eq 0 ]; then
        echo "WARNING: Found bad string match for $2"
    fi
}

_where=$1
shift 1
if [ -z "$_where" ]; then
    echo "Missing argument for path to find patches."
    exit 1
fi

_file=`find $_where -name "*.patch" | sort | tail -1`

check_string $_file "have_rocksdb.inc"
check_string $_file "mysql-test/suite/rocksdb_"
check_string $_file " a/rocksdb"
check_string $_file " b/rocksdb"
check_string $_file " include/ut0counter"
check_string $_file "mysqld--help"
check_string $_file "thd_thread_id"
check_string $_file "/trx_info"
check_string $_file "/lock_info"
check_string $_file "restart_mysqld_with_option"
git apply --check $@ $_file
