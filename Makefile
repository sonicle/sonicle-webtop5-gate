#
# Copyright (C) 2017 Sonicle S.r.l.
# 
# This program is free software; you can redistribute it and/or modify it under
# the terms of the GNU Affero General Public License version 3 as published by
# the Free Software Foundation with the addition of the following permission
# added to Section 15 as permitted in Section 7(a): FOR ANY PART OF THE COVERED
# WORK IN WHICH THE COPYRIGHT IS OWNED BY SONICLE, SONICLE DISCLAIMS THE
# WARRANTY OF NON INFRINGEMENT OF THIRD PARTY RIGHTS.
# 
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for more
# details.
# 
# You should have received a copy of the GNU Affero General Public License
# along with this program; if not, see http://www.gnu.org/licenses or write to
# the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
# MA 02110-1301 USA.
# 
# You can contact Sonicle S.r.l. at email address sonicle[at]sonicle[dot]com
# 
# The interactive user interfaces in modified source and object code versions
# of this program must display Appropriate Legal Notices, as required under
# Section 5 of the GNU Affero General Public License version 3.
# 
# In accordance with Section 7(b) of the GNU Affero General Public License
# version 3, these Appropriate Legal Notices must retain the display of the
# Sonicle logo and Sonicle copyright notice. If the display of the logo is not
# reasonably feasible for technical reasons, the Appropriate Legal Notices must
# display the words "Copyright (C) 2014 Sonicle S.r.l.".
# 

TOOL_DIRS += jasperreports-maven-plugin
TOOL_DIRS += minify-maven-plugin
TOOL_DIRS += sonicle-superpom
COMPONENT_DIRS += sonicle-superpom-senchapkg
COMPONENT_DIRS += sonicle-commons
COMPONENT_DIRS += sonicle-commons-web
COMPONENT_DIRS += sonicle-mail
COMPONENT_DIRS += sonicle-security
COMPONENT_DIRS += sonicle-dav
COMPONENT_DIRS += sonicle-vfs2
COMPONENT_DIRS += sonicle-jasperreports-fonts
COMPONENT_DIRS += sonicle-extjs
COMPONENT_DIRS += sonicle-extjs-extensions
COMPONENT_DIRS += webtop-superpom
COMPONENT_DIRS += webtop-superpom-core
COMPONENT_DIRS += webtop-core-api
COMPONENT_DIRS += webtop-superpom-service-api
COMPONENT_DIRS += webtop-calendar-api
COMPONENT_DIRS += webtop-contacts-api
COMPONENT_DIRS += webtop-mail-api
COMPONENT_DIRS += webtop-tasks-api
COMPONENT_DIRS += webtop-vfs-api
COMPONENT_DIRS += webtop-core-db
COMPONENT_DIRS += webtop-core
COMPONENT_DIRS += webtop-superpom-service
COMPONENT_DIRS += webtop-calendar
COMPONENT_DIRS += webtop-contacts
COMPONENT_DIRS += webtop-mail
COMPONENT_DIRS += webtop-tasks
COMPONENT_DIRS += webtop-vfs
COMPONENT_DIRS += webtop-mattermost
DEPLOY_DIRS += webtop-webapp

BUILD_PROFILE.webtop-core-db = build-reports,profile-production
BUILD_PROFILE.webtop-core = build-reports,profile-production
BUILD_PROFILE.webtop-core-api = build-reports,profile-production
BUILD_PROFILE.webtop-calendar = build-reports,profile-production
BUILD_PROFILE.webtop-calendar-api = build-reports,profile-production
BUILD_PROFILE.webtop-contacts = build-reports,profile-production
BUILD_PROFILE.webtop-contacts-api = build-reports,profile-production
BUILD_PROFILE.webtop-mail = build-reports,profile-production
BUILD_PROFILE.webtop-mail-api = build-reports,profile-production
BUILD_PROFILE.webtop-tasks = build-reports,profile-production
BUILD_PROFILE.webtop-tasks-api = build-reports,profile-production
BUILD_PROFILE.webtop-vfs = build-reports,profile-production
BUILD_PROFILE.webtop-vfs-api = build-reports,profile-production
BUILD_PROFILE.webtop-mattermost = build-reports,profile-production
BUILD_PROFILE.sonicle-extjs-extensions = profile-production
BUILD_PROFILE.webtop-webapp = profile-production

BUILD_DIR =	$(shell pwd)

GIT = /usr/bin/git
MVN = /usr/bin/mvn -q -Dmaven.test.skip=true

TOOLS_GIT_BASE_URL=https://github.com/sonicle
TOOLS_GIT_SUFFIX=.git
COMPONENTS_GIT_BASE_URL=https://github.com/sonicle-webtop
COMPONENTS_GIT_SUFFIX=.git

all:
	@echo "Available targets: clone update build deploy"

workspace-tools:
	@(\
	 if [ ! -d sencha/cmd ]; then \
		echo "Preparing sencha cmd tools..."; \
		tar jxf workspace-tools-cmd.tar.bz2; \
	 fi; \
	 if [ ! -d sencha/workspace ]; then \
		echo "Preparing sencha workspace tools..."; \
		tar jxf workspace-tools-workspace.tar.bz2; \
	 fi; \
	)

clone: workspace-tools
	@(\
	 set -e; \
	 if [ -d components ]; then \
		echo "The components directory already exists."; \
		echo "Remove it to start a new clone of the repositories."; \
		exit 1; \
	 fi; \
	 mkdir components; \
	 cd components; \
	 for name in $(TOOL_DIRS); do \
		$(GIT) clone $(TOOLS_GIT_BASE_URL)/$$name$(TOOLS_GIT_SUFFIX); \
	 done; \
	 for name in $(COMPONENT_DIRS) $(DEPLOY_DIRS); do \
		$(GIT) clone $(COMPONENTS_GIT_BASE_URL)/$$name$(COMPONENTS_GIT_SUFFIX); \
	 done; \
	)

update: workspace-tools
	@(\
	 set -e; \
	 if [ ! -d components ]; then \
		echo "The components directory does not exist."; \
		echo "Run 'make clone' first."; \
		exit 1; \
	 fi; \
	 cd components; \
	 for name in $(TOOL_DIRS); do \
		cd $$name; \
		$(GIT) pull; \
		cd ..; \
	 done; \
	 for name in $(COMPONENT_DIRS) $(DEPLOY_DIRS); do \
		cd $$name; \
		$(GIT) pull; \
		cd ..; \
	 done; \
	)

build: workspace-tools prepare $(TOOL_DIRS) $(COMPONENT_DIRS)

$(TOOL_DIRS): FORCE
	@( \
	 CMD="$(MVN) clean install"; \
	 BUILD_PROFILE=$(BUILD_PROFILE.$@); \
	 if [ "x$$BUILD_PROFILE" != "x" ]; then \
		BUILD_PROFILE="-P $$BUILD_PROFILE"; \
	 fi; \
	 cd components/$@ && echo "$@ : $$CMD $$BUILD_PROFILE" && $$CMD $$BUILD_PROFILE \
	)

$(COMPONENT_DIRS): FORCE
	@( \
	 CMD="$(MVN) clean install"; \
	 BUILD_PROFILE=$(BUILD_PROFILE.$@); \
	 if [ "x$$BUILD_PROFILE" != "x" ]; then \
		BUILD_PROFILE="-P $$BUILD_PROFILE"; \
	 fi; \
	 cd components/$@ && echo "$@ : $$CMD $$BUILD_PROFILE" && $$CMD $$BUILD_PROFILE \
	)

deploy: workspace-tools $(DEPLOY_DIRS)

$(DEPLOY_DIRS): FORCE
	@( \
	 CMD="$(MVN) clean install"; \
	 BUILD_PROFILE=$(BUILD_PROFILE.$@); \
	 if [ "x$$BUILD_PROFILE" != "x" ]; then \
	        BUILD_PROFILE="-P $$BUILD_PROFILE"; \
	 fi; \
	 cd components/$@ && echo "$@ : $$CMD $$BUILD_PROFILE" && $$CMD $$BUILD_PROFILE \
	)

prepare: workspace-tools FORCE
	@( \
	 WEXTENSIONS_DIR=$(BUILD_DIR)/sencha/workspace/packages/local/sonicle-extensions; \
	 CEXTENSIONS_DIR=$(BUILD_DIR)/components/sonicle-extjs-extensions/src/sencha/sonicle-extensions; \
	 XBUILD_DIR=$$WEXTENSIONS_DIR/build; \
	 LBUILD_DIR=$$CEXTENSIONS_DIR/build; \
	 rm -rf $$XBUILD_DIR; \
	 rm -rf $$LBUILD_DIR; \
	 mkdir -p $$XBUILD_DIR; \
	 ln -s $$XBUILD_DIR $$LBUILD_DIR; \
	 mkdir -p $$HOME/.m2; \
	 echo "sencha.cmd.v6=$(BUILD_DIR)/sencha/cmd/6.7.0.63" > $$HOME/.m2/sencha.properties; \
	 echo "sencha.workspace=$(BUILD_DIR)/sencha/workspace" >> $$HOME/.m2/sencha.properties; \
	)

FORCE:

