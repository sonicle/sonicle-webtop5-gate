# Sonicle Webtop 5 build environment
Use this to build all the WebTop 5 repositories and produce the war file for deployment.

Requirements for the build are git and mvn.

The Makefile has 5 possible targets: clone, update, clean, build and deploy.

Start cloning all the WebTop5 repositories with 'gmake clone'.
Then you periodically run 'gmake update' to fetch changes.

To build all the components, run 'gmake build' and wait for all the components to be built.
You may see warning or errors during this stage: if the build continues, don't mind them.

You may now create the deployment war with 'gmake deploy'.

# Database initialization

Create a postgres database and initialize it with the following sql files:

init-config.sql[https://github.com/sonicle-webtop/webtop-core/blob/master/src/main/resources/com/sonicle/webtop/core/meta/db/init-config.sql]

# Deployment

The deployment war can be found in components/webtop-webapp/target and can be deployed on Tomcat7/8
or any other J2EE container supporting websocket.

Before firing up the web application, 


