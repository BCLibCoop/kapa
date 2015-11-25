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

package KAPA::EZProxy;

use Data::Dumper;
use KAPA::Patron;
use warnings;
use strict;
use Sys::Syslog qw(syslog);
use Error qw(try);
use LWP;

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

	# server, the webb address of the partron API, eg: www.cataloge.library.ca:4500
	
	my $server = $self->{institution}->{config}->{server};
    my $proxy_login = $self->{institution}->{config}->{proxy_login};
    my $proxy_url = $self->{institution}->{config}->{proxy_url};

	# barcode, the barcode or other library-specific patron ID number for this particular session,
	# is the only other thing that's been passed
	
	my ($barcode, $pin) = ($_[0], $_[1]);

	# form the connection, but fail gracefully if we fail to connect
	my $userAgent = LWP::UserAgent->new;

	my $request = HTTP::Request->new(GET => "$proxy_login?user=$barcode&pass=$pin&url=$proxy_url");
	my $result = $userAgent->request($request);
	my $retrieved_patron = 0;
	if( $result->is_success){
		my $result_string = $result->as_string;
	
		if(grep { /cookies/ } $result_string)
		{
			return KAPA::Patron->new($barcode);
		}
	}

	return undef;

}
