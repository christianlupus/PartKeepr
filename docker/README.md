# Docker file generation of PartKeepr

Introduction bla bla

## Folder structure

There are in fact different folders here that have differrent goals. Here is a short overview:

| Foldername | Description |
|----|----|
| `base` | A basic image can be generated as a starting point for any further images. It contains the required php extensions to run PartKeepr. |
| `development` | This folder contains a complete setup using docker-compose to develop with PartKeepr. |

## Details on the base image

The image installs a set of php extensions, composer, and configures apache to serve `/var/www/pk/web`. That is, PartKeepr should be installed in `/var/www/pk`.

This image is not ready to run but serves as a basis for the other images related to PartKeepr.

## Details on the development installation

To run a complete development environment, there is also a database required. Therefore, here a docker-compose based setup is chosen. Of course, on can setup things manually as well.

There are in the docker-compose file multiple services registered.

Once, there is the database (called `db`). It is a basic `mariadb` image compatible to PartKeepr and with basic configuration.

Second, there is the main PartKeepr installation called `app`. More on it later.

Third, there is a service called `initdb`. Its purpose is to restore the database and `data` folder to a pristane state. This one should normally not started unless one wnats to reset the database.

**Note:** There needs to be a useful default inserted into the initdb. At the moment it only clears out the database to be valid but containing no parts at all. Exactly the situtation you have after a fresh installation. Some test data might be useful here.

## The main development image

Apart from some additional tools in the docker image mainly an xdebug extension for php is installed.

The image is intended to work on the main sources as checked out. This allows easy updating and testing cycles.  
The files belong typically to the deveoper user. This causes problems when PartKeepr dowes not have sufficient permissions or if the UID does not match. To overcome this, the entry point script changes the UID of the `www-data` user in the image to some UID provided by the environemnt variable `GITHUB_DEBUG_UID`. Any access is thus made from the same rights as the development user outside and all newly created files will belong to him.

If no explicit command is given, the service starts apache.

Before apache is started, some preparations are made. This is for one, that composer is called to update any dependencies. If the user set `PARTKEEPR_FORCE_UPDATE` to `yes` a set of steps are run that represent a setup run (see [this wiki entry](https://wiki.partkeepr.org/wiki/Running_PartKeepr_from_GIT#Updating)). All cron jobs are run upon restarting to avoid additional messages here.

A manual command is possible as well.
Then, no initialation script is run and no composer run is perfomred.

By setting `ADD_PHPINFO_FILE` to `1`, the developer can add a file to the web folder that serves a `phpinfo()` command.

There is also a commented sketch in the docker-compose how to debug and develop the Dockerfile.
