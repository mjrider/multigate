#
# (C) 2000 - 2005 Wieger Opmeer, Casper Joost Eyckelhof, Yvo Brevoort, Robbert Müller
#
# This package is free software; you can redistribute it and/or modify it
# under the terms of the "Artistic License".
#

package Multigate::DB;

#
# The interface for the database abstraction and configuration
# Default database handler is mysql if no database type is set

use strict;
use vars qw( @ISA @EXPORT $VERSION );
use Exporter;
use DBI;
use Data::Dumper;
use Cwd qw( abs_path );

use lib './lib';
use Multigate::Config qw( getconf hasconf);

$VERSION = '1';
@ISA     = qw( Exporter );
@EXPORT  =
  qw( get_dbh ) ;

sub get_dbi {

	if ( hasconf("db_dbi") ){
		return getconf("db_dbi");
	}

	my ($dbtype, $database);

	$dbtype = 'mysql';
	if ( hasconf("db_type") ){
		$dbtype = getconf("db_type")
	}

	$database = getconf('db_name');

	my $dbi = 'DBI:' . $dbtype . ':' . $database;
	return $dbi;

}

# returns a working $dbh, we hope
sub get_dbh {
	my $dbi = get_dbi();
	my ($db_passwd, $db_user);
	if (hasconf('db_passwd')) {
		$db_passwd = getconf('db_passwd');
	}
	if (hasconf('db_user')) {
		$db_user  = getconf('db_user');
	}

    	my $dbh = DBI->connect_cached( $dbi, $db_user, $db_passwd ,  { RaiseError => 0, AutoCommit => 1 } );
	return 0 unless defined $dbh;
	return $dbh;
}

