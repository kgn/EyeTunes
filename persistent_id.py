#!/usr/bin/env python
from appscript import *

print app('iTunes').current_track.persistent_ID()
