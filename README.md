# Sonicle Webtop 5 build environment
Use this to build all the WebTop 5 repositories and produce the war file for deployment.

Requirements for the build are git and mvn.

The Makefile has 5 possible targets: clone, update, clean, build and deploy.

Start cloning all the WebTop5 repositories with 'gmake clone'.\s\s
Then you periodically run 'gmake update' to fetch changes.

To build all the components, run 'gmake build' and wait for all the components to be built.\s\s
You may see warning or errors during this stage: if the build continues, don't mind them.

You may now create the deployment war with 'gmake deploy'.

# Database initialization

Create a postgres database and initialize it with the following sql files:

[init-config.sql](https://github.com/sonicle-webtop/webtop-core/blob/master/src/main/resources/com/sonicle/webtop/core/meta/db/init-config.sql)\s\s
[init-core.sql](https://github.com/sonicle-webtop/webtop-core/blob/master/src/main/resources/com/sonicle/webtop/core/meta/db/init-core.sql)\s\s
[init-public.sql](https://github.com/sonicle-webtop/webtop-core/blob/master/src/main/resources/com/sonicle/webtop/core/meta/db/init-public.sql)\s\s
[init-calendar.sql](https://github.com/sonicle-webtop/webtop-calendar/blob/master/src/main/resources/com/sonicle/webtop/calendar/meta/db/init-calendar.sql)\s\s
[init-contacts.sql](https://github.com/sonicle-webtop/webtop-contacts/blob/master/src/main/resources/com/sonicle/webtop/contacts/meta/db/init-contacts.sql)\s\s
[init-mail.sql](https://github.com/sonicle-webtop/webtop-mail/blob/master/src/main/resources/com/sonicle/webtop/mail/meta/db/init-mail.sql)\s\s
[init-tasks.sql](https://github.com/sonicle-webtop/webtop-tasks/blob/master/src/main/resources/com/sonicle/webtop/tasks/meta/db/init-tasks.sql)\s\s
[init-vfs.sql](https://github.com/sonicle-webtop/webtop-vfs/blob/master/src/main/resources/com/sonicle/webtop/vfs/meta/db/init-vfs.sql)\s\s

Then fill it with initial data using the following sql files:

[init-data-core.sql](https://github.com/sonicle-webtop/webtop-core/blob/master/src/main/resources/com/sonicle/webtop/core/meta/db/init-data-core.sql)\s\s
[init-data-mail.sql](https://github.com/sonicle-webtop/webtop-mail/blob/master/src/main/resources/com/sonicle/webtop/mail/meta/db/init-data-mail.sql)\s\s
[init-data-vfs.sql](https://github.com/sonicle-webtop/webtop-vfs/blob/master/src/main/resources/com/sonicle/webtop/vfs/meta/db/init-data-vfs.sql)\s\s

# Deployment

The deployment war can be found in components/webtop-webapp/target.

Check the contained META-INF/data-sources.xml and update it with correct database connection information.

The application can be deployed on Tomcat7/8 or any other J2EE container supporting websocket.

# Administration

Once the web application is running, connect to it and you should get the login page.

Enter admin / admin to begin.

You should review the Properties (system) page, to reflect your installation, expecially:
- com.sonicle.webtop.core / home.path = an empty home directory for WebTop, with write permissions for the container user (e.g. tomcat)
- com.sonicle.webtop.core / php.path = point to a valid path for the php binary
- com.sonicle.webtop.core / public.url = how the system is reachable from the internet (used to prepare public urls)
- com.sonicle.webtop.core / smtp.host & smtp.port = the smtp host and port
- com.sonicle.webtop.core / zpush.path = the path pointing to the z-push-webtop component
- com.sonicle.webtop.mail / * = check all the imap settings for your server

Right click the Domains node and create a new domain selecting the authentication method:
- Use WebTop (local) for local users and password, managed by WebTop. Each user must be configured with its imap account.
- Use WebTop (ldap) for a simple ldap management by the WebTop Administrator
- Choose any other method if your imap server infrastructure has its own authentication infrastructure (ldap, active directory)
- In this last case, you can choose to let WebTop create a WebTop user automatically when a user is authenticated the first time.

Once the Domain is created, you can view and manage the list of users by opening the domain tree. Here you can manage groups and roles too.

Go back to the login screen via the top-right menu / exit button, and enter valid user credentials to start using WebTop 5.


