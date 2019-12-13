TWEAK_NAME = ProceduralWallpaperLoader
ProceduralWallpaperLoader_OBJCC_FILES = Tweak.xm
ProceduralWallpaperLoader_CFLAGS = -F$(SYSROOT)/System/Library/CoreServices
ProceduralWallpaperLoader_FRAMEWORKS = Foundation UIKit
ProceduralWallpaperLoader_PRIVATE_FRAMEWORKS = SpringBoardFoundation
TARGET = :clang::7.0
ARCHS = armv7 arm64
include theos/makefiles/common.mk
include theos/makefiles/tweak.mk

# If the first argument is "kill"...
ifeq (kill,$(firstword $(MAKECMDGOALS)))
  # use the rest as arguments for "kill"
  KILL_PROC := $(wordlist 2,3,$(MAKECMDGOALS))
  # ...and turn them into do-nothing targets
  $(eval $(KILL_PROC):;@:)
endif

ifeq (open,$(word 3,$(MAKECMDGOALS)))
  OPEN_PROC := $(wordlist 4,5,$(MAKECMDGOALS))
  $(eval $(OPEN_PROC):;@:)
endif

open:
	@ssh root@127.0.0.1 -p 2222 open $(OPEN_PROC)

kill::sync
	@ssh root@127.0.0.1 -p 2222 killall $(KILL_PROC)
	
sync::stage
	@rsync -rz -e "ssh -p 2222" _/Library/ root@127.0.0.1:/Library/