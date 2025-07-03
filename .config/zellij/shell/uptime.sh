#!/bin/bash

uptime -p | sed -e 's/up //' -e 's/ days\?/d/' -e 's/ hours\?/h/' -e 's/ minutes\?/m/' -e 's/ weeks\?/w/'  -e 's/ week\?/w/' -e 's/,//g' -e 's/ //g'
