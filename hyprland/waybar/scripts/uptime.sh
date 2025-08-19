#!/bin/bash
uptime -p | sed 's/up /↑ /; s/hours*/h/; s/minutes*/m/'
