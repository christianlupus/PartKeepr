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
The files belong typically to the developer user. This causes problems when PartKeepr does not have sufficient permissions or if the UID does not match. To overcome this, the entry point script changes the UID of the `www-data` user in the image to some UID provided by the environemnt variable `GITHUB_DEBUG_UID`. Any access is thus made from the same rights as the development user outside and all newly created files will belong to him.

If no explicit command is given, the service starts apache.

Before apache is started, some preparations are made. This is for one, that composer is called to update any dependencies. If the user set `PARTKEEPR_FORCE_UPDATE` to `yes` a set of steps are run that represent a setup run (see [this wiki entry](https://wiki.partkeepr.org/wiki/Running_PartKeepr_from_GIT#Updating)). All cron jobs are run upon restarting to avoid additional messages here.

Calling a manual command is possible as well.
Then, no initialation script is run and no composer run is performed.
Just do something like `docker-compose run --rm app composer update`.

By setting `ADD_PHPINFO_FILE` to `1`, the developer can add a file to the web folder that serves a `phpinfo()` command.

There is also a commented sketch in the docker-compose how to debug and develop the Dockerfile.

## Setting up a development environment

In order to start using the suggested development environment a few steps are required to set them up for the first time.
This guide assumes, you have just freshly checked out the PartKeer repository from git.

1. Navigate in a console to the folder `docker/development`.
2. Copy the file `.github.env.dist` to `.github.env`.
3. Create a github personal access token in the settings on github. You need no additional rights. Put the generated token into the file `.github.env` where the `XXX...XXX` markers are.  
  Alternatively, you can also remove the line in the `.github.env` file. The reason for this setup is that github poses a rate limit on the number of accesses. When using the `composer` command much, these rate limits might be triggered easily. By logging in, the limits are pushed to higher values.
2. Call `docker-compose pull` to fetch all images from the docker hub. Alternatively you could [build the images manually](#building-the-images-manually).
3. First, you need to fire up the database and let it initialize. This is done by callng `docker-compose up -d db`. You can peek into the process by `docker-compose logs -f db`. Wait for a message that the server is ready for connections and listening on port 3306. Using `<Ctrl><c>`, you can exit from the logs.
4. Build the `initdb` image by calling `docker-compose build initdb`. This will take a few moments as it builds a docker image.
4. By default the line `RESET_DATABASE: 'yes'` in the file `docker-compose.yml` is commented. This is to avoid accidentially removing your data. Uncomment the line.
5. Initialize the data by calling `docker-compose up initdb`.
6. Recomment the line in the `docker-compose.yml` file you just uncommented.
7. Now, you can fire up the main container by calling `docker-compose up -d app`.
8. The container will initialize some dependenciees. This might take some time as well. Again using `docker-compose logs -f app` you can peek into the process and with `<Ctrl><c>` you can return to the console.  
   There might be some error messages regarding missing tables.
9. The partkeepr instance is avaliable at http://127.0.0.1:8082/. You will get a white screen as you need to start the [setup](http://127.0.0.1:8082/setup/) once. Just accept the defaults but do not create a new set of users (keep the existing ones) and select HTTP Basic authentication.
10. You might want to or not set up a cron job as described. The check is disabled by default.

## Building the images manually

It is possible to build the image manually. The main purpose is to teest, debug and alter the docker setup. Here are the steps to perform the build from scratch:

1. Go to `/docker/base-dev/`.
2. Call `docker build -t partkeepr/base-dev:latest .`. You can also give another tag name but you need to adopt later.
3. Go to `/docker/development`.
4. Alter the `docker-compose.yml` file.
    - Uncomment all the lines in the `app` service that start with the `build:` name as the comment indicates.
    - You might want to alter the `SRC_IMAGE` if you tagged with a different name above.
    - You might want to alter the name of the generated image to not overwrite the local `partkeepr/deevelopment:latest` image.
5. Call `docker-compose build app`.

