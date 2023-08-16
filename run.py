#!/usr/bin/env python3


import os
import sys

arg = ''
if (len(sys.argv) > 1):
    arg = sys.argv[1]


if (arg == 'server'):
    os.system("cd config-server; go.exe run . debug;")
elif (arg == 'client'):
    os.system("cd config-ui; pnpm run serve;")
