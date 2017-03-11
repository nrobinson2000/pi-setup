# pi-setup

This is my automated solution for configuring a Raspbian SD card for headless use with Particle.

Essentially the script is a wizard that guides the user [through these steps on my blog](https://cehs.github.io/2017/03/08/how-to-run-particle-on-raspberry-pi.html).

This script requires a Linux environment, preferably Ubuntu-based, so that the SD card is mounted in `/media/$USER`.

After flashing your SD card with Raspbian just [run the script](https://github.com/nrobinson2000/pi-setup/blob/master/pi-setup.sh) to set up your Pi for headless use:

```bash
$ bash <( curl -sL https://raw.githubusercontent.com/nrobinson2000/pi-setup/master/pi-setup.sh)
```
