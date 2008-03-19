#
# ILS.pm: Test ILS interface module
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
package ILS;

use warnings;
use strict;
use Sys::Syslog qw(syslog);

use ILS::Item;
use ILS::Patron;
use ILS::Transaction;
use ILS::Transaction::Checkout;
use ILS::Transaction::Checkin;
use ILS::Transaction::FeePayment;
use ILS::Transaction::Hold;
use ILS::Transaction::Renew;
use ILS::Transaction::RenewAll;

my %supports = (
		'magnetic media'	=> 1,
		'security inhibit'	=> 0,
		'offline operation'	=> 0,
		"patron status request" => 1,
		"checkout"		=> 1,
		"checkin"		=> 1,
		"block patron"		=> 1,
		"acs status"		=> 1,
		"login"			=> 1,
		"patron information"	=> 1,
		"end patron session"	=> 1,
		"fee paid"		=> 0,
		"item information"	=> 1,
		"item status update"	=> 0,
		"patron enable"		=> 1,
		"hold"			=> 1,
		"renew"			=> 1,
		"renew all"		=> 1,
	       );

sub new {
    my ($class, $institution) = @_;
    my $type = ref($class) || $class;
    my $self = {};

    syslog("LOG_DEBUG", "new ILS '%s'", $institution->{id});
    $self->{institution} = $institution;

    return bless $self, $type;
}

sub find_patron {
    my $self = shift;

    return ILS::Patron->new(@_);
}

sub find_item {
    my $self = shift;

    return ILS::Item->new(@_);
}

sub institution {
    my $self = shift;

    return $self->{institution}->{id};
}

sub supports {
    my ($self, $op) = @_;

    return (exists($supports{$op}) && $supports{$op});
}

sub check_inst_id {
    my ($self, $id, $whence) = @_;

    if ($id ne $self->{institution}->{id}) {
	syslog("LOG_WARNING", "%s: received institution '%s', expected '%s'",
	       $whence, $id, $self->{institution}->{id});
    }
}

sub to_bool {
    my $bool = shift;

    # If it's defined, and matches a true sort of string, or is
    # a non-zero number, then it's true.
    return defined($bool) && (($bool =~ /true|y|yes/i) || $bool != 0);
}

sub checkout_ok {
    my $self = shift;

    return (exists($self->{policy}->{checkout})
	    && to_bool($self->{policy}->{checkout}));
}

sub checkin_ok {
    my $self = shift;

    return (exists($self->{policy}->{checkin})
	    && to_bool($self->{policy}->{checkin}));
}

sub status_update_ok {
    my $self = shift;

    return (exists($self->{policy}->{status_update})
	    && to_bool($self->{policy}->{status_update}));

}

sub offline_ok {
    my $self = shift;

    return (exists($self->{policy}->{offline})
	    && to_bool($self->{policy}->{offline}));
}

#
# Checkout(patron_id, item_id, sc_renew):
#    patron_id & item_id are the identifiers send by the terminal
#    sc_renew is the renewal policy configured on the terminal
# returns a status opject that can be queried for the various bits
# of information that the protocol (SIP or NCIP) needs to generate
# the response.
#
sub checkout {
    my ($self, $patron_id, $item_id, $sc_renew) = @_;
    my ($patron, $item, $circ);

    $circ = new ILS::Transaction::Checkout;

    # BEGIN TRANSACTION
    $circ->patron($patron = new ILS::Patron $patron_id);
    $circ->item($item = new ILS::Item $item_id);

    if (!$patron) {
	$circ->screen_msg("Invalid Patron");
    } elsif (!$patron->charge_ok) {
	$circ->screen_msg("Patron Blocked");
    } elsif (!$item) {
	$circ->screen_msg("Invalid Item");
    } elsif (@{$item->hold_queue} && ($patron_id ne $item->hold_queue->[0])) {
	$circ->screen_msg("Item on Hold for Another User");
    } elsif ($item->{patron} && ($item->{patron} ne $patron_id)) {
	# I can't deal with this right now
	$circ->screen_msg("Item checked out to another patron");
    } else {
	$circ->ok(1);
	# If the item is already associated with this patron, then
	# we're renewing it.
	$circ->renew_ok($item->{patron} && ($item->{patron} eq $patron_id));
	$item->{patron} = $patron_id;
	$item->{due_date} = time + (14*24*60*60); # two weeks
	push(@{$patron->{items}}, $item_id);
	$circ->desensitize(!$item->magnetic);

	syslog("LOG_DEBUG", "ILS::Checkout: patron %s has checked out %s",
	       $patron_id, join(', ', @{$patron->{items}}));
    }

    # END TRANSACTION

    return $circ;
}

sub checkin {
    my ($self, $item_id, $trans_date, $return_date,
	$current_loc, $item_props, $cancel) = @_;
    my ($patron, $item, $circ);

    $circ = new ILS::Transaction::Checkin;
    # BEGIN TRANSACTION
    $circ->item($item = new ILS::Item $item_id);

    # It's ok to check it in if it exists, and if it was checked out
    $circ->ok($item && $item->{patron});

    if ($circ->ok) {
	$circ->patron($patron = new ILS::Patron $item->{patron});
	delete $item->{patron};
	delete $item->{due_date};
	$patron->{items} = [ grep {$_ ne $item_id} @{$patron->{items}} ];
    }
    # END TRANSACTION

    return $circ;
}

# If the ILS caches patron information, this lets it free
# it up
sub end_patron_session {
    my ($self, $patron_id) = @_;

    # success?, screen_msg, print_line
    return (1, 'Thank you for using Evergreen!', '');
}

sub pay_fee {
    my ($self, $patron_id, $patron_pwd, $fee_amt, $fee_type,
	$pay_type, $fee_id, $trans_id, $currency) = @_;
    my $trans;
    my $patron;

    $trans = new ILS::Transaction::FeePayment;

    $patron = new ILS::Patron $patron_id;

    $trans->transaction_id($trans_id);
    $trans->patron($patron);
    $trans->ok(1);

    return $trans;
}

sub add_hold {
    my ($self, $patron_id, $patron_pwd, $item_id, $title_id,
	$expiry_date, $pickup_location, $hold_type, $fee_ack) = @_;
    my ($patron, $item);
    my $hold;
    my $trans;


    $trans = new ILS::Transaction::Hold;

    # BEGIN TRANSACTION
    $patron = new ILS::Patron $patron_id;
    if (!$patron
	|| (defined($patron_pwd) && !$patron->check_password($patron_pwd))) {
	$trans->screen_msg("Invalid Patron.");

	return $trans;
    }

    $item = new ILS::Item ($item_id || $title_id);
    if (!$item) {
	$trans->screen_msg("No such item.");

	# END TRANSACTION (conditionally)
	return $trans;
    } elsif ($item->fee && ($fee_ack ne 'Y')) {
	$trans->screen_msg = "Fee required to place hold.";

	# END TRANSACTION (conditionally)
	return $trans;
    }

    $hold = {
	item_id         => $item->id,
	patron_id       => $patron->id,
	expiration_date => $expiry_date,
	pickup_location => $pickup_location,
	hold_type       => $hold_type,
    };

    $trans->ok(1);
    $trans->patron($patron);
    $trans->item($item);
    $trans->pickup_location($pickup_location);

    push(@{$item->hold_queue}, $hold);
    push(@{$patron->{hold_items}}, $hold);


    # END TRANSACTION
    return $trans;
}

sub cancel_hold {
    my ($self, $patron_id, $patron_pwd, $item_id, $title_id) = @_;
    my ($patron, $item, $hold);
    my $trans;

    $trans = new ILS::Transaction::Hold;

    # BEGIN TRANSACTION
    $patron = new ILS::Patron $patron_id;
    if (!$patron) {
	$trans->screen_msg("Invalid patron barcode.");

	return $trans;
    } elsif (defined($patron_pwd) && !$patron->check_password($patron_pwd)) {
	$trans->screen_msg('Invalid patron password.');

	return $trans;
    }

    $item = new ILS::Item ($item_id || $title_id);
    if (!$item) {
	$trans->screen_msg("No such item.");

	# END TRANSACTION (conditionally)
	return $trans;
    }

    # Remove the hold from the patron's record first
    $trans->ok($patron->drop_hold($item_id));

    if (!$trans->ok) {
	# We didn't find it on the patron record
	$trans->screen_msg("No such hold on patron record.");

	# END TRANSACTION (conditionally)
	return $trans;
    }

    # Now, remove it from the item record.  If it was on the patron
    # record but not on the item record, we'll treat that as success.
    foreach my $i (0 .. scalar @{$item->hold_queue}) {
	$hold = $item->hold_queue->[$i];

	if ($hold->{patron_id} eq $patron->id) {
	    # found it: delete it.
	    splice @{$item->hold_queue}, $i, 1;
	    last;
	}
    }

    $trans->screen_msg("Hold Cancelled.");
    $trans->patron($patron);
    $trans->item($item);

    return $trans;
}


# The patron and item id's can't be altered, but the
# date, location, and type can.
sub alter_hold {
    my ($self, $patron_id, $patron_pwd, $item_id, $title_id,
	$expiry_date, $pickup_location, $hold_type, $fee_ack) = @_;
    my ($patron, $item);
    my $hold;
    my $trans;

    $trans = new ILS::Transaction::Hold;

    # BEGIN TRANSACTION
    $patron = new ILS::Patron $patron_id;
    if (!$patron) {
	$trans->screen_msg("Invalid patron barcode.");

	return $trans;
    }

    foreach my $i (0 .. scalar @{$patron->{hold_items}}) {
	$hold = $patron->{hold_items}[$i];

	if ($hold->{item_id} eq $item_id) {
	    # Found it.  So fix it.
	    $hold->{expiration_date} = $expiry_date if $expiry_date;
	    $hold->{pickup_location} = $pickup_location if $pickup_location;
	    $hold->{hold_type} = $hold_type if $hold_type;

	    $trans->ok(1);
	    $trans->screen_msg("Hold updated.");
	    $trans->patron($patron);
	    $trans->item(new ILS::Item $hold->{item_id});
	    last;
	}
    }

    # The same hold structure is linked into both the patron's
    # list of hold items and into the queue of outstanding holds
    # for the item, so we don't need to search the hold queue for
    # the item, since it's already been updated by the patron code.

    if (!$trans->ok) {
	$trans->screen_msg("No such outstanding hold.");
    }

    return $trans;
}

sub renew {
    my ($self, $patron_id, $patron_pwd, $item_id, $title_id,
	$no_block, $nb_due_date, $third_party,
	$item_props, $fee_ack) = @_;
    my ($patron, $item);
    my $trans;

    $trans = new ILS::Transaction::Renew;

    $trans->patron($patron = new ILS::Patron $patron_id);

    if (!$patron) {
	$trans->screen_msg("Invalid patron barcode.");

	return $trans;
    } elsif (!$patron->renew_ok) {
	$trans->screen_msg("Renewals not allowed.");

	return $trans;
    }

    if (defined($title_id)) {
	# renewing a title, rather than an item (sort of)
	# This is gross, but in a real ILS it would be better
	foreach my $i (@{$patron->{items}}) {
	    $item = new ILS::Item $i;
	    last if ($title_id eq $item->title_id);
	    $item = undef;
	}
    } else {
	foreach my $i (@{$patron->{items}}) {
	    if ($i == $item_id) {
		# We have it checked out
		$item = new ILS::Item $item_id;
		last;
	    }
	}
    }

    $trans->item($item);

    if (!defined($item)) {
	# It's not checked out to $patron_id
	$trans->screen_msg("Item not checked out to " . $patron->name);
    } elsif (!$item->available($patron_id)) {
	 $trans->screen_msg("Item has outstanding holds");
    } else {
	$trans->renewal_ok(1);

	$trans->desensitize(0);	# It's already checked out

	if ($no_block eq 'Y') {
	    $item->{due_date} = $nb_due_date;
	} else {
	    $item->{due_date} = time + (14*24*60*60); # two weeks
	}
	if ($item_props) {
	    $item->{sip_item_properties} = $item_props;
	}
	$trans->ok(1);
	$trans->renewal_ok(1);

	return $trans;
    }

    return $trans;
}

sub renew_all {
    my ($self, $patron_id, $patron_pwd, $fee_ack) = @_;
    my ($patron, $item_id);
    my $trans;

    $trans = new ILS::Transaction::RenewAll;

    $trans->patron($patron = new ILS::Patron $patron_id);
    if (defined $patron) {
	syslog("LOG_DEBUG", "ILS::renew_all: patron '%s': renew_ok: %s",
	       $patron->name, $patron->renew_ok);
    } else {
	syslog("LOG_DEBUG", "ILS::renew_all: Invalid patron id: '%s'",
	       $patron_id);
    }

    if (!defined($patron)) {
	$trans->screen_msg("Invalid patron barcode.");
	return $trans;
    } elsif (!$patron->renew_ok) {
	$trans->screen_msg("Renewals not allowed.");
	return $trans;
    } elsif (defined($patron_pwd) && !$patron->check_password($patron_pwd)) {
	$trans->screen_msg("Invalid patron password.");
	return $trans;
    }

    foreach $item_id (@{$patron->{items}}) {
	my $item = new ILS::Item $item_id;

	if (!defined($item)) {
	    syslog("LOG_WARNING",
		   "renew_all: Invalid item id associated with patron '%s'",
		   $patron->id);
	    next;
	}

	if (@{$item->hold_queue}) {
	    # Can't renew if there are outstanding holds
	    push @{$trans->unrenewed}, $item_id;
	} else {
	    $item->{due_date} = time + (14*24*60*60); # two weeks hence
	    push @{$trans->renewed}, $item_id;
	}
    }

    $trans->ok(1);

    return $trans;
}

1;
