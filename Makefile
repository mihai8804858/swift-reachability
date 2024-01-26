NAME = SwiftReachability
CONFIG = debug

GENERIC_PLATFORM_IOS = generic/platform=iOS
GENERIC_PLATFORM_MACOS = platform=macOS
GENERIC_PLATFORM_MAC_CATALYST = platform=macOS,variant=Mac Catalyst
GENERIC_PLATFORM_TVOS = generic/platform=tvOS
GENERIC_PLATFORM_WATCHOS = generic/platform=watchOS
GENERIC_PLATFORM_VISIONOS = generic/platform=visionOS

SIM_PLATFORM_IOS = platform=iOS Simulator,id=$(call udid_for,iOS,iPhone \d\+ Pro [^M])
SIM_PLATFORM_MACOS = platform=macOS
SIM_PLATFORM_MAC_CATALYST = platform=macOS,variant=Mac Catalyst
SIM_PLATFORM_TVOS = platform=tvOS Simulator,id=$(call udid_for,tvOS,TV)
SIM_PLATFORM_WATCHOS = platform=watchOS Simulator,id=$(call udid_for,watchOS,Watch)
SIM_PLATFORM_VISIONOS = platform=visionOS Simulator,id=$(call udid_for,visionOS,Vision)

GREEN='\033[0;32m'
NC='\033[0m'

build-all-platforms:
	for platform in \
	  "$(GENERIC_PLATFORM_IOS)" \
	  "$(GENERIC_PLATFORM_MACOS)" \
	  "$(GENERIC_PLATFORM_MAC_CATALYST)" \
	  "$(GENERIC_PLATFORM_TVOS)" \
	  "$(GENERIC_PLATFORM_WATCHOS)" \
	  "$(GENERIC_PLATFORM_VISIONOS)"; \
	do \
		echo -e "\n${GREEN}Building $$platform ${NC}"\n; \
		set -o pipefail && xcrun xcodebuild build \
			-workspace $(NAME).xcworkspace \
			-scheme $(NAME) \
			-configuration $(CONFIG) \
			-destination "$$platform" | xcpretty || exit 1; \
	done;

test-all-platforms:
	for platform in \
	  "$(SIM_PLATFORM_IOS)" \
	  "$(SIM_PLATFORM_MACOS)" \
	  "$(SIM_PLATFORM_MAC_CATALYST)" \
	  "$(SIM_PLATFORM_TVOS)" \
	  "$(SIM_PLATFORM_WATCHOS)" \
	  "$(SIM_PLATFORM_VISIONOS)"; \
	do \
		echo -e "\n${GREEN}Testing $$platform ${NC}\n"; \
		set -o pipefail && xcrun xcodebuild test \
			-workspace $(NAME).xcworkspace \
			-scheme $(NAME) \
			-configuration $(CONFIG) \
			-destination "$$platform" | xcpretty || exit 1; \
	done;

lint:
	swiftlint lint --strict

.PHONY: build-all-platforms test-all-platforms lint

define udid_for
$(shell xcrun simctl list devices available '$(1)' | grep '$(2)' | sort -r | head -1 | awk -F '[()]' '{ print $$(NF-3) }')
endef
