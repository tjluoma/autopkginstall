autopkginstall
==============

**Summary:** automate the installation of .pkg or .mpkg files if put into a certain folder

In response to <http://apple.stackexchange.com/questions/113489/unattended-installation-of-pkg-file>, here is a script to automate the installation of .pkg and/or .mpkg files.

## Installation ##

#### 1) You must edit the `com.tjluoma.AutoInstallPKG.plist` file and change `/Users/luomat/Action/AutoInstallPKG` to the full path to whatever directory that you want to monitor for new .pkg or .mpkg files

	<key>QueueDirectories</key>
	<array>
		<string>/Users/luomat/Action/AutoInstallPKG</string>
	</array>

#### 2) After editing `com.tjluoma.AutoInstallPKG.plist` move it to `~/Library/LaunchAgents/com.tjluoma.AutoInstallPKG.plist`

#### 3) Install `autopkginstall.sh` to somewhere in your $PATH such as `/usr/local/bin/autopkginstall.sh`

#### 4) Make sure that `autopkginstall.sh` is executable:

	chmod 755 `which autopkginstall.sh`

#### 5) In order for installations to run unattended, you must add this line to `/etc/sudoers`

	%admin ALL=NOPASSWD: /usr/sbin/installer

(See `man visudo` for more information on editing the sudoers file. BBEdit users should check out [bbwait](https://github.com/tjluoma/bbwait) to use BBEdit to edit the sudoers file.)

Note that this change introduces a minor security concern in that any administrator account on the local Mac which is a member of the `admin` group will be able to install pkg and mpkg files without having to enter their password.

#### 6) Install [terminal-notifier](https://github.com/alloy/terminal-notifier) (Optional)

If found in $PATH, `terminal-notifier` will be used to tell the user when packages are installed using this script.

## Troubleshooting ##


Error messages will be saved to `/tmp/AutoInstallPKG.errors.log`

Other informational messages may be saved to `/tmp/AutoInstallPKG.log`

If you do not want to use /tmp/ for those files, edit the `com.tjluoma.AutoInstallPKG.plist` file accordingly.

