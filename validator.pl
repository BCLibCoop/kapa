#!/usr/bin/perl
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

package Validator;

use strict;
use DBI;
use DBD::Sybase;
use LWP::UserAgent;


sub new{
	my $class = shift;
	my $self = {};
	bless($self, $class);
	return $self;
}

sub validatePostgresBarcode{
#2 paramaters expected the symbol of the library first and the barcode being tested second
	#these are the settings for the postgres database that contains all the stored valid barcodes
	my $host = "";
	my $dbUserName = "postgres";
	my $dbPassword = "";
	my $dbName = "barcodes";

	#creating and setting the search values
	my $symbol;
	my $barcode;
	if(@_ >= 2){
		$symbol = @_[0];
		$barcode = @_[1];
	}
	else{
		#did not get the needed input die and complain about it
		die "validatePostgresBarcode did not recive the needed input"; 
	}
	
	#connect to the database:
	my $dbc = DBI->conect("DBI:Pg:dbname=$dbName;host=$host", $dbUserName, $dbPassword, {'RaiseError' => 1});

	#format and prepair the select statement
	my $selectQuery = $dbc->prepare("SELECT barcode, symbol FROM barcodes_by_symbol WHERE symbol = '$symbol' AND barcode = '$barcode'");
	
	#execute the query	
	if( $selectQuery->execute ){

		#record if the request was succesful
		my $test = $selectQuery->fetchrow_hashref();

		#disconnect
		$selectQuery->finish();
		$dbc->disconnect();

		#return true if succesful
		if($test){
			return 1;
		}
		else{
			return 0;
		}
	}
	else{
		die "$DBI::errstr";
	}
}

sub validateSybaseBarcode{
	#expecting 5 paramaters, the name of the server as it is named in the freetds config file and the barcode second
	#third is the username to connect to the server, 4th is the password
	#5th is the name of the database on the server
	#create and set the needed variables
	my $server;
	my $barcode;
	my $uname;
	my $password;
	my $dbname;
	if(@_ >= 5){
		$server = @_[0];
		$barcode = @_[1];
		$uname = @_[2];
		$password = @_[3];
		$dbname = @_[4];
	}
	else{
		#did not recieve all the needed input values die
		die "validateSybaseBarcode did not recive all needed data";
	}
	
	#form the connection
	my $dbc = DBI->connect("DBI:Sybase:server=$server", $uname, $password) or die;
	$dbc->do("use $dbname") || die "$DB::errstr";

	#form the select query and execute it
	my $action = $dbc->prepare("SELECT bbarcode FROM borrower_barcode WHERE bbarcode = '$barcode'") || die "$DBI::errstr";
	if( $action->execute ){
		
		#record if it was a success
		my $test = $action->fetchrow_hasref();

		#disconnect
		$action->finish();
		$dbc->disconnect();
		
		#return true if success
		if( $test ){
			return 1;
		}
		else{
			return 0;
		}
	}
	else{
		die "$DBI::errst";
	}
}


sub validatePAPIBarcode{
	#this expects 2 paramaters, the webaddress of where the requests are made, including port eg: catalogue.nameoflibrary.ca:4500
	#second is the barcode to be tested
	
	#create and set up the variables:
	my $address;
	my $barcode;
	if( @_ >= 2 ){
		$address = @_[0};
		$barcode = @_[1];
	}
	else{
		#did not get the needed input values, die
		die "validatePAPIBarcode did not get needed input values";
	}

	#form the request and send it
	my $ua = LWP::UserAgent->new;
	my $request = HTTP::Request->new(GET => "http://$address/PATRONAPI/$barcode/dump");
	my $result = $ua->request($request);

	#if the request was successful test it and return as needed otherwise fail
	if( $result->is_success ){
		my $resultString = $result->as_string;
		my $test = $resultString =~ m/P BARCODE[pb]=$barcode/;
		return $test;		
	}
	else{
		die "Patron API request failed";
	}
	
}
1;
