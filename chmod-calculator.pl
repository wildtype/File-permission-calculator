#!/usr/bin/env perl

use strict;
use warnings;
use Gtk3 '-init';

my $builder = Gtk3::Builder->new();
$builder->add_from_file("interface.ui");
$builder->connect_signals(undef);

# w = Widgets
# get all widgets from gtkbuilder
my %w = get_objects (
    $builder, 
    qw{MainWindow cbUserRead cbUserWrite cbUserExe cbGroupRead 
    cbGroupWrite cbGroupExe cbOtherRead cbOtherWrite cbOtherExe 
    tbOctal}
);
$w{MainWindow}->show_all();

Gtk3->main();

sub on_MainWindow_delete_event
{
    Gtk3::main_quit();
}

sub on_cbs_toggled
{
    my $isUserRead = $w{cbUserRead}->get_active();
    my $isUserWrite = $w{cbUserWrite}->get_active();
    my $isUserExe = $w{cbUserExe}->get_active();
    my $isGroupWrite = $w{cbGroupWrite}->get_active();
    my $isGroupRead = $w{cbGroupRead}->get_active();
    my $isGroupExe = $w{cbGroupExe}->get_active();
    my $isOtherRead = $w{cbOtherRead}->get_active();
    my $isOtherWrite = $w{cbOtherWrite}->get_active();
    my $isOtherExe = $w{cbOtherExe}->get_active();
    my $umod = 4*$isUserRead + 2*$isUserWrite + 1*$isUserExe;
    my $gmod = 4*$isGroupRead + 2*$isGroupWrite + 1*$isGroupExe;
    my $omod = 4*$isOtherRead + 2*$isOtherWrite + 1*$isOtherExe;
    $w{tbOctal}->set_text($umod.$gmod.$omod);
}

# ambil semua objek dari gtkbuilder/glade
# pengganti Gtk::Builder->get_object untuk tiap2 object
# panggil sekali, dapat semua, macam itulah
# return hash dengan key berupa nama object
sub get_objects
{
    my $builder = shift;
    my %objects;
    foreach my $object_name (@_) {
        my $object = $builder->get_object($object_name);
        $objects{$object_name} = $object;
    }
    return %objects;
}
