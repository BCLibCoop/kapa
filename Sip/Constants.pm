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
# Sip::Constants.pm
#
# Various protocol constant values for 3M's Standard Interchange
# Protocol for communication between a library's Automated
# Checkout System (ACS) and stand-alone Self-Check (SC) units

package Sip::Constants;

use strict;
use warnings;
use Exporter;

our (@ISA, @EXPORT_OK, %EXPORT_TAGS);

@ISA = qw(Exporter);

@EXPORT_OK = qw(PATRON_STATUS_REQ CHECKOUT CHECKIN BLOCK_PATRON
		SC_STATUS REQUEST_ACS_RESEND LOGIN PATRON_INFO
		END_PATRON_SESSION FEE_PAID ITEM_INFORMATION
		ITEM_STATUS_UPDATE PATRON_ENABLE HOLD RENEW
		RENEW_ALL PATRON_STATUS_RESP CHECKOUT_RESP
		CHECKIN_RESP ACS_STATUS REQUEST_SC_RESEND
		LOGIN_RESP PATRON_INFO_RESP END_SESSION_RESP
		FEE_PAID_RESP ITEM_INFO_RESP
		ITEM_STATUS_UPDATE_RESP PATRON_ENABLE_RESP
		HOLD_RESP RENEW_RESP RENEW_ALL_RESP
		REQUEST_ACS_RESEND_CKSUM REQUEST_SC_RESEND_CKSUM
		FID_PATRON_ID FID_ITEM_ID FID_TERMINAL_PWD
		FID_PATRON_PWD FID_PERSONAL_NAME FID_SCREEN_MSG
		FID_PRINT_LINE FID_DUE_DATE FID_TITLE_ID
		FID_BLOCKED_CARD_MSG FID_LIBRARY_NAME
		FID_TERMINAL_LOCN FID_INST_ID FID_CURRENT_LOCN
		FID_PERM_LOCN FID_HOME_LIBRARY FID_HOLD_ITEMS
		FID_OVERDUE_ITEMS FID_CHARGED_ITEMS FID_FINE_ITEMS
		FID_SEQNO FID_CKSUM FID_HOME_ADDR FID_EMAIL
		FID_HOME_PHONE FID_OWNER FID_CURRENCY FID_CANCEL
		FID_TRANSACTION_ID FID_VALID_PATRON
		FID_RENEWED_ITEMS FID_UNRENEWED_ITEMS FID_FEE_ACK
		FID_START_ITEM FID_END_ITEM FID_QUEUE_POS
		FID_PICKUP_LOCN FID_FEE_TYPE FID_RECALL_ITEMS
		FID_FEE_AMT FID_EXPIRATION FID_SUPPORTED_MSGS
		FID_HOLD_TYPE FID_HOLD_ITEMS_LMT
		FID_OVERDUE_ITEMS_LMT FID_CHARGED_ITEMS_LMT
		FID_FEE_LMT FID_UNAVAILABLE_HOLD_ITEMS
		FID_HOLD_QUEUE_LEN FID_FEE_ID FID_ITEM_PROPS
		FID_SECURITY_INHIBIT FID_RECALL_DATE
		FID_MEDIA_TYPE FID_SORT_BIN FID_HOLD_PICKUP_DATE
		FID_LOGIN_UID FID_LOGIN_PWD FID_LOCATION_CODE
		FID_VALID_PATRON_PWD

		FID_PATRON_BIRTHDATE FID_PATRON_CLASS FID_INET_PROFILE

		SC_STATUS_OK SC_STATUS_PAPER SC_STATUS_SHUTDOWN
		SIP_DATETIME);

%EXPORT_TAGS = (

		SC_msgs => [qw(PATRON_STATUS_REQ CHECKOUT CHECKIN
			       BLOCK_PATRON SC_STATUS
			       REQUEST_ACS_RESEND LOGIN
			       PATRON_INFO
			       END_PATRON_SESSION FEE_PAID
			       ITEM_INFORMATION
			       ITEM_STATUS_UPDATE
			       PATRON_ENABLE HOLD RENEW
			       RENEW_ALL)],

		ACS_msgs => [qw(PATRON_STATUS_RESP CHECKOUT_RESP
				CHECKIN_RESP ACS_STATUS
				REQUEST_SC_RESEND LOGIN_RESP
				PATRON_INFO_RESP
				END_SESSION_RESP
				FEE_PAID_RESP ITEM_INFO_RESP
				ITEM_STATUS_UPDATE_RESP
				PATRON_ENABLE_RESP HOLD_RESP
				RENEW_RESP RENEW_ALL_RESP)],

		constant_msgs => [qw(REQUEST_ACS_RESEND_CKSUM
				     REQUEST_SC_RESEND_CKSUM)],

		field_ids => [qw( FID_PATRON_ID FID_ITEM_ID
				  FID_TERMINAL_PWD
				  FID_PATRON_PWD
				  FID_PERSONAL_NAME
				  FID_SCREEN_MSG
				  FID_PRINT_LINE FID_DUE_DATE
				  FID_TITLE_ID
				  FID_BLOCKED_CARD_MSG
				  FID_LIBRARY_NAME
				  FID_TERMINAL_LOCN
				  FID_INST_ID
				  FID_CURRENT_LOCN
				  FID_PERM_LOCN
				  FID_HOME_LIBRARY
				  FID_HOLD_ITEMS
				  FID_OVERDUE_ITEMS
				  FID_CHARGED_ITEMS
				  FID_FINE_ITEMS FID_SEQNO
				  FID_CKSUM FID_HOME_ADDR
				  FID_EMAIL FID_HOME_PHONE
				  FID_OWNER FID_CURRENCY
				  FID_CANCEL
				  FID_TRANSACTION_ID
				  FID_VALID_PATRON
				  FID_RENEWED_ITEMS
				  FID_UNRENEWED_ITEMS
				  FID_FEE_ACK FID_START_ITEM
				  FID_END_ITEM FID_QUEUE_POS
				  FID_PICKUP_LOCN
				  FID_FEE_TYPE
				  FID_RECALL_ITEMS
				  FID_FEE_AMT FID_EXPIRATION
				  FID_SUPPORTED_MSGS
				  FID_HOLD_TYPE
				  FID_HOLD_ITEMS_LMT
				  FID_OVERDUE_ITEMS_LMT
				  FID_CHARGED_ITEMS_LMT
				  FID_FEE_LMT
				  FID_UNAVAILABLE_HOLD_ITEMS
				  FID_HOLD_QUEUE_LEN
				  FID_FEE_ID FID_ITEM_PROPS
				  FID_SECURITY_INHIBIT
				  FID_RECALL_DATE
				  FID_MEDIA_TYPE FID_SORT_BIN
				  FID_HOLD_PICKUP_DATE
				  FID_LOGIN_UID FID_LOGIN_PWD
				  FID_LOCATION_CODE
				  FID_VALID_PATRON_PWD

				  FID_PATRON_BIRTHDATE
				  FID_PATRON_CLASS
				  FID_INET_PROFILE)],

		SC_status => [qw(SC_STATUS_OK SC_STATUS_PAPER
				 SC_STATUS_SHUTDOWN)],

		formats => [qw(SIP_DATETIME)],

		all => [qw(PATRON_STATUS_REQ CHECKOUT CHECKIN
			   BLOCK_PATRON SC_STATUS
			   REQUEST_ACS_RESEND LOGIN PATRON_INFO
			   END_PATRON_SESSION FEE_PAID
			   ITEM_INFORMATION ITEM_STATUS_UPDATE
			   PATRON_ENABLE HOLD RENEW RENEW_ALL
			   PATRON_STATUS_RESP CHECKOUT_RESP
			   CHECKIN_RESP ACS_STATUS
			   REQUEST_SC_RESEND LOGIN_RESP
			   PATRON_INFO_RESP END_SESSION_RESP
			   FEE_PAID_RESP ITEM_INFO_RESP
			   ITEM_STATUS_UPDATE_RESP
			   PATRON_ENABLE_RESP HOLD_RESP
			   RENEW_RESP RENEW_ALL_RESP
			   REQUEST_ACS_RESEND_CKSUM
			   REQUEST_SC_RESEND_CKSUM FID_PATRON_ID
			   FID_ITEM_ID FID_TERMINAL_PWD
			   FID_PATRON_PWD FID_PERSONAL_NAME
			   FID_SCREEN_MSG FID_PRINT_LINE
			   FID_DUE_DATE FID_TITLE_ID
			   FID_BLOCKED_CARD_MSG FID_LIBRARY_NAME
			   FID_TERMINAL_LOCN FID_INST_ID
			   FID_CURRENT_LOCN FID_PERM_LOCN FID_HOME_LIBRARY
			   FID_HOLD_ITEMS FID_OVERDUE_ITEMS
			   FID_CHARGED_ITEMS FID_FINE_ITEMS
			   FID_SEQNO FID_CKSUM FID_HOME_ADDR
			   FID_EMAIL FID_HOME_PHONE FID_OWNER
			   FID_CURRENCY FID_CANCEL
			   FID_TRANSACTION_ID FID_VALID_PATRON
			   FID_RENEWED_ITEMS FID_UNRENEWED_ITEMS
			   FID_FEE_ACK FID_START_ITEM
			   FID_END_ITEM FID_QUEUE_POS
			   FID_PICKUP_LOCN FID_FEE_TYPE
			   FID_RECALL_ITEMS FID_FEE_AMT
			   FID_EXPIRATION FID_SUPPORTED_MSGS
			   FID_HOLD_TYPE FID_HOLD_ITEMS_LMT
			   FID_OVERDUE_ITEMS_LMT
			   FID_CHARGED_ITEMS_LMT FID_FEE_LMT
			   FID_UNAVAILABLE_HOLD_ITEMS
			   FID_HOLD_QUEUE_LEN FID_FEE_ID
			   FID_ITEM_PROPS FID_SECURITY_INHIBIT
			   FID_RECALL_DATE FID_MEDIA_TYPE
			   FID_SORT_BIN FID_HOLD_PICKUP_DATE
			   FID_LOGIN_UID FID_LOGIN_PWD
			   FID_LOCATION_CODE FID_VALID_PATRON_PWD
			   FID_PATRON_BIRTHDATE FID_PATRON_CLASS
			   FID_INET_PROFILE
			   SC_STATUS_OK SC_STATUS_PAPER SC_STATUS_SHUTDOWN
			   SIP_DATETIME
			   )]);

#
# Declare message types
#

# Messages from SC to ACS
use constant {
    PATRON_STATUS_REQ  => '23',
    CHECKOUT           => '11',
    CHECKIN            => '09',
    BLOCK_PATRON       => '01',
    SC_STATUS          => '99',
    REQUEST_ACS_RESEND => '97',
    LOGIN              => '93',
    PATRON_INFO        => '63',
    END_PATRON_SESSION => '35',
    FEE_PAID           => '37',
    ITEM_INFORMATION   => '17',
    ITEM_STATUS_UPDATE => '19',
    PATRON_ENABLE      => '25',
    HOLD               => '15',
    RENEW              => '29',
    RENEW_ALL          => '65',
};

# Message responses from ACS to SC
use constant {
    PATRON_STATUS_RESP      => '24',
    CHECKOUT_RESP           => '12',
    CHECKIN_RESP            => '10',
    ACS_STATUS              => '98',
    REQUEST_SC_RESEND       => '96',
    LOGIN_RESP              => '94',
    PATRON_INFO_RESP        => '64',
    END_SESSION_RESP        => '36',
    FEE_PAID_RESP           => '38',
    ITEM_INFO_RESP          => '18',
    ITEM_STATUS_UPDATE_RESP => '20',
    PATRON_ENABLE_RESP      => '26',
    HOLD_RESP               => '16',
    RENEW_RESP              => '30',
    RENEW_ALL_RESP          => '66',
};

#
# Some messages are short and invariant, so they're constant's too
#
use constant {
    REQUEST_ACS_RESEND_CKSUM => '97AZFEF5',
    REQUEST_SC_RESEND_CKSUM  => '96AZFEF6',
};

#
# Field Identifiers
#
use constant {
    FID_PATRON_ID              => 'AA',
    FID_ITEM_ID                => 'AB',
    FID_TERMINAL_PWD           => 'AC',
    FID_PATRON_PWD             => 'AD',
    FID_PERSONAL_NAME          => 'AE',
    FID_SCREEN_MSG             => 'AF',
    FID_PRINT_LINE             => 'AG',
    FID_DUE_DATE               => 'AH',
    # UNUSED AI
    FID_TITLE_ID               => 'AJ',
    # UNUSED AK
    FID_BLOCKED_CARD_MSG       => 'AL',
    FID_LIBRARY_NAME           => 'AM',
    FID_TERMINAL_LOCN          => 'AN',
    FID_INST_ID                => 'AO',
    FID_CURRENT_LOCN           => 'AP',
    FID_PERM_LOCN              => 'AQ',
    FID_HOME_LIBRARY           => 'AQ', # Extension: AQ in patron info
    # UNUSED AR
    FID_HOLD_ITEMS             => 'AS', # SIP 2.0
    FID_OVERDUE_ITEMS          => 'AT', # SIP 2.0
    FID_CHARGED_ITEMS          => 'AU', # SIP 2.0
    FID_FINE_ITEMS             => 'AV', # SIP 2.0
    # UNUSED AW
    # UNUSED AX
    FID_SEQNO                  => 'AY',
    FID_CKSUM                  => 'AZ',

    # SIP 2.0 Fields
    # UNUSED BA
    # UNUSED BB
    # UNUSED BC
    FID_HOME_ADDR              => 'BD',
    FID_EMAIL                  => 'BE',
    FID_HOME_PHONE             => 'BF',
    FID_OWNER                  => 'BG',
    FID_CURRENCY               => 'BH',
    FID_CANCEL                 => 'BI',
    # UNUSED BJ
    FID_TRANSACTION_ID         => 'BK',
    FID_VALID_PATRON           => 'BL',
    FID_RENEWED_ITEMS          => 'BM',
    FID_UNRENEWED_ITEMS        => 'BN',
    FID_FEE_ACK                => 'BO',
    FID_START_ITEM             => 'BP',
    FID_END_ITEM               => 'BQ',
    FID_QUEUE_POS              => 'BR',
    FID_PICKUP_LOCN            => 'BS',
    FID_FEE_TYPE               => 'BT',
    FID_RECALL_ITEMS           => 'BU',
    FID_FEE_AMT                => 'BV',
    FID_EXPIRATION             => 'BW',
    FID_SUPPORTED_MSGS         => 'BX',
    FID_HOLD_TYPE              => 'BY',
    FID_HOLD_ITEMS_LMT         => 'BZ',
    FID_OVERDUE_ITEMS_LMT      => 'CA',
    FID_CHARGED_ITEMS_LMT      => 'CB',
    FID_FEE_LMT                => 'CC',
    FID_UNAVAILABLE_HOLD_ITEMS => 'CD',
    # UNUSED CE
    FID_HOLD_QUEUE_LEN         => 'CF',
    FID_FEE_ID                 => 'CG',
    FID_ITEM_PROPS             => 'CH',
    FID_SECURITY_INHIBIT       => 'CI',
    FID_RECALL_DATE            => 'CJ',
    FID_MEDIA_TYPE             => 'CK',
    FID_SORT_BIN               => 'CL',
    FID_HOLD_PICKUP_DATE       => 'CM',
    FID_LOGIN_UID              => 'CN',
    FID_LOGIN_PWD              => 'CO',
    FID_LOCATION_CODE          => 'CP',
    FID_VALID_PATRON_PWD       => 'CQ',

    # SIP Extensions used by Envisionware Terminals
    FID_PATRON_BIRTHDATE       => 'PB',
    FID_PATRON_CLASS           => 'PC',

    # SIP Extension for reporting patron internet privileges
    FID_INET_PROFILE           => 'PI',
};

#
# SC Status Codes
#
use constant {
    SC_STATUS_OK     => '0',
    SC_STATUS_PAPER  => '1',
    SC_STATUS_SHUTDOWN => '2',
};

#
# Various format strings
#
use constant {
    SIP_DATETIME => "%Y%m%d    %H%M%S",
};
