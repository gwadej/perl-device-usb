#!perl -T

use lib "t";
use TestTools;
use Test::More tests => 11;
use Device::USB;
use strict;
use warnings;

my $usb = Device::USB->new();
ok( defined $usb, "Object successfully created" );

my $bus = ($usb->list_busses())[0];
ok( defined $bus, "Object successfully created" );
can_ok( $bus, "list_devices_if" );

eval { $bus->list_devices_if() };
like( $@, qr/Missing predicate/, "Requires a predicate." );

eval { $bus->list_devices_if( 1 ) };
like( $@, qr/Predicate must be/, "Requires a code reference." );

my $busses = $usb->list_busses();
ok( defined $busses, "USB busses found" );

my ($found_bus, $found_device) =
    TestTools::find_an_installed_device_and_bus( 0, @{$busses} );

SKIP:
{
    skip "No installed USB devices", 5 unless defined $found_device;

    my $vendor = $found_device->idVendor();
    my $product = $found_device->idProduct();

    my @devices = $found_bus->list_devices_if(
        sub { $_->idVendor() == $vendor && $_->idProduct() == $product }
    );
    my $device_count = @devices;

    ok( 0 < $device_count, "At least one device found" );
    my $matches = grep { $_->idVendor() == $vendor && $_->idProduct() == $product }
         @devices;
    is( $matches, $device_count, "All match the criteria" );

    my @vendor_devices = $found_bus->list_devices_if(
        sub { $_->idVendor() == $vendor }
    );
    my $vdevice_count = @vendor_devices;

    ok( $device_count <= $vdevice_count, "At least one device found" );
    $matches = grep { $_->idVendor() == $vendor } @devices;
    is( $matches, $vdevice_count, "All match the criteria" );

    my @all_devices = $found_bus->list_devices_if( sub { defined } );
    my $all_count = @all_devices;
    ok( $vdevice_count <= $all_count, "At least one device found" );
}

