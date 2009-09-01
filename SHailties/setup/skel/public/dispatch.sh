#!/bin/bash
cd ..
. vendor/SHailties/initializer.sh
initializer.run

. vendor/SHailties/dispatcher.sh
Dispatcher.dispatch
