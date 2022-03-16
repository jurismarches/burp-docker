# Burp docker container

This repository contains files to build burp container which includes burp-ui and email sending capability.

Burp is an open source backup and restore software for Unix and Windows clients.
https://burp.grke.org/

#### Installation

- Clone this repository
```
git clone https://github.com/jurismarches/burp-docker
```

- build docker container manually

```
cd container
docker build -t burp-server .
```

- or pull from dockerhub

```
docker pull octopusmindteam/burp
```

- run it with defaults values for testing purposes. 

```
docker run -itd -p 5000:5000 -p 4971:4971 -p 4972:4972 burp
```

#### Variables

`NOTIFY_SUCCESS` 

Boolean value true/false for receiving notifications on successfull backups via email. 

`NOTIFY_FAILURE`

Boolean value true/false for receiving notification on failed backups via email.

`NOTIFY_EMAIL`

Email address where notifications are sent to

#### Volumes

There are few important mountpoints you should note if preserving data is important (usually it is unless you're not just testing this).

`/etc/burp` - configuration path

`/var/spool/burp` - path for backup store

You should mount a path from host machine to these for best outcome.

#### Tips

- Each restart copies /etc/burp/burp-server.conf.template as /etc/burp/burp-server.conf and edits it according to variables set. If you wish to add or edit some configuration which is not supported by my build, you can edit the template file inside the container/host mountpoint to preserve things in the future. 
