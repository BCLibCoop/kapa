#
# Copyright (C) 2006-2008  Georgia Public Library Service
# 
# Author: David J. Fiander
# 
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
#
# An object to handle checkout status
#

package ILS::Transaction::Checkout;

use warnings;
use strict;

use POSIX qw(strftime);

use ILS;
use ILS::Transaction;

our @ISA = qw(ILS::Transaction);

# Most fields are handled by the Transaction superclass
my %fields = (
	      security_inhibit => 0,
	      due              => undef,
	      renew_ok         => 0,
	      );

sub new {
    my $class = shift;;
    my $self = $class->SUPER::new();
    my $element;

    foreach $element (keys %fields) {
	$self->{_permitted}->{$element} = $fields{$element};
    }

    @{$self}{keys %fields} = values %fields;
    $self->{'due'} = time() + (60*60*24*14); # two weeks hence
    
    return bless $self, $class;
}

1;
