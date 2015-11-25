# This program is free software; you can redistribute it and/or
# modify it under the terms of version 2 of the GNU General Public
# License as published by the Free Software Foundation.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public
# License along with this program; if not, write to the Free
# Software Foundation, Inc., 59 Temple Place, Suite 330, Boston,
# MA 02111-1307 USA

package KAPA::Z3950;

use Data::Dumper;
use ZOOM;
use KAPA::Patron;
use warnings;
use strict;
use Sys::Syslog qw(syslog);
use Error qw(try);

my %supports = (
	'magnetic media'	=> 0,
	'security inhibit'	=> 0,
	'offline operation'	=> 0,
	"patron status request" => 0,
	"checkout"		=> 0,
	"checkin"		=> 0,
	"block patron"		=> 0,
	"acs status"		=> 0,
	"login"			=> 1,
	"patron information"	=> 1,
	"end patron session"	=> 0,
	"fee paid"		=> 0,
	"item information"	=> 0,
	"item status update"	=> 0,
	"patron enable"		=> 0,
	"hold"			=> 0,
	"renew"			=> 0,
	"renew all"		=> 0,
);

# Everything going down as far as find_patron is OpenNCIP boilerplate,
# lightly customized to recognize the fact we do almost nothing with
# this server

sub new {
    my ($class, $institution) = @_;
    my $type = ref($class) || $class;
    my $self = {};
	
    syslog("LOG_DEBUG", "new ILS '%s'", $institution->{id});
    $self->{institution} = $institution;
	
    return bless $self, $type;

}

sub supports {
    my ($self, $op) = @_;
	
    return (exists($supports{$op}) && $supports{$op});
}

sub checkout_ok {
	return undef;
}

sub checkin_ok {
	return undef;
}

sub status_update_ok {
	return undef;
}

sub offline_ok {
	return undef;
}

sub institution {
	my $self = shift;
	return $self->{institution}->{id};
}

# Here endeth the boilerplate.

sub find_patron {
	# First we remove the first arg, which is a self-referential thing,
	# apparently
	my $self = shift;

	# server, the FreeTDS datasource to connect to, as named in /etc/freetds/freetds.conf
	# database_name, the name of the Sybase or SQL Server database to connect to 
	# username, the username to connect to the remote database (*not* the end user's username!)
	# password, the password for the database connection (as above, not for the end user!)
	
	my $server = $self->{institution}->{config}->{server};
	my $port = $self->{institution}->{config}->{port};
	my $database = $self->{institution}->{config}->{database};

	# barcode, the barcode or other library-specific patron ID number for this particular session,
	# is the only other thing that's been passed
	my $barcode = shift;
	
	my $z39_connection = new ZOOM::Connection($server, $port, databaseName => $database, preferredRecordSyntax => 'USMARC');
	my $query = new ZOOM::Query::PQF('@attr 1=1032 @attr 4=2 ' . $barcode);

	my $rs = $z39_connection->search($query);
	my $results = $rs->size();
	$z39_connection->destroy();

	return KAPA::Patron->new($barcode) if $results gt 0;
	return undef;
}
