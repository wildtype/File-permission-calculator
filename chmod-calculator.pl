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
    qw{MainWindow cbOwnerRead cbOwnerWrite cbOwnerExe cbGroupRead 
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
    my $isOwnerRead = $w{cbOwnerRead}->get_active();
    my $isOwnerWrite = $w{cbOwnerWrite}->get_active();
    my $isOwnerExe = $w{cbOwnerExe}->get_active();
    my $isGroupWrite = $w{cbGroupWrite}->get_active();
    my $isGroupRead = $w{cbGroupRead}->get_active();
    my $isGroupExe = $w{cbGroupExe}->get_active();
    my $isOtherRead = $w{cbOtherRead}->get_active();
    my $isOtherWrite = $w{cbOtherWrite}->get_active();
    my $isOtherExe = $w{cbOtherExe}->get_active();
    my $umod = 4*$isOwnerRead + 2*$isOwnerWrite + 1*$isOwnerExe;
    my $gmod = 4*$isGroupRead + 2*$isGroupWrite + 1*$isGroupExe;
    my $omod = 4*$isOtherRead + 2*$isOtherWrite + 1*$isOtherExe;
    $w{tbOctal}->set_text($umod.$gmod.$omod);
}

sub on_tbOctal_changed
{
    my $octal = $w{tbOctal}->get_text();
    print "|".$octal."|";
    #proses cuma kalau nilainya 3digit oktal
    if ($octal =~ /^[0-7]{3}$/) {
        my @oct = split '',$octal;
        if ($oct[0] >= 4) {
            $w{cbOwnerRead}->set_active(1);
            $oct[0] -= 4;
        } else {
            $w{cbOwnerRead}->set_active(0);
        }
        if ($oct[0] >= 2) {
            $w{cbOwnerWrite}->set_active(1);
            $oct[0] -= 2;
        } else {
            $w{cbOwnerWrite}->set_active(0);
        }
        if ($oct[0] >= 1) {
            $w{cbOwnerExe}->set_active(1);
            $oct[0] -= 1;
        } else {
            $w{cbOwnerExe}->set_active(0);
        }
        if ($oct[1] >= 4) {
            $w{cbOtherRead}->set_active(1);
            $oct[1] -= 4;
        } else {
            $w{cbOtherRead}->set_active(0);
        }
        if ($oct[1] >= 2) {
            $w{cbOtherWrite}->set_active(1);
            $oct[1] -= 2;
        } else {
            $w{cbOtherWrite}->set_active(0);
        }
        if ($oct[1] >= 1) {
            $w{cbOtherExe}->set_active(1);
            $oct[1] -= 1;
        } else {
            $w{cbOtherExe}->set_active(0);
        }
        if ($oct[2] >= 4) {
            $w{cbGroupRead}->set_active(1);
            $oct[2] -= 4;
        } else {
            $w{cbGroupRead}->set_active(0);
        }
        if ($oct[2] >= 2) {
            $w{cbGroupWrite}->set_active(1);
            $oct[2] -= 2;
        } else {
            $w{cbGroupWrite}->set_active(0);
        }
        if ($oct[2] >= 1) {
            $w{cbGroupExe}->set_active(1);
            $oct[2] -= 1;
        } else {
            $w{cbGroupExe}->set_active(0);
        }
    }
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
