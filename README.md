<!-- Improved compatibility of back to top link: See: https://github.com/othneildrew/Best-README-Template/pull/73 -->

<a name="readme-top"></a>

<!--
*** Thanks for checking out the Best-README-Template. If you have a suggestion
*** that would make this better, please fork the repo and create a pull request
*** or simply open an issue with the tag "enhancement".
*** Don't forget to give the project a star!
*** Thanks again! Now go create something AMAZING! :D
-->

<!-- PROJECT SHIELDS -->
<!--
*** I'm using markdown "reference style" links for readability.
*** Reference links are enclosed in brackets [ ] instead of parentheses ( ).
*** See the bottom of this document for the declaration of the reference variables
*** for contributors-url, forks-url, etc. This is an optional, concise syntax you may use.
*** https://www.markdownguide.org/basic-syntax/#reference-style-links
-->

[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![MIT License][license-shield]][license-url]
[![LinkedIn][linkedin-shield]][linkedin-url]

<!-- PROJECT LOGO -->
<br />
<div align="center">

<h1 align="center">Docker Postgres Setup</h1>

  <p align="center">
    A few simple .bat files that can be executed on windows to spin up a postgres database configuration.
  </p>
</div>

<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
      </ul>
    </li>
    <li>
      <a href="#usage">Usage</a>
      <ul>
        <li><a href="#windows">Windows</a></li>
      </ul>
    </li>
  </ol>
</details>

<!-- ABOUT THE PROJECT -->

## About The Project

This is a quick and simple project consisting of a few files used to quickly spin up a docker postgres instance for local development environments. The motivation behind it was to minimise the amount of docker commands required to snapshot and restore a postgres database so that data can be saved, and restored very quickly when testing.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- GETTING STARTED -->

## Getting Started

To get started simply clone this repo to a folder of choice and you're nearly ready to go

### Prerequisites

Docker installation on a Windows PC or Linux operating system. At the time of writing I had Docker version 20.10.12 installed but the commands used are core commands that are unlikely to ever change so in theory it should work with any version. Docker provides comprehensive installation instructions so I'll spare myself any errors and refer to their documentation for this ;) https://docs.docker.com/desktop/install/windows-install/

Also no docker container should be running on the port 5432. If there is then running the scripts could result in "port binding in use" errors.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- USAGE EXAMPLES -->

## Usage
The script files are designed to be run from their respective folders in a terminal but the SQL file to initialise the project should be created in the project root folder.

At a high level, you will use the project by
 - Creating an `init.sql` file with some initial database set up commands
 - Set some environment variables with the **Configure** script
 - Initialise the docker container with the **Init** script
 - Backup your data and store that as an sql file in `backup_dumps` using the **Backup** script
 - Restore your data from saved sql files using the **Restore** script

 Below will walk through an give some explanation of how the scripts achieve this for both Windows and Linux operating systems.

### Windows

Firstly, create a file named `init.sql` in the root of this project folder. The contents of this file should be a small set of SQL commands to

- create a database for you application's tables
- create a user that your application will use to connect to the database with
- assign the relevant permissions to that user for the application's purposes

The below example content will do just this:

```
create database appdb;
create user appuser;
grant all privileges on database appdb to appuser;
```

Open up a CMD or Powershell terminal and navigate to the locally cloned version of this project and then to the windows_scripts folder.

The first batch file to run is the `configure.bat` file. This is simply to set a few environment variables for your windows user. It will prompt for these but they can also be set manually. Once this .bat file has executed, you will need to open a new terminal for the changed environment variables to be recognised so close down the terminal and open a new one, navigating back to this folder. These environment variables will need to be reset every time you switch applications. Alternatively, the .bat files here can be copied and modified to just take fixed names for each of your projects.

The next batch file to run is `init.bat`. This will pull the postgres image matching the version specified in the configuration step (if you don't have this image already saved). It will then build and run the container with some standard postgres environment variables. Finally it will copy across the init.sql to the root folder of the running container. Frustratingly trying to run Docker commands that take a while is something I've not managed to achieve in a batch file, but they can still be run from the console. The required command to actually run the init.sql will be output on the console at the bottom to be copied and pasted and run by yourself manually.

At this point the postgres server should be up and running on port 5432 so ought to be accessible from your application if you have the correct connection details.

As your application persists its state to the database, you can take snapshots of it by running the `backup.bat` file. This will prompt you for a file name which should **exclude** the .sql extension. All this file is doing is running some docker commands to run some psql commands inside the container to dump the database into a file. It then copies this file with your chosen name to a directory in Windows called backup_dumps. **Choosing the same name for a backup will overwrite any existing files in this directory**.

If you wish to restore the application to a given state, run the `restore.bat`. This will prompt for a file name (again exclude the extension) and will copy this file from the Windows directory to the container's root directory. Again the command to execute the restoration of the database dump doesn't seem to complete when run from a batch file so this will need to be copied and pasted manually.

There are also a couple of util files such as `start.bat` which is to quickly start the server (much easier to type 's' then tab and enter rather than submit the full docker start container-name). Similarly there is the a command to enter the container shell called `enter_shell.bat`, similarly this is a simple docker command but 'e' tab and enter are quicker. From the container a similar shortcut exists to actually enter the postgres console by running the `query_mode.sh` which uses an environment variable to connect to the application database as the root user.

### Linux
Firstly, create a file named `init.sql` in the root of this project folder. The contents of this file should be a small set of SQL commands to

- create a database for you application's tables
- create a user that your application will use to connect to the database with
- assign the relevant permissions to that user for the application's purposes

The below example content will do just this:

```
create database appdb;
create user appuser;
grant all privileges on database appdb to appuser;
```
Open up a terminal and navigate to the locally cloned version of this project and then to the linux_scripts folder.

The first shell script to run is the `configure.sh` file. This is simply to set a few environment variables for your user. These environment variables will need to be reset every time you switch applications. Alternatively, the shell files here can be copied and modified to just take fixed names for each of your projects.

The next shell script to run is `init.sh`. This will pull the postgres image matching the version specified in the configuration step (if you don't have this image already saved). It will then build and run the container with some standard postgres environment variables. Finally it will copy across the init.sql to the root folder of the running container. Frustratingly trying to run Docker commands that take a while is something I've not managed to achieve in a script file, but they can still be run from the console. The required command to actually run the init.sql will be output on the console at the bottom to be copied and pasted and run by yourself manually.

At this point the postgres server should be up and running on port 5432 so ought to be accessible from your application if you have the correct connection details.

As your application persists its state to the database, you can take snapshots of it by running the `backup.sh` file. This will prompt you for a file name which should **exclude** the .sql extension. All this file is doing is running some docker commands to run some psql commands inside the container to dump the database into a file. It then copies this file with your chosen name to a directory in Windows called backup_dumps. **Choosing the same name for a backup will overwrite any existing files in this directory**.

If you wish to restore the application to a given state, run the `restore.sh`. This will prompt for a file name (again exclude the extension) and will copy this file from the host linux directory to the container's root directory. Again the command to execute the restoration of the database dump doesn't seem to complete when run from a script file so this will need to be copied and pasted manually.

There are also a couple of util files such as `start.sh` which is to quickly start the server (much easier to type './s' then tab and enter rather than submit the full docker start container-name). Similarly there is the a command to enter the container shell called `enter_shell.sh`, similarly this is a simple docker command but './e' tab and enter are quicker. From the container a similar shortcut exists to actually enter the postgres console by running the `query_mode.sh` which uses an environment variable to connect to the application database as the root user.


<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->

[contributors-shield]: https://img.shields.io/github/contributors/ayorkshireworrall/docker-postgres-windows-config.svg?style=flat
[contributors-url]: https://github.com/ayorkshireworrall/docker-postgres-windows-config/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/ayorkshireworrall/docker-postgres-windows-config.svg?style=flat
[forks-url]: https://github.com/ayorkshireworrall/docker-postgres-windows-config/network/members
[stars-shield]: https://img.shields.io/github/stars/ayorkshireworrall/docker-postgres-windows-config.svg?style=flat
[stars-url]: https://github.com/ayorkshireworrall/docker-postgres-windows-config/stargazers
[issues-shield]: https://img.shields.io/github/issues/ayorkshireworrall/docker-postgres-windows-config.svg?style=flat
[issues-url]: https://github.com/ayorkshireworrall/docker-postgres-windows-config/issues
[license-shield]: https://img.shields.io/github/license/ayorkshireworrall/docker-postgres-windows-config.svg?style=flat
[license-url]: https://github.com/ayorkshireworrall/docker-postgres-windows-config/blob/main/License.txt
[linkedin-shield]: https://img.shields.io/badge/-LinkedIn-black.svg?style=flat&logo=linkedin&colorB=555
[linkedin-url]: https://linkedin.com/in/alexander-worrall-51b1881a5
[product-screenshot]: images/screenshot.png
[next.js]: https://img.shields.io/badge/next.js-000000?style=flat&logo=nextdotjs&logoColor=white
[next-url]: https://nextjs.org/
[react.js]: https://img.shields.io/badge/React-20232A?style=flat&logo=react&logoColor=61DAFB
[react-url]: https://reactjs.org/
[vue.js]: https://img.shields.io/badge/Vue.js-35495E?style=flat&logo=vuedotjs&logoColor=4FC08D
[vue-url]: https://vuejs.org/
[angular.io]: https://img.shields.io/badge/Angular-DD0031?style=flat&logo=angular&logoColor=white
[angular-url]: https://angular.io/
[svelte.dev]: https://img.shields.io/badge/Svelte-4A4A55?style=flat&logo=svelte&logoColor=FF3E00
[svelte-url]: https://svelte.dev/
[laravel.com]: https://img.shields.io/badge/Laravel-FF2D20?style=flat&logo=laravel&logoColor=white
[laravel-url]: https://laravel.com
[bootstrap.com]: https://img.shields.io/badge/Bootstrap-563D7C?style=flat&logo=bootstrap&logoColor=white
[bootstrap-url]: https://getbootstrap.com
[jquery.com]: https://img.shields.io/badge/jQuery-0769AD?style=flat&logo=jquery&logoColor=white
[jquery-url]: https://jquery.com
