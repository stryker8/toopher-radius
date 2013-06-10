Installing and Configuring the Toopher RADIUS server
======================================================

Toopher uses the popular open-source FreeRadius server as the base for its RADIUS
solution.

Set Up LDAP Integration
-----------------------
Integrating Toopher into your organization's LDAP schema provides a simple way to administer per-user Toopher settings,
and is the recommended deployment method. 

### Integrating Toopher into Microsoft Active Directory
The files required for Active Directory integration are in the /ad folder.

#### Import the Toopher Schema

    ldifde -i -f toopher_schema.ldif -c DC=x DC=example,DC=com

Change DC=example,DC=com to values appropriate for your domain

The schema import will create a new auxilliary user class called toopherProtectedEntity that contains per-user Toopher settings.  Additionally, it will create a new user group called "ToopherAdministrators" that will be allowed to modify the toopherProtectedEntity settings.

After importing the schema changes, you should create a new LDAP user for use by the RADIUS server and add them to the ToopherAdministrators group.


Installing the RADIUS Server
-----------------------------
### Installing on Ubuntu (or other debian-based distro)
run the provided install-ubuntu.sh script as root:

    cd install && sudo ./install-ubuntu.sh

### Installing on other linux
Automated install scripts for Redhat and SuSE distros should be available soon.  Until then...

Install FreeRadius (at least 2.1.10, older builds might work but are untested) using Your Package Manager Of Choice

Copy all of the Toopher configuration files to the freeradius configuration directory (usually /etc/raddb):

    sudo cp -r freeradius/etc/raddb/* /etc/raddb/

make sure that all of the copied files in /etc/raddb are readable by the freeradius service user

Install required perl modules:

    cpan Net::OAuth::ConsumerRequest JSON::XS JSON Net::LDAP LWP::Protocol::https

*Note - cpan will sometimes fail midway through while installing dependencies.  Just re-run the command and it should eventually finish without error*

Verify that you can start the FreeRadius server without any perl errors:

    sudo radiusd -Xxx

If that command completes without errors, you should be good to go. Ctrl-C to exit.

### Installing on Windows
Please use our prebuilt Cygwin-based server for deployment on Windows.

RADIUS Configuration
--------------------

Before you can run the server, you need to edit /etc/raddb/toopher_radius_config.pm (/etc/freeradius/toopher_radius_config.pm on Ubuntu) to suit your site.
```perl
    my $toopher_config =
    {
      toopher_api => {
        url   =>  'https://api.toopher.com.com/v1/',
        key   =>  'YOUR TOOPHER API KEY',
        secret=>  'YOUR TOOPHER API SECRET',
        },
      ldap => {
        username =>  'toopher_radius',
        password =>  'p@ssw0rd',
        host  =>     '127.0.0.1',
        principal => 'example.toopher.com',
        dc        => 'DC=example,DC=toopher,DC=com',
        },
      prompts => {
        pairing_challenge => 'Toopher 2-factor authentication is enabled for your account.  Please enter the pairing phrase generated by the Toopher mobile app:'
        }
    };
```

At a minimum, you must change the "key" and "secret" values in the
toopher_api section.  You can generate new requester credentials at the 
[Toopher Developer Site](https://dev.toopher.com).

Most users will also need to edit the ldap section to point to their
ActiveDirectory or other LDAP server.  The username/password should be
a LDAP user that belongs to the ToopherAdministators group.

Additionally, you may customize the prompt displayed to users when they initially pair their device with Toopher.  The maximum length of this prompt is 253 characters due to technical limitations of the RADIUS specification.

Start the RADIUS server
-----------------------

    sudo service freeradius start    # or service radiusd start, depending on the distro

Add Toopher Protection to Individual Users
------------------------------------------

On Windows systems, users can be easily managed using the toopher-admin.bat script.

Enable Toopher protection for a user:

    toopher-admin enable [username]

Reset a user's pairing (for instance, if they get a new mobile device and want to change their pairing):

    toopher-admin reset-pairing [username]

Disable Toopher security for a user (pairing information will be kept):

    toopher-admin disable [username]

Show a list of all Toopher-enabled users:

    toopher-admin show-users

Linux-based administration tools are coming soon...
