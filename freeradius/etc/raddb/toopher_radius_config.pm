package toopher_radius_config;
use strict;

{
  my $toopher_config = 
  {
    toopher_api => {  
      url   =>  'https://toopher-api-dev.appspot.com/v1/',
      key   =>  'uDSyNsfBGPgSpEVcXM', 
      secret=>  '9k5RDbKrhMacqrjtPRSCgrwfVTX5rjm5',
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
  sub get_config { return $toopher_config; }
}
